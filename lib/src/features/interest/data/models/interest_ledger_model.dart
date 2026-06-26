import '../../domain/entities/interest_calculation.dart';
import '../../domain/entities/interest_ledger.dart';

class LedgerEntryModel extends LedgerEntry {
  const LedgerEntryModel({
    required super.date,
    required super.type,
    required super.openingPrincipal,
    required super.interest,
    required super.penalty,
    required super.payment,
    required super.closingPrincipal,
    super.notes,
  });

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) {
    return LedgerEntryModel(
      date: DateTime.parse(json['date'] as String),
      type: _parseType(json['type'] as String),
      openingPrincipal: (json['openingPrincipal'] as num).toDouble(),
      interest: (json['interest'] as num).toDouble(),
      penalty: (json['penalty'] as num).toDouble(),
      payment: (json['payment'] as num).toDouble(),
      closingPrincipal: (json['closingPrincipal'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  static LedgerEntryType _parseType(String type) {
    switch (type) {
      case 'PAYMENT':
        return LedgerEntryType.payment;
      case 'PENALTY':
        return LedgerEntryType.penalty;
      case 'RENEWAL':
        return LedgerEntryType.renewal;
      case 'REDEMPTION':
        return LedgerEntryType.redemption;
      case 'AUCTION':
        return LedgerEntryType.auction;
      default:
        return LedgerEntryType.accrual;
    }
  }
}

class InterestLedgerModel extends InterestLedger {
  const InterestLedgerModel({
    required super.girviId,
    required super.customerName,
    required super.customerNameEn,
    required super.principal,
    required super.interestType,
    required super.interestRate,
    required super.entries,
  });

  factory InterestLedgerModel.fromJson(Map<String, dynamic> json) {
    final rawEntries = json['entries'] as List<dynamic>? ?? [];
    return InterestLedgerModel(
      girviId: json['girviId'] as String,
      customerName: json['customerName'] as String,
      customerNameEn: json['customerNameEn'] as String,
      principal: (json['principal'] as num).toDouble(),
      interestType: _parseType(json['interestType'] as String),
      interestRate: (json['interestRate'] as num).toDouble(),
      entries: rawEntries
          .map((e) => LedgerEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static InterestType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'katmiti':
        return InterestType.katmiti;
      case 'daily':
        return InterestType.daily;
      default:
        return InterestType.simple;
    }
  }
}
