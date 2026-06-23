import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/compliance_entities.dart';
import '../presentation/bloc/form9_bloc.dart';
import '../theme/compliance_colors.dart';
import 'compliance_dashboard_page.dart';

/// SCR-037 Form 9 Register
///
/// Daily lending register aggregating Girvi, payments, and interest data.
class Form9RegisterPage extends StatelessWidget {
  const Form9RegisterPage({super.key});

  static const routeName = 'form9-register';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<Form9Bloc>()..add(Form9Started()),
      child: const _Form9Scaffold(),
    );
  }
}

class _Form9Scaffold extends StatefulWidget {
  const _Form9Scaffold();

  @override
  State<_Form9Scaffold> createState() => _Form9ScaffoldState();
}

class _Form9ScaffoldState extends State<_Form9Scaffold> {
  String _from = '01 Jan 2026';
  String _to = '31 Jan 2026';

  String _format(double value) => '₹ ${value.toStringAsFixed(0)}';

  Future<void> _pickDate(bool isFrom) async {
    final initial = DateTime(2026, isFrom ? 1 : 1, isFrom ? 1 : 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ComplianceColors.navy,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    final formatted =
        '${picked.day.toString().padLeft(2, '0')} ${_monthAbbr(picked.month)} ${picked.year}';
    setState(() {
      if (isFrom) {
        _from = formatted;
      } else {
        _to = formatted;
      }
    });
  }

  String _monthAbbr(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m - 1];
  }

  void _preview() {
    context
        .read<Form9Bloc>()
        .add(Form9DateRangeChanged(from: _from, to: _to));
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
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _FilterBar(
              from: _from,
              to: _to,
              onFromTap: () => _pickDate(true),
              onToTap: () => _pickDate(false),
              onPreview: _preview,
            ),
            Expanded(
              child: BlocBuilder<Form9Bloc, Form9State>(
                builder: (context, state) {
                  if (state is Form9Loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: ComplianceColors.navy),
                    );
                  }
                  if (state is Form9Error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: ComplianceColors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(
                                  color: ComplianceColors.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<Form9Bloc>().add(Form9Started()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ComplianceColors.navy),
                            child: const Text('पुन्हा प्रयत्न / Retry',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is Form9Loaded) {
                    return _RegisterView(
                        register: state.register, format: _format);
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

class _RegisterView extends StatelessWidget {
  const _RegisterView({required this.register, required this.format});

  final Form9Register register;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                const _TableHeader(),
                const Divider(height: 1, color: ComplianceColors.line),
                ...register.rows.map(
                  (row) => _TableRow(row: row, format: format),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SummaryBar(register: register, format: format),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.from,
    required this.to,
    required this.onFromTap,
    required this.onToTap,
    required this.onPreview,
  });

  final String from;
  final String to;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _DateField(label: 'From', value: from, onTap: onFromTap),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DateField(label: 'To', value: to, onTap: onToTap),
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
                  fontSize: 10, color: ComplianceColors.muted),
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
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ComplianceColors.navy.withAlpha(10),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Date / तारीख',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ComplianceColors.ink),
            ),
          ),
          Expanded(
            child: Text(
              'Count',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ComplianceColors.ink),
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
                  color: ComplianceColors.ink),
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
                  color: ComplianceColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.row, required this.format});

  final Form9Row row;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ComplianceColors.line)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              row.date,
              style: const TextStyle(
                  fontSize: 13, color: ComplianceColors.ink),
            ),
          ),
          Expanded(
            child: Text(
              '${row.girviCount}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: ComplianceColors.ink),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              format(row.totalLoan),
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
              format(row.payments),
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

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.register, required this.format});

  final Form9Register register;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ComplianceColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
              label: 'एकूण नोंदी / Count',
              value: '${register.totalCount}'),
          _SummaryItem(
              label: 'एकूण कर्ज / Loans',
              value: format(register.totalLoans)),
          _SummaryItem(
              label: 'एकूण परतावे / Payments',
              value: format(register.totalPayments)),
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
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ],
    );
  }
}
