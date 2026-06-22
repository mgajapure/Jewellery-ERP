import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/purchase_colors.dart';

/// SCR-058 New Purchase Entry
///
/// Form to create a purchase, supporting gold items, scrap, supplier details,
/// rates, and payment mode.
class NewPurchasePage extends StatefulWidget {
  const NewPurchasePage({super.key});

  static const routeName = 'new-purchase';

  @override
  State<NewPurchasePage> createState() => _NewPurchasePageState();
}

class _NewPurchasePageState extends State<NewPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _supplierMobileController = TextEditingController();
  final _billNoController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _grossWeightController = TextEditingController();
  final _netWeightController = TextEditingController();
  final _purityController = TextEditingController();
  final _rateController = TextEditingController();
  final _amountController = TextEditingController();

  String _purchaseType = 'New Inventory';
  String _paymentMode = 'Cash';
  String _metalType = 'Gold 22K';
  final bool _gstIncluded = false;

  @override
  void dispose() {
    _supplierNameController.dispose();
    _supplierMobileController.dispose();
    _billNoController.dispose();
    _itemNameController.dispose();
    _grossWeightController.dispose();
    _netWeightController.dispose();
    _purityController.dispose();
    _rateController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: integrate purchase creation API.
      context.pop();
    }
  }

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
              'नवीन खरेदी नोंद',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'New Purchase Entry',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle(titleMr: 'खरेदीचा तपशील', titleEn: 'Purchase Details'),
              _DropdownField(
                labelMr: 'खरेदी प्रकार',
                labelEn: 'Purchase Type',
                value: _purchaseType,
                options: const ['New Inventory', 'Scrap', 'Bullion'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _purchaseType = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              _TextField(
                controller: _billNoController,
                labelMr: 'बिल क्र.',
                labelEn: 'Bill No.',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'पुरवठादार तपशील', titleEn: 'Supplier Details'),
              _TextField(
                controller: _supplierNameController,
                labelMr: 'पुरवठादाराचे नाव',
                labelEn: 'Supplier Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),
              _TextField(
                controller: _supplierMobileController,
                labelMr: 'मोबाईल क्र.',
                labelEn: 'Mobile No.',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'वस्तू तपशील', titleEn: 'Item Details'),
              _DropdownField(
                labelMr: 'धातू प्रकार',
                labelEn: 'Metal Type',
                value: _metalType,
                options: const ['Gold 24K', 'Gold 22K', 'Gold 18K', 'Silver'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _metalType = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              _TextField(
                controller: _itemNameController,
                labelMr: 'वस्तूचे नाव',
                labelEn: 'Item Name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TextField(
                      controller: _grossWeightController,
                      labelMr: 'ग्रॉस वजन',
                      labelEn: 'Gross Wt (g)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TextField(
                      controller: _netWeightController,
                      labelMr: 'नेट वजन',
                      labelEn: 'Net Wt (g)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TextField(
                      controller: _purityController,
                      labelMr: 'शुद्धता %',
                      labelEn: 'Purity %',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TextField(
                      controller: _rateController,
                      labelMr: 'दर',
                      labelEn: 'Rate (₹/g)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _TextField(
                controller: _amountController,
                labelMr: 'रक्कम',
                labelEn: 'Amount (₹)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _SectionTitle(titleMr: 'पेमेंट तपशील', titleEn: 'Payment Details'),
              _DropdownField(
                labelMr: 'पेमेंट पद्धत',
                labelEn: 'Payment Mode',
                value: _paymentMode,
                options: const ['Cash', 'Bank Transfer', 'Cheque', 'Credit'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _paymentMode = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PurchaseColors.navy,
                        side: const BorderSide(color: PurchaseColors.navy),
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
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PurchaseColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('जतन करा / Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              color: PurchaseColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$titleMr / $titleEn',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: PurchaseColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.labelMr,
    required this.labelEn,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String labelMr;
  final String labelEn;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: '$labelMr / $labelEn',
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
