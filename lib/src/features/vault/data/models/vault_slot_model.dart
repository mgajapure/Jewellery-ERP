import '../../domain/entities/vault_slot.dart';

class VaultSlotModel extends VaultSlot {
  const VaultSlotModel({
    required super.id,
    required super.slotName,
    required super.coordinate,
    required super.status,
    super.girviId,
  });

  factory VaultSlotModel.fromJson(Map<String, dynamic> json) {
    return VaultSlotModel(
      id: json['id'] as String,
      slotName: json['slotName'] as String,
      coordinate: json['coordinate'] as String,
      status: _parseStatus(json['status'] as String),
      girviId: json['girviId'] as String?,
    );
  }

  static SlotStatus _parseStatus(String s) {
    switch (s) {
      case 'occupied':
        return SlotStatus.occupied;
      case 'reserved':
        return SlotStatus.reserved;
      default:
        return SlotStatus.available;
    }
  }
}
