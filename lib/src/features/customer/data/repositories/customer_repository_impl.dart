import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../models/customer_model.dart';

@LazySingleton(as: CustomerRepository)
class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<List<Customer>>> getCustomerList({
    bool? activeOnly,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (activeOnly != null) queryParams['active'] = activeOnly;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      final response = await _apiClient.get(
        ApiEndpoints.customers,
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Customer>> getCustomerById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.customerById(id));
      final data = response.data as Map<String, dynamic>;
      final customer = CustomerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(customer);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Customer>>> searchCustomers(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.customers,
        queryParameters: {'search': query},
      );
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Customer>> createCustomer(CreateCustomerRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.customers,
        data: {
          'name': request.name,
          'mobile': request.mobile,
          if (request.alternateMobile != null)
            'alternateMobile': request.alternateMobile,
          'address': request.address,
          'city': request.city,
          'state': request.state,
          'pincode': request.pincode,
          if (request.gender != null) 'gender': request.gender,
          if (request.dateOfBirth != null) 'dateOfBirth': request.dateOfBirth,
          if (request.aadhaarNumber != null)
            'aadhaarNumber': request.aadhaarNumber,
          if (request.panNumber != null) 'panNumber': request.panNumber,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final customer = CustomerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(customer);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Customer>> updateCustomer(
      UpdateCustomerRequest request) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.customerById(request.id),
        data: {
          'name': request.name,
          if (request.alternateMobile != null)
            'alternateMobile': request.alternateMobile,
          'address': request.address,
          'city': request.city,
          'state': request.state,
          'pincode': request.pincode,
          if (request.gender != null) 'gender': request.gender,
          if (request.dateOfBirth != null) 'dateOfBirth': request.dateOfBirth,
          if (request.panNumber != null) 'panNumber': request.panNumber,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final customer = CustomerModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(customer);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  AppException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return const AuthException(
            message: 'Session expired. Please login again.',
          );
        }
        if (statusCode == 404) return const NotFoundException();
        return ServerException(
          message: error.response?.statusMessage ?? 'Server error occurred.',
        );
      default:
        return ServerException(message: error.message ?? 'Unknown error');
    }
  }
}
