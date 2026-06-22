import 'package:equatable/equatable.dart';

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {
  const LoadCustomers();
}

class SearchCustomers extends CustomerEvent {
  const SearchCustomers(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class RefreshCustomers extends CustomerEvent {
  const RefreshCustomers();
}
