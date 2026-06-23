import 'package:equatable/equatable.dart';

class PurchaseDashboardStats extends Equatable {
  const PurchaseDashboardStats({
    required this.todayPurchases,
    required this.todayValue,
    required this.pendingApprovals,
    required this.totalSuppliers,
    required this.scrapPurchases,
    required this.inventoryAdded,
  });

  final int todayPurchases;
  final double todayValue;
  final int pendingApprovals;
  final int totalSuppliers;
  final int scrapPurchases;
  final int inventoryAdded;

  @override
  List<Object?> get props => [
        todayPurchases,
        todayValue,
        pendingApprovals,
        totalSuppliers,
        scrapPurchases,
        inventoryAdded,
      ];
}
