import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../dashboard/dashboard_page.dart';
import '../../../girvi/girvi.dart';
import '../../../more/more.dart';
import '../../domain/entities/customer.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import 'create_customer_page.dart';
import 'customer_details_page.dart';
import 'customer_search_page.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  static const routeName = 'customer-list';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomerBloc>()..add(const LoadCustomers()),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  const _CustomerListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppListHeader(
              titleMr: 'ग्राहक यादी',
              titleEn: 'Customer List',
              actionIcon: Icons.add_circle,
              actionTooltip: 'Add Customer',
              onAction: () => context.goNamed(CreateCustomerPage.routeName),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: AppSearchBar(
                hint: 'नाव / मोबाईल / आयडी शोधा',
                readOnly: true,
                onTap: () => context.goNamed(CustomerSearchPage.routeName),
              ),
            ),
            const _FilterChips(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<CustomerBloc, CustomerState>(
                builder: (context, state) {
                  return switch (state) {
                    CustomerInitial() || CustomerLoading() =>
                      const AppLoader(),
                    CustomerError(:final message) => AppErrorState(
                        message: message,
                        onRetry: () => context
                            .read<CustomerBloc>()
                            .add(const LoadCustomers()),
                      ),
                    CustomersLoaded(:final customers) => customers.isEmpty
                        ? const AppEmptyState(
                            title: 'No customers found',
                            subtitle: 'Add your first customer to get started.',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: customers.length,
                            itemBuilder: (context, index) {
                              final customer = customers[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CustomerCard(customer: customer),
                              );
                            },
                          ),
                  };
                },
              ),
            ),
            AppBottomNav(
              currentIndex: 2,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.goNamed(DashboardPage.routeName);
                  case 1:
                    context.goNamed(GirviListPage.routeName);
                  case 2:
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

class _FilterChips extends StatefulWidget {
  const _FilterChips();

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  final List<String> _labels = const [
    'सर्व / All',
    'सक्रिय / Active',
    'निष्क्रिय / Inactive',
    'उच्च जोखीम / High Risk',
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
                color: selected ? AppColors.secondary : AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected,
            selectedColor: AppColors.navy,
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected ? AppColors.navy : AppColors.line,
              ),
            ),
            onSelected: (_) => setState(() => _selected = index),
          );
        },
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final Customer customer;

  Color get _riskColor {
    switch (customer.riskCategory) {
      case 'HIGH':
        return AppColors.danger;
      case 'MEDIUM':
        return AppColors.secondary;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.goNamed(
        CustomerDetailsPage.routeName,
        pathParameters: {'id': customer.id},
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (customer.nameEn != null)
                      Text(
                        customer.nameEn!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _riskColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  customer.riskCategory,
                  style: TextStyle(
                    color: _riskColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.phone_outlined, text: customer.mobile),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.badge_outlined,
            text: customer.digitalCustomerId,
            isMuted: true,
          ),
          const Divider(height: 22, color: AppColors.line),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  labelMr: 'सक्रिय गिरवी',
                  labelEn: 'Active Girvi',
                  value: customer.activeGirvi.toString(),
                ),
              ),
              Container(width: 1, height: 30, color: AppColors.line),
              Expanded(
                child: _SummaryItem(
                  labelMr: 'बाकी रक्कम',
                  labelEn: 'Outstanding',
                  value: customer.outstanding.toRupeeString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    this.isMuted = false,
  });

  final IconData icon;
  final String text;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.muted,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: isMuted ? AppColors.muted : AppColors.ink,
            fontSize: isMuted ? 12 : 13,
            fontWeight: isMuted ? FontWeight.w600 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelMr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          labelEn,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
