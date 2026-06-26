import '../../../../core/errors/result.dart';
import '../entities/sale_order.dart';
import '../entities/sales_dashboard_stats.dart';

abstract class SalesRepository {
  Future<Result<SalesDashboardStats>> getDashboardStats();

  Future<Result<List<SaleOrder>>> getLedger({
    String? filter,
    String? query,
  });

  Future<Result<SaleOrder>> getDetails(String invoiceNo);

  Future<Result<SaleOrder>> createSale({
    required String customerId,
    required String customerName,
    required String customerMobile,
    required List<String> itemIds,
    required double discount,
    required SalePaymentMode paymentMode,
  });

  Future<Result<bool>> processReturn({
    required String invoiceNo,
    required List<String> itemIds,
    required String reason,
    required String returnType,
    required String inventoryStatus,
  });

  Future<Result<SaleOrder>> lookupInvoice(String invoiceNo);

  Future<Result<SaleItem>> getCartItem(String barcode);
}
