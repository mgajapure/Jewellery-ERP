import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/inventory_colors.dart';
import 'inventory_list_page.dart';

/// SCR-049 Inventory Item Details
///
/// Complete stock information for a single inventory item including
/// jewellery details, pricing, images, and movement history.
class InventoryDetailsPage extends StatelessWidget {
  const InventoryDetailsPage({super.key});

  static const routeName = 'inventory-details';

  final Map<String, dynamic> _item = const {
    'barcode': 'INV-2026-000001',
    'name': '22K Gold Necklace',
    'category': 'Gold Jewellery',
    'description': 'Traditional 22K gold necklace with intricate design.',
    'metalType': 'Gold',
    'grossWeight': 16.20,
    'netWeight': 15.50,
    'purity': '22K',
    'makingCharges': 8500.0,
    'costPrice': 82000.0,
    'sellingPrice': 98500.0,
    'status': 'Available',
  };

  final List<Map<String, dynamic>> _movements = const [
    {
      'date': '15 Jan 2026',
      'action': 'Created',
      'user': 'Admin',
      'reference': 'PUR-2026-00010',
    },
    {
      'date': '18 Jan 2026',
      'action': 'Price Updated',
      'user': 'Manager',
      'reference': '-',
    },
    {
      'date': '20 Jan 2026',
      'action': 'Available',
      'user': 'System',
      'reference': '-',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final margin = (_item['sellingPrice'] as double) -
        (_item['costPrice'] as double);
    final marginPercent =
        (margin / (_item['costPrice'] as double)) * 100;

    return Scaffold(
      backgroundColor: InventoryColors.screenBg,
      appBar: AppBar(
        backgroundColor: InventoryColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            InventoryListPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'इन्व्हेंटरी तपशील',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Inventory Details',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: edit item.
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              // TODO: print barcode.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderCard(item: _item),
              const SizedBox(height: 16),
              _SectionCard(
                titleMr: 'मूळ तपशील',
                titleEn: 'Basic Details',
                rows: [
                  _DetailRow(label: 'Barcode', value: _item['barcode'] as String),
                  _DetailRow(label: 'Item Name', value: _item['name'] as String),
                  _DetailRow(label: 'Category', value: _item['category'] as String),
                  _DetailRow(
                    label: 'Description',
                    value: _item['description'] as String,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                titleMr: 'दागिने तपशील',
                titleEn: 'Jewellery Details',
                rows: [
                  _DetailRow(label: 'Metal Type', value: _item['metalType'] as String),
                  _DetailRow(
                    label: 'Gross Weight',
                    value: '${_item['grossWeight']} g',
                  ),
                  _DetailRow(
                    label: 'Net Weight',
                    value: '${_item['netWeight']} g',
                  ),
                  _DetailRow(label: 'Purity', value: _item['purity'] as String),
                  _DetailRow(
                    label: 'Making Charges',
                    value: '₹ ${(_item['makingCharges'] as double).toStringAsFixed(2)}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                titleMr: 'किंमत',
                titleEn: 'Pricing',
                rows: [
                  _DetailRow(
                    label: 'Cost Price',
                    value: '₹ ${(_item['costPrice'] as double).toStringAsFixed(2)}',
                  ),
                  _DetailRow(
                    label: 'Selling Price',
                    value: '₹ ${(_item['sellingPrice'] as double).toStringAsFixed(2)}',
                    valueColor: InventoryColors.green,
                  ),
                  _DetailRow(
                    label: 'Profit Margin',
                    value: '${marginPercent.toStringAsFixed(2)}%',
                    valueColor: InventoryColors.gold,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ImageGallery(),
              const SizedBox(height: 12),
              _MovementHistory(movements: _movements),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: InventoryColors.line)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: mark as reserved.
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: InventoryColors.orange,
                    side: const BorderSide(color: InventoryColors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Reserve'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: mark as sold.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: InventoryColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Mark Sold'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.item});

  final Map<String, dynamic> item;

  Color get _statusColor {
    switch (item['status'] as String) {
      case 'Available':
        return InventoryColors.green;
      case 'Reserved':
        return InventoryColors.orange;
      case 'Sold':
        return InventoryColors.red;
      default:
        return InventoryColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: InventoryColors.navy,
        borderRadius: BorderRadius.circular(20),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item['barcode'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: InventoryColors.gold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '₹ ${(item['sellingPrice'] as double).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.titleMr,
    required this.titleEn,
    required this.rows,
  });

  final String titleMr;
  final String titleEn;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InventoryColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titleMr / $titleEn',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: InventoryColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = InventoryColors.ink,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: InventoryColors.muted,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InventoryColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'फोटो / Images',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: InventoryColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ImagePlaceholder(),
              const SizedBox(width: 10),
              _ImagePlaceholder(),
              const SizedBox(width: 10),
              _ImagePlaceholder(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: InventoryColors.screenBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InventoryColors.line),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: InventoryColors.muted,
      ),
    );
  }
}

class _MovementHistory extends StatelessWidget {
  const _MovementHistory({required this.movements});

  final List<Map<String, dynamic>> movements;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InventoryColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'हालचाल इतिहास / Movement History',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: InventoryColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          ...movements.map((m) => _MovementRow(movement: m)),
        ],
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.movement});

  final Map<String, dynamic> movement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: InventoryColors.line),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: InventoryColors.navy,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement['action'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: InventoryColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${movement['date']} • ${movement['user']} • ${movement['reference']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: InventoryColors.muted,
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
