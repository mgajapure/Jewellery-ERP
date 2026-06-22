import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../constants/api_config.dart';
import '../storage/secure_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/device_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/mock_interceptor.dart';

/// Production-ready HTTP client.
///
/// [MockInterceptor] is currently active so the app can run without a backend.
/// When the backend is ready:
///   1. Update [ApiConfig.baseUrl]
///   2. Set [ApiConfig.useMockData] to false
@lazySingleton
class ApiClient {
  ApiClient({required SecureStorage secureStorage})
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            headers: const {'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.addAll([
      AuthInterceptor(secureStorage: secureStorage),
      DeviceInterceptor(secureStorage: secureStorage),
      if (ApiConfig.useMockData) MockInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
