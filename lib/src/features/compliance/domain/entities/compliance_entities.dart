import 'package:equatable/equatable.dart';

enum ComplianceSeverity {
  high,
  medium,
  low;

  String get labelMr {
    return switch (this) {
      ComplianceSeverity.high => 'उच्च',
      ComplianceSeverity.medium => 'मध्यम',
      ComplianceSeverity.low => 'कमी',
    };
  }

  String get labelEn {
    return switch (this) {
      ComplianceSeverity.high => 'High',
      ComplianceSeverity.medium => 'Medium',
      ComplianceSeverity.low => 'Low',
    };
  }
}

class ComplianceMetric extends Equatable {
  const ComplianceMetric({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.colorHex,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final int colorHex;

  @override
  List<Object?> get props => [labelMr, labelEn, value, colorHex];
}

class ComplianceAlert extends Equatable {
  const ComplianceAlert({
    required this.title,
    required this.subtitle,
    required this.severity,
    required this.time,
  });

  final String title;
  final String subtitle;
  final ComplianceSeverity severity;
  final String time;

  @override
  List<Object?> get props => [title, severity, time];
}

class ComplianceDashboardStats extends Equatable {
  const ComplianceDashboardStats({
    required this.healthScore,
    required this.metrics,
    required this.alerts,
  });

  final int healthScore;
  final List<ComplianceMetric> metrics;
  final List<ComplianceAlert> alerts;

  @override
  List<Object?> get props => [healthScore, metrics, alerts];
}

class Form9Row extends Equatable {
  const Form9Row({
    required this.date,
    required this.girviCount,
    required this.totalLoan,
    required this.payments,
    required this.interest,
  });

  final String date;
  final int girviCount;
  final double totalLoan;
  final double payments;
  final double interest;

  @override
  List<Object?> get props => [date, girviCount, totalLoan, payments, interest];
}

class Form9Register extends Equatable {
  const Form9Register({required this.rows, required this.period});

  final List<Form9Row> rows;
  final String period;

  double get totalLoans =>
      rows.fold(0, (s, r) => s + r.totalLoan);
  double get totalPayments =>
      rows.fold(0, (s, r) => s + r.payments);
  int get totalCount =>
      rows.fold(0, (s, r) => s + r.girviCount);

  @override
  List<Object?> get props => [rows, period];
}
