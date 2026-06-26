part of 'barcode_sale_bloc.dart';

sealed class BarcodeSaleEvent {}

final class BarcodeSaleItemScanned extends BarcodeSaleEvent {
  BarcodeSaleItemScanned({required this.barcode});
  final String barcode;
}

final class BarcodeSaleItemRemoved extends BarcodeSaleEvent {
  BarcodeSaleItemRemoved({required this.itemId});
  final String itemId;
}

final class BarcodeSaleCheckoutStarted extends BarcodeSaleEvent {}
