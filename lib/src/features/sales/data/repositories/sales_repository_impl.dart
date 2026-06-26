import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/sale_order.dart';
import '../../domain/entities/sales_dashboard_stats.dart';
import '../../domain/repositories/sales_repository.dart';
import '../models/sale_order_model.dart';
import '../models/sales_dashboard_stats_model.dart';

@LazySingleton(as: SalesRepository)
class SalesRepositoryImpl implements SalesRepository {
  const SalesRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Result<SalesDashboardStats>> getDashboardStats() async {
    try {
      final response = await apiClient.get(ApiEndpoints.salesDashboard);
      final data = _dataMap(response.data);
      return Result.success(SalesDashboardStatsModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<List<SaleOrder>>> getLedger({
    String? filter,
    String? query,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.salesLedger,
        queryParameters: {
          if (filter != null && filter.isNotEmpty) 'filter': filter,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );
      final list = _dataList(response.data);
      return Result.success(
        list.map((e) => SaleOrderModel.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<SaleOrder>> getDetails(String invoiceNo) async {
    try {
      final response =
          await apiClient.get(ApiEndpoints.saleById(invoiceNo));
      final data = _dataMap(response.data);
      return Result.success(SaleOrderModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<SaleOrder>> createSale({
    required String customerId,
    required String customerName,
    required String customerMobile,
    required List<String> itemIds,
    required double discount,
    required SalePaymentMode paymentMode,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.sales,
        data: {
          'customerId': customerId,
          'customerName': customerName,
          'customerMobile': customerMobile,
          'itemIds': itemIds,
          'discount': discount,
          'paymentMode': _encodePaymentMode(paymentMode),
        },
      );
      final data = _dataMap(response.data);
      return Result.success(SaleOrderModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<bool>> processReturn({
    required String invoiceNo,
    required List<String> itemIds,
    required String reason,
    required String returnType,
    required String inventoryStatus,
  }) async {
    try {
      await apiClient.post(
        ApiEndpoints.salesReturn,
        data: {
          'invoiceNo': invoiceNo,
          'itemIds': itemIds,
          'reason': reason,
          'returnType': returnType,
          'inventoryStatus': inventoryStatus,
        },
      );
      return const Result.success(true);
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<SaleOrder>> lookupInvoice(String invoiceNo) async {
    try {
      final response =
          await apiClient.get(ApiEndpoints.saleById(invoiceNo));
      final data = _dataMap(response.data);
      return Result.success(SaleOrderModel.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(_mapDio(e));
    }
  }

  @override
  Future<Result<SaleItem>> getCartItem(String barcode) async {
    try {
      final response =
          await apiClient.get(ApiEndpoints.inventoryItemByBarcode(barcode));
      final data = _dataMap(response.data);
      return Result.success(SaleItemModel.fromJson(data));
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

  String _encodePaymentMode(SalePaymentMode mode) {
    switch (mode) {
      case SalePaymentMode.upi:
        return 'UPI';
      case SalePaymentMode.bankTransfer:
        return 'BANK_TRANSFER';
      case SalePaymentMode.card:
        return 'CARD';
      case SalePaymentMode.splitPayment:
        return 'SPLIT_PAYMENT';
      case SalePaymentMode.cash:
        return 'CASH';
    }
  }
}
