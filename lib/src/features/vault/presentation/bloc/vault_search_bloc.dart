import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/vault_repository.dart';
import 'vault_search_event.dart';
import 'vault_search_state.dart';

@injectable
class VaultSearchBloc extends Bloc<VaultSearchEvent, VaultSearchState> {
  VaultSearchBloc({required VaultRepository repository})
      : _repository = repository,
        super(const VaultSearchInitial()) {
    on<VaultSearchStarted>(_onStarted);
    on<VaultSearchQueryChanged>(_onQueryChanged);
    on<VaultSearchRefreshed>(_onRefreshed);
  }

  final VaultRepository _repository;

  Future<void> _onStarted(
    VaultSearchStarted event,
    Emitter<VaultSearchState> emit,
  ) async {
    emit(const VaultSearchLoading());
    await _loadOccupancy(emit, query: '', searchMode: 'Girvi ID');
  }

  Future<void> _onQueryChanged(
    VaultSearchQueryChanged event,
    Emitter<VaultSearchState> emit,
  ) async {
    if (state is! VaultSearchReady) return;
    final current = state as VaultSearchReady;

    if (event.query.isEmpty) {
      emit(current.copyWith(
        query: '',
        searchMode: event.searchMode,
        clearResults: true,
      ));
      return;
    }

    emit(current.copyWith(
      query: event.query,
      searchMode: event.searchMode,
      isSearching: true,
      clearResults: true,
    ));

    final result = await _repository.searchVault(
      query: event.query,
      searchMode: event.searchMode,
    );

    result.when(
      success: (results) => emit(current.copyWith(
        query: event.query,
        searchMode: event.searchMode,
        searchResults: results,
        isSearching: false,
      )),
      failure: (error) => emit(current.copyWith(
        query: event.query,
        searchMode: event.searchMode,
        isSearching: false,
        clearResults: true,
      )),
    );
  }

  Future<void> _onRefreshed(
    VaultSearchRefreshed event,
    Emitter<VaultSearchState> emit,
  ) async {
    final current = state is VaultSearchReady
        ? state as VaultSearchReady
        : null;
    await _loadOccupancy(
      emit,
      query: current?.query ?? '',
      searchMode: current?.searchMode ?? 'Girvi ID',
    );
  }

  Future<void> _loadOccupancy(
    Emitter<VaultSearchState> emit, {
    required String query,
    required String searchMode,
  }) async {
    final result = await _repository.getOccupancy();
    result.when(
      success: (occupancy) => emit(VaultSearchReady(
        occupancy: occupancy,
        query: query,
        searchMode: searchMode,
      )),
      failure: (error) => emit(VaultSearchError(error.message)),
    );
  }
}
