import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/girvi.dart';
import '../../domain/repositories/girvi_repository.dart';
import 'girvi_list_event.dart';
import 'girvi_list_state.dart';

@injectable
class GirviListBloc extends Bloc<GirviListEvent, GirviListState> {
  GirviListBloc({required GirviRepository repository})
      : _repository = repository,
        super(const GirviListInitial()) {
    on<LoadGirviList>(_onLoadGirviList);
    on<FilterGirviByStatus>(_onFilterByStatus);
    on<SearchGirviList>(_onSearch);
    on<RefreshGirviList>(_onRefresh);
  }

  final GirviRepository _repository;
  GirviStatus? _activeFilter;
  String _searchQuery = '';

  Future<void> _onLoadGirviList(
    LoadGirviList event,
    Emitter<GirviListState> emit,
  ) async {
    emit(const GirviListLoading());
    final result = await _repository.getGirviList(
      statusFilter: _activeFilter,
      searchQuery: _searchQuery,
    );
    result.when(
      success: (list) => emit(
        GirviListLoaded(
          girviList: list,
          activeFilter: _activeFilter,
          searchQuery: _searchQuery,
        ),
      ),
      failure: (error) => emit(GirviListError(error.message)),
    );
  }

  Future<void> _onFilterByStatus(
    FilterGirviByStatus event,
    Emitter<GirviListState> emit,
  ) async {
    _activeFilter = event.status;
    emit(const GirviListLoading());
    final result = await _repository.getGirviList(
      statusFilter: _activeFilter,
      searchQuery: _searchQuery,
    );
    result.when(
      success: (list) => emit(
        GirviListLoaded(
          girviList: list,
          activeFilter: _activeFilter,
          searchQuery: _searchQuery,
        ),
      ),
      failure: (error) => emit(GirviListError(error.message)),
    );
  }

  Future<void> _onSearch(
    SearchGirviList event,
    Emitter<GirviListState> emit,
  ) async {
    _searchQuery = event.query;
    final result = await _repository.getGirviList(
      statusFilter: _activeFilter,
      searchQuery: _searchQuery,
    );
    result.when(
      success: (list) => emit(
        GirviListLoaded(
          girviList: list,
          activeFilter: _activeFilter,
          searchQuery: _searchQuery,
        ),
      ),
      failure: (error) => emit(GirviListError(error.message)),
    );
  }

  Future<void> _onRefresh(
    RefreshGirviList event,
    Emitter<GirviListState> emit,
  ) async {
    final result = await _repository.getGirviList(
      statusFilter: _activeFilter,
      searchQuery: _searchQuery,
    );
    result.when(
      success: (list) => emit(
        GirviListLoaded(
          girviList: list,
          activeFilter: _activeFilter,
          searchQuery: _searchQuery,
        ),
      ),
      failure: (error) => emit(GirviListError(error.message)),
    );
  }
}
