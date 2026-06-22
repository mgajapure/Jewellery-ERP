import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../compliance/compliance.dart';
import '../customer/customer.dart';
import '../girvi/girvi.dart';
import '../interest/interest.dart';
import '../inventory/inventory.dart';
import '../purchase/purchase.dart';
import '../vault/vault.dart';

const _navy = Color(0xFF061C49);
const _gold = Color(0xFFE7A726);
const _ink = Color(0xFF071A49);
const _muted = Color(0xFF5E6880);
const _green = Color(0xFF07934A);
const _red = Color(0xFFE21B2D);
const _screenBg = Color(0xFFF8F9FC);
const _line = Color(0xFFE5E8EF);

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                children: [
                  const _GoldRateCard(),
                  const SizedBox(height: 16),
                  const _SectionHeader(
                    title: 'मुख्य आकडेवारी / Key Metrics',
                    trailing: 'आज / Today',
                  ),
                  const SizedBox(height: 10),
                  const _MetricGrid(),
                  const SizedBox(height: 18),
                  const _SectionHeader(title: 'जलद कृती / Quick Actions'),
                  const SizedBox(height: 12),
                  _QuickActions(
                    onNewGirviTap: () =>
                        context.goNamed(CreateGirviWizardPage.routeName),
                    onSearchCustomerTap: () =>
                        context.goNamed(CustomerSearchPage.routeName),
                    onVaultSearchTap: () =>
                        context.goNamed(VaultSearchPage.routeName),
                    onInterestCalcTap: () =>
                        context.goNamed(InterestCalculatorPage.routeName),
                    onComplianceTap: () =>
                        context.goNamed(ComplianceDashboardPage.routeName),
                    onPurchaseTap: () =>
                        context.goNamed(PurchaseDashboardPage.routeName),
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeader(
                    title: 'अलीकडील पेमेंट्स / Recent Payments',
                    trailing: 'सर्व पहा / View All',
                  ),
                  const SizedBox(height: 12),
                  const _RecentPaymentsList(),
                ],
              ),
            ),
            _DashboardBottomNav(
              onGirviTap: () => context.goNamed(GirviListPage.routeName),
              onCustomersTap: () => context.goNamed(CustomerListPage.routeName),
              onInventoryTap: () => context.goNamed(InventoryListPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: _ink),
            tooltip: 'Menu',
          ),
          const Spacer(),
          const Text(
            'डॅशबोर्ड / Dashboard',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: _ink),
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 7,
                top: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
    );
  }
}

class _GoldRateCard extends StatelessWidget {
  const _GoldRateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F061C49),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'आजचा सोनाचा दर (24K)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Gold Rate Today (24K)',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'प्रति 10 ग्रॅम / per 10g',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹71,850',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '+ ₹320 (0.45%) ↑',
                    style: TextStyle(
                      color: Color(0xFF34D06D),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: const [
              Text(
                '06 Jun 2026, 09:30 AM',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Spacer(),
              Text(
                'स्रोत: MCX',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(width: 6),
              Icon(Icons.refresh, color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          Text(
            trailing!,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.18,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _MetricTile(
          titleMr: 'एकूण सक्रिय गिरवी',
          titleEn: 'Active Girvi',
          value: '128',
          delta: '+12 आज / today',
        ),
        _MetricTile(
          titleMr: 'एकूण डिस्बर्समेंट',
          titleEn: 'Total Disbursed',
          value: '₹2.45 Cr',
          delta: '+₹18.6L आज / today',
        ),
        _MetricTile(
          titleMr: 'आजचे व्याज',
          titleEn: 'Interest Due Today',
          value: '₹48,760',
          delta: '+₹3,250 आज / today',
        ),
        _MetricTile(
          titleMr: 'ओव्हरड्यू खाती',
          titleEn: 'Overdue Accounts',
          value: '21',
          valueColor: _red,
          delta: '+2 आज / today',
        ),
      ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.titleMr,
    required this.titleEn,
    required this.value,
    required this.delta,
    this.valueColor = _ink,
  });

  final String titleMr;
  final String titleEn;
  final String value;
  final String delta;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titleEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _green,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    this.onNewGirviTap,
    this.onSearchCustomerTap,
    this.onVaultSearchTap,
    this.onInterestCalcTap,
    this.onComplianceTap,
    this.onPurchaseTap,
  });

  final VoidCallback? onNewGirviTap;
  final VoidCallback? onSearchCustomerTap;
  final VoidCallback? onVaultSearchTap;
  final VoidCallback? onInterestCalcTap;
  final VoidCallback? onComplianceTap;
  final VoidCallback? onPurchaseTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.add,
              titleMr: 'नवीन गिरवी',
              titleEn: 'New Girvi',
              filled: true,
              onTap: onNewGirviTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.search,
              titleMr: 'ग्राहक शोधा',
              titleEn: 'Search Customer',
              onTap: onSearchCustomerTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.account_balance,
              titleMr: 'तिजोरी शोध',
              titleEn: 'Vault Search',
              onTap: onVaultSearchTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.calculate_outlined,
              titleMr: 'व्याज गणना',
              titleEn: 'Interest Calc',
              onTap: onInterestCalcTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.verified_user_outlined,
              titleMr: 'अनुपालन',
              titleEn: 'Compliance',
              onTap: onComplianceTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.shopping_bag_outlined,
              titleMr: 'खरेदी',
              titleEn: 'Purchase',
              onTap: onPurchaseTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    this.filled = false,
    this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: filled ? _navy : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: filled ? _navy : _line),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: filled ? Colors.white : _ink, size: 27),
          ),
          const SizedBox(height: 8),
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titleEn,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPaymentsList extends StatelessWidget {
  const _RecentPaymentsList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: [
          _PaymentTransactionTile(
            customerName: 'सुरेश पाटील',
            customerSubtitle: 'Suresh Patil',
            paymentType: 'व्याज पेमेंट / Interest Payment',
            amount: '₹12,500',
            time: '10:45 AM',
            status: 'पूर्ण / Paid',
            icon: Icons.south_west,
          ),
          _ListDivider(),
          _PaymentTransactionTile(
            customerName: 'मीना जाधव',
            customerSubtitle: 'Meena Jadhav',
            paymentType: 'मुद्दल पेमेंट / Principal Payment',
            amount: '₹35,000',
            time: '09:20 AM',
            status: 'पूर्ण / Paid',
            icon: Icons.south_west,
          ),
          _ListDivider(),
          _PaymentTransactionTile(
            customerName: 'अमोल देशमुख',
            customerSubtitle: 'Amol Deshmukh',
            paymentType: 'आंशिक पेमेंट / Partial Payment',
            amount: '₹8,760',
            time: 'काल / Yesterday',
            status: 'पूर्ण / Paid',
            icon: Icons.south_west,
          ),
        ],
      ),
    );
  }
}

class _PaymentTransactionTile extends StatelessWidget {
  const _PaymentTransactionTile({
    required this.customerName,
    required this.customerSubtitle,
    required this.paymentType,
    required this.amount,
    required this.time,
    required this.status,
    required this.icon,
  });

  final String customerName;
  final String customerSubtitle;
  final String paymentType;
  final String amount;
  final String time;
  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF8F3),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Icon(icon, color: _green, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  customerSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  paymentType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                status,
                style: const TextStyle(
                  color: _green,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListDivider extends StatelessWidget {
  const _ListDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: _line, indent: 68);
  }
}

class _DashboardBottomNav extends StatelessWidget {
  const _DashboardBottomNav({
    required this.onGirviTap,
    required this.onCustomersTap,
    required this.onInventoryTap,
  });

  final VoidCallback onGirviTap;
  final VoidCallback onCustomersTap;
  final VoidCallback onInventoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              titleMr: 'डॅशबोर्ड',
              titleEn: 'Dashboard',
              selected: true,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.diamond_outlined,
              titleMr: 'गिरवी',
              titleEn: 'Girvi',
              onTap: onGirviTap,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.groups_outlined,
              titleMr: 'ग्राहक',
              titleEn: 'Customers',
              onTap: onCustomersTap,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.inventory_2_outlined,
              titleMr: 'स्टॉक',
              titleEn: 'Inventory',
              onTap: onInventoryTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? _gold : _ink;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            titleEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? _ink : _muted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
