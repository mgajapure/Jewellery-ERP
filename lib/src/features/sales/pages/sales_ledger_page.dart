import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_header.dart';
import '../theme/sales_colors.dart';
import 'sales_dashboard_page.dart';

/// SCR-057 Sales Ledger
///
/// Complete sales history with filters and totals.
class SalesLedgerPage extends StatefulWidget {
  const SalesLedgerPage({super.key});

  static const routeName = 'sales-ledger';

  @override
  State<SalesLedgerPage> createState() => _SalesLedgerPageState();
}

class _SalesLedgerPageState extends State<SalesLedgerPage> {
  String _filter = 'सर्व / All';

  final List<String> _filters = const [
    'सर्व / All',
    'पूर्ण / Completed',
    'परत / Returned',
    'रद्द / Cancelled',
  ];

  final List<Map<String, dynamic>> _transactions = const [
    {
      'date': '22 Jun 2026',
      'invoice': 'INV-2026-000102',
      'customer': 'Ramesh Patil',
      'items': '2',
      'tax': '₹5,010',
      'amount': '₹1,72,010',
      'status': 'Completed',
    },
    {
      'date': '21 Jun 2026',
      'invoice': 'INV-2026-000101',
      'customer': 'Meena Jadhav',
      'items': '1',
      'tax': '₹1,260',
      'amount': '₹43,260',
      'status': 'Completed',
    },
    {
      'date': '20 Jun 2026',
      'invoice': 'INV-2026-000100',
      'customer': 'Amol Deshmukh',
      'items': '3',
      'tax': '₹8,250',
      'amount': '₹2,83,250',
      'status': 'Returned',
    },
    {
      'date': '19 Jun 2026',
      'invoice': 'INV-2026-000099',
      'customer': 'Suresh Patil',
      'items': '1',
      'tax': '₹3,750',
      'amount': '₹1,28,750',
      'status': 'Completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalesColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'विक्री खाते',
              titleEn: 'Sales Ledger',
              showBackButton: true,
              backFallbackRoute: SalesDashboardPage.routeName,
              actions: [
                IconButton(
                  icon: const Icon(Icons.download_outlined,
                      color: SalesColors.ink),
                  tooltip: 'एक्सपोर्ट / Export',
                  onPressed: () {
                    // TODO: export ledger.
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
            _SummaryCard(total: '₹6,27,270'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: _transactions
                    .map((tx) => _TransactionCard(
                          date: tx['date'] as String,
                          invoice: tx['invoice'] as String,
                          customer: tx['customer'] as String,
                          items: tx['items'] as String,
                          tax: tx['tax'] as String,
                          amount: tx['amount'] as String,
                          status: tx['status'] as String,
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
        border: Border.all(color: SalesColors.line),
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
          Icon(Icons.search, color: SalesColors.muted, size: 22),
          SizedBox(width: 12),
          Text(
            'इन्व्हॉईस / ग्राहक शोधा',
            style: TextStyle(
              color: SalesColors.muted,
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
                color: isSelected ? SalesColors.gold : SalesColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(filter),
            selectedColor: SalesColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? SalesColors.navy : SalesColors.line,
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
          color: SalesColors.navy,
          borderRadius: BorderRadius.circular(12),
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
    required this.invoice,
    required this.customer,
    required this.items,
    required this.tax,
    required this.amount,
    required this.status,
  });

  final String date;
  final String invoice;
  final String customer;
  final String items;
  final String tax;
  final String amount;
  final String status;

  Color get _statusColor {
    switch (status) {
      case 'Returned':
        return SalesColors.red;
      case 'Cancelled':
        return SalesColors.muted;
      default:
        return SalesColors.green;
    }
  }

  String get _statusText {
    switch (status) {
      case 'Completed':
        return 'पूर्ण / Completed';
      case 'Returned':
        return 'परत / Returned';
      case 'Cancelled':
        return 'रद्द / Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed('sales-details'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SalesColors.line),
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
                  invoice,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: SalesColors.navy,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              customer,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: SalesColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Tag(text: '$items Items'),
                const SizedBox(width: 8),
                _Tag(text: tax),
                const SizedBox(width: 8),
                _Tag(
                  text: _statusText,
                  color: _statusColor,
                ),
              ],
            ),
            const Divider(height: 22, color: SalesColors.line),
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
                    color: SalesColors.ink,
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
            color: SalesColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            color: SalesColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
        color: color == null
            ? SalesColors.cream
            : color!.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color ?? SalesColors.navy,
        ),
      ),
    );
  }
}
