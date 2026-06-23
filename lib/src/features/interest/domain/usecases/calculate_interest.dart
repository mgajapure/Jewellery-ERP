import 'dart:math';

import '../entities/interest_calculation.dart';

/// Pure synchronous use case for interest computation.
///
/// Simple:  P × R × T / 36500
/// Katmiti: P × ((1 + R/1200)^ceil(T/30) − 1)   — monthly compound
/// Daily:   P × ((1 + R/36500)^T − 1)             — daily compound
/// Penalty: P × 2 × overdueDays / 36500  (for days > 180)
class CalculateInterest {
  const CalculateInterest();

  InterestCalculation call({
    required double principal,
    required double ratePercent,
    required int days,
    required DateTime startDate,
    required InterestType interestType,
  }) {
    final accrued = _accrued(principal, ratePercent, days, interestType);
    final penalty = _penalty(principal, days);
    return InterestCalculation(
      principal: principal,
      ratePercent: ratePercent,
      days: days,
      startDate: startDate,
      interestType: interestType,
      accruedInterest: accrued,
      penaltyInterest: penalty,
    );
  }

  double _accrued(
    double p,
    double r,
    int days,
    InterestType type,
  ) {
    if (p <= 0 || r <= 0 || days <= 0) return 0;
    switch (type) {
      case InterestType.simple:
        return (p * r * days) / 36500;
      case InterestType.katmiti:
        final months = (days / 30).ceil();
        return p * (pow(1 + r / 1200, months) - 1);
      case InterestType.daily:
        return p * (pow(1 + r / 36500, days) - 1);
    }
  }

  double _penalty(double principal, int days) {
    if (days <= 180) return 0;
    return (principal * 2 * (days - 180)) / 36500;
  }
}
