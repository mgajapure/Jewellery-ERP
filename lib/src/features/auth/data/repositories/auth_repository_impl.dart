import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_session_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  static const _kAccessToken = 'auth.accessToken';
  static const _kRefreshToken = 'auth.refreshToken';
  static const _kStaffId = 'auth.staffId';
  static const _kTenantId = 'auth.tenantId';
  static const _kStaffName = 'auth.staffName';
  static const _kRole = 'auth.role';
  static const _kExpiresAt = 'auth.expiresAt';
  static const _kDeviceId = 'auth.deviceId';

  Future<String> _getDeviceId() async {
    final stored = await _secureStorage.read(_kDeviceId);
    if (stored != null) return stored;
    final generated =
        'dev-${DateTime.now().millisecondsSinceEpoch}-${Object().hashCode.abs()}';
    await _secureStorage.write(_kDeviceId, generated);
    return generated;
  }

  @override
  Future<Result<String>> requestOtp(String mobile) async {
    try {
      final tenantId = await _secureStorage.read(_kTenantId) ?? '';
      final deviceId = await _getDeviceId();
      await _apiClient.post(
        ApiEndpoints.sendOtp,
        data: {
          'mobile': mobile,
          'tenantId': tenantId,
          'deviceFingerprint': deviceId,
          'deviceName': 'Jewellery ERP App',
          'platform': 'android',
        },
      );
      // Real backend returns a success message, not a requestId.
      // Return mobile as the identifier so OtpBloc can display masking.
      return Result.success(mobile);
    } on DioException catch (e) {
      return Result.failure(_mapError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthSession>> verifyOtp({
    required String requestId,
    required String otp,
    required String mobile,
  }) async {
    try {
      final tenantId = await _secureStorage.read(_kTenantId) ?? '';
      final deviceId = await _getDeviceId();
      final response = await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {
          'mobile': mobile,
          'tenantId': tenantId,
          'otp': otp,
          'deviceFingerprint': deviceId,
        },
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;

      // Real backend: deviceStatus PENDING means awaiting admin approval.
      if (data['deviceStatus'] == 'PENDING') {
        return Result.failure(
          const AuthException(message: '__registration_pending__'),
        );
      }

      // Legacy mock fallback: success=false with pending=true flag.
      if (body['success'] == false) {
        if (body['pending'] == true) {
          return Result.failure(
            const AuthException(message: '__registration_pending__'),
          );
        }
        return Result.failure(
          ServerException(
            message: body['message'] as String? ?? 'OTP पडताळणी अयशस्वी.',
          ),
        );
      }

      final session = AuthSessionModel.fromJson(data).toEntity();
      await _saveSession(session);
      return Result.success(session);
    } on DioException catch (e) {
      return Result.failure(_mapError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthSession>> refreshSession() async {
    try {
      final stored = await getStoredSession();
      if (stored == null) {
        return Result.failure(const AuthException(message: 'No session found.'));
      }
      final response = await _apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': stored.refreshToken},
      );
      final data =
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      // Real backend only returns new tokens; user info is preserved from storage.
      final session = AuthSession(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        staffId: stored.staffId,
        tenantId: stored.tenantId,
        staffName: stored.staffName,
        role: stored.role,
        expiresAt: data['expiresAt'] != null
            ? DateTime.parse(data['expiresAt'] as String)
            : DateTime.now().add(const Duration(hours: 24)),
      );
      await _saveSession(session);
      return Result.success(session);
    } on DioException catch (e) {
      return Result.failure(_mapError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (_) {
      // Always clear local storage even if network call fails.
    }
    await _secureStorage.deleteAll();
    return const Result.success(null);
  }

  @override
  Future<AuthSession?> getStoredSession() async {
    final token = await _secureStorage.read(_kAccessToken);
    if (token == null) return null;
    final expiresAtStr = await _secureStorage.read(_kExpiresAt);
    if (expiresAtStr == null) return null;
    return AuthSession(
      accessToken: token,
      refreshToken: await _secureStorage.read(_kRefreshToken) ?? '',
      staffId: await _secureStorage.read(_kStaffId) ?? '',
      tenantId: await _secureStorage.read(_kTenantId) ?? '',
      staffName: await _secureStorage.read(_kStaffName) ?? '',
      role: _parseRole(await _secureStorage.read(_kRole) ?? 'STAFF'),
      expiresAt: DateTime.parse(expiresAtStr),
    );
  }

  Future<void> _saveSession(AuthSession session) async {
    await _secureStorage.write(_kAccessToken, session.accessToken);
    await _secureStorage.write(_kRefreshToken, session.refreshToken);
    await _secureStorage.write(_kStaffId, session.staffId);
    await _secureStorage.write(_kTenantId, session.tenantId);
    await _secureStorage.write(_kStaffName, session.staffName);
    await _secureStorage.write(_kRole, session.role.name.toUpperCase());
    await _secureStorage.write(
        _kExpiresAt, session.expiresAt.toIso8601String());
  }

  static StaffRole _parseRole(String raw) {
    switch (raw.toUpperCase()) {
      case 'OWNER':
        return StaffRole.owner;
      case 'MANAGER':
        return StaffRole.manager;
      case 'VIEWER':
        return StaffRole.viewer;
      default:
        return StaffRole.staff;
    }
  }

  AppException _mapError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401) {
          return const AuthException(message: 'सत्र संपले. पुन्हा लॉगिन करा.');
        }
        if (code == 422) {
          return ServerException(
            message: (error.response?.data as Map?)?['message'] as String? ??
                'चुकीचा OTP.',
          );
        }
        return ServerException(
          message: error.response?.statusMessage ?? 'Server error occurred.',
        );
      default:
        return ServerException(message: error.message ?? 'Unknown error');
    }
  }
}
