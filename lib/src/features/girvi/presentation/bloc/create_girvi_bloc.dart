import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/girvi_repository.dart';
import 'create_girvi_event.dart';
import 'create_girvi_state.dart';

class CreateGirviBloc extends Bloc<CreateGirviEvent, CreateGirviState> {
  CreateGirviBloc({required GirviRepository repository})
      : _repository = repository,
        super(CreateGirviDraft(
          startDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
        )) {
    on<CreateGirviCustomerSelected>(_onCustomerSelected);
    on<CreateGirviItemAdded>(_onItemAdded);
    on<CreateGirviItemRemoved>(_onItemRemoved);
    on<CreateGirviItemUpdated>(_onItemUpdated);
    on<CreateGirviItemPhotoAdded>(_onItemPhotoAdded);
    on<CreateGirviItemPhotoRemoved>(_onItemPhotoRemoved);
    on<CreateGirviLtvSelected>(_onLtvSelected);
    on<CreateGirviLoanAmountOverridden>(_onLoanAmountOverridden);
    on<CreateGirviLoanTermsUpdated>(_onLoanTermsUpdated);
    on<CreateGirviKfsAccepted>(_onKfsAccepted);
    on<CreateGirviVaultSelected>(_onVaultSelected);
    on<CreateGirviSubmitted>(_onSubmitted);
  }

  final GirviRepository _repository;

  CreateGirviDraft _draft(CreateGirviState s) {
    if (s is CreateGirviDraft) return s;
    if (s is CreateGirviError) return s.draft;
    if (s is CreateGirviSubmitting) return s.draft;
    return CreateGirviDraft(
      startDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
    );
  }

  void _onCustomerSelected(CreateGirviCustomerSelected e, Emitter<CreateGirviState> emit) {
    emit(_draft(state).copyWith(
      customerId: e.customerId,
      customerName: e.customerName,
      customerNameEn: e.customerNameEn,
      customerMobile: e.customerMobile,
    ));
  }

  void _onItemAdded(CreateGirviItemAdded e, Emitter<CreateGirviState> emit) {
    final draft = _draft(state);
    final newItem = GirviItemDraft(id: 'item-${DateTime.now().millisecondsSinceEpoch}');
    emit(draft.copyWith(items: [...draft.items, newItem]));
  }

  void _onItemRemoved(CreateGirviItemRemoved e, Emitter<CreateGirviState> emit) {
    final draft = _draft(state);
    emit(draft.copyWith(items: draft.items.where((i) => i.id != e.itemId).toList()));
  }

  void _onItemUpdated(CreateGirviItemUpdated e, Emitter<CreateGirviState> emit) {
    final draft = _draft(state);
    emit(draft.copyWith(
      items: draft.items.map((i) => i.id == e.item.id ? e.item : i).toList(),
    ));
  }

  void _onItemPhotoAdded(CreateGirviItemPhotoAdded e, Emitter<CreateGirviState> emit) {
    final draft = _draft(state);
    emit(draft.copyWith(
      items: draft.items.map((item) {
        if (item.id != e.itemId) return item;
        return item.copyWith(photoPaths: [...item.photoPaths, e.photoPath]);
      }).toList(),
    ));
  }

  void _onItemPhotoRemoved(CreateGirviItemPhotoRemoved e, Emitter<CreateGirviState> emit) {
    final draft = _draft(state);
    emit(draft.copyWith(
      items: draft.items.map((item) {
        if (item.id != e.itemId) return item;
        final photos = List<String>.from(item.photoPaths);
        if (e.photoIndex < photos.length) photos.removeAt(e.photoIndex);
        return item.copyWith(photoPaths: photos);
      }).toList(),
    ));
  }

  void _onLtvSelected(CreateGirviLtvSelected e, Emitter<CreateGirviState> emit) {
    emit(_draft(state).copyWith(selectedLtvPercent: e.ltvPercent, manualLoanAmount: null));
  }

  void _onLoanAmountOverridden(CreateGirviLoanAmountOverridden e, Emitter<CreateGirviState> emit) {
    emit(_draft(state).copyWith(manualLoanAmount: e.amount));
  }

  void _onLoanTermsUpdated(CreateGirviLoanTermsUpdated e, Emitter<CreateGirviState> emit) {
    final draft = _draft(state);
    emit(draft.copyWith(
      interestRate: e.interestRate ?? draft.interestRate,
      interestType: e.interestType ?? draft.interestType,
      dueDate: e.dueDate ?? draft.dueDate,
      penaltyRate: e.penaltyRate ?? draft.penaltyRate,
    ));
  }

  void _onKfsAccepted(CreateGirviKfsAccepted e, Emitter<CreateGirviState> emit) {
    emit(_draft(state).copyWith(kfsAccepted: e.accepted));
  }

  void _onVaultSelected(CreateGirviVaultSelected e, Emitter<CreateGirviState> emit) {
    emit(_draft(state).copyWith(vaultLocation: e.vaultLocation));
  }

  Future<void> _onSubmitted(CreateGirviSubmitted e, Emitter<CreateGirviState> emit) async {
    final draft = _draft(state);
    emit(CreateGirviSubmitting(draft));

    final request = CreateGirviRequest(
      customerId: draft.customerId ?? 'cust-001',
      items: draft.items.map((item) => GirviItemRequest(
        itemType: item.itemType,
        description: item.description,
        quantity: item.quantity,
        grossWeightG: item.grossWeightG,
        stoneWeightG: item.stoneWeightG,
        netWeightG: item.netWeightG,
        purity: item.purity,
        metalType: item.metalType,
        photoPaths: item.photoPaths,
      )).toList(),
      loanAmount: draft.effectiveLoanAmount,
      interestRate: draft.interestRate,
      interestType: draft.interestType,
      startDate: draft.startDate,
      dueDate: draft.dueDate,
      penaltyRate: draft.penaltyRate,
      vaultLocation: draft.vaultLocation,
    );

    final result = await _repository.createGirvi(request);
    result.when(
      success: (girvi) => emit(CreateGirviSuccess(girvi)),
      failure: (error) => emit(CreateGirviError(message: error.message, draft: draft)),
    );
  }
}
