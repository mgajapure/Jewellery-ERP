import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/customer/customer.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/di/injection.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/girvi.dart';
import '../presentation/bloc/girvi_list_bloc.dart';
import '../presentation/bloc/girvi_list_event.dart';
import '../presentation/bloc/girvi_list_state.dart';
import '../theme/girvi_colors.dart';
import '../widgets/girvi_card.dart';
import 'create_girvi_wizard_page.dart';
import 'girvi_details_page.dart';
import 'partial_payment_page.dart';
import 'redemption_page.dart';
import 'renewal_page.dart';

class GirviListPage extends StatelessWidget {
  const GirviListPage({super.key});

  static const routeName = 'girvi-list';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GirviListBloc>()..add(const LoadGirviList()),
      child: const _GirviListView(),
    );
  }
}

class _GirviListView extends StatelessWidget {
  const _GirviListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _GirviListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _GirviSearchBar(),
            ),
            const _FilterChips(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<GirviListBloc, GirviListState>(
                builder: (context, state) {
                  if (state is GirviListLoading ||
                      state is GirviListInitial) {
                    return const AppLoader(
                      message: 'गिरवी यादी लोड होत आहे...',
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
                    if (state.girviList.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.diamond_outlined,
                        title: 'गिरवी नाही / No Girvi Found',
                        subtitle:
                            'नवीन गिरवी तयार करण्यासाठी + बटण दाबा.',
                      );
                    }

                    final overdueCount = state.girviList
                        .where((g) =>
                            g.status == GirviStatus.overdue ||
                            g.daysLeft < 0)
                        .length;
                    final dueSoonCount = state.girviList
                        .where((g) =>
                            (g.status == GirviStatus.active ||
                                g.status == GirviStatus.partialPaid) &&
                            g.daysLeft >= 0 &&
                            g.daysLeft <= 7)
                        .length;

                    return Column(
                      children: [
                        if (overdueCount > 0)
                          _AlertBanner(
                            icon: Icons.warning_amber_rounded,
                            message:
                                '$overdueCount गिरवी मुदतीपूर्व / $overdueCount overdue',
                            color: GirviColors.red,
                            onTap: () => context.goNamed('due-overdue'),
                          )
                        else if (dueSoonCount > 0)
                          _AlertBanner(
                            icon: Icons.alarm_outlined,
                            message:
                                '$dueSoonCount गिरवी लवकरच देय / $dueSoonCount due soon',
                            color: GirviColors.orange,
                            onTap: () => context.goNamed('due-overdue'),
                          ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async => context
                                .read<GirviListBloc>()
                                .add(const RefreshGirviList()),
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                  20, 0, 20, 20),
                              itemCount: state.girviList.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final girvi = state.girviList[index];
                                final isActionable = girvi.status ==
                                        GirviStatus.active ||
                                    girvi.status ==
                                        GirviStatus.partialPaid ||
                                    girvi.status == GirviStatus.overdue;
                                return GirviCard(
                                  girvi: girvi,
                                  onTap: () => context.goNamed(
                                    GirviDetailsPage.routeName,
                                    pathParameters: {'id': girvi.id},
                                  ),
                                  onPayTap: isActionable
                                      ? () => context.goNamed(
                                            PartialPaymentPage.routeName,
                                            pathParameters: {
                                              'id': girvi.id
                                            },
                                          )
                                      : null,
                                  onRenewTap: isActionable
                                      ? () => context.goNamed(
                                            RenewalPage.routeName,
                                            pathParameters: {
                                              'id': girvi.id
                                            },
                                          )
                                      : null,
                                  onRedeemTap: isActionable
                                      ? () => context.goNamed(
                                            RedemptionPage.routeName,
                                            pathParameters: {
                                              'id': girvi.id
                                            },
                                          )
                                      : null,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            AppBottomNav(
              currentIndex: 1,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.goNamed(DashboardPage.routeName);
                  case 1:
                    break;
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

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({
    required this.icon,
    required this.message,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String message;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              'पहा / View →',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GirviListHeader extends StatelessWidget {
  const _GirviListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'गिरवी यादी / Girvi List',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: GirviColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () =>
                context.goNamed(CreateGirviWizardPage.routeName),
            icon:
                const Icon(Icons.add_circle, color: GirviColors.ink),
            tooltip: 'नवीन गिरवी / New Girvi',
          ),
        ],
      ),
    );
  }
}

class _GirviSearchBar extends StatefulWidget {
  @override
  State<_GirviSearchBar> createState() => _GirviSearchBarState();
}

class _GirviSearchBarState extends State<_GirviSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      child: Row(
        children: [
          const Icon(Icons.search, color: GirviColors.muted, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (q) =>
                  context.read<GirviListBloc>().add(SearchGirviList(q)),
              decoration: const InputDecoration(
                hintText: 'ग्राहक / सिरीयल आयडी शोधा',
                hintStyle: TextStyle(
                  color: GirviColors.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    _controller.clear();
                    context
                        .read<GirviListBloc>()
                        .add(const SearchGirviList(''));
                  },
                  child: const Icon(Icons.clear,
                      color: GirviColors.muted, size: 20),
                );
              }
              return const Icon(Icons.qr_code_scanner,
                  color: GirviColors.muted, size: 22);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  static const _filters = <GirviStatus?>[
    null,
    GirviStatus.active,
    GirviStatus.partialPaid,
    GirviStatus.renewed,
    GirviStatus.redeemed,
    GirviStatus.overdue,
  ];

  static const _labels = [
    'सर्व / All',
    'सक्रिय / Active',
    'आंशिक पेड / Partial',
    'नवीनीकृत / Renewed',
    'मुद्दलपरत / Redeemed',
    'ओव्हरड्यू / Overdue',
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == _selected;
          return ChoiceChip(
            label: Text(
              _labels[index],
              style: TextStyle(
                color: selected ? GirviColors.gold : GirviColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected,
            selectedColor: GirviColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color:
                    selected ? GirviColors.navy : GirviColors.line,
              ),
            ),
            onSelected: (_) {
              setState(() => _selected = index);
              context
                  .read<GirviListBloc>()
                  .add(FilterGirviByStatus(_filters[index]));
            },
          );
        },
      ),
    );
  }
}
