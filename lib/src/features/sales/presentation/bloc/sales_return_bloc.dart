import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/sale_order.dart';
import '../../domain/repositories/sales_repository.dart';

part 'sales_return_event.dart';
part 'sales_return_state.dart';

@injectable
class SalesReturnBloc extends Bloc<SalesReturnEvent, SalesReturnState> {
  SalesReturnBloc({required this.repository}) : super(SalesReturnInitial()) {
    on<SalesReturnInvoiceLookupStarted>(_onLookup);
    on<SalesReturnItemToggled>(_onItemToggled);
    on<SalesReturnSubmitted>(_onSubmitted);
  }

  final SalesRepository repository;

  Future<void> _onLookup(
    SalesReturnInvoiceLookupStarted event,
    Emitter<SalesReturnState> emit,
  ) async {
    emit(SalesReturnLookupLoading());
    final result = await repository.lookupInvoice(event.invoiceNo);
    result.when(
      success: (order) => emit(
        SalesReturnLookupLoaded(order: order, selectedItemIds: const {}),
      ),
      failure: (e) => emit(SalesReturnError(message: e.message)),
    );
  }

  void _onItemToggled(
    SalesReturnItemToggled event,
    Emitter<SalesReturnState> emit,
  ) {
    final current = state;
    if (current is! SalesReturnLookupLoaded) return;
    final ids = Set<String>.from(current.selectedItemIds);
    if (ids.contains(event.itemId)) {
      ids.remove(event.itemId);
    } else {
      ids.add(event.itemId);
    }
    emit(current.copyWith(selectedItemIds: ids));
  }

  Future<void> _onSubmitted(
    SalesReturnSubmitted event,
    Emitter<SalesReturnState> emit,
  ) async {
    final current = state;
    if (current is! SalesReturnLookupLoaded) return;
    emit(SalesReturnSubmitting());
    final result = await repository.processReturn(
      invoiceNo: current.order.invoiceNo,
      itemIds: current.selectedItemIds.toList(),
      reason: event.reason,
      returnType: event.returnType,
      inventoryStatus: event.inventoryStatus,
    );
    result.when(
      success: (_) => emit(SalesReturnSuccess()),
      failure: (e) => emit(SalesReturnError(message: e.message)),
    );
  }
}
