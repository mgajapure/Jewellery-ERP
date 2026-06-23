import '../../domain/entities/sale_order.dart';

class SaleItemModel extends SaleItem {
  const SaleItemModel({
    required super.id,
    required super.name,
    required super.barcode,
    required super.grossWeight,
    required super.netWeight,
    required super.purity,
    required super.taxableAmount,
    required super.gst,
    required super.totalAmount,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) => SaleItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        barcode: json['barcode'] as String,
        grossWeight: (json['grossWeight'] as num).toDouble(),
        netWeight: (json['netWeight'] as num).toDouble(),
        purity: (json['purity'] as num).toDouble(),
        taxableAmount: (json['taxableAmount'] as num).toDouble(),
        gst: (json['gst'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
      );
}

class SaleOrderModel extends SaleOrder {
  const SaleOrderModel({
    required super.invoiceNo,
    required super.date,
    required super.customerId,
    required super.customerName,
    required super.customerMobile,
    required super.items,
    required super.subtotal,
    required super.discount,
    required super.cgst,
    required super.sgst,
    required super.totalAmount,
    required super.paymentMode,
    required super.status,
    required super.createdAt,
  });

  factory SaleOrderModel.fromJson(Map<String, dynamic> json) => SaleOrderModel(
        invoiceNo: json['invoiceNo'] as String,
        date: DateTime.parse(json['date'] as String),
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        customerMobile: json['customerMobile'] as String,
        items: (json['items'] as List)
            .map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        discount: (json['discount'] as num).toDouble(),
        cgst: (json['cgst'] as num).toDouble(),
        sgst: (json['sgst'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        paymentMode: _parsePaymentMode(json['paymentMode'] as String),
        status: _parseStatus(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static SalePaymentMode _parsePaymentMode(String s) {
    switch (s) {
      case 'UPI':
        return SalePaymentMode.upi;
      case 'BANK_TRANSFER':
        return SalePaymentMode.bankTransfer;
      case 'CARD':
        return SalePaymentMode.card;
      case 'SPLIT_PAYMENT':
        return SalePaymentMode.splitPayment;
      default:
        return SalePaymentMode.cash;
    }
  }

  static SaleStatus _parseStatus(String s) {
    switch (s) {
      case 'COMPLETED':
        return SaleStatus.completed;
      case 'RETURNED':
        return SaleStatus.returned;
      case 'CANCELLED':
        return SaleStatus.cancelled;
      default:
        return SaleStatus.draft;
    }
  }
}
