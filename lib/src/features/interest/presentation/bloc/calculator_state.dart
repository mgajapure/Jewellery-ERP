import 'package:equatable/equatable.dart';

import '../../domain/entities/interest_calculation.dart';

sealed class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object?> get props => [];
}

class CalculatorInitial extends CalculatorState {
  const CalculatorInitial();
}

class CalculatorReady extends CalculatorState {
  const CalculatorReady({
    required this.principal,
    required this.ratePercent,
    required this.days,
    required this.startDate,
    required this.interestType,
    this.result,
  });

  final double principal;
  final double ratePercent;
  final int days;
  final DateTime startDate;
  final InterestType interestType;

  /// Null until the user taps Calculate for the first time.
  final InterestCalculation? result;

  CalculatorReady copyWith({
    double? principal,
    double? ratePercent,
    int? days,
    DateTime? startDate,
    InterestType? interestType,
    InterestCalculation? result,
    bool clearResult = false,
  }) {
    return CalculatorReady(
      principal: principal ?? this.principal,
      ratePercent: ratePercent ?? this.ratePercent,
      days: days ?? this.days,
      startDate: startDate ?? this.startDate,
      interestType: interestType ?? this.interestType,
      result: clearResult ? null : result ?? this.result,
    );
  }

  @override
  List<Object?> get props =>
      [principal, ratePercent, days, startDate, interestType, result];
}
