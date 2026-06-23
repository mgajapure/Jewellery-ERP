part of 'sales_return_bloc.dart';

sealed class SalesReturnEvent {}

final class SalesReturnInvoiceLookupStarted extends SalesReturnEvent {
  SalesReturnInvoiceLookupStarted({required this.invoiceNo});
  final String invoiceNo;
}

final class SalesReturnItemToggled extends SalesReturnEvent {
  SalesReturnItemToggled({required this.itemId});
  final String itemId;
}

final class SalesReturnSubmitted extends SalesReturnEvent {
  SalesReturnSubmitted({
    required this.reason,
    required this.returnType,
    required this.inventoryStatus,
  });
  final String reason;
  final String returnType;
  final String inventoryStatus;
}
