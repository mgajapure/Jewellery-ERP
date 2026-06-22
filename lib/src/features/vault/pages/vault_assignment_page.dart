import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/vault_colors.dart';

/// SCR-034 Vault Assignment
///
/// Assigns a physical vault location (Vault → Safe → Tray → Slot) to a Girvi
/// contract. This page can be reached from the Create Girvi Wizard or from a
/// Girvi details screen when a location needs to be changed.
class VaultAssignmentPage extends StatefulWidget {
  const VaultAssignmentPage({super.key});

  static const routeName = 'vault-assignment';

  @override
  State<VaultAssignmentPage> createState() => _VaultAssignmentPageState();
}

class _VaultAssignmentPageState extends State<VaultAssignmentPage> {
  String? _selectedVault;
  String? _selectedSafe;
  String? _selectedTray;
  String? _selectedSlot;

  final List<String> _vaults = const ['Vault-A', 'Vault-B', 'Vault-C'];
  final List<String> _safes = const ['Safe-01', 'Safe-02', 'Safe-03'];
  final List<String> _trays = const ['Tray-01', 'Tray-05', 'Tray-12'];
  final List<String> _slots = const [
    'Slot-17',
    'Slot-18',
    'Slot-19',
    'Slot-20',
  ];

  String get _coordinate {
    if (_selectedVault == null ||
        _selectedSafe == null ||
        _selectedTray == null ||
        _selectedSlot == null) {
      return '-- / -- / -- / --';
    }
    final vaultCode = _selectedVault!.replaceAll('Vault-', 'VA-');
    final safeCode = _selectedSafe!.replaceAll('Safe-', 'SF-');
    final trayCode = _selectedTray!.replaceAll('Tray-', 'TR-');
    final slotCode = _selectedSlot!.replaceAll('Slot-', 'SL-');
    return '$vaultCode/$safeCode/$trayCode/$slotCode';
  }

  bool get _isComplete {
    return _selectedVault != null &&
        _selectedSafe != null &&
        _selectedTray != null &&
        _selectedSlot != null;
  }

  bool get _isSlotOccupied {
    // Mock occupancy: Slot-18 is occupied, Slot-20 is reserved, others available.
    if (_selectedSlot == 'Slot-18') return true;
    if (_selectedSlot == 'Slot-20') return false; // reserved treated as not free
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CoordinateCard(coordinate: _coordinate),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      titleMr: 'स्थान निवडा',
                      titleEn: 'Select Location',
                    ),
                    const SizedBox(height: 12),
                    _LocationDropdown(
                      labelMr: 'तिजोरी',
                      labelEn: 'Vault',
                      value: _selectedVault,
                      items: _vaults,
                      icon: Icons.account_balance,
                      onChanged: (value) {
                        setState(() {
                          _selectedVault = value;
                          _selectedSafe = null;
                          _selectedTray = null;
                          _selectedSlot = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _LocationDropdown(
                      labelMr: 'सेफ',
                      labelEn: 'Safe',
                      value: _selectedSafe,
                      items: _safes,
                      icon: Icons.lock_outline,
                      enabled: _selectedVault != null,
                      onChanged: (value) {
                        setState(() {
                          _selectedSafe = value;
                          _selectedTray = null;
                          _selectedSlot = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _LocationDropdown(
                      labelMr: 'ट्रे',
                      labelEn: 'Tray',
                      value: _selectedTray,
                      items: _trays,
                      icon: Icons.layers_outlined,
                      enabled: _selectedSafe != null,
                      onChanged: (value) {
                        setState(() {
                          _selectedTray = value;
                          _selectedSlot = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _LocationDropdown(
                      labelMr: 'स्लॉट',
                      labelEn: 'Slot',
                      value: _selectedSlot,
                      items: _slots,
                      icon: Icons.grid_view_outlined,
                      enabled: _selectedTray != null,
                      onChanged: (value) {
                        setState(() => _selectedSlot = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_selectedSlot != null) _SlotStatusCard(occupied: _isSlotOccupied),
                    const SizedBox(height: 24),
                    _InfoBox(
                      textMr: 'सक्रिय गिरवीसाठी तिजोरी नियुक्ती अनिवार्य आहे.',
                      textEn: 'Vault assignment is mandatory before Girvi activation.',
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
                  onPressed: _isComplete && !_isSlotOccupied
                      ? () {
                          // TODO: call repository to assign slot and return coordinate.
                          context.pop(_coordinate);
                        }
                      : null,
                  child: const Text(
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
        ),
      ),
    );
  }
}

class _CoordinateCard extends StatelessWidget {
  const _CoordinateCard({required this.coordinate});

  final String coordinate;

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
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            coordinate,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: coordinate == '-- / -- / -- / --'
                  ? Colors.white38
                  : VaultColors.gold,
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
          style: const TextStyle(
            fontSize: 12,
            color: VaultColors.muted,
          ),
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
  });

  final String labelMr;
  final String labelEn;
  final String? value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;
  final bool enabled;

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
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down),
              hint: Text(
                enabled ? 'निवडा / Select $labelEn' : 'प्रथम वरची पातळी निवडा / Select level above',
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
                          Icon(
                            icon,
                            size: 18,
                            color: VaultColors.navy,
                          ),
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

class _SlotStatusCard extends StatelessWidget {
  const _SlotStatusCard({required this.occupied});

  final bool occupied;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: occupied ? const Color(0xFFFFF0F0) : const Color(0xFFF0FFF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: occupied ? VaultColors.red.withAlpha(30) : VaultColors.green.withAlpha(30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: occupied ? VaultColors.red : VaultColors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                occupied ? 'स्लॉट व्यस्त आहे' : 'स्लॉट उपलब्ध आहे',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: occupied ? VaultColors.red : VaultColors.green,
                ),
              ),
              Text(
                occupied ? 'Slot Occupied' : 'Slot Available',
                style: TextStyle(
                  fontSize: 12,
                  color: occupied ? VaultColors.red.withAlpha(180) : VaultColors.green.withAlpha(180),
                ),
              ),
            ],
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
          Icon(
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
                  style: TextStyle(
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
