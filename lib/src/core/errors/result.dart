import 'app_exception.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppException error) = Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  });

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  AppException? get errorOrNull =>
      this is Failure<T> ? (this as Failure<T>).error : null;
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) =>
      success(data);
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppException error;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) =>
      failure(error);
}
