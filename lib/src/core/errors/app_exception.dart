import 'package:equatable/equatable.dart';

/// Base application exception.
///
/// All errors are mapped to this type before reaching the UI layer.
class AppException extends Equatable {
  const AppException({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final dynamic details;

  @override
  List<Object?> get props => [code, message, details];
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection.'})
      : super(code: 'NETWORK_ERROR');
}

class ServerException extends AppException {
  const ServerException({required super.message, super.details})
      : super(code: 'SERVER_ERROR');
}

class AuthException extends AppException {
  const AuthException({required super.message})
      : super(code: 'AUTH_ERROR');
}

class ValidationException extends AppException {
  const ValidationException({required super.message, super.details})
      : super(code: 'VALIDATION_ERROR');
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Resource not found.'})
      : super(code: 'NOT_FOUND');
}
