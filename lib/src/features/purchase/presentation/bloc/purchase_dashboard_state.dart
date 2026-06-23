part of 'purchase_dashboard_bloc.dart';

sealed class PurchaseDashboardState {
  const PurchaseDashboardState();
}

final class PurchaseDashboardInitial extends PurchaseDashboardState {
  const PurchaseDashboardInitial();
}

final class PurchaseDashboardLoading extends PurchaseDashboardState {
  const PurchaseDashboardLoading();
}

final class PurchaseDashboardLoaded extends PurchaseDashboardState {
  const PurchaseDashboardLoaded(this.stats);

  final PurchaseDashboardStats stats;
}

final class PurchaseDashboardError extends PurchaseDashboardState {
  const PurchaseDashboardError(this.message);

  final String message;
}
