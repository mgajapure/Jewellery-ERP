import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../models/inventory_item_model.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  const InventoryRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Result<List<InventoryItem>>> getItems({
    String? filter,
    String? query,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.inventory,
        queryParameters: {
          if (filter != null && filter.isNotEmpty) 'filter': filter,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );
      final list = _dataList(response.data);
      return Result.success(list.map(InventoryItemModel.fromJson).toList());
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<InventoryItem>> getItemById(String id) async {
    try {
      final response = await apiClient.get(ApiEndpoints.inventoryById(id));
      final data = _dataMap(response.data);
      return Result.success(InventoryItemModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<InventoryItem>> getItemByBarcode(String barcode) async {
    try {
      final response =
          await apiClient.get(ApiEndpoints.inventoryBySku(barcode));
      if (response.data['success'] == false) {
        return const Result.failure(NotFoundException());
      }
      final data = _dataMap(response.data);
      return Result.success(InventoryItemModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<InventoryItem>> updateStatus(
      String id, InventoryStatus status) async {
    try {
      final response = await apiClient.patch(
        ApiEndpoints.inventoryById(id),
        data: {'status': status.name.toUpperCase()},
      );
      final data = _dataMap(response.data);
      return Result.success(InventoryItemModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<InventoryItem>> createItem(
      Map<String, dynamic> payload) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.inventory,
        data: payload,
      );
      final data = _dataMap(response.data);
      return Result.success(InventoryItemModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  List<Map<String, dynamic>> _dataList(dynamic body) =>
      ((body as Map<String, dynamic>)['data'] as List)
          .cast<Map<String, dynamic>>();

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
