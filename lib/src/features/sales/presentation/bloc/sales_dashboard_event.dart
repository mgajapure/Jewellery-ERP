part of 'sales_dashboard_bloc.dart';

sealed class SalesDashboardEvent {}

final class SalesDashboardStarted extends SalesDashboardEvent {}

final class SalesDashboardRefreshed extends SalesDashboardEvent {}
