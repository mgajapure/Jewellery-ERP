import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/girvi.dart';
import '../../domain/repositories/girvi_repository.dart';
import '../models/girvi_model.dart';

@LazySingleton(as: GirviRepository)
class GirviRepositoryImpl implements GirviRepository {
  GirviRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<List<Girvi>>> getGirviList({
    GirviStatus? statusFilter,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (statusFilter != null) queryParams['status'] = statusFilter.name;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      final response = await _apiClient.get(
        ApiEndpoints.girvi,
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map(
            (e) =>
                GirviModel.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Girvi>> getGirviById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.girviById(id));
      final data = response.data as Map<String, dynamic>;
      final girvi = GirviModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(girvi);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Girvi>>> getDueGirvi() async {
    // No dedicated "due" endpoint in the real backend; use overdue list.
    return getOverdueGirvi();
  }

  @override
  Future<Result<List<Girvi>>> getOverdueGirvi() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.girviOverdue);
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map(
            (e) =>
                GirviModel.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> makePayment(
    String girviId,
    PaymentRequest request,
  ) async {
    try {
      // Map legacy paymentType to the split principal/interest/penalty model.
      final isPrincipal = request.paymentType == PaymentType.principal;
      final isInterest = request.paymentType == PaymentType.interest;
      await _apiClient.post(
        ApiEndpoints.girviPayment(girviId),
        data: {
          'principalPaid': isPrincipal ? request.amount : 0.0,
          'interestPaid': isInterest ? request.amount : 0.0,
          'penaltyPaid': 0.0,
          'paymentMode':
              request.referenceNumber != null ? 'NEFT' : 'CASH',
          if (request.notes != null) 'notes': request.notes,
        },
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Girvi>> renewGirvi(
    String girviId,
    RenewalRequest request,
  ) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.girviRenew(girviId),
        data: {
          'newLoanAmount': request.newLoanAmount,
          'interestRate': request.interestRate,
          'months': request.months,
          'interestType': request.interestType.name,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final girvi = GirviModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(girvi);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> redeemGirvi(String girviId) async {
    try {
      await _apiClient.patch(ApiEndpoints.girviRedeem(girviId));
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> completeAuction(
    String girviId,
    AuctionRequest request,
  ) async {
    // Auction is not supported by the real backend API.
    return const Result.failure(
      ServerException(message: 'Auction endpoint is not available.'),
    );
  }

  @override
  Future<Result<Girvi>> createGirvi(CreateGirviRequest request) async {
    try {
      // Calculate tenureMonths from startDate/dueDate (real API requires tenureMonths).
      final tenureMonths =
          ((request.dueDate.difference(request.startDate).inDays) / 30)
              .round()
              .clamp(1, 12);
      final response = await _apiClient.post(
        ApiEndpoints.girvi,
        data: {
          'customerId': request.customerId,
          'interestRate': request.interestRate,
          'interestType': request.interestType.name.toUpperCase(),
          'tenureMonths': tenureMonths,
          'items': request.items
              .map((item) => {
                    'itemName': item.itemType,
                    'description': item.description,
                    'metalType': item.metalType.name.toUpperCase(),
                    'purity': item.purity,
                    'grossWeight': item.grossWeightG,
                    'netWeight': item.netWeightG,
                    'stoneWeight': item.stoneWeightG,
                    'photoUrls': item.photoPaths,
                  })
              .toList(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      final girvi = GirviModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(girvi);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  AppException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return const AuthException(
            message: 'Session expired. Please login again.',
          );
        }
        if (statusCode == 404) return const NotFoundException();
        return ServerException(
          message:
              error.response?.statusMessage ?? 'Server error occurred.',
        );
      default:
        return ServerException(message: error.message ?? 'Unknown error');
    }
  }
}
