import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/navigation/app_navigation.dart';
import '../presentation/bloc/add_inventory_bloc.dart';
import '../theme/inventory_colors.dart';

/// SCR-050 Add New Inventory Item
class AddInventoryItemPage extends StatelessWidget {
  const AddInventoryItemPage({super.key});

  static const routeName = 'inventory-add';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AddInventoryBloc>(),
      child: const _AddInventoryScaffold(),
    );
  }
}

class _AddInventoryScaffold extends StatefulWidget {
  const _AddInventoryScaffold();

  @override
  State<_AddInventoryScaffold> createState() => _AddInventoryScaffoldState();
}

class _AddInventoryScaffoldState extends State<_AddInventoryScaffold> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _grossWeightCtrl = TextEditingController();
  final _netWeightCtrl = TextEditingController();
  final _makingChargesCtrl = TextEditingController();
  final _costPriceCtrl = TextEditingController();
  final _sellingPriceCtrl = TextEditingController();

  String _category = 'Gold Jewellery';
  String _metalType = 'Gold';
  String _purity = '22K';

  static const _categories = [
    'Gold Jewellery',
    'Silver Jewellery',
    'Diamond Jewellery',
    'Platinum Jewellery',
    'Other',
  ];

  static const _metalTypes = ['Gold', 'Silver', 'Platinum', 'Diamond'];

  static const _purities = [
    ('22K', 91.67),
    ('18K', 75.0),
    ('14K', 58.33),
    ('24K', 99.9),
    ('925', 92.5),
    ('950', 95.0),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _grossWeightCtrl.dispose();
    _netWeightCtrl.dispose();
    _makingChargesCtrl.dispose();
    _costPriceCtrl.dispose();
    _sellingPriceCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final purityEntry =
        _purities.firstWhere((p) => p.$1 == _purity, orElse: () => ('22K', 91.67));
    context.read<AddInventoryBloc>().add(
          AddInventorySubmitted(
            payload: {
              'name': _nameCtrl.text.trim(),
              'category': _category,
              'description': _descCtrl.text.trim(),
              'metalType': _metalType,
              'purity': _purity,
              'purityValue': purityEntry.$2,
              'grossWeight': double.tryParse(_grossWeightCtrl.text) ?? 0.0,
              'netWeight': double.tryParse(_netWeightCtrl.text) ?? 0.0,
              'makingCharges':
                  double.tryParse(_makingChargesCtrl.text) ?? 0.0,
              'costPrice': double.tryParse(_costPriceCtrl.text) ?? 0.0,
              'sellingPrice': double.tryParse(_sellingPriceCtrl.text) ?? 0.0,
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddInventoryBloc, AddInventoryState>(
      listener: (context, state) {
        if (state is AddInventorySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('वस्तू यशस्वीरीत्या जोडली! / Item added successfully!'),
              backgroundColor: InventoryColors.green,
            ),
          );
          AppNavigation.popOrGoNamed(context, 'inventory-list');
        }
        if (state is AddInventoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: InventoryColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: InventoryColors.screenBg,
        appBar: AppBar(
          backgroundColor: InventoryColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                AppNavigation.popOrGoNamed(context, 'inventory-list'),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'नवीन वस्तू जोडा',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Add New Item',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('मूळ माहिती', 'Basic Information'),
                  _buildField(
                    ctrl: _nameCtrl,
                    label: 'वस्तूचे नाव / Item Name',
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'श्रेणी / Category',
                    value: _category,
                    items: _categories,
                    labelFor: (v) => v,
                    onChanged: (v) =>
                        setState(() => _category = v ?? _category),
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    ctrl: _descCtrl,
                    label: 'वर्णन / Description',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('दागिने तपशील', 'Jewellery Details'),
                  _buildDropdown<String>(
                    label: 'धातू प्रकार / Metal Type',
                    value: _metalType,
                    items: _metalTypes,
                    labelFor: (v) => v,
                    onChanged: (v) =>
                        setState(() => _metalType = v ?? _metalType),
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown<String>(
                    label: 'शुद्धता / Purity',
                    value: _purity,
                    items: _purities.map((p) => p.$1).toList(),
                    labelFor: (v) => v,
                    onChanged: (v) =>
                        setState(() => _purity = v ?? _purity),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          ctrl: _grossWeightCtrl,
                          label: 'एकूण वजन (g)',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[\d.]'))
                          ],
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildField(
                          ctrl: _netWeightCtrl,
                          label: 'निव्वळ वजन (g)',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[\d.]'))
                          ],
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('किंमत', 'Pricing'),
                  _buildField(
                    ctrl: _makingChargesCtrl,
                    label: 'घडणावळ (₹) / Making Charges (₹)',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    ctrl: _costPriceCtrl,
                    label: 'खरेदी किंमत (₹) / Cost Price (₹)',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
                    ],
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  _buildField(
                    ctrl: _sellingPriceCtrl,
                    label: 'विक्री किंमत (₹) / Selling Price (₹)',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))
                    ],
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<AddInventoryBloc, AddInventoryState>(
                    builder: (context, state) {
                      final isLoading = state is AddInventoryLoading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: InventoryColors.navy,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'जोडा / Add Item',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String mr, String en) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: InventoryColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$mr / $en',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: InventoryColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController ctrl,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: _inputDecoration(label),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelFor,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(label),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(labelFor(item)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: InventoryColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: InventoryColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: InventoryColors.navy, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: InventoryColors.red),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
