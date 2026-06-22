import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/interest_colors.dart';

/// SCR-033 Interest Ledger & Breakdown
///
/// Displays the complete financial audit trail for a Girvi contract,
/// including every accrual, payment, penalty, renewal, and redemption entry.
class InterestLedgerPage extends StatelessWidget {
  const InterestLedgerPage({super.key});

  static const routeName = 'interest-ledger';

  final Map<String, dynamic> _header = const {
    'girviId': 'GRV-2026-000042',
    'customer': 'Ramesh Patil',
    'principal': 100000.0,
    'interestType': 'Simple',
    'interestRate': 12.0,
  };

  final List<Map<String, dynamic>> _ledgerRows = const [
    {
      'date': '01 Jan 2026',
      'type': 'ACCRUAL',
      'openingPrincipal': 100000.0,
      'interest': 0.0,
      'penalty': 0.0,
      'payment': 0.0,
      'closingPrincipal': 100000.0,
    },
    {
      'date': '31 Jan 2026',
      'type': 'ACCRUAL',
      'openingPrincipal': 100000.0,
      'interest': 986.30,
      'penalty': 0.0,
      'payment': 0.0,
      'closingPrincipal': 100000.0,
    },
    {
      'date': '28 Feb 2026',
      'type': 'ACCRUAL',
      'openingPrincipal': 100000.0,
      'interest': 1013.70,
      'penalty': 0.0,
      'payment': 0.0,
      'closingPrincipal': 100000.0,
    },
    {
      'date': '15 Mar 2026',
      'type': 'PAYMENT',
      'openingPrincipal': 100000.0,
      'interest': 0.0,
      'penalty': 0.0,
      'payment': 5000.0,
      'closingPrincipal': 95000.0,
    },
    {
      'date': '30 Jun 2026',
      'type': 'ACCRUAL',
      'openingPrincipal': 95000.0,
      'interest': 4931.51,
      'penalty': 0.0,
      'payment': 0.0,
      'closingPrincipal': 95000.0,
    },
  ];

  double get _totalInterest {
    return _ledgerRows.fold<double>(
      0,
      (sum, row) => sum + (row['interest'] as double),
    );
  }

  double get _totalPenalty {
    return _ledgerRows.fold<double>(
      0,
      (sum, row) => sum + (row['penalty'] as double),
    );
  }

  double get _totalPayments {
    return _ledgerRows.fold<double>(
      0,
      (sum, row) => sum + (row['payment'] as double),
    );
  }

  double get _outstanding {
    final principal = _header['principal'] as double;
    return principal + _totalInterest + _totalPenalty - _totalPayments;
  }

  String _format(double value) {
    return '₹ ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InterestColors.screenBg,
      appBar: AppBar(
        backgroundColor: InterestColors.navy,
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
              'व्याज खाते',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Interest Ledger',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: () {
              // TODO: print ledger.
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: share ledger.
            },
          ),
        ],
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
                    _LedgerHeader(header: _header),
                    const SizedBox(height: 16),
                    _LedgerSummary(
                      principal: _header['principal'] as double,
                      totalInterest: _totalInterest,
                      totalPenalty: _totalPenalty,
                      outstanding: _outstanding,
                    ),
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
                    ..._ledgerRows.map((row) => _LedgerRow(
                          row: row,
                          format: _format,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerHeader extends StatelessWidget {
  const _LedgerHeader({required this.header});

  final Map<String, dynamic> header;

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
            header['girviId'] as String,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: InterestColors.gold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            header['customer'] as String,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeaderItem(
                  labelMr: 'मूळ रक्कम',
                  labelEn: 'Principal',
                  value:
                      '₹ ${(header['principal'] as double).toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _HeaderItem(
                  labelMr: 'व्याज प्रकार',
                  labelEn: 'Interest Type',
                  value: header['interestType'] as String,
                ),
              ),
              Expanded(
                child: _HeaderItem(
                  labelMr: 'दर',
                  labelEn: 'Rate',
                  value: '${header['interestRate']}%',
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
        Text(
          labelMr,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white54,
          ),
        ),
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
  const _LedgerSummary({
    required this.principal,
    required this.totalInterest,
    required this.totalPenalty,
    required this.outstanding,
  });

  final double principal;
  final double totalInterest;
  final double totalPenalty;
  final double outstanding;

  String _format(double value) {
    return '₹ ${value.toStringAsFixed(2)}';
  }

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
                  value: _format(principal),
                  color: InterestColors.navy,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryBox(
                  labelMr: 'व्याज',
                  labelEn: 'Interest',
                  value: _format(totalInterest),
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
                  value: _format(totalPenalty),
                  color: InterestColors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryBox(
                  labelMr: 'बाकी',
                  labelEn: 'Outstanding',
                  value: _format(outstanding),
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
            style: TextStyle(
              fontSize: 11,
              color: color.withAlpha(180),
            ),
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
    required this.row,
    required this.format,
  });

  final Map<String, dynamic> row;
  final String Function(double) format;

  Color get _typeColor {
    switch (row['type'] as String) {
      case 'PAYMENT':
        return InterestColors.green;
      case 'PENALTY':
        return InterestColors.red;
      case 'RENEWAL':
        return InterestColors.orange;
      case 'REDEMPTION':
        return InterestColors.navy;
      default:
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
                row['date'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: InterestColors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _typeColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  row['type'] as String,
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
                  value: format(row['openingPrincipal'] as double),
                ),
              ),
              Expanded(
                child: _LedgerItem(
                  label: 'Interest',
                  value: format(row['interest'] as double),
                  valueColor: InterestColors.gold,
                ),
              ),
              Expanded(
                child: _LedgerItem(
                  label: 'Penalty',
                  value: format(row['penalty'] as double),
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
                  value: format(row['payment'] as double),
                  valueColor: InterestColors.green,
                ),
              ),
              Expanded(
                child: _LedgerItem(
                  label: 'Closing',
                  value: format(row['closingPrincipal'] as double),
                  isBold: true,
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
          style: const TextStyle(
            fontSize: 11,
            color: InterestColors.muted,
          ),
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
