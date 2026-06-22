import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/customer/customer.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/inventory/inventory.dart';

import '../theme/girvi_colors.dart';
import 'create_girvi_wizard_page.dart';
import 'girvi_details_page.dart';

class GirviListPage extends StatelessWidget {
  const GirviListPage({super.key});

  static const routeName = 'girvi-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _GirviListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchBar(),
            ),
            const _FilterChips(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: const [
                  _GirviCard(
                    serialId: 'GRV-2026-000521',
                    customerName: 'सुरेश पाटील',
                    customerNameEn: 'Suresh Patil',
                    status: 'ACTIVE',
                    loanAmount: '₹75,000',
                    outstanding: '₹82,450',
                    dueDate: '15 Jul 2026',
                    items: 2,
                    daysLeft: 18,
                  ),
                  SizedBox(height: 12),
                  _GirviCard(
                    serialId: 'GRV-2026-000520',
                    customerName: 'मीना जाधव',
                    customerNameEn: 'Meena Jadhav',
                    status: 'PARTIAL_PAID',
                    loanAmount: '₹50,000',
                    outstanding: '₹28,000',
                    dueDate: '20 Jul 2026',
                    items: 1,
                    daysLeft: 23,
                  ),
                  SizedBox(height: 12),
                  _GirviCard(
                    serialId: 'GRV-2026-000519',
                    customerName: 'अमोल देशमुख',
                    customerNameEn: 'Amol Deshmukh',
                    status: 'OVERDUE',
                    loanAmount: '₹1,20,000',
                    outstanding: '₹1,38,500',
                    dueDate: '01 Jun 2026',
                    items: 3,
                    daysLeft: -13,
                  ),
                  SizedBox(height: 12),
                  _GirviCard(
                    serialId: 'GRV-2026-000518',
                    customerName: 'सुनीता शिंदे',
                    customerNameEn: 'Sunita Shinde',
                    status: 'REDEEMED',
                    loanAmount: '₹35,000',
                    outstanding: '₹0',
                    dueDate: '10 May 2026',
                    items: 1,
                    daysLeft: 0,
                  ),
                  SizedBox(height: 12),
                  _GirviCard(
                    serialId: 'GRV-2026-000517',
                    customerName: 'राजेंद्र कदम',
                    customerNameEn: 'Rajendra Kadam',
                    status: 'RENEWED',
                    loanAmount: '₹2,00,000',
                    outstanding: '₹2,18,000',
                    dueDate: '10 Aug 2026',
                    items: 4,
                    daysLeft: 44,
                  ),
                ],
              ),
            ),
            _AppBottomNav(
              onDashboardTap: () => context.goNamed(DashboardPage.routeName),
              onCustomersTap: () => context.goNamed(CustomerListPage.routeName),
              onInventoryTap: () =>
                  context.goNamed(InventoryListPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class _GirviListHeader extends StatelessWidget {
  const _GirviListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'गिरवी यादी / Girvi List',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GirviColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.goNamed(CreateGirviWizardPage.routeName),
            icon: const Icon(Icons.add_circle, color: GirviColors.ink),
            tooltip: 'नवीन गिरवी / New Girvi',
          ),
        ],
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
        border: Border.all(color: GirviColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: GirviColors.muted, size: 22),
          SizedBox(width: 12),
          Text(
            'ग्राहक / सिरीयल आयडी / QR शोधा',
            style: TextStyle(
              color: GirviColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Icon(Icons.qr_code_scanner, color: GirviColors.muted, size: 22),
        ],
      ),
    );
  }
}

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  final List<String> _labels = const [
    'सर्व / All',
    'सक्रिय / Active',
    'आंशिक पेड / Partial',
    'नवीनीकृत / Renewed',
    'मुद्दलपरत / Redeemed',
    'ओव्हरड्यू / Overdue',
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == _selected;
          return ChoiceChip(
            label: Text(
              _labels[index],
              style: TextStyle(
                color: selected ? GirviColors.gold : GirviColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected,
            selectedColor: GirviColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected ? GirviColors.navy : GirviColors.line,
              ),
            ),
            onSelected: (_) => setState(() => _selected = index),
          );
        },
      ),
    );
  }
}

class _GirviCard extends StatelessWidget {
  const _GirviCard({
    required this.serialId,
    required this.customerName,
    required this.customerNameEn,
    required this.status,
    required this.loanAmount,
    required this.outstanding,
    required this.dueDate,
    required this.items,
    required this.daysLeft,
  });

  final String serialId;
  final String customerName;
  final String customerNameEn;
  final String status;
  final String loanAmount;
  final String outstanding;
  final String dueDate;
  final int items;
  final int daysLeft;

  Color get _statusColor {
    switch (status) {
      case 'OVERDUE':
        return GirviColors.red;
      case 'REDEEMED':
        return GirviColors.muted;
      case 'PARTIAL_PAID':
      case 'RENEWED':
        return GirviColors.gold;
      default:
        return GirviColors.green;
    }
  }

  String get _statusText {
    switch (status) {
      case 'ACTIVE':
        return 'सक्रिय / Active';
      case 'PARTIAL_PAID':
        return 'आंशिक पेड / Partial';
      case 'RENEWED':
        return 'नवीनीकृत / Renewed';
      case 'REDEEMED':
        return 'मुद्दलपरत / Redeemed';
      case 'OVERDUE':
        return 'ओव्हरड्यू / Overdue';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(GirviDetailsPage.routeName),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GirviColors.line),
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serialId,
                        style: const TextStyle(
                          color: GirviColors.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: GirviColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customerNameEn,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: GirviColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusText,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'कर्ज रक्कम',
                    labelEn: 'Loan Amount',
                    value: loanAmount,
                  ),
                ),
                Container(width: 1, height: 30, color: GirviColors.line),
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'बाकी रक्कम',
                    labelEn: 'Outstanding',
                    value: outstanding,
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: GirviColors.line),
            Row(
              children: [
                _MetaChip(
                  icon: Icons.diamond_outlined,
                  label: '$items वस्तू / Items',
                ),
                const SizedBox(width: 12),
                _MetaChip(
                  icon: Icons.calendar_today_outlined,
                  label: 'देय तारीख / $dueDate',
                ),
                const Spacer(),
                _DaysLeftChip(daysLeft: daysLeft),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelMr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          labelEn,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: GirviColors.muted),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DaysLeftChip extends StatelessWidget {
  const _DaysLeftChip({required this.daysLeft});

  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final isOverdue = daysLeft < 0;
    final color = isOverdue ? GirviColors.red : GirviColors.ink;
    final text = isOverdue
        ? '${-daysLeft} दिवस उशीर / Late'
        : daysLeft == 0
        ? 'आज देय / Due Today'
        : '$daysLeft दिवस शिल्लक / Left';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({
    required this.onDashboardTap,
    required this.onCustomersTap,
    required this.onInventoryTap,
  });

  final VoidCallback onDashboardTap;
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
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              titleMr: 'डॅशबोर्ड',
              titleEn: 'Dashboard',
              onTap: onDashboardTap,
            ),
          ),
          const Expanded(
            child: _BottomNavItem(
              icon: Icons.diamond_outlined,
              titleMr: 'गिरवी',
              titleEn: 'Girvi',
              selected: true,
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

const _gold = Color(0xFFE7A726);
const _ink = Color(0xFF071A49);
const _muted = Color(0xFF5E6880);
const _line = Color(0xFFE5E8EF);

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
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            titleEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? _ink : _muted,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
