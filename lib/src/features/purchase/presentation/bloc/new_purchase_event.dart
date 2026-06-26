part of 'new_purchase_bloc.dart';

sealed class NewPurchaseEvent {
  const NewPurchaseEvent();
}

final class NewPurchaseSubmitted extends NewPurchaseEvent {
  const NewPurchaseSubmitted({
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
    required this.paymentMode,
  });

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
  final PaymentMode paymentMode;
}
