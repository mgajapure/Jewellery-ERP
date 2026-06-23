class ReportCategoryItem {
  const ReportCategoryItem({
    required this.labelMr,
    required this.labelEn,
    required this.amount,
    required this.percentage,
    required this.colorHex,
  });

  final String labelMr;
  final String labelEn;
  final double amount;
  final double percentage;
  final int colorHex;
}

class SalesReportSummary {
  const SalesReportSummary({
    required this.totalRevenue,
    required this.totalOrders,
    required this.avgOrderValue,
    required this.growthPercent,
    required this.categories,
  });

  final double totalRevenue;
  final int totalOrders;
  final double avgOrderValue;
  final double growthPercent;
  final List<ReportCategoryItem> categories;
}

class GirviReportSummary {
  const GirviReportSummary({
    required this.totalDisbursed,
    required this.totalRepaid,
    required this.activeLoans,
    required this.overdueLoans,
    required this.interestCollected,
    required this.avgLoanAmount,
  });

  final double totalDisbursed;
  final double totalRepaid;
  final int activeLoans;
  final int overdueLoans;
  final double interestCollected;
  final double avgLoanAmount;
}

class PurchaseReportSummary {
  const PurchaseReportSummary({
    required this.totalPurchased,
    required this.totalWeight,
    required this.avgRate,
    required this.uniqueSuppliers,
  });

  final double totalPurchased;
  final double totalWeight;
  final double avgRate;
  final int uniqueSuppliers;
}

class ReportsDashboardData {
  const ReportsDashboardData({
    required this.period,
    required this.sales,
    required this.girvi,
    required this.purchase,
  });

  final String period;
  final SalesReportSummary sales;
  final GirviReportSummary girvi;
  final PurchaseReportSummary purchase;
}
