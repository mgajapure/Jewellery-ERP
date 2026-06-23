import 'package:equatable/equatable.dart';

enum InterestType { simple, katmiti, daily }

extension InterestTypeLabel on InterestType {
  String get labelMr {
    switch (this) {
      case InterestType.simple:
        return 'साधे व्याज';
      case InterestType.katmiti:
        return 'कटमिती';
      case InterestType.daily:
        return 'दैनिक';
    }
  }

  String get labelEn {
    switch (this) {
      case InterestType.simple:
        return 'Simple';
      case InterestType.katmiti:
        return 'Katmiti (Monthly)';
      case InterestType.daily:
        return 'Daily Compound';
    }
  }
}

class InterestCalculation extends Equatable {
  const InterestCalculation({
    required this.principal,
    required this.ratePercent,
    required this.days,
    required this.startDate,
    required this.interestType,
    required this.accruedInterest,
    required this.penaltyInterest,
  });

  final double principal;
  final double ratePercent;
  final int days;
  final DateTime startDate;
  final InterestType interestType;

  /// Core interest on principal for [days].
  final double accruedInterest;

  /// Penalty applied for days beyond 180 at 2 % p.a. flat.
  final double penaltyInterest;

  double get totalInterest => accruedInterest + penaltyInterest;
  double get totalDue => principal + totalInterest;

  @override
  List<Object?> get props => [
        principal,
        ratePercent,
        days,
        startDate,
        interestType,
        accruedInterest,
        penaltyInterest,
      ];
}
