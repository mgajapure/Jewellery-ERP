// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => _DashboardSummaryModel(
  activeGirvi: (json['activeGirvi'] as num?)?.toInt() ?? 0,
  dueToday: (json['dueToday'] as num?)?.toInt() ?? 0,
  overdue: (json['overdue'] as num?)?.toInt() ?? 0,
  collectionsToday: (json['collectionsToday'] as num?)?.toDouble() ?? 0.0,
  loanExposure: (json['loanExposure'] as num?)?.toDouble() ?? 0.0,
  goldRate: (json['goldRate'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  _DashboardSummaryModel instance,
) => <String, dynamic>{
  'activeGirvi': instance.activeGirvi,
  'dueToday': instance.dueToday,
  'overdue': instance.overdue,
  'collectionsToday': instance.collectionsToday,
  'loanExposure': instance.loanExposure,
  'goldRate': instance.goldRate,
};
