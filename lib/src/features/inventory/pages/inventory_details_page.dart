import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/inventory_item.dart';
import '../presentation/bloc/inventory_detail_bloc.dart';
import '../theme/inventory_colors.dart';
import 'inventory_list_page.dart';

/// SCR-049 Inventory Item Details
class InventoryDetailsPage extends StatelessWidget {
  const InventoryDetailsPage({super.key, required this.item});

  static const routeName = 'inventory-details';

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<InventoryDetailBloc>(),
      child: _InventoryDetailsScaffold(item: item),
    );
  }
}

class _InventoryDetailsScaffold extends StatefulWidget {
  const _InventoryDetailsScaffold({required this.item});

  final InventoryItem item;

  @override
  State<_InventoryDetailsScaffold> createState() =>
      _InventoryDetailsScaffoldState();
}

class _InventoryDetailsScaffoldState
    extends State<_InventoryDetailsScaffold> {
  late InventoryItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Color _statusColor(InventoryStatus status) {
    switch (status) {
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
    return BlocListener<InventoryDetailBloc, InventoryDetailState>(
      listener: (context, state) {
        if (state is InventoryDetailUpdateSuccess) {
          setState(() => _item = state.item);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: BilingualText(en: 'Status updated!', mr: 'स्थिती अद्यतनित!', compact: true),
              backgroundColor: InventoryColors.green,
            ),
          );
        }
        if (state is InventoryDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: InventoryColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: InventoryColors.screenBg,
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                titleMr: 'इन्व्हेंटरी तपशील',
                titleEn: 'Inventory Details',
                showBackButton: true,
                backFallbackRoute: InventoryListPage.routeName,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.print_outlined, color: Color(0xFF071A49)),
                    onPressed: () => _showPrintDialog(context),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(
                  item: _item,
                  statusColor: _statusColor(_item.status),
                  amtFmt: amtFmt,
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  titleMr: 'मूळ तपशील',
                  titleEn: 'Basic Details',
                  rows: [
                    _DetailRow(label: 'Barcode', value: _item.barcode),
                    _DetailRow(label: 'Item Name', value: _item.name),
                    _DetailRow(label: 'Category', value: _item.category),
                    if (_item.description.isNotEmpty)
                      _DetailRow(
                          label: 'Description', value: _item.description),
                  ],
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  titleMr: 'दागिने तपशील',
                  titleEn: 'Jewellery Details',
                  rows: [
                    _DetailRow(label: 'Metal Type', value: _item.metalType),
                    _DetailRow(
                      label: 'Gross Weight',
                      value: '${_item.grossWeight.toStringAsFixed(2)} g',
                    ),
                    _DetailRow(
                      label: 'Net Weight',
                      value: '${_item.netWeight.toStringAsFixed(2)} g',
                    ),
                    _DetailRow(label: 'Purity', value: _item.purity),
                    _DetailRow(
                      label: 'Making Charges',
                      value: '₹ ${amtFmt.format(_item.makingCharges)}',
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
                      value: '₹ ${amtFmt.format(_item.costPrice)}',
                    ),
                    _DetailRow(
                      label: 'Selling Price',
                      value: '₹ ${amtFmt.format(_item.sellingPrice)}',
                      valueColor: InventoryColors.green,
                    ),
                    _DetailRow(
                      label: 'GST',
                      value: '₹ ${amtFmt.format(_item.gst)}',
                    ),
                    _DetailRow(
                      label: 'Total Amount',
                      value: '₹ ${amtFmt.format(_item.totalAmount)}',
                      valueColor: InventoryColors.navy,
                    ),
                    _DetailRow(
                      label: 'Profit Margin',
                      value: '${_item.marginPercent.toStringAsFixed(2)}%',
                      valueColor: InventoryColors.gold,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ImageGallery(),
                const SizedBox(height: 12),
                if (_item.movements.isNotEmpty)
                  _MovementHistory(movements: _item.movements),
              ],
            ),
          ),
              ),
            ],
          ),
        ),
        bottomSheet: _BottomActions(
          item: _item,
          onReserve: () => context.read<InventoryDetailBloc>().add(
                InventoryDetailUpdateStatus(
                  id: _item.id,
                  status: InventoryStatus.reserved,
                ),
              ),
          onMarkSold: () => context.read<InventoryDetailBloc>().add(
                InventoryDetailUpdateStatus(
                  id: _item.id,
                  status: InventoryStatus.sold,
                ),
              ),
        ),
      ),
    );
  }

  void _showPrintDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'बारकोड प्रिंट / Print Barcode',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: InventoryColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.barcode_reader,
                    size: 40, color: InventoryColors.navy),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _item.barcode,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: InventoryColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: InventoryColors.muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: BilingualText(en: 'Close', mr: 'बंद करा', compact: true),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.print, size: 16),
            label: BilingualText(en: 'Print', mr: 'प्रिंट', compact: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: InventoryColors.navy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
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

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.item,
    required this.onReserve,
    required this.onMarkSold,
  });

  final InventoryItem item;
  final VoidCallback onReserve;
  final VoidCallback onMarkSold;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryDetailBloc, InventoryDetailState>(
      builder: (context, state) {
        final isLoading = state is InventoryDetailLoading;
        final canAct = item.status == InventoryStatus.available && !isLoading;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: InventoryColors.line)),
          ),
          child: SafeArea(
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      height: 40,
                      child: CircularProgressIndicator(
                          color: InventoryColors.navy),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: canAct ? onReserve : null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: InventoryColors.orange,
                            side: const BorderSide(
                                color: InventoryColors.orange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: BilingualText(en: 'Reserve', mr: 'राखीव', compact: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: canAct ? onMarkSold : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: InventoryColors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: BilingualText(en: 'Mark Sold', mr: 'विकले', compact: true),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
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
