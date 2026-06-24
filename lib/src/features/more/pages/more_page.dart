import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bottom_nav.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: const Text(
                'अधिक / More',
                style: TextStyle(
                  color: Color(0xFF071A49),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E8EF)),
                  ),
                ),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _modules.length,
                  separatorBuilder: (context, i) =>
                      const Divider(height: 1, color: Color(0xFFE5E8EF)),
                  itemBuilder: (context, i) => _ModuleTile(
                    module: _modules[i],
                    onTap: () =>
                        context.pushNamed(_modules[i]['route'] as String),
                  ),
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

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module, required this.onTap});
  final Map<String, dynamic> module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(module['color'] as int);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(module['icon'] as IconData, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module['titleMr'] as String,
                      style: const TextStyle(
                        color: Color(0xFF071A49),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      module['titleEn'] as String,
                      style: const TextStyle(
                        color: Color(0xFF5E6880),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFF5E6880), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
