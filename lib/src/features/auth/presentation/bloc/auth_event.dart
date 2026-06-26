import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once at app startup to restore a persisted session.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Fired after a successful OTP verification to hydrate the app-level session.
class AuthSessionObtained extends AuthEvent {
  const AuthSessionObtained(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

/// Fired when the user taps logout anywhere in the app.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
