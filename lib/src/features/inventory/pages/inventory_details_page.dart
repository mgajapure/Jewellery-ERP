import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/inventory_item.dart';
import '../theme/inventory_colors.dart';
import 'inventory_list_page.dart';

/// SCR-049 Inventory Item Details
class InventoryDetailsPage extends StatelessWidget {
  const InventoryDetailsPage({super.key, required this.item});

  static const routeName = 'inventory-details';

  final InventoryItem item;

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
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderCard(
                item: item,
                statusColor: _statusColor,
                amtFmt: amtFmt,
              ),
              const SizedBox(height: 14),
              _SectionCard(
                titleMr: 'मूळ तपशील',
                titleEn: 'Basic Details',
                rows: [
                  _DetailRow(label: 'Barcode', value: item.barcode),
                  _DetailRow(label: 'Item Name', value: item.name),
                  _DetailRow(label: 'Category', value: item.category),
                  if (item.description.isNotEmpty)
                    _DetailRow(
                        label: 'Description', value: item.description),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                titleMr: 'दागिने तपशील',
                titleEn: 'Jewellery Details',
                rows: [
                  _DetailRow(label: 'Metal Type', value: item.metalType),
                  _DetailRow(
                    label: 'Gross Weight',
                    value: '${item.grossWeight.toStringAsFixed(2)} g',
                  ),
                  _DetailRow(
                    label: 'Net Weight',
                    value: '${item.netWeight.toStringAsFixed(2)} g',
                  ),
                  _DetailRow(label: 'Purity', value: item.purity),
                  _DetailRow(
                    label: 'Making Charges',
                    value: '₹ ${amtFmt.format(item.makingCharges)}',
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
                    value: '₹ ${amtFmt.format(item.costPrice)}',
                  ),
                  _DetailRow(
                    label: 'Selling Price',
                    value: '₹ ${amtFmt.format(item.sellingPrice)}',
                    valueColor: InventoryColors.green,
                  ),
                  _DetailRow(
                    label: 'GST',
                    value: '₹ ${amtFmt.format(item.gst)}',
                  ),
                  _DetailRow(
                    label: 'Total Amount',
                    value: '₹ ${amtFmt.format(item.totalAmount)}',
                    valueColor: InventoryColors.navy,
                  ),
                  _DetailRow(
                    label: 'Profit Margin',
                    value: '${item.marginPercent.toStringAsFixed(2)}%',
                    valueColor: InventoryColors.gold,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ImageGallery(),
              const SizedBox(height: 12),
              if (item.movements.isNotEmpty)
                _MovementHistory(movements: item.movements),
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
                  onPressed: item.status == InventoryStatus.available
                      ? () {}
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: InventoryColors.orange,
                    side: const BorderSide(color: InventoryColors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('राखीव / Reserve'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: item.status == InventoryStatus.available
                      ? () {}
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: InventoryColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('विकले / Mark Sold'),
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
  const _HeaderCard({
    required this.item,
    required this.statusColor,
    required this.amtFmt,
  });

  final InventoryItem item;
  final Color statusColor;
  final NumberFormat amtFmt;

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
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${item.status.labelMr} / ${item.status.labelEn}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.barcode,
            style: const TextStyle(
              fontSize: 13,
              color: InventoryColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '₹ ${amtFmt.format(item.sellingPrice)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.metalType} • ${item.purity} • ${item.grossWeight.toStringAsFixed(2)} g',
            style: const TextStyle(fontSize: 12, color: Colors.white60),
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
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: InventoryColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$titleMr / $titleEn',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: InventoryColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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
                fontWeight: FontWeight.w600,
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
          const Row(
            children: [
              Text(
                'फोटो / Images',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: InventoryColors.ink,
                ),
              ),
            ],
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

  final List<InventoryMovement> movements;

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

  final InventoryMovement movement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: InventoryColors.line)),
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
                  movement.action,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: InventoryColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${movement.date} • ${movement.user} • ${movement.reference}',
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
