import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/girvi/pages/girvi_list_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/customer.dart';
import '../theme/customer_colors.dart';
import 'create_customer_page.dart';
import 'customer_details_page.dart';
import 'customer_search_page.dart';

/// SCR-010 Customer List / Search
/// Displays a searchable, filterable list of customers with pagination.
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                children: [
                  _CustomerTile(
                    nameEn: 'Ramesh Mahajan',
                    nameMr: 'रमेश महाजन',
                    mobile: '98765 43210',
                    customerId: 'CUS-000101',
                    active: true,
                    avatarColor: const Color(0xFFFFF7E9),
                    initialsColor: const Color(0xFFE7A726),
                    customer: _demoCustomer('CUS-000101', 'रमेश महाजन', 'Ramesh Mahajan', '98765 43210', true),
                  ),
                  const SizedBox(height: 10),
                  _CustomerTile(
                    nameEn: 'Suresh More',
                    nameMr: 'सुरेश मोरे',
                    mobile: '87654 32109',
                    customerId: 'CUS-000102',
                    active: true,
                    avatarColor: const Color(0xFFF0F4FF),
                    initialsColor: const Color(0xFF5E72E4),
                    customer: _demoCustomer('CUS-000102', 'सुरेश मोरे', 'Suresh More', '87654 32109', true),
                  ),
                  const SizedBox(height: 10),
                  _CustomerTile(
                    nameEn: 'Priya Patil',
                    nameMr: 'प्रिया पाटील',
                    mobile: '77788 99001',
                    customerId: 'CUS-000103',
                    active: true,
                    avatarColor: const Color(0xFFE6F7EF),
                    initialsColor: const Color(0xFF07934A),
                    customer: _demoCustomer('CUS-000103', 'प्रिया पाटील', 'Priya Patil', '77788 99001', true),
                  ),
                  const SizedBox(height: 10),
                  _CustomerTile(
                    nameEn: 'Vikram Jadhav',
                    nameMr: 'विक्रम जाधव',
                    mobile: '90909 12345',
                    customerId: 'CUS-000104',
                    active: false,
                    avatarColor: const Color(0xFFFFEBEE),
                    initialsColor: const Color(0xFFE21B2D),
                    customer: _demoCustomer('CUS-000104', 'विक्रम जाधव', 'Vikram Jadhav', '90909 12345', false),
                  ),
                  const SizedBox(height: 10),
                  _CustomerTile(
                    nameEn: 'Anil Kadam',
                    nameMr: 'अनिल कदम',
                    mobile: '70203 45678',
                    customerId: 'CUS-000105',
                    active: true,
                    avatarColor: const Color(0xFFFFF3E0),
                    initialsColor: const Color(0xFFEF6C00),
                    customer: _demoCustomer('CUS-000105', 'अनिल कदम', 'Anil Kadam', '70203 45678', true),
                  ),
                  const SizedBox(height: 10),
                  _CustomerTile(
                    nameEn: 'Meena Deshmukh',
                    nameMr: 'मीना देशमुख',
                    mobile: '98220 33445',
                    customerId: 'CUS-000106',
                    active: true,
                    avatarColor: const Color(0xFFF3E5F5),
                    initialsColor: const Color(0xFF8E24AA),
                    customer: _demoCustomer('CUS-000106', 'मीना देशमुख', 'Meena Deshmukh', '98220 33445', true),
                  ),
                ],
              ),
            ),
            AppBottomNav(
              currentIndex: 2,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.goNamed(DashboardPage.routeName);
                    break;
                  case 1:
                    context.goNamed(GirviListPage.routeName);
                    break;
                  case 2:
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

Customer _demoCustomer(
  String id,
  String name,
  String nameEn,
  String mobile,
  bool isActive,
) {
  final now = DateTime(2025, 1, 1);
  return Customer(
    id: id,
    tenantId: 'demo',
    digitalCustomerId: id,
    name: name,
    nameEn: nameEn,
    mobile: mobile,
    address: 'Demo Address, Pune, Maharashtra - 411001',
    riskCategory: RiskCategory.low,
    isActive: isActive,
    activeGirvi: 0,
    outstanding: 0,
    createdAt: now,
    updatedAt: now,
    version: 1,
  );
}

class _CustomerListHeader extends StatelessWidget {
  const _CustomerListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
      child: Row(
        children: [
          const Expanded(
            child: BilingualText(
              en: 'Customers',
              mr: 'ग्राहक सूची',
              hi: 'ग्राहक',
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () => context.goNamed(CreateCustomerPage.routeName),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: CustomerColors.navy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  BilingualText(
                    en: 'New',
                    mr: 'नवीन',
                    hi: 'नया',
                    compact: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
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
            Expanded(
              child: BilingualText(
                en: 'Search name, mobile, customer ID',
                mr: 'नाव, मोबाईल, ग्राहक ID शोधा',
                hi: 'नाम, मोबाइल, ग्राहक ID खोजें',
                style: TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
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
  final List<_FilterChipData> _filters = const [
    _FilterChipData(mr: 'सर्व', hi: 'सभी', en: 'All', count: 156),
    _FilterChipData(mr: 'सक्रिय', hi: 'सक्रिय', en: 'Active', count: 112),
    _FilterChipData(mr: 'निष्क्रिय', hi: 'निष्क्रिय', en: 'Inactive', count: 44),
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == _selected;
          final filter = _filters[index];
          return ChoiceChip(
            label: BilingualText(
              en: '${filter.en} (${filter.count})',
              mr: '${filter.mr} (${filter.count})',
              hi: '${filter.hi} (${filter.count})',
              style: TextStyle(
                color: selected ? Colors.white : CustomerColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

class _FilterChipData {
  const _FilterChipData({
    required this.mr,
    required this.hi,
    required this.en,
    required this.count,
  });

  final String mr;
  final String hi;
  final String en;
  final int count;
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.nameEn,
    required this.nameMr,
    required this.mobile,
    required this.customerId,
    required this.active,
    required this.avatarColor,
    required this.initialsColor,
    required this.customer,
  });

  final String nameEn;
  final String nameMr;
  final String mobile;
  final String customerId;
  final bool active;
  final Color avatarColor;
  final Color initialsColor;
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(
        CustomerDetailsPage.routeName,
        pathParameters: {'id': customerId},
        extra: customer,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          children: [
            _InitialsAvatar(
              name: nameEn,
              backgroundColor: avatarColor,
              foregroundColor: initialsColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BilingualText(
                          en: nameEn,
                          mr: nameMr,
                          hi: nameMr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CustomerColors.ink,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: (active
                                  ? CustomerColors.green
                                  : CustomerColors.red)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: BilingualText(
                          en: active ? 'Active' : 'Inactive',
                          mr: active ? 'सक्रिय' : 'निष्क्रिय',
                          hi: active ? 'सक्रिय' : 'निष्क्रिय',
                          style: TextStyle(
                            color: active
                                ? CustomerColors.green
                                : CustomerColors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$mobile • $customerId',
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: CustomerColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String name;
  final Color backgroundColor;
  final Color foregroundColor;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

