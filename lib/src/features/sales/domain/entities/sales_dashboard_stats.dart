import 'package:equatable/equatable.dart';

class SalesDashboardStats extends Equatable {
  const SalesDashboardStats({
    required this.todaySales,
    required this.todayRevenue,
    required this.monthlyRevenue,
    required this.avgInvoice,
    required this.topCategory,
    required this.pendingReturns,
  });

  final int todaySales;
  final double todayRevenue;
  final double monthlyRevenue;
  final double avgInvoice;
  final String topCategory;
  final int pendingReturns;

  @override
  List<Object?> get props => [
        todaySales,
        todayRevenue,
        monthlyRevenue,
        avgInvoice,
        topCategory,
        pendingReturns,
      ];
}
