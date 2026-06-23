import 'package:equatable/equatable.dart';

enum InventoryStatus {
  available,
  reserved,
  sold,
  lowStock,
  damaged;

  String get labelMr {
    return switch (this) {
      InventoryStatus.available => 'उपलब्ध',
      InventoryStatus.reserved => 'राखीव',
      InventoryStatus.sold => 'विकले',
      InventoryStatus.lowStock => 'कमी स्टॉक',
      InventoryStatus.damaged => 'खराब',
    };
  }

  String get labelEn {
    return switch (this) {
      InventoryStatus.available => 'Available',
      InventoryStatus.reserved => 'Reserved',
      InventoryStatus.sold => 'Sold',
      InventoryStatus.lowStock => 'Low Stock',
      InventoryStatus.damaged => 'Damaged',
    };
  }
}

class InventoryMovement extends Equatable {
  const InventoryMovement({
    required this.date,
    required this.action,
    required this.user,
    required this.reference,
  });

  final String date;
  final String action;
  final String user;
  final String reference;

  @override
  List<Object?> get props => [date, action, user, reference];
}

class InventoryItem extends Equatable {
  const InventoryItem({
    required this.id,
    required this.barcode,
    required this.name,
    required this.category,
    required this.description,
    required this.metalType,
    required this.grossWeight,
    required this.netWeight,
    required this.purity,
    required this.makingCharges,
    required this.costPrice,
    required this.sellingPrice,
    required this.taxableAmount,
    required this.gst,
    required this.totalAmount,
    required this.status,
    required this.movements,
  });

  final String id;
  final String barcode;
  final String name;
  final String category;
  final String description;
  final String metalType;
  final double grossWeight;
  final double netWeight;
  final String purity;
  final double makingCharges;
  final double costPrice;
  final double sellingPrice;
  final double taxableAmount;
  final double gst;
  final double totalAmount;
  final InventoryStatus status;
  final List<InventoryMovement> movements;

  double get margin => sellingPrice - costPrice;
  double get marginPercent =>
      costPrice > 0 ? (margin / costPrice) * 100 : 0;

  @override
  List<Object?> get props => [id, barcode, name, status];
}
