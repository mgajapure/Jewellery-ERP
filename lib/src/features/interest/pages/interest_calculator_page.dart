import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../domain/entities/interest_calculation.dart';
import '../presentation/bloc/calculator_bloc.dart';
import '../presentation/bloc/calculator_event.dart';
import '../presentation/bloc/calculator_state.dart';
import '../theme/interest_colors.dart';

/// SCR-032 Interest Calculator
///
/// Calculates real-time interest for a Girvi contract. Supports Simple,
/// Katmiti (monthly compound), and Daily compound interest types with
/// optional penalty for days beyond 180.
class InterestCalculatorPage extends StatelessWidget {
  const InterestCalculatorPage({super.key});

  static const routeName = 'interest-calculator';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<CalculatorBloc>()..add(const CalculatorStarted()),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatefulWidget {
  const _CalculatorView();

  @override
  State<_CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<_CalculatorView> {
  late final TextEditingController _principalCtrl;
  late final TextEditingController _rateCtrl;
  late final TextEditingController _daysCtrl;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _principalCtrl = TextEditingController();
    _rateCtrl = TextEditingController();
    _daysCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _principalCtrl.dispose();
    _rateCtrl.dispose();
    _daysCtrl.dispose();
    super.dispose();
  }

  void _syncControllersFrom(CalculatorReady state) {
    if (!_initialized) {
      _principalCtrl.text = state.principal.toStringAsFixed(0);
      _rateCtrl.text = state.ratePercent.toStringAsFixed(0);
      _daysCtrl.text = state.days.toString();
      _initialized = true;
    }
  }

  void _onPrincipalChanged(String v) {
    context.read<CalculatorBloc>().add(
          CalculatorInputChanged(principal: double.tryParse(v)),
        );
  }

  void _onRateChanged(String v) {
    context.read<CalculatorBloc>().add(
          CalculatorInputChanged(ratePercent: double.tryParse(v)),
        );
  }

  void _onDaysChanged(String v) {
    context.read<CalculatorBloc>().add(
          CalculatorInputChanged(days: int.tryParse(v)),
        );
  }

  void _onTypeSelected(InterestType type) {
    context
        .read<CalculatorBloc>()
        .add(CalculatorInputChanged(interestType: type));
  }

  Future<void> _pickDate(CalculatorReady state) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'सुरुवातीची तारीख निवडा',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: InterestColors.navy,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      context
          .read<CalculatorBloc>()
          .add(CalculatorInputChanged(startDate: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InterestColors.screenBg,
      body: SafeArea(
        child: BlocBuilder<CalculatorBloc, CalculatorState>(
          builder: (context, state) {
            if (state is! CalculatorReady) {
              return const Center(child: CircularProgressIndicator());
            }
            _syncControllersFrom(state);
            return Column(
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
                        const _SectionTitle(
                          titleMr: 'कर्ज माहिती',
                          titleEn: 'Loan Information',
                        ),
                        const SizedBox(height: 12),
                        _InputField(
                          labelMr: 'मूळ रक्कम',
                          labelEn: 'Principal Amount',
                          controller: _principalCtrl,
                          prefix: '₹',
                          onChanged: _onPrincipalChanged,
                        ),
                        const SizedBox(height: 12),
                        _InterestTypeSelector(
                          selected: state.interestType,
                          onSelected: _onTypeSelected,
                        ),
                        const SizedBox(height: 12),
                        _InputField(
                          labelMr: 'व्याज दर',
                          labelEn: 'Interest Rate',
                          controller: _rateCtrl,
                          suffix: '% p.a.',
                          onChanged: _onRateChanged,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _InputField(
                                labelMr: 'दिवस',
                                labelEn: 'Days',
                                controller: _daysCtrl,
                                onChanged: _onDaysChanged,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DatePickerField(
                                labelMr: 'सुरुवातीची तारीख',
                                labelEn: 'Start Date',
                                value: DateFormat('dd MMM yyyy')
                                    .format(state.startDate),
                                onTap: () => _pickDate(state),
                              ),
                            ),
                          ],
                        ),
                        if (state.result != null) ...[
                          const SizedBox(height: 24),
                          _ResultCard(result: state.result!),
                        ],
                        const SizedBox(height: 24),
                        const _FormulaInfoBox(interestType: null),
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
                            // Navigate to ledger page
                          },
                          icon:
                              const Icon(Icons.receipt_long_outlined, size: 18),
                          label: const Text('Ledger'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: InterestColors.navy,
                            side:
                                const BorderSide(color: InterestColors.navy),
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
                            onPressed: () => context
                                .read<CalculatorBloc>()
                                .add(const CalculatorRecalculate()),
                            icon: const Icon(Icons.calculate_outlined,
                                size: 20),
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
            );
          },
        ),
      ),
    );
  }
}

// ─── Widgets ────────────────────────────────────────────────────────────────

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
    this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final TextEditingController controller;
  final String? prefix;
  final String? suffix;
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
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixText: prefix,
              suffixText: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: InterestColors.ink,
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
    required this.selected,
    required this.onSelected,
  });

  final InterestType selected;
  final ValueChanged<InterestType> onSelected;

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
            children: InterestType.values.map((type) {
              final isSelected = type == selected;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          type.labelMr,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.white
                                : InterestColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          type.labelEn,
                          style: TextStyle(
                            fontSize: 9,
                            color: isSelected
                                ? Colors.white70
                                : InterestColors.muted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => onSelected(type),
                    selectedColor: InterestColors.navy,
                    backgroundColor: InterestColors.screenBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? InterestColors.navy
                            : InterestColors.line,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
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
  const _ResultCard({required this.result});

  final InterestCalculation result;

  String _fmt(double v) => '₹ ${_currencyFmt.format(v)}';

  static final _currencyFmt = NumberFormat('#,##,##0.00', 'en_IN');

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'गणना निकाल / Calculation Result',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _TypeBadge(result.interestType),
            ],
          ),
          const SizedBox(height: 16),
          _ResultRow(
            labelMr: 'मूळ रक्कम',
            labelEn: 'Principal',
            value: _fmt(result.principal),
          ),
          const Divider(color: Colors.white24, height: 24),
          _ResultRow(
            labelMr: 'एकत्रित व्याज',
            labelEn: 'Accrued Interest',
            value: _fmt(result.accruedInterest),
            valueColor: InterestColors.gold,
          ),
          if (result.penaltyInterest > 0) ...[
            const SizedBox(height: 12),
            _ResultRow(
              labelMr: 'दंड व्याज (${result.days - 180} अतिरिक्त दिवस)',
              labelEn: 'Penalty (overdue)',
              value: _fmt(result.penaltyInterest),
              valueColor: InterestColors.red,
            ),
          ],
          const Divider(color: Colors.white24, height: 24),
          _ResultRow(
            labelMr: 'एकूण देय',
            labelEn: 'Total Due',
            value: _fmt(result.totalDue),
            valueColor: InterestColors.gold,
            isBold: true,
          ),
          const SizedBox(height: 8),
          Text(
            '${result.days} दिवस · ${result.ratePercent}% p.a.',
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge(this.type);

  final InterestType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: InterestColors.gold.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: InterestColors.gold.withAlpha(80)),
      ),
      child: Text(
        type.labelEn,
        style: const TextStyle(
          fontSize: 11,
          color: InterestColors.gold,
          fontWeight: FontWeight.w700,
        ),
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
        Expanded(
          child: Column(
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

class _FormulaInfoBox extends StatelessWidget {
  const _FormulaInfoBox({required this.interestType});

  final InterestType? interestType;

  String get _formulaMr {
    switch (interestType) {
      case InterestType.katmiti:
        return 'मासिक चक्रवाढ: P × ((1 + R/1200)^महिने - 1)';
      case InterestType.daily:
        return 'दैनिक चक्रवाढ: P × ((1 + R/36500)^दिवस - 1)';
      default:
        return 'साधे व्याज: P × R × T / 36500';
    }
  }

  String get _formulaEn {
    switch (interestType) {
      case InterestType.katmiti:
        return 'Monthly compound: P × ((1 + R/1200)^months − 1)';
      case InterestType.daily:
        return 'Daily compound: P × ((1 + R/36500)^days − 1)';
      default:
        return 'Simple interest: P × R × T / 36500';
    }
  }

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
          const Icon(
            Icons.functions_outlined,
            size: 20,
            color: InterestColors.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formulaMr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: InterestColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formulaEn,
                  style: const TextStyle(
                    fontSize: 11,
                    color: InterestColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'दंड: 180 दिवसांनंतर 2% p.a. अतिरिक्त · Penalty: 2% p.a. after 180 days',
                  style: TextStyle(
                    fontSize: 10,
                    color: InterestColors.red,
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
