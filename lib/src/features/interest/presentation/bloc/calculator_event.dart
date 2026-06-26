import 'package:equatable/equatable.dart';

import '../../domain/entities/interest_calculation.dart';

sealed class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

class CalculatorStarted extends CalculatorEvent {
  const CalculatorStarted();
}

class CalculatorInputChanged extends CalculatorEvent {
  const CalculatorInputChanged({
    this.principal,
    this.ratePercent,
    this.days,
    this.startDate,
    this.interestType,
  });

  final double? principal;
  final double? ratePercent;
  final int? days;
  final DateTime? startDate;
  final InterestType? interestType;

  @override
  List<Object?> get props =>
      [principal, ratePercent, days, startDate, interestType];
}

class CalculatorRecalculate extends CalculatorEvent {
  const CalculatorRecalculate();
}
