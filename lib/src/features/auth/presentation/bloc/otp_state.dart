import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

/// The active state during OTP entry — covers all UI sub-states via flags.
class OtpEntry extends OtpState {
  const OtpEntry({
    required this.mobile,
    required this.maskedMobile,
    required this.requestId,
    required this.secondsLeft,
    required this.attemptsLeft,
    this.errorMessage,
    this.isVerifying = false,
    this.isResending = false,
  });

  final String mobile;
  final String maskedMobile;
  final String requestId;
  final int secondsLeft;
  final int attemptsLeft;
  final String? errorMessage;
  final bool isVerifying;
  final bool isResending;

  bool get isExpired => secondsLeft <= 0;

  OtpEntry copyWith({
    int? secondsLeft,
    int? attemptsLeft,
    String? requestId,
    String? errorMessage,
    bool? isVerifying,
    bool? isResending,
    bool clearError = false,
  }) =>
      OtpEntry(
        mobile: mobile,
        maskedMobile: maskedMobile,
        requestId: requestId ?? this.requestId,
        secondsLeft: secondsLeft ?? this.secondsLeft,
        attemptsLeft: attemptsLeft ?? this.attemptsLeft,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        isVerifying: isVerifying ?? this.isVerifying,
        isResending: isResending ?? this.isResending,
      );

  @override
  List<Object?> get props => [
        mobile,
        requestId,
        secondsLeft,
        attemptsLeft,
        errorMessage,
        isVerifying,
        isResending,
      ];
}

/// OTP verified — navigate to Dashboard.
class OtpSuccess extends OtpState {
  const OtpSuccess(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

/// Device is new / unregistered — navigate to RegistrationPending.
class OtpRegistrationPending extends OtpState {
  const OtpRegistrationPending();
}
