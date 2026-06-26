part of 'new_sale_bloc.dart';

sealed class NewSaleEvent {}

final class NewSaleItemAdded extends NewSaleEvent {
  NewSaleItemAdded({required this.item});
  final SaleItem item;
}

final class NewSaleItemRemoved extends NewSaleEvent {
  NewSaleItemRemoved({required this.itemId});
  final String itemId;
}

final class NewSaleDiscountChanged extends NewSaleEvent {
  NewSaleDiscountChanged({required this.discount});
  final double discount;
}

final class NewSalePaymentModeChanged extends NewSaleEvent {
  NewSalePaymentModeChanged({required this.mode});
  final SalePaymentMode mode;
}

final class NewSaleCustomerChanged extends NewSaleEvent {
  NewSaleCustomerChanged({
    required this.customerId,
    required this.customerName,
    required this.customerMobile,
  });
  final String customerId;
  final String customerName;
  final String customerMobile;
}

final class NewSaleSubmitted extends NewSaleEvent {}
