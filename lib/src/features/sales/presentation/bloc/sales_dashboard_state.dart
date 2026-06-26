part of 'sales_dashboard_bloc.dart';

sealed class SalesDashboardState {}

final class SalesDashboardInitial extends SalesDashboardState {}

final class SalesDashboardLoading extends SalesDashboardState {}

final class SalesDashboardLoaded extends SalesDashboardState {
  SalesDashboardLoaded({required this.stats});
  final SalesDashboardStats stats;
}

final class SalesDashboardError extends SalesDashboardState {
  SalesDashboardError({required this.message});
  final String message;
}
