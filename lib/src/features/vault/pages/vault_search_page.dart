import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/vault_search_result.dart';
import '../presentation/bloc/vault_search_bloc.dart';
import '../presentation/bloc/vault_search_event.dart';
import '../presentation/bloc/vault_search_state.dart';
import '../theme/vault_colors.dart';

/// SCR-035 Vault Search & Occupancy
///
/// Allows users to locate pledged assets instantly and view vault occupancy
/// metrics. Search methods include Girvi ID, Customer, Mobile, Serial ID, QR.
class VaultSearchPage extends StatelessWidget {
  const VaultSearchPage({super.key});

  static const routeName = 'vault-search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<VaultSearchBloc>()
        ..add(const VaultSearchStarted()),
      child: const _VaultSearchView(),
    );
  }
}

class _VaultSearchView extends StatefulWidget {
  const _VaultSearchView();

  @override
  State<_VaultSearchView> createState() => _VaultSearchViewState();
}

class _VaultSearchViewState extends State<_VaultSearchView> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchMode = 'Girvi ID';

  static const _searchModes = [
    'Girvi ID',
    'Customer',
    'Mobile',
    'Serial ID',
    'QR',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<VaultSearchBloc>().add(
          VaultSearchQueryChanged(query: value, searchMode: _searchMode),
        );
  }

  void _onModeChanged(String mode) {
    setState(() => _searchMode = mode);
    if (_searchCtrl.text.isNotEmpty) {
      context.read<VaultSearchBloc>().add(
            VaultSearchQueryChanged(
              query: _searchCtrl.text,
              searchMode: mode,
            ),
          );
    }
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
              child: BlocBuilder<VaultSearchBloc, VaultSearchState>(
                builder: (context, state) {
                  if (state is VaultSearchLoading ||
                      state is VaultSearchInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is VaultSearchError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: VaultColors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(
                                  color: VaultColors.muted, fontSize: 14)),
                        ],
                      ),
                    );
                  }
                  final ready = state as VaultSearchReady;
                  return RefreshIndicator(
                    color: VaultColors.navy,
                    onRefresh: () async =>
                        context
                            .read<VaultSearchBloc>()
                            .add(const VaultSearchRefreshed()),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SearchBar(
                            controller: _searchCtrl,
                            searchMode: _searchMode,
                            isSearching: ready.isSearching,
                            onChanged: _onSearchChanged,
                            onScanTap: () async {
                              final scanned = await showModalBottomSheet<String>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const _QrScannerModal(),
                              );
                              if (scanned != null && mounted) {
                                _searchCtrl.text = scanned;
                                _onSearchChanged(scanned);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _SearchModeChips(
                            modes: _searchModes,
                            selected: _searchMode,
                            onSelected: _onModeChanged,
                          ),
                          const SizedBox(height: 20),
                          _OccupancySummary(
                            total: ready.totalSlots,
                            occupied: ready.occupiedSlots,
                            available: ready.availableSlots,
                            percentage: ready.occupancyPercentage,
                          ),
                          const SizedBox(height: 20),
                          const _SectionTitle(
                            titleMr: 'तिजोरी व्याप्ती हीटमॅप',
                            titleEn: 'Vault Occupancy Heat Map',
                          ),
                          const SizedBox(height: 12),
                          ...ready.occupancy.map(
                            (v) => _VaultHeatMap(occupancy: v),
                          ),
                          const SizedBox(height: 24),
                          const _SectionTitle(
                            titleMr: 'शोध निकाल',
                            titleEn: 'Search Results',
                          ),
                          const SizedBox(height: 12),
                          if (_searchCtrl.text.isEmpty)
                            const _EmptySearchState()
                          else if (ready.isSearching)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: VaultColors.navy,
                                ),
                              ),
                            )
                          else if (ready.searchResults == null ||
                              ready.searchResults!.isEmpty)
                            _NoResultsState(query: ready.query)
                          else
                            ...ready.searchResults!.map(
                              (r) => _SearchResultCard(result: r),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.searchMode,
    required this.isSearching,
    required this.onChanged,
    required this.onScanTap,
  });

  final TextEditingController controller;
  final String searchMode;
  final bool isSearching;
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
                hintText:
                    '$searchMode ने शोधा / Search by $searchMode',
                hintStyle: const TextStyle(
                  color: VaultColors.muted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (isSearching)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: VaultColors.navy,
              ),
            )
          else if (searchMode == 'QR')
            IconButton(
              icon: const Icon(Icons.qr_code_scanner,
                  color: VaultColors.navy),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(25),
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
              valueColor:
                  AlwaysStoppedAnimation<Color>(_statusColor),
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
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$labelMr / $labelEn',
              style: TextStyle(
                fontSize: 11,
                color: color.withAlpha(180),
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
  const _VaultHeatMap({required this.occupancy});

  final VaultOccupancy occupancy;

  @override
  Widget build(BuildContext context) {
    final pct = occupancy.percentage / 100;
    final Color barColor;
    if (occupancy.percentage >= 81) {
      barColor = VaultColors.red;
    } else if (occupancy.percentage >= 51) {
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
                occupancy.vaultName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: VaultColors.ink,
                ),
              ),
              Text(
                '${occupancy.percentage.toStringAsFixed(0)}% Occupied',
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
              value: pct,
              minHeight: 12,
              backgroundColor: VaultColors.line,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${occupancy.occupied} occupied · ${occupancy.available} available',
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
  const _SearchResultCard({required this.result});

  final VaultSearchResult result;

  Color get _statusColor {
    switch (result.status.toLowerCase()) {
      case 'active':
        return VaultColors.green;
      case 'overdue':
        return VaultColors.red;
      case 'partial paid':
        return VaultColors.orange;
      default:
        return VaultColors.navy;
    }
  }

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
                  result.customerName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: VaultColors.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.confirmation_number_outlined,
            text: result.girviId,
          ),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.qr_code_2_outlined, text: result.serialId),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.phone_outlined, text: result.mobile),
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
                  result.coordinate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: VaultColors.navy,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: result.coordinate));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: BilingualText(en: 'Coordinate copied', mr: 'कोऑर्डिनेट कॉपी केले', compact: true),
                      duration: Duration(seconds: 1),
                    ),
                  );
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
                    // Navigate to Girvi details
                  },
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: BilingualText(en: 'View Girvi', mr: 'गिरवी पहा', compact: true),
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
                    // Navigate to Customer details
                  },
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: BilingualText(en: 'Customer', mr: 'ग्राहक', compact: true),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

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
            color: VaultColors.muted.withAlpha(128),
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
          const Text(
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

class _NoResultsState extends StatelessWidget {
  const _NoResultsState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VaultColors.line),
      ),
      child: Column(
        children: [
          Icon(
            Icons.find_in_page_outlined,
            size: 48,
            color: VaultColors.muted.withAlpha(128),
          ),
          const SizedBox(height: 12),
          const Text(
            'कोणतेही निकाल आढळले नाहीत',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: VaultColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No results found for "$query"',
            style: const TextStyle(
              fontSize: 12,
              color: VaultColors.muted,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QrScannerModal extends StatefulWidget {
  const _QrScannerModal();

  @override
  State<_QrScannerModal> createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<_QrScannerModal> {
  final MobileScannerController _ctrl = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue;
    if (value != null && value.isNotEmpty) {
      setState(() => _scanned = true);
      Navigator.pop(context, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'QR स्कॅन करा / Scan QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                controller: _ctrl,
                onDetect: _onDetect,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'QR कोड फ्रेममध्ये ठेवा / Place QR code within frame',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
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
