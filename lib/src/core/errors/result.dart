import 'app_exception.dart';

/// Simple Result type for clean error handling.
///
/// Use [Result.success] or [Result.failure] from repositories and datasources.
sealed class Result<T> {
  const Result();

  factory Result.success(T data) => Success._(data);
  factory Result.failure(AppException error) => Failure._(error);

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Failure<T>(:final error) => failure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success._(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure._(this.error);

  final AppException error;
}
