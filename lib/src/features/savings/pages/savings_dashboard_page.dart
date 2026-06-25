import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/savings_entities.dart';
import '../presentation/bloc/savings_dashboard_bloc.dart';
import '../theme/savings_colors.dart';

class SavingsDashboardPage extends StatelessWidget {
  const SavingsDashboardPage({super.key});

  static const routeName = 'savings-dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SavingsDashboardBloc>()
        ..add(SavingsDashboardStarted()),
      child: const _SavingsScaffold(),
    );
  }
}

class _SavingsScaffold extends StatelessWidget {
  const _SavingsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SavingsColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'बचत योजना',
              titleEn: 'Savings Scheme',
              showBackButton: true,
              backFallbackRoute: 'more',
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh,
                      color: SavingsColors.navy),
                  onPressed: () => context
                      .read<SavingsDashboardBloc>()
                      .add(SavingsDashboardRefreshed()),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<SavingsDashboardBloc,
                  SavingsDashboardState>(
                builder: (context, state) {
                  if (state is SavingsDashboardLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: SavingsColors.navy),
                    );
                  }
                  if (state is SavingsDashboardError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Color(0xFFE21B2D), size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(
                                  color: SavingsColors.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<SavingsDashboardBloc>()
                                .add(SavingsDashboardRefreshed()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: SavingsColors.navy),
                            child: const BilingualText(
                              en: 'Retry',
                              mr: 'पुन्हा प्रयत्न',
                              hi: 'पुनः प्रयास',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is SavingsDashboardLoaded) {
                    return _LoadedView(stats: state.stats);
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

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.stats});

  final SavingsDashboardStats stats;

  static final _fmt = NumberFormat('#,##,##0', 'en_IN');

  String _currency(double v) => '₹ ${_fmt.format(v)}';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryBanner(stats: stats, currency: _currency),
          const SizedBox(height: 24),
          const BilingualText(
            en: 'Available Plans',
            mr: 'उपलब्ध योजना',
            hi: 'उपलब्ध योजनाएं',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: SavingsColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          ...stats.plans.map((p) => _PlanCard(plan: p, currency: _currency)),
          const SizedBox(height: 24),
          const BilingualText(
            en: 'Recent Subscriptions',
            mr: 'अलीकडील नोंदणी',
            hi: 'हाल की सदस्यताएं',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: SavingsColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          ...stats.recentSubscriptions
              .map((s) => _SubscriptionCard(sub: s, currency: _currency)),
        ],
      ),
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner(
      {required this.stats, required this.currency});

  final SavingsDashboardStats stats;
  final String Function(double) currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SavingsColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualText(
            en: 'Savings Overview',
            mr: 'बचत योजना सारांश',
            hi: 'बचत योजना सारांश',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _BannerStat(
                  value: '${stats.activeSubscriptions}',
                  labelMr: 'सक्रिय सदस्य',
                  labelEn: 'Active Members',
                ),
              ),
              Container(
                  width: 1, height: 50, color: Colors.white24),
              Expanded(
                child: _BannerStat(
                  value: '${stats.activePlans}',
                  labelMr: 'योजना',
                  labelEn: 'Plans',
                ),
              ),
              Container(
                  width: 1, height: 50, color: Colors.white24),
              Expanded(
                child: _BannerStat(
                  value: currency(stats.collectedThisMonth),
                  labelMr: 'या महिन्यात',
                  labelEn: 'This Month',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    color: SavingsColors.gold, size: 20),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BilingualText(
                      en: 'Total Collected',
                      mr: 'एकूण संकलन',
                      hi: 'कुल संग्रह',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    Text(
                      currency(stats.totalCollected),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  const _BannerStat({
    required this.value,
    required this.labelMr,
    required this.labelEn,
  });

  final String value;
  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        BilingualText(
          en: labelEn,
          mr: labelMr,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.currency});

  final SavingsPlan plan;
  final String Function(double) currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'योजना तपशील लवकरच येणार / Plan details coming soon'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SavingsColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: SavingsColors.gold.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.diamond,
                    color: SavingsColors.gold, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.nameMr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SavingsColors.ink,
                      ),
                    ),
                    Text(
                      plan.nameEn,
                      style: const TextStyle(
                          fontSize: 11, color: SavingsColors.muted),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _PlanChip(
                            label:
                                '${currency(plan.monthlyAmount)}/month'),
                        const SizedBox(width: 8),
                        _PlanChip(
                            label:
                                '${plan.durationMonths}+${plan.bonusMonths} months'),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${plan.activeSubscribers}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SavingsColors.navy,
                    ),
                  ),
                  const Text(
                    'members',
                    style:
                        TextStyle(fontSize: 10, color: SavingsColors.muted),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right,
                  color: SavingsColors.muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanChip extends StatelessWidget {
  const _PlanChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: SavingsColors.navy.withAlpha(12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: SavingsColors.navy,
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard(
      {required this.sub, required this.currency});

  final SavingsSubscription sub;
  final String Function(double) currency;

  Color get _statusColor {
    switch (sub.status) {
      case SavingsSubscriptionStatus.active:
        return const Color(0xFF07934A);
      case SavingsSubscriptionStatus.completed:
        return const Color(0xFF061C49);
      case SavingsSubscriptionStatus.defaulted:
        return const Color(0xFFE21B2D);
      case SavingsSubscriptionStatus.cancelled:
        return const Color(0xFF5E6880);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = sub.completionPercent;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SavingsColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sub.customerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: SavingsColors.ink,
                      ),
                    ),
                    Text(
                      '${sub.planNameMr} · ${sub.planNameEn}',
                      style: const TextStyle(
                          fontSize: 11, color: SavingsColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BilingualText(
                  en: sub.status.labelEn,
                  mr: sub.status.labelMr,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SubStat(
                  label: 'Paid',
                  value:
                      '${sub.paidInstallments}/${sub.totalInstallments}',
                ),
              ),
              Expanded(
                child: _SubStat(
                  label: 'Total Paid',
                  value: currency(sub.totalPaid),
                ),
              ),
              Expanded(
                child: _SubStat(
                  label: 'Next Due',
                  value: sub.nextDueDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: SavingsColors.line,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ),
          const SizedBox(height: 4),
          BilingualText(
            en: '${(progress * 100).toStringAsFixed(0)}% complete',
            mr: '${(progress * 100).toStringAsFixed(0)}% पूर्ण',
            hi: '${(progress * 100).toStringAsFixed(0)}% पूर्ण',
            style: const TextStyle(fontSize: 10, color: SavingsColors.muted),
          ),
        ],
      ),
    );
  }
}

class _SubStat extends StatelessWidget {
  const _SubStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 10, color: SavingsColors.muted),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SavingsColors.ink,
          ),
        ),
      ],
    );
  }
}
