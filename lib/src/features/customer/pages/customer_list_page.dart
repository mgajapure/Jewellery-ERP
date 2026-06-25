import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/dashboard/dashboard_page.dart';
import 'package:jewellery_erp/src/features/girvi/pages/girvi_list_page.dart';
import 'package:jewellery_erp/src/features/more/more.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/customer.dart';
import '../presentation/bloc/customer_list_bloc.dart';
import '../presentation/bloc/customer_list_event.dart';
import '../presentation/bloc/customer_list_state.dart';
import '../theme/customer_colors.dart';
import 'create_customer_page.dart';
import 'customer_details_page.dart';

/// SCR-010 Customer List / Search
/// Displays a searchable, filterable list of customers with real BLoC data.
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  static const routeName = 'customer-list';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CustomerListBloc>()..add(const LoadCustomerList()),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  const _CustomerListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.screenBg,
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.goNamed(DashboardPage.routeName);
              break;
            case 1:
              context.goNamed(GirviListPage.routeName);
              break;
            case 2:
              break;
            case 3:
              context.goNamed(MorePage.routeName);
              break;
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _CustomerListHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _InlineSearchBar(
                onChanged: (query) => context
                    .read<CustomerListBloc>()
                    .add(SearchCustomerList(query)),
              ),
            ),
            const _FilterChips(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<CustomerListBloc, CustomerListState>(
                builder: (context, state) {
                  if (state is CustomerListLoading ||
                      state is CustomerListInitial) {
                    return const AppLoader(
                      message: 'ग्राहक यादी लोड होत आहे...',
                    );
                  }
                  if (state is CustomerListError) {
                    return AppErrorState(
                      message: state.message,
                      onRetry: () => context
                          .read<CustomerListBloc>()
                          .add(const LoadCustomerList()),
                    );
                  }
                  if (state is CustomerListLoaded) {
                    if (state.displayList.isEmpty) {
                      return AppEmptyState(
                        icon: Icons.person_search_outlined,
                        title: 'ग्राहक नाही / No Customers Found',
                        subtitle: state.searchQuery.isNotEmpty
                            ? 'इतर शब्दांनी शोधा / Try a different search'
                            : 'नवीन ग्राहक जोडण्यासाठी + दाबा',
                      );
                    }
                    return RefreshIndicator(
                      color: CustomerColors.navy,
                      onRefresh: () async => context
                          .read<CustomerListBloc>()
                          .add(const RefreshCustomerList()),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        itemCount: state.displayList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            _CustomerTile(customer: state.displayList[index]),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const _PaginationFooter(),
          ],
        ),
      ),
    );
  }
}

class _CustomerListHeader extends StatelessWidget {
  const _CustomerListHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          const SizedBox(width: 48),
          const Expanded(
            child: Text(
              'ग्राहक सूची / Customers',
              textAlign: TextAlign.center,
              style: AppTextStyles.screenTitle,
            ),
          ),
          IconButton(
            onPressed: () => context.pushNamed(CreateCustomerPage.routeName),
            icon: const Icon(Icons.add, color: CustomerColors.ink),
            tooltip: 'Add Customer',
          ),
        ],
      ),
    );
  }
}

class _InlineSearchBar extends StatefulWidget {
  const _InlineSearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<_InlineSearchBar> createState() => _InlineSearchBarState();
}

class _InlineSearchBarState extends State<_InlineSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomerColors.line),
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
          const Icon(Icons.search, color: CustomerColors.muted, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (v) {
                setState(() {});
                widget.onChanged(v);
              },
              decoration: InputDecoration(
                hintText: 'नाव, मोबाईल, ID शोधा / Search name, mobile, ID',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {});
                widget.onChanged('');
              },
              child: const Icon(Icons.close, color: CustomerColors.muted, size: 18),
            )
          else
            const Icon(Icons.qr_code_scanner, color: CustomerColors.muted, size: 22),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerListBloc, CustomerListState>(
      builder: (context, state) {
        final total = state is CustomerListLoaded ? state.totalCount : 0;
        final active = state is CustomerListLoaded ? state.activeCount : 0;
        final inactive = state is CustomerListLoaded ? state.inactiveCount : 0;
        final filter =
            state is CustomerListLoaded ? state.activeFilter : null;
        final filters = [
          _FilterChipData(
            mr: 'सर्व',
            en: 'All',
            count: total,
            value: null,
          ),
          _FilterChipData(
            mr: 'सक्रिय',
            en: 'Active',
            count: active,
            value: true,
          ),
          _FilterChipData(
            mr: 'निष्क्रिय',
            en: 'Inactive',
            count: inactive,
            value: false,
          ),
        ];

        return SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final chip = filters[index];
              final selected = chip.value == filter;
              return ChoiceChip(
                label: Text(
                  total > 0
                      ? '${chip.mr} / ${chip.en} (${chip.count})'
                      : '${chip.mr} / ${chip.en}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: selected ? Colors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                selected: selected,
                selectedColor: CustomerColors.navy,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color:
                        selected ? CustomerColors.navy : CustomerColors.line,
                  ),
                ),
                onSelected: (_) => context
                    .read<CustomerListBloc>()
                    .add(FilterCustomerByStatus(chip.value)),
              );
            },
          ),
        );
      },
    );
  }
}

class _FilterChipData {
  const _FilterChipData({
    required this.mr,
    required this.en,
    required this.count,
    required this.value,
  });

  final String mr;
  final String en;
  final int count;
  final bool? value;
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer});

  final Customer customer;

  static const _avatarColors = [
    (bg: Color(0xFFFFF7E9), fg: Color(0xFFE7A726)),
    (bg: Color(0xFFF0F4FF), fg: Color(0xFF5E72E4)),
    (bg: Color(0xFFE6F7EF), fg: Color(0xFF07934A)),
    (bg: Color(0xFFFFEBEE), fg: Color(0xFFE21B2D)),
    (bg: Color(0xFFFFF3E0), fg: Color(0xFFEF6C00)),
    (bg: Color(0xFFF3E5F5), fg: Color(0xFF8E24AA)),
  ];

  ({Color bg, Color fg}) get _colors {
    final hash = customer.nameEn.codeUnits.fold(0, (a, b) => a + b);
    return _avatarColors[hash % _avatarColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return InkWell(
      onTap: () => context.pushNamed(
        CustomerDetailsPage.routeName,
        pathParameters: {'id': customer.id},
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomerColors.line),
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
            _InitialsAvatar(
              name: customer.nameEn,
              backgroundColor: colors.bg,
              foregroundColor: colors.fg,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${customer.mobile} • ${customer.digitalCustomerId}',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: (customer.isActive
                              ? CustomerColors.green
                              : CustomerColors.red)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      customer.isActive
                          ? 'सक्रिय / Active'
                          : 'निष्क्रिय / Inactive',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: customer.isActive
                            ? CustomerColors.green
                            : CustomerColors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(customer.outstanding),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${customer.activeGirvi} गिरवी',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.chevron_right,
                  color: CustomerColors.muted,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount == 0) return '₹0';
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)}L';
    }
    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(0)}K';
    }
    return '₹${amount.toInt()}';
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String name;
  final Color backgroundColor;
  final Color foregroundColor;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerListBloc, CustomerListState>(
      builder: (context, state) {
        final count = state is CustomerListLoaded
            ? state.displayList.length
            : 0;
        final total = state is CustomerListLoaded ? state.totalCount : 0;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count / $total ग्राहक दाखवत आहे',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '• Showing customers',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
