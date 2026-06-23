import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/purchase_entry.dart';
import '../../domain/repositories/purchase_repository.dart';

part 'new_purchase_event.dart';
part 'new_purchase_state.dart';

@injectable
class NewPurchaseBloc extends Bloc<NewPurchaseEvent, NewPurchaseState> {
  NewPurchaseBloc({required PurchaseRepository repository})
      : _repository = repository,
        super(const NewPurchaseInitial()) {
    on<NewPurchaseSubmitted>(_onSubmitted);
  }

  final PurchaseRepository _repository;

  Future<void> _onSubmitted(
    NewPurchaseSubmitted event,
    Emitter<NewPurchaseState> emit,
  ) async {
    emit(const NewPurchaseSubmitting());
    final result = await _repository.createPurchase(
      supplierName: event.supplierName,
      supplierMobile: event.supplierMobile,
      billNo: event.billNo,
      purchaseType: event.purchaseType,
      metalType: event.metalType,
      itemName: event.itemName,
      grossWeight: event.grossWeight,
      netWeight: event.netWeight,
      purity: event.purity,
      rate: event.rate,
      amount: event.amount,
      paymentMode: event.paymentMode,
    );
    result.when(
      success: (entry) => emit(NewPurchaseSuccess(entry)),
      failure: (e) => emit(NewPurchaseError(e.message)),
    );
  }
}
