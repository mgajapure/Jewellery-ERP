import 'package:equatable/equatable.dart';

import '../../domain/entities/vault_slot.dart';

sealed class VaultAssignmentState extends Equatable {
  const VaultAssignmentState();

  @override
  List<Object?> get props => [];
}

class VaultAssignmentInitial extends VaultAssignmentState {
  const VaultAssignmentInitial();
}

class VaultAssignmentLoading extends VaultAssignmentState {
  const VaultAssignmentLoading();
}

class VaultAssignmentReady extends VaultAssignmentState {
  const VaultAssignmentReady({
    required this.vaults,
    this.safes = const [],
    this.trays = const [],
    this.slots = const [],
    this.selectedVault,
    this.selectedSafe,
    this.selectedTray,
    this.selectedSlot,
    this.isLoadingNext = false,
    this.isAssigning = false,
    this.errorMessage,
  });

  final List<String> vaults;
  final List<String> safes;
  final List<String> trays;
  final List<VaultSlot> slots;
  final String? selectedVault;
  final String? selectedSafe;
  final String? selectedTray;
  final VaultSlot? selectedSlot;
  final bool isLoadingNext;
  final bool isAssigning;
  final String? errorMessage;

  String get coordinate =>
      selectedSlot?.coordinate ?? '-- / -- / -- / --';

  bool get canConfirm =>
      selectedSlot != null &&
      selectedSlot!.isAvailable &&
      !isAssigning &&
      !isLoadingNext;

  VaultAssignmentReady copyWith({
    List<String>? vaults,
    List<String>? safes,
    List<String>? trays,
    List<VaultSlot>? slots,
    String? selectedVault,
    String? selectedSafe,
    String? selectedTray,
    VaultSlot? selectedSlot,
    bool? isLoadingNext,
    bool? isAssigning,
    String? errorMessage,
    bool clearSafe = false,
    bool clearTray = false,
    bool clearSlot = false,
    bool clearError = false,
  }) {
    return VaultAssignmentReady(
      vaults: vaults ?? this.vaults,
      safes: clearSafe ? [] : safes ?? this.safes,
      trays: clearTray ? [] : trays ?? this.trays,
      slots: clearSlot ? [] : slots ?? this.slots,
      selectedVault: selectedVault ?? this.selectedVault,
      selectedSafe: clearSafe ? null : selectedSafe ?? this.selectedSafe,
      selectedTray: clearTray ? null : selectedTray ?? this.selectedTray,
      selectedSlot: clearSlot ? null : selectedSlot ?? this.selectedSlot,
      isLoadingNext: isLoadingNext ?? this.isLoadingNext,
      isAssigning: isAssigning ?? this.isAssigning,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        vaults,
        safes,
        trays,
        slots,
        selectedVault,
        selectedSafe,
        selectedTray,
        selectedSlot,
        isLoadingNext,
        isAssigning,
        errorMessage,
      ];
}

class VaultAssignmentSuccess extends VaultAssignmentState {
  const VaultAssignmentSuccess(this.coordinate);

  final String coordinate;

  @override
  List<Object?> get props => [coordinate];
}

class VaultAssignmentError extends VaultAssignmentState {
  const VaultAssignmentError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
