import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import 'customer_list_event.dart';
import 'customer_list_state.dart';

@injectable
class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  CustomerListBloc({required CustomerRepository repository})
      : _repository = repository,
        super(const CustomerListInitial()) {
    on<LoadCustomerList>(_onLoad);
    on<FilterCustomerByStatus>(_onFilter);
    on<SearchCustomerList>(_onSearch);
    on<RefreshCustomerList>(_onRefresh);
  }

  final CustomerRepository _repository;

  List<Customer> _allCustomers = [];
  bool? _activeFilter;
  String _searchQuery = '';

  Future<void> _onLoad(
    LoadCustomerList event,
    Emitter<CustomerListState> emit,
  ) async {
    emit(const CustomerListLoading());
    final result = await _repository.getCustomerList();
    result.when(
      success: (list) {
        _allCustomers = list;
        emit(_buildLoaded());
      },
      failure: (error) => emit(CustomerListError(error.message)),
    );
  }

  Future<void> _onFilter(
    FilterCustomerByStatus event,
    Emitter<CustomerListState> emit,
  ) async {
    _activeFilter = event.activeOnly;
    _searchQuery = '';
    if (_allCustomers.isEmpty) {
      emit(const CustomerListLoading());
      final result = await _repository.getCustomerList();
      result.when(
        success: (list) {
          _allCustomers = list;
          emit(_buildLoaded());
        },
        failure: (error) => emit(CustomerListError(error.message)),
      );
    } else {
      emit(_buildLoaded());
    }
  }

  Future<void> _onSearch(
    SearchCustomerList event,
    Emitter<CustomerListState> emit,
  ) async {
    _searchQuery = event.query;
    if (event.query.isEmpty) {
      if (_allCustomers.isNotEmpty) {
        emit(_buildLoaded());
      } else {
        emit(const CustomerListLoading());
        final result = await _repository.getCustomerList();
        result.when(
          success: (list) {
            _allCustomers = list;
            emit(_buildLoaded());
          },
          failure: (error) => emit(CustomerListError(error.message)),
        );
      }
      return;
    }
    // Search via API (may return richer results from backend)
    final result = await _repository.searchCustomers(event.query);
    result.when(
      success: (list) {
        final activeCount = _allCustomers.isEmpty
            ? list.where((c) => c.isActive).length
            : _allCustomers.where((c) => c.isActive).length;
        final inactiveCount = _allCustomers.isEmpty
            ? list.where((c) => !c.isActive).length
            : _allCustomers.where((c) => !c.isActive).length;
        emit(
          CustomerListLoaded(
            displayList: list,
            totalCount: _allCustomers.isEmpty ? list.length : _allCustomers.length,
            activeCount: activeCount,
            inactiveCount: inactiveCount,
            activeFilter: _activeFilter,
            searchQuery: _searchQuery,
          ),
        );
      },
      failure: (error) => emit(CustomerListError(error.message)),
    );
  }

  Future<void> _onRefresh(
    RefreshCustomerList event,
    Emitter<CustomerListState> emit,
  ) async {
    final result = await _repository.getCustomerList();
    result.when(
      success: (list) {
        _allCustomers = list;
        emit(_buildLoaded());
      },
      failure: (error) => emit(CustomerListError(error.message)),
    );
  }

  CustomerListLoaded _buildLoaded() {
    final q = _searchQuery.toLowerCase();
    var display = _allCustomers.toList();

    if (_activeFilter != null) {
      display = display.where((c) => c.isActive == _activeFilter).toList();
    }
    if (q.isNotEmpty) {
      display = display.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.nameEn.toLowerCase().contains(q) ||
            c.mobile.contains(q) ||
            c.digitalCustomerId.toLowerCase().contains(q);
      }).toList();
    }

    final activeCount = _allCustomers.where((c) => c.isActive).length;
    return CustomerListLoaded(
      displayList: display,
      totalCount: _allCustomers.length,
      activeCount: activeCount,
      inactiveCount: _allCustomers.length - activeCount,
      activeFilter: _activeFilter,
      searchQuery: _searchQuery,
    );
  }
}
