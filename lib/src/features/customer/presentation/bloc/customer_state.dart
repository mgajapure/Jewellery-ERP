import 'package:equatable/equatable.dart';

import '../../domain/entities/customer.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomersLoaded extends CustomerState {
  const CustomersLoaded(this.customers, {this.hasReachedMax = false});

  final List<Customer> customers;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [customers, hasReachedMax];
}

class CustomerError extends CustomerState {
  const CustomerError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
