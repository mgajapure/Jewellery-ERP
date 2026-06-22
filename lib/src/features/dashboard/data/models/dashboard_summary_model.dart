import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/dashboard_summary.dart';

part 'dashboard_summary_model.freezed.dart';
part 'dashboard_summary_model.g.dart';

@freezed
class DashboardSummaryModel with _$DashboardSummaryModel {
  const factory DashboardSummaryModel({
    @Default(0) int activeGirvi,
    @Default(0) int dueToday,
    @Default(0) int overdue,
    @Default(0.0) double collectionsToday,
    @Default(0.0) double loanExposure,
    @Default(0.0) double goldRate,
  }) = _DashboardSummaryModel;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);
}

extension DashboardSummaryModelX on DashboardSummaryModel {
  DashboardSummary toEntity() => DashboardSummary(
        activeGirvi: activeGirvi,
        dueToday: dueToday,
        overdue: overdue,
        collectionsToday: collectionsToday,
        loanExposure: loanExposure,
        goldRate: goldRate,
      );
}
