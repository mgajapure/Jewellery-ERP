import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/injection.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/girvi.dart';
import '../presentation/bloc/girvi_list_bloc.dart';
import '../presentation/bloc/girvi_list_event.dart';
import '../presentation/bloc/girvi_list_state.dart';
import '../theme/girvi_colors.dart';
import 'girvi_details_page.dart';

Future<void> _dialCall(BuildContext context, String mobile) async {
  final uri = Uri(scheme: 'tel', path: '+91$mobile');
  if (!await launchUrl(uri) && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: BilingualText(en: 'Could not open dialer', mr: 'डायलर उघडता आला नाही', compact: true),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<void> _openWhatsApp(BuildContext context, String mobile) async {
  final uri = Uri.parse('https://wa.me/91$mobile');
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
      context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'WhatsApp उघडता आला नाही / Could not open WhatsApp'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class DueOverduePage extends StatelessWidget {
  const DueOverduePage({super.key});

  static const routeName = 'due-overdue';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GirviListBloc>()..add(const LoadGirviList()),
      child: const _DueOverdueView(),
    );
  }
}

class _DueOverdueView extends StatefulWidget {
  const _DueOverdueView();

  @override
  State<_DueOverdueView> createState() => _DueOverdueViewState();
}

class _DueOverdueViewState extends State<_DueOverdueView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'देय व मुदतीपूर्व',
              titleEn: 'Due & Overdue',
              showBackButton: true,
              backFallbackRoute: 'girvi-list',
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              decoration: BoxDecoration(
                color: GirviColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: GirviColors.gold,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: GirviColors.navy,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'आज / Today'),
                  Tab(text: 'या आठवड्यात'),
                  Tab(text: 'मुदतीपूर्व'),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<GirviListBloc, GirviListState>(
                builder: (context, state) {
                  if (state is GirviListLoading || state is GirviListInitial) {
                    return const AppLoader(
                      message: 'देय यादी लोड होत आहे...',
                    );
                  }
                  if (state is GirviListError) {
                    return AppErrorState(
                      message: state.message,
                      onRetry: () => context
                          .read<GirviListBloc>()
                          .add(const LoadGirviList()),
                    );
                  }
                  if (state is GirviListLoaded) {
                    final all = state.girviList;
                    final today = all
                        .where((g) =>
                            (g.status == GirviStatus.active ||
                                g.status == GirviStatus.partialPaid) &&
                            g.daysLeft == 0)
                        .toList();
                    final thisWeek = all
                        .where((g) =>
                            (g.status == GirviStatus.active ||
                                g.status == GirviStatus.partialPaid) &&
                            g.daysLeft > 0 &&
                            g.daysLeft <= 7)
                        .toList();
                    final overdue = all
                        .where((g) =>
                            g.status == GirviStatus.overdue || g.daysLeft < 0)
                        .toList();

                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _DueList(
                          items: today,
                          statusColor: GirviColors.gold,
                          emptyLabel: 'आज कोणतेही देय नाही',
                          emptyLabelEn: 'No payments due today',
                        ),
                        _DueList(
                          items: thisWeek,
                          statusColor: GirviColors.orange,
                          emptyLabel: 'या आठवड्यात कोणतेही देय नाही',
                          emptyLabelEn: 'No payments due this week',
                        ),
                        _DueList(
                          items: overdue,
                          statusColor: GirviColors.red,
                          emptyLabel: 'मुदतीपूर्व कोणतेही नाही',
                          emptyLabelEn: 'No overdue contracts',
                          isOverdue: true,
                        ),
                      ],
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

class _DueList extends StatelessWidget {
  const _DueList({
    required this.items,
    required this.statusColor,
    required this.emptyLabel,
    required this.emptyLabelEn,
    this.isOverdue = false,
  });

  final List<Girvi> items;
  final Color statusColor;
  final String emptyLabel;
  final String emptyLabelEn;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(labelMr: emptyLabel, labelEn: emptyLabelEn);
    }
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<GirviListBloc>().add(const RefreshGirviList()),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: items.length,
        itemBuilder: (context, index) => _DueCard(
          girvi: items[index],
          statusColor: statusColor,
          isOverdue: isOverdue,
        ),
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({
    required this.girvi,
    required this.statusColor,
    required this.isOverdue,
  });

  final Girvi girvi;
  final Color statusColor;
  final bool isOverdue;

  static final _fmt = NumberFormat('#,##,##0', 'en_IN');

  String get _dueLabel {
    if (isOverdue || girvi.daysLeft < 0) {
      return '${girvi.daysLeft.abs()} days overdue';
    }
    if (girvi.daysLeft == 0) return 'Due Today';
    return 'In ${girvi.daysLeft} days';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(
        GirviDetailsPage.routeName,
        pathParameters: {'id': girvi.id},
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  girvi.serialId,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: GirviColors.navy,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _dueLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.person_outline,
              text: girvi.customerNameEn,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.phone_outlined,
              text: girvi.customerMobile,
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.currency_rupee,
              text: '₹ ${_fmt.format(girvi.outstandingAmount)}',
            ),
            const Divider(height: 22, color: GirviColors.line),
            Row(
              children: [
                _ActionChip(
                  icon: Icons.phone,
                  label: 'कॉल / Call',
                  onTap: () => _dialCall(context, girvi.customerMobile),
                ),
                const SizedBox(width: 8),
                _ActionChip(
                  icon: Icons.message_outlined,
                  label: 'व्हाट्सअँप / WA',
                  onTap: () =>
                      _openWhatsApp(context, girvi.customerMobile),
                ),
                const SizedBox(width: 8),
                _ActionChip(
                  icon: Icons.alarm_outlined,
                  label: 'सूचना / Reminder',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'स्मरणपत्र लवकरच येणार / Reminder coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: GirviColors.muted),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: GirviColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: GirviColors.screenBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GirviColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: GirviColors.navy),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: GirviColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.labelMr, required this.labelEn});

  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: GirviColors.muted.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            labelMr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: GirviColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            labelEn,
            style: const TextStyle(
              fontSize: 13,
              color: GirviColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
