import 'package:equatable/equatable.dart';

enum RecentPaymentType { interest, principal, partial, renewal, redemption }

class RecentPayment extends Equatable {
  const RecentPayment({
    required this.id,
    required this.customerName,
    required this.customerNameEn,
    required this.girviSerial,
    required this.paymentType,
    required this.amount,
    required this.paidAt,
  });

  final String id;
  final String customerName;
  final String customerNameEn;
  final String girviSerial;
  final RecentPaymentType paymentType;
  final double amount;
  final DateTime paidAt;

  @override
  List<Object?> get props =>
      [id, customerName, customerNameEn, girviSerial, paymentType, amount, paidAt];
}

class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.activeGirvi,
    required this.dueToday,
    required this.overdue,
    required this.collectionsToday,
    required this.loanExposure,
    required this.goldRatePerGram,
    required this.goldRateChange,
    required this.goldRateChangePct,
    required this.goldRateSource,
    required this.goldRateUpdatedAt,
    required this.recentPayments,
    this.newGirviToday = 0,
    this.disbursedToday = 0,
  });

  final int activeGirvi;

  /// Girvi accounts due within 7 days
  final int dueToday;

  /// Overdue girvi count
  final int overdue;

  /// Total payments collected today
  final double collectionsToday;

  /// Total outstanding loan exposure across all active girvi
  final double loanExposure;

  /// 24K gold rate per gram (multiply × 10 for 10g display)
  final double goldRatePerGram;

  /// Today's gold rate change (per gram)
  final double goldRateChange;

  /// Today's gold rate change as a percentage
  final double goldRateChangePct;

  final String goldRateSource;
  final DateTime goldRateUpdatedAt;
  final List<RecentPayment> recentPayments;

  /// New girvi created today (for delta display)
  final int newGirviToday;

  /// Amount disbursed today (for delta display)
  final double disbursedToday;

  /// Notification badge count = dueToday + overdue
  int get alertCount => dueToday + overdue;

  @override
  List<Object?> get props => [
    activeGirvi, dueToday, overdue, collectionsToday, loanExposure,
    goldRatePerGram, goldRateChange, goldRateChangePct, goldRateSource,
    goldRateUpdatedAt, recentPayments, newGirviToday, disbursedToday,
  ];
}
