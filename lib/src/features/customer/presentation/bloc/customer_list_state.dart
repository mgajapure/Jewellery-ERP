import 'package:equatable/equatable.dart';

import '../../domain/entities/customer.dart';

sealed class CustomerListState extends Equatable {
  const CustomerListState();

  @override
  List<Object?> get props => [];
}

class CustomerListInitial extends CustomerListState {
  const CustomerListInitial();
}

class CustomerListLoading extends CustomerListState {
  const CustomerListLoading();
}

class CustomerListLoaded extends CustomerListState {
  const CustomerListLoaded({
    required this.displayList,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    this.activeFilter,
    this.searchQuery = '',
  });

  final List<Customer> displayList;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  /// null = All, true = Active, false = Inactive
  final bool? activeFilter;
  final String searchQuery;

  @override
  List<Object?> get props => [
    displayList,
    totalCount,
    activeCount,
    inactiveCount,
    activeFilter,
    searchQuery,
  ];
}

class CustomerListError extends CustomerListState {
  const CustomerListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
