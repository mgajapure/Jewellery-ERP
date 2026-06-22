import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_header.dart';
import '../theme/inventory_colors.dart';

/// SCR-048 Inventory List
///
/// View and manage jewellery stock available for retail sales.
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  static const routeName = 'inventory-list';

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  String _filter = 'All';

  final List<String> _filters = const [
    'सर्व / All',
    'उपलब्ध / Available',
    'राखीव / Reserved',
    'विकले / Sold',
    'कमी स्टॉक / Low Stock',
  ];

  final List<Map<String, dynamic>> _items = const [
    {
      'barcode': 'INV-2026-000001',
      'name': '22K Gold Necklace',
      'category': 'Gold Jewellery',
      'weight': '15.50',
      'purity': '22K',
      'price': '₹98,500',
      'status': 'Available',
    },
    {
      'barcode': 'INV-2026-000002',
      'name': 'Diamond Ring',
      'category': 'Diamond',
      'weight': '4.20',
      'purity': '18K',
      'price': '₹65,000',
      'status': 'Reserved',
    },
    {
      'barcode': 'INV-2026-000003',
      'name': 'Silver Payal',
      'category': 'Silver Jewellery',
      'weight': '25.00',
      'purity': '925',
      'price': '₹12,000',
      'status': 'Available',
    },
    {
      'barcode': 'INV-2026-000004',
      'name': 'Gold Coin 10g',
      'category': 'Bullion',
      'weight': '10.00',
      'purity': '24K',
      'price': '₹72,000',
      'status': 'Sold',
    },
    {
      'barcode': 'INV-2026-000005',
      'name': 'Platinum Band',
      'category': 'Platinum',
      'weight': '6.50',
      'purity': '950',
      'price': '₹45,000',
      'status': 'Low Stock',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_filter == 'सर्व / All') return _items;
    return _items.where((item) {
      final status = item['status'] as String;
      switch (_filter) {
        case 'उपलब्ध / Available':
          return status == 'Available';
        case 'राखीव / Reserved':
          return status == 'Reserved';
        case 'विकले / Sold':
          return status == 'Sold';
        case 'कमी स्टॉक / Low Stock':
          return status == 'Low Stock';
        default:
          return true;
      }
    }).toList();
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
                  icon: const Icon(Icons.add_circle, color: InventoryColors.ink),
                  tooltip: 'नवीन वस्तू / New Item',
                  onPressed: () {
                    // TODO: navigate to create inventory item.
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchBar(
                onScanTap: () {
                  // TODO: open barcode scanner.
                },
              ),
            ),
            _FilterChips(
              filters: _filters,
              selected: _filter,
              onSelected: (filter) => setState(() => _filter = filter),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: _filteredItems
                    .map((item) => _InventoryCard(item: item))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onScanTap});

  final VoidCallback onScanTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InventoryColors.line),
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
          const Icon(Icons.search, color: InventoryColors.muted, size: 22),
          const SizedBox(width: 12),
          const Text(
            'बारकोड, नाव, श्रेणी किंवा टॅग शोधा',
            style: TextStyle(
              color: InventoryColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.qr_code_scanner,
            color: InventoryColors.muted,
            size: 22,
          ),
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

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selected;
          return ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? InventoryColors.gold : InventoryColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(filter),
            selectedColor: InventoryColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? InventoryColors.navy : InventoryColors.line,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.item});

  final Map<String, dynamic> item;

  Color get _statusColor {
    switch (item['status'] as String) {
      case 'Available':
        return InventoryColors.green;
      case 'Reserved':
        return InventoryColors.orange;
      case 'Sold':
        return InventoryColors.red;
      case 'Low Stock':
        return InventoryColors.blue;
      default:
        return InventoryColors.muted;
    }
  }

  String get _statusText {
    switch (item['status'] as String) {
      case 'Available':
        return 'उपलब्ध / Available';
      case 'Reserved':
        return 'राखीव / Reserved';
      case 'Sold':
        return 'विकले / Sold';
      case 'Low Stock':
        return 'कमी स्टॉक / Low Stock';
      default:
        return item['status'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed('inventory-details'),
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['barcode'] as String,
                        style: const TextStyle(
                          color: InventoryColors.navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: InventoryColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
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
                    _statusText,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'वजन',
                    labelEn: 'Weight',
                    value: '${item['weight']} g',
                  ),
                ),
                Container(width: 1, height: 30, color: InventoryColors.line),
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'शुद्धता',
                    labelEn: 'Purity',
                    value: item['purity'] as String,
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: InventoryColors.line),
            Row(
              children: [
                _MetaChip(
                  icon: Icons.category_outlined,
                  label: item['category'] as String,
                ),
                const Spacer(),
                Text(
                  item['price'] as String,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: InventoryColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          labelEn,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: InventoryColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: InventoryColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
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
