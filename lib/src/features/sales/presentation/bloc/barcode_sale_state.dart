part of 'barcode_sale_bloc.dart';

sealed class BarcodeSaleState {}

final class BarcodeSaleCartState extends BarcodeSaleState {
  BarcodeSaleCartState({required this.items});
  final List<SaleItem> items;
  double get total => items.fold(0, (sum, i) => sum + i.totalAmount);
}

final class BarcodeSaleItemNotFound extends BarcodeSaleState {
  BarcodeSaleItemNotFound({required this.barcode});
  final String barcode;
}

final class BarcodeSaleCheckingOut extends BarcodeSaleState {}

final class BarcodeSaleSuccess extends BarcodeSaleState {
  BarcodeSaleSuccess({required this.order});
  final SaleOrder order;
}

final class BarcodeSaleError extends BarcodeSaleState {
  BarcodeSaleError({required this.message});
  final String message;
}
