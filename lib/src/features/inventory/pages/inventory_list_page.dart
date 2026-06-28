import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/inventory_item.dart';
import '../presentation/bloc/inventory_list_bloc.dart';
import '../theme/inventory_colors.dart';
import 'add_inventory_item_page.dart';
import 'inventory_details_page.dart';

/// SCR-048 Inventory List
class InventoryListPage extends StatelessWidget {
  const InventoryListPage({super.key});

  static const routeName = 'inventory-list';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<InventoryListBloc>()..add(InventoryListStarted()),
      child: const _InventoryListScaffold(),
    );
  }
}

class _InventoryListScaffold extends StatefulWidget {
  const _InventoryListScaffold();

  @override
  State<_InventoryListScaffold> createState() => _InventoryListScaffoldState();
}

class _InventoryListScaffoldState extends State<_InventoryListScaffold> {
  final _searchCtrl = TextEditingController();

  static const _filters = [
    ('', 'सर्व / All'),
    ('AVAILABLE', 'उपलब्ध / Available'),
    ('RESERVED', 'राखीव / Reserved'),
    ('SOLD', 'विकले / Sold'),
    ('LOW_STOCK', 'कमी स्टॉक / Low Stock'),
    ('DAMAGED', 'खराब / Damaged'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InventoryColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'इन्व्हेंटरी यादी',
              titleEn: 'Inventory List',
              showBackButton: true,
              backFallbackRoute: 'more',
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: InventoryColors.navy),
                  tooltip: 'नवीन वस्तू / New Item',
                  onPressed: () =>
                      context.goNamed(AddInventoryItemPage.routeName),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _SearchBar(
                controller: _searchCtrl,
                onChanged: (q) => context
                    .read<InventoryListBloc>()
                    .add(InventoryListSearchChanged(query: q)),
              ),
            ),
            BlocBuilder<InventoryListBloc, InventoryListState>(
              builder: (context, state) {
                final current =
                    state is InventoryListLoaded ? state.filter : '';
                return _FilterChips(
                  filters: _filters,
                  selected: current,
                  onSelected: (f) => context
                      .read<InventoryListBloc>()
                      .add(InventoryListFilterChanged(filter: f)),
                );
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: BlocBuilder<InventoryListBloc, InventoryListState>(
                builder: (context, state) {
                  if (state is InventoryListLoading ||
                      state is InventoryListInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: InventoryColors.navy,
                      ),
                    );
                  }
                  if (state is InventoryListError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () => context
                          .read<InventoryListBloc>()
                          .add(InventoryListRefreshed()),
                    );
                  }
                  if (state is InventoryListLoaded) {
                    return _LoadedView(state: state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InventoryColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: InventoryColors.muted, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'बारकोड, नाव, श्रेणी शोधा / Search...',
                hintStyle: TextStyle(
                  color: InventoryColors.muted,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const Icon(Icons.qr_code_scanner,
              color: InventoryColors.muted, size: 20),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<(String, String)> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (value, label) = filters[index];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                color: isSelected ? InventoryColors.gold : InventoryColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(value),
            selectedColor: InventoryColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? InventoryColors.navy
                    : InventoryColors.line,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});

  final InventoryListLoaded state;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0', 'en_IN');
    return RefreshIndicator(
      color: InventoryColors.navy,
      onRefresh: () async {
        context.read<InventoryListBloc>().add(InventoryListRefreshed());
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _SummaryRow(
            totalItems: state.items.length,
            available: state.availableCount,
            totalValue: state.totalValue,
            amtFmt: amtFmt,
          ),
          const SizedBox(height: 12),
          if (state.items.isEmpty)
            const _EmptyView()
          else
            ...state.items.map(
              (item) => _InventoryCard(
                item: item,
                onTap: () => context.goNamed(
                  InventoryDetailsPage.routeName,
                  pathParameters: {'id': item.id},
                  extra: item,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.totalItems,
    required this.available,
    required this.totalValue,
    required this.amtFmt,
  });

  final int totalItems;
  final int available;
  final double totalValue;
  final NumberFormat amtFmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: InventoryColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _StatCell(
            label: 'एकूण / Total',
            value: totalItems.toString(),
          ),
          Container(width: 1, height: 36, color: Colors.white24),
          _StatCell(
            label: 'उपलब्ध / Available',
            value: available.toString(),
          ),
          Container(width: 1, height: 36, color: Colors.white24),
          _StatCell(
            label: 'एकूण मूल्य / Value',
            value: '₹${amtFmt.format(totalValue)}',
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.item, required this.onTap});

  final InventoryItem item;
  final VoidCallback onTap;

  Color get _statusColor {
    switch (item.status) {
      case InventoryStatus.available:
        return InventoryColors.green;
      case InventoryStatus.reserved:
        return InventoryColors.orange;
      case InventoryStatus.sold:
        return InventoryColors.red;
      case InventoryStatus.lowStock:
        return InventoryColors.blue;
      case InventoryStatus.damaged:
        return InventoryColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: InventoryColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.barcode,
                        style: const TextStyle(
                          color: InventoryColors.navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: InventoryColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${item.status.labelMr} / ${item.status.labelEn}',
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'वजन',
                    labelEn: 'Weight',
                    value: '${item.grossWeight.toStringAsFixed(2)} g',
                  ),
                ),
                Container(
                    width: 1, height: 30, color: InventoryColors.line),
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'शुद्धता',
                    labelEn: 'Purity',
                    value: item.purity,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: InventoryColors.line),
            Row(
              children: [
                _MetaChip(
                  icon: Icons.category_outlined,
                  label: item.category,
                ),
                const Spacer(),
                Text(
                  '₹${amtFmt.format(item.sellingPrice)}',
                  style: const TextStyle(
                    color: InventoryColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: InventoryColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            color: InventoryColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: InventoryColors.ink,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: InventoryColors.muted),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: InventoryColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 56, color: InventoryColors.muted),
            SizedBox(height: 12),
            Text(
              'कोणती वस्तू आढळली नाही\nNo items found',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: InventoryColors.muted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: InventoryColors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: InventoryColors.ink),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: InventoryColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: BilingualText(en: 'Retry', mr: 'पुन्हा प्रयत्न', compact: true),
            ),
          ],
        ),
      ),
    );
  }
}
