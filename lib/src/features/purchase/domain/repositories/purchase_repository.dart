import '../../../../core/errors/result.dart';
import '../entities/purchase_dashboard_stats.dart';
import '../entities/purchase_entry.dart';
import '../entities/supplier.dart';

abstract class PurchaseRepository {
  Future<Result<PurchaseDashboardStats>> getDashboardStats();

  Future<Result<List<PurchaseEntry>>> getLedger({
    String? filter,
    String? query,
  });

  Future<Result<PurchaseEntry>> getDetails(String purchaseId);

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
  });

  Future<Result<List<Supplier>>> getSuppliers({
    String? filter,
    String? query,
  });
}
