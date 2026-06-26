import 'package:equatable/equatable.dart';

import '../../domain/entities/customer.dart';

sealed class CustomerListEvent extends Equatable {
  const CustomerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerList extends CustomerListEvent {
  const LoadCustomerList();
}

class PreloadCustomerList extends CustomerListEvent {
  const PreloadCustomerList(this.customers);

  final List<Customer> customers;

  @override
  List<Object?> get props => [customers];
}

class FilterCustomerByStatus extends CustomerListEvent {
  const FilterCustomerByStatus(this.activeOnly);

  final bool? activeOnly;

  @override
  List<Object?> get props => [activeOnly];
}

class SearchCustomerList extends CustomerListEvent {
  const SearchCustomerList(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class RefreshCustomerList extends CustomerListEvent {
  const RefreshCustomerList();
}
