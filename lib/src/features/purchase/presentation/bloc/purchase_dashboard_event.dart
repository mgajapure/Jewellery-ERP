part of 'purchase_dashboard_bloc.dart';

sealed class PurchaseDashboardEvent {
  const PurchaseDashboardEvent();
}

final class PurchaseDashboardStarted extends PurchaseDashboardEvent {
  const PurchaseDashboardStarted();
}

final class PurchaseDashboardRefreshed extends PurchaseDashboardEvent {
  const PurchaseDashboardRefreshed();
}
