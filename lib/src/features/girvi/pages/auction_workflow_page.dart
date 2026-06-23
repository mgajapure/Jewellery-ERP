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

class AuctionWorkflowPage extends StatelessWidget {
  const AuctionWorkflowPage({super.key});

  static const routeName = 'auction-workflow';

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    return BlocProvider(
      create: (_) => getIt<GirviDetailBloc>()..add(LoadGirviDetail(id)),
      child: const _AuctionWorkflowView(),
    );
  }
}

class _AuctionWorkflowView extends StatefulWidget {
  const _AuctionWorkflowView();

  @override
  State<_AuctionWorkflowView> createState() => _AuctionWorkflowViewState();
}

class _AuctionWorkflowViewState extends State<_AuctionWorkflowView> {
  final _saleAmountController = TextEditingController();
  final _buyerNameController = TextEditingController();
  final _buyerMobileController = TextEditingController();
  int _currentStep = 0;

  static final _fmt = NumberFormat('#,##,##0.00', 'en_IN');

  static const _steps = [
    (Icons.description_outlined, 'सूचना तयार करा', 'Generate Notice'),
    (Icons.notification_add_outlined, 'कर्जदाराला सूचित करा', 'Notify Borrower'),
    (Icons.local_shipping_outlined, 'वितरण ट्रॅक करा', 'Track Delivery'),
    (Icons.timer_outlined, 'कायदेशीर कालावधी पूर्ण करा', 'Wait Statutory Period'),
    (Icons.event_outlined, 'लिलाव नियोजित करा', 'Schedule Auction'),
    (Icons.gavel_outlined, 'विक्री नोंदवा', 'Record Sale'),
  ];

  @override
  void dispose() {
    _saleAmountController.dispose();
    _buyerNameController.dispose();
    _buyerMobileController.dispose();
    super.dispose();
  }

  double get _saleAmount => double.tryParse(_saleAmountController.text) ?? 0;

  double _surplus(Girvi girvi) =>
      _saleAmount - (girvi.outstandingAmount + girvi.penaltyAmount);

  bool get _canCompleteAuction =>
      _currentStep >= 5 &&
      _saleAmount > 0 &&
      _buyerNameController.text.trim().isNotEmpty;

  void _submit(BuildContext context, Girvi girvi) {
    context.read<GirviDetailBloc>().add(
          CompleteGirviAuction(
            girviId: girvi.id,
            request: AuctionRequest(
              saleAmount: _saleAmount,
              buyerName: _buyerNameController.text.trim(),
              buyerMobile: _buyerMobileController.text.trim().isEmpty
                  ? null
                  : _buyerMobileController.text.trim(),
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
              onRetry: () =>
                  context.read<GirviDetailBloc>().add(LoadGirviDetail(id)),
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
                        _HeaderCard(girvi: girvi, fmt: _fmt),
                        const SizedBox(height: 20),
                        const _SectionTitle(
                          titleMr: 'लिलाव पायऱ्या',
                          titleEn: 'Auction Steps',
                        ),
                        const SizedBox(height: 12),
                        ..._steps.asMap().entries.map((entry) {
                          final index = entry.key;
                          final step = entry.value;
                          return _StepTile(
                            index: index,
                            icon: step.$1,
                            titleMr: step.$2,
                            titleEn: step.$3,
                            isActive: index == _currentStep,
                            isCompleted: index < _currentStep,
                            onTap: isSubmitting
                                ? null
                                : () => setState(
                                    () => _currentStep = index + 1),
                          );
                        }),
                        const SizedBox(height: 20),
                        _SaleForm(
                          saleAmountController: _saleAmountController,
                          buyerNameController: _buyerNameController,
                          buyerMobileController: _buyerMobileController,
                          enabled: !isSubmitting,
                          onChanged: () => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        _SurplusCard(
                          saleAmount: _saleAmount,
                          outstanding: girvi.outstandingAmount,
                          penalty: girvi.penaltyAmount,
                          surplus: _surplus(girvi),
                          fmt: _fmt,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSubmitting)
                  const LinearProgressIndicator(
                    backgroundColor: GirviColors.line,
                    color: GirviColors.red,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GirviColors.red,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: GirviColors.line,
                        disabledForegroundColor: GirviColors.muted,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: (!isSubmitting && _canCompleteAuction)
                          ? () => _submit(context, girvi)
                          : null,
                      icon: isSubmitting
                          ? const _ButtonLoader()
                          : const Icon(Icons.gavel_outlined, size: 20),
                      label: const Text(
                        'लिलाव पूर्ण करा / Complete Auction',
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
            'लिलाव कार्यपद्धती',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'Auction Workflow',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.girvi, required this.fmt});

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
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeaderItem(
                  label: 'Outstanding',
                  value: '₹ ${fmt.format(girvi.outstandingAmount)}',
                ),
              ),
              Expanded(
                child: _HeaderItem(
                  label: 'Penalty',
                  value: '₹ ${fmt.format(girvi.penaltyAmount)}',
                  valueColor: GirviColors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'पूर्वअटी: मुदतीपूर्व & १४ दिवसांची सूचना पाठवली',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const Text(
            'Preconditions: Overdue & 14-day notice sent',
            style: TextStyle(fontSize: 10, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
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

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.isActive,
    required this.isCompleted,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String titleMr;
  final String titleEn;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color circleColor;
    final IconData trailingIcon;
    if (isCompleted) {
      circleColor = GirviColors.green;
      trailingIcon = Icons.check;
    } else if (isActive) {
      circleColor = GirviColors.gold;
      trailingIcon = Icons.chevron_right;
    } else {
      circleColor = GirviColors.line;
      trailingIcon = Icons.lock_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : GirviColors.screenBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? GirviColors.gold : GirviColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: circleColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(trailingIcon, size: 18, color: GirviColors.green)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? GirviColors.gold
                                : GirviColors.muted,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleMr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isActive ? GirviColors.ink : GirviColors.muted,
                      ),
                    ),
                    Text(
                      titleEn,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? GirviColors.muted
                            : GirviColors.muted.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                trailingIcon,
                size: 18,
                color: isActive ? GirviColors.gold : GirviColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaleForm extends StatelessWidget {
  const _SaleForm({
    required this.saleAmountController,
    required this.buyerNameController,
    required this.buyerMobileController,
    required this.enabled,
    required this.onChanged,
  });

  final TextEditingController saleAmountController;
  final TextEditingController buyerNameController;
  final TextEditingController buyerMobileController;
  final bool enabled;
  final VoidCallback onChanged;

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
            'विक्री तपशील / Sale Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: GirviColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _InputField(
            labelMr: 'विक्री रक्कम',
            labelEn: 'Sale Amount',
            controller: saleAmountController,
            prefix: '₹',
            keyboardType: TextInputType.number,
            enabled: enabled,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          _InputField(
            labelMr: 'खरेदीदाराचे नाव',
            labelEn: 'Buyer Name',
            controller: buyerNameController,
            enabled: enabled,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          _InputField(
            labelMr: 'खरेदीदाराचा मोबाईल',
            labelEn: 'Buyer Mobile',
            controller: buyerMobileController,
            keyboardType: TextInputType.phone,
            enabled: enabled,
          ),
        ],
      ),
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
    this.enabled = true,
    this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final TextEditingController controller;
  final String? prefix;
  final TextInputType? keyboardType;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? GirviColors.screenBg : GirviColors.line,
        borderRadius: BorderRadius.circular(12),
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
            enabled: enabled,
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

class _SurplusCard extends StatelessWidget {
  const _SurplusCard({
    required this.saleAmount,
    required this.outstanding,
    required this.penalty,
    required this.surplus,
    required this.fmt,
  });

  final double saleAmount;
  final double outstanding;
  final double penalty;
  final double surplus;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final isSurplus = surplus >= 0;
    final color = isSurplus ? GirviColors.green : GirviColors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSurplus ? 'अधिक रक्कम / Surplus' : 'तूट रक्कम / Shortfall',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹ ${fmt.format(surplus.abs())}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sale ₹${fmt.format(saleAmount)} − Outstanding ₹${fmt.format(outstanding)} − Penalty ₹${fmt.format(penalty)}',
            style: const TextStyle(fontSize: 11, color: GirviColors.muted),
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
