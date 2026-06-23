import '../../domain/entities/compliance_entities.dart';

class ComplianceMetricModel extends ComplianceMetric {
  const ComplianceMetricModel({
    required super.labelMr,
    required super.labelEn,
    required super.value,
    required super.colorHex,
  });

  factory ComplianceMetricModel.fromJson(Map<String, dynamic> json) =>
      ComplianceMetricModel(
        labelMr: json['labelMr'] as String,
        labelEn: json['labelEn'] as String,
        value: json['value'] as String,
        colorHex: json['color'] as int,
      );
}

class ComplianceAlertModel extends ComplianceAlert {
  const ComplianceAlertModel({
    required super.title,
    required super.subtitle,
    required super.severity,
    required super.time,
  });

  factory ComplianceAlertModel.fromJson(Map<String, dynamic> json) =>
      ComplianceAlertModel(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        severity: _parseSeverity(json['severity'] as String),
        time: json['time'] as String,
      );

  static ComplianceSeverity _parseSeverity(String s) {
    switch (s.toLowerCase()) {
      case 'high':
        return ComplianceSeverity.high;
      case 'medium':
        return ComplianceSeverity.medium;
      default:
        return ComplianceSeverity.low;
    }
  }
}

class ComplianceDashboardStatsModel extends ComplianceDashboardStats {
  const ComplianceDashboardStatsModel({
    required super.healthScore,
    required super.metrics,
    required super.alerts,
  });

  factory ComplianceDashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      ComplianceDashboardStatsModel(
        healthScore: json['healthScore'] as int,
        metrics: (json['metrics'] as List)
            .map((e) =>
                ComplianceMetricModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        alerts: (json['alerts'] as List)
            .map((e) =>
                ComplianceAlertModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class Form9RowModel extends Form9Row {
  const Form9RowModel({
    required super.date,
    required super.girviCount,
    required super.totalLoan,
    required super.payments,
    required super.interest,
  });

  factory Form9RowModel.fromJson(Map<String, dynamic> json) => Form9RowModel(
        date: json['date'] as String,
        girviCount: json['girviCount'] as int,
        totalLoan: (json['totalLoan'] as num).toDouble(),
        payments: (json['payments'] as num).toDouble(),
        interest: (json['interest'] as num).toDouble(),
      );
}

class Form9RegisterModel extends Form9Register {
  const Form9RegisterModel({required super.rows, required super.period});

  factory Form9RegisterModel.fromJson(Map<String, dynamic> json) =>
      Form9RegisterModel(
        period: json['period'] as String? ?? '',
        rows: (json['rows'] as List)
            .map((e) => Form9RowModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
