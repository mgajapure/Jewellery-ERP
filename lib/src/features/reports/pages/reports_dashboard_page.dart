import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/reports_entities.dart';
import '../presentation/bloc/reports_dashboard_bloc.dart';
import '../theme/reports_colors.dart';

class ReportsDashboardPage extends StatelessWidget {
  const ReportsDashboardPage({super.key});

  static const routeName = 'reports-dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ReportsDashboardBloc>()
        ..add(ReportsDashboardStarted()),
      child: const _ReportsScaffold(),
    );
  }
}

class _ReportsScaffold extends StatelessWidget {
  const _ReportsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReportsColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'अहवाल आणि विश्लेषण',
              titleEn: 'Reports & Analytics',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            Expanded(
              child: BlocBuilder<ReportsDashboardBloc,
                  ReportsDashboardState>(
                builder: (context, state) {
                  if (state is ReportsDashboardLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: ReportsColors.navy),
                    );
                  }
                  if (state is ReportsDashboardError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Color(0xFFE21B2D), size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(
                                  color: ReportsColors.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<ReportsDashboardBloc>()
                                .add(ReportsDashboardStarted()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ReportsColors.navy),
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
                  if (state is ReportsDashboardLoaded) {
                    return _LoadedView(
                      data: state.data,
                      activePeriod: state.period,
                    );
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
  const _LoadedView({
    required this.data,
    required this.activePeriod,
  });

  final ReportsDashboardData data;
  final String activePeriod;

  static final _fmt = NumberFormat('#,##,##0', 'en_IN');
  static final _fmtDec = NumberFormat('#,##,##0.00', 'en_IN');

  String _currency(double v) => '₹ ${_fmt.format(v)}';
  String _weight(double v) => '${_fmtDec.format(v)} g';

  static const _periods = [
    ('today', 'Today', 'आज'),
    ('week', 'Week', 'आठवडा'),
    ('month', 'Month', 'महिना'),
    ('year', 'Year', 'वर्ष'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PeriodFilter(activePeriod: activePeriod),
          const SizedBox(height: 20),
          _PeriodLabel(period: data.period),
          const SizedBox(height: 16),
          const BilingualText(
            en: 'Sales',
            mr: 'विक्री',
            hi: 'बिक्री',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ReportsColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _SalesCard(sales: data.sales, currency: _currency),
          const SizedBox(height: 20),
          const BilingualText(
            en: 'Girvi (Loans)',
            mr: 'गिरवी',
            hi: 'गिरवी (ऋण)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ReportsColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _GirviCard(girvi: data.girvi, currency: _currency),
          const SizedBox(height: 20),
          const BilingualText(
            en: 'Purchase',
            mr: 'खरेदी',
            hi: 'खरीद',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ReportsColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _PurchaseCard(
              purchase: data.purchase,
              currency: _currency,
              weight: _weight),
        ],
      ),
    );
  }

  static List<(String, String, String)> get periods => _periods;
}

class _PeriodFilter extends StatelessWidget {
  const _PeriodFilter({required this.activePeriod});

  final String activePeriod;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _LoadedView.periods.map((entry) {
          final (key, en, mr) = entry;
          final isActive = key == activePeriod;
          final labelColor = isActive ? Colors.white : ReportsColors.ink;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context
                  .read<ReportsDashboardBloc>()
                  .add(ReportsDashboardPeriodChanged(period: key)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isActive ? ReportsColors.navy : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? ReportsColors.navy
                        : ReportsColors.line,
                  ),
                ),
                child: BilingualText(
                  en: en,
                  mr: mr,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PeriodLabel extends StatelessWidget {
  const _PeriodLabel({required this.period});

  final String period;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined,
            size: 14, color: ReportsColors.muted),
        const SizedBox(width: 6),
        Text(
          period,
          style: const TextStyle(
              fontSize: 13, color: ReportsColors.muted),
        ),
      ],
    );
  }
}

class _SalesCard extends StatelessWidget {
  const _SalesCard(
      {required this.sales, required this.currency});

  final SalesReportSummary sales;
  final String Function(double) currency;

  @override
  Widget build(BuildContext context) {
    final isGrowth = sales.growthPercent >= 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ReportsColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelMr: 'एकूण उत्पन्न',
                  labelEn: 'Total Revenue',
                  value: currency(sales.totalRevenue),
                  valueColor: ReportsColors.navy,
                ),
              ),
              Expanded(
                child: _StatTile(
                  labelMr: 'एकूण ऑर्डर',
                  labelEn: 'Total Orders',
                  value: '${sales.totalOrders}',
                  valueColor: ReportsColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelMr: 'सरासरी ऑर्डर',
                  labelEn: 'Avg. Order',
                  value: currency(sales.avgOrderValue),
                  valueColor: ReportsColors.muted,
                ),
              ),
              Expanded(
                child: _StatTile(
                  labelMr: 'वाढ',
                  labelEn: 'Growth',
                  value:
                      '${isGrowth ? '+' : ''}${sales.growthPercent.toStringAsFixed(1)}%',
                  valueColor: isGrowth
                      ? const Color(0xFF07934A)
                      : const Color(0xFFE21B2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: ReportsColors.line),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: BilingualText(
              en: 'By Category',
              mr: 'श्रेणीनुसार',
              hi: 'श्रेणी अनुसार',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ReportsColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...sales.categories
              .map((c) => _CategoryBar(item: c, currency: currency)),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.item, required this.currency});

  final ReportCategoryItem item;
  final String Function(double) currency;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.colorHex);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BilingualText(
                  en: item.labelEn,
                  mr: item.labelMr,
                  style: const TextStyle(
                      fontSize: 12, color: ReportsColors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${item.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currency(item.amount),
                style: const TextStyle(
                    fontSize: 12, color: ReportsColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.percentage / 100,
              minHeight: 5,
              backgroundColor: ReportsColors.line,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _GirviCard extends StatelessWidget {
  const _GirviCard(
      {required this.girvi, required this.currency});

  final GirviReportSummary girvi;
  final String Function(double) currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ReportsColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelMr: 'वितरित',
                  labelEn: 'Disbursed',
                  value: currency(girvi.totalDisbursed),
                  valueColor: ReportsColors.navy,
                ),
              ),
              Expanded(
                child: _StatTile(
                  labelMr: 'परत',
                  labelEn: 'Repaid',
                  value: currency(girvi.totalRepaid),
                  valueColor: const Color(0xFF07934A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelMr: 'सक्रिय',
                  labelEn: 'Active Loans',
                  value: '${girvi.activeLoans}',
                  valueColor: ReportsColors.navy,
                ),
              ),
              Expanded(
                child: _StatTile(
                  labelMr: 'थकबाकी',
                  labelEn: 'Overdue',
                  value: '${girvi.overdueLoans}',
                  valueColor: const Color(0xFFE21B2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  labelMr: 'व्याज संकलन',
                  labelEn: 'Interest',
                  value: currency(girvi.interestCollected),
                  valueColor: ReportsColors.gold,
                ),
              ),
              Expanded(
                child: _StatTile(
                  labelMr: 'सरासरी कर्ज',
                  labelEn: 'Avg. Loan',
                  value: currency(girvi.avgLoanAmount),
                  valueColor: ReportsColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({
    required this.purchase,
    required this.currency,
    required this.weight,
  });

  final PurchaseReportSummary purchase;
  final String Function(double) currency;
  final String Function(double) weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ReportsColors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              labelMr: 'खरेदी मूल्य',
              labelEn: 'Purchased',
              value: currency(purchase.totalPurchased),
              valueColor: ReportsColors.navy,
            ),
          ),
          Expanded(
            child: _StatTile(
              labelMr: 'वजन',
              labelEn: 'Weight',
              value: weight(purchase.totalWeight),
              valueColor: ReportsColors.gold,
            ),
          ),
          Expanded(
            child: _StatTile(
              labelMr: 'पुरवठादार',
              labelEn: 'Suppliers',
              value: '${purchase.uniqueSuppliers}',
              valueColor: ReportsColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.valueColor,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BilingualText(
          en: labelEn,
          mr: labelMr,
          style: const TextStyle(fontSize: 10, color: ReportsColors.muted),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
