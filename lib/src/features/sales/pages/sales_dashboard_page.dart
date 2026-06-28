import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../presentation/bloc/sales_dashboard_bloc.dart';
import '../theme/sales_colors.dart';

/// SCR-051 Sales Dashboard
class SalesDashboardPage extends StatelessWidget {
  const SalesDashboardPage({super.key});

  static const routeName = 'sales-dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SalesDashboardBloc>()
        ..add(SalesDashboardStarted()),
      child: Scaffold(
        backgroundColor: SalesColors.screenBg,
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                titleMr: 'विक्री डॅशबोर्ड',
                titleEn: 'Sales Dashboard',
                showBackButton: true,
                backFallbackRoute: 'more',
              ),
              Expanded(
                child: BlocBuilder<SalesDashboardBloc, SalesDashboardState>(
                  builder: (context, state) {
                    if (state is SalesDashboardLoading ||
                        state is SalesDashboardInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: SalesColors.navy,
                        ),
                      );
                    }
                    if (state is SalesDashboardError) {
                      return _ErrorView(
                        message: state.message,
                        onRetry: () => context
                            .read<SalesDashboardBloc>()
                            .add(SalesDashboardRefreshed()),
                      );
                    }
                    if (state is SalesDashboardLoaded) {
                      return _DashboardBody(state: state);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.state});

  final SalesDashboardLoaded state;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
    final stats = state.stats;

    final metrics = [
      {
        'labelMr': 'आजची विक्री',
        'labelEn': "Today's Sales",
        'value': '${stats.todaySales}',
        'color': SalesColors.navy,
        'icon': Icons.trending_up,
        'iconColor': SalesColors.navy,
      },
      {
        'labelMr': 'आजचे उत्पन्न',
        'labelEn': "Today's Revenue",
        'value': '₹${amtFmt.format(stats.todayRevenue)}',
        'color': SalesColors.gold,
        'icon': Icons.payments,
        'iconColor': SalesColors.gold,
      },
      {
        'labelMr': 'मासिक उत्पन्न',
        'labelEn': 'Monthly Revenue',
        'value': '₹${amtFmt.format(stats.monthlyRevenue)}',
        'color': SalesColors.green,
        'icon': Icons.bar_chart,
        'iconColor': SalesColors.green,
      },
      {
        'labelMr': 'सरासरी इन्व्हॉईस',
        'labelEn': 'Avg Invoice',
        'value': '₹${amtFmt.format(stats.avgInvoice)}',
        'color': const Color(0xFF2563EB),
        'icon': Icons.receipt_long,
        'iconColor': const Color(0xFF2563EB),
      },
      {
        'labelMr': 'टॉप श्रेणी',
        'labelEn': 'Top Category',
        'value': stats.topCategory,
        'color': SalesColors.navy,
        'icon': Icons.workspace_premium,
        'iconColor': SalesColors.navy,
      },
      {
        'labelMr': 'प्रलंबित परतावा',
        'labelEn': 'Pending Returns',
        'value': '${stats.pendingReturns}',
        'color': SalesColors.orange,
        'icon': Icons.assignment_return_outlined,
        'iconColor': SalesColors.orange,
      },
    ];

    return RefreshIndicator(
      color: SalesColors.navy,
      onRefresh: () async => context
          .read<SalesDashboardBloc>()
          .add(SalesDashboardRefreshed()),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: metrics.map((m) => _MetricCard(metric: m)).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'जलद कृती / Quick Actions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: SalesColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.sell,
              titleMr: 'नवीन विक्री',
              titleEn: 'New Sale',
              onTap: () => context.goNamed('new-sale'),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.qr_code_scanner,
              titleMr: 'बारकोड विक्री',
              titleEn: 'Barcode Sale',
              onTap: () => context.goNamed('barcode-sale'),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.receipt_long,
              titleMr: 'विक्री खाते',
              titleEn: 'Sales Ledger',
              onTap: () => context.goNamed('sales-ledger'),
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.assignment_return_outlined,
              titleMr: 'विक्री परतावा',
              titleEn: 'Sales Return',
              onTap: () => context.goNamed('sales-return'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final Map<String, dynamic> metric;

  @override
  Widget build(BuildContext context) {
    final color = metric['color'] as Color;
    final iconColor = metric['iconColor'] as Color;
    final icon = metric['icon'] as IconData;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SalesColors.line),
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
                  metric['value'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric['labelMr'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: SalesColors.ink,
                ),
              ),
              Text(
                metric['labelEn'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  color: SalesColors.muted,
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
          border: Border.all(color: SalesColors.line),
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
                color: SalesColors.navy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: SalesColors.navy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                '$titleMr / $titleEn',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: SalesColors.ink,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: SalesColors.muted),
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
            const Icon(Icons.wifi_off_outlined,
                size: 48, color: SalesColors.muted),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: SalesColors.muted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: SalesColors.navy,
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
