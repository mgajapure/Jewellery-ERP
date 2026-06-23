part of 'reports_dashboard_bloc.dart';

sealed class ReportsDashboardState {}

final class ReportsDashboardInitial extends ReportsDashboardState {}

final class ReportsDashboardLoading extends ReportsDashboardState {}

final class ReportsDashboardLoaded extends ReportsDashboardState {
  ReportsDashboardLoaded({required this.data, required this.period});
  final ReportsDashboardData data;
  final String period;
}

final class ReportsDashboardError extends ReportsDashboardState {
  ReportsDashboardError({required this.message});
  final String message;
}
