import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/girvi_colors.dart';

/// SCR-028 Partial Payment
///
/// Records a partial payment against a Girvi contract. Validates that the
/// payment amount does not exceed the outstanding balance.
class PartialPaymentPage extends StatefulWidget {
  const PartialPaymentPage({super.key});

  static const routeName = 'partial-payment';

  @override
  State<PartialPaymentPage> createState() => _PartialPaymentPageState();
}

class _PartialPaymentPageState extends State<PartialPaymentPage> {
  String _paymentMode = 'Cash';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final double _outstanding = 100917.81;
  final double _accruedInterest = 5917.81;

  final List<String> _paymentModes = const [
    'Cash',
    'UPI',
    'Bank Transfer',
    'Cheque',
  ];

  double get _enteredAmount {
    return double.tryParse(_amountController.text) ?? 0;
  }

  bool get _isValid {
    return _enteredAmount > 0 && _enteredAmount <= _outstanding;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarksController.dispose();
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
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'आंशिक पेमेंट',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Partial Payment',
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
                    _OutstandingCard(
                      outstanding: _outstanding,
                      accruedInterest: _accruedInterest,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      titleMr: 'पेमेंट तपशील',
                      titleEn: 'Payment Details',
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'रक्कम',
                      labelEn: 'Amount',
                      controller: _amountController,
                      prefix: '₹',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    _PaymentModeSelector(
                      modes: _paymentModes,
                      selected: _paymentMode,
                      onSelected: (mode) {
                        setState(() => _paymentMode = mode);
                      },
                    ),
                    const SizedBox(height: 12),
                    _InputField(
                      labelMr: 'शेरा',
                      labelEn: 'Remarks',
                      controller: _remarksController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    if (_enteredAmount > _outstanding)
                      _ErrorMessage(
                        textMr: 'रक्कम बाकी रकमेपेक्षा जास्त असू शकत नाही.',
                        textEn: 'Amount cannot exceed outstanding balance.',
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GirviColors.navy,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GirviColors.line,
                    disabledForegroundColor: GirviColors.muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isValid
                      ? () {
                          // TODO: record payment and generate receipt.
                          context.pop();
                        }
                      : null,
                  child: const Text(
                    'पेमेंट नोंदा / Record Payment',
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

class _OutstandingCard extends StatelessWidget {
  const _OutstandingCard({
    required this.outstanding,
    required this.accruedInterest,
  });

  final double outstanding;
  final double accruedInterest;

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
          const Text(
            'एकूण बाकी / Total Outstanding',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹ ${outstanding.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: GirviColors.gold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'एकत्रित व्याज / Accrued Interest: ₹ ${accruedInterest.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
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
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final TextEditingController controller;
  final String? prefix;
  final TextInputType? keyboardType;
  final int maxLines;
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
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixText: prefix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentModeSelector extends StatelessWidget {
  const _PaymentModeSelector({
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> modes;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'पेमेंट पद्धत / Payment Mode',
            style: TextStyle(
              fontSize: 11,
              color: GirviColors.muted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: modes.map((mode) {
              final isSelected = mode == selected;
              return ChoiceChip(
                label: Text(mode),
                selected: isSelected,
                onSelected: (_) => onSelected(mode),
                selectedColor: GirviColors.navy,
                backgroundColor: GirviColors.screenBg,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : GirviColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected ? GirviColors.navy : GirviColors.line,
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

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.textMr, required this.textEn});

  final String textMr;
  final String textEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GirviColors.red.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.red.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textMr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: GirviColors.red,
            ),
          ),
          Text(
            textEn,
            style: TextStyle(
              fontSize: 12,
              color: GirviColors.red.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}
