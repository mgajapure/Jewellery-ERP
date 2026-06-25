import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/bilingual_text.dart';
import '../compliance/compliance.dart';
import '../customer/customer.dart';
import '../girvi/girvi.dart';
import '../interest/interest.dart';
import '../more/more.dart';
import '../purchase/purchase.dart';
import '../sales/sales.dart';
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
                    en: 'Key Metrics',
                    mr: 'मुख्य आकडेवारी',
                    hi: 'मुख्य संख्याएं',
                    trailingEn: 'Today',
                    trailingMr: 'आज',
                  ),
                  const SizedBox(height: 10),
                  const _MetricGrid(),
                  const SizedBox(height: 18),
                  const _SectionHeader(en: 'Quick Actions', mr: 'जलद कृती', hi: 'त्वरित क्रियाएं'),
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
                    onSalesTap: () =>
                        context.goNamed(SalesDashboardPage.routeName),
                  ),
                  const SizedBox(height: 22),
                  _SectionHeader(
                    en: 'Recent Payments',
                    mr: 'अलीकडील पेमेंट्स',
                    hi: 'हाल के भुगतान',
                    trailingEn: 'View All',
                    trailingMr: 'सर्व पहा',
                    onTrailingTap: () =>
                        context.goNamed(GirviListPage.routeName),
                  ),
                  const SizedBox(height: 12),
                  const _RecentPaymentsList(),
                ],
              ),
            ),
            AppBottomNav(
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 0:
                    break;
                  case 1:
                    context.goNamed(GirviListPage.routeName);
                    break;
                  case 2:
                    context.goNamed(CustomerListPage.routeName);
                    break;
                  case 3:
                    context.goNamed(MorePage.routeName);
                    break;
                }
              },
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
          const BilingualText(
            en: 'Dashboard',
            mr: 'डॅशबोर्ड',
            hi: 'डैशबोर्ड',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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
      ),
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
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BilingualText(
                      en: 'Gold Rate Today (24K)',
                      mr: 'आजचा सोनाचा दर (24K)',
                      hi: 'आज का सोने का भाव (24K)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    BilingualText(
                      en: 'per 10g',
                      mr: 'प्रति 10 ग्रॅम',
                      hi: 'प्रति 10 ग्राम',
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
  const _SectionHeader({
    required this.en,
    this.mr,
    this.hi,
    this.trailingEn,
    this.trailingMr,
    this.onTrailingTap,
  });

  final String en;
  final String? mr;
  final String? hi;
  final String? trailingEn;
  final String? trailingMr;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BilingualText(
            en: en,
            mr: mr,
            hi: hi,
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingEn != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onTrailingTap,
            child: BilingualText(
              en: trailingEn!,
              mr: trailingMr,
              style: TextStyle(
                color: onTrailingTap != null ? _navy : _muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                decoration: onTrailingTap != null
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: _navy,
              ),
              textAlign: TextAlign.end,
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
          titleHi: 'कुल सक्रिय गिरवी',
          value: '128',
          delta: '+12 आज / today',
        ),
        _MetricTile(
          titleMr: 'एकूण डिस्बर्समेंट',
          titleEn: 'Total Disbursed',
          titleHi: 'ऋण एक्सपोजर',
          value: '₹2.45 Cr',
          delta: '+₹18.6L आज / today',
        ),
        _MetricTile(
          titleMr: 'आजचे व्याज',
          titleEn: 'Interest Due Today',
          titleHi: 'आज का संग्रह',
          value: '₹48,760',
          delta: '+₹3,250 आज / today',
        ),
        _MetricTile(
          titleMr: 'ओव्हरड्यू खाती',
          titleEn: 'Overdue Accounts',
          titleHi: 'अतिदेय खाते',
          value: '21',
          valueColor: _red,
          delta: '+2 आज / today',
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.titleMr,
    required this.titleEn,
    this.titleHi,
    required this.value,
    required this.delta,
    this.valueColor = _ink,
  });

  final String titleMr;
  final String titleEn;
  final String? titleHi;
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
          BilingualText(
            en: titleEn,
            mr: titleMr,
            hi: titleHi,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    this.onSalesTap,
  });

  final VoidCallback? onNewGirviTap;
  final VoidCallback? onSearchCustomerTap;
  final VoidCallback? onVaultSearchTap;
  final VoidCallback? onInterestCalcTap;
  final VoidCallback? onComplianceTap;
  final VoidCallback? onPurchaseTap;
  final VoidCallback? onSalesTap;

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
              titleHi: 'नई गिरवी',
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
              titleHi: 'खोजें',
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
              titleHi: 'तिजोरी',
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
              titleHi: 'ब्याज',
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
              titleHi: 'अनुपालन',
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
              titleHi: 'खरीद',
              onTap: onPurchaseTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.point_of_sale_outlined,
              titleMr: 'विक्री',
              titleEn: 'Sales',
              titleHi: 'बिक्री',
              onTap: onSalesTap,
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
    this.titleHi,
    this.filled = false,
    this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final String? titleHi;
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
          BilingualText(
            en: titleEn,
            mr: titleMr,
            hi: titleHi,
            style: const TextStyle(
              color: _ink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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
            paymentTypeMr: 'व्याज पेमेंट',
            paymentTypeEn: 'Interest Payment',
            amount: '₹12,500',
            time: '10:45 AM',
            icon: Icons.south_west,
          ),
          _ListDivider(),
          _PaymentTransactionTile(
            customerName: 'मीना जाधव',
            customerSubtitle: 'Meena Jadhav',
            paymentTypeMr: 'मुद्दल पेमेंट',
            paymentTypeEn: 'Principal Payment',
            amount: '₹35,000',
            time: '09:20 AM',
            icon: Icons.south_west,
          ),
          _ListDivider(),
          _PaymentTransactionTile(
            customerName: 'अमोल देशमुख',
            customerSubtitle: 'Amol Deshmukh',
            paymentTypeMr: 'आंशिक पेमेंट',
            paymentTypeEn: 'Partial Payment',
            amount: '₹8,760',
            time: 'काल / Yesterday',
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
    required this.paymentTypeMr,
    required this.paymentTypeEn,
    required this.amount,
    required this.time,
    required this.icon,
  });

  final String customerName;
  final String customerSubtitle;
  final String paymentTypeMr;
  final String paymentTypeEn;
  final String amount;
  final String time;
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
                BilingualText(
                  en: paymentTypeEn,
                  mr: paymentTypeMr,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
              const BilingualText(
                en: 'Paid',
                mr: 'पूर्ण',
                hi: 'भुगतान',
                style: TextStyle(
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

