import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/sale_order.dart';
import '../theme/sales_colors.dart';

/// SCR-055 Sales Details
class SalesDetailsPage extends StatelessWidget {
  const SalesDetailsPage({super.key, required this.order});

  static const routeName = 'sales-details';

  final SaleOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalesColors.screenBg,
      appBar: AppBar(
        backgroundColor: SalesColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              AppNavigation.popOrGoNamed(context, 'sales-ledger'),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'विक्री तपशील',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Text(
              'Sales Details',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final fmt = DateFormat('dd MMM yyyy');
              final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
              final text = '''विक्री तपशील / Sale Details
इन्व्हॉईस: ${order.invoiceNo}
ग्राहक: ${order.customerName}
दिनांक: ${fmt.format(order.date)}
रक्कम: ₹${amtFmt.format(order.totalAmount)}
पेमेंट: ${order.paymentMode.labelMr} / ${order.paymentMode.labelEn}''';
              Share.share(text, subject: 'Invoice ${order.invoiceNo}');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _DetailsBody(order: order),
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.order});

  final SaleOrder order;

  Color _statusColor(SaleStatus status) {
    switch (status) {
      case SaleStatus.completed:
        return SalesColors.green;
      case SaleStatus.returned:
        return SalesColors.red;
      case SaleStatus.cancelled:
        return SalesColors.muted;
      case SaleStatus.draft:
        return SalesColors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusHeader(
          invoiceNo: order.invoiceNo,
          status: '${order.status.labelMr} / ${order.status.labelEn}',
          statusColor: _statusColor(order.status),
          date: dateFmt.format(order.date),
        ),
        const SizedBox(height: 16),
        _SummaryCard(
          total: '₹${amtFmt.format(order.totalAmount)}',
          items: '${order.items.length}',
          gst: '₹${amtFmt.format(order.cgst + order.sgst)}',
          mode: '${order.paymentMode.labelMr} / ${order.paymentMode.labelEn}',
        ),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'ग्राहक', titleEn: 'Customer'),
        _DetailTile(
            labelMr: 'नाव',
            labelEn: 'Name',
            value: order.customerName),
        _DetailTile(
            labelMr: 'मोबाईल',
            labelEn: 'Mobile',
            value: order.customerMobile.isNotEmpty
                ? order.customerMobile
                : '—'),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'वस्तू', titleEn: 'Items'),
        ...order.items.asMap().entries.map(
              (e) => _DetailTile(
                labelMr: 'वस्तू ${e.key + 1}',
                labelEn: 'Item ${e.key + 1}',
                value: e.value.name,
              ),
            ),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'पेमेंट', titleEn: 'Payment'),
        _DetailTile(
            labelMr: 'पद्धत',
            labelEn: 'Mode',
            value:
                '${order.paymentMode.labelMr} / ${order.paymentMode.labelEn}'),
        _DetailTile(
            labelMr: 'रक्कम',
            labelEn: 'Amount',
            value: '₹${amtFmt.format(order.totalAmount)}'),
        _DetailTile(
            labelMr: 'दिनांक',
            labelEn: 'Date',
            value: dateFmt.format(order.date)),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'ऑडिट माहिती', titleEn: 'Audit Trail'),
        _AuditTile(
            time: DateFormat('hh:mm a').format(order.createdAt),
            event: 'Sale Created'),
        _AuditTile(
            time: DateFormat('hh:mm a').format(order.createdAt),
            event: 'Invoice Generated'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('प्रिंट लवकरच / Print coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.print_outlined),
                label: const Text('प्रिंट / Print'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SalesColors.navy,
                  side: const BorderSide(color: SalesColors.navy),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.goNamed('sales-return'),
                icon: const Icon(Icons.assignment_return_outlined),
                label: const Text('परतावा / Return'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SalesColors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.invoiceNo,
    required this.status,
    required this.statusColor,
    required this.date,
  });

  final String invoiceNo;
  final String status;
  final Color statusColor;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SalesColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invoiceNo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.items,
    required this.gst,
    required this.mode,
  });

  final String total;
  final String items;
  final String gst;
  final String mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SalesColors.line),
      ),
      child: Column(
        children: [
          Text(
            total,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: SalesColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(label: 'Items', value: items),
              _SummaryItem(label: 'GST', value: gst),
              _SummaryItem(label: 'Mode', value: mode),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: SalesColors.ink,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style:
              const TextStyle(fontSize: 11, color: SalesColors.muted),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: SalesColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$titleMr / $titleEn',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: SalesColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SalesColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(fontSize: 13, color: SalesColors.muted),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SalesColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditTile extends StatelessWidget {
  const _AuditTile({required this.time, required this.event});

  final String time;
  final String event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SalesColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            event,
            style:
                const TextStyle(fontSize: 13, color: SalesColors.ink),
          ),
          Text(
            time,
            style:
                const TextStyle(fontSize: 12, color: SalesColors.muted),
          ),
        ],
      ),
    );
  }
}
