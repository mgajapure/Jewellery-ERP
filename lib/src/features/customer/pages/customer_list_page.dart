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
                    customer: _kDemoCustomers['CUS-000101']!,
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
                    customer: _kDemoCustomers['CUS-000102']!,
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
                    customer: _kDemoCustomers['CUS-000103']!,
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
                    customer: _kDemoCustomers['CUS-000104']!,
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
                    customer: _kDemoCustomers['CUS-000105']!,
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
                    customer: _kDemoCustomers['CUS-000106']!,
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

final _kDemoCustomers = <String, Customer>{
  'CUS-000101': Customer(
    id: 'CUS-000101', tenantId: 'demo', digitalCustomerId: 'CUS-000101',
    name: 'रमेश महाजन', nameEn: 'Ramesh Mahajan',
    mobile: '9876543210', alternateMobile: '9823001122',
    address: 'Plot 12, Ganesh Nagar, Kothrud, Pune, Maharashtra - 411038',
    aadhaarMasked: 'XXXX-XXXX-3456', panNumber: 'AABPM1234C',
    dateOfBirth: DateTime(1978, 4, 12),
    riskCategory: RiskCategory.low, isActive: true,
    activeGirvi: 3, outstanding: 142500,
    createdAt: DateTime(2022, 6, 15), updatedAt: DateTime(2025, 3, 10), version: 5,
  ),
  'CUS-000102': Customer(
    id: 'CUS-000102', tenantId: 'demo', digitalCustomerId: 'CUS-000102',
    name: 'सुरेश मोरे', nameEn: 'Suresh More',
    mobile: '8765432109',
    address: 'Flat 4B, Shivaji Housing Society, Hadapsar, Pune, Maharashtra - 411028',
    aadhaarMasked: 'XXXX-XXXX-7890', panNumber: 'BCFPS5678D',
    dateOfBirth: DateTime(1985, 9, 22),
    riskCategory: RiskCategory.medium, isActive: true,
    activeGirvi: 1, outstanding: 38000,
    createdAt: DateTime(2023, 2, 8), updatedAt: DateTime(2025, 1, 20), version: 2,
  ),
  'CUS-000103': Customer(
    id: 'CUS-000103', tenantId: 'demo', digitalCustomerId: 'CUS-000103',
    name: 'प्रिया पाटील', nameEn: 'Priya Patil',
    mobile: '7778899001',
    address: '88, Laxmi Road, Narayan Peth, Pune, Maharashtra - 411030',
    aadhaarMasked: 'XXXX-XXXX-2211', panNumber: 'CGQPP2345E',
    dateOfBirth: DateTime(1992, 1, 5),
    riskCategory: RiskCategory.low, isActive: true,
    activeGirvi: 2, outstanding: 67000,
    createdAt: DateTime(2021, 11, 30), updatedAt: DateTime(2025, 4, 2), version: 8,
  ),
  'CUS-000104': Customer(
    id: 'CUS-000104', tenantId: 'demo', digitalCustomerId: 'CUS-000104',
    name: 'विक्रम जाधव', nameEn: 'Vikram Jadhav',
    mobile: '9090912345',
    address: 'House 7, Ram Krishna Nagar, Aundh, Pune, Maharashtra - 411007',
    aadhaarMasked: 'XXXX-XXXX-5544',
    dateOfBirth: DateTime(1970, 7, 18),
    riskCategory: RiskCategory.high, isActive: false,
    activeGirvi: 0, outstanding: 0,
    createdAt: DateTime(2020, 5, 5), updatedAt: DateTime(2024, 12, 1), version: 3,
  ),
  'CUS-000105': Customer(
    id: 'CUS-000105', tenantId: 'demo', digitalCustomerId: 'CUS-000105',
    name: 'अनिल कदम', nameEn: 'Anil Kadam',
    mobile: '7020345678',
    address: 'D-203, Suyog Apartments, Wakad, Pune, Maharashtra - 411057',
    aadhaarMasked: 'XXXX-XXXX-9988', panNumber: 'DHKAK7890F',
    dateOfBirth: DateTime(1981, 3, 30),
    riskCategory: RiskCategory.low, isActive: true,
    activeGirvi: 1, outstanding: 25500,
    createdAt: DateTime(2023, 8, 14), updatedAt: DateTime(2025, 2, 28), version: 1,
  ),
  'CUS-000106': Customer(
    id: 'CUS-000106', tenantId: 'demo', digitalCustomerId: 'CUS-000106',
    name: 'मीना देशमुख', nameEn: 'Meena Deshmukh',
    mobile: '9822033445',
    address: '15, Tilak Road, Sadashiv Peth, Pune, Maharashtra - 411030',
    aadhaarMasked: 'XXXX-XXXX-6677', panNumber: 'EJLMD3456G',
    dateOfBirth: DateTime(1968, 11, 25),
    riskCategory: RiskCategory.low, isActive: true,
    activeGirvi: 4, outstanding: 198000,
    createdAt: DateTime(2019, 3, 20), updatedAt: DateTime(2025, 5, 1), version: 12,
  ),
};

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

