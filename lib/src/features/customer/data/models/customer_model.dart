import '../../domain/entities/customer.dart';

class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.tenantId,
    required this.digitalCustomerId,
    required this.name,
    required this.nameEn,
    required this.mobile,
    this.alternateMobile,
    required this.address,
    this.aadhaarMasked,
    this.panNumber,
    this.dateOfBirth,
    this.photoUrl,
    this.qrCodeUrl,
    required this.riskCategory,
    required this.isActive,
    required this.activeGirvi,
    required this.outstanding,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'] as String,
    tenantId: json['tenantId'] as String,
    digitalCustomerId: json['digitalCustomerId'] as String,
    name: json['name'] as String,
    nameEn: json['nameEn'] as String,
    mobile: json['mobile'] as String,
    alternateMobile: json['alternateMobile'] as String?,
    address: json['address'] as String? ?? '',
    aadhaarMasked: json['aadhaarMasked'] as String?,
    panNumber: json['panNumber'] as String?,
    dateOfBirth: json['dateOfBirth'] != null
        ? DateTime.tryParse(json['dateOfBirth'] as String)
        : null,
    photoUrl: json['photoUrl'] as String?,
    qrCodeUrl: json['qrCodeUrl'] as String?,
    riskCategory: _parseRisk(json['riskCategory'] as String? ?? 'LOW'),
    isActive: json['isActive'] as bool? ?? true,
    activeGirvi: (json['activeGirvi'] as num?)?.toInt() ?? 0,
    outstanding: (json['outstanding'] as num?)?.toDouble() ?? 0,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    version: (json['version'] as num?)?.toInt() ?? 1,
  );

  static RiskCategory _parseRisk(String value) {
    switch (value.toLowerCase()) {
      case 'medium':
        return RiskCategory.medium;
      case 'high':
        return RiskCategory.high;
      default:
        return RiskCategory.low;
    }
  }

  final String id;
  final String tenantId;
  final String digitalCustomerId;
  final String name;
  final String nameEn;
  final String mobile;
  final String? alternateMobile;
  final String address;
  final String? aadhaarMasked;
  final String? panNumber;
  final DateTime? dateOfBirth;
  final String? photoUrl;
  final String? qrCodeUrl;
  final RiskCategory riskCategory;
  final bool isActive;
  final int activeGirvi;
  final double outstanding;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Customer toEntity() => Customer(
    id: id,
    tenantId: tenantId,
    digitalCustomerId: digitalCustomerId,
    name: name,
    nameEn: nameEn,
    mobile: mobile,
    alternateMobile: alternateMobile,
    address: address,
    aadhaarMasked: aadhaarMasked,
    panNumber: panNumber,
    dateOfBirth: dateOfBirth,
    photoUrl: photoUrl,
    qrCodeUrl: qrCodeUrl,
    riskCategory: riskCategory,
    isActive: isActive,
    activeGirvi: activeGirvi,
    outstanding: outstanding,
    createdAt: createdAt,
    updatedAt: updatedAt,
    version: version,
  );
}
