import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/purchase_entry.dart';
import '../../domain/repositories/purchase_repository.dart';

part 'purchase_ledger_event.dart';
part 'purchase_ledger_state.dart';

@injectable
class PurchaseLedgerBloc
    extends Bloc<PurchaseLedgerEvent, PurchaseLedgerState> {
  PurchaseLedgerBloc({required PurchaseRepository repository})
      : _repository = repository,
        super(const PurchaseLedgerInitial()) {
    on<PurchaseLedgerStarted>(_onStarted);
    on<PurchaseLedgerFilterChanged>(_onFilterChanged);
    on<PurchaseLedgerSearchChanged>(_onSearchChanged);
    on<PurchaseLedgerRefreshed>(_onRefreshed);
  }

  final PurchaseRepository _repository;

  Future<void> _onStarted(
    PurchaseLedgerStarted event,
    Emitter<PurchaseLedgerState> emit,
  ) async {
    emit(const PurchaseLedgerLoading());
    await _load(emit, filter: '', query: '');
  }

  Future<void> _onFilterChanged(
    PurchaseLedgerFilterChanged event,
    Emitter<PurchaseLedgerState> emit,
  ) async {
    final current = state;
    final query = current is PurchaseLedgerLoaded ? current.query : '';
    emit(const PurchaseLedgerLoading());
    await _load(emit, filter: event.filter, query: query);
  }

  Future<void> _onSearchChanged(
    PurchaseLedgerSearchChanged event,
    Emitter<PurchaseLedgerState> emit,
  ) async {
    final current = state;
    final filter = current is PurchaseLedgerLoaded ? current.filter : '';
    emit(const PurchaseLedgerLoading());
    await _load(emit, filter: filter, query: event.query);
  }

  Future<void> _onRefreshed(
    PurchaseLedgerRefreshed event,
    Emitter<PurchaseLedgerState> emit,
  ) async {
    final current = state;
    final filter = current is PurchaseLedgerLoaded ? current.filter : '';
    final query = current is PurchaseLedgerLoaded ? current.query : '';
    await _load(emit, filter: filter, query: query);
  }

  Future<void> _load(
    Emitter<PurchaseLedgerState> emit, {
    required String filter,
    required String query,
  }) async {
    final result = await _repository.getLedger(
      filter: filter.isEmpty ? null : filter,
      query: query.isEmpty ? null : query,
    );
    result.when(
      success: (entries) => emit(PurchaseLedgerLoaded(
        entries: entries,
        filter: filter,
        query: query,
      )),
      failure: (e) => emit(PurchaseLedgerError(e.message)),
    );
  }
}
