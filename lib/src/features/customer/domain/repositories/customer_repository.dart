import '../../../../core/errors/result.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Result<List<Customer>>> getCustomerList({
    bool? activeOnly,
    String? searchQuery,
  });

  Future<Result<Customer>> getCustomerById(String id);

  Future<Result<List<Customer>>> searchCustomers(String query);

  Future<Result<Customer>> createCustomer(CreateCustomerRequest request);

  Future<Result<Customer>> updateCustomer(UpdateCustomerRequest request);
}
