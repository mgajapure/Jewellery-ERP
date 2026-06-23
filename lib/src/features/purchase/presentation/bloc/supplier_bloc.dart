import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/supplier.dart';
import '../../domain/repositories/purchase_repository.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

@injectable
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc({required PurchaseRepository repository})
      : _repository = repository,
        super(const SupplierInitial()) {
    on<SupplierListStarted>(_onStarted);
    on<SupplierFilterChanged>(_onFilterChanged);
    on<SupplierSearchChanged>(_onSearchChanged);
    on<SupplierListRefreshed>(_onRefreshed);
  }

  final PurchaseRepository _repository;

  Future<void> _onStarted(
    SupplierListStarted event,
    Emitter<SupplierState> emit,
  ) async {
    emit(const SupplierLoading());
    await _load(emit, filter: '', query: '');
  }

  Future<void> _onFilterChanged(
    SupplierFilterChanged event,
    Emitter<SupplierState> emit,
  ) async {
    final current = state;
    final query = current is SupplierLoaded ? current.query : '';
    emit(const SupplierLoading());
    await _load(emit, filter: event.filter, query: query);
  }

  Future<void> _onSearchChanged(
    SupplierSearchChanged event,
    Emitter<SupplierState> emit,
  ) async {
    final current = state;
    final filter = current is SupplierLoaded ? current.filter : '';
    emit(const SupplierLoading());
    await _load(emit, filter: filter, query: event.query);
  }

  Future<void> _onRefreshed(
    SupplierListRefreshed event,
    Emitter<SupplierState> emit,
  ) async {
    final current = state;
    final filter = current is SupplierLoaded ? current.filter : '';
    final query = current is SupplierLoaded ? current.query : '';
    await _load(emit, filter: filter, query: query);
  }

  Future<void> _load(
    Emitter<SupplierState> emit, {
    required String filter,
    required String query,
  }) async {
    final result = await _repository.getSuppliers(
      filter: filter.isEmpty ? null : filter,
      query: query.isEmpty ? null : query,
    );
    result.when(
      success: (suppliers) => emit(SupplierLoaded(
        suppliers: suppliers,
        filter: filter,
        query: query,
      )),
      failure: (e) => emit(SupplierError(e.message)),
    );
  }
}
