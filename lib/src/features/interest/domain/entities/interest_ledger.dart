import 'package:equatable/equatable.dart';

import 'interest_calculation.dart';

enum LedgerEntryType { accrual, payment, penalty, renewal, redemption, auction }

extension LedgerEntryTypeLabel on LedgerEntryType {
  String get labelMr {
    switch (this) {
      case LedgerEntryType.accrual:
        return 'जमा';
      case LedgerEntryType.payment:
        return 'भरणा';
      case LedgerEntryType.penalty:
        return 'दंड';
      case LedgerEntryType.renewal:
        return 'नूतनीकरण';
      case LedgerEntryType.redemption:
        return 'परतफेड';
      case LedgerEntryType.auction:
        return 'लिलाव';
    }
  }

  String get labelEn {
    switch (this) {
      case LedgerEntryType.accrual:
        return 'Accrual';
      case LedgerEntryType.payment:
        return 'Payment';
      case LedgerEntryType.penalty:
        return 'Penalty';
      case LedgerEntryType.renewal:
        return 'Renewal';
      case LedgerEntryType.redemption:
        return 'Redemption';
      case LedgerEntryType.auction:
        return 'Auction';
    }
  }
}

class LedgerEntry extends Equatable {
  const LedgerEntry({
    required this.date,
    required this.type,
    required this.openingPrincipal,
    required this.interest,
    required this.penalty,
    required this.payment,
    required this.closingPrincipal,
    this.notes,
  });

  final DateTime date;
  final LedgerEntryType type;
  final double openingPrincipal;
  final double interest;
  final double penalty;
  final double payment;
  final double closingPrincipal;
  final String? notes;

  @override
  List<Object?> get props => [
        date,
        type,
        openingPrincipal,
        interest,
        penalty,
        payment,
        closingPrincipal,
      ];
}

class InterestLedger extends Equatable {
  const InterestLedger({
    required this.girviId,
    required this.customerName,
    required this.customerNameEn,
    required this.principal,
    required this.interestType,
    required this.interestRate,
    required this.entries,
  });

  final String girviId;
  final String customerName;
  final String customerNameEn;
  final double principal;
  final InterestType interestType;
  final double interestRate;
  final List<LedgerEntry> entries;

  double get totalInterest =>
      entries.fold(0, (sum, e) => sum + e.interest);
  double get totalPenalty =>
      entries.fold(0, (sum, e) => sum + e.penalty);
  double get totalPayments =>
      entries.fold(0, (sum, e) => sum + e.payment);
  double get outstanding =>
      principal + totalInterest + totalPenalty - totalPayments;

  @override
  List<Object?> get props => [girviId, entries];
}
