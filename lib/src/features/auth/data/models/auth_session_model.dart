import '../../domain/entities/auth_session.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.staffId,
    required this.tenantId,
    required this.staffName,
    required this.role,
    required this.expiresAt,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      staffId: json['staffId'] as String,
      tenantId: json['tenantId'] as String,
      staffName: json['staffName'] as String,
      role: _parseRole(json['role'] as String? ?? 'STAFF'),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  final String accessToken;
  final String refreshToken;
  final String staffId;
  final String tenantId;
  final String staffName;
  final StaffRole role;
  final DateTime expiresAt;

  AuthSession toEntity() => AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        staffId: staffId,
        tenantId: tenantId,
        staffName: staffName,
        role: role,
        expiresAt: expiresAt,
      );

  static StaffRole _parseRole(String raw) {
    switch (raw.toUpperCase()) {
      case 'OWNER':
        return StaffRole.owner;
      case 'MANAGER':
        return StaffRole.manager;
      case 'VIEWER':
        return StaffRole.viewer;
      default:
        return StaffRole.staff;
    }
  }
}
