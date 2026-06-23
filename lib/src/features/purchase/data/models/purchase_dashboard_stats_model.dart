import '../../domain/entities/purchase_dashboard_stats.dart';

class PurchaseDashboardStatsModel extends PurchaseDashboardStats {
  const PurchaseDashboardStatsModel({
    required super.todayPurchases,
    required super.todayValue,
    required super.pendingApprovals,
    required super.totalSuppliers,
    required super.scrapPurchases,
    required super.inventoryAdded,
  });

  factory PurchaseDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return PurchaseDashboardStatsModel(
      todayPurchases: (json['todayPurchases'] as num).toInt(),
      todayValue: (json['todayValue'] as num).toDouble(),
      pendingApprovals: (json['pendingApprovals'] as num).toInt(),
      totalSuppliers: (json['totalSuppliers'] as num).toInt(),
      scrapPurchases: (json['scrapPurchases'] as num).toInt(),
      inventoryAdded: (json['inventoryAdded'] as num).toInt(),
    );
  }
}
