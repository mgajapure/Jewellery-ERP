import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_header.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/girvi.dart';
import '../domain/repositories/girvi_repository.dart';
import '../presentation/bloc/girvi_detail_bloc.dart';
import '../presentation/bloc/girvi_detail_event.dart';
import '../presentation/bloc/girvi_detail_state.dart';
import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

class PartialPaymentPage extends StatelessWidget {
  const PartialPaymentPage({super.key});

  static const routeName = 'partial-payment';

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    return BlocProvider(
      create: (_) => getIt<GirviDetailBloc>()..add(LoadGirviDetail(id)),
      child: const _PartialPaymentView(),
    );
  }
}

class _PartialPaymentView extends StatefulWidget {
  const _PartialPaymentView();

  @override
  State<_PartialPaymentView> createState() => _PartialPaymentViewState();
}

class _PartialPaymentViewState extends State<_PartialPaymentView> {
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _remarksController = TextEditingController();
  PaymentType _paymentType = PaymentType.cash;

  static final _fmt = NumberFormat('#,##,##0.00', 'en_IN');

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  double get _enteredAmount => double.tryParse(_amountController.text) ?? 0;

  bool _isValid(double outstanding) =>
      _enteredAmount > 0 && _enteredAmount <= outstanding;

  bool get _needsReference =>
      _paymentType == PaymentType.upi ||
      _paymentType == PaymentType.bankTransfer ||
      _paymentType == PaymentType.cheque;

  void _submit(BuildContext context, Girvi girvi) {
    context.read<GirviDetailBloc>().add(
          MakeGirviPayment(
            girviId: girvi.id,
            request: PaymentRequest(
              amount: _enteredAmount,
              paymentType: _paymentType,
              referenceNumber: _referenceController.text.trim().isEmpty
                  ? null
                  : _referenceController.text.trim(),
              notes: _remarksController.text.trim().isEmpty
                  ? null
                  : _remarksController.text.trim(),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GirviDetailBloc, GirviDetailState>(
      listener: (context, state) {
        if (state is GirviOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: GirviColors.green,
            ),
          );
          AppNavigation.popOrGoNamed(
            context,
            GirviDetailsPage.routeName,
            pathParameters: {'id': state.girvi.id},
          );
        } else if (state is GirviOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: GirviColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GirviDetailInitial || state is GirviDetailLoading) {
          return Scaffold(
            backgroundColor: GirviColors.screenBg,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    titleMr: 'आंशिक पेमेंट',
                    titleEn: 'Partial Payment',
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF071A49)),
                      onPressed: () => _navigateBack(context, null),
                    ),
                  ),
                  const Expanded(child: AppLoader(message: 'लोड होत आहे...')),
                ],
              ),
            ),
          );
        }

        if (state is GirviDetailError) {
          final id = GoRouterState.of(context).pathParameters['id']!;
          return Scaffold(
            backgroundColor: GirviColors.screenBg,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    titleMr: 'आंशिक पेमेंट',
                    titleEn: 'Partial Payment',
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF071A49)),
                      onPressed: () => _navigateBack(context, id),
                    ),
                  ),
                  Expanded(
                    child: AppErrorState(
                      message: state.message,
                      onRetry: () => context
                          .read<GirviDetailBloc>()
                          .add(LoadGirviDetail(id)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final Girvi girvi;
        final bool isSubmitting;
        if (state is GirviDetailLoaded) {
          girvi = state.girvi;
          isSubmitting = false;
        } else if (state is GirviOperationLoading) {
          girvi = state.girvi;
          isSubmitting = true;
        } else if (state is GirviOperationFailure) {
          girvi = state.girvi;
          isSubmitting = false;
        } else {
          girvi = (state as GirviOperationSuccess).girvi;
          isSubmitting = false;
        }

        return Scaffold(
          backgroundColor: GirviColors.screenBg,
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  titleMr: 'आंशिक पेमेंट',
                  titleEn: 'Partial Payment',
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF071A49)),
                    onPressed: () => _navigateBack(context, girvi.id),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OutstandingCard(girvi: girvi, fmt: _fmt),
                        const SizedBox(height: 20),
                        const _SectionTitle(
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
                          selected: _paymentType,
                          onSelected: (t) => setState(() => _paymentType = t),
                        ),
                        if (_needsReference) ...[
                          const SizedBox(height: 12),
                          _InputField(
                            labelMr: 'संदर्भ क्रमांक',
                            labelEn: 'Reference Number',
                            controller: _referenceController,
                          ),
                        ],
                        const SizedBox(height: 12),
                        _InputField(
                          labelMr: 'शेरा',
                          labelEn: 'Remarks',
                          controller: _remarksController,
                          maxLines: 3,
                        ),
                        if (_enteredAmount > girvi.outstandingAmount) ...[
                          const SizedBox(height: 16),
                          _ErrorBanner(
                            textMr: 'रक्कम बाकी रकमेपेक्षा जास्त असू शकत नाही.',
                            textEn:
                                'Amount cannot exceed outstanding balance of ₹${_fmt.format(girvi.outstandingAmount)}.',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (isSubmitting)
                  const LinearProgressIndicator(
                    backgroundColor: GirviColors.line,
                    color: GirviColors.navy,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GirviColors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: GirviColors.line,
                        disabledForegroundColor: GirviColors.muted,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: (!isSubmitting &&
                              _isValid(girvi.outstandingAmount))
                          ? () => _submit(context, girvi)
                          : null,
                      child: isSubmitting
                          ? const _ButtonLoader()
                          : const Text(
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
      },
    );
  }

  void _navigateBack(BuildContext context, String? girviId) {
    if (girviId != null) {
      AppNavigation.popOrGoNamed(
        context,
        GirviDetailsPage.routeName,
        pathParameters: {'id': girviId},
      );
    } else {
      AppNavigation.popOrGoNamed(context, GirviDetailsPage.routeName);
    }
  }
}

class _OutstandingCard extends StatelessWidget {
  const _OutstandingCard({required this.girvi, required this.fmt});

  final Girvi girvi;
  final NumberFormat fmt;

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
            girvi.serialId,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: GirviColors.gold,
            ),
          ),
          Text(
            girvi.customerNameEn,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          const Text(
            'एकूण बाकी / Total Outstanding',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${fmt.format(girvi.outstandingAmount)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: GirviColors.gold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'एकत्रित व्याज / Accrued Interest: ₹ ${fmt.format(girvi.accruedInterest)}',
            style: const TextStyle(fontSize: 13, color: Colors.white70),
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
            fontWeight: FontWeight.w700,
            color: GirviColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(fontSize: 12, color: GirviColors.muted),
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
            style: const TextStyle(fontSize: 11, color: GirviColors.muted),
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
    required this.selected,
    required this.onSelected,
  });

  final PaymentType selected;
  final ValueChanged<PaymentType> onSelected;

  static const _modes = [
    (PaymentType.cash, 'Cash'),
    (PaymentType.upi, 'UPI'),
    (PaymentType.bankTransfer, 'Bank Transfer'),
    (PaymentType.cheque, 'Cheque'),
  ];

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
            style: TextStyle(fontSize: 11, color: GirviColors.muted),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _modes.map((entry) {
              final isSelected = entry.$1 == selected;
              return ChoiceChip(
                label: Text(entry.$2),
                selected: isSelected,
                onSelected: (_) => onSelected(entry.$1),
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.textMr, required this.textEn});

  final String textMr;
  final String textEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GirviColors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.red.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textMr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: GirviColors.red,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            textEn,
            style: TextStyle(
              fontSize: 12,
              color: GirviColors.red.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonLoader extends StatelessWidget {
  const _ButtonLoader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}
