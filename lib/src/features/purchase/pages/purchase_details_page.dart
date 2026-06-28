import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/purchase_entry.dart';
import '../theme/purchase_colors.dart';
import 'purchase_ledger_page.dart';

/// SCR-059 Purchase Details
class PurchaseDetailsPage extends StatelessWidget {
  const PurchaseDetailsPage({super.key, required this.entry});

  static const routeName = 'purchase-details';

  final PurchaseEntry entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'खरेदी तपशील',
              titleEn: 'Purchase Details',
              showBackButton: true,
              backFallbackRoute: PurchaseLedgerPage.routeName,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _DetailsBody(entry: entry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.entry});

  final PurchaseEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusHeader(
          purchaseId: entry.id,
          status: entry.status.labelEn,
          statusColor: _statusColor(entry.status),
          date: dateFmt.format(entry.date),
        ),
        const SizedBox(height: 16),
        _SummaryCard(
          amount: '₹${amtFmt.format(entry.totalAmount)}',
          netWeight: '${entry.netWeight.toStringAsFixed(2)} g',
          purity: '${entry.purity.toStringAsFixed(1)}%',
          rate: '₹${amtFmt.format(entry.rate)}/g',
        ),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'पुरवठादार', titleEn: 'Supplier'),
        _DetailTile(
            labelMr: 'नाव', labelEn: 'Name', value: entry.supplierName),
        _DetailTile(
            labelMr: 'मोबाईल',
            labelEn: 'Mobile',
            value: entry.supplierMobile),
        _DetailTile(
            labelMr: 'बिल क्र.', labelEn: 'Bill No.', value: entry.billNo),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'वस्तू तपशील', titleEn: 'Item Details'),
        _DetailTile(
            labelMr: 'खरेदी प्रकार',
            labelEn: 'Purchase Type',
            value: entry.purchaseType.labelEn),
        _DetailTile(
            labelMr: 'धातू',
            labelEn: 'Metal',
            value: entry.metalType.labelEn),
        _DetailTile(
            labelMr: 'वस्तू', labelEn: 'Item', value: entry.itemName),
        _DetailTile(
            labelMr: 'ग्रॉस वजन',
            labelEn: 'Gross Wt',
            value: '${entry.grossWeight.toStringAsFixed(2)} g'),
        _DetailTile(
            labelMr: 'नेट वजन',
            labelEn: 'Net Wt',
            value: '${entry.netWeight.toStringAsFixed(2)} g'),
        _DetailTile(
            labelMr: 'शुद्धता',
            labelEn: 'Purity',
            value: '${entry.purity.toStringAsFixed(1)}%'),
        _DetailTile(
            labelMr: 'दर',
            labelEn: 'Rate',
            value: '₹${amtFmt.format(entry.rate)}/g'),
        const SizedBox(height: 20),
        _SectionTitle(titleMr: 'पेमेंट तपशील', titleEn: 'Payment Details'),
        _DetailTile(
            labelMr: 'पेमेंट पद्धत',
            labelEn: 'Payment Mode',
            value: entry.paymentMode.labelEn),
        _DetailTile(
            labelMr: 'रक्कम',
            labelEn: 'Amount',
            value: '₹${amtFmt.format(entry.amount)}'),
        _DetailTile(
            labelMr: 'GST',
            labelEn: 'GST',
            value: '₹${amtFmt.format(entry.gst)}'),
        _DetailTile(
            labelMr: 'एकूण',
            labelEn: 'Total',
            value: '₹${amtFmt.format(entry.totalAmount)}'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: BilingualText(en: 'Print coming soon', mr: 'प्रिंट लवकरच', compact: true),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.print_outlined),
                label: BilingualText(en: 'Print', mr: 'प्रिंट', compact: true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PurchaseColors.navy,
                  side: const BorderSide(color: PurchaseColors.navy),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'खरेदी संपादन लवकरच / Edit purchase coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: BilingualText(en: 'Edit', mr: 'संपादन', compact: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PurchaseColors.navy,
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

  Color _statusColor(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.approved:
        return PurchaseColors.green;
      case PurchaseStatus.rejected:
        return PurchaseColors.red;
      case PurchaseStatus.pending:
        return PurchaseColors.orange;
    }
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.purchaseId,
    required this.status,
    required this.statusColor,
    required this.date,
  });

  final String purchaseId;
  final String status;
  final Color statusColor;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PurchaseColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                purchaseId,
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
    required this.amount,
    required this.netWeight,
    required this.purity,
    required this.rate,
  });

  final String amount;
  final String netWeight;
  final String purity;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PurchaseColors.line),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: PurchaseColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(label: 'Net Wt', value: netWeight),
              _SummaryItem(label: 'Purity', value: purity),
              _SummaryItem(label: 'Rate', value: rate),
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
            color: PurchaseColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: PurchaseColors.muted),
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
              color: PurchaseColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$titleMr / $titleEn',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: PurchaseColors.ink,
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
        border: Border(bottom: BorderSide(color: PurchaseColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
                fontSize: 13, color: PurchaseColors.muted),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: PurchaseColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
