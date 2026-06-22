import 'package:equatable/equatable.dart';

/// Domain entity for a customer.
class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.tenantId,
    required this.digitalCustomerId,
    required this.name,
    this.nameEn,
    required this.mobile,
    this.alternateMobile,
    this.address,
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

  final String id;
  final String tenantId;
  final String digitalCustomerId;
  final String name;
  final String? nameEn;
  final String mobile;
  final String? alternateMobile;
  final String? address;
  final String? aadhaarMasked;
  final String? panNumber;
  final DateTime? dateOfBirth;
  final String? photoUrl;
  final String? qrCodeUrl;
  final String riskCategory;
  final bool isActive;
  final int activeGirvi;
  final double outstanding;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  @override
  List<Object?> get props => [id, digitalCustomerId, mobile];
}
