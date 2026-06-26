import 'package:equatable/equatable.dart';

import '../../domain/entities/customer.dart';

sealed class CustomerDetailEvent extends Equatable {
  const CustomerDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerDetail extends CustomerDetailEvent {
  const LoadCustomerDetail(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class PreloadCustomerDetail extends CustomerDetailEvent {
  const PreloadCustomerDetail(this.customer);

  final Customer customer;

  @override
  List<Object?> get props => [customer];
}

class CreateCustomer extends CustomerDetailEvent {
  const CreateCustomer(this.request);

  final CreateCustomerRequest request;

  @override
  List<Object?> get props => [request];
}

class UpdateCustomer extends CustomerDetailEvent {
  const UpdateCustomer(this.request);

  final UpdateCustomerRequest request;

  @override
  List<Object?> get props => [request];
}
