import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../presentation/bloc/barcode_sale_bloc.dart';
import '../theme/sales_colors.dart';

/// SCR-081 Barcode Sales Screen
class BarcodeSalePage extends StatelessWidget {
  const BarcodeSalePage({super.key});

  static const routeName = 'barcode-sale';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<BarcodeSaleBloc>(),
      child: BlocListener<BarcodeSaleBloc, BarcodeSaleState>(
        listener: (context, state) {
          if (state is BarcodeSaleSuccess) {
            context.goNamed('invoice-preview', extra: state.order);
          }
          if (state is BarcodeSaleItemNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'बारकोड सापडला नाही: ${state.barcode} / Barcode not found'),
                backgroundColor: SalesColors.red,
              ),
            );
          }
          if (state is BarcodeSaleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: SalesColors.red,
              ),
            );
          }
        },
        child: const _BarcodeSaleScaffold(),
      ),
    );
  }
}

class _BarcodeSaleScaffold extends StatefulWidget {
  const _BarcodeSaleScaffold();

  @override
  State<_BarcodeSaleScaffold> createState() => _BarcodeSaleScaffoldState();
}

class _BarcodeSaleScaffoldState extends State<_BarcodeSaleScaffold> {
  final _barcodeCtrl = TextEditingController();

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SalesColors.screenBg,
      body: SafeArea(
        child: BlocBuilder<BarcodeSaleBloc, BarcodeSaleState>(
          builder: (context, state) {
            final cart = state is BarcodeSaleCartState
                ? state
                : BarcodeSaleCartState(items: const []);
            final isCheckingOut = state is BarcodeSaleCheckingOut;

            return Column(
              children: [
                AppHeader(
                  titleMr: 'बारकोड विक्री',
                  titleEn: 'Barcode Sale',
                  showBackButton: true,
                  backFallbackRoute: 'sales-dashboard',
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _barcodeCtrl,
                          decoration: InputDecoration(
                            hintText:
                                'बारकोड स्कॅन करा / Scan Barcode',
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
                                horizontal: 14, vertical: 14),
                          ),
                          onSubmitted: (barcode) {
                            if (barcode.trim().isNotEmpty) {
                              context.read<BarcodeSaleBloc>().add(
                                    BarcodeSaleItemScanned(
                                        barcode: barcode.trim()),
                                  );
                              _barcodeCtrl.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final b = _barcodeCtrl.text.trim();
                          if (b.isNotEmpty) {
                            context
                                .read<BarcodeSaleBloc>()
                                .add(BarcodeSaleItemScanned(barcode: b));
                            _barcodeCtrl.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SalesColors.navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
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
                  child: cart.items.isEmpty
                      ? const _EmptyCart()
                      : ListView.separated(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cart.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return _CartItemTile(
                              name: item.name,
                              barcode: item.barcode,
                              price: item.totalAmount,
                              onDelete: () => context
                                  .read<BarcodeSaleBloc>()
                                  .add(BarcodeSaleItemRemoved(
                                      itemId: item.id)),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(top: BorderSide(color: SalesColors.line)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                            '₹${NumberFormat('#,##,##0.00', 'en_IN').format(cart.total)}',
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
                          onPressed: isCheckingOut || cart.items.isEmpty
                              ? null
                              : () => context
                                  .read<BarcodeSaleBloc>()
                                  .add(BarcodeSaleCheckoutStarted()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SalesColors.navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isCheckingOut
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('चेकआउट / Checkout'),
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
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 48, color: SalesColors.muted),
          SizedBox(height: 12),
          Text(
            'कार्ट रिकामी आहे\nCart is empty',
            textAlign: TextAlign.center,
            style: TextStyle(color: SalesColors.muted, fontSize: 14),
          ),
        ],
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
              color: SalesColors.navy.withValues(alpha: 0.08),
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
            '₹${NumberFormat('#,##,##0.00', 'en_IN').format(price)}',
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
