part of 'savings_dashboard_bloc.dart';

sealed class SavingsDashboardEvent {}

final class SavingsDashboardStarted extends SavingsDashboardEvent {}

final class SavingsDashboardRefreshed extends SavingsDashboardEvent {}
