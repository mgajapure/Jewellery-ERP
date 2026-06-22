import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/purchase_colors.dart';

/// SCR-059 Purchase Details
///
/// Displays complete details of a purchase transaction with item and payment info.
class PurchaseDetailsPage extends StatelessWidget {
  const PurchaseDetailsPage({super.key});

  static const routeName = 'purchase-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      appBar: AppBar(
        backgroundColor: PurchaseColors.navy,
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
              'खरेदी तपशील',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Purchase Details',
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
              _StatusHeader(
                purchaseId: 'PUR-20250622-001',
                status: 'Approved',
                date: '22 Jun 2025',
              ),
              const SizedBox(height: 16),
              _SummaryCard(
                amount: '₹ 1,25,000',
                netWeight: '24.50 g',
                purity: '91.6%',
                rate: '₹ 5,102 /g',
              ),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'पुरवठादार', titleEn: 'Supplier'),
              _DetailTile(labelMr: 'नाव', labelEn: 'Name', value: 'Ramesh Jewellers'),
              _DetailTile(labelMr: 'मोबाईल', labelEn: 'Mobile', value: '+91 98765 43210'),
              _DetailTile(labelMr: 'बिल क्र.', labelEn: 'Bill No.', value: 'BJ/2025/045'),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'वस्तू तपशील', titleEn: 'Item Details'),
              _DetailTile(labelMr: 'धातू', labelEn: 'Metal', value: 'Gold 22K'),
              _DetailTile(labelMr: 'वस्तू', labelEn: 'Item', value: 'Gold Chain'),
              _DetailTile(labelMr: 'ग्रॉस वजन', labelEn: 'Gross Wt', value: '26.10 g'),
              _DetailTile(labelMr: 'नेट वजन', labelEn: 'Net Wt', value: '24.50 g'),
              _DetailTile(labelMr: 'शुद्धता', labelEn: 'Purity', value: '91.6%'),
              _DetailTile(labelMr: 'दर', labelEn: 'Rate', value: '₹ 5,102 /g'),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'पेमेंट तपशील', titleEn: 'Payment Details'),
              _DetailTile(labelMr: 'पेमेंट पद्धत', labelEn: 'Payment Mode', value: 'Bank Transfer'),
              _DetailTile(labelMr: 'रक्कम', labelEn: 'Amount', value: '₹ 1,25,000'),
              _DetailTile(labelMr: 'GST', labelEn: 'GST', value: '₹ 0'),
              _DetailTile(labelMr: 'एकूण', labelEn: 'Total', value: '₹ 1,25,000'),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: share / print PDF.
                      },
                      icon: const Icon(Icons.print_outlined),
                      label: const Text('प्रिंट / Print'),
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
                        // TODO: edit purchase.
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('संपादन / Edit'),
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
          ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.purchaseId,
    required this.status,
    required this.date,
  });

  final String purchaseId;
  final String status;
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
              color: PurchaseColors.green,
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
          style: const TextStyle(
            fontSize: 11,
            color: PurchaseColors.muted,
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
        border: Border(
          bottom: BorderSide(color: PurchaseColors.line),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 13,
              color: PurchaseColors.muted,
            ),
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
