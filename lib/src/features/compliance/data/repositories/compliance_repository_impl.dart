import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
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
      // No dedicated compliance dashboard in the real backend.
      // Use the dashboard summary to populate compliance stats.
      final response = await apiClient.get(ApiEndpoints.dashboardSummary);
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
      // Real backend: GET /compliance/form9?customerId=...
      // 'from' is reused as the customerId param until the domain interface is updated.
      final response = await apiClient.get(
        ApiEndpoints.complianceForm9,
        queryParameters: {
          if (from != null) 'customerId': from,
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
      // Map formType string to the corresponding real endpoint.
      final endpoint = _formEndpoint(formType);
      await apiClient.get(endpoint);
      return const Result.success(true);
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  String _formEndpoint(String formType) {
    switch (formType.toLowerCase()) {
      case 'form6':
        return ApiEndpoints.complianceForm6;
      case 'form9':
        return ApiEndpoints.complianceForm9;
      case 'form11':
        return ApiEndpoints.complianceForm11;
      case 'form12':
        return ApiEndpoints.complianceForm12;
      case 'form13':
        return ApiEndpoints.complianceForm13;
      default:
        return ApiEndpoints.complianceForm6;
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
