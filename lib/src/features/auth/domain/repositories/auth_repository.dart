import '../../../../core/errors/result.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  /// Sends an OTP to [mobile]. Returns the server-generated [requestId].
  Future<Result<String>> requestOtp(String mobile);

  /// Verifies [otp] against [requestId]. Returns an [AuthSession] on success.
  /// Returns failure with message `__registration_pending__` when the device
  /// is recognised but admin approval is still pending.
  Future<Result<AuthSession>> verifyOtp({
    required String requestId,
    required String otp,
    required String mobile,
  });

  /// Uses the stored refresh token to obtain a new access token.
  Future<Result<AuthSession>> refreshSession();

  /// Clears all local session data (always succeeds even if network fails).
  Future<Result<void>> logout();

  /// Reads the persisted session from secure storage. Returns null when no
  /// session has been saved (first launch or after logout).
  Future<AuthSession?> getStoredSession();
}
