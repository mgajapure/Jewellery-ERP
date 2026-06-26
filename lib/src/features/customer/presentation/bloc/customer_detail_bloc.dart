import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/customer_repository.dart';
import 'customer_detail_event.dart';
import 'customer_detail_state.dart';

@injectable
class CustomerDetailBloc
    extends Bloc<CustomerDetailEvent, CustomerDetailState> {
  CustomerDetailBloc({required CustomerRepository repository})
      : _repository = repository,
        super(const CustomerDetailInitial()) {
    on<LoadCustomerDetail>(_onLoad);
    on<PreloadCustomerDetail>((event, emit) => emit(CustomerDetailLoaded(event.customer)));
    on<CreateCustomer>(_onCreate);
    on<UpdateCustomer>(_onUpdate);
  }

  final CustomerRepository _repository;

  Future<void> _onLoad(
    LoadCustomerDetail event,
    Emitter<CustomerDetailState> emit,
  ) async {
    emit(const CustomerDetailLoading());
    final result = await _repository.getCustomerById(event.id);
    result.when(
      success: (customer) => emit(CustomerDetailLoaded(customer)),
      failure: (error) => emit(CustomerDetailError(error.message)),
    );
  }

  Future<void> _onCreate(
    CreateCustomer event,
    Emitter<CustomerDetailState> emit,
  ) async {
    emit(const CustomerOperationLoading(null));
    final result = await _repository.createCustomer(event.request);
    result.when(
      success: (customer) => emit(
        CustomerOperationSuccess(
          customer,
          'ग्राहक यशस्वीरित्या तयार झाला / Customer created successfully',
        ),
      ),
      failure: (error) => emit(CustomerOperationFailure(error.message)),
    );
  }

  Future<void> _onUpdate(
    UpdateCustomer event,
    Emitter<CustomerDetailState> emit,
  ) async {
    final current = switch (state) {
      CustomerDetailLoaded(:final customer) => customer,
      CustomerOperationSuccess(:final customer) => customer,
      CustomerOperationFailure(:final customer) => customer,
      _ => null,
    };
    emit(CustomerOperationLoading(current));
    final result = await _repository.updateCustomer(event.request);
    result.when(
      success: (customer) => emit(
        CustomerOperationSuccess(
          customer,
          'ग्राहक यशस्वीरित्या अपडेट झाला / Customer updated successfully',
        ),
      ),
      failure: (error) =>
          emit(CustomerOperationFailure(error.message, customer: current)),
    );
  }
}
