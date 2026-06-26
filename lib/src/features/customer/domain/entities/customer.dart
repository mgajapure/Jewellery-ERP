import 'package:equatable/equatable.dart';

enum RiskCategory { low, medium, high }

class Customer extends Equatable {
  const Customer({
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

  @override
  List<Object?> get props => [
    id, tenantId, digitalCustomerId, name, nameEn, mobile, alternateMobile,
    address, aadhaarMasked, panNumber, dateOfBirth, photoUrl, qrCodeUrl,
    riskCategory, isActive, activeGirvi, outstanding, createdAt, updatedAt,
    version,
  ];
}

class CreateCustomerRequest {
  const CreateCustomerRequest({
    required this.name,
    required this.mobile,
    this.alternateMobile,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.gender,
    this.dateOfBirth,
    this.aadhaarNumber,
    this.panNumber,
  });

  final String name;
  final String mobile;
  final String? alternateMobile;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? gender;
  final String? dateOfBirth;
  final String? aadhaarNumber;
  final String? panNumber;
}

class UpdateCustomerRequest {
  const UpdateCustomerRequest({
    required this.id,
    required this.name,
    this.alternateMobile,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.gender,
    this.dateOfBirth,
    this.panNumber,
  });

  final String id;
  final String name;
  final String? alternateMobile;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? gender;
  final String? dateOfBirth;
  final String? panNumber;
}
