import 'package:equatable/equatable.dart';

/// Domain entity for dashboard summary.
class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.activeGirvi,
    required this.dueToday,
    required this.overdue,
    required this.collectionsToday,
    required this.loanExposure,
    required this.goldRate,
  });

  final int activeGirvi;
  final int dueToday;
  final int overdue;
  final double collectionsToday;
  final double loanExposure;
  final double goldRate;

  @override
  List<Object?> get props => [
        activeGirvi,
        dueToday,
        overdue,
        collectionsToday,
        loanExposure,
        goldRate,
      ];
}
