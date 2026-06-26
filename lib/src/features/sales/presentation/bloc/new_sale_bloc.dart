import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/sale_order.dart';
import '../../domain/repositories/sales_repository.dart';

part 'new_sale_event.dart';
part 'new_sale_state.dart';

@injectable
class NewSaleBloc extends Bloc<NewSaleEvent, NewSaleState> {
  NewSaleBloc({required this.repository}) : super(_initialCart()) {
    on<NewSaleItemAdded>(_onItemAdded);
    on<NewSaleItemRemoved>(_onItemRemoved);
    on<NewSaleDiscountChanged>(_onDiscountChanged);
    on<NewSalePaymentModeChanged>(_onPaymentModeChanged);
    on<NewSaleCustomerChanged>(_onCustomerChanged);
    on<NewSaleSubmitted>(_onSubmitted);
  }

  final SalesRepository repository;

  static NewSaleCartState _initialCart() => NewSaleCartState(
        items: const [
          SaleItem(
            id: 'inv-1001',
            name: 'Gold Chain 22K',
            barcode: 'ITM-1001',
            grossWeight: 24.50,
            netWeight: 24.20,
            purity: 91.6,
            taxableAmount: 125000,
            gst: 3750,
            totalAmount: 128750,
          ),
          SaleItem(
            id: 'inv-1002',
            name: 'Gold Ring 22K',
            barcode: 'ITM-1002',
            grossWeight: 8.20,
            netWeight: 8.00,
            purity: 91.6,
            taxableAmount: 42000,
            gst: 1260,
            totalAmount: 43260,
          ),
        ],
        discount: 0,
        paymentMode: SalePaymentMode.cash,
        customerId: 'walk-in',
        customerName: 'Walk-in Customer',
        customerMobile: '',
      );

  void _onItemAdded(NewSaleItemAdded event, Emitter<NewSaleState> emit) {
    final current = _currentCart();
    emit(current.copyWith(items: [...current.items, event.item]));
  }

  void _onItemRemoved(NewSaleItemRemoved event, Emitter<NewSaleState> emit) {
    final current = _currentCart();
    emit(current.copyWith(
      items: current.items.where((i) => i.id != event.itemId).toList(),
    ));
  }

  void _onDiscountChanged(
      NewSaleDiscountChanged event, Emitter<NewSaleState> emit) {
    emit(_currentCart().copyWith(discount: event.discount));
  }

  void _onPaymentModeChanged(
      NewSalePaymentModeChanged event, Emitter<NewSaleState> emit) {
    emit(_currentCart().copyWith(paymentMode: event.mode));
  }

  void _onCustomerChanged(
      NewSaleCustomerChanged event, Emitter<NewSaleState> emit) {
    emit(_currentCart().copyWith(
      customerId: event.customerId,
      customerName: event.customerName,
      customerMobile: event.customerMobile,
    ));
  }

  Future<void> _onSubmitted(
      NewSaleSubmitted event, Emitter<NewSaleState> emit) async {
    final cart = _currentCart();
    emit(NewSaleSubmitting());
    final result = await repository.createSale(
      customerId: cart.customerId,
      customerName: cart.customerName,
      customerMobile: cart.customerMobile,
      itemIds: cart.items.map((i) => i.id).toList(),
      discount: cart.discount,
      paymentMode: cart.paymentMode,
    );
    result.when(
      success: (order) => emit(NewSaleSuccess(order: order)),
      failure: (e) => emit(NewSaleError(message: e.message)),
    );
  }

  NewSaleCartState _currentCart() {
    final s = state;
    if (s is NewSaleCartState) return s;
    return _initialCart();
  }
}
