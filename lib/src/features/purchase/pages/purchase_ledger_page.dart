import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/purchase_entry.dart';
import '../presentation/bloc/purchase_ledger_bloc.dart';
import '../theme/purchase_colors.dart';

/// SCR-061 Purchase Ledger
class PurchaseLedgerPage extends StatelessWidget {
  const PurchaseLedgerPage({super.key});

  static const routeName = 'purchase-ledger';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<PurchaseLedgerBloc>()
        ..add(const PurchaseLedgerStarted()),
      child: const _LedgerView(),
    );
  }
}

class _LedgerView extends StatefulWidget {
  const _LedgerView();

  @override
  State<_LedgerView> createState() => _LedgerViewState();
}

class _LedgerViewState extends State<_LedgerView> {
  final _searchCtrl = TextEditingController();

  static const _filters = [
    ('', 'सर्व / All'),
    ('CASH', 'रोख / Cash'),
    ('BANK', 'बँक / Bank'),
    ('CREDIT', 'उधार / Credit'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'खरेदी खाते',
              titleEn: 'Purchase Ledger',
              showBackButton: true,
              backFallbackRoute: 'purchase-dashboard',
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: PurchaseColors.ink),
                  tooltip: 'फिल्टर / Filter',
                  onPressed: () async {
                    final now = DateTime.now();
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: now,
                      initialDateRange: DateTimeRange(
                        start: DateTime(now.year, now.month, 1),
                        end: now,
                      ),
                      helpText: 'तारीख श्रेणी निवडा / Select Date Range',
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: PurchaseColors.navy,
                            onPrimary: Colors.white,
                            secondary: PurchaseColors.gold,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (range != null && context.mounted) {
                      final fmt = DateFormat('dd MMM');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'तारीख फिल्टर: ${fmt.format(range.start)} – ${fmt.format(range.end)}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _SearchBar(
                controller: _searchCtrl,
                onChanged: (q) => context
                    .read<PurchaseLedgerBloc>()
                    .add(PurchaseLedgerSearchChanged(q)),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<PurchaseLedgerBloc, PurchaseLedgerState>(
              buildWhen: (p, c) =>
                  (p is PurchaseLedgerLoaded ? p.filter : '') !=
                  (c is PurchaseLedgerLoaded ? c.filter : ''),
              builder: (context, state) {
                final selected =
                    state is PurchaseLedgerLoaded ? state.filter : '';
                return _FilterChips(
                  filters: _filters,
                  selected: selected,
                  onSelected: (f) => context
                      .read<PurchaseLedgerBloc>()
                      .add(PurchaseLedgerFilterChanged(f)),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                color: PurchaseColors.navy,
                onRefresh: () async => context
                    .read<PurchaseLedgerBloc>()
                    .add(const PurchaseLedgerRefreshed()),
                child: BlocBuilder<PurchaseLedgerBloc, PurchaseLedgerState>(
                  builder: (context, state) {
                    if (state is PurchaseLedgerLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: PurchaseColors.navy,
                        ),
                      );
                    }
                    if (state is PurchaseLedgerError) {
                      return _ErrorView(
                        message: state.message,
                        onRetry: () => context
                            .read<PurchaseLedgerBloc>()
                            .add(const PurchaseLedgerStarted()),
                      );
                    }
                    if (state is PurchaseLedgerLoaded) {
                      if (state.entries.isEmpty) {
                        return const _EmptyState();
                      }
                      return _LoadedList(loaded: state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedList extends StatelessWidget {
  const _LoadedList({required this.loaded});

  final PurchaseLedgerLoaded loaded;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,##0.00', 'en_IN');
    return Column(
      children: [
        _SummaryCard(total: '₹${fmt.format(loaded.totalAmount)}'),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            itemCount: loaded.entries.length,
            itemBuilder: (_, i) =>
                _TransactionCard(entry: loaded.entries[i]),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PurchaseColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: PurchaseColors.muted, size: 22),
          hintText: 'पुरवठादार / आयडी / तारीख शोधा',
          hintStyle: TextStyle(
            color: PurchaseColors.muted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
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
                color: isSelected ? PurchaseColors.gold : PurchaseColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(value),
            selectedColor: PurchaseColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color:
                    isSelected ? PurchaseColors.navy : PurchaseColors.line,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PurchaseColors.navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'एकूण खरेदी / Total Purchase',
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
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.entry});

  final PurchaseEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
    return InkWell(
      onTap: () => context.goNamed(
        'purchase-details',
        extra: entry,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PurchaseColors.line),
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
                  entry.id,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.navy,
                  ),
                ),
                Text(
                  dateFmt.format(entry.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: PurchaseColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry.supplierName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: PurchaseColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Tag(text: entry.metalType.labelEn),
                const SizedBox(width: 8),
                _Tag(
                    text:
                        '${entry.netWeight.toStringAsFixed(2)} g'),
                const SizedBox(width: 8),
                _Tag(text: entry.paymentMode.labelEn),
              ],
            ),
            const Divider(height: 22, color: PurchaseColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _BiLabel(labelMr: 'रक्कम', labelEn: 'Amount'),
                Text(
                  '₹${amtFmt.format(entry.totalAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.ink,
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
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: PurchaseColors.cream,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: PurchaseColors.navy,
        ),
      ),
    );
  }
}

class _BiLabel extends StatelessWidget {
  const _BiLabel({required this.labelMr, required this.labelEn});

  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: PurchaseColors.muted,
          ),
          SizedBox(height: 12),
          Text(
            'कोणत्याही नोंदी आढळल्या नाहीत',
            style: TextStyle(
              color: PurchaseColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'No entries found',
            style: TextStyle(
              color: PurchaseColors.muted,
              fontSize: 12,
            ),
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
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: PurchaseColors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PurchaseColors.muted),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: PurchaseColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: BilingualText(en: 'Retry', mr: 'पुन्हा प्रयत्न', compact: true),
            ),
          ],
        ),
      ),
    );
  }
}
