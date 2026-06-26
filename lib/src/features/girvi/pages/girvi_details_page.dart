import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/bilingual_text.dart';
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
            child: BilingualText(
              en: 'Girvi Detail',
              mr: 'गिरवी तपशील',
              hi: 'गिरवी विवरण',
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
                  content: BilingualText(
                    en: 'Print coming soon',
                    mr: 'प्रिंट लवकरच',
                    hi: 'प्रिंट जल्द आएगा',
                  ),
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
                  context.pushNamed(
                    PartialPaymentPage.routeName,
                    pathParameters: {'id': girvi.id},
                  );
                case 'renewal':
                  context.pushNamed(
                    RenewalPage.routeName,
                    pathParameters: {'id': girvi.id},
                  );
                case 'redemption':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: BilingualText(
                        en: 'Redemption coming soon',
                        mr: 'मोचन लवकरच',
                        hi: 'मोचन जल्द आएगा',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                case 'auction':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: BilingualText(
                        en: 'Auction coming soon',
                        mr: 'लिलाव प्रक्रिया लवकरच',
                        hi: 'नीलामी प्रक्रिया जल्द आएगी',
                      ),
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
                    BilingualText(
                      en: 'Partial Payment',
                      mr: 'आंशिक पेमेंट',
                      hi: 'आंशिक भुगतान',
                    ),
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
                    BilingualText(
                      en: 'Renew',
                      mr: 'नूतनीकरण',
                      hi: 'नवीनीकरण',
                    ),
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
                    BilingualText(
                      en: 'Redeem',
                      mr: 'मोचन',
                      hi: 'मोचन',
                    ),
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
                    BilingualText(
                      en: 'Auction Workflow',
                      mr: 'लिलाव',
                      hi: 'नीलामी',
                    ),
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
                          labelHi: 'ऋण आईडी',
                          value: girvi.serialId,
                        ),
                        const SizedBox(width: 24),
                        _InlineInfo(
                          labelMr: 'दिनांक',
                          labelEn: 'Date',
                          labelHi: 'दिनांक',
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
                  labelHi: 'ऋण राशि',
                  value: _formatCurrency(girvi.loanAmount),
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'बाकी रक्कम',
                  labelEn: 'Outstanding',
                  labelHi: 'बकाया राशि',
                  value: _formatCurrency(girvi.outstandingAmount),
                  valueColor: GirviColors.gold,
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'LTV',
                  labelEn: 'Loan to Value',
                  labelHi: 'LTV',
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
    required this.labelHi,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String labelHi;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BilingualText(
          en: labelEn,
          mr: labelMr,
          hi: labelHi,
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
    required this.labelHi,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String labelMr;
  final String labelEn;
  final String labelHi;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BilingualText(
          en: labelEn,
          mr: labelMr,
          hi: labelHi,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
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
            _TabLabel(mr: 'तपशील', en: 'Details', hi: 'विवरण'),
            _TabLabel(mr: 'दागिने', en: 'Items', hi: 'आभूषण'),
            _TabLabel(mr: 'पेमेंट्स', en: 'Payments', hi: 'भुगतान'),
            _TabLabel(mr: 'KFS दस्तऐवज', en: 'KFS Docs', hi: 'KFS दस्तावेज़'),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({required this.mr, required this.en, required this.hi});

  final String mr;
  final String en;
  final String hi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: BilingualText(
        en: en,
        mr: mr,
        hi: hi,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.girvi});

  final Girvi girvi;

  String _dateLabel(DateTime d) =>
      DateFormat('dd MMM yyyy').format(d);

  Widget _interestTypeWidget(InterestType t) {
    switch (t) {
      case InterestType.simple:
        return const BilingualText(
          en: 'Simple',
          mr: 'साधं व्याज',
          hi: 'साधारण ब्याज',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        );
      case InterestType.katmiti:
        return const BilingualText(
          en: 'Katmiti',
          mr: 'कात्मिती',
          hi: 'वार्षिक',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        );
      case InterestType.daily:
        return const BilingualText(
          en: 'Daily',
          mr: 'दैनिक',
          hi: 'दैनिक',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = girvi.daysLeft;
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
                labelEn: 'Due Date',
                labelMr: 'देय तारीख',
                labelHi: 'देय तिथि',
                valueWidget: _DueDateValue(
                  dateLabel: _dateLabel(girvi.dueDate),
                  daysLeft: daysLeft,
                ),
              ),
              const _DetailDivider(),
              _DetailRow(
                icon: Icons.trending_down_outlined,
                labelEn: 'Interest Type',
                labelMr: 'व्याज प्रकार',
                labelHi: 'ब्याज प्रकार',
                valueWidget: _interestTypeWidget(girvi.interestType),
              ),
              const _DetailDivider(),
              _DetailRow(
                icon: Icons.percent_outlined,
                labelEn: 'Interest Rate',
                labelMr: 'व्याज दर',
                labelHi: 'ब्याज दर',
                valueWidget: _InterestRateValue(rate: girvi.interestRate),
              ),
              const _DetailDivider(),
              _DetailRow(
                icon: Icons.warning_amber_outlined,
                labelEn: 'Penalty Rate',
                labelMr: 'दंड',
                labelHi: 'जुर्माना',
                valueWidget: _PenaltyRateValue(rate: girvi.penaltyRate),
              ),
              if (girvi.vaultLocation != null) ...[
                const _DetailDivider(),
                _DetailRow(
                  icon: Icons.lock_outline,
                  labelEn: 'Vault',
                  labelMr: 'वॉल्ट',
                  labelHi: 'तिजोरी',
                  valueWidget: Text(
                    girvi.vaultLocation!,
                    style: const TextStyle(
                      color: GirviColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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

class _DueDateValue extends StatelessWidget {
  const _DueDateValue({required this.dateLabel, required this.daysLeft});

  final String dateLabel;
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    if (daysLeft >= 0) {
      return Row(
        children: [
          Text(
            '$dateLabel  ',
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          BilingualText(
            en: '($daysLeft days left)',
            mr: '($daysLeft दिवस शिल्लक)',
            hi: '($daysLeft दिन शेष)',
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            '$dateLabel  ',
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          BilingualText(
            en: '(${-daysLeft} days late)',
            mr: '(${-daysLeft} दिवस उशीर)',
            hi: '(${-daysLeft} दिन देरी)',
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );
    }
  }
}

class _InterestRateValue extends StatelessWidget {
  const _InterestRateValue({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${rate.toStringAsFixed(2)}%  ',
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const BilingualText(
          en: 'per annum',
          mr: 'प्रति वर्ष',
          hi: 'प्रति वर्ष',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _PenaltyRateValue extends StatelessWidget {
  const _PenaltyRateValue({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${rate.toStringAsFixed(2)}%  ',
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const BilingualText(
          en: 'per month',
          mr: 'प्रति महिना',
          hi: 'प्रति माह',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.labelEn,
    required this.labelMr,
    required this.labelHi,
    required this.valueWidget,
  });

  final IconData icon;
  final String labelEn;
  final String labelMr;
  final String labelHi;
  final Widget valueWidget;

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
                BilingualText(
                  en: labelEn,
                  mr: labelMr,
                  hi: labelHi,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                valueWidget,
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
                BilingualText(
                  en: 'View KFS',
                  mr: 'KFS पहा',
                  hi: 'KFS देखें',
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

  Widget _paymentTypeWidget(PaymentType t) {
    switch (t) {
      case PaymentType.cash:
        return const BilingualText(
          en: 'Cash',
          mr: 'रोख',
          hi: 'नकद',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        );
      case PaymentType.upi:
        return const Text(
          'UPI',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        );
      case PaymentType.bankTransfer:
        return const BilingualText(
          en: 'Bank Transfer',
          mr: 'बँक ट्रान्सफर',
          hi: 'बैंक ट्रांसफर',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        );
      case PaymentType.cheque:
        return const BilingualText(
          en: 'Cheque',
          mr: 'चेक',
          hi: 'चेक',
          style: TextStyle(
            color: GirviColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        );
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
              BilingualText(
                en: 'No Payments Yet',
                mr: 'कोणतेही पेमेंट नाही',
                hi: 'कोई भुगतान नहीं',
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
                            _paymentTypeWidget(girvi.payments[i].paymentType),
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
              BilingualText(
                en: 'KFS Documents',
                mr: 'KFS दस्तऐवज',
                hi: 'KFS दस्तावेज़',
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 42,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GirviColors.screenBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: GirviColors.line),
                  ),
                  child: const Icon(Icons.call, color: GirviColors.ink, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.currency_rupee, size: 18),
                  label: const BilingualText(
                    en: 'Take Payment',
                    mr: 'पेमेंट घ्या',
                    hi: 'भुगतान लें',
                  ),
                  onPressed: canShowActions
                      ? () => context.pushNamed(
                            PartialPaymentPage.routeName,
                            pathParameters: {'id': girvi.id},
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GirviColors.navy,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GirviColors.line,
                    disabledForegroundColor: GirviColors.muted,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.autorenew, size: 18),
                  label: const BilingualText(
                    en: 'Renew',
                    mr: 'नूतनीकरण',
                    hi: 'नवीनीकरण',
                  ),
                  onPressed: canShowActions
                      ? () => context.pushNamed(
                            RenewalPage.routeName,
                            pathParameters: {'id': girvi.id},
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GirviColors.gold,
                    foregroundColor: GirviColors.ink,
                    disabledBackgroundColor: GirviColors.line,
                    disabledForegroundColor: GirviColors.muted,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
