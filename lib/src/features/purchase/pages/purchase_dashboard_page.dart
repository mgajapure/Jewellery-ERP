import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/purchase_colors.dart';

/// SCR-050 Purchase Dashboard
///
/// Central purchase monitoring screen with metrics and quick actions.
class PurchaseDashboardPage extends StatelessWidget {
  const PurchaseDashboardPage({super.key});

  static const routeName = 'purchase-dashboard';

  final List<Map<String, dynamic>> _metrics = const [
    {'labelMr': 'आजची खरेदी', 'labelEn': "Today's Purchases", 'value': '8', 'color': 0xFF061C49},
    {'labelMr': 'खरेदी मूल्य', 'labelEn': 'Purchase Value', 'value': '₹ 4.2L', 'color': 0xFFE7A726},
    {'labelMr': 'प्रलंबित मंजुरी', 'labelEn': 'Pending Approvals', 'value': '3', 'color': 0xFFF59E0B},
    {'labelMr': 'पुरवठादार', 'labelEn': 'Suppliers', 'value': '24', 'color': 0xFF2563EB},
    {'labelMr': 'स्क्रॅप खरेदी', 'labelEn': 'Scrap Purchases', 'value': '5', 'color': 0xFF07934A},
    {'labelMr': 'इन्व्हेंटरी जोडले', 'labelEn': 'Inventory Added', 'value': '12', 'color': 0xFF061C49},
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
              'खरेदी डॅशबोर्ड',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Purchase Dashboard',
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
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _metrics.map((m) => _MetricCard(metric: m)).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'जलद कृती / Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PurchaseColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.add_shopping_cart_outlined,
                titleMr: 'नवीन खरेदी',
                titleEn: 'New Purchase',
                onTap: () => context.goNamed('new-purchase'),
              ),
              const SizedBox(height: 10),
              _ActionCard(
                icon: Icons.menu_book_outlined,
                titleMr: 'खरेदी खाते',
                titleEn: 'Purchase Ledger',
                onTap: () => context.goNamed('purchase-ledger'),
              ),
              const SizedBox(height: 10),
              _ActionCard(
                icon: Icons.business_outlined,
                titleMr: 'पुरवठादार',
                titleEn: 'Suppliers',
                onTap: () => context.goNamed('suppliers'),
              ),
              const SizedBox(height: 10),
              _ActionCard(
                icon: Icons.bar_chart_outlined,
                titleMr: 'अहवाल',
                titleEn: 'Reports',
                onTap: () {
                  // TODO: navigate to reports.
                },
              ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PurchaseColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metric['value'] as String,
            style: TextStyle(
              fontSize: 22,
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
                  fontWeight: FontWeight.w600,
                  color: PurchaseColors.ink,
                ),
              ),
              Text(
                metric['labelEn'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  color: PurchaseColors.muted,
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PurchaseColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PurchaseColors.navy.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: PurchaseColors.navy,
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
                      fontWeight: FontWeight.w600,
                      color: PurchaseColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, color: PurchaseColors.navy),
          ],
        ),
      ),
    );
  }
}
