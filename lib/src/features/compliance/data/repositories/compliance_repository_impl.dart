import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/compliance_entities.dart';
import '../../domain/repositories/compliance_repository.dart';
import '../models/compliance_models.dart';

@LazySingleton(as: ComplianceRepository)
class ComplianceRepositoryImpl implements ComplianceRepository {
  const ComplianceRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Result<ComplianceDashboardStats>> getDashboardStats() async {
    try {
      final response = await apiClient.get('/compliance/dashboard');
      final data = _dataMap(response.data);
      return Result.success(ComplianceDashboardStatsModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<Form9Register>> getForm9Register({
    String? from,
    String? to,
  }) async {
    try {
      final response = await apiClient.get(
        '/compliance/form9',
        queryParameters: {
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );
      final data = _dataMap(response.data);
      return Result.success(Form9RegisterModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<bool>> generateForm(String formType) async {
    try {
      await apiClient.post('/compliance/generate', data: {'form': formType});
      return const Result.success(true);
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
    final msg = (e.response?.data as Map<String, dynamic>?)?['message']
            as String? ??
        e.message ??
        'Something went wrong.';
    return ServerException(message: msg);
  }
}
