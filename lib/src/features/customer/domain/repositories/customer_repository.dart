import '../../../../core/errors/result.dart';
import '../entities/customer.dart';

/// Customer repository contract.
abstract class CustomerRepository {
  Future<Result<List<Customer>>> getCustomers();
  Future<Result<Customer>> getCustomerById(String id);
  Future<Result<List<Customer>>> searchCustomers(String query);
}
