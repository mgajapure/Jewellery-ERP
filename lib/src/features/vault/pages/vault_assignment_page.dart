import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../domain/entities/vault_slot.dart';
import '../presentation/bloc/vault_assignment_bloc.dart';
import '../presentation/bloc/vault_assignment_event.dart';
import '../presentation/bloc/vault_assignment_state.dart';
import '../theme/vault_colors.dart';

/// SCR-034 Vault Assignment
///
/// Assigns a physical vault location (Vault → Safe → Tray → Slot) to a Girvi
/// contract. Reached from the Create Girvi Wizard or from Girvi details when
/// a location needs to be changed. Returns the selected coordinate via pop.
class VaultAssignmentPage extends StatelessWidget {
  const VaultAssignmentPage({super.key});

  static const routeName = 'vault-assignment';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<VaultAssignmentBloc>()
        ..add(const VaultAssignmentStarted()),
      child: const _VaultAssignmentView(),
    );
  }
}

class _VaultAssignmentView extends StatelessWidget {
  const _VaultAssignmentView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VaultAssignmentBloc, VaultAssignmentState>(
      listener: (context, state) {
        if (state is VaultAssignmentSuccess) {
          context.pop(state.coordinate);
        }
      },
      child: Scaffold(
        backgroundColor: VaultColors.screenBg,
        appBar: AppBar(
          backgroundColor: VaultColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'तिजोरी नियुक्ती',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Vault Assignment',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<VaultAssignmentBloc, VaultAssignmentState>(
            builder: (context, state) {
              if (state is VaultAssignmentLoading ||
                  state is VaultAssignmentInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is VaultAssignmentError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: VaultColors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        style: const TextStyle(
                            color: VaultColors.muted, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              final ready = state as VaultAssignmentReady;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CoordinateCard(coordinate: ready.coordinate),
                          const SizedBox(height: 20),
                          const _SectionTitle(
                            titleMr: 'स्थान निवडा',
                            titleEn: 'Select Location',
                          ),
                          const SizedBox(height: 12),
                          _LocationDropdown(
                            labelMr: 'तिजोरी',
                            labelEn: 'Vault',
                            value: ready.selectedVault,
                            items: ready.vaults,
                            icon: Icons.account_balance,
                            enabled: true,
                            onChanged: (v) {
                              if (v != null) {
                                context
                                    .read<VaultAssignmentBloc>()
                                    .add(VaultSelected(v));
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _LocationDropdown(
                            labelMr: 'सेफ',
                            labelEn: 'Safe',
                            value: ready.selectedSafe,
                            items: ready.safes,
                            icon: Icons.lock_outline,
                            enabled: ready.selectedVault != null &&
                                !ready.isLoadingNext,
                            isLoading: ready.isLoadingNext &&
                                ready.selectedVault != null &&
                                ready.selectedSafe == null,
                            onChanged: (v) {
                              if (v != null) {
                                context
                                    .read<VaultAssignmentBloc>()
                                    .add(SafeSelected(v));
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _LocationDropdown(
                            labelMr: 'ट्रे',
                            labelEn: 'Tray',
                            value: ready.selectedTray,
                            items: ready.trays,
                            icon: Icons.layers_outlined,
                            enabled: ready.selectedSafe != null &&
                                !ready.isLoadingNext,
                            isLoading: ready.isLoadingNext &&
                                ready.selectedSafe != null &&
                                ready.selectedTray == null,
                            onChanged: (v) {
                              if (v != null) {
                                context
                                    .read<VaultAssignmentBloc>()
                                    .add(TraySelected(v));
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          if (ready.selectedTray != null)
                            _SlotGrid(
                              slots: ready.slots,
                              selected: ready.selectedSlot,
                              isLoading: ready.isLoadingNext &&
                                  ready.selectedTray != null &&
                                  ready.slots.isEmpty,
                              onSelected: (slot) => context
                                  .read<VaultAssignmentBloc>()
                                  .add(SlotSelected(slot)),
                            ),
                          if (ready.selectedSlot != null) ...[
                            const SizedBox(height: 16),
                            _SlotStatusCard(
                              slot: ready.selectedSlot!,
                            ),
                          ],
                          if (ready.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: VaultColors.red.withAlpha(10),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: VaultColors.red.withAlpha(30)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: VaultColors.red, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ready.errorMessage!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: VaultColors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          const _InfoBox(
                            textMr:
                                'सक्रिय गिरवीसाठी तिजोरी नियुक्ती अनिवार्य आहे.',
                            textEn:
                                'Vault assignment is mandatory before Girvi activation.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VaultColors.navy,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: VaultColors.line,
                          disabledForegroundColor: VaultColors.muted,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: ready.canConfirm
                            ? () => context
                                .read<VaultAssignmentBloc>()
                                .add(const VaultAssignmentConfirmed())
                            : null,
                        child: ready.isAssigning
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'नियुक्ती निश्चित करा / Confirm Assignment',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Widgets ────────────────────────────────────────────────────────────────

class _CoordinateCard extends StatelessWidget {
  const _CoordinateCard({required this.coordinate});

  final String coordinate;

  bool get _isPlaceholder => coordinate == '-- / -- / -- / --';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VaultColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'तिजोरी निर्देशांक / Vault Coordinate',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            coordinate,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _isPlaceholder ? Colors.white38 : VaultColors.gold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VaultColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(fontSize: 12, color: VaultColors.muted),
        ),
      ],
    );
  }
}

class _LocationDropdown extends StatelessWidget {
  const _LocationDropdown({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
    this.enabled = true,
    this.isLoading = false,
  });

  final String labelMr;
  final String labelEn;
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VaultColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 11,
              color: VaultColors.muted,
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: VaultColors.navy,
                ),
              ),
            )
          else
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: Text(
                  enabled
                      ? 'निवडा / Select $labelEn'
                      : 'प्रथम वरची पातळी निवडा / Select level above',
                  style: TextStyle(
                    color: enabled ? VaultColors.muted : VaultColors.line,
                  ),
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(icon, size: 18, color: VaultColors.navy),
                            const SizedBox(width: 12),
                            Text(item),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: enabled ? onChanged : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  const _SlotGrid({
    required this.slots,
    required this.selected,
    required this.onSelected,
    this.isLoading = false,
  });

  final List<VaultSlot> slots;
  final VaultSlot? selected;
  final ValueChanged<VaultSlot> onSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VaultColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'स्लॉट निवडा / Select Slot',
            style: TextStyle(
              fontSize: 12,
              color: VaultColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: VaultColors.navy),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map((slot) {
                final isSelected = slot.id == selected?.id;
                final Color bgColor;
                final Color borderColor;
                final Color textColor;

                switch (slot.status) {
                  case SlotStatus.occupied:
                    bgColor = VaultColors.red.withAlpha(15);
                    borderColor = VaultColors.red.withAlpha(80);
                    textColor = VaultColors.red;
                  case SlotStatus.reserved:
                    bgColor = VaultColors.orange.withAlpha(15);
                    borderColor = VaultColors.orange.withAlpha(80);
                    textColor = VaultColors.orange;
                  case SlotStatus.available:
                    bgColor = isSelected
                        ? VaultColors.navy
                        : VaultColors.green.withAlpha(10);
                    borderColor = isSelected
                        ? VaultColors.navy
                        : VaultColors.green.withAlpha(80);
                    textColor = isSelected ? Colors.white : VaultColors.green;
                }

                return GestureDetector(
                  onTap: slot.isAvailable ? () => onSelected(slot) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      slot.slotName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Legend(color: VaultColors.green, label: 'Available'),
              const SizedBox(width: 16),
              _Legend(color: VaultColors.red, label: 'Occupied'),
              const SizedBox(width: 16),
              _Legend(color: VaultColors.orange, label: 'Reserved'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: VaultColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SlotStatusCard extends StatelessWidget {
  const _SlotStatusCard({required this.slot});

  final VaultSlot slot;

  @override
  Widget build(BuildContext context) {
    final isAvailable = slot.isAvailable;
    final color = isAvailable ? VaultColors.green : VaultColors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable
            ? const Color(0xFFF0FFF5)
            : const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.status.labelMr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  '${slot.slotName} · ${slot.status.labelEn}',
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withAlpha(180),
                  ),
                ),
                if (slot.girviId != null)
                  Text(
                    'Girvi: ${slot.girviId}',
                    style: const TextStyle(
                        fontSize: 11, color: VaultColors.muted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.textMr, required this.textEn});

  final String textMr;
  final String textEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VaultColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VaultColors.gold.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: VaultColors.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textMr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: VaultColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  textEn,
                  style: const TextStyle(
                    fontSize: 12,
                    color: VaultColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
