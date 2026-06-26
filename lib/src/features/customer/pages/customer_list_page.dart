import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/girvi/pages/girvi_list_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/l10n/app_language.dart';
import '../../../core/l10n/app_l10n_provider.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/customer.dart';
import '../theme/customer_colors.dart';
import 'create_customer_page.dart';
import 'customer_demo_data.dart';
import 'customer_details_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  static const routeName = 'customer-list';

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final _searchController = TextEditingController();
  String _query = '';
  int _filterIndex = 0;

  static const _tileColors = {
    'CUS-000101': (bg: Color(0xFFFFF7E9), fg: Color(0xFFE7A726)),
    'CUS-000102': (bg: Color(0xFFF0F4FF), fg: Color(0xFF5E72E4)),
    'CUS-000103': (bg: Color(0xFFE6F7EF), fg: Color(0xFF07934A)),
    'CUS-000104': (bg: Color(0xFFFFEBEE), fg: Color(0xFFE21B2D)),
    'CUS-000105': (bg: Color(0xFFFFF3E0), fg: Color(0xFFEF6C00)),
    'CUS-000106': (bg: Color(0xFFF3E5F5), fg: Color(0xFF8E24AA)),
  };

  static const _defaultColor = (
    bg: Color(0xFFF0F4FF),
    fg: Color(0xFF5E72E4),
  );

  List<Customer> get _allCustomers => kDemoCustomers.values.toList();

  List<Customer> get _filteredCustomers {
    var list = _allCustomers;
    if (_filterIndex == 1) list = list.where((c) => c.isActive).toList();
    if (_filterIndex == 2) list = list.where((c) => !c.isActive).toList();
    final q = _query.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list.where((c) =>
        c.name.toLowerCase().contains(q) ||
        c.nameEn.toLowerCase().contains(q) ||
        c.mobile.contains(q) ||
        c.digitalCustomerId.toLowerCase().contains(q),
      ).toList();
    }
    return list;
  }

  String _formatMobile(String mobile) {
    if (mobile.length == 10) {
      return '${mobile.substring(0, 5)} ${mobile.substring(5)}';
    }
    return mobile;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = _filteredCustomers;
    final allCount = _allCustomers.length;
    final activeCount = _allCustomers.where((c) => c.isActive).length;
    final inactiveCount = allCount - activeCount;

    return Scaffold(
      backgroundColor: CustomerColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _CustomerListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchField(
                controller: _searchController,
                onChanged: (q) => setState(() => _query = q),
              ),
            ),
            _FilterChips(
              selectedIndex: _filterIndex,
              onChanged: (i) => setState(() => _filterIndex = i),
              allCount: allCount,
              activeCount: activeCount,
              inactiveCount: inactiveCount,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: customers.isEmpty
                  ? _NoResults(query: _query)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      itemCount: customers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final c = customers[i];
                        final colors = _tileColors[c.id] ?? _defaultColor;
                        return _CustomerTile(
                          nameEn: c.nameEn,
                          nameMr: c.name,
                          mobile: _formatMobile(c.mobile),
                          customerId: c.digitalCustomerId,
                          active: c.isActive,
                          avatarColor: colors.bg,
                          initialsColor: colors.fg,
                          customer: c,
                        );
                      },
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

// ── Header ───────────────────────────────────────────────────────────────────

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

// ── Search field ─────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppLangProvider>();
    final lang = provider?.notifier?.language ?? AppLanguage.en;
    final hint = lang == AppLanguage.mr
        ? 'नाव, मोबाईल, ग्राहक ID शोधा'
        : lang == AppLanguage.hi
            ? 'नाम, मोबाइल, ग्राहक ID खोजें'
            : 'Search name, mobile or ID';

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(
          color: CustomerColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.search, color: CustomerColors.muted, size: 22),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: CustomerColors.muted, size: 20),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : const Icon(Icons.qr_code_scanner, color: CustomerColors.muted, size: 22),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomerColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomerColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomerColors.navy, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

// ── Filter chips ─────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedIndex,
    required this.onChanged,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final int allCount;
  final int activeCount;
  final int inactiveCount;

  @override
  Widget build(BuildContext context) {
    final filters = [
      (mr: 'सर्व', hi: 'सभी', en: 'All', count: allCount),
      (mr: 'सक्रिय', hi: 'सक्रिय', en: 'Active', count: activeCount),
      (mr: 'निष्क्रिय', hi: 'निष्क्रिय', en: 'Inactive', count: inactiveCount),
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          final f = filters[index];
          return ChoiceChip(
            label: BilingualText(
              en: '${f.en} (${f.count})',
              mr: '${f.mr} (${f.count})',
              hi: '${f.hi} (${f.count})',
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
            onSelected: (_) => onChanged(index),
          );
        },
      ),
    );
  }
}

// ── No results ────────────────────────────────────────────────────────────────

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 56,
              color: CustomerColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            const BilingualText(
              en: 'No Customer Found',
              mr: 'ग्राहक सापडला नाही',
              hi: 'कोई ग्राहक नहीं मिला',
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            BilingualText(
              en: query.isEmpty ? 'No customers in this category' : 'No match for "$query"',
              mr: query.isEmpty ? 'या श्रेणीत ग्राहक नाही' : '"$query" साठी ग्राहक सापडला नाही',
              hi: query.isEmpty ? 'इस श्रेणी में कोई ग्राहक नहीं' : '"$query" के लिए कोई ग्राहक नहीं',
              style: const TextStyle(
                color: CustomerColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Customer tile ─────────────────────────────────────────────────────────────

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

// ── Initials avatar ───────────────────────────────────────────────────────────

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
