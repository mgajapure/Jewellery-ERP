import 'package:equatable/equatable.dart';

import '../../domain/entities/vault_slot.dart';

sealed class VaultAssignmentEvent extends Equatable {
  const VaultAssignmentEvent();

  @override
  List<Object?> get props => [];
}

class VaultAssignmentStarted extends VaultAssignmentEvent {
  const VaultAssignmentStarted();
}

class VaultSelected extends VaultAssignmentEvent {
  const VaultSelected(this.vault);

  final String vault;

  @override
  List<Object?> get props => [vault];
}

class SafeSelected extends VaultAssignmentEvent {
  const SafeSelected(this.safe);

  final String safe;

  @override
  List<Object?> get props => [safe];
}

class TraySelected extends VaultAssignmentEvent {
  const TraySelected(this.tray);

  final String tray;

  @override
  List<Object?> get props => [tray];
}

class SlotSelected extends VaultAssignmentEvent {
  const SlotSelected(this.slot);

  final VaultSlot slot;

  @override
  List<Object?> get props => [slot];
}

class VaultAssignmentConfirmed extends VaultAssignmentEvent {
  const VaultAssignmentConfirmed();
}
