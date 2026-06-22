import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    'All',
    'Available',
    'Reserved',
    'Sold',
    'Low Stock',
  ];

  final List<Map<String, dynamic>> _items = const [
    {
      'barcode': 'INV-2026-000001',
      'name': '22K Gold Necklace',
      'category': 'Gold Jewellery',
      'weight': '15.50',
      'purity': '22K',
      'price': 98500.0,
      'status': 'Available',
    },
    {
      'barcode': 'INV-2026-000002',
      'name': 'Diamond Ring',
      'category': 'Diamond',
      'weight': '4.20',
      'purity': '18K',
      'price': 65000.0,
      'status': 'Reserved',
    },
    {
      'barcode': 'INV-2026-000003',
      'name': 'Silver Payal',
      'category': 'Silver Jewellery',
      'weight': '25.00',
      'purity': '925',
      'price': 12000.0,
      'status': 'Available',
    },
    {
      'barcode': 'INV-2026-000004',
      'name': 'Gold Coin 10g',
      'category': 'Bullion',
      'weight': '10.00',
      'purity': '24K',
      'price': 72000.0,
      'status': 'Sold',
    },
    {
      'barcode': 'INV-2026-000005',
      'name': 'Platinum Band',
      'category': 'Platinum',
      'weight': '6.50',
      'purity': '950',
      'price': 45000.0,
      'status': 'Low Stock',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_filter == 'All') return _items;
    return _items.where((item) => item['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InventoryColors.screenBg,
      appBar: AppBar(
        backgroundColor: InventoryColors.navy,
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
              'इन्व्हेंटरी',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Inventory',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // TODO: open barcode scanner.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(
              onScanTap: () {
                // TODO: open barcode scanner.
              },
            ),
            _FilterChips(
              filters: _filters,
              selected: _filter,
              onSelected: (filter) => setState(() => _filter = filter),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _filteredItems
                    .map((item) => _InventoryCard(item: item))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: navigate to create inventory item.
        },
        backgroundColor: InventoryColors.navy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InventoryColors.line),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: InventoryColors.muted),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'बारकोड, नाव, श्रेणी किंवा टॅग शोधा / Search',
                hintStyle: TextStyle(
                  color: InventoryColors.muted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: InventoryColors.navy),
            onPressed: onScanTap,
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
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selected;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => onSelected(filter),
            selectedColor: InventoryColors.navy,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : InventoryColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InventoryColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: InventoryColors.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['status'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item['barcode'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: InventoryColors.navy,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.category_outlined,
                text: item['category'] as String,
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.scale_outlined,
                text: '${item['weight']} g',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.diamond_outlined,
                text: item['purity'] as String,
              ),
            ],
          ),
          const Divider(height: 24, color: InventoryColors.line),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${(item['price'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: InventoryColors.ink,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined, size: 20),
                    color: InventoryColors.navy,
                    onPressed: () {
                      // TODO: view item details.
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.print_outlined, size: 20),
                    color: InventoryColors.muted,
                    onPressed: () {
                      // TODO: print barcode.
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: InventoryColors.screenBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: InventoryColors.muted),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: InventoryColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
