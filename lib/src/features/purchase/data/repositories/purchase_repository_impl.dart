import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/purchase_dashboard_stats.dart';
import '../../domain/entities/purchase_entry.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../models/purchase_dashboard_stats_model.dart';
import '../models/purchase_entry_model.dart';
import '../models/supplier_model.dart';

@LazySingleton(as: PurchaseRepository)
class PurchaseRepositoryImpl implements PurchaseRepository {
  PurchaseRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<PurchaseDashboardStats>> getDashboardStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.purchaseDashboard);
      final data = _dataMap(response.data);
      return Result.success(PurchaseDashboardStatsModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PurchaseEntry>>> getLedger({
    String? filter,
    String? query,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.purchaseLedger,
        queryParameters: {
          if (filter != null && filter.isNotEmpty) 'filter': filter,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );
      final list = _dataList(response.data);
      return Result.success(
        list
            .map((e) => PurchaseEntryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<PurchaseEntry>> getDetails(String purchaseId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.purchaseById(purchaseId));
      final data = _dataMap(response.data);
      return Result.success(PurchaseEntryModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<PurchaseEntry>> createPurchase({
    required String supplierName,
    required String supplierMobile,
    required String billNo,
    required PurchaseType purchaseType,
    required MetalType metalType,
    required String itemName,
    required double grossWeight,
    required double netWeight,
    required double purity,
    required double rate,
    required double amount,
    required PaymentMode paymentMode,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.purchases,
        data: {
          'supplierName': supplierName,
          'supplierMobile': supplierMobile,
          'billNo': billNo,
          'purchaseType': purchaseType.name.toUpperCase(),
          'metalType': metalType.name.toUpperCase(),
          'itemName': itemName,
          'grossWeight': grossWeight,
          'netWeight': netWeight,
          'purity': purity,
          'rate': rate,
          'amount': amount,
          'paymentMode': paymentMode.name.toUpperCase(),
        },
      );
      final data = _dataMap(response.data);
      return Result.success(PurchaseEntryModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Supplier>>> getSuppliers({
    String? filter,
    String? query,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.suppliers,
        queryParameters: {
          if (filter != null && filter.isNotEmpty) 'filter': filter,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );
      final list = _dataList(response.data);
      return Result.success(
        list
            .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  List<dynamic> _dataList(dynamic body) {
    return (body as Map<String, dynamic>)['data'] as List<dynamic>;
  }

  Map<String, dynamic> _dataMap(dynamic body) {
    return (body as Map<String, dynamic>)['data'] as Map<String, dynamic>;
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
