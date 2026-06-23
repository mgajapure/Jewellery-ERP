import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/interest_ledger.dart';
import '../../domain/repositories/interest_repository.dart';
import '../models/interest_ledger_model.dart';

@LazySingleton(as: InterestRepository)
class InterestRepositoryImpl implements InterestRepository {
  InterestRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<InterestLedger>> getLedger(String girviId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.interestLedger(girviId));
      final data = (response.data as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      return Result.success(InterestLedgerModel.fromJson(data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Result.failure(NetworkException());
      }
      return Result.failure(
        ServerException(message: e.response?.statusMessage ?? 'Server error'),
      );
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }
}
