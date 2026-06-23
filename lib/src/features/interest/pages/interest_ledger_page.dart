import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../domain/entities/interest_calculation.dart';
import '../domain/entities/interest_ledger.dart';
import '../presentation/bloc/ledger_bloc.dart';
import '../presentation/bloc/ledger_event.dart';
import '../presentation/bloc/ledger_state.dart';
import '../theme/interest_colors.dart';

/// SCR-033 Interest Ledger & Breakdown
///
/// Displays the complete financial audit trail for a Girvi contract —
/// every accrual, payment, penalty, renewal, and redemption entry.
class InterestLedgerPage extends StatelessWidget {
  const InterestLedgerPage({this.girviId = 'grv-001', super.key});

  static const routeName = 'interest-ledger';

  final String girviId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<LedgerBloc>()
        ..add(LedgerLoadRequested(girviId)),
      child: const _LedgerView(),
    );
  }
}

class _LedgerView extends StatelessWidget {
  const _LedgerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InterestColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'व्याज खाते',
              titleEn: 'Interest Ledger',
              showBackButton: true,
              backFallbackRoute: 'more',
              actions: [
                IconButton(
                  icon: const Icon(Icons.print_outlined,
                      color: InterestColors.ink),
                  tooltip: 'प्रिंट / Print',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined,
                      color: InterestColors.ink),
                  tooltip: 'शेअर / Share',
                  onPressed: () {},
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<LedgerBloc, LedgerState>(
                builder: (context, state) {
                  if (state is LedgerLoading || state is LedgerInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is LedgerError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: InterestColors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            style: const TextStyle(
                                color: InterestColors.muted, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  final ledger = (state as LedgerLoaded).ledger;
                  return _LedgerContent(ledger: ledger);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerContent extends StatelessWidget {
  const _LedgerContent({required this.ledger});

  final InterestLedger ledger;

  static final _dateFmt = DateFormat('dd MMM yyyy');
  static final _currencyFmt = NumberFormat('#,##,##0.00', 'en_IN');

  String _fmt(double v) => '₹ ${_currencyFmt.format(v)}';

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: InterestColors.navy,
      onRefresh: () async {
        context.read<LedgerBloc>().add(
              LedgerRefreshRequested(ledger.girviId),
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LedgerHeader(ledger: ledger, fmt: _fmt),
            const SizedBox(height: 16),
            _LedgerSummary(ledger: ledger, fmt: _fmt),
            const SizedBox(height: 24),
            const Text(
              'खाते तपशील / Ledger Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: InterestColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            ...ledger.entries.map(
              (entry) => _LedgerRow(
                entry: entry,
                dateFmt: _dateFmt,
                fmt: _fmt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerHeader extends StatelessWidget {
  const _LedgerHeader({required this.ledger, required this.fmt});

  final InterestLedger ledger;
  final String Function(double) fmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: InterestColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ledger.girviId,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: InterestColors.gold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${ledger.customerName} / ${ledger.customerNameEn}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeaderItem(
                  labelMr: 'मूळ रक्कम',
                  labelEn: 'Principal',
                  value: fmt(ledger.principal),
                ),
              ),
              Expanded(
                child: _HeaderItem(
                  labelMr: 'व्याज प्रकार',
                  labelEn: 'Interest Type',
                  value: ledger.interestType.labelEn,
                ),
              ),
              Expanded(
                child: _HeaderItem(
                  labelMr: 'दर',
                  labelEn: 'Rate',
                  value: '${ledger.interestRate}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelMr,
            style: const TextStyle(fontSize: 11, color: Colors.white70)),
        Text(labelEn,
            style: const TextStyle(fontSize: 10, color: Colors.white54)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _LedgerSummary extends StatelessWidget {
  const _LedgerSummary({required this.ledger, required this.fmt});

  final InterestLedger ledger;
  final String Function(double) fmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: InterestColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'सारांश / Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: InterestColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  labelMr: 'मूळ',
                  labelEn: 'Principal',
                  value: fmt(ledger.principal),
                  color: InterestColors.navy,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryBox(
                  labelMr: 'व्याज',
                  labelEn: 'Interest',
                  value: fmt(ledger.totalInterest),
                  color: InterestColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  labelMr: 'दंड',
                  labelEn: 'Penalty',
                  value: fmt(ledger.totalPenalty),
                  color: InterestColors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryBox(
                  labelMr: 'बाकी',
                  labelEn: 'Outstanding',
                  value: fmt(ledger.outstanding),
                  color: InterestColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.color,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: TextStyle(fontSize: 11, color: color.withAlpha(180)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({
    required this.entry,
    required this.dateFmt,
    required this.fmt,
  });

  final LedgerEntry entry;
  final DateFormat dateFmt;
  final String Function(double) fmt;

  Color get _typeColor {
    switch (entry.type) {
      case LedgerEntryType.payment:
        return InterestColors.green;
      case LedgerEntryType.penalty:
        return InterestColors.red;
      case LedgerEntryType.renewal:
        return InterestColors.orange;
      case LedgerEntryType.redemption:
        return InterestColors.navy;
      case LedgerEntryType.auction:
        return InterestColors.red;
      case LedgerEntryType.accrual:
        return InterestColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InterestColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFmt.format(entry.date),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: InterestColors.ink,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _typeColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${entry.type.labelMr} / ${entry.type.labelEn}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _typeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LedgerItem(
                  label: 'Opening',
                  value: fmt(entry.openingPrincipal),
                ),
              ),
              Expanded(
                child: _LedgerItem(
                  label: 'Interest',
                  value: fmt(entry.interest),
                  valueColor: InterestColors.gold,
                ),
              ),
              Expanded(
                child: _LedgerItem(
                  label: 'Penalty',
                  value: fmt(entry.penalty),
                  valueColor: InterestColors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _LedgerItem(
                  label: 'Payment',
                  value: fmt(entry.payment),
                  valueColor: InterestColors.green,
                ),
              ),
              Expanded(
                child: _LedgerItem(
                  label: 'Closing',
                  value: fmt(entry.closingPrincipal),
                  isBold: true,
                ),
              ),
              if (entry.notes != null)
                Expanded(
                  child: Text(
                    entry.notes!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: InterestColors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LedgerItem extends StatelessWidget {
  const _LedgerItem({
    required this.label,
    required this.value,
    this.valueColor = InterestColors.ink,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: InterestColors.muted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
