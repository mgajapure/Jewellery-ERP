import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/customer_colors.dart';
import 'create_customer_page.dart';
import 'customer_details_page.dart';
import 'customer_search_page.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  static const routeName = 'customer-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _CustomerListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchBar(
                onTap: () => context.goNamed(CustomerSearchPage.routeName),
              ),
            ),
            const _FilterChips(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: const [
                  _CustomerCard(
                    name: 'सुरेश पाटील',
                    nameEn: 'Suresh Patil',
                    mobile: '+91 98765 43210',
                    customerId: 'CUST-2026-000101',
                    activeGirvi: 2,
                    outstanding: '₹1,25,000',
                    risk: 'LOW',
                  ),
                  SizedBox(height: 12),
                  _CustomerCard(
                    name: 'मीना जाधव',
                    nameEn: 'Meena Jadhav',
                    mobile: '+91 87654 32109',
                    customerId: 'CUST-2026-000102',
                    activeGirvi: 1,
                    outstanding: '₹45,000',
                    risk: 'LOW',
                  ),
                  SizedBox(height: 12),
                  _CustomerCard(
                    name: 'अमोल देशमुख',
                    nameEn: 'Amol Deshmukh',
                    mobile: '+91 76543 21098',
                    customerId: 'CUST-2026-000103',
                    activeGirvi: 3,
                    outstanding: '₹2,80,000',
                    risk: 'MEDIUM',
                  ),
                  SizedBox(height: 12),
                  _CustomerCard(
                    name: 'सुनीता शिंदे',
                    nameEn: 'Sunita Shinde',
                    mobile: '+91 65432 10987',
                    customerId: 'CUST-2026-000104',
                    activeGirvi: 0,
                    outstanding: '₹0',
                    risk: 'LOW',
                  ),
                  SizedBox(height: 12),
                  _CustomerCard(
                    name: 'राजेंद्र कदम',
                    nameEn: 'Rajendra Kadam',
                    mobile: '+91 54321 09876',
                    customerId: 'CUST-2026-000105',
                    activeGirvi: 2,
                    outstanding: '₹3,50,000',
                    risk: 'HIGH',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(CreateCustomerPage.routeName),
        backgroundColor: CustomerColors.navy,
        icon: const Icon(Icons.add, color: CustomerColors.gold),
        label: const Text(
          'नवीन ग्राहक / New Customer',
          style: TextStyle(
            color: CustomerColors.gold,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CustomerListHeader extends StatelessWidget {
  const _CustomerListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: CustomerColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'ग्राहक यादी / Customer List',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: CustomerColors.ink),
            tooltip: 'Filter',
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomerColors.line),
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
            Icon(Icons.search, color: CustomerColors.muted, size: 22),
            SizedBox(width: 12),
            Text(
              'नाव / मोबाईल / आयडी शोधा',
              style: TextStyle(
                color: CustomerColors.muted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Icon(Icons.qr_code_scanner, color: CustomerColors.muted, size: 22),
          ],
        ),
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
    'निष्क्रिय / Inactive',
    'उच्च जोखीम / High Risk',
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
                color: selected ? CustomerColors.gold : CustomerColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected,
            selectedColor: CustomerColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected ? CustomerColors.navy : CustomerColors.line,
              ),
            ),
            onSelected: (_) => setState(() => _selected = index),
          );
        },
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({
    required this.name,
    required this.nameEn,
    required this.mobile,
    required this.customerId,
    required this.activeGirvi,
    required this.outstanding,
    required this.risk,
  });

  final String name;
  final String nameEn;
  final String mobile;
  final String customerId;
  final int activeGirvi;
  final String outstanding;
  final String risk;

  Color get _riskColor {
    switch (risk) {
      case 'HIGH':
        return CustomerColors.red;
      case 'MEDIUM':
        return CustomerColors.gold;
      default:
        return CustomerColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(CustomerDetailsPage.routeName),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomerColors.line),
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
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CustomerColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nameEn,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CustomerColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _riskColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    risk,
                    style: TextStyle(
                      color: _riskColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16, color: CustomerColors.muted),
                const SizedBox(width: 6),
                Text(
                  mobile,
                  style: const TextStyle(
                    color: CustomerColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.badge_outlined, size: 16, color: CustomerColors.muted),
                const SizedBox(width: 6),
                Text(
                  customerId,
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: CustomerColors.line),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'सक्रिय गिरवी',
                    labelEn: 'Active Girvi',
                    value: activeGirvi.toString(),
                  ),
                ),
                Container(width: 1, height: 30, color: CustomerColors.line),
                Expanded(
                  child: _SummaryItem(
                    labelMr: 'बाकी रक्कम',
                    labelEn: 'Outstanding',
                    value: outstanding,
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
            color: CustomerColors.muted,
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
            color: CustomerColors.muted,
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
            color: CustomerColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
