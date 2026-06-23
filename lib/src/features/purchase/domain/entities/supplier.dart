import 'package:equatable/equatable.dart';

enum SupplierStatus { active, inactive }

extension SupplierStatusLabel on SupplierStatus {
  String get labelMr =>
      this == SupplierStatus.active ? 'सक्रिय' : 'निष्क्रिय';
  String get labelEn =>
      this == SupplierStatus.active ? 'Active' : 'Inactive';
}

class Supplier extends Equatable {
  const Supplier({
    required this.id,
    required this.name,
    required this.mobile,
    required this.gstNo,
    required this.balanceDue,
    required this.status,
  });

  final String id;
  final String name;
  final String mobile;
  final String gstNo;
  final double balanceDue;
  final SupplierStatus status;

  @override
  List<Object?> get props => [id, name, mobile, gstNo, balanceDue, status];
}
