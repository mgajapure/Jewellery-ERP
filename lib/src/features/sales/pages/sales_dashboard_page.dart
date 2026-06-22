import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_header.dart';
import '../theme/sales_colors.dart';

/// SCR-051 Sales Dashboard
///
/// Central sales monitoring screen with metrics and quick actions.
class SalesDashboardPage extends StatelessWidget {
  const SalesDashboardPage({super.key});

  static const routeName = 'sales-dashboard';

  final List<Map<String, dynamic>> _metrics = const [
    {
      'labelMr': 'आजची विक्री',
      'labelEn': "Today's Sales",
      'value': '12',
      'color': 0xFF061C49,
    },
    {
      'labelMr': 'आजचे उत्पन्न',
      'labelEn': "Today's Revenue",
      'value': '₹3.8L',
      'color': 0xFFE7A726,
    },
    {
      'labelMr': 'मासिक उत्पन्न',
      'labelEn': 'Monthly Revenue',
      'value': '₹28.5L',
      'color': 0xFF07934A,
    },
    {
      'labelMr': 'सरासरी इन्व्हॉईस',
      'labelEn': 'Avg Invoice',
      'value': '₹31,750',
      'color': 0xFF2563EB,
    },
    {
      'labelMr': 'टॉप श्रेणी',
      'labelEn': 'Top Category',
      'value': 'Gold Chain',
      'color': 0xFF061C49,
    },
    {
      'labelMr': 'प्रलंबित परतावा',
      'labelEn': 'Pending Returns',
      'value': '2',
      'color': 0xFFF59E0B,
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
              titleMr: 'विक्री डॅशबोर्ड',
              titleEn: 'Sales Dashboard',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _metrics
                          .map((m) => _MetricCard(metric: m))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'जलद कृती / Quick Actions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: SalesColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      icon: Icons.point_of_sale_outlined,
                      titleMr: 'नवीन विक्री',
                      titleEn: 'New Sale',
                      onTap: () => context.goNamed('new-sale'),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      icon: Icons.qr_code_scanner_outlined,
                      titleMr: 'बारकोड विक्री',
                      titleEn: 'Barcode Sale',
                      onTap: () => context.goNamed('barcode-sale'),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      icon: Icons.menu_book_outlined,
                      titleMr: 'विक्री खाते',
                      titleEn: 'Sales Ledger',
                      onTap: () => context.goNamed('sales-ledger'),
                    ),
                    const SizedBox(height: 12),
                    _ActionCard(
                      icon: Icons.assignment_return_outlined,
                      titleMr: 'विक्री परतावा',
                      titleEn: 'Sales Return',
                      onTap: () => context.goNamed('sales-return'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final Map<String, dynamic> metric;

  @override
  Widget build(BuildContext context) {
    final color = Color(metric['color'] as int);
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metric['value'] as String,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric['labelMr'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: SalesColors.ink,
                ),
              ),
              Text(
                metric['labelEn'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  color: SalesColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: SalesColors.navy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: SalesColors.navy,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$titleMr / $titleEn',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: SalesColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: SalesColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
