import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../inventory/domain/entities/inventory_item.dart';
import '../../inventory/presentation/bloc/inventory_list_bloc.dart';
import '../domain/entities/sale_order.dart';
import '../presentation/bloc/new_sale_bloc.dart';
import '../theme/sales_colors.dart';

/// SCR-053 New Sale
class NewSalePage extends StatelessWidget {
  const NewSalePage({super.key});

  static const routeName = 'new-sale';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<NewSaleBloc>(),
      child: BlocListener<NewSaleBloc, NewSaleState>(
        listener: (context, state) {
          if (state is NewSaleSuccess) {
            context.goNamed('invoice-preview', extra: state.order);
          }
          if (state is NewSaleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: SalesColors.red,
              ),
            );
          }
        },
        child: const _NewSaleScaffold(),
      ),
    );
  }
}

class _NewSaleScaffold extends StatefulWidget {
  const _NewSaleScaffold();

  @override
  State<_NewSaleScaffold> createState() => _NewSaleScaffoldState();
}

class _NewSaleScaffoldState extends State<_NewSaleScaffold> {
  final _discountCtrl = TextEditingController();

  @override
  void dispose() {
    _discountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalesColors.screenBg,
      body: SafeArea(
        child: BlocBuilder<NewSaleBloc, NewSaleState>(
          builder: (context, state) {
            final cart = state is NewSaleCartState
                ? state
                : NewSaleCartState(
                    items: const [],
                    discount: 0,
                    paymentMode: SalePaymentMode.cash,
                    customerId: 'walk-in',
                    customerName: 'Walk-in Customer',
                    customerMobile: '',
                  );
            final isSubmitting = state is NewSaleSubmitting;
            return Column(
              children: [
                AppHeader(
                  titleMr: 'नवीन विक्री',
                  titleEn: 'New Sale',
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
                            titleMr: 'ग्राहक तपशील',
                            titleEn: 'Customer Details'),
                        _DropdownField<String>(
                          labelMr: 'ग्राहक प्रकार',
                          labelEn: 'Customer Type',
                          value: cart.customerName,
                          items: const [
                            'Walk-in Customer',
                            'Existing Customer',
                            'New Customer',
                          ],
                          labelFor: (v) => v,
                          onChanged: (v) {
                            if (v != null) {
                              context.read<NewSaleBloc>().add(
                                    NewSaleCustomerChanged(
                                      customerId: v == 'Existing Customer'
                                          ? 'cust-001'
                                          : 'walk-in',
                                      customerName: v,
                                      customerMobile: '',
                                    ),
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(
                            titleMr: 'वस्तू', titleEn: 'Items'),
                        ...cart.items.map(
                          (item) => _ItemTile(
                            item: item,
                            onRemove: () => context
                                .read<NewSaleBloc>()
                                .add(NewSaleItemRemoved(itemId: item.id)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () =>
                              _showInventoryPicker(context),
                          icon: const Icon(Icons.add,
                              color: SalesColors.navy),
                          label: const Text(
                            'वस्तू जोडा / Add Item',
                            style: TextStyle(color: SalesColors.navy),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: SalesColors.navy),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(
                            titleMr: 'ऑफर', titleEn: 'Offers'),
                        TextField(
                          controller: _discountCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[\d.]')),
                          ],
                          onChanged: (v) {
                            final d = double.tryParse(v) ?? 0;
                            context
                                .read<NewSaleBloc>()
                                .add(NewSaleDiscountChanged(discount: d));
                          },
                          decoration: _inputDecoration(
                              'सूट (₹) / Discount (₹)'),
                        ),
                        const SizedBox(height: 20),
                        _SectionTitle(
                            titleMr: 'पेमेंट पद्धत',
                            titleEn: 'Payment Mode'),
                        _DropdownField<SalePaymentMode>(
                          labelMr: 'पेमेंट पद्धत',
                          labelEn: 'Payment Mode',
                          value: cart.paymentMode,
                          items: SalePaymentMode.values,
                          labelFor: (m) =>
                              '${m.labelMr} / ${m.labelEn}',
                          onChanged: (m) {
                            if (m != null) {
                              context.read<NewSaleBloc>().add(
                                    NewSalePaymentModeChanged(mode: m),
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _TotalPanel(
                  cart: cart,
                  isSubmitting: isSubmitting,
                  onSubmit: () => context
                      .read<NewSaleBloc>()
                      .add(NewSaleSubmitted()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showInventoryPicker(BuildContext pageContext) async {
    final item = await showModalBottomSheet<InventoryItem>(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _InventoryPickerSheet(),
    );
    if (item != null && pageContext.mounted) {
      pageContext.read<NewSaleBloc>().add(
            NewSaleItemAdded(
              item: SaleItem(
                id: item.id,
                name: item.name,
                barcode: item.barcode,
                grossWeight: item.grossWeight,
                netWeight: item.netWeight,
                purity: item.purityPercent,
                taxableAmount: item.taxableAmount,
                gst: item.gst,
                totalAmount: item.totalAmount,
              ),
            ),
          );
    }
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class _TotalPanel extends StatelessWidget {
  const _TotalPanel({
    required this.cart,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final NewSaleCartState cart;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: SalesColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TotalRow(
              labelMr: 'एकूण',
              labelEn: 'Subtotal',
              value: '₹${amtFmt.format(cart.subtotal)}'),
          _TotalRow(
              labelMr: 'सूट',
              labelEn: 'Discount',
              value: '- ₹${amtFmt.format(cart.discount)}'),
          _TotalRow(
              labelMr: 'CGST 1.5%',
              labelEn: 'CGST',
              value: '₹${amtFmt.format(cart.cgst)}'),
          _TotalRow(
              labelMr: 'SGST 1.5%',
              labelEn: 'SGST',
              value: '₹${amtFmt.format(cart.sgst)}'),
          const Divider(color: SalesColors.line),
          _TotalRow(
            labelMr: 'एकूण देय',
            labelEn: 'Total Due',
            value: '₹${amtFmt.format(cart.totalAmount)}',
            bold: true,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: SalesColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                  : const Text('इन्व्हॉईस पूर्वावलोकन / Preview Invoice'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item, required this.onRemove});

  final SaleItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
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
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SalesColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.barcode} • ${item.grossWeight.toStringAsFixed(2)}g • ${item.purity.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${amtFmt.format(item.taxableAmount)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SalesColors.navy,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: SalesColors.muted),
            onPressed: onRemove,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(labelFor(item)),
              ))
          .toList(),
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

// ---------------------------------------------------------------------------
// Inventory picker bottom sheet (Gap fix: Add Item)
// ---------------------------------------------------------------------------

class _InventoryPickerSheet extends StatefulWidget {
  const _InventoryPickerSheet();

  @override
  State<_InventoryPickerSheet> createState() =>
      _InventoryPickerSheetState();
}

class _InventoryPickerSheetState extends State<_InventoryPickerSheet> {
  final _searchCtrl = TextEditingController();
  late final InventoryListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<InventoryListBloc>()
      ..add(InventoryListStarted());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return BlocProvider.value(
      value: _bloc,
      child: Container(
        height: mq.size.height * 0.75,
        decoration: const BoxDecoration(
          color: SalesColors.screenBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: SalesColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'वस्तू निवडा',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: SalesColors.ink,
                          ),
                        ),
                        Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 12,
                            color: SalesColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: SalesColors.muted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'नाव / बारकोड शोधा  |  Search name / barcode',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: SalesColors.muted),
                  prefixIcon: const Icon(Icons.search,
                      color: SalesColors.muted, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: SalesColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: SalesColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: SalesColors.navy, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
                onChanged: (v) => setState(() {}),
              ),
            ),
            const Divider(height: 1, color: SalesColors.line),
            Expanded(
              child: BlocBuilder<InventoryListBloc, InventoryListState>(
                builder: (context, state) {
                  if (state is InventoryListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: SalesColors.navy),
                    );
                  }
                  if (state is InventoryListError) {
                    return Center(
                      child: Text(state.message,
                          style:
                              const TextStyle(color: SalesColors.muted)),
                    );
                  }
                  if (state is InventoryListLoaded) {
                    final query = _searchCtrl.text.toLowerCase();
                    final available = state.items
                        .where((i) =>
                            i.status == InventoryStatus.available &&
                            (query.isEmpty ||
                                i.name.toLowerCase().contains(query) ||
                                i.barcode.toLowerCase().contains(query)))
                        .toList();
                    if (available.isEmpty) {
                      return const Center(
                        child: Text(
                          'उपलब्ध वस्तू नाहीत\nNo items available',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: SalesColors.muted),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: available.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = available[index];
                        final amtFmt =
                            NumberFormat('#,##,##0.00', 'en_IN');
                        return InkWell(
                          onTap: () => Navigator.pop(context, item),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: SalesColors.line),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7E9),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.diamond_outlined,
                                    color: SalesColors.gold,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: SalesColors.ink,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.barcode} • ${item.purity} • ${item.grossWeight.toStringAsFixed(2)}g',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: SalesColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${amtFmt.format(item.sellingPrice)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: SalesColors.navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
