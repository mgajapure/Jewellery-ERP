import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/vault_search_result.dart';
import '../../domain/entities/vault_slot.dart';
import '../../domain/repositories/vault_repository.dart';
import '../models/vault_search_result_model.dart';
import '../models/vault_slot_model.dart';

@LazySingleton(as: VaultRepository)
class VaultRepositoryImpl implements VaultRepository {
  VaultRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<List<VaultOccupancy>>> getOccupancy() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vaults);
      final list = _dataList(response.data);
      return Result.success(
        list
            .map((e) => VaultOccupancyModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<VaultSearchResult>>> searchVault({
    required String query,
    required String searchMode,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.vaultSearch,
        queryParameters: {'q': query, 'mode': searchMode.toLowerCase()},
      );
      final list = _dataList(response.data);
      return Result.success(
        list
            .map((e) =>
                VaultSearchResultModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getVaults() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vaultList);
      final list = _dataList(response.data);
      return Result.success(list.cast<String>());
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getSafes(String vault) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vaultSafes(vault));
      final list = _dataList(response.data);
      return Result.success(list.cast<String>());
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getTrays(String vault, String safe) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.vaultTrays(vault, safe));
      final list = _dataList(response.data);
      return Result.success(list.cast<String>());
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<VaultSlot>>> getSlots(
    String vault,
    String safe,
    String tray,
  ) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.vaultSlots(vault, safe, tray));
      final list = _dataList(response.data);
      return Result.success(
        list
            .map((e) => VaultSlotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> assignSlot({required String coordinate}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.vaultAssign,
        data: {'coordinate': coordinate},
      );
      final data =
          (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return Result.success(data['coordinate'] as String);
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  List<dynamic> _dataList(dynamic body) {
    return (body as Map<String, dynamic>)['data'] as List<dynamic>;
  }

  AppException _mapDio(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
    return ServerException(
      message: e.response?.statusMessage ?? 'Server error',
    );
  }
}
