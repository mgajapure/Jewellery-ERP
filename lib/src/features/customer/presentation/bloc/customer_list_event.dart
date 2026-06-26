import 'package:equatable/equatable.dart';

sealed class CustomerListEvent extends Equatable {
  const CustomerListEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerList extends CustomerListEvent {
  const LoadCustomerList();
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
