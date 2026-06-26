import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/customer/customer.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../theme/girvi_colors.dart';
import 'create_girvi_wizard_page.dart';
import 'girvi_details_page.dart';

const _kAllGirvis = [
  _GirviCardData(serialId: 'GRV-2026-000521', customerName: 'सुरेश पाटील', customerNameEn: 'Suresh Patil', status: 'ACTIVE', loanAmount: '₹75,000', outstanding: '₹82,450', dueDate: '15 Jul 2026', items: 2, daysLeft: 18),
  _GirviCardData(serialId: 'GRV-2026-000520', customerName: 'मीना जाधव', customerNameEn: 'Meena Jadhav', status: 'PARTIAL_PAID', loanAmount: '₹50,000', outstanding: '₹28,000', dueDate: '20 Jul 2026', items: 1, daysLeft: 23),
  _GirviCardData(serialId: 'GRV-2026-000519', customerName: 'अमोल देशमुख', customerNameEn: 'Amol Deshmukh', status: 'OVERDUE', loanAmount: '₹1,20,000', outstanding: '₹1,38,500', dueDate: '01 Jun 2026', items: 3, daysLeft: -13),
  _GirviCardData(serialId: 'GRV-2026-000518', customerName: 'सुनीता शिंदे', customerNameEn: 'Sunita Shinde', status: 'REDEEMED', loanAmount: '₹35,000', outstanding: '₹0', dueDate: '10 May 2026', items: 1, daysLeft: 0),
  _GirviCardData(serialId: 'GRV-2026-000517', customerName: 'राजेंद्र कदम', customerNameEn: 'Rajendra Kadam', status: 'RENEWED', loanAmount: '₹2,00,000', outstanding: '₹2,18,000', dueDate: '10 Aug 2026', items: 4, daysLeft: 44),
];

class _GirviCardData {
  const _GirviCardData({
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
}

class GirviListPage extends StatefulWidget {
  const GirviListPage({super.key});

  static const routeName = 'girvi-list';

  @override
  State<GirviListPage> createState() => _GirviListPageState();
}

class _GirviListPageState extends State<GirviListPage> {
  final _searchController = TextEditingController();
  String _query = '';
  int _filterIndex = 0;

  static const _statusForFilter = ['', 'ACTIVE', 'PARTIAL_PAID', 'RENEWED', 'REDEEMED', 'OVERDUE'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_GirviCardData> get _filtered {
    final q = _query.toLowerCase();
    final statusKey = _statusForFilter[_filterIndex];
    return _kAllGirvis.where((g) {
      final matchesFilter = statusKey.isEmpty || g.status == statusKey;
      final matchesSearch = q.isEmpty ||
          g.customerName.toLowerCase().contains(q) ||
          g.customerNameEn.toLowerCase().contains(q) ||
          g.serialId.toLowerCase().contains(q);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      bottomNavigationBar: AppBottomNav(
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
      body: SafeArea(
        child: Column(
          children: [
            const _GirviListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchBar(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            _FilterChips(
              selectedIndex: _filterIndex,
              onSelected: (i) => setState(() => _filterIndex = i),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.diamond_outlined, size: 48, color: GirviColors.muted.withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          const BilingualText(
                            en: 'No records found',
                            mr: 'कोणतेही रेकॉर्ड नाही',
                            hi: 'कोई रिकॉर्ड नहीं',
                            style: TextStyle(color: GirviColors.muted, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final d = items[index];
                        return _GirviCard(
                          serialId: d.serialId,
                          customerName: d.customerName,
                          customerNameEn: d.customerNameEn,
                          status: d.status,
                          loanAmount: d.loanAmount,
                          outstanding: d.outstanding,
                          dueDate: d.dueDate,
                          items: d.items,
                          daysLeft: d.daysLeft,
                        );
                      },
                    ),
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
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
      child: Row(
        children: [
          const Expanded(
            child: BilingualText(
              en: 'Girvi List',
              mr: 'गिरवी यादी',
              hi: 'गिरवी सूची',
              style: TextStyle(
                color: GirviColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () => context.goNamed(CreateGirviWizardPage.routeName),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: GirviColors.navy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  BilingualText(
                    en: 'New Girvi',
                    mr: 'नवीन',
                    hi: 'नई',
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
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search customer / serial ID',
        hintStyle: const TextStyle(
          color: GirviColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(Icons.search, color: GirviColors.muted, size: 22),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, val, __) => val.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: GirviColors.muted, size: 20),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : const Icon(Icons.qr_code_scanner, color: GirviColors.muted, size: 22),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GirviColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GirviColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GirviColors.navy, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

class _GirviFilterChipData {
  const _GirviFilterChipData({required this.mr, required this.en, required this.hi});
  final String mr;
  final String en;
  final String hi;
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _labels = [
    _GirviFilterChipData(mr: 'सर्व', en: 'All', hi: 'सभी'),
    _GirviFilterChipData(mr: 'सक्रिय', en: 'Active', hi: 'सक्रिय'),
    _GirviFilterChipData(mr: 'आंशिक पेड', en: 'Partial', hi: 'आंशिक'),
    _GirviFilterChipData(mr: 'नवीनीकृत', en: 'Renewed', hi: 'नवीनीकृत'),
    _GirviFilterChipData(mr: 'मुद्दलपरत', en: 'Redeemed', hi: 'मुक्त'),
    _GirviFilterChipData(mr: 'ओव्हरड्यू', en: 'Overdue', hi: 'अतिदेय'),
  ];

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
          final selected = index == selectedIndex;
          final chip = _labels[index];
          return ChoiceChip(
            label: BilingualText(
              en: chip.en,
              mr: chip.mr,
              hi: chip.hi,
              compact: true,
              style: TextStyle(
                color: selected ? GirviColors.gold : GirviColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            onSelected: (_) => onSelected(index),
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

  ({String mr, String en, String hi}) get _statusLabel {
    switch (status) {
      case 'ACTIVE':
        return (mr: 'सक्रिय', en: 'Active', hi: 'सक्रिय');
      case 'PARTIAL_PAID':
        return (mr: 'आंशिक पेड', en: 'Partial', hi: 'आंशिक भुगतान');
      case 'RENEWED':
        return (mr: 'नवीनीकृत', en: 'Renewed', hi: 'नवीनीकृत');
      case 'REDEEMED':
        return (mr: 'मुद्दलपरत', en: 'Redeemed', hi: 'मुक्त');
      case 'OVERDUE':
        return (mr: 'ओव्हरड्यू', en: 'Overdue', hi: 'अतिदेय');
      default:
        return (mr: status, en: status, hi: status);
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
                          Builder(builder: (context) {
                            final (:mr, :en, :hi) = _statusLabel;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: BilingualText(
                                en: en,
                                mr: mr,
                                hi: hi,
                                compact: true,
                                style: TextStyle(
                                  color: _statusColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
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
                  labelMr: '$items वस्तू',
                  labelEn: '$items Items',
                ),
                const SizedBox(width: 12),
                _DaysLeftChip(daysLeft: daysLeft),
              ],
            ),
            if (status != 'REDEEMED') ...[
              const Divider(height: 22, color: GirviColors.line),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      labelMr: 'पेमेंट',
                      labelEn: 'Pay',
                      color: GirviColors.green,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      labelMr: 'नूतनीकरण',
                      labelEn: 'Renew',
                      color: GirviColors.gold,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      labelMr: 'परतफेड',
                      labelEn: 'Redeem',
                      color: GirviColors.navy,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
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
        BilingualText(
          en: labelEn,
          mr: labelMr,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
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
  const _MetaChip({required this.icon, required this.labelMr, required this.labelEn});

  final IconData icon;
  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: GirviColors.muted),
        const SizedBox(width: 5),
        BilingualText(
          en: labelEn,
          mr: labelMr,
          style: const TextStyle(
            color: GirviColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
    final (mr, en) = isOverdue
        ? ('${-daysLeft} दिवस उशीर', '${-daysLeft} Days Late')
        : daysLeft == 0
        ? ('आज देय', 'Due Today')
        : ('$daysLeft दिवस शिल्लक', '$daysLeft Days Left');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: BilingualText(
        en: en,
        mr: mr,
        compact: true,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.labelMr,
    required this.labelEn,
    required this.color,
    required this.onTap,
  });

  final String labelMr;
  final String labelEn;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: BilingualText(
            en: labelEn,
            mr: labelMr,
            compact: true,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

