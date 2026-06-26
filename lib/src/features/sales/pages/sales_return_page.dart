import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_header.dart';
import '../presentation/bloc/sales_return_bloc.dart';
import '../theme/sales_colors.dart';

/// SCR-056 Sales Return
class SalesReturnPage extends StatelessWidget {
  const SalesReturnPage({super.key});

  static const routeName = 'sales-return';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SalesReturnBloc>(),
      child: BlocListener<SalesReturnBloc, SalesReturnState>(
        listener: (context, state) {
          if (state is SalesReturnSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('परतावा प्रक्रिया यशस्वी / Return processed.'),
                backgroundColor: SalesColors.green,
              ),
            );
            AppNavigation.popOrGoNamed(context, 'sales-dashboard');
          }
          if (state is SalesReturnError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: SalesColors.red,
              ),
            );
          }
        },
        child: const _SalesReturnScaffold(),
      ),
    );
  }
}

class _SalesReturnScaffold extends StatefulWidget {
  const _SalesReturnScaffold();

  @override
  State<_SalesReturnScaffold> createState() => _SalesReturnScaffoldState();
}

class _SalesReturnScaffoldState extends State<_SalesReturnScaffold> {
  final _invoiceCtrl =
      TextEditingController(text: 'INV-2026-000102');
  final _reasonCtrl = TextEditingController();
  String _returnType = 'Full Return';
  String _inventoryStatus = 'Available';

  @override
  void dispose() {
    _invoiceCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalesColors.screenBg,
      body: SafeArea(
        child: BlocBuilder<SalesReturnBloc, SalesReturnState>(
          builder: (context, state) {
            final isSubmitting = state is SalesReturnSubmitting;
            return Column(
              children: [
                AppHeader(
                  titleMr: 'विक्री परतावा',
                  titleEn: 'Sales Return',
                  showBackButton: true,
                  backFallbackRoute: 'sales-dashboard',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(
                            titleMr: 'इन्व्हॉईस शोधा',
                            titleEn: 'Find Invoice'),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _invoiceCtrl,
                                decoration: _inputDecoration(
                                    'इन्व्हॉईस क्र. / Invoice No.'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: state is SalesReturnLookupLoading
                                  ? null
                                  : () => context
                                      .read<SalesReturnBloc>()
                                      .add(SalesReturnInvoiceLookupStarted(
                                        invoiceNo: _invoiceCtrl.text.trim(),
                                      )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SalesColors.navy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                              child: state is SalesReturnLookupLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('शोधा'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(
                            titleMr: 'परतावा प्रकार',
                            titleEn: 'Return Type'),
                        _DropdownField(
                          labelMr: 'परतावा प्रकार',
                          labelEn: 'Return Type',
                          value: _returnType,
                          options: const [
                            'Full Return',
                            'Partial Return',
                            'Exchange',
                          ],
                          onChanged: (v) {
                            if (v != null)
                              setState(() => _returnType = v);
                          },
                        ),
                        if (state is SalesReturnLookupLoaded) ...[
                          const SizedBox(height: 20),
                          _SectionTitle(
                              titleMr: 'वस्तू निवडा',
                              titleEn: 'Select Items'),
                          ...state.order.items.map(
                            (item) => _ReturnItemTile(
                              name: item.name,
                              barcode: item.barcode,
                              price: item.totalAmount,
                              selected: state.selectedItemIds
                                  .contains(item.id),
                              onToggle: () => context
                                  .read<SalesReturnBloc>()
                                  .add(SalesReturnItemToggled(
                                      itemId: item.id)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        _SectionTitle(
                            titleMr: 'परतावा कारण',
                            titleEn: 'Return Reason'),
                        TextField(
                          controller: _reasonCtrl,
                          maxLines: 3,
                          decoration:
                              _inputDecoration('कारण / Reason'),
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(
                            titleMr: 'स्टॉक स्थिती',
                            titleEn: 'Inventory Status'),
                        _DropdownField(
                          labelMr: 'स्टॉक स्थिती',
                          labelEn: 'Inventory Status',
                          value: _inventoryStatus,
                          options: const [
                            'Available',
                            'Damaged',
                            'Repair',
                          ],
                          onChanged: (v) {
                            if (v != null)
                              setState(() => _inventoryStatus = v);
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
                              Icon(Icons.info_outline,
                                  color: SalesColors.navy),
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
                    border:
                        Border(top: BorderSide(color: SalesColors.line)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => AppNavigation.popOrGoNamed(
                              context, 'sales-dashboard'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: SalesColors.navy,
                            side: const BorderSide(
                                color: SalesColors.navy),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
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
                          onPressed: isSubmitting ||
                                  state is! SalesReturnLookupLoaded
                              ? null
                              : () => context.read<SalesReturnBloc>().add(
                                    SalesReturnSubmitted(
                                      reason: _reasonCtrl.text.trim(),
                                      returnType: _returnType,
                                      inventoryStatus: _inventoryStatus,
                                    ),
                                  ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SalesColors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('परतावा / Return'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
        borderSide:
            const BorderSide(color: SalesColors.navy, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class _ReturnItemTile extends StatelessWidget {
  const _ReturnItemTile({
    required this.name,
    required this.barcode,
    required this.price,
    required this.selected,
    required this.onToggle,
  });

  final String name;
  final String barcode;
  final double price;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? SalesColors.navy : SalesColors.line,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            activeColor: SalesColors.navy,
            onChanged: (_) => onToggle(),
          ),
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
            '₹${amtFmt.format(price)}',
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
          borderSide:
              const BorderSide(color: SalesColors.navy, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      items: options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
