import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_header.dart';
import '../../compliance/compliance.dart';
import '../../inventory/inventory.dart';
import '../../interest/interest.dart';
import '../../purchase/purchase.dart';
import '../../reports/reports.dart';
import '../../sales/sales.dart';
import '../../savings/savings.dart';
import '../../settings/settings.dart';
import '../../staff/staff.dart';
import '../../vault/vault.dart';

/// More / All Modules hub.
///
/// Consolidates navigation to every non-primary module so the bottom nav
/// stays clean with only Dashboard, Girvi, Customers, and More.
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  static const routeName = 'more';

  final List<Map<String, dynamic>> _modules = const [
    {
      'titleMr': 'स्टॉक',
      'titleEn': 'Inventory',
      'icon': Icons.inventory_2_outlined,
      'route': InventoryListPage.routeName,
      'color': 0xFF061C49,
    },
    {
      'titleMr': 'तिजोरी',
      'titleEn': 'Vault',
      'icon': Icons.account_balance_outlined,
      'route': VaultSearchPage.routeName,
      'color': 0xFF2563EB,
    },
    {
      'titleMr': 'व्याज',
      'titleEn': 'Interest',
      'icon': Icons.calculate_outlined,
      'route': InterestCalculatorPage.routeName,
      'color': 0xFF07934A,
    },
    {
      'titleMr': 'अनुपालन',
      'titleEn': 'Compliance',
      'icon': Icons.verified_user_outlined,
      'route': ComplianceDashboardPage.routeName,
      'color': 0xFFE7A726,
    },
    {
      'titleMr': 'खरेदी',
      'titleEn': 'Purchase',
      'icon': Icons.shopping_bag_outlined,
      'route': PurchaseDashboardPage.routeName,
      'color': 0xFF061C49,
    },
    {
      'titleMr': 'विक्री',
      'titleEn': 'Sales',
      'icon': Icons.point_of_sale_outlined,
      'route': SalesDashboardPage.routeName,
      'color': 0xFF061C49,
    },
    {
      'titleMr': 'बचत योजना',
      'titleEn': 'Savings',
      'icon': Icons.savings_outlined,
      'route': SavingsDashboardPage.routeName,
      'color': 0xFF07934A,
    },
    {
      'titleMr': 'अहवाल',
      'titleEn': 'Reports',
      'icon': Icons.bar_chart_outlined,
      'route': ReportsDashboardPage.routeName,
      'color': 0xFF2563EB,
    },
    {
      'titleMr': 'कर्मचारी',
      'titleEn': 'Staff',
      'icon': Icons.badge_outlined,
      'route': StaffDashboardPage.routeName,
      'color': 0xFFF59E0B,
    },
    {
      'titleMr': 'सेटिंग्ज',
      'titleEn': 'Settings',
      'icon': Icons.settings_outlined,
      'route': SettingsDashboardPage.routeName,
      'color': 0xFF5E6880,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Column(
          children: [
            const AppListHeader(
              titleMr: 'सर्व मॉड्यूल्स',
              titleEn: 'All Modules',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'अधिक मॉड्यूल्स / More Modules',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF071A49),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _modules.map((module) => _ModuleCard(module: module)).toList(),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),
bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.goNamed('dashboard');
              break;
            case 1:
              context.goNamed('girvi-list');
              break;
            case 2:
              context.goNamed('customer-list');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module});

  final Map<String, dynamic> module;

  @override
  Widget build(BuildContext context) {
    final color = Color(module['color'] as int);
    return InkWell(
      onTap: () => context.pushNamed(module['route'] as String),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E8EF)),
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                module['icon'] as IconData,
                color: color,
                size: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module['titleMr'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF071A49),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  module['titleEn'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5E6880),
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
