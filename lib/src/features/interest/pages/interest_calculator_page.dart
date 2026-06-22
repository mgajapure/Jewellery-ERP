import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../theme/interest_colors.dart';

/// SCR-032 Interest Calculator
///
/// Calculates real-time interest for a Girvi contract. Used during Girvi
/// creation, payment, renewal, redemption, and reporting.
class InterestCalculatorPage extends StatefulWidget {
  const InterestCalculatorPage({super.key});

  static const routeName = 'interest-calculator';

  @override
  State<InterestCalculatorPage> createState() => _InterestCalculatorPageState();
}

class _InterestCalculatorPageState extends State<InterestCalculatorPage> {
  String _interestType = 'Simple';
  final TextEditingController _principalController =
      TextEditingController(text: '100000');
  final TextEditingController _rateController =
      TextEditingController(text: '12');
  final TextEditingController _daysController =
      TextEditingController(text: '180');

  final List<String> _interestTypes = const [
    'Simple',
    'Katmiti',
    'Daily',
  ];

  double get _principal {
    return double.tryParse(_principalController.text) ?? 0;
  }

  double get _rate {
    return double.tryParse(_rateController.text) ?? 0;
  }

  int get _days {
    return int.tryParse(_daysController.text) ?? 0;
  }

  double get _accruedInterest {
    if (_principal <= 0 || _rate <= 0 || _days <= 0) return 0;
    return (_principal * _rate * _days) / 36500;
  }

  double get _penalty {
    if (_days <= 180) return 0;
    final overdueDays = _days - 180;
    return (_principal * 2 * overdueDays) / 36500;
  }

  double get _totalDue {
    return _principal + _accruedInterest + _penalty;
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _recalculate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InterestColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'व्याज कॅल्क्युलेटर',
              titleEn: 'Interest Calculator',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                      titleMr: 'कर्ज माहिती',
                      titleEn: 'Loan Information',
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'मूळ रक्कम',
                      labelEn: 'Principal Amount',
                      controller: _principalController,
                      prefix: '₹',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _recalculate(),
                    ),
                    const SizedBox(height: 12),
                    _InterestTypeSelector(
                      types: _interestTypes,
                      selected: _interestType,
                      onSelected: (type) {
                        setState(() => _interestType = type);
                      },
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'व्याज दर',
                      labelEn: 'Interest Rate',
                      controller: _rateController,
                      suffix: '% p.a.',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _recalculate(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            labelMr: 'दिवस',
                            labelEn: 'Days',
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _recalculate(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatePickerField(
                            labelMr: 'सुरुवातीची तारीख',
                            labelEn: 'Start Date',
                            value: '01 Jan 2026',
                            onTap: () {
                              // TODO: open date picker.
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _ResultCard(
                      principal: _principal,
                      interest: _accruedInterest,
                      penalty: _penalty,
                      totalDue: _totalDue,
                    ),
                    const SizedBox(height: 24),
                    _InfoBox(
                      textMr:
                          'गणना अचूकपणे तपासा. सर्व व्याज नोंदी अचल असतात.',
                      textEn:
                          'Verify calculations carefully. All interest records are immutable.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: save interest snapshot.
                      },
                      icon: const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Save'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: InterestColors.navy,
                        side: const BorderSide(color: InterestColors.navy),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _recalculate,
                        icon: const Icon(Icons.calculate_outlined, size: 20),
                        label: const Text(
                          'गणना करा / Calculate',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: InterestColors.navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: InterestColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: InterestColors.muted,
            fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InterestColors.line),
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
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 11,
              color: InterestColors.muted,
              fontWeight: FontWeight.w700,
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

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.onTap,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: InterestColors.line),
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
            Text(
              '$labelMr / $labelEn',
              style: const TextStyle(
                fontSize: 11,
                color: InterestColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: InterestColors.ink,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: InterestColors.navy,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestTypeSelector extends StatelessWidget {
  const _InterestTypeSelector({
    required this.types,
    required this.selected,
    required this.onSelected,
  });

  final List<String> types;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InterestColors.line),
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
          const Text(
            'व्याज प्रकार / Interest Type',
            style: TextStyle(
              fontSize: 11,
              color: InterestColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: types.map((type) {
              final isSelected = type == selected;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) => onSelected(type),
                    selectedColor: InterestColors.navy,
                    backgroundColor: InterestColors.screenBg,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : InterestColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? InterestColors.navy
                            : InterestColors.line,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.principal,
    required this.interest,
    required this.penalty,
    required this.totalDue,
  });

  final double principal;
  final double interest;
  final double penalty;
  final double totalDue;

  String _format(double value) {
    return '₹ ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: InterestColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'गणना निकाल / Calculation Result',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _ResultRow(
            labelMr: 'मूळ रक्कम',
            labelEn: 'Principal',
            value: _format(principal),
          ),
          const Divider(color: Colors.white24, height: 24),
          _ResultRow(
            labelMr: 'एकत्रित व्याज',
            labelEn: 'Accrued Interest',
            value: _format(interest),
            valueColor: InterestColors.gold,
          ),
          const SizedBox(height: 12),
          _ResultRow(
            labelMr: 'दंड व्याज',
            labelEn: 'Penalty',
            value: _format(penalty),
            valueColor: InterestColors.red,
          ),
          const Divider(color: Colors.white24, height: 24),
          _ResultRow(
            labelMr: 'एकूण देय',
            labelEn: 'Total Due',
            value: _format(totalDue),
            valueColor: InterestColors.gold,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    this.valueColor = Colors.white,
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
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              labelEn,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
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
        color: InterestColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InterestColors.gold.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: InterestColors.gold,
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
                    fontWeight: FontWeight.w700,
                    color: InterestColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  textEn,
                  style: TextStyle(
                    fontSize: 12,
                    color: InterestColors.muted,
                    fontWeight: FontWeight.w600,
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
