import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/customer.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    required String tenantId,
    required String digitalCustomerId,
    required String name,
    String? nameEn,
    required String mobile,
    String? alternateMobile,
    String? address,
    String? aadhaarMasked,
    String? panNumber,
    DateTime? dateOfBirth,
    String? photoUrl,
    String? qrCodeUrl,
    @Default('LOW') String riskCategory,
    @Default(true) bool isActive,
    @Default(0) int activeGirvi,
    @Default(0.0) double outstanding,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(1) int version,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}

extension CustomerModelX on CustomerModel {
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
