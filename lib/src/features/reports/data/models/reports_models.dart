import '../../domain/entities/reports_entities.dart';

class ReportCategoryItemModel extends ReportCategoryItem {
  const ReportCategoryItemModel({
    required super.labelMr,
    required super.labelEn,
    required super.amount,
    required super.percentage,
    required super.colorHex,
  });

  factory ReportCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return ReportCategoryItemModel(
      labelMr: json['labelMr'] as String,
      labelEn: json['labelEn'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      colorHex: json['color'] as int,
    );
  }
}

class SalesReportSummaryModel extends SalesReportSummary {
  const SalesReportSummaryModel({
    required super.totalRevenue,
    required super.totalOrders,
    required super.avgOrderValue,
    required super.growthPercent,
    required super.categories,
  });

  factory SalesReportSummaryModel.fromJson(Map<String, dynamic> json) {
    final cats = (json['categories'] as List<dynamic>? ?? [])
        .map((c) =>
            ReportCategoryItemModel.fromJson(c as Map<String, dynamic>))
        .toList();
    return SalesReportSummaryModel(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalOrders: json['totalOrders'] as int,
      avgOrderValue: (json['avgOrderValue'] as num).toDouble(),
      growthPercent: (json['growthPercent'] as num).toDouble(),
      categories: cats,
    );
  }
}

class GirviReportSummaryModel extends GirviReportSummary {
  const GirviReportSummaryModel({
    required super.totalDisbursed,
    required super.totalRepaid,
    required super.activeLoans,
    required super.overdueLoans,
    required super.interestCollected,
    required super.avgLoanAmount,
  });

  factory GirviReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return GirviReportSummaryModel(
      totalDisbursed: (json['totalDisbursed'] as num).toDouble(),
      totalRepaid: (json['totalRepaid'] as num).toDouble(),
      activeLoans: json['activeLoans'] as int,
      overdueLoans: json['overdueLoans'] as int,
      interestCollected: (json['interestCollected'] as num).toDouble(),
      avgLoanAmount: (json['avgLoanAmount'] as num).toDouble(),
    );
  }
}

class PurchaseReportSummaryModel extends PurchaseReportSummary {
  const PurchaseReportSummaryModel({
    required super.totalPurchased,
    required super.totalWeight,
    required super.avgRate,
    required super.uniqueSuppliers,
  });

  factory PurchaseReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReportSummaryModel(
      totalPurchased: (json['totalPurchased'] as num).toDouble(),
      totalWeight: (json['totalWeight'] as num).toDouble(),
      avgRate: (json['avgRate'] as num).toDouble(),
      uniqueSuppliers: json['uniqueSuppliers'] as int,
    );
  }
}

class ReportsDashboardDataModel extends ReportsDashboardData {
  const ReportsDashboardDataModel({
    required super.period,
    required super.sales,
    required super.girvi,
    required super.purchase,
  });

  factory ReportsDashboardDataModel.fromJson(Map<String, dynamic> json) {
    return ReportsDashboardDataModel(
      period: json['period'] as String,
      sales: SalesReportSummaryModel.fromJson(
          json['sales'] as Map<String, dynamic>),
      girvi: GirviReportSummaryModel.fromJson(
          json['girvi'] as Map<String, dynamic>),
      purchase: PurchaseReportSummaryModel.fromJson(
          json['purchase'] as Map<String, dynamic>),
    );
  }
}
