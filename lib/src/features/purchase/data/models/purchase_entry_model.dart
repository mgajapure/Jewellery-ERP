import '../../domain/entities/purchase_entry.dart';

class PurchaseEntryModel extends PurchaseEntry {
  const PurchaseEntryModel({
    required super.id,
    required super.date,
    required super.supplierName,
    required super.supplierMobile,
    required super.billNo,
    required super.purchaseType,
    required super.metalType,
    required super.itemName,
    required super.grossWeight,
    required super.netWeight,
    required super.purity,
    required super.rate,
    required super.amount,
    required super.gst,
    required super.totalAmount,
    required super.paymentMode,
    required super.status,
  });

  factory PurchaseEntryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseEntryModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      supplierName: json['supplierName'] as String,
      supplierMobile: json['supplierMobile'] as String,
      billNo: json['billNo'] as String,
      purchaseType: _parsePurchaseType(json['purchaseType'] as String),
      metalType: _parseMetalType(json['metalType'] as String),
      itemName: json['itemName'] as String,
      grossWeight: (json['grossWeight'] as num).toDouble(),
      netWeight: (json['netWeight'] as num).toDouble(),
      purity: (json['purity'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMode: _parsePaymentMode(json['paymentMode'] as String),
      status: _parseStatus(json['status'] as String),
    );
  }

  static PurchaseType _parsePurchaseType(String raw) {
    switch (raw.toUpperCase()) {
      case 'SCRAP':
        return PurchaseType.scrap;
      case 'BULLION':
        return PurchaseType.bullion;
      default:
        return PurchaseType.newInventory;
    }
  }

  static MetalType _parseMetalType(String raw) {
    switch (raw.toUpperCase()) {
      case 'GOLD_24K':
      case 'GOLD24K':
        return MetalType.gold24k;
      case 'GOLD_18K':
      case 'GOLD18K':
        return MetalType.gold18k;
      case 'SILVER':
        return MetalType.silver;
      default:
        return MetalType.gold22k;
    }
  }

  static PaymentMode _parsePaymentMode(String raw) {
    switch (raw.toUpperCase()) {
      case 'BANK_TRANSFER':
      case 'BANK':
        return PaymentMode.bankTransfer;
      case 'CHEQUE':
        return PaymentMode.cheque;
      case 'CREDIT':
        return PaymentMode.credit;
      default:
        return PaymentMode.cash;
    }
  }

  static PurchaseStatus _parseStatus(String raw) {
    switch (raw.toUpperCase()) {
      case 'APPROVED':
        return PurchaseStatus.approved;
      case 'REJECTED':
        return PurchaseStatus.rejected;
      default:
        return PurchaseStatus.pending;
    }
  }
}
