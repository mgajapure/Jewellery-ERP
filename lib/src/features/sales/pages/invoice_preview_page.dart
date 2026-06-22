import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/sales_colors.dart';

/// SCR-054 Invoice Preview
///
/// Preview GST invoice before finalizing sale.
class InvoicePreviewPage extends StatelessWidget {
  const InvoicePreviewPage({super.key});

  static const routeName = 'invoice-preview';

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
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'इन्व्हॉईस पूर्वावलोकन',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Invoice Preview',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InvoiceHeader(
                invoiceNo: 'INV-2026-000102',
                date: '22 Jun 2026',
                status: 'Draft',
              ),
              const SizedBox(height: 16),
              _PartyCard(
                titleMr: 'व्यवसाय',
                titleEn: 'Business',
                name: 'Shree Jewellers',
                details: 'GST: 27ABCDE1234F1Z5\nPune, Maharashtra',
              ),
              const SizedBox(height: 12),
              _PartyCard(
                titleMr: 'ग्राहक',
                titleEn: 'Customer',
                name: 'Ramesh Patil',
                details: '+91 98765 43210\nPune',
              ),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'वस्तू तपशील', titleEn: 'Item Breakdown'),
              _ItemRow(
                name: 'Gold Chain 22K',
                details: '24.50 g • 91.6%',
                taxable: 125000,
                gst: 3750,
                total: 128750,
              ),
              _ItemRow(
                name: 'Gold Ring 22K',
                details: '8.20 g • 91.6%',
                taxable: 42000,
                gst: 1260,
                total: 43260,
              ),
              const Divider(color: SalesColors.line),
              _SummaryRow(label: 'Taxable Amount', value: '₹ 1,67,000'),
              _SummaryRow(label: 'CGST 1.5%', value: '₹ 2,505'),
              _SummaryRow(label: 'SGST 1.5%', value: '₹ 2,505'),
              _SummaryRow(label: 'Discount', value: '- ₹ 0'),
              const Divider(color: SalesColors.line),
              _SummaryRow(label: 'Total Invoice', value: '₹ 1,72,010', bold: true),
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
                      onPressed: () {
                        context.goNamed('sales-details');
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('विक्री निश्चित / Finalize'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SalesColors.green,
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

class _InvoiceHeader extends StatelessWidget {
  const _InvoiceHeader({
    required this.invoiceNo,
    required this.date,
    required this.status,
  });

  final String invoiceNo;
  final String date;
  final String status;

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
              color: SalesColors.orange,
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

class _PartyCard extends StatelessWidget {
  const _PartyCard({
    required this.titleMr,
    required this.titleEn,
    required this.name,
    required this.details,
  });

  final String titleMr;
  final String titleEn;
  final String name;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SalesColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titleMr / $titleEn',
            style: const TextStyle(
              fontSize: 12,
              color: SalesColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SalesColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            details,
            style: const TextStyle(
              fontSize: 12,
              color: SalesColors.ink,
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

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.name,
    required this.details,
    required this.taxable,
    required this.gst,
    required this.total,
  });

  final String name;
  final String details;
  final double taxable;
  final double gst;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SalesColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SalesColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 11,
                    color: SalesColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹ ${taxable.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: SalesColors.muted,
                ),
              ),
              Text(
                '+ ₹ ${gst.toStringAsFixed(0)} GST',
                style: const TextStyle(
                  fontSize: 11,
                  color: SalesColors.muted,
                ),
              ),
              Text(
                '₹ ${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SalesColors.navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: SalesColors.ink,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 16 : 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: bold ? SalesColors.navy : SalesColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
