import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/sales_colors.dart';
import 'sales_dashboard_page.dart';

/// SCR-081 Barcode Sales Screen
///
/// Fast counter sales via barcode scanning.
class BarcodeSalePage extends StatefulWidget {
  const BarcodeSalePage({super.key});

  static const routeName = 'barcode-sale';

  @override
  State<BarcodeSalePage> createState() => _BarcodeSalePageState();
}

class _BarcodeSalePageState extends State<BarcodeSalePage> {
  final _barcodeController = TextEditingController();

  final List<Map<String, dynamic>> _cart = [
    {
      'name': 'Gold Chain 22K',
      'barcode': 'ITM-1001',
      'price': 128750.0,
    },
  ];

  double get _total => _cart.fold<double>(0, (sum, item) => sum + (item['price'] as double));

  void _scan() {
    // TODO: trigger barcode scanner.
  }

  void _checkout() {
    context.goNamed('invoice-preview');
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalesColors.screenBg,
      appBar: AppBar(
        backgroundColor: SalesColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            SalesDashboardPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'बारकोड विक्री',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Barcode Sale',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        hintText: 'बारकोड स्कॅन करा / Scan Barcode',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: SalesColors.line),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: SalesColors.line),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: SalesColors.navy, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _scan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SalesColors.navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _cart.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = _cart[index];
                  return _CartItemTile(
                    name: item['name'] as String,
                    barcode: item['barcode'] as String,
                    price: item['price'] as double,
                    onDelete: () {
                      // TODO: remove item.
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: SalesColors.line)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'एकूण / Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: SalesColors.ink,
                        ),
                      ),
                      Text(
                        '₹ ${_total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: SalesColors.navy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SalesColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('चेकआउट / Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.name,
    required this.barcode,
    required this.price,
    required this.onDelete,
  });

  final String name;
  final String barcode;
  final double price;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SalesColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SalesColors.navy.withAlpha(10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code, color: SalesColors.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SalesColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  barcode,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹ ${price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: SalesColors.navy,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: SalesColors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
