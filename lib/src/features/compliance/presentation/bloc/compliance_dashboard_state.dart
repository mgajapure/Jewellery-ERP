part of 'compliance_dashboard_bloc.dart';

sealed class ComplianceDashboardState {}

final class ComplianceDashboardInitial extends ComplianceDashboardState {}

final class ComplianceDashboardLoading extends ComplianceDashboardState {}

final class ComplianceDashboardLoaded extends ComplianceDashboardState {
  ComplianceDashboardLoaded({required this.stats});
  final ComplianceDashboardStats stats;
}

final class ComplianceDashboardError extends ComplianceDashboardState {
  ComplianceDashboardError({required this.message});
  final String message;
}
