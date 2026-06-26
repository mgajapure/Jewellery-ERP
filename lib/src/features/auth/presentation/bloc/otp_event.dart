import 'package:equatable/equatable.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

/// Must be the first event added — starts countdown timer.
class OtpStarted extends OtpEvent {
  const OtpStarted({
    required this.requestId,
    required this.mobile,
    required this.maskedMobile,
    this.countdownSeconds = 30,
  });

  final String requestId;
  final String mobile;
  final String maskedMobile;
  final int countdownSeconds;

  @override
  List<Object?> get props => [requestId, mobile];
}

/// Emitted internally by the countdown stream — not intended for UI use.
class OtpTimerTicked extends OtpEvent {
  const OtpTimerTicked(this.secondsLeft);

  final int secondsLeft;

  @override
  List<Object?> get props => [secondsLeft];
}

/// User tapped "Verify OTP".
class OtpSubmitted extends OtpEvent {
  const OtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

/// User tapped "Resend OTP".
class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}
