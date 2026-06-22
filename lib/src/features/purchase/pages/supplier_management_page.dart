import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_header.dart';
import '../theme/purchase_colors.dart';
import 'purchase_dashboard_page.dart';

/// SCR-060 Supplier Management
///
/// Lists suppliers and provides search/add actions.
class SupplierManagementPage extends StatefulWidget {
  const SupplierManagementPage({super.key});

  static const routeName = 'suppliers';

  @override
  State<SupplierManagementPage> createState() =>
      _SupplierManagementPageState();
}

class _SupplierManagementPageState extends State<SupplierManagementPage> {
  String _filter = 'सर्व / All';

  final List<String> _filters = const [
    'सर्व / All',
    'सक्रिय / Active',
    'निष्क्रिय / Inactive',
  ];

  final List<Map<String, dynamic>> _suppliers = const [
    {
      'name': 'Ramesh Jewellers',
      'mobile': '+91 98765 43210',
      'gst': '27ABCDE1234F1Z5',
      'balance': '₹1,25,000',
      'status': 'Active',
    },
    {
      'name': 'Shree Gold House',
      'mobile': '+91 91234 56789',
      'gst': '27FGHIJ5678K2L6',
      'balance': '₹45,000',
      'status': 'Active',
    },
    {
      'name': 'Mumbai Bullion Traders',
      'mobile': '+91 99887 77665',
      'gst': '27KLMNO9012P3Q7',
      'balance': '₹0',
      'status': 'Inactive',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'पुरवठादार यादी',
              titleEn: 'Suppliers',
              showBackButton: true,
              backFallbackRoute: PurchaseDashboardPage.routeName,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: PurchaseColors.ink),
                  tooltip: 'नवीन पुरवठादार / New Supplier',
                  onPressed: () {
                    // TODO: add supplier.
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchBar(),
            ),
            _FilterChips(
              filters: _filters,
              selected: _filter,
              onSelected: (filter) => setState(() => _filter = filter),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: _suppliers
                    .map((supplier) => _SupplierCard(
                          name: supplier['name'] as String,
                          mobile: supplier['mobile'] as String,
                          gst: supplier['gst'] as String,
                          balance: supplier['balance'] as String,
                          status: supplier['status'] as String,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
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
        border: Border.all(color: PurchaseColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: PurchaseColors.muted, size: 22),
          SizedBox(width: 12),
          Text(
            'पुरवठादार शोधा / Search supplier',
            style: TextStyle(
              color: PurchaseColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selected;
          return ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                color: isSelected ? PurchaseColors.gold : PurchaseColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(filter),
            selectedColor: PurchaseColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? PurchaseColors.navy : PurchaseColors.line,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({
    required this.name,
    required this.mobile,
    required this.gst,
    required this.balance,
    required this.status,
  });

  final String name;
  final String mobile;
  final String gst;
  final String balance;
  final String status;

  Color get _statusColor {
    return status == 'Active' ? PurchaseColors.green : PurchaseColors.muted;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: supplier detail.
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PurchaseColors.line),
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
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: PurchaseColors.ink,
                    ),
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
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.phone_outlined, value: mobile),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.numbers_outlined, value: gst),
            const Divider(height: 22, color: PurchaseColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _SummaryItem(
                  labelMr: 'येणे बाकी',
                  labelEn: 'Balance Due',
                ),
                Text(
                  balance,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.ink,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PurchaseColors.muted),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: PurchaseColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.labelMr, required this.labelEn});

  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
