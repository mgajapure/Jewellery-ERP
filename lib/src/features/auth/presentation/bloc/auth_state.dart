import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Session check in progress (reading SecureStorage or refreshing token).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// A valid, unexpired session exists.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

/// No stored session, or session was cleared by logout / refresh failure.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
