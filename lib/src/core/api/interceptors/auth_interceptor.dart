import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../../storage/secure_storage.dart';

/// Attaches the JWT access token to every request.
///
/// In the future this will also handle silent token refresh on 401.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final SecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
