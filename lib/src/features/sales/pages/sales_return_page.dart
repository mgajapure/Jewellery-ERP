import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/sales_colors.dart';
import 'sales_dashboard_page.dart';

/// SCR-056 Sales Return
///
/// Process full, partial, or exchange returns against an invoice.
class SalesReturnPage extends StatefulWidget {
  const SalesReturnPage({super.key});

  static const routeName = 'sales-return';

  @override
  State<SalesReturnPage> createState() => _SalesReturnPageState();
}

class _SalesReturnPageState extends State<SalesReturnPage> {
  final _invoiceController = TextEditingController(text: 'INV-2026-000102');
  final _reasonController = TextEditingController();

  String _returnType = 'Full Return';
  String _inventoryStatus = 'Available';
  final bool _managerApproved = false;

  final List<Map<String, dynamic>> _invoiceItems = const [
    {'name': 'Gold Chain 22K', 'barcode': 'ITM-1001', 'price': '₹ 1,28,750'},
    {'name': 'Gold Ring 22K', 'barcode': 'ITM-1002', 'price': '₹ 43,260'},
  ];

  @override
  void dispose() {
    _invoiceController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _processReturn() {
    // TODO: integrate return API.
    AppNavigation.popOrGoNamed(context, SalesDashboardPage.routeName);
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
              'विक्री परतावा',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Sales Return',
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
                    _SectionTitle(titleMr: 'इन्व्हॉईस शोधा', titleEn: 'Find Invoice'),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _invoiceController,
                            decoration: _inputDecoration('इन्व्हॉईस क्र. / Invoice No.'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: fetch invoice.
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SalesColors.navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('शोधा'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'परतावा प्रकार', titleEn: 'Return Type'),
                    _DropdownField(
                      labelMr: 'परतावा प्रकार',
                      labelEn: 'Return Type',
                      value: _returnType,
                      options: const ['Full Return', 'Partial Return', 'Exchange'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _returnType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'वस्तू निवडा', titleEn: 'Select Items'),
                    ..._invoiceItems.map((item) => _ReturnItemTile(item: item)),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'परतावा कारण', titleEn: 'Return Reason'),
                    TextField(
                      controller: _reasonController,
                      maxLines: 3,
                      decoration: _inputDecoration('कारण / Reason'),
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(titleMr: 'स्टॉक स्थिती', titleEn: 'Inventory Status'),
                    _DropdownField(
                      labelMr: 'स्टॉक स्थिती',
                      labelEn: 'Inventory Status',
                      value: _inventoryStatus,
                      options: const ['Available', 'Damaged', 'Repair'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _inventoryStatus = value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: SalesColors.cream,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: SalesColors.navy),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'महत्त्वाचे / Important: Returns above the configured threshold require manager approval.',
                              style: TextStyle(
                                fontSize: 12,
                                color: SalesColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => AppNavigation.popOrGoNamed(
                        context,
                        SalesDashboardPage.routeName,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SalesColors.navy,
                        side: const BorderSide(color: SalesColors.navy),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('रद्द / Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _processReturn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SalesColors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('परतावा / Return'),
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

class _ReturnItemTile extends StatefulWidget {
  const _ReturnItemTile({required this.item});

  final Map<String, dynamic> item;

  @override
  State<_ReturnItemTile> createState() => _ReturnItemTileState();
}

class _ReturnItemTileState extends State<_ReturnItemTile> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _selected ? SalesColors.navy : SalesColors.line),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _selected,
            activeColor: SalesColors.navy,
            onChanged: (value) => setState(() => _selected = value ?? false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SalesColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.item['barcode']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.item['price'] as String,
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
