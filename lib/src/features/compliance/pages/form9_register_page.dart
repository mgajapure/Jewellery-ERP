import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/compliance_colors.dart';
import 'compliance_dashboard_page.dart';

/// SCR-037 Form 9 Register
///
/// Daily lending register aggregating Girvi, payments, and interest data.
class Form9RegisterPage extends StatelessWidget {
  const Form9RegisterPage({super.key});

  static const routeName = 'form9-register';

  final List<Map<String, dynamic>> _rows = const [
    {
      'date': '01 Jan 2026',
      'girviCount': 4,
      'totalLoan': 185000.0,
      'payments': 12000.0,
      'interest': 2100.0,
    },
    {
      'date': '02 Jan 2026',
      'girviCount': 2,
      'totalLoan': 75000.0,
      'payments': 5000.0,
      'interest': 950.0,
    },
    {
      'date': '03 Jan 2026',
      'girviCount': 5,
      'totalLoan': 220000.0,
      'payments': 15000.0,
      'interest': 2800.0,
    },
    {
      'date': '04 Jan 2026',
      'girviCount': 3,
      'totalLoan': 140000.0,
      'payments': 8000.0,
      'interest': 1650.0,
    },
  ];

  String _format(double value) {
    return '₹ ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComplianceColors.screenBg,
      appBar: AppBar(
        backgroundColor: ComplianceColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            ComplianceDashboardPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'फॉर्म ९ रजिस्टर',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Form 9 Register',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {
              // TODO: export PDF.
            },
          ),
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            onPressed: () {
              // TODO: export Excel.
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _FilterBar(
              onPreview: () {
                // TODO: regenerate register preview.
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ComplianceColors.line),
                      ),
                      child: Column(
                        children: [
                          _TableHeader(),
                          const Divider(height: 1, color: ComplianceColors.line),
                          ..._rows.map((row) => _TableRow(row: row, format: _format)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SummaryRow(rows: _rows, format: _format),
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.onPreview});

  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              label: 'From',
              value: '01 Jan 2026',
              onTap: () {
                // TODO: open date picker.
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DateField(
              label: 'To',
              value: '31 Jan 2026',
              onTap: () {
                // TODO: open date picker.
              },
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onPreview,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Preview'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ComplianceColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ComplianceColors.screenBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ComplianceColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: ComplianceColors.muted,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ComplianceColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ComplianceColors.navy.withAlpha(10),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ComplianceColors.ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Count',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ComplianceColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Loans',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ComplianceColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Payments',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ComplianceColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.row, required this.format});

  final Map<String, dynamic> row;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ComplianceColors.line),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              row['date'] as String,
              style: const TextStyle(
                fontSize: 13,
                color: ComplianceColors.ink,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${row['girviCount']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: ComplianceColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              format(row['totalLoan'] as double),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ComplianceColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              format(row['payments'] as double),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ComplianceColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.rows, required this.format});

  final List<Map<String, dynamic>> rows;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    final totalCount = rows.fold<int>(
      0,
      (sum, r) => sum + (r['girviCount'] as int),
    );
    final totalLoans = rows.fold<double>(
      0,
      (sum, r) => sum + (r['totalLoan'] as double),
    );
    final totalPayments = rows.fold<double>(
      0,
      (sum, r) => sum + (r['payments'] as double),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ComplianceColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(label: 'Total Count', value: '$totalCount'),
          _SummaryItem(label: 'Total Loans', value: format(totalLoans)),
          _SummaryItem(label: 'Total Payments', value: format(totalPayments)),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
