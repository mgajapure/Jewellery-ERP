import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/purchase_colors.dart';

/// SCR-061 Purchase Ledger
///
/// Lists historical purchase transactions with filters and totals.
class PurchaseLedgerPage extends StatelessWidget {
  const PurchaseLedgerPage({super.key});

  static const routeName = 'purchase-ledger';

  final List<Map<String, dynamic>> _transactions = const [
    {
      'date': '22 Jun 2025',
      'id': 'PUR-20250622-001',
      'supplier': 'Ramesh Jewellers',
      'type': 'Gold 22K',
      'weight': '24.50 g',
      'amount': '₹ 1,25,000',
      'mode': 'Bank Transfer',
    },
    {
      'date': '21 Jun 2025',
      'id': 'PUR-20250621-002',
      'supplier': 'Shree Gold House',
      'type': 'Scrap',
      'weight': '8.20 g',
      'amount': '₹ 42,000',
      'mode': 'Cash',
    },
    {
      'date': '20 Jun 2025',
      'id': 'PUR-20250620-003',
      'supplier': 'Mumbai Bullion Traders',
      'type': 'Gold 24K',
      'weight': '50.00 g',
      'amount': '₹ 3,05,000',
      'mode': 'Credit',
    },
    {
      'date': '19 Jun 2025',
      'id': 'PUR-20250619-004',
      'supplier': 'Ramesh Jewellers',
      'type': 'Silver',
      'weight': '100.00 g',
      'amount': '₹ 7,500',
      'mode': 'Cash',
    },
  ];

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
              'खरेदी खाते',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Purchase Ledger',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: filter ledger.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
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
                      const Text(
                        'एकूण खरेदी / Total Purchase',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '₹ 4,79,500',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'This Month',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return _TransactionCard(
                    date: tx['date'] as String,
                    id: tx['id'] as String,
                    supplier: tx['supplier'] as String,
                    type: tx['type'] as String,
                    weight: tx['weight'] as String,
                    amount: tx['amount'] as String,
                    mode: tx['mode'] as String,
                    onTap: () => context.goNamed('purchase-details'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.date,
    required this.id,
    required this.supplier,
    required this.type,
    required this.weight,
    required this.amount,
    required this.mode,
    required this.onTap,
  });

  final String date;
  final String id;
  final String supplier;
  final String type;
  final String weight;
  final String amount;
  final String mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PurchaseColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PurchaseColors.navy,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PurchaseColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              supplier,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PurchaseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Tag(text: type),
                const SizedBox(width: 8),
                _Tag(text: weight),
                const SizedBox(width: 8),
                _Tag(text: mode),
              ],
            ),
            const Divider(height: 20, color: PurchaseColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'रक्कम / Amount',
                  style: TextStyle(
                    fontSize: 12,
                    color: PurchaseColors.muted,
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: PurchaseColors.navy,
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

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: PurchaseColors.cream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: PurchaseColors.navy,
        ),
      ),
    );
  }
}
