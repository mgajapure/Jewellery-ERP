part of 'savings_dashboard_bloc.dart';

sealed class SavingsDashboardState {}

final class SavingsDashboardInitial extends SavingsDashboardState {}

final class SavingsDashboardLoading extends SavingsDashboardState {}

final class SavingsDashboardLoaded extends SavingsDashboardState {
  SavingsDashboardLoaded({required this.stats});
  final SavingsDashboardStats stats;
}

final class SavingsDashboardError extends SavingsDashboardState {
  SavingsDashboardError({required this.message});
  final String message;
}
