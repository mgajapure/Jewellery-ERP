import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/purchase_colors.dart';

/// SCR-060 Supplier Management
///
/// Lists suppliers and provides search/add actions.
class SupplierManagementPage extends StatelessWidget {
  const SupplierManagementPage({super.key});

  static const routeName = 'suppliers';

  final List<Map<String, dynamic>> _suppliers = const [
    {
      'name': 'Ramesh Jewellers',
      'mobile': '+91 98765 43210',
      'gst': '27ABCDE1234F1Z5',
      'balance': '₹ 1,25,000',
      'status': 'Active',
    },
    {
      'name': 'Shree Gold House',
      'mobile': '+91 91234 56789',
      'gst': '27FGHIJ5678K2L6',
      'balance': '₹ 45,000',
      'status': 'Active',
    },
    {
      'name': 'Mumbai Bullion Traders',
      'mobile': '+91 99887 77665',
      'gst': '27KLMNO9012P3Q7',
      'balance': '₹ 0',
      'status': 'Inactive',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      appBar: AppBar(
        backgroundColor: PurchaseColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'पुरवठादार व्यवस्थापन',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Supplier Management',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: add supplier.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'पुरवठादार शोधा / Search supplier',
                  prefixIcon: const Icon(Icons.search, color: PurchaseColors.muted),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PurchaseColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PurchaseColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: PurchaseColors.navy, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suppliers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final supplier = _suppliers[index];
                  return _SupplierCard(
                    name: supplier['name'] as String,
                    mobile: supplier['mobile'] as String,
                    gst: supplier['gst'] as String,
                    balance: supplier['balance'] as String,
                    status: supplier['status'] as String,
                    onTap: () {
                      // TODO: supplier detail.
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PurchaseColors.navy,
        foregroundColor: Colors.white,
        onPressed: () {
          // TODO: add supplier.
        },
        child: const Icon(Icons.person_add_alt_1),
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
    required this.onTap,
  });

  final String name;
  final String mobile;
  final String gst;
  final String balance;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PurchaseColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: PurchaseColors.ink,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? PurchaseColors.green.withAlpha(20) : PurchaseColors.muted.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? PurchaseColors.green : PurchaseColors.muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(icon: Icons.phone_outlined, value: mobile),
            _InfoRow(icon: Icons.numbers_outlined, value: gst),
            const Divider(height: 20, color: PurchaseColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'येणे बाकी / Balance Due',
                  style: TextStyle(
                    fontSize: 12,
                    color: PurchaseColors.muted,
                  ),
                ),
                Text(
                  balance,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: PurchaseColors.navy,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: PurchaseColors.muted),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: PurchaseColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
