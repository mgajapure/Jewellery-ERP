import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../domain/entities/sale_order.dart';
import '../presentation/bloc/sales_ledger_bloc.dart';
import '../theme/sales_colors.dart';

/// SCR-057 Sales Ledger
class SalesLedgerPage extends StatefulWidget {
  const SalesLedgerPage({super.key});

  static const routeName = 'sales-ledger';

  @override
  State<SalesLedgerPage> createState() => _SalesLedgerPageState();
}

class _SalesLedgerPageState extends State<SalesLedgerPage> {
  final _searchCtrl = TextEditingController();

  static const _filters = [
    ('', 'सर्व / All'),
    ('COMPLETED', 'पूर्ण / Completed'),
    ('RETURNED', 'परत / Returned'),
    ('CANCELLED', 'रद्द / Cancelled'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<SalesLedgerBloc>()..add(SalesLedgerStarted()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: SalesColors.screenBg,
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  titleMr: 'विक्री खाते',
                  titleEn: 'Sales Ledger',
                  showBackButton: true,
                  backFallbackRoute: 'sales-dashboard',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.download_outlined,
                          color: SalesColors.ink),
                      tooltip: 'एक्सपोर्ट / Export',
                      onPressed: () {},
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: _SearchBar(
                    controller: _searchCtrl,
                    onChanged: (q) => context
                        .read<SalesLedgerBloc>()
                        .add(SalesLedgerSearchChanged(query: q)),
                  ),
                ),
                BlocBuilder<SalesLedgerBloc, SalesLedgerState>(
                  buildWhen: (prev, curr) =>
                      (prev is SalesLedgerLoaded && curr is SalesLedgerLoaded &&
                          prev.filter != curr.filter) ||
                      prev.runtimeType != curr.runtimeType,
                  builder: (context, state) {
                    final selected =
                        state is SalesLedgerLoaded ? state.filter : '';
                    return _FilterChips(
                      filters: _filters,
                      selected: selected,
                      onSelected: (f) => context
                          .read<SalesLedgerBloc>()
                          .add(SalesLedgerFilterChanged(filter: f)),
                    );
                  },
                ),
                const SizedBox(height: 8),
                BlocBuilder<SalesLedgerBloc, SalesLedgerState>(
                  builder: (context, state) {
                    if (state is SalesLedgerLoading ||
                        state is SalesLedgerInitial) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: SalesColors.navy,
                          ),
                        ),
                      );
                    }
                    if (state is SalesLedgerError) {
                      return Expanded(
                        child: _ErrorView(
                          message: state.message,
                          onRetry: () => context
                              .read<SalesLedgerBloc>()
                              .add(SalesLedgerRefreshed()),
                        ),
                      );
                    }
                    if (state is SalesLedgerLoaded) {
                      return Expanded(
                        child: _LedgerBody(
                          state: state,
                          onRefresh: () async => context
                              .read<SalesLedgerBloc>()
                              .add(SalesLedgerRefreshed()),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _LedgerBody extends StatelessWidget {
  const _LedgerBody({required this.state, required this.onRefresh});

  final SalesLedgerLoaded state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');

    return RefreshIndicator(
      color: SalesColors.navy,
      onRefresh: onRefresh,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SummaryCard(
              total: '₹${amtFmt.format(state.totalRevenue)}',
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: state.orders.isEmpty
                ? const _EmptyView()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: state.orders.length,
                    itemBuilder: (context, i) =>
                        _TransactionCard(order: state.orders[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'इन्व्हॉईस / ग्राहक शोधा',
        hintStyle: const TextStyle(color: SalesColors.muted, fontSize: 14),
        prefixIcon:
            const Icon(Icons.search, color: SalesColors.muted, size: 22),
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
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<(String, String)> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (value, label) = filters[index];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                color: isSelected ? SalesColors.gold : SalesColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(value),
            selectedColor: SalesColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? SalesColors.navy : SalesColors.line,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total});

  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SalesColors.navy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'एकूण उत्पन्न / Total Revenue',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                total,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'This Month',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.order});

  final SaleOrder order;

  Color get _statusColor {
    switch (order.status) {
      case SaleStatus.returned:
        return SalesColors.red;
      case SaleStatus.cancelled:
        return SalesColors.muted;
      default:
        return SalesColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');

    return InkWell(
      onTap: () => context.goNamed(
        'sales-details',
        pathParameters: {'id': order.invoiceNo},
        extra: order,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SalesColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.invoiceNo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: SalesColors.navy,
                  ),
                ),
                Text(
                  dateFmt.format(order.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: SalesColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.customerName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: SalesColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Tag(text: '${order.items.length} Items'),
                const SizedBox(width: 8),
                _Tag(
                  text: '${order.status.labelMr} / ${order.status.labelEn}',
                  color: _statusColor,
                ),
              ],
            ),
            const Divider(height: 22, color: SalesColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'रक्कम',
                      style: TextStyle(
                        color: SalesColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: SalesColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${amtFmt.format(order.totalAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: SalesColors.ink,
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

class _Tag extends StatelessWidget {
  const _Tag({required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color == null
            ? SalesColors.cream
            : color!.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color ?? SalesColors.navy,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: SalesColors.muted),
          SizedBox(height: 12),
          Text(
            'कोणतेही व्यवहार नाहीत\nNo transactions found',
            textAlign: TextAlign.center,
            style: TextStyle(color: SalesColors.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined,
                size: 48, color: SalesColors.muted),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: SalesColors.muted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: SalesColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('पुन्हा प्रयत्न / Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
