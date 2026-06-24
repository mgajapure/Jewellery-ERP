import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/girvi.dart';
import '../../domain/repositories/girvi_repository.dart';
import '../models/girvi_model.dart';

@LazySingleton(as: GirviRepository)
class GirviRepositoryImpl implements GirviRepository {
  GirviRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<List<Girvi>>> getGirviList({
    GirviStatus? statusFilter,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (statusFilter != null) queryParams['status'] = statusFilter.name;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }
      final response = await _apiClient.get(
        ApiEndpoints.girvi,
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map(
            (e) =>
                GirviModel.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Girvi>> getGirviById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.girviById(id));
      final data = response.data as Map<String, dynamic>;
      final girvi = GirviModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(girvi);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Girvi>>> getDueGirvi() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.girviDue);
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map(
            (e) =>
                GirviModel.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Girvi>>> getOverdueGirvi() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.girviOverdue);
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List<dynamic>)
          .map(
            (e) =>
                GirviModel.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
      return Result.success(list);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> makePayment(
    String girviId,
    PaymentRequest request,
  ) async {
    try {
      await _apiClient.post(
        ApiEndpoints.girviPayment(girviId),
        data: {
          'amount': request.amount,
          'paymentType': request.paymentType.name,
          if (request.referenceNumber != null)
            'referenceNumber': request.referenceNumber,
          if (request.notes != null) 'notes': request.notes,
        },
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Girvi>> renewGirvi(
    String girviId,
    RenewalRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.girviRenewal(girviId),
        data: {
          'newLoanAmount': request.newLoanAmount,
          'interestRate': request.interestRate,
          'months': request.months,
          'interestType': request.interestType.name,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final girvi = GirviModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(girvi);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> redeemGirvi(String girviId) async {
    try {
      await _apiClient.post(ApiEndpoints.girviRedemption(girviId));
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> completeAuction(
    String girviId,
    AuctionRequest request,
  ) async {
    try {
      await _apiClient.post(
        ApiEndpoints.girviAuction(girviId),
        data: {
          'saleAmount': request.saleAmount,
          'buyerName': request.buyerName,
          if (request.buyerMobile != null) 'buyerMobile': request.buyerMobile,
        },
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Result<Girvi>> createGirvi(CreateGirviRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.girvi,
        data: {
          'customerId': request.customerId,
          'loanAmount': request.loanAmount,
          'interestRate': request.interestRate,
          'interestType': request.interestType.name,
          'startDate': request.startDate.toIso8601String(),
          'dueDate': request.dueDate.toIso8601String(),
          'penaltyRate': request.penaltyRate,
          if (request.vaultLocation != null) 'vaultLocation': request.vaultLocation,
          'items': request.items.map((item) => {
            'itemType': item.itemType,
            'description': item.description,
            'quantity': item.quantity,
            'grossWeightG': item.grossWeightG,
            'stoneWeightG': item.stoneWeightG,
            'netWeightG': item.netWeightG,
            'purity': item.purity,
            'metalType': item.metalType.name,
            'photoPaths': item.photoPaths,
          }).toList(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      final girvi = GirviModel.fromJson(
        data['data'] as Map<String, dynamic>,
      ).toEntity();
      return Result.success(girvi);
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
          message:
              error.response?.statusMessage ?? 'Server error occurred.',
        );
      default:
        return ServerException(message: error.message ?? 'Unknown error');
    }
  }
}
