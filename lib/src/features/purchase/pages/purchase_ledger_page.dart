import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_header.dart';
import '../theme/purchase_colors.dart';
import 'purchase_dashboard_page.dart';

/// SCR-061 Purchase Ledger
///
/// Lists historical purchase transactions with filters and totals.
class PurchaseLedgerPage extends StatefulWidget {
  const PurchaseLedgerPage({super.key});

  static const routeName = 'purchase-ledger';

  @override
  State<PurchaseLedgerPage> createState() => _PurchaseLedgerPageState();
}

class _PurchaseLedgerPageState extends State<PurchaseLedgerPage> {
  String _filter = 'सर्व / All';

  final List<String> _filters = const [
    'सर्व / All',
    'रोख / Cash',
    'बँक / Bank',
    'उधार / Credit',
  ];

  final List<Map<String, dynamic>> _transactions = const [
    {
      'date': '22 Jun 2025',
      'id': 'PUR-20250622-001',
      'supplier': 'Ramesh Jewellers',
      'type': 'Gold 22K',
      'weight': '24.50 g',
      'amount': '₹1,25,000',
      'mode': 'Bank Transfer',
    },
    {
      'date': '21 Jun 2025',
      'id': 'PUR-20250621-002',
      'supplier': 'Shree Gold House',
      'type': 'Scrap',
      'weight': '8.20 g',
      'amount': '₹42,000',
      'mode': 'Cash',
    },
    {
      'date': '20 Jun 2025',
      'id': 'PUR-20250620-003',
      'supplier': 'Mumbai Bullion Traders',
      'type': 'Gold 24K',
      'weight': '50.00 g',
      'amount': '₹3,05,000',
      'mode': 'Credit',
    },
    {
      'date': '19 Jun 2025',
      'id': 'PUR-20250619-004',
      'supplier': 'Ramesh Jewellers',
      'type': 'Silver',
      'weight': '100.00 g',
      'amount': '₹7,500',
      'mode': 'Cash',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'खरेदी खाते',
              titleEn: 'Purchase Ledger',
              showBackButton: true,
              backFallbackRoute: PurchaseDashboardPage.routeName,
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list,
                      color: PurchaseColors.ink),
                  tooltip: 'फिल्टर / Filter',
                  onPressed: () {
                    // TODO: filter ledger.
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchBar(),
            ),
            _FilterChips(
              filters: _filters,
              selected: _filter,
              onSelected: (filter) => setState(() => _filter = filter),
            ),
            const SizedBox(height: 8),
            _SummaryCard(total: '₹4,79,500'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: _transactions
                    .map((tx) => _TransactionCard(
                          date: tx['date'] as String,
                          id: tx['id'] as String,
                          supplier: tx['supplier'] as String,
                          type: tx['type'] as String,
                          weight: tx['weight'] as String,
                          amount: tx['amount'] as String,
                          mode: tx['mode'] as String,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PurchaseColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: PurchaseColors.muted, size: 22),
          SizedBox(width: 12),
          Text(
            'पुरवठादार / आयडी / तारीख शोधा',
            style: TextStyle(
              color: PurchaseColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selected;
          return ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? PurchaseColors.gold : PurchaseColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(filter),
            selectedColor: PurchaseColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? PurchaseColors.navy : PurchaseColors.line,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total});

  final String total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PurchaseColors.navy,
          borderRadius: BorderRadius.circular(12),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  total,
                  style: const TextStyle(
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
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'This Month',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
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
  });

  final String date;
  final String id;
  final String supplier;
  final String type;
  final String weight;
  final String amount;
  final String mode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed('purchase-details'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PurchaseColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
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
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.navy,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PurchaseColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              supplier,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: PurchaseColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Tag(text: type),
                const SizedBox(width: 8),
                _Tag(text: weight),
                const SizedBox(width: 8),
                _Tag(text: mode),
              ],
            ),
            const Divider(height: 22, color: PurchaseColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _SummaryItem(
                  labelMr: 'रक्कम',
                  labelEn: 'Amount',
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.ink,
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

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.labelMr, required this.labelEn});

  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
          fontWeight: FontWeight.w700,
          color: PurchaseColors.navy,
        ),
      ),
    );
  }
}
