import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/sale_order.dart';
import '../../domain/repositories/sales_repository.dart';

part 'sales_ledger_event.dart';
part 'sales_ledger_state.dart';

@injectable
class SalesLedgerBloc extends Bloc<SalesLedgerEvent, SalesLedgerState> {
  SalesLedgerBloc({required this.repository}) : super(SalesLedgerInitial()) {
    on<SalesLedgerStarted>(_onStarted);
    on<SalesLedgerFilterChanged>(_onFilterChanged);
    on<SalesLedgerSearchChanged>(_onSearchChanged);
    on<SalesLedgerRefreshed>(_onRefreshed);
  }

  final SalesRepository repository;

  Future<void> _onStarted(
    SalesLedgerStarted event,
    Emitter<SalesLedgerState> emit,
  ) async {
    emit(SalesLedgerLoading());
    await _load(emit, filter: '', query: '');
  }

  Future<void> _onFilterChanged(
    SalesLedgerFilterChanged event,
    Emitter<SalesLedgerState> emit,
  ) async {
    final current = state;
    final query = current is SalesLedgerLoaded ? current.query : '';
    emit(SalesLedgerLoading());
    await _load(emit, filter: event.filter, query: query);
  }

  Future<void> _onSearchChanged(
    SalesLedgerSearchChanged event,
    Emitter<SalesLedgerState> emit,
  ) async {
    final current = state;
    final filter = current is SalesLedgerLoaded ? current.filter : '';
    emit(SalesLedgerLoading());
    await _load(emit, filter: filter, query: event.query);
  }

  Future<void> _onRefreshed(
    SalesLedgerRefreshed event,
    Emitter<SalesLedgerState> emit,
  ) async {
    final current = state;
    final filter = current is SalesLedgerLoaded ? current.filter : '';
    final query = current is SalesLedgerLoaded ? current.query : '';
    await _load(emit, filter: filter, query: query);
  }

  Future<void> _load(
    Emitter<SalesLedgerState> emit, {
    required String filter,
    required String query,
  }) async {
    final result = await repository.getLedger(
      filter: filter.isNotEmpty ? filter : null,
      query: query.isNotEmpty ? query : null,
    );
    result.when(
      success: (orders) => emit(
        SalesLedgerLoaded(orders: orders, filter: filter, query: query),
      ),
      failure: (e) => emit(SalesLedgerError(message: e.message)),
    );
  }
}
