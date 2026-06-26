import 'package:equatable/equatable.dart';

enum StaffRole { owner, manager, staff, viewer }

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.staffId,
    required this.tenantId,
    required this.staffName,
    required this.role,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String staffId;
  final String tenantId;
  final String staffName;
  final StaffRole role;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [staffId, tenantId, accessToken];
}

/// Data transfer object passed from MobileNumberPage to OtpVerificationPage.
class OtpArgs {
  const OtpArgs({
    required this.requestId,
    required this.mobile,
    required this.maskedMobile,
  });

  final String requestId;
  final String mobile;
  final String maskedMobile;
}
