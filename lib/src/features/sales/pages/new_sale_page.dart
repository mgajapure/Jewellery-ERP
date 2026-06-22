import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/sales_colors.dart';

/// SCR-053 New Sale
///
/// Creates a customer invoice by selecting customer, adding items,
/// applying discounts, calculating GST, and choosing payment mode.
class NewSalePage extends StatefulWidget {
  const NewSalePage({super.key});

  static const routeName = 'new-sale';

  @override
  State<NewSalePage> createState() => _NewSalePageState();
}

class _NewSalePageState extends State<NewSalePage> {
  final _customerController = TextEditingController();
  final _discountController = TextEditingController();

  String _customerType = 'Existing Customer';
  String _paymentMode = 'Cash';

  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Gold Chain 22K',
      'barcode': 'ITM-1001',
      'weight': '24.50 g',
      'purity': '91.6%',
      'price': 125000.0,
    },
    {
      'name': 'Gold Ring 22K',
      'barcode': 'ITM-1002',
      'weight': '8.20 g',
      'purity': '91.6%',
      'price': 42000.0,
    },
  ];

  double get _subtotal => _items.fold<double>(0, (sum, item) => sum + (item['price'] as double));

  double get _discount => double.tryParse(_discountController.text) ?? 0;

  double get _taxable => _subtotal - _discount;

  double get _cgst => _taxable * 0.015;

  double get _sgst => _taxable * 0.015;

  double get _total => _taxable + _cgst + _sgst;

  void _previewInvoice() {
    context.goNamed('invoice-preview');
  }

  @override
  void dispose() {
    _customerController.dispose();
    _discountController.dispose();
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
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'नवीन विक्री',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'New Sale',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(titleMr: 'ग्राहक तपशील', titleEn: 'Customer Details'),
                    _DropdownField(
                      labelMr: 'ग्राहक प्रकार',
                      labelEn: 'Customer Type',
                      value: _customerType,
                      options: const ['Existing Customer', 'Walk-in Customer', 'New Customer'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _customerType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customerController,
                      decoration: _inputDecoration('ग्राहक शोधा / Search Customer'),
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'वस्तू', titleEn: 'Items'),
                    ..._items.map((item) => _ItemTile(item: item)),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: add item by inventory/barcode.
                      },
                      icon: const Icon(Icons.add, color: SalesColors.navy),
                      label: const Text(
                        'वस्तू जोडा / Add Item',
                        style: TextStyle(color: SalesColors.navy),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: SalesColors.navy),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'ऑफर', titleEn: 'Offers'),
                    TextField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration('सूट (₹) / Discount (₹)'),
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'पेमेंट पद्धत', titleEn: 'Payment Mode'),
                    _DropdownField(
                      labelMr: 'पेमेंट पद्धत',
                      labelEn: 'Payment Mode',
                      value: _paymentMode,
                      options: const ['Cash', 'UPI', 'Bank Transfer', 'Card', 'Split Payment'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _paymentMode = value);
                        }
                      },
                    ),
                  ],
                ),
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
                  _TotalRow(labelMr: 'एकूण', labelEn: 'Subtotal', value: '₹ ${_subtotal.toStringAsFixed(0)}'),
                  _TotalRow(labelMr: 'सूट', labelEn: 'Discount', value: '- ₹ ${_discount.toStringAsFixed(0)}'),
                  _TotalRow(labelMr: 'CGST 1.5%', labelEn: 'CGST', value: '₹ ${_cgst.toStringAsFixed(0)}'),
                  _TotalRow(labelMr: 'SGST 1.5%', labelEn: 'SGST', value: '₹ ${_sgst.toStringAsFixed(0)}'),
                  const Divider(color: SalesColors.line),
                  _TotalRow(
                    labelMr: 'एकूण देय',
                    labelEn: 'Total Due',
                    value: '₹ ${_total.toStringAsFixed(0)}',
                    bold: true,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _previewInvoice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SalesColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('इन्व्हॉईस पूर्वावलोकन / Preview Invoice'),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SalesColors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SalesColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['barcode']} • ${item['weight']} • ${item['purity']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹ ${(item['price'] as double).toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SalesColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: SalesColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$titleMr / $titleEn',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: SalesColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: '$labelMr / $labelEn',
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
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    this.bold = false,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: TextStyle(
              fontSize: bold ? 14 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: SalesColors.ink,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 16 : 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: SalesColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
