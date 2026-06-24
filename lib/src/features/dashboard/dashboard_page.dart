import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/di/injection.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../shared/widgets/app_error_state.dart';
import '../../shared/widgets/app_loader.dart';
import '../compliance/compliance.dart';
import '../customer/customer.dart';
import '../girvi/girvi.dart';
import '../interest/interest.dart';
import '../more/more.dart';
import '../purchase/purchase.dart';
import '../sales/sales.dart';
import '../vault/vault.dart';
import 'domain/entities/dashboard_summary.dart';
import 'presentation/bloc/dashboard_bloc.dart';
import 'presentation/bloc/dashboard_event.dart';
import 'presentation/bloc/dashboard_state.dart';

const _navy = Color(0xFF061C49);
const _gold = Color(0xFFE7A726);
const _ink = Color(0xFF071A49);
const _muted = Color(0xFF5E6880);
const _green = Color(0xFF07934A);
const _red = Color(0xFFE21B2D);
const _screenBg = Color(0xFFF8F9FC);
const _line = Color(0xFFE5E8EF);

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const routeName = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DashboardBloc>()..add(const LoadDashboard()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final alertCount = state is DashboardLoaded
            ? state.summary.alertCount
            : 0;

        return Scaffold(
          backgroundColor: _screenBg,
          body: SafeArea(
            child: Column(
              children: [
                _DashboardHeader(alertCount: alertCount),
                Expanded(child: _buildBody(context, state)),
                AppBottomNav(
                  currentIndex: 0,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        break;
                      case 1:
                        context.goNamed(GirviListPage.routeName);
                        break;
                      case 2:
                        context.goNamed(CustomerListPage.routeName);
                        break;
                      case 3:
                        context.goNamed(MorePage.routeName);
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state) {
    if (state is DashboardInitial || state is DashboardLoading) {
      return const AppLoader(message: 'डॅशबोर्ड लोड होत आहे...');
    }
    if (state is DashboardError) {
      return AppErrorState(
        message: state.message,
        onRetry: () =>
            context.read<DashboardBloc>().add(const LoadDashboard()),
      );
    }
    if (state is DashboardLoaded) {
      return RefreshIndicator(
        color: _navy,
        onRefresh: () async =>
            context.read<DashboardBloc>().add(const RefreshDashboard()),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          children: [
            _GoldRateCard(summary: state.summary),
            const SizedBox(height: 16),
            const _SectionHeader(
              title: 'मुख्य आकडेवारी / Key Metrics',
              trailing: 'आज / Today',
            ),
            const SizedBox(height: 10),
            _MetricGrid(summary: state.summary),
            const SizedBox(height: 18),
            const _SectionHeader(title: 'जलद कृती / Quick Actions'),
            const SizedBox(height: 12),
            _QuickActions(
              onNewGirviTap: () =>
                  context.goNamed(CreateGirviWizardPage.routeName),
              onSearchCustomerTap: () =>
                  context.goNamed(CustomerSearchPage.routeName),
              onVaultSearchTap: () =>
                  context.goNamed(VaultSearchPage.routeName),
              onInterestCalcTap: () =>
                  context.goNamed(InterestCalculatorPage.routeName),
              onComplianceTap: () =>
                  context.goNamed(ComplianceDashboardPage.routeName),
              onPurchaseTap: () =>
                  context.goNamed(PurchaseDashboardPage.routeName),
              onSalesTap: () =>
                  context.goNamed(SalesDashboardPage.routeName),
            ),
            const SizedBox(height: 22),
            _SectionHeader(
              title: 'अलीकडील व्यवहार / Recent Transactions',
              trailing: 'सर्व पहा / View All',
              onTrailingTap: () =>
                  context.goNamed(GirviListPage.routeName),
            ),
            const SizedBox(height: 12),
            _RecentPaymentsList(payments: state.summary.recentPayments),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.alertCount});

  final int alertCount;

  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _MenuSheet(),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotificationsSheet(alertCount: alertCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showMenuSheet(context),
            icon: const Icon(Icons.menu, color: _ink),
            tooltip: 'Menu',
          ),
          const Spacer(),
          const Text(
            'डॅशबोर्ड / Dashboard',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => _showNotificationsSheet(context),
                icon: const Icon(Icons.notifications_none, color: _ink),
                tooltip: 'Notifications',
              ),
              if (alertCount > 0)
                Positioned(
                  right: 7,
                  top: 6,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: _red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      alertCount > 99 ? '99+' : alertCount.toString(),
                      style: const TextStyle(
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

// ─── Gold Rate Card ────────────────────────────────────────────────────────────

class _GoldRateCard extends StatelessWidget {
  const _GoldRateCard({required this.summary});

  final DashboardSummary summary;

  String _formatRate(double perGram) {
    final per10g = (perGram * 10).toInt();
    return '₹${NumberFormat('#,##,###', 'en_IN').format(per10g)}';
  }

  String _formatChange(double change) {
    final per10g = (change * 10).toInt();
    final sign = per10g >= 0 ? '+ ' : '− ';
    final arrow = per10g >= 0 ? '↑' : '↓';
    return '$sign₹${per10g.abs()} (${summary.goldRateChangePct.toStringAsFixed(2)}%) $arrow';
  }

  String _formatTime(DateTime dt) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(dt.toLocal());

  @override
  Widget build(BuildContext context) {
    final isUp = summary.goldRateChange >= 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: _navy,
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
                    _formatRate(summary.goldRatePerGram),
                    style: const TextStyle(
                      color: _gold,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatChange(summary.goldRateChange),
                    style: TextStyle(
                      color: isUp
                          ? const Color(0xFF34D06D)
                          : const Color(0xFFFF6B6B),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                _formatTime(summary.goldRateUpdatedAt),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              Text(
                'स्रोत: ${summary.goldRateSource}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.refresh, color: Colors.white70, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(
      {required this.title, this.trailing, this.onTrailingTap});

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

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
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style: TextStyle(
                color: onTrailingTap != null ? _navy : _muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                decoration: onTrailingTap != null
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: _navy,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Metric Grid ──────────────────────────────────────────────────────────────

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.summary});

  final DashboardSummary summary;

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    }
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }
    if (amount >= 1000) {
      return '₹${NumberFormat('#,##,###', 'en_IN').format(amount.toInt())}';
    }
    return '₹${amount.toInt()}';
  }

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
          delta: summary.newGirviToday > 0
              ? '+${summary.newGirviToday} आज / today'
              : 'कोणतेही नाहीत',
          deltaColor: _green,
          icon: Icons.lock_outlined,
          iconColor: _navy,
        ),
        _MetricTile(
          titleMr: 'एकूण कर्ज एक्स्पोजर',
          titleEn: 'Loan Exposure',
          value: _formatAmount(summary.loanExposure),
          delta: summary.disbursedToday > 0
              ? '+${_formatAmount(summary.disbursedToday)} आज'
              : 'आज नाही',
          deltaColor: _green,
          icon: Icons.account_balance,
          iconColor: _green,
        ),
        _MetricTile(
          titleMr: 'आजचे संकलन',
          titleEn: 'Collections Today',
          value: _formatAmount(summary.collectionsToday),
          delta: '${summary.dueToday} खाती येणे / due',
          deltaColor: _muted,
          icon: Icons.payments,
          iconColor: _gold,
        ),
        _MetricTile(
          titleMr: 'ओव्हरड्यू खाती',
          titleEn: 'Overdue Accounts',
          value: summary.overdue.toString(),
          valueColor: _red,
          delta: summary.overdue > 0
              ? 'तात्काळ कारवाई आवश्यक'
              : 'सर्व खाती ठीक आहेत',
          deltaColor: summary.overdue > 0 ? _red : _green,
          icon: Icons.warning_amber_rounded,
          iconColor: _red,
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
    required this.icon,
    required this.iconColor,
    this.valueColor = _ink,
    this.deltaColor = _green,
  });

  final String titleMr;
  final String titleEn;
  final String value;
  final String delta;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;
  final Color deltaColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleMr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
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
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: deltaColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

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
              icon: Icons.add_circle_outline,
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
              icon: Icons.person_search,
              titleMr: 'ग्राहक शोधा',
              titleEn: 'Search Customer',
              onTap: onSearchCustomerTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.lock_outlined,
              titleMr: 'तिजोरी शोध',
              titleEn: 'Vault Search',
              onTap: onVaultSearchTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.percent,
              titleMr: 'व्याज गणना',
              titleEn: 'Interest Calc',
              onTap: onInterestCalcTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.verified,
              titleMr: 'अनुपालन',
              titleEn: 'Compliance',
              onTap: onComplianceTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.storefront,
              titleMr: 'खरेदी',
              titleEn: 'Purchase',
              onTap: onPurchaseTap,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 76,
            child: _QuickAction(
              icon: Icons.sell,
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
              color: filled ? _navy : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: filled ? _navy : _line),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: filled ? Colors.white : _ink, size: 27),
          ),
          const SizedBox(height: 8),
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
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
              color: _muted,
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

// ─── Recent Payments ──────────────────────────────────────────────────────────

class _RecentPaymentsList extends StatelessWidget {
  const _RecentPaymentsList({required this.payments});

  final List<RecentPayment> payments;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: const Center(
          child: Text(
            'आज कोणतेही व्यवहार नाहीत\nNo transactions today',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 13),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < payments.length; i++) ...[
            _PaymentTransactionTile(payment: payments[i]),
            if (i < payments.length - 1) const _ListDivider(),
          ],
        ],
      ),
    );
  }
}

class _PaymentTransactionTile extends StatelessWidget {
  const _PaymentTransactionTile({required this.payment});

  final RecentPayment payment;

  static const _typeLabels = {
    RecentPaymentType.interest: 'व्याज पेमेंट / Interest',
    RecentPaymentType.principal: 'मुद्दल पेमेंट / Principal',
    RecentPaymentType.partial: 'आंशिक पेमेंट / Partial',
    RecentPaymentType.renewal: 'नूतनीकरण / Renewal',
    RecentPaymentType.redemption: 'सोडवणूक / Redemption',
  };

  String _formatAmount(double amount) {
    return '₹${NumberFormat('#,##,###', 'en_IN').format(amount.toInt())}';
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final local = dt.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final paidDay = DateTime(local.year, local.month, local.day);

    if (paidDay == today) {
      return DateFormat('hh:mm a').format(local);
    }
    if (paidDay == today.subtract(const Duration(days: 1))) {
      return 'काल / Yesterday';
    }
    return DateFormat('dd MMM').format(local);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF8F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.south_west, color: _green, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  payment.customerNameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _typeLabels[payment.paymentType] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
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
                _formatAmount(payment.amount),
                style: const TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(payment.paidAt),
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'पूर्ण / Paid',
                style: TextStyle(
                  color: _green,
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
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: _line, indent: 68);
}

// ─── Menu Sheet ───────────────────────────────────────────────────────────────

class _MenuSheet extends StatelessWidget {
  const _MenuSheet();

  static const _menuItems = [
    (icon: Icons.groups, labelMr: 'ग्राहक', labelEn: 'Customers', route: 'customer-list'),
    (icon: Icons.lock_outlined, labelMr: 'गिरवी', labelEn: 'Girvi', route: 'girvi-list'),
    (icon: Icons.sell, labelMr: 'विक्री', labelEn: 'Sales', route: 'sales-dashboard'),
    (icon: Icons.storefront, labelMr: 'खरेदी', labelEn: 'Purchase', route: 'purchase-dashboard'),
    (icon: Icons.account_balance_wallet_outlined, labelMr: 'बचत योजना', labelEn: 'Savings', route: 'savings-dashboard'),
    (icon: Icons.analytics, labelMr: 'अहवाल', labelEn: 'Reports', route: 'reports-dashboard'),
    (icon: Icons.verified, labelMr: 'अनुपालन', labelEn: 'Compliance', route: 'compliance-dashboard'),
    (icon: Icons.percent, labelMr: 'व्याज', labelEn: 'Interest', route: 'interest-calculator'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.diamond_outlined, color: _gold, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'प्रकाश ज्वेलर्स',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Prakash Jewellers · ERP v0.1',
                        style: TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: _line),
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, i) {
                final item = _menuItems[i];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed(item.route);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _navy.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: _navy, size: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.labelMr,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.labelEn,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─── Notifications Sheet ──────────────────────────────────────────────────────

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet({required this.alertCount});

  final int alertCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  const Text(
                    'सूचना / Notifications',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  if (alertCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEECEC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$alertCount अलर्ट / alerts',
                        style: const TextStyle(
                          color: _red,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: _line),
            if (alertCount == 0)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.notifications_none, size: 48, color: _muted),
                    SizedBox(height: 12),
                    Text(
                      'कोणत्याही सूचना नाहीत\nNo notifications',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted, fontSize: 13),
                    ),
                  ],
                ),
              )
            else ...[
              _NotificationTile(
                icon: Icons.warning_amber_outlined,
                color: _red,
                titleMr: 'अतिदेय गिरवी खाती',
                titleEn: 'Overdue Girvi Accounts',
                bodyMr: '$alertCount खाती तात्काळ कारवाई आवश्यक',
                bodyEn: '$alertCount accounts need immediate attention',
              ),
              const Divider(height: 1, color: _line, indent: 20),
              _NotificationTile(
                icon: Icons.schedule_outlined,
                color: const Color(0xFFF59E0B),
                titleMr: 'देय तारखा जवळ आहेत',
                titleEn: 'Due Dates Approaching',
                bodyMr: 'काही गिरवी या आठवड्यात देय आहेत',
                bodyEn: 'Some girvi accounts due this week',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.goNamed('due-overdue');
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('देय व अतिदेय पहा / View Due & Overdue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.titleMr,
    required this.titleEn,
    required this.bodyMr,
    required this.bodyEn,
  });

  final IconData icon;
  final Color color;
  final String titleMr, titleEn, bodyMr, bodyEn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$titleMr / $titleEn',
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$bodyMr\n$bodyEn',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    height: 1.4,
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
