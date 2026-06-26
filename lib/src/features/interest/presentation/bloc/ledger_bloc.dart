import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/interest_repository.dart';
import 'ledger_event.dart';
import 'ledger_state.dart';

@injectable
class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  LedgerBloc({required InterestRepository repository})
      : _repository = repository,
        super(const LedgerInitial()) {
    on<LedgerLoadRequested>(_onLoad);
    on<LedgerRefreshRequested>(_onRefresh);
  }

  final InterestRepository _repository;

  Future<void> _onLoad(
    LedgerLoadRequested event,
    Emitter<LedgerState> emit,
  ) async {
    emit(const LedgerLoading());
    final result = await _repository.getLedger(event.girviId);
    result.when(
      success: (ledger) => emit(LedgerLoaded(ledger)),
      failure: (error) => emit(LedgerError(error.message)),
    );
  }

  Future<void> _onRefresh(
    LedgerRefreshRequested event,
    Emitter<LedgerState> emit,
  ) async {
    final result = await _repository.getLedger(event.girviId);
    result.when(
      success: (ledger) => emit(LedgerLoaded(ledger)),
      failure: (error) => emit(LedgerError(error.message)),
    );
  }
}
