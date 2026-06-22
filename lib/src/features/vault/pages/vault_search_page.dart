import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../theme/vault_colors.dart';

/// SCR-035 Vault Search & Occupancy
///
/// Allows users to locate pledged assets instantly and view vault occupancy
/// metrics. Search methods include Girvi ID, customer name, mobile, serial
/// asset ID, and QR scan.
class VaultSearchPage extends StatefulWidget {
  const VaultSearchPage({super.key});

  static const routeName = 'vault-search';

  @override
  State<VaultSearchPage> createState() => _VaultSearchPageState();
}

class _VaultSearchPageState extends State<VaultSearchPage> {
  String _searchMode = 'Girvi ID';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _searchModes = const [
    'Girvi ID',
    'Customer',
    'Mobile',
    'Serial ID',
    'QR',
  ];

  final List<Map<String, dynamic>> _mockResults = const [
    {
      'customer': 'Ramesh Patil',
      'girviId': 'GRV-2026-000042',
      'serialId': 'SA-2026-000042',
      'status': 'Active',
      'coordinate': 'VA-A/SF-02/TR-05/SL-18',
      'mobile': '9876543210',
    },
    {
      'customer': 'Suresh Jadhav',
      'girviId': 'GRV-2026-000038',
      'serialId': 'SA-2026-000038',
      'status': 'Partial Paid',
      'coordinate': 'VA-A/SF-01/TR-03/SL-07',
      'mobile': '9123456780',
    },
    {
      'customer': 'Asha Desai',
      'girviId': 'GRV-2026-000021',
      'serialId': 'SA-2026-000021',
      'status': 'Renewed',
      'coordinate': 'VA-B/SF-03/TR-08/SL-02',
      'mobile': '9988776655',
    },
  ];

  final List<Map<String, dynamic>> _mockOccupancy = const [
    {'vault': 'Vault-A', 'occupied': 42, 'total': 80},
    {'vault': 'Vault-B', 'occupied': 64, 'total': 80},
    {'vault': 'Vault-C', 'occupied': 18, 'total': 60},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _totalSlots {
    return _mockOccupancy.fold<int>(
      0,
      (sum, item) => sum + (item['total'] as int),
    );
  }

  int get _occupiedSlots {
    return _mockOccupancy.fold<int>(
      0,
      (sum, item) => sum + (item['occupied'] as int),
    );
  }

  int get _availableSlots => _totalSlots - _occupiedSlots;

  double get _occupancyPercentage {
    if (_totalSlots == 0) return 0;
    return (_occupiedSlots / _totalSlots) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'तिजोरी शोध आणि व्याप्ती',
              titleEn: 'Vault Search & Occupancy',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SearchBar(
                      controller: _searchController,
                      searchMode: _searchMode,
                      onChanged: (value) => setState(() {}),
                      onScanTap: () {
                        // TODO: open QR scanner.
                      },
                    ),
                    const SizedBox(height: 12),
                    _SearchModeChips(
                      modes: _searchModes,
                      selected: _searchMode,
                      onSelected: (mode) => setState(() => _searchMode = mode),
                    ),
                    const SizedBox(height: 20),
                    _OccupancySummary(
                      total: _totalSlots,
                      occupied: _occupiedSlots,
                      available: _availableSlots,
                      percentage: _occupancyPercentage,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      titleMr: 'तिजोरी व्याप्ती हीटमॅप',
                      titleEn: 'Vault Occupancy Heat Map',
                    ),
                    const SizedBox(height: 12),
                    ..._mockOccupancy.map((item) => _VaultHeatMap(item: item)),
                    const SizedBox(height: 24),
                    _SectionTitle(
                      titleMr: 'शोध निकाल',
                      titleEn: 'Search Results',
                    ),
                    const SizedBox(height: 12),
                    if (_searchController.text.isEmpty)
                      const _EmptySearchState()
                    else
                      ..._mockResults.map((item) => _SearchResultCard(item: item)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.searchMode,
    required this.onChanged,
    required this.onScanTap,
  });

  final TextEditingController controller;
  final String searchMode;
  final ValueChanged<String> onChanged;
  final VoidCallback onScanTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VaultColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: VaultColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: '$searchMode ने शोधा / Search by $searchMode',
                hintStyle: const TextStyle(
                  color: VaultColors.muted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (searchMode == 'QR')
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: VaultColors.navy),
              onPressed: onScanTap,
            ),
        ],
      ),
    );
  }
}

class _SearchModeChips extends StatelessWidget {
  const _SearchModeChips({
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> modes;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: modes.map((mode) {
        final isSelected = mode == selected;
        return ChoiceChip(
          label: Text(mode),
          selected: isSelected,
          onSelected: (_) => onSelected(mode),
          selectedColor: VaultColors.navy,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : VaultColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isSelected ? VaultColors.navy : VaultColors.line,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _OccupancySummary extends StatelessWidget {
  const _OccupancySummary({
    required this.total,
    required this.occupied,
    required this.available,
    required this.percentage,
  });

  final int total;
  final int occupied;
  final int available;
  final double percentage;

  Color get _statusColor {
    if (percentage >= 81) return VaultColors.red;
    if (percentage >= 51) return VaultColors.orange;
    return VaultColors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VaultColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'एकूण व्याप्ती / Total Occupancy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: VaultColors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : occupied / total,
              minHeight: 10,
              backgroundColor: VaultColors.line,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MetricBox(
                labelMr: 'एकूण',
                labelEn: 'Total',
                value: total.toString(),
                color: VaultColors.navy,
              ),
              const SizedBox(width: 10),
              _MetricBox(
                labelMr: 'व्यस्त',
                labelEn: 'Occupied',
                value: occupied.toString(),
                color: VaultColors.red,
              ),
              const SizedBox(width: 10),
              _MetricBox(
                labelMr: 'उपलब्ध',
                labelEn: 'Available',
                value: available.toString(),
                color: VaultColors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.color,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$labelMr / $labelEn',
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.7),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VaultHeatMap extends StatelessWidget {
  const _VaultHeatMap({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final occupied = item['occupied'] as int;
    final total = item['total'] as int;
    final percentage = total == 0 ? 0.0 : occupied / total;

    Color barColor;
    if (percentage >= 0.81) {
      barColor = VaultColors.red;
    } else if (percentage >= 0.51) {
      barColor = VaultColors.orange;
    } else {
      barColor = VaultColors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VaultColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['vault'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: VaultColors.ink,
                ),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(0)}% Occupied',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12,
              backgroundColor: VaultColors.line,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$occupied occupied • ${total - occupied} available',
            style: const TextStyle(
              fontSize: 12,
              color: VaultColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VaultColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['customer'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: VaultColors.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: VaultColors.cream,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['status'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: VaultColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ResultRow(icon: Icons.confirmation_number_outlined, text: item['girviId'] as String),
          const SizedBox(height: 6),
          _ResultRow(icon: Icons.qr_code_2_outlined, text: item['serialId'] as String),
          const SizedBox(height: 6),
          _ResultRow(icon: Icons.phone_outlined, text: item['mobile'] as String),
          const Divider(height: 22, color: VaultColors.line),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: VaultColors.navy,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item['coordinate'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: VaultColors.navy,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: copy coordinate to clipboard.
                },
                child: const Icon(
                  Icons.copy_outlined,
                  size: 18,
                  color: VaultColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: navigate to Girvi details.
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Girvi'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VaultColors.navy,
                    side: const BorderSide(color: VaultColors.navy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: navigate to customer details.
                  },
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: const Text('Customer'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: VaultColors.navy,
                    side: const BorderSide(color: VaultColors.navy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: VaultColors.muted),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: VaultColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VaultColors.line),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 48,
            color: VaultColors.muted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'शोधण्यासाठी वर टाइप करा',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: VaultColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Type above to search vault locations',
            style: TextStyle(
              fontSize: 12,
              color: VaultColors.muted,
              fontWeight: FontWeight.w600,
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
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: VaultColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: VaultColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
