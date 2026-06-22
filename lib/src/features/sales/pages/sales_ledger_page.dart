import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/sales_colors.dart';

/// SCR-057 Sales Ledger
///
/// Complete sales history with filters and totals.
class SalesLedgerPage extends StatelessWidget {
  const SalesLedgerPage({super.key});

  static const routeName = 'sales-ledger';

  final List<Map<String, dynamic>> _transactions = const [
    {
      'date': '22 Jun 2026',
      'invoice': 'INV-2026-000102',
      'customer': 'Ramesh Patil',
      'items': '2',
      'tax': '₹ 5,010',
      'amount': '₹ 1,72,010',
      'status': 'Completed',
    },
    {
      'date': '21 Jun 2026',
      'invoice': 'INV-2026-000101',
      'customer': 'Meena Jadhav',
      'items': '1',
      'tax': '₹ 1,260',
      'amount': '₹ 43,260',
      'status': 'Completed',
    },
    {
      'date': '20 Jun 2026',
      'invoice': 'INV-2026-000100',
      'customer': 'Amol Deshmukh',
      'items': '3',
      'tax': '₹ 8,250',
      'amount': '₹ 2,83,250',
      'status': 'Returned',
    },
    {
      'date': '19 Jun 2026',
      'invoice': 'INV-2026-000099',
      'customer': 'Suresh Patil',
      'items': '1',
      'tax': '₹ 3,750',
      'amount': '₹ 1,28,750',
      'status': 'Completed',
    },
  ];

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
              'विक्री खाते',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Sales Ledger',
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
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              // TODO: export ledger.
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
                color: SalesColors.navy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'एकूण उत्पन्न / Total Revenue',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '₹ 6,27,270',
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
                    invoice: tx['invoice'] as String,
                    customer: tx['customer'] as String,
                    items: tx['items'] as String,
                    tax: tx['tax'] as String,
                    amount: tx['amount'] as String,
                    status: tx['status'] as String,
                    onTap: () => context.goNamed('sales-details'),
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
    required this.invoice,
    required this.customer,
    required this.items,
    required this.tax,
    required this.amount,
    required this.status,
    required this.onTap,
  });

  final String date;
  final String invoice;
  final String customer;
  final String items;
  final String tax;
  final String amount;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isReturned = status == 'Returned';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SalesColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: SalesColors.navy,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              customer,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SalesColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Tag(text: '$items Items'),
                const SizedBox(width: 8),
                _Tag(text: tax),
                const SizedBox(width: 8),
                _Tag(
                  text: status,
                  color: isReturned ? SalesColors.red : SalesColors.green,
                ),
              ],
            ),
            const Divider(height: 20, color: SalesColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'रक्कम / Amount',
                  style: TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                  ),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SalesColors.navy,
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
  const _Tag({required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color == null ? SalesColors.cream : color!.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color ?? SalesColors.navy,
        ),
      ),
    );
  }
}
