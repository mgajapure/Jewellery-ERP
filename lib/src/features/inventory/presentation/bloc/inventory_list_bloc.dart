import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_list_event.dart';
part 'inventory_list_state.dart';

@injectable
class InventoryListBloc
    extends Bloc<InventoryListEvent, InventoryListState> {
  InventoryListBloc({required this.repository})
      : super(InventoryListInitial()) {
    on<InventoryListStarted>(_onStarted);
    on<InventoryListFilterChanged>(_onFilterChanged);
    on<InventoryListSearchChanged>(_onSearchChanged);
    on<InventoryListRefreshed>(_onRefreshed);
  }

  final InventoryRepository repository;

  Future<void> _onStarted(
    InventoryListStarted event,
    Emitter<InventoryListState> emit,
  ) async {
    emit(InventoryListLoading());
    await _load(emit, filter: '', query: '');
  }

  Future<void> _onFilterChanged(
    InventoryListFilterChanged event,
    Emitter<InventoryListState> emit,
  ) async {
    final current = state;
    final query = current is InventoryListLoaded ? current.query : '';
    emit(InventoryListLoading());
    await _load(emit, filter: event.filter, query: query);
  }

  Future<void> _onSearchChanged(
    InventoryListSearchChanged event,
    Emitter<InventoryListState> emit,
  ) async {
    final current = state;
    final filter = current is InventoryListLoaded ? current.filter : '';
    emit(InventoryListLoading());
    await _load(emit, filter: filter, query: event.query);
  }

  Future<void> _onRefreshed(
    InventoryListRefreshed event,
    Emitter<InventoryListState> emit,
  ) async {
    final current = state;
    final filter = current is InventoryListLoaded ? current.filter : '';
    final query = current is InventoryListLoaded ? current.query : '';
    await _load(emit, filter: filter, query: query);
  }

  Future<void> _load(
    Emitter<InventoryListState> emit, {
    required String filter,
    required String query,
  }) async {
    final result = await repository.getItems(
      filter: filter.isNotEmpty ? filter : null,
      query: query.isNotEmpty ? query : null,
    );
    result.when(
      success: (items) => emit(
        InventoryListLoaded(items: items, filter: filter, query: query),
      ),
      failure: (e) => emit(InventoryListError(message: e.message)),
    );
  }
}
