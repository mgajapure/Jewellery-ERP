import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/customer/customer.dart';
import 'package:jewellery_erp/src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/widgets/app_bottom_nav.dart';
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
            AppBottomNav(
              currentIndex: 1,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.goNamed(DashboardPage.routeName);
                    break;
                  case 1:
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

class _GirviListHeader extends StatelessWidget {
  const _GirviListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'गिरवी यादी / Girvi List',
              textAlign: TextAlign.left,
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
      onTap: () => context.goNamed(
        GirviDetailsPage.routeName,
        pathParameters: {'id': serialId},
      ),
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
                CircleAvatar(
                  radius: 20.0, // Controls the size (diameter will be 80.0)
                  backgroundColor:
                      GirviColors.ink, // Placeholder background color
                  child: CircleAvatar(
                    radius: 19.0, // Controls the size (diameter will be 80.0)
                    backgroundColor: GirviColors.screenBg,
                    child: Icon(
                      Icons.person,
                      size: 25.0,
                      color: GirviColors.ink, // Placeholder icon
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: GirviColors.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
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
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            customerNameEn,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: GirviColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            serialId,
                            style: const TextStyle(
                              color: GirviColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: GirviColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'कर्ज रक्कम',
                    labelEn: 'Loan Amount',
                    value: loanAmount,
                  ),
                ),
                Container(width: 1, height: 50, color: GirviColors.line),
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'बाकी रक्कम',
                    labelEn: 'Outstanding',
                    value: outstanding,
                  ),
                ),
                Container(width: 1, height: 50, color: GirviColors.line),
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'देय तारीख',
                    labelEn: 'Due Date',
                    value: dueDate,
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: GirviColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetaChip(
                  icon: Icons.diamond_outlined,
                  label: '$items वस्तू / Items',
                ),
                const SizedBox(width: 12),
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
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 12,
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
            fontSize: 10,
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
        ? '${-daysLeft} दिवस उशीर / Days Late'
        : daysLeft == 0
        ? 'आज देय / Due Today'
        : '$daysLeft दिवस शिल्लक / Days Left';

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
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

