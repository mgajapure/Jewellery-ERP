import 'package:equatable/equatable.dart';

enum PurchaseType { newInventory, scrap, bullion }

extension PurchaseTypeLabel on PurchaseType {
  String get labelMr {
    switch (this) {
      case PurchaseType.newInventory:
        return 'नवीन इन्व्हेंटरी';
      case PurchaseType.scrap:
        return 'स्क्रॅप';
      case PurchaseType.bullion:
        return 'बुलियन';
    }
  }

  String get labelEn {
    switch (this) {
      case PurchaseType.newInventory:
        return 'New Inventory';
      case PurchaseType.scrap:
        return 'Scrap';
      case PurchaseType.bullion:
        return 'Bullion';
    }
  }
}

enum MetalType { gold24k, gold22k, gold18k, silver }

extension MetalTypeLabel on MetalType {
  String get labelMr {
    switch (this) {
      case MetalType.gold24k:
        return 'सोने 24K';
      case MetalType.gold22k:
        return 'सोने 22K';
      case MetalType.gold18k:
        return 'सोने 18K';
      case MetalType.silver:
        return 'चांदी';
    }
  }

  String get labelEn {
    switch (this) {
      case MetalType.gold24k:
        return 'Gold 24K';
      case MetalType.gold22k:
        return 'Gold 22K';
      case MetalType.gold18k:
        return 'Gold 18K';
      case MetalType.silver:
        return 'Silver';
    }
  }
}

enum PaymentMode { cash, bankTransfer, cheque, credit }

extension PaymentModeLabel on PaymentMode {
  String get labelMr {
    switch (this) {
      case PaymentMode.cash:
        return 'रोख';
      case PaymentMode.bankTransfer:
        return 'बँक ट्रान्सफर';
      case PaymentMode.cheque:
        return 'धनादेश';
      case PaymentMode.credit:
        return 'उधार';
    }
  }

  String get labelEn {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.bankTransfer:
        return 'Bank Transfer';
      case PaymentMode.cheque:
        return 'Cheque';
      case PaymentMode.credit:
        return 'Credit';
    }
  }
}

enum PurchaseStatus { pending, approved, rejected }

extension PurchaseStatusLabel on PurchaseStatus {
  String get labelMr {
    switch (this) {
      case PurchaseStatus.pending:
        return 'प्रलंबित';
      case PurchaseStatus.approved:
        return 'मंजूर';
      case PurchaseStatus.rejected:
        return 'नाकारले';
    }
  }

  String get labelEn {
    switch (this) {
      case PurchaseStatus.pending:
        return 'Pending';
      case PurchaseStatus.approved:
        return 'Approved';
      case PurchaseStatus.rejected:
        return 'Rejected';
    }
  }
}

class PurchaseEntry extends Equatable {
  const PurchaseEntry({
    required this.id,
    required this.date,
    required this.supplierName,
    required this.supplierMobile,
    required this.billNo,
    required this.purchaseType,
    required this.metalType,
    required this.itemName,
    required this.grossWeight,
    required this.netWeight,
    required this.purity,
    required this.rate,
    required this.amount,
    required this.gst,
    required this.totalAmount,
    required this.paymentMode,
    required this.status,
  });

  final String id;
  final DateTime date;
  final String supplierName;
  final String supplierMobile;
  final String billNo;
  final PurchaseType purchaseType;
  final MetalType metalType;
  final String itemName;
  final double grossWeight;
  final double netWeight;
  final double purity;
  final double rate;
  final double amount;
  final double gst;
  final double totalAmount;
  final PaymentMode paymentMode;
  final PurchaseStatus status;

  @override
  List<Object?> get props => [
        id,
        date,
        supplierName,
        supplierMobile,
        billNo,
        purchaseType,
        metalType,
        itemName,
        grossWeight,
        netWeight,
        purity,
        rate,
        amount,
        gst,
        totalAmount,
        paymentMode,
        status,
      ];
}
