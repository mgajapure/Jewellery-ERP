import '../../domain/entities/sales_dashboard_stats.dart';

class SalesDashboardStatsModel extends SalesDashboardStats {
  const SalesDashboardStatsModel({
    required super.todaySales,
    required super.todayRevenue,
    required super.monthlyRevenue,
    required super.avgInvoice,
    required super.topCategory,
    required super.pendingReturns,
  });

  factory SalesDashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      SalesDashboardStatsModel(
        todaySales: (json['todaySales'] as num).toInt(),
        todayRevenue: (json['todayRevenue'] as num).toDouble(),
        monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
        avgInvoice: (json['avgInvoice'] as num).toDouble(),
        topCategory: json['topCategory'] as String,
        pendingReturns: (json['pendingReturns'] as num).toInt(),
      );
}
