import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/customer_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

@injectable
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc({required CustomerRepository repository})
      : _repository = repository,
        super(const CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<SearchCustomers>(_onSearchCustomers);
    on<RefreshCustomers>(_onRefreshCustomers);
  }

  final CustomerRepository _repository;

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    emit(const CustomerLoading());
    final result = await _repository.getCustomers();
    result.when(
      success: (customers) => emit(CustomersLoaded(customers)),
      failure: (error) => emit(CustomerError(error.message)),
    );
  }

  Future<void> _onSearchCustomers(
    SearchCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadCustomers());
      return;
    }

    emit(const CustomerLoading());
    final result = await _repository.searchCustomers(event.query);
    result.when(
      success: (customers) => emit(CustomersLoaded(customers)),
      failure: (error) => emit(CustomerError(error.message)),
    );
  }

  Future<void> _onRefreshCustomers(
    RefreshCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    final result = await _repository.getCustomers();
    result.when(
      success: (customers) => emit(CustomersLoaded(customers)),
      failure: (error) => emit(CustomerError(error.message)),
    );
  }
}
