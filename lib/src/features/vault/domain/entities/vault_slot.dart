import 'package:equatable/equatable.dart';

enum SlotStatus { available, occupied, reserved }

extension SlotStatusLabel on SlotStatus {
  String get labelMr {
    switch (this) {
      case SlotStatus.available:
        return 'उपलब्ध';
      case SlotStatus.occupied:
        return 'व्यस्त';
      case SlotStatus.reserved:
        return 'राखीव';
    }
  }

  String get labelEn {
    switch (this) {
      case SlotStatus.available:
        return 'Available';
      case SlotStatus.occupied:
        return 'Occupied';
      case SlotStatus.reserved:
        return 'Reserved';
    }
  }
}

class VaultSlot extends Equatable {
  const VaultSlot({
    required this.id,
    required this.slotName,
    required this.coordinate,
    required this.status,
    this.girviId,
  });

  final String id;
  final String slotName;
  final String coordinate;
  final SlotStatus status;
  final String? girviId;

  bool get isAvailable => status == SlotStatus.available;

  @override
  List<Object?> get props => [id, coordinate, status, girviId];
}
