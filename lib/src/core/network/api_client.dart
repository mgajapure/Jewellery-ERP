import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({Dio? dio})
    : _dio = dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.example.com',
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 20),
              headers: const {'Accept': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }
}
