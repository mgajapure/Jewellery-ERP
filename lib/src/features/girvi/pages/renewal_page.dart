import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

/// SCR-029 Renewal
///
/// Extends a Girvi contract with revaluation and recalculated terms.
/// Links the old contract and generates a renewal receipt.
class RenewalPage extends StatefulWidget {
  const RenewalPage({super.key});

  static const routeName = 'renewal';

  @override
  State<RenewalPage> createState() => _RenewalPageState();
}

class _RenewalPageState extends State<RenewalPage> {
  final TextEditingController _newAmountController =
      TextEditingController(text: '100000');
  final TextEditingController _rateController =
      TextEditingController(text: '12');
  final TextEditingController _monthsController =
      TextEditingController(text: '12');

  final double _currentOutstanding = 100917.81;
  final String _oldGirviId = 'GRV-2026-000042';

  double get _newAmount {
    return double.tryParse(_newAmountController.text) ?? 0;
  }

  double get _rate {
    return double.tryParse(_rateController.text) ?? 0;
  }

  int get _months {
    return int.tryParse(_monthsController.text) ?? 0;
  }

  double get _newInterest {
    if (_newAmount <= 0 || _months <= 0) return 0;
    return (_newAmount * _rate * _months) / 1200;
  }

  double get _totalDue {
    return _newAmount + _newInterest;
  }

  @override
  void dispose() {
    _newAmountController.dispose();
    _rateController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      appBar: AppBar(
        backgroundColor: GirviColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            GirviDetailsPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'नूतनीकरण',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Renewal',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
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
                    _CurrentContractCard(
                      girviId: _oldGirviId,
                      outstanding: _currentOutstanding,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      titleMr: 'नवीन अटी',
                      titleEn: 'New Terms',
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'नवीन कर्ज रक्कम',
                      labelEn: 'New Loan Amount',
                      controller: _newAmountController,
                      prefix: '₹',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            labelMr: 'व्याज दर',
                            labelEn: 'Interest Rate',
                            controller: _rateController,
                            suffix: '%',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InputField(
                            labelMr: 'महिने',
                            labelEn: 'Months',
                            controller: _monthsController,
                            suffix: 'mo',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _RenewalSummary(
                      principal: _newAmount,
                      interest: _newInterest,
                      totalDue: _totalDue,
                      months: _months,
                    ),
                    const SizedBox(height: 16),
                    _InfoBox(
                      textMr:
                          'नूतनीकरण जुना करार बंद करते आणि नवीन करार तयार करते.',
                      textEn:
                          'Renewal closes the old contract and creates a new linked contract.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GirviColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // TODO: create renewal contract and generate receipt.
                    AppNavigation.popOrGoNamed(
                      context,
                      GirviDetailsPage.routeName,
                    );
                  },
                  icon: const Icon(Icons.receipt_long_outlined, size: 20),
                  label: const Text(
                    'नूतनीकरण करा / Renew Contract',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentContractCard extends StatelessWidget {
  const _CurrentContractCard({
    required this.girviId,
    required this.outstanding,
  });

  final String girviId;
  final double outstanding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GirviColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            girviId,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GirviColors.gold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'सध्याचे बाकी / Current Outstanding',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${outstanding.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: GirviColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: GirviColors.muted,
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.labelMr,
    required this.labelEn,
    required this.controller,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final TextEditingController controller;
  final String? prefix;
  final String? suffix;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 11,
              color: GirviColors.muted,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixText: prefix,
              suffixText: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _RenewalSummary extends StatelessWidget {
  const _RenewalSummary({
    required this.principal,
    required this.interest,
    required this.totalDue,
    required this.months,
  });

  final double principal;
  final double interest;
  final double totalDue;
  final int months;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'नूतनीकरण सारांश / Renewal Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GirviColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            labelMr: 'मूळ रक्कम',
            labelEn: 'Principal',
            value: '₹ ${principal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            labelMr: 'व्याज ($months महिने)',
            labelEn: 'Interest ($months months)',
            value: '₹ ${interest.toStringAsFixed(2)}',
            valueColor: GirviColors.gold,
          ),
          const Divider(height: 24, color: GirviColors.line),
          _SummaryRow(
            labelMr: 'एकूण देय',
            labelEn: 'Total Due',
            value: '₹ ${totalDue.toStringAsFixed(2)}',
            valueColor: GirviColors.navy,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    this.valueColor = GirviColors.ink,
    this.isBold = false,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelMr,
              style: const TextStyle(
                fontSize: 13,
                color: GirviColors.ink,
              ),
            ),
            Text(
              labelEn,
              style: const TextStyle(
                fontSize: 11,
                color: GirviColors.muted,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.textMr, required this.textEn});

  final String textMr;
  final String textEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GirviColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.gold.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: GirviColors.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textMr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: GirviColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  textEn,
                  style: TextStyle(
                    fontSize: 12,
                    color: GirviColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
