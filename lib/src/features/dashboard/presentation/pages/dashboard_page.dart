import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../compliance/compliance.dart';
import '../../../customer/customer.dart';
import '../../../girvi/girvi.dart';
import '../../../interest/interest.dart';
import '../../../more/more.dart';
import '../../../purchase/purchase.dart';
import '../../../sales/sales.dart';
import '../../../vault/vault.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>()..add(const LoadDashboard()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardHeader(),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return switch (state) {
                    DashboardInitial() || DashboardLoading() =>
                      const AppLoader(),
                    DashboardError(:final message) => AppErrorState(
                        message: message,
                        onRetry: () => context
                            .read<DashboardBloc>()
                            .add(const LoadDashboard()),
                      ),
                    DashboardLoaded(:final summary) => ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                        children: [
                          _GoldRateCard(goldRate: summary.goldRate),
                          const SizedBox(height: 16),
                          _SectionHeader(
                            title: 'मुख्य आकडेवारी / Key Metrics',
                            trailing: 'आज / Today',
                          ),
                          const SizedBox(height: 10),
                          _MetricGrid(summary: summary),
                          const SizedBox(height: 18),
                          const _SectionHeader(
                            title: 'जलद कृती / Quick Actions',
                          ),
                          const SizedBox(height: 12),
                          _QuickActions(
                            onNewGirviTap: () =>
                                context.goNamed(CreateGirviWizardPage.routeName),
                            onSearchCustomerTap: () =>
                                context.goNamed(CustomerSearchPage.routeName),
                            onVaultSearchTap: () =>
                                context.goNamed(VaultSearchPage.routeName),
                            onInterestCalcTap: () => context
                                .goNamed(InterestCalculatorPage.routeName),
                            onComplianceTap: () => context
                                .goNamed(ComplianceDashboardPage.routeName),
                            onPurchaseTap: () =>
                                context.goNamed(PurchaseDashboardPage.routeName),
                            onSalesTap: () =>
                                context.goNamed(SalesDashboardPage.routeName),
                          ),
                          const SizedBox(height: 22),
                          const _SectionHeader(
                            title: 'अलीकडील पेमेंट्स / Recent Payments',
                            trailing: 'सर्व पहा / View All',
                          ),
                          const SizedBox(height: 12),
                          const _RecentPaymentsList(),
                        ],
                      ),
                  };
                },
              ),
            ),
            AppBottomNav(
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 0:
                  case 1:
                    context.goNamed(GirviListPage.routeName);
                  case 2:
                    context.goNamed(CustomerListPage.routeName);
                  case 3:
                    context.goNamed(MorePage.routeName);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: AppColors.ink),
            tooltip: 'Menu',
          ),
          const Spacer(),
          Text(
            'डॅशबोर्ड / Dashboard',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: AppColors.ink),
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 7,
                top: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoldRateCard extends StatelessWidget {
  const _GoldRateCard({required this.goldRate});

  final double goldRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F061C49),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'आजचा सोनाचा दर (24K)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Gold Rate Today (24K)',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'प्रति 10 ग्रॅम / per 10g',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    goldRate.toRupeeString(),
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '+ ₹320 (0.45%) ↑',
                    style: TextStyle(
                      color: Color(0xFF34D06D),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Row(
            children: [
              Text(
                '06 Jun 2026, 09:30 AM',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Spacer(),
              Text(
                'स्रोत: MCX',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(width: 6),
              Icon(Icons.refresh, color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          Text(
            trailing!,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.18,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _MetricTile(
          titleMr: 'एकूण सक्रिय गिरवी',
          titleEn: 'Active Girvi',
          value: summary.activeGirvi.toString(),
          delta: '+12 आज / today',
        ),
        _MetricTile(
          titleMr: 'एकूण डिस्बर्समेंट',
          titleEn: 'Total Disbursed',
          value: summary.loanExposure.toRupeeString(),
          delta: '+₹18.6L आज / today',
        ),
        _MetricTile(
          titleMr: 'आजचे व्याज',
          titleEn: 'Interest Due Today',
          value: summary.collectionsToday.toRupeeString(),
          delta: '+₹3,250 आज / today',
        ),
        _MetricTile(
          titleMr: 'ओव्हरड्यू खाती',
          titleEn: 'Overdue Accounts',
          value: summary.overdue.toString(),
          valueColor: AppColors.danger,
          delta: '+2 आज / today',
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.titleMr,
    required this.titleEn,
    required this.value,
    required this.delta,
    this.valueColor = AppColors.ink,
  });

  final String titleMr;
  final String titleEn;
  final String value;
  final String delta;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titleEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    this.onNewGirviTap,
    this.onSearchCustomerTap,
    this.onVaultSearchTap,
    this.onInterestCalcTap,
    this.onComplianceTap,
    this.onPurchaseTap,
    this.onSalesTap,
  });

  final VoidCallback? onNewGirviTap;
  final VoidCallback? onSearchCustomerTap;
  final VoidCallback? onVaultSearchTap;
  final VoidCallback? onInterestCalcTap;
  final VoidCallback? onComplianceTap;
  final VoidCallback? onPurchaseTap;
  final VoidCallback? onSalesTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.add,
              titleMr: 'नवीन गिरवी',
              titleEn: 'New Girvi',
              filled: true,
              onTap: onNewGirviTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.search,
              titleMr: 'ग्राहक शोधा',
              titleEn: 'Search Customer',
              onTap: onSearchCustomerTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.account_balance,
              titleMr: 'तिजोरी शोध',
              titleEn: 'Vault Search',
              onTap: onVaultSearchTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.calculate_outlined,
              titleMr: 'व्याज गणना',
              titleEn: 'Interest Calc',
              onTap: onInterestCalcTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.verified_user_outlined,
              titleMr: 'अनुपालन',
              titleEn: 'Compliance',
              onTap: onComplianceTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.shopping_bag_outlined,
              titleMr: 'खरेदी',
              titleEn: 'Purchase',
              onTap: onPurchaseTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.point_of_sale_outlined,
              titleMr: 'विक्री',
              titleEn: 'Sales',
              onTap: onSalesTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    this.filled = false,
    this.onTap,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: filled ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: filled ? AppColors.navy : AppColors.line),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon,
                color: filled ? AppColors.white : AppColors.ink, size: 27),
          ),
          const SizedBox(height: 8),
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titleEn,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPaymentsList extends StatelessWidget {
  const _RecentPaymentsList();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _PaymentTransactionTile(
            customerName: 'सुरेश पाटील',
            customerSubtitle: 'Suresh Patil',
            paymentType: 'व्याज पेमेंट / Interest Payment',
            amount: '₹12,500',
            time: '10:45 AM',
            status: 'पूर्ण / Paid',
            icon: Icons.south_west,
          ),
          _ListDivider(),
          _PaymentTransactionTile(
            customerName: 'मीना जाधव',
            customerSubtitle: 'Meena Jadhav',
            paymentType: 'मुद्दल पेमेंट / Principal Payment',
            amount: '₹35,000',
            time: '09:20 AM',
            status: 'पूर्ण / Paid',
            icon: Icons.south_west,
          ),
          _ListDivider(),
          _PaymentTransactionTile(
            customerName: 'अमोल देशमुख',
            customerSubtitle: 'Amol Deshmukh',
            paymentType: 'आंशिक पेमेंट / Partial Payment',
            amount: '₹8,760',
            time: 'काल / Yesterday',
            status: 'पूर्ण / Paid',
            icon: Icons.south_west,
          ),
        ],
      ),
    );
  }
}

class _PaymentTransactionTile extends StatelessWidget {
  const _PaymentTransactionTile({
    required this.customerName,
    required this.customerSubtitle,
    required this.paymentType,
    required this.amount,
    required this.time,
    required this.status,
    required this.icon,
  });

  final String customerName;
  final String customerSubtitle;
  final String paymentType;
  final String amount;
  final String time;
  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF8F3),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Icon(icon, color: AppColors.success, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  customerSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  paymentType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                status,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListDivider extends StatelessWidget {
  const _ListDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.line, indent: 68);
  }
}
