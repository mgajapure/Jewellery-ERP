import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/girvi.dart';
import '../domain/repositories/girvi_repository.dart';
import '../presentation/bloc/girvi_detail_bloc.dart';
import '../presentation/bloc/girvi_detail_event.dart';
import '../presentation/bloc/girvi_detail_state.dart';
import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

class RenewalPage extends StatelessWidget {
  const RenewalPage({super.key});

  static const routeName = 'renewal';

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    return BlocProvider(
      create: (_) => getIt<GirviDetailBloc>()..add(LoadGirviDetail(id)),
      child: const _RenewalView(),
    );
  }
}

class _RenewalView extends StatefulWidget {
  const _RenewalView();

  @override
  State<_RenewalView> createState() => _RenewalViewState();
}

class _RenewalViewState extends State<_RenewalView> {
  final _newAmountController = TextEditingController();
  final _rateController = TextEditingController();
  final _monthsController = TextEditingController(text: '12');
  InterestType _interestType = InterestType.simple;
  bool _initialized = false;

  static final _fmt = NumberFormat('#,##,##0.00', 'en_IN');

  @override
  void dispose() {
    _newAmountController.dispose();
    _rateController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  void _prefillFrom(Girvi girvi) {
    if (_initialized) return;
    _newAmountController.text = girvi.outstandingAmount.toStringAsFixed(0);
    _rateController.text = girvi.interestRate.toStringAsFixed(1);
    _interestType = girvi.interestType;
    _initialized = true;
  }

  double get _newAmount => double.tryParse(_newAmountController.text) ?? 0;
  double get _rate => double.tryParse(_rateController.text) ?? 0;
  int get _months => int.tryParse(_monthsController.text) ?? 0;

  double get _projectedInterest {
    if (_newAmount <= 0 || _months <= 0) return 0;
    return (_newAmount * _rate * _months) / 1200;
  }

  bool get _isValid => _newAmount > 0 && _rate > 0 && _months > 0;

  void _submit(BuildContext context, Girvi girvi) {
    context.read<GirviDetailBloc>().add(
          RenewGirviRequested(
            girviId: girvi.id,
            request: RenewalRequest(
              newLoanAmount: _newAmount,
              interestRate: _rate,
              months: _months,
              interestType: _interestType,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GirviDetailBloc, GirviDetailState>(
      listener: (context, state) {
        if (state is GirviDetailLoaded && !_initialized) {
          setState(() => _prefillFrom(state.girvi));
        }
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
            appBar: _NavBar(onBack: () => _navigateBack(context, null)),
            body: const AppLoader(message: 'लोड होत आहे...'),
          );
        }

        if (state is GirviDetailError) {
          final id = GoRouterState.of(context).pathParameters['id']!;
          return Scaffold(
            backgroundColor: GirviColors.screenBg,
            appBar: _NavBar(onBack: () => _navigateBack(context, id)),
            body: AppErrorState(
              message: state.message,
              onRetry: () => context
                  .read<GirviDetailBloc>()
                  .add(LoadGirviDetail(id)),
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
          appBar: _NavBar(onBack: () => _navigateBack(context, girvi.id)),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CurrentContractCard(girvi: girvi, fmt: _fmt),
                        const SizedBox(height: 20),
                        const _SectionTitle(
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
                        const SizedBox(height: 12),
                        _InterestTypeSelector(
                          selected: _interestType,
                          onSelected: (t) => setState(() => _interestType = t),
                        ),
                        const SizedBox(height: 20),
                        _RenewalSummary(
                          principal: _newAmount,
                          interest: _projectedInterest,
                          totalDue: _newAmount + _projectedInterest,
                          months: _months,
                          fmt: _fmt,
                        ),
                        const SizedBox(height: 16),
                        const _InfoBox(
                          textMr:
                              'नूतनीकरण जुना करार बंद करते आणि नवीन करार तयार करते.',
                          textEn:
                              'Renewal closes the old contract and creates a new linked contract.',
                        ),
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
                    child: ElevatedButton.icon(
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
                      onPressed: (!isSubmitting && _isValid)
                          ? () => _submit(context, girvi)
                          : null,
                      icon: isSubmitting
                          ? const _ButtonLoader()
                          : const Icon(Icons.receipt_long_outlined, size: 20),
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

class _NavBar extends StatelessWidget implements PreferredSizeWidget {
  const _NavBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: GirviColors.navy,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
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
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _CurrentContractCard extends StatelessWidget {
  const _CurrentContractCard({required this.girvi, required this.fmt});

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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GirviColors.gold,
            ),
          ),
          Text(
            girvi.customerNameEn,
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          const Text(
            'सध्याचे बाकी / Current Outstanding',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${fmt.format(girvi.outstandingAmount)}',
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
            style: const TextStyle(fontSize: 11, color: GirviColors.muted),
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

class _InterestTypeSelector extends StatelessWidget {
  const _InterestTypeSelector({
    required this.selected,
    required this.onSelected,
  });

  final InterestType selected;
  final ValueChanged<InterestType> onSelected;

  static const _types = [
    (InterestType.simple, 'Simple'),
    (InterestType.katmiti, 'Katmiti'),
    (InterestType.daily, 'Daily'),
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
            'व्याज प्रकार / Interest Type',
            style: TextStyle(fontSize: 11, color: GirviColors.muted),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types.map((entry) {
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

class _RenewalSummary extends StatelessWidget {
  const _RenewalSummary({
    required this.principal,
    required this.interest,
    required this.totalDue,
    required this.months,
    required this.fmt,
  });

  final double principal;
  final double interest;
  final double totalDue;
  final int months;
  final NumberFormat fmt;

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
              fontWeight: FontWeight.w700,
              color: GirviColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            labelMr: 'मूळ रक्कम',
            labelEn: 'Principal',
            value: '₹ ${fmt.format(principal)}',
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            labelMr: 'व्याज ($months महिने)',
            labelEn: 'Interest ($months months)',
            value: '₹ ${fmt.format(interest)}',
            valueColor: GirviColors.gold,
          ),
          const Divider(height: 24, color: GirviColors.line),
          _SummaryRow(
            labelMr: 'एकूण देय',
            labelEn: 'Total Due',
            value: '₹ ${fmt.format(totalDue)}',
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
              style: const TextStyle(fontSize: 13, color: GirviColors.ink),
            ),
            Text(
              labelEn,
              style: const TextStyle(fontSize: 11, color: GirviColors.muted),
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
        border: Border.all(color: GirviColors.gold.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: GirviColors.gold),
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
                  style: const TextStyle(
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

class _ButtonLoader extends StatelessWidget {
  const _ButtonLoader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
    );
  }
}
