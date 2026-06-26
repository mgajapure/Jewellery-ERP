part of 'reports_dashboard_bloc.dart';

sealed class ReportsDashboardEvent {}

final class ReportsDashboardStarted extends ReportsDashboardEvent {}

final class ReportsDashboardPeriodChanged extends ReportsDashboardEvent {
  ReportsDashboardPeriodChanged({required this.period});
  final String period;
}
