import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/sales_colors.dart';
import 'sales_ledger_page.dart';

/// SCR-055 Sales Details
///
/// View completed sale with invoice, items, payments, and audit trail.
class SalesDetailsPage extends StatelessWidget {
  const SalesDetailsPage({super.key});

  static const routeName = 'sales-details';

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
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            SalesLedgerPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'विक्री तपशील',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Sales Details',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: share invoice.
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
              _StatusHeader(
                invoiceNo: 'INV-2026-000102',
                status: 'Completed',
                date: '22 Jun 2026',
              ),
              const SizedBox(height: 16),
              _SummaryCard(
                total: '₹ 1,72,010',
                items: '2',
                gst: '₹ 5,010',
                mode: 'UPI',
              ),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'ग्राहक', titleEn: 'Customer'),
              _DetailTile(labelMr: 'नाव', labelEn: 'Name', value: 'Ramesh Patil'),
              _DetailTile(labelMr: 'मोबाईल', labelEn: 'Mobile', value: '+91 98765 43210'),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'वस्तू', titleEn: 'Items'),
              _DetailTile(labelMr: 'वस्तू 1', labelEn: 'Item 1', value: 'Gold Chain 22K'),
              _DetailTile(labelMr: 'वस्तू 2', labelEn: 'Item 2', value: 'Gold Ring 22K'),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'पेमेंट', titleEn: 'Payment'),
              _DetailTile(labelMr: 'पद्धत', labelEn: 'Mode', value: 'UPI'),
              _DetailTile(labelMr: 'रक्कम', labelEn: 'Amount', value: '₹ 1,72,010'),
              _DetailTile(labelMr: 'दिनांक', labelEn: 'Date', value: '22 Jun 2026, 11:30 AM'),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'ऑडिट माहिती', titleEn: 'Audit Trail'),
              _AuditTile(time: '11:30 AM', event: 'Sale Completed'),
              _AuditTile(time: '11:28 AM', event: 'Invoice Generated'),
              _AuditTile(time: '11:25 AM', event: 'Items Added'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: print invoice.
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
          ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.invoiceNo,
    required this.status,
    required this.date,
  });

  final String invoiceNo;
  final String status;
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
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SalesColors.green,
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: SalesColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: SalesColors.muted,
          ),
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
            style: const TextStyle(
              fontSize: 13,
              color: SalesColors.muted,
            ),
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
            style: const TextStyle(
              fontSize: 13,
              color: SalesColors.ink,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: SalesColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
