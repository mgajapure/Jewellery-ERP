import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/girvi.dart';
import '../presentation/bloc/girvi_detail_bloc.dart';
import '../presentation/bloc/girvi_detail_event.dart';
import '../presentation/bloc/girvi_detail_state.dart';
import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

class RedemptionPage extends StatelessWidget {
  const RedemptionPage({super.key});

  static const routeName = 'redemption';

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    return BlocProvider(
      create: (_) => getIt<GirviDetailBloc>()..add(LoadGirviDetail(id)),
      child: const _RedemptionView(),
    );
  }
}

class _RedemptionView extends StatefulWidget {
  const _RedemptionView();

  @override
  State<_RedemptionView> createState() => _RedemptionViewState();
}

class _RedemptionViewState extends State<_RedemptionView> {
  bool _fullPaymentReceived = false;
  bool _photoVerified = false;
  bool _vaultReleased = false;

  static final _fmt = NumberFormat('#,##,##0.00', 'en_IN');

  bool get _canRedeem =>
      _fullPaymentReceived && _photoVerified && _vaultReleased;

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
                        _HeaderCard(girvi: girvi, fmt: _fmt),
                        const SizedBox(height: 20),
                        const _SectionTitle(
                          titleMr: 'पूर्वप्रतिमा तपासणी',
                          titleEn: 'Redemption Checklist',
                        ),
                        const SizedBox(height: 12),
                        _ChecklistTile(
                          icon: Icons.currency_rupee,
                          titleMr: 'पूर्ण पेमेंट घेतले',
                          titleEn: 'Full Payment Received',
                          subtitle:
                              '₹ ${_fmt.format(girvi.outstandingAmount)}',
                          value: _fullPaymentReceived,
                          onChanged: isSubmitting
                              ? null
                              : (v) => setState(
                                  () => _fullPaymentReceived = v ?? false),
                        ),
                        const SizedBox(height: 10),
                        _ChecklistTile(
                          icon: Icons.photo_camera_outlined,
                          titleMr: 'वस्तू फोटो पडताळणी',
                          titleEn: 'Item Photo Verified',
                          subtitle: 'Capture returned item photos',
                          value: _photoVerified,
                          onChanged: isSubmitting
                              ? null
                              : (v) =>
                                  setState(() => _photoVerified = v ?? false),
                        ),
                        const SizedBox(height: 10),
                        _ChecklistTile(
                          icon: Icons.logout_outlined,
                          titleMr: 'तिजोरी मुक्त',
                          titleEn: 'Vault Released',
                          subtitle:
                              girvi.vaultLocation ?? 'No vault assigned',
                          value: _vaultReleased,
                          onChanged: isSubmitting
                              ? null
                              : (v) =>
                                  setState(() => _vaultReleased = v ?? false),
                        ),
                        const SizedBox(height: 24),
                        const _InfoBox(
                          textMr:
                              'मुद्दलपरत झाल्यानंतर सोने ७ कार्यदिवसांच्या आत ग्राहकाला परत करावे.',
                          textEn:
                              'After redemption, gold must be returned to the customer within 7 working days.',
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSubmitting)
                  const LinearProgressIndicator(
                    backgroundColor: GirviColors.line,
                    color: GirviColors.green,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
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
                      onPressed: (!isSubmitting && _canRedeem)
                          ? () => context
                              .read<GirviDetailBloc>()
                              .add(RedeemGirviRequested(girvi.id))
                          : null,
                      icon: isSubmitting
                          ? const _ButtonLoader()
                          : const Icon(Icons.check_circle_outline, size: 20),
                      label: const Text(
                        'मुद्दलपरत पूर्ण करा / Complete Redemption',
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
            'मुद्दलपरत',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'Redemption',
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
          const SizedBox(height: 4),
          Text(
            girvi.customerNameEn,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          Text(
            girvi.customerMobile,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          const Text(
            'पूर्ण पेमेंट देय / Full Payment Due',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${fmt.format(girvi.outstandingAmount)}',
            style: const TextStyle(
              fontSize: 26,
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

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value ? GirviColors.green.withValues(alpha: 0.3) : GirviColors.line,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: value
                  ? GirviColors.green.withValues(alpha: 0.08)
                  : GirviColors.screenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? GirviColors.green : GirviColors.navy,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$titleMr / $titleEn',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: GirviColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: GirviColors.muted),
                ),
              ],
            ),
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: GirviColors.green,
          ),
        ],
      ),
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
                  style: const TextStyle(fontSize: 12, color: GirviColors.muted),
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
