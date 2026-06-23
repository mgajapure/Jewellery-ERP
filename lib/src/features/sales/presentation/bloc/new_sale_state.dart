part of 'new_sale_bloc.dart';

sealed class NewSaleState {}

final class NewSaleCartState extends NewSaleState {
  NewSaleCartState({
    required this.items,
    required this.discount,
    required this.paymentMode,
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
  });

  final List<SaleItem> items;
  final double discount;
  final SalePaymentMode paymentMode;
  final String customerId;
  final String customerName;
  final String customerMobile;

  double get subtotal =>
      items.fold(0, (sum, i) => sum + i.taxableAmount);
  double get taxable => subtotal - discount;
  double get cgst => taxable * 0.015;
  double get sgst => taxable * 0.015;
  double get totalAmount => taxable + cgst + sgst;

  NewSaleCartState copyWith({
    List<SaleItem>? items,
    double? discount,
    SalePaymentMode? paymentMode,
    String? customerId,
    String? customerName,
    String? customerMobile,
  }) =>
      NewSaleCartState(
        items: items ?? this.items,
        discount: discount ?? this.discount,
        paymentMode: paymentMode ?? this.paymentMode,
        customerId: customerId ?? this.customerId,
        customerName: customerName ?? this.customerName,
        customerMobile: customerMobile ?? this.customerMobile,
      );
}

final class NewSaleSubmitting extends NewSaleState {}

final class NewSaleSuccess extends NewSaleState {
  NewSaleSuccess({required this.order});
  final SaleOrder order;
}

final class NewSaleError extends NewSaleState {
  NewSaleError({required this.message});
  final String message;
}
