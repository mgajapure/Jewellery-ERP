// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    _CustomerModel(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      digitalCustomerId: json['digitalCustomerId'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String?,
      mobile: json['mobile'] as String,
      alternateMobile: json['alternateMobile'] as String?,
      address: json['address'] as String?,
      aadhaarMasked: json['aadhaarMasked'] as String?,
      panNumber: json['panNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      photoUrl: json['photoUrl'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      riskCategory: json['riskCategory'] as String? ?? 'LOW',
      isActive: json['isActive'] as bool? ?? true,
      activeGirvi: (json['activeGirvi'] as num?)?.toInt() ?? 0,
      outstanding: (json['outstanding'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$CustomerModelToJson(_CustomerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'digitalCustomerId': instance.digitalCustomerId,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'mobile': instance.mobile,
      'alternateMobile': instance.alternateMobile,
      'address': instance.address,
      'aadhaarMasked': instance.aadhaarMasked,
      'panNumber': instance.panNumber,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'photoUrl': instance.photoUrl,
      'qrCodeUrl': instance.qrCodeUrl,
      'riskCategory': instance.riskCategory,
      'isActive': instance.isActive,
      'activeGirvi': instance.activeGirvi,
      'outstanding': instance.outstanding,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'version': instance.version,
    };
