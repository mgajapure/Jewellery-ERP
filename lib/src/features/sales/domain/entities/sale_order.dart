import 'package:equatable/equatable.dart';

enum SaleStatus {
  draft,
  completed,
  returned,
  cancelled;

  String get labelMr {
    switch (this) {
      case SaleStatus.draft:
        return 'मसुदा';
      case SaleStatus.completed:
        return 'पूर्ण';
      case SaleStatus.returned:
        return 'परत';
      case SaleStatus.cancelled:
        return 'रद्द';
    }
  }

  String get labelEn {
    switch (this) {
      case SaleStatus.draft:
        return 'Draft';
      case SaleStatus.completed:
        return 'Completed';
      case SaleStatus.returned:
        return 'Returned';
      case SaleStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum SalePaymentMode {
  cash,
  upi,
  bankTransfer,
  card,
  splitPayment;

  String get labelMr {
    switch (this) {
      case SalePaymentMode.cash:
        return 'रोख';
      case SalePaymentMode.upi:
        return 'यूपीआय';
      case SalePaymentMode.bankTransfer:
        return 'बँक हस्तांतरण';
      case SalePaymentMode.card:
        return 'कार्ड';
      case SalePaymentMode.splitPayment:
        return 'विभाजित';
    }
  }

  String get labelEn {
    switch (this) {
      case SalePaymentMode.cash:
        return 'Cash';
      case SalePaymentMode.upi:
        return 'UPI';
      case SalePaymentMode.bankTransfer:
        return 'Bank Transfer';
      case SalePaymentMode.card:
        return 'Card';
      case SalePaymentMode.splitPayment:
        return 'Split Payment';
    }
  }
}

class SaleItem extends Equatable {
  const SaleItem({
    required this.id,
    required this.name,
    required this.barcode,
    required this.grossWeight,
    required this.netWeight,
    required this.purity,
    required this.taxableAmount,
    required this.gst,
    required this.totalAmount,
  });

  final String id;
  final String name;
  final String barcode;
  final double grossWeight;
  final double netWeight;
  final double purity;
  final double taxableAmount;
  final double gst;
  final double totalAmount;

  @override
  List<Object?> get props => [
        id,
        name,
        barcode,
        grossWeight,
        netWeight,
        purity,
        taxableAmount,
        gst,
        totalAmount,
      ];
}

class SaleOrder extends Equatable {
  const SaleOrder({
    required this.invoiceNo,
    required this.date,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.cgst,
    required this.sgst,
    required this.totalAmount,
    required this.paymentMode,
    required this.status,
    required this.createdAt,
  });

  final String invoiceNo;
  final DateTime date;
  final String customerId;
  final String customerName;
  final String customerMobile;
  final List<SaleItem> items;
  final double subtotal;
  final double discount;
  final double cgst;
  final double sgst;
  final double totalAmount;
  final SalePaymentMode paymentMode;
  final SaleStatus status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        invoiceNo,
        date,
        customerId,
        customerName,
        customerMobile,
        items,
        subtotal,
        discount,
        cgst,
        sgst,
        totalAmount,
        paymentMode,
        status,
        createdAt,
      ];
}
