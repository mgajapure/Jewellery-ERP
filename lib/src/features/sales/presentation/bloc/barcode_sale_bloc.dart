import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/sale_order.dart';
import '../../domain/repositories/sales_repository.dart';

part 'barcode_sale_event.dart';
part 'barcode_sale_state.dart';

@injectable
class BarcodeSaleBloc extends Bloc<BarcodeSaleEvent, BarcodeSaleState> {
  BarcodeSaleBloc({required this.repository})
      : super(BarcodeSaleCartState(items: const [])) {
    on<BarcodeSaleItemScanned>(_onItemScanned);
    on<BarcodeSaleItemRemoved>(_onItemRemoved);
    on<BarcodeSaleCheckoutStarted>(_onCheckoutStarted);
  }

  final SalesRepository repository;

  Future<void> _onItemScanned(
    BarcodeSaleItemScanned event,
    Emitter<BarcodeSaleState> emit,
  ) async {
    final result = await repository.getCartItem(event.barcode);
    result.when(
      success: (item) {
        final current = _currentCart();
        emit(BarcodeSaleCartState(items: [...current.items, item]));
      },
      failure: (_) => emit(BarcodeSaleItemNotFound(barcode: event.barcode)),
    );
  }

  void _onItemRemoved(
    BarcodeSaleItemRemoved event,
    Emitter<BarcodeSaleState> emit,
  ) {
    final current = _currentCart();
    emit(BarcodeSaleCartState(
      items: current.items.where((i) => i.id != event.itemId).toList(),
    ));
  }

  Future<void> _onCheckoutStarted(
    BarcodeSaleCheckoutStarted event,
    Emitter<BarcodeSaleState> emit,
  ) async {
    final cart = _currentCart();
    emit(BarcodeSaleCheckingOut());
    final result = await repository.createSale(
      customerId: 'walk-in',
      customerName: 'Walk-in Customer',
      customerMobile: '',
      itemIds: cart.items.map((i) => i.id).toList(),
      discount: 0,
      paymentMode: SalePaymentMode.cash,
    );
    result.when(
      success: (order) => emit(BarcodeSaleSuccess(order: order)),
      failure: (e) => emit(BarcodeSaleError(message: e.message)),
    );
  }

  BarcodeSaleCartState _currentCart() {
    final s = state;
    if (s is BarcodeSaleCartState) return s;
    return BarcodeSaleCartState(items: const []);
  }
}
