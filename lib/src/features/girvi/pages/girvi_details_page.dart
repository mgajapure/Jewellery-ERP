import 'package:cached_network_image/cached_network_image.dart';
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
import '../widgets/girvi_status_badge.dart';
import 'girvi_list_page.dart';
import 'partial_payment_page.dart';
import 'renewal_page.dart';

/// SCR-018 Girvi Detail View
class GirviDetailsPage extends StatelessWidget {
  const GirviDetailsPage({super.key});

  static const routeName = 'girvi-details';

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    return BlocProvider(
      create: (_) =>
          getIt<GirviDetailBloc>()..add(LoadGirviDetail(id)),
      child: const _GirviDetailsView(),
    );
  }
}

class _GirviDetailsView extends StatelessWidget {
  const _GirviDetailsView();

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
        }
        if (state is GirviOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: GirviColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GirviDetailLoading || state is GirviDetailInitial) {
          return const Scaffold(
            backgroundColor: GirviColors.screenBg,
            body: SafeArea(child: AppLoader(message: 'गिरवी लोड होत आहे...')),
          );
        }
        if (state is GirviDetailError) {
          final id = GoRouterState.of(context).pathParameters['id']!;
          return Scaffold(
            backgroundColor: GirviColors.screenBg,
            body: SafeArea(
              child: Column(
                children: [
                  _header(context, girvi: null),
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
        Girvi? girvi;
        if (state is GirviDetailLoaded) girvi = state.girvi;
        if (state is GirviOperationLoading) girvi = state.girvi;
        if (state is GirviOperationSuccess) girvi = state.girvi;
        if (state is GirviOperationFailure) girvi = state.girvi;

        if (girvi == null) return const SizedBox.shrink();

        final isLoading = state is GirviOperationLoading;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: GirviColors.screenBg,
            body: SafeArea(
              child: Column(
                children: [
                  _header(context, girvi: girvi),
                  _GirviHeaderCard(girvi: girvi),
                  const _GirviTabBar(),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _DetailsTab(girvi: girvi),
                        _ItemsTab(girvi: girvi),
                        _PaymentsTab(girvi: girvi),
                        const _KfsDocsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: isLoading
                ? const LinearProgressIndicator(
                    color: GirviColors.gold,
                    backgroundColor: GirviColors.line,
                  )
                : _BottomActionBar(girvi: girvi),
          ),
        );
      },
    );
  }

  static Widget _header(BuildContext context, {Girvi? girvi}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () =>
                AppNavigation.popOrGoNamed(context, GirviListPage.routeName),
            icon: const Icon(Icons.arrow_back, color: GirviColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'गिरवी तपशील / Girvi Detail',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GirviColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('प्रिंट लवकरच / Print coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.print_outlined, color: GirviColors.ink),
            tooltip: 'Print',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: GirviColors.ink),
            tooltip: 'More',
            onSelected: (value) {
              if (girvi == null) return;
              switch (value) {
                case 'partial-payment':
                  context.goNamed(
                    PartialPaymentPage.routeName,
                    pathParameters: {'id': girvi.id},
                  );
                case 'renewal':
                  context.goNamed(
                    RenewalPage.routeName,
                    pathParameters: {'id': girvi.id},
                  );
                case 'redemption':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'मोचन लवकरच / Redemption coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                case 'auction':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'लिलाव प्रक्रिया लवकरच / Auction coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'partial-payment',
                child: Row(
                  children: [
                    Icon(Icons.currency_rupee, size: 18,
                        color: GirviColors.navy),
                    SizedBox(width: 10),
                    Text('आंशिक पेमेंट / Partial Payment'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'renewal',
                child: Row(
                  children: [
                    Icon(Icons.autorenew, size: 18,
                        color: GirviColors.navy),
                    SizedBox(width: 10),
                    Text('नूतनीकरण / Renew'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'redemption',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 18,
                        color: GirviColors.green),
                    SizedBox(width: 10),
                    Text('मोचन / Redeem'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'auction',
                child: Row(
                  children: [
                    Icon(Icons.gavel_outlined, size: 18,
                        color: GirviColors.red),
                    SizedBox(width: 10),
                    Text('लिलाव / Auction Workflow'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GirviHeaderCard extends StatelessWidget {
  const _GirviHeaderCard({required this.girvi});

  final Girvi girvi;

  String _formatCurrency(double amount) {
    final fmt = NumberFormat('#,##,##0', 'en_IN');
    return '₹${fmt.format(amount.toInt())}';
  }

  String _dateLabel(DateTime d) =>
      DateFormat('dd MMM yyyy').format(d);

  double get _ltv {
    final totalValuation = girvi.items.fold<double>(
      0,
      (sum, i) => sum + i.valuationAmount,
    );
    if (totalValuation == 0) return 0;
    return (girvi.loanAmount / totalValuation) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GirviColors.navy,
        borderRadius: BorderRadius.circular(16),
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
              const _CustomerAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      girvi.customerNameEn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      girvi.customerMobile,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _InlineInfo(
                          labelMr: 'कर्ज आयडी',
                          labelEn: 'Loan ID',
                          value: girvi.serialId,
                        ),
                        const SizedBox(width: 24),
                        _InlineInfo(
                          labelMr: 'दिनांक',
                          labelEn: 'Date',
                          value: _dateLabel(girvi.startDate),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GirviStatusBadge(status: girvi.status),
                  const SizedBox(height: 12),
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const _QrCodePlaceholder(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  labelMr: 'कर्ज रक्कम',
                  labelEn: 'Loan Amount',
                  value: _formatCurrency(girvi.loanAmount),
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'बाकी रक्कम',
                  labelEn: 'Outstanding',
                  value: _formatCurrency(girvi.outstandingAmount),
                  valueColor: GirviColors.gold,
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'LTV',
                  labelEn: 'Loan to Value',
                  value: '${_ltv.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  const _CustomerAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: GirviColors.gold.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: GirviColors.gold.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: 'https://i.pravatar.cc/150?img=11',
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Icon(Icons.person, color: GirviColors.gold, size: 38),
          errorWidget: (context, url, error) =>
              const Icon(Icons.person, color: GirviColors.gold, size: 38),
        ),
      ),
    );
  }
}

class _QrCodePlaceholder extends StatelessWidget {
  const _QrCodePlaceholder();

  @override
  Widget build(BuildContext context) {
    const size = 48.0;
    const cells = 9;
    const cellSize = size / cells;
    const pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 1, 0, 1, 0, 1, 0, 1],
    ];
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          for (var row = 0; row < cells; row++)
            Row(
              children: [
                for (var col = 0; col < cells; col++)
                  Container(
                    width: cellSize,
                    height: cellSize,
                    color: pattern[row][col] == 1
                        ? GirviColors.navy
                        : Colors.transparent,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelMr / $labelEn',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          labelEn,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _GirviTabBar extends StatelessWidget {
  const _GirviTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const TabBar(
          indicator: BoxDecoration(color: GirviColors.navy),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: GirviColors.muted,
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            _TabLabel(mr: 'तपशील', en: 'Details'),
            _TabLabel(mr: 'दागिने', en: 'Items'),
            _TabLabel(mr: 'पेमेंट्स', en: 'Payments'),
            _TabLabel(mr: 'KFS दस्तऐवज', en: 'KFS Docs'),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({required this.mr, required this.en});

  final String mr;
  final String en;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mr),
          const SizedBox(height: 2),
          Text(en, style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.girvi});

  final Girvi girvi;

  String _dateLabel(DateTime d) =>
      DateFormat('dd MMM yyyy').format(d);

  String _interestTypeLabel(InterestType t) {
    switch (t) {
      case InterestType.simple:
        return 'साधं व्याज / Simple';
      case InterestType.katmiti:
        return 'कात्मिती / Katmiti';
      case InterestType.daily:
        return 'दैनिक / Daily';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'देय तारीख / Due Date',
                value:
                    '${_dateLabel(girvi.dueDate)} (${girvi.daysLeft >= 0 ? "${girvi.daysLeft} दिवस शिल्लक / days left" : "${-girvi.daysLeft} दिवस उशीर / days late"})',
              ),
              const _DetailDivider(),
              _DetailRow(
                icon: Icons.trending_down_outlined,
                label: 'व्याज प्रकार / Interest Type',
                value: _interestTypeLabel(girvi.interestType),
              ),
              const _DetailDivider(),
              _DetailRow(
                icon: Icons.percent_outlined,
                label: 'व्याज दर / Interest Rate',
                value: '${girvi.interestRate.toStringAsFixed(2)}% प्रति वर्ष / per annum',
              ),
              const _DetailDivider(),
              _DetailRow(
                icon: Icons.warning_amber_outlined,
                label: 'दंड / Penalty Rate',
                value: '${girvi.penaltyRate.toStringAsFixed(2)}% प्रति महिना / per month',
              ),
              if (girvi.vaultLocation != null) ...[
                const _DetailDivider(),
                _DetailRow(
                  icon: Icons.lock_outline,
                  label: 'वॉल्ट / Vault',
                  value: girvi.vaultLocation!,
                ),
              ],
              const _DetailDivider(),
              const _KfsRow(),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: GirviColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: GirviColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: GirviColors.line, indent: 46);
  }
}

class _KfsRow extends StatelessWidget {
  const _KfsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.description_outlined, size: 20, color: GirviColors.muted),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KFS',
                  style: TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'KFS पहा / View KFS',
                  style: TextStyle(
                    color: GirviColors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.download_outlined, color: GirviColors.green, size: 22),
        ],
      ),
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab({required this.girvi});

  final Girvi girvi;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < girvi.items.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    color: GirviColors.line,
                    indent: 72,
                  ),
                _ItemTile(item: girvi.items[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item});

  final GirviItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: GirviColors.navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              color: GirviColors.navy,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: GirviColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.itemType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.itemType} • ${item.purity} • ${item.netWeightG.toStringAsFixed(2)} g',
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: GirviColors.muted, size: 22),
        ],
      ),
    );
  }
}

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab({required this.girvi});

  final Girvi girvi;

  String _dateLabel(DateTime d) =>
      DateFormat('dd MMM yyyy').format(d);

  String _formatCurrency(double amount) {
    final fmt = NumberFormat('#,##,##0', 'en_IN');
    return '₹${fmt.format(amount.toInt())}';
  }

  String _paymentTypeLabel(PaymentType t) {
    switch (t) {
      case PaymentType.cash:
        return 'रोख / Cash';
      case PaymentType.upi:
        return 'UPI';
      case PaymentType.bankTransfer:
        return 'बँक ट्रान्सफर / Bank Transfer';
      case PaymentType.cheque:
        return 'चेक / Cheque';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (girvi.payments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined, size: 40, color: GirviColors.muted),
              SizedBox(height: 12),
              Text(
                'कोणतेही पेमेंट नाही / No Payments Yet',
                style: TextStyle(
                  color: GirviColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < girvi.payments.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    color: GirviColors.line,
                    indent: 66,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: GirviColors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.south_west,
                          color: GirviColors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _paymentTypeLabel(girvi.payments[i].paymentType),
                              style: const TextStyle(
                                color: GirviColors.ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dateLabel(girvi.payments[i].paidAt),
                              style: const TextStyle(
                                color: GirviColors.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatCurrency(girvi.payments[i].amount),
                        style: const TextStyle(
                          color: GirviColors.ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _KfsDocsTab extends StatelessWidget {
  const _KfsDocsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: const Column(
            children: [
              Icon(Icons.description_outlined, size: 40, color: GirviColors.muted),
              SizedBox(height: 12),
              Text(
                'KFS दस्तऐवज',
                style: TextStyle(
                  color: GirviColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'KFS documents will appear here',
                style: TextStyle(
                  color: GirviColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.girvi});

  final Girvi girvi;

  @override
  Widget build(BuildContext context) {
    final canShowActions = girvi.status != GirviStatus.redeemed;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: GirviColors.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.call,
                  labelMr: 'कॉल करा',
                  labelEn: 'Call',
                  backgroundColor: Colors.white,
                  foregroundColor: GirviColors.ink,
                  onTap: () {},
                ),
              ),
              Container(width: 1, height: 36, color: GirviColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.currency_rupee,
                  labelMr: 'पेमेंट घ्या',
                  labelEn: 'Take Payment',
                  backgroundColor:
                      canShowActions ? GirviColors.navy : GirviColors.line,
                  foregroundColor: canShowActions ? Colors.white : GirviColors.muted,
                  onTap: canShowActions
                      ? () => context.goNamed(
                            PartialPaymentPage.routeName,
                            pathParameters: {'id': girvi.id},
                          )
                      : () {},
                ),
              ),
              Container(width: 1, height: 36, color: GirviColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.autorenew,
                  labelMr: 'नूतनीकरण',
                  labelEn: 'Renew',
                  backgroundColor: canShowActions ? GirviColors.gold : GirviColors.line,
                  foregroundColor: canShowActions ? GirviColors.ink : GirviColors.muted,
                  onTap: canShowActions
                      ? () => context.goNamed(
                            RenewalPage.routeName,
                            pathParameters: {'id': girvi.id},
                          )
                      : () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foregroundColor, size: 22),
            const SizedBox(height: 6),
            Text(
              labelMr,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              labelEn,
              style: TextStyle(
                color: foregroundColor.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
