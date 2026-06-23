part of 'compliance_dashboard_bloc.dart';

sealed class ComplianceDashboardEvent {}

final class ComplianceDashboardStarted extends ComplianceDashboardEvent {}

final class ComplianceDashboardRefreshed extends ComplianceDashboardEvent {}
