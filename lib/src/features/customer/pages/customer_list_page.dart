import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/girvi/pages/girvi_list_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/bilingual_text.dart';
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
                children: const [
                  _CustomerTile(
                    name: 'Ramesh Mahajan',
                    mobile: '98765 43210',
                    customerId: 'CUS-000101',
                    active: true,
                    avatarColor: Color(0xFFFFF7E9),
                    initialsColor: Color(0xFFE7A726),
                  ),
                  SizedBox(height: 10),
                  _CustomerTile(
                    name: 'Suresh More',
                    mobile: '87654 32109',
                    customerId: 'CUS-000102',
                    active: true,
                    avatarColor: Color(0xFFF0F4FF),
                    initialsColor: Color(0xFF5E72E4),
                  ),
                  SizedBox(height: 10),
                  _CustomerTile(
                    name: 'Priya Patil',
                    mobile: '77788 99001',
                    customerId: 'CUS-000103',
                    active: true,
                    avatarColor: Color(0xFFE6F7EF),
                    initialsColor: Color(0xFF07934A),
                  ),
                  SizedBox(height: 10),
                  _CustomerTile(
                    name: 'Vikram Jadhav',
                    mobile: '90909 12345',
                    customerId: 'CUS-000104',
                    active: false,
                    avatarColor: Color(0xFFFFEBEE),
                    initialsColor: Color(0xFFE21B2D),
                  ),
                  SizedBox(height: 10),
                  _CustomerTile(
                    name: 'Anil Kadam',
                    mobile: '70203 45678',
                    customerId: 'CUS-000105',
                    active: true,
                    avatarColor: Color(0xFFFFF3E0),
                    initialsColor: Color(0xFFEF6C00),
                  ),
                  SizedBox(height: 10),
                  _CustomerTile(
                    name: 'Meena Deshmukh',
                    mobile: '98220 33445',
                    customerId: 'CUS-000106',
                    active: true,
                    avatarColor: Color(0xFFF3E5F5),
                    initialsColor: Color(0xFF8E24AA),
                  ),
                ],
              ),
            ),
            const _PaginationFooter(),
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

class _CustomerListHeader extends StatelessWidget {
  const _CustomerListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () =>
                AppNavigation.popOrGoNamed(context, DashboardPage.routeName),
            icon: const Icon(Icons.arrow_back, color: CustomerColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: BilingualText(
              en: 'Customers',
              mr: 'ग्राहक सूची',
              hi: 'ग्राहक',
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => context.goNamed(CreateCustomerPage.routeName),
            icon: const Icon(Icons.add, color: CustomerColors.ink),
            tooltip: 'Add Customer',
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
              child: Text(
                'नाव, मोबाईल, ग्राहक ID शोधा',
                style: TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Search name, mobile, customer ID',
              style: TextStyle(
                color: CustomerColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 10),
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
    _FilterChipData(mr: 'सर्व', en: 'All', count: 156),
    _FilterChipData(mr: 'सक्रिय', en: 'Active', count: 112),
    _FilterChipData(mr: 'निष्क्रिय', en: 'Inactive', count: 44),
  ];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
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
              mr: filter.mr,
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
    required this.en,
    required this.count,
  });

  final String mr;
  final String en;
  final int count;
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.name,
    required this.mobile,
    required this.customerId,
    required this.active,
    required this.avatarColor,
    required this.initialsColor,
  });

  final String name;
  final String mobile;
  final String customerId;
  final bool active;
  final Color avatarColor;
  final Color initialsColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(
        CustomerDetailsPage.routeName,
        pathParameters: {'id': customerId},
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
              name: name,
              backgroundColor: avatarColor,
              foregroundColor: initialsColor,
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 4),
                  Text(
                    '$mobile • $customerId',
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (active ? CustomerColors.green : CustomerColors.red)
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: BilingualText(
                      en: active ? 'Active' : 'Inactive',
                      mr: active ? 'सक्रिय' : 'निष्क्रिय',
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

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_left,
              color: CustomerColors.muted,
              size: 22,
            ),
            tooltip: 'Previous',
          ),
          const SizedBox(width: 8),
          const Text(
            'पृष्ठ 1 / 16',
            style: TextStyle(
              color: CustomerColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '• Page 1 of 16',
            style: TextStyle(
              color: CustomerColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chevron_right,
              color: CustomerColors.ink,
              size: 22,
            ),
            tooltip: 'Next',
          ),
        ],
      ),
    );
  }
}
