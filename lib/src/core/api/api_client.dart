import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';
import 'interceptors/mock_interceptor.dart';

class ApiClient {
  ApiClient({required SecureStorage secureStorage, Dio? dio})
      : _secureStorage = secureStorage,
        _dio = dio ?? _buildDio();

  // ignore: unused_field — reserved for auth-header injection when backend is live
  final SecureStorage _secureStorage;
  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com/api/v1',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(MockInterceptor());
    return dio;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put<T>(path, data: data);

  Future<Response<T>> patch<T>(String path, {dynamic data}) =>
      _dio.patch<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);
}
