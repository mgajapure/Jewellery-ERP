import 'package:equatable/equatable.dart';

import '../../domain/entities/customer.dart';

sealed class CustomerDetailState extends Equatable {
  const CustomerDetailState();

  @override
  List<Object?> get props => [];
}

class CustomerDetailInitial extends CustomerDetailState {
  const CustomerDetailInitial();
}

class CustomerDetailLoading extends CustomerDetailState {
  const CustomerDetailLoading();
}

class CustomerDetailLoaded extends CustomerDetailState {
  const CustomerDetailLoaded(this.customer);

  final Customer customer;

  @override
  List<Object?> get props => [customer];
}

class CustomerDetailError extends CustomerDetailState {
  const CustomerDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CustomerOperationLoading extends CustomerDetailState {
  const CustomerOperationLoading(this.customer);

  final Customer? customer;

  @override
  List<Object?> get props => [customer];
}

class CustomerOperationSuccess extends CustomerDetailState {
  const CustomerOperationSuccess(this.customer, this.message);

  final Customer customer;
  final String message;

  @override
  List<Object?> get props => [customer, message];
}

class CustomerOperationFailure extends CustomerDetailState {
  const CustomerOperationFailure(this.message, {this.customer});

  final String message;
  final Customer? customer;

  @override
  List<Object?> get props => [message, customer];
}
