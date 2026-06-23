import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/vault_repository.dart';
import 'vault_assignment_event.dart';
import 'vault_assignment_state.dart';

@injectable
class VaultAssignmentBloc
    extends Bloc<VaultAssignmentEvent, VaultAssignmentState> {
  VaultAssignmentBloc({required VaultRepository repository})
      : _repository = repository,
        super(const VaultAssignmentInitial()) {
    on<VaultAssignmentStarted>(_onStarted);
    on<VaultSelected>(_onVaultSelected);
    on<SafeSelected>(_onSafeSelected);
    on<TraySelected>(_onTraySelected);
    on<SlotSelected>(_onSlotSelected);
    on<VaultAssignmentConfirmed>(_onConfirmed);
  }

  final VaultRepository _repository;

  Future<void> _onStarted(
    VaultAssignmentStarted event,
    Emitter<VaultAssignmentState> emit,
  ) async {
    emit(const VaultAssignmentLoading());
    final result = await _repository.getVaults();
    result.when(
      success: (vaults) =>
          emit(VaultAssignmentReady(vaults: vaults)),
      failure: (error) => emit(VaultAssignmentError(error.message)),
    );
  }

  Future<void> _onVaultSelected(
    VaultSelected event,
    Emitter<VaultAssignmentState> emit,
  ) async {
    if (state is! VaultAssignmentReady) return;
    final current = state as VaultAssignmentReady;

    emit(current.copyWith(
      selectedVault: event.vault,
      clearSafe: true,
      clearTray: true,
      clearSlot: true,
      isLoadingNext: true,
      clearError: true,
    ));

    final result = await _repository.getSafes(event.vault);
    if (state is! VaultAssignmentReady) return;
    final updated = state as VaultAssignmentReady;

    result.when(
      success: (safes) => emit(updated.copyWith(
        safes: safes,
        isLoadingNext: false,
      )),
      failure: (error) => emit(updated.copyWith(
        isLoadingNext: false,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> _onSafeSelected(
    SafeSelected event,
    Emitter<VaultAssignmentState> emit,
  ) async {
    if (state is! VaultAssignmentReady) return;
    final current = state as VaultAssignmentReady;
    if (current.selectedVault == null) return;

    emit(current.copyWith(
      selectedSafe: event.safe,
      clearTray: true,
      clearSlot: true,
      isLoadingNext: true,
      clearError: true,
    ));

    final result = await _repository.getTrays(current.selectedVault!, event.safe);
    if (state is! VaultAssignmentReady) return;
    final updated = state as VaultAssignmentReady;

    result.when(
      success: (trays) => emit(updated.copyWith(
        trays: trays,
        isLoadingNext: false,
      )),
      failure: (error) => emit(updated.copyWith(
        isLoadingNext: false,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> _onTraySelected(
    TraySelected event,
    Emitter<VaultAssignmentState> emit,
  ) async {
    if (state is! VaultAssignmentReady) return;
    final current = state as VaultAssignmentReady;
    if (current.selectedVault == null || current.selectedSafe == null) return;

    emit(current.copyWith(
      selectedTray: event.tray,
      clearSlot: true,
      isLoadingNext: true,
      clearError: true,
    ));

    final result = await _repository.getSlots(
      current.selectedVault!,
      current.selectedSafe!,
      event.tray,
    );
    if (state is! VaultAssignmentReady) return;
    final updated = state as VaultAssignmentReady;

    result.when(
      success: (slots) => emit(updated.copyWith(
        slots: slots,
        isLoadingNext: false,
      )),
      failure: (error) => emit(updated.copyWith(
        isLoadingNext: false,
        errorMessage: error.message,
      )),
    );
  }

  void _onSlotSelected(
    SlotSelected event,
    Emitter<VaultAssignmentState> emit,
  ) {
    if (state is! VaultAssignmentReady) return;
    emit((state as VaultAssignmentReady).copyWith(
      selectedSlot: event.slot,
      clearError: true,
    ));
  }

  Future<void> _onConfirmed(
    VaultAssignmentConfirmed event,
    Emitter<VaultAssignmentState> emit,
  ) async {
    if (state is! VaultAssignmentReady) return;
    final current = state as VaultAssignmentReady;
    if (!current.canConfirm) return;

    emit(current.copyWith(isAssigning: true, clearError: true));

    final result = await _repository.assignSlot(
      coordinate: current.selectedSlot!.coordinate,
    );

    result.when(
      success: (coordinate) => emit(VaultAssignmentSuccess(coordinate)),
      failure: (error) {
        if (state is VaultAssignmentReady) {
          emit((state as VaultAssignmentReady).copyWith(
            isAssigning: false,
            errorMessage: error.message,
          ));
        }
      },
    );
  }
}
