import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/savings_entities.dart';
import '../../domain/repositories/savings_repository.dart';
import '../models/savings_models.dart';

@LazySingleton(as: SavingsRepository)
class SavingsRepositoryImpl implements SavingsRepository {
  const SavingsRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Result<SavingsDashboardStats>> getDashboardStats() async {
    try {
      // No dedicated savings dashboard in the real backend; use general dashboard.
      final response =
          await apiClient.get(ApiEndpoints.dashboardSummary);
      final data = _dataMap(response.data);
      return Result.success(SavingsDashboardStatsModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  Map<String, dynamic> _dataMap(dynamic body) =>
      ((body as Map<String, dynamic>)['data'] as Map<String, dynamic>);

  AppException _mapDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }
    final msg =
        (e.response?.data as Map<String, dynamic>?)?['message'] as String? ??
            e.message ??
            'Something went wrong.';
    return ServerException(message: msg);
  }
}
