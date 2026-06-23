import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_summary_model.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<DashboardSummary>> getDashboardSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboardSummary);
      final data = response.data as Map<String, dynamic>;
      final summary = DashboardSummaryModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(summary);
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
        return ServerException(
          message: error.response?.statusMessage ?? 'Server error occurred.',
        );
      default:
        return ServerException(message: error.message ?? 'Unknown error');
    }
  }
}
