import '../../domain/entities/inventory_item.dart';

class InventoryMovementModel extends InventoryMovement {
  const InventoryMovementModel({
    required super.date,
    required super.action,
    required super.user,
    required super.reference,
  });

  factory InventoryMovementModel.fromJson(Map<String, dynamic> json) =>
      InventoryMovementModel(
        date: json['date'] as String? ?? '',
        action: json['action'] as String? ?? '',
        user: json['user'] as String? ?? '',
        reference: json['reference'] as String? ?? '-',
      );
}

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.barcode,
    required super.name,
    required super.category,
    required super.description,
    required super.metalType,
    required super.grossWeight,
    required super.netWeight,
    required super.purity,
    required super.makingCharges,
    required super.costPrice,
    required super.sellingPrice,
    required super.taxableAmount,
    required super.gst,
    required super.totalAmount,
    required super.status,
    required super.movements,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    final movementsRaw =
        (json['movements'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    return InventoryItemModel(
      id: json['id'] as String,
      barcode: json['barcode'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      metalType: json['metalType'] as String? ?? '',
      grossWeight: (json['grossWeight'] as num).toDouble(),
      netWeight: (json['netWeight'] as num).toDouble(),
      purity: json['purity'] as String? ?? '',
      makingCharges: (json['makingCharges'] as num?)?.toDouble() ?? 0.0,
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      taxableAmount: (json['taxableAmount'] as num?)?.toDouble() ?? 0.0,
      gst: (json['gst'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: _parseStatus(json['status'] as String? ?? 'AVAILABLE'),
      movements: movementsRaw.map(InventoryMovementModel.fromJson).toList(),
    );
  }

  static InventoryStatus _parseStatus(String s) {
    switch (s.toUpperCase()) {
      case 'AVAILABLE':
        return InventoryStatus.available;
      case 'RESERVED':
        return InventoryStatus.reserved;
      case 'SOLD':
        return InventoryStatus.sold;
      case 'LOWSTOCK':
      case 'LOW_STOCK':
        return InventoryStatus.lowStock;
      case 'DAMAGED':
        return InventoryStatus.damaged;
      default:
        return InventoryStatus.available;
    }
  }
}
