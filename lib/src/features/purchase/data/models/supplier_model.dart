import '../../domain/entities/supplier.dart';

class SupplierModel extends Supplier {
  const SupplierModel({
    required super.id,
    required super.name,
    required super.mobile,
    required super.gstNo,
    required super.balanceDue,
    required super.status,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      gstNo: json['gstNo'] as String,
      balanceDue: (json['balanceDue'] as num).toDouble(),
      status: (json['status'] as String).toUpperCase() == 'ACTIVE'
          ? SupplierStatus.active
          : SupplierStatus.inactive,
    );
  }
}
