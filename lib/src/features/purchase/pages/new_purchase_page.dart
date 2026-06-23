import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/purchase_entry.dart';
import '../presentation/bloc/new_purchase_bloc.dart';
import '../theme/purchase_colors.dart';
import 'purchase_dashboard_page.dart';

/// SCR-058 New Purchase Entry
class NewPurchasePage extends StatelessWidget {
  const NewPurchasePage({super.key});

  static const routeName = 'new-purchase';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<NewPurchaseBloc>(),
      child: const _NewPurchaseView(),
    );
  }
}

class _NewPurchaseView extends StatefulWidget {
  const _NewPurchaseView();

  @override
  State<_NewPurchaseView> createState() => _NewPurchaseViewState();
}

class _NewPurchaseViewState extends State<_NewPurchaseView> {
  final _formKey = GlobalKey<FormState>();
  final _supplierNameCtrl = TextEditingController();
  final _supplierMobileCtrl = TextEditingController();
  final _billNoCtrl = TextEditingController();
  final _itemNameCtrl = TextEditingController();
  final _grossWeightCtrl = TextEditingController();
  final _netWeightCtrl = TextEditingController();
  final _purityCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  PurchaseType _purchaseType = PurchaseType.newInventory;
  MetalType _metalType = MetalType.gold22k;
  PaymentMode _paymentMode = PaymentMode.cash;

  @override
  void dispose() {
    _supplierNameCtrl.dispose();
    _supplierMobileCtrl.dispose();
    _billNoCtrl.dispose();
    _itemNameCtrl.dispose();
    _grossWeightCtrl.dispose();
    _netWeightCtrl.dispose();
    _purityCtrl.dispose();
    _rateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<NewPurchaseBloc>().add(
          NewPurchaseSubmitted(
            supplierName: _supplierNameCtrl.text.trim(),
            supplierMobile: _supplierMobileCtrl.text.trim(),
            billNo: _billNoCtrl.text.trim(),
            purchaseType: _purchaseType,
            metalType: _metalType,
            itemName: _itemNameCtrl.text.trim(),
            grossWeight:
                double.tryParse(_grossWeightCtrl.text.trim()) ?? 0.0,
            netWeight:
                double.tryParse(_netWeightCtrl.text.trim()) ?? 0.0,
            purity: double.tryParse(_purityCtrl.text.trim()) ?? 0.0,
            rate: double.tryParse(_rateCtrl.text.trim()) ?? 0.0,
            amount: double.tryParse(_amountCtrl.text.trim()) ?? 0.0,
            paymentMode: _paymentMode,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewPurchaseBloc, NewPurchaseState>(
      listener: (context, state) {
        if (state is NewPurchaseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('खरेदी नोंद यशस्वीरित्या जतन केली / Purchase saved'),
              backgroundColor: PurchaseColors.green,
            ),
          );
          AppNavigation.popOrGoNamed(
              context, PurchaseDashboardPage.routeName);
        } else if (state is NewPurchaseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: PurchaseColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: PurchaseColors.screenBg,
        appBar: AppBar(
          backgroundColor: PurchaseColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => AppNavigation.popOrGoNamed(
              context,
              PurchaseDashboardPage.routeName,
            ),
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
                style: TextStyle(fontSize: 12, color: Colors.white70),
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
                _SectionTitle(
                    titleMr: 'खरेदीचा तपशील',
                    titleEn: 'Purchase Details'),
                _DropdownField<PurchaseType>(
                  labelMr: 'खरेदी प्रकार',
                  labelEn: 'Purchase Type',
                  value: _purchaseType,
                  items: PurchaseType.values,
                  labelFor: (t) => '${t.labelMr} / ${t.labelEn}',
                  onChanged: (v) {
                    if (v != null) setState(() => _purchaseType = v);
                  },
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _billNoCtrl,
                  labelMr: 'बिल क्र.',
                  labelEn: 'Bill No.',
                  keyboardType: TextInputType.text,
                  validator: _required,
                ),
                const SizedBox(height: 20),
                _SectionTitle(
                    titleMr: 'पुरवठादार तपशील',
                    titleEn: 'Supplier Details'),
                _InputField(
                  controller: _supplierNameCtrl,
                  labelMr: 'पुरवठादाराचे नाव',
                  labelEn: 'Supplier Name',
                  keyboardType: TextInputType.name,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _supplierMobileCtrl,
                  labelMr: 'मोबाईल क्र.',
                  labelEn: 'Mobile No.',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _required,
                ),
                const SizedBox(height: 20),
                _SectionTitle(
                    titleMr: 'वस्तू तपशील', titleEn: 'Item Details'),
                _DropdownField<MetalType>(
                  labelMr: 'धातू प्रकार',
                  labelEn: 'Metal Type',
                  value: _metalType,
                  items: MetalType.values,
                  labelFor: (t) => '${t.labelMr} / ${t.labelEn}',
                  onChanged: (v) {
                    if (v != null) setState(() => _metalType = v);
                  },
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _itemNameCtrl,
                  labelMr: 'वस्तूचे नाव',
                  labelEn: 'Item Name',
                  keyboardType: TextInputType.text,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _InputField(
                        controller: _grossWeightCtrl,
                        labelMr: 'ग्रॉस वजन',
                        labelEn: 'Gross Wt (g)',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'))
                        ],
                        validator: _requiredNumber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InputField(
                        controller: _netWeightCtrl,
                        labelMr: 'नेट वजन',
                        labelEn: 'Net Wt (g)',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'))
                        ],
                        validator: _requiredNumber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _InputField(
                        controller: _purityCtrl,
                        labelMr: 'शुद्धता %',
                        labelEn: 'Purity %',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'))
                        ],
                        validator: _requiredNumber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InputField(
                        controller: _rateCtrl,
                        labelMr: 'दर',
                        labelEn: 'Rate (₹/g)',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'))
                        ],
                        validator: _requiredNumber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _amountCtrl,
                  labelMr: 'रक्कम',
                  labelEn: 'Amount (₹)',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  validator: _requiredNumber,
                ),
                const SizedBox(height: 20),
                _SectionTitle(
                    titleMr: 'पेमेंट तपशील', titleEn: 'Payment Details'),
                _DropdownField<PaymentMode>(
                  labelMr: 'पेमेंट पद्धत',
                  labelEn: 'Payment Mode',
                  value: _paymentMode,
                  items: PaymentMode.values,
                  labelFor: (m) => '${m.labelMr} / ${m.labelEn}',
                  onChanged: (v) {
                    if (v != null) setState(() => _paymentMode = v);
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<NewPurchaseBloc, NewPurchaseState>(
                  builder: (context, state) {
                    final isSubmitting = state is NewPurchaseSubmitting;
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSubmitting
                                ? null
                                : () => AppNavigation.popOrGoNamed(
                                      context,
                                      PurchaseDashboardPage.routeName,
                                    ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PurchaseColors.navy,
                              side: const BorderSide(
                                  color: PurchaseColors.navy),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
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
                            onPressed: isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PurchaseColors.navy,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('जतन करा / Save'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'हे क्षेत्र आवश्यक आहे / Required' : null;

  String? _requiredNumber(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'हे क्षेत्र आवश्यक आहे / Required';
    }
    if (double.tryParse(v.trim()) == null) {
      return 'मान्य क्रमांक प्रविष्ट करा / Enter valid number';
    }
    return null;
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

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.labelMr,
    required this.labelEn,
    required this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String labelMr;
  final String labelEn;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
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
          borderSide:
              const BorderSide(color: PurchaseColors.navy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PurchaseColors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.items,
    required this.labelFor,
    required this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final T value;
  final List<T> items;
  final String Function(T) labelFor;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
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
          borderSide:
              const BorderSide(color: PurchaseColors.navy, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(labelFor(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
