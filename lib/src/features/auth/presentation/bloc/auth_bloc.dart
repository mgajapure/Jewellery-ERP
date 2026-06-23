import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// App-level BLoC — one singleton per app lifecycle.
/// Manages the persisted auth session; all screens listen to this to decide
/// whether to show protected content or the login flow.
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthLoading()) {
    on<AuthStarted>(_onStarted);
    on<AuthSessionObtained>(_onSessionObtained);
    on<AuthLogoutRequested>(_onLogout);
  }

  final AuthRepository _repository;

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final stored = await _repository.getStoredSession();
    if (stored == null) {
      emit(const AuthUnauthenticated());
      return;
    }
    if (!stored.isExpired) {
      emit(AuthAuthenticated(stored));
      return;
    }
    // Expired — try silent refresh
    final result = await _repository.refreshSession();
    result.when(
      success: (session) => emit(AuthAuthenticated(session)),
      failure: (_) => emit(const AuthUnauthenticated()),
    );
  }

  void _onSessionObtained(
    AuthSessionObtained event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAuthenticated(event.session));
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }
}
