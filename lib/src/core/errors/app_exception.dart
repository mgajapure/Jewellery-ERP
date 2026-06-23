sealed class AppException {
  const AppException({required this.message});
  final String message;
}

class NetworkException extends AppException {
  const NetworkException()
      : super(message: 'No internet connection. Please check your network.');
}

class ServerException extends AppException {
  const ServerException({required super.message});
}

class AuthException extends AppException {
  const AuthException({required super.message});
}

class NotFoundException extends AppException {
  const NotFoundException() : super(message: 'Requested resource not found.');
}

class CacheException extends AppException {
  const CacheException({required super.message});
}
