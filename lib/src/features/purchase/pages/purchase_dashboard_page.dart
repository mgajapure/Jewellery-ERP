import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/purchase_dashboard_stats.dart';
import '../presentation/bloc/purchase_dashboard_bloc.dart';
import '../theme/purchase_colors.dart';

/// SCR-050 Purchase Dashboard
class PurchaseDashboardPage extends StatelessWidget {
  const PurchaseDashboardPage({super.key});

  static const routeName = 'purchase-dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<PurchaseDashboardBloc>()
        ..add(const PurchaseDashboardStarted()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'खरेदी डॅशबोर्ड',
              titleEn: 'Purchase Dashboard',
              showBackButton: true,
              backFallbackRoute: 'more',
              actions: [
                BlocBuilder<PurchaseDashboardBloc, PurchaseDashboardState>(
                  buildWhen: (_, s) => s is PurchaseDashboardLoading,
                  builder: (context, state) {
                    if (state is PurchaseDashboardLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: PurchaseColors.gold,
                          ),
                        ),
                      );
                    }
                    return IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: PurchaseColors.ink,
                      ),
                      onPressed: () => context
                          .read<PurchaseDashboardBloc>()
                          .add(const PurchaseDashboardRefreshed()),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                color: PurchaseColors.navy,
                onRefresh: () async {
                  context
                      .read<PurchaseDashboardBloc>()
                      .add(const PurchaseDashboardRefreshed());
                },
                child: BlocBuilder<PurchaseDashboardBloc,
                    PurchaseDashboardState>(
                  builder: (context, state) {
                    if (state is PurchaseDashboardLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: PurchaseColors.navy,
                        ),
                      );
                    }
                    if (state is PurchaseDashboardError) {
                      return _ErrorView(
                        message: state.message,
                        onRetry: () => context
                            .read<PurchaseDashboardBloc>()
                            .add(const PurchaseDashboardStarted()),
                      );
                    }
                    if (state is PurchaseDashboardLoaded) {
                      return _LoadedView(stats: state.stats);
                    }
                    return const SizedBox.shrink();
                  },
                ),
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

  final PurchaseDashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##,##0.00', 'en_IN');
    final metrics = [
      _Metric(
        labelMr: 'आजची खरेदी',
        labelEn: "Today's Purchases",
        value: '${stats.todayPurchases}',
        color: PurchaseColors.navy,
        icon: Icons.shopping_cart,
      ),
      _Metric(
        labelMr: 'खरेदी मूल्य',
        labelEn: 'Purchase Value',
        value: '₹${fmt.format(stats.todayValue)}',
        color: PurchaseColors.gold,
        icon: Icons.payments,
      ),
      _Metric(
        labelMr: 'प्रलंबित मंजुरी',
        labelEn: 'Pending Approvals',
        value: '${stats.pendingApprovals}',
        color: PurchaseColors.orange,
        icon: Icons.pending_actions,
      ),
      _Metric(
        labelMr: 'पुरवठादार',
        labelEn: 'Suppliers',
        value: '${stats.totalSuppliers}',
        color: PurchaseColors.blue,
        icon: Icons.storefront,
      ),
      _Metric(
        labelMr: 'स्क्रॅप खरेदी',
        labelEn: 'Scrap Purchases',
        value: '${stats.scrapPurchases}',
        color: PurchaseColors.green,
        icon: Icons.recycling,
      ),
      _Metric(
        labelMr: 'इन्व्हेंटरी जोडले',
        labelEn: 'Inventory Added',
        value: '${stats.inventoryAdded}',
        color: PurchaseColors.navy,
        icon: Icons.inventory_2,
      ),
    ];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            itemBuilder: (_, i) => _MetricCard(metric: metrics[i]),
          ),
          const SizedBox(height: 24),
          const Text(
            'जलद कृती / Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: PurchaseColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.add_business,
            titleMr: 'नवीन खरेदी',
            titleEn: 'New Purchase',
            onTap: () => context.goNamed('new-purchase'),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.receipt_long,
            titleMr: 'खरेदी खाते',
            titleEn: 'Purchase Ledger',
            onTap: () => context.goNamed('purchase-ledger'),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.storefront,
            titleMr: 'पुरवठादार',
            titleEn: 'Suppliers',
            onTap: () => context.goNamed('suppliers'),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.analytics,
            titleMr: 'अहवाल',
            titleEn: 'Reports',
            onTap: () => context.goNamed('reports-dashboard'),
          ),
        ],
      ),
    );
  }
}

class _Metric {
  const _Metric({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color color;
  final IconData icon;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PurchaseColors.line),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  metric.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: metric.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: metric.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(metric.icon, color: metric.color, size: 18),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.labelMr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: PurchaseColors.ink,
                ),
              ),
              Text(
                metric.labelEn,
                style: const TextStyle(
                  fontSize: 10,
                  color: PurchaseColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PurchaseColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PurchaseColors.navy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: PurchaseColors.navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleMr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: PurchaseColors.ink,
                    ),
                  ),
                  Text(
                    titleEn,
                    style: const TextStyle(
                      fontSize: 12,
                      color: PurchaseColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: PurchaseColors.muted),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: PurchaseColors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PurchaseColors.muted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: PurchaseColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: BilingualText(en: 'Retry', mr: 'पुन्हा प्रयत्न', compact: true),
            ),
          ],
        ),
      ),
    );
  }
}
