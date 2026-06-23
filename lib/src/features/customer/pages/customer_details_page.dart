import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../domain/entities/customer.dart';
import '../presentation/bloc/customer_detail_bloc.dart';
import '../presentation/bloc/customer_detail_event.dart';
import '../presentation/bloc/customer_detail_state.dart';
import '../theme/customer_colors.dart';
import 'customer_list_page.dart';

/// SCR-011 Customer Profile View
/// Displays the master customer profile with tabs for Profile, Loans,
/// Schemes and History, plus quick Call / WhatsApp / Share actions.
class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({super.key});

  static const routeName = 'customer-details';

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    return BlocProvider(
      create: (_) =>
          getIt<CustomerDetailBloc>()..add(LoadCustomerDetail(id)),
      child: _CustomerDetailsView(customerId: id),
    );
  }
}

class _CustomerDetailsView extends StatelessWidget {
  const _CustomerDetailsView({required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
      builder: (context, state) {
        if (state is CustomerDetailLoading || state is CustomerDetailInitial) {
          return const Scaffold(
            backgroundColor: CustomerColors.screenBg,
            body: AppLoader(message: 'ग्राहक माहिती लोड होत आहे...'),
          );
        }

        if (state is CustomerDetailError) {
          return Scaffold(
            backgroundColor: CustomerColors.screenBg,
            body: AppErrorState(
              message: state.message,
              onRetry: () => context
                  .read<CustomerDetailBloc>()
                  .add(LoadCustomerDetail(customerId)),
            ),
          );
        }

        final customer = switch (state) {
          CustomerDetailLoaded(:final customer) => customer,
          CustomerOperationLoading(:final customer) => customer,
          CustomerOperationSuccess(:final customer) => customer,
          CustomerOperationFailure(:final customer) => customer,
          _ => null,
        };

        if (customer == null) {
          return const Scaffold(
            backgroundColor: CustomerColors.screenBg,
            body: AppLoader(),
          );
        }

        return _CustomerBody(customer: customer);
      },
    );
  }
}

class _CustomerBody extends StatelessWidget {
  const _CustomerBody({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: CustomerColors.screenBg,
        body: SafeArea(
          child: Column(
            children: [
              _ProfileAppBar(customer: customer),
              _ProfileHeaderCard(customer: customer),
              Container(
                color: Colors.white,
                child: const TabBar(
                  isScrollable: true,
                  indicatorColor: CustomerColors.gold,
                  labelColor: CustomerColors.navy,
                  unselectedLabelColor: CustomerColors.muted,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    _TabLabel(mr: 'प्रोफाइल', en: 'Profile'),
                    _TabLabel(mr: 'गिरवी', en: 'Loans'),
                    _TabLabel(mr: 'योजना', en: 'Schemes'),
                    _TabLabel(mr: 'इतिहास', en: 'History'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ProfileTab(customer: customer),
                    const _LoansTab(),
                    const _SchemesTab(),
                    const _HistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomActionBar(mobile: customer.mobile),
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigation.popOrGoNamed(
              context,
              CustomerListPage.routeName,
            ),
            icon: const Icon(Icons.arrow_back, color: CustomerColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'ग्राहक प्रोफाइल / Customer Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: CustomerColors.ink),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: CustomerColors.ink),
            tooltip: 'More',
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.customer});

  final Customer customer;

  String _formatAmount(double amount) {
    if (amount == 0) return '₹0';
    final fmt = NumberFormat('#,##,###', 'en_IN');
    return '₹${fmt.format(amount.toInt())}';
  }

  String _formatDate(DateTime dt) =>
      DateFormat('dd MMM yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomerColors.navy,
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
              _CustomerAvatar(name: customer.nameEn),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer.nameEn,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.mobile,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          customer.digitalCustomerId,
                          style: const TextStyle(
                            color: CustomerColors.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '• ग्राहक ID',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: (customer.isActive
                              ? CustomerColors.green
                              : CustomerColors.red)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      customer.isActive
                          ? 'सक्रिय / Active'
                          : 'निष्क्रिय / Inactive',
                      style: TextStyle(
                        color: customer.isActive
                            ? CustomerColors.green
                            : CustomerColors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _RiskBadge(category: customer.riskCategory),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  labelMr: 'एकूण गिरवी',
                  labelEn: 'Total Loans',
                  value: customer.activeGirvi.toString(),
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'एकूण बकाया',
                  labelEn: 'Total Outstanding',
                  value: _formatAmount(customer.outstanding),
                  valueColor: CustomerColors.gold,
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'सदस्यता',
                  labelEn: 'Since',
                  value: _formatDate(customer.createdAt),
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
  const _CustomerAvatar({required this.name});

  final String name;

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
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: CustomerColors.gold.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: CustomerColors.gold.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _initials,
          style: const TextStyle(
            color: CustomerColors.gold,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.category});

  final RiskCategory category;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (category) {
      RiskCategory.low => ('कमी जोखीम / Low', CustomerColors.green),
      RiskCategory.medium => ('मध्यम जोखीम / Med', Colors.orange),
      RiskCategory.high => ('उच्च जोखीम / High', CustomerColors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
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
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mr),
          const SizedBox(height: 2),
          Text(en, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.customer});

  final Customer customer;

  String _formatDob(DateTime? dob) {
    if (dob == null) return '—';
    return DateFormat('dd MMM yyyy').format(dob);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        const _SectionTitle(
          titleMr: 'वैयक्तिक माहिती',
          titleEn: 'Personal Information',
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Column(
            children: [
              _InfoRow(
                icon: Icons.person_outline,
                label: 'नाव / Name',
                value: '${customer.name} / ${customer.nameEn}',
              ),
              const _InfoDivider(),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'मोबाईल / Mobile',
                value: customer.mobile,
              ),
              if (customer.alternateMobile != null) ...[
                const _InfoDivider(),
                _InfoRow(
                  icon: Icons.phone_android_outlined,
                  label: 'पर्यायी मोबाईल / Alternate Mobile',
                  value: customer.alternateMobile!,
                ),
              ],
              const _InfoDivider(),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'पत्ता / Address',
                value: customer.address.isNotEmpty ? customer.address : '—',
              ),
              const _InfoDivider(),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'जन्मतारीख / DOB',
                value: _formatDob(customer.dateOfBirth),
              ),
              if (customer.aadhaarMasked != null) ...[
                const _InfoDivider(),
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'आधार क्रमांक / Aadhaar No.',
                  value: customer.aadhaarMasked!,
                  verified: true,
                ),
              ],
              if (customer.panNumber != null) ...[
                const _InfoDivider(),
                _InfoRow(
                  icon: Icons.credit_card_outlined,
                  label: 'पॅन क्रमांक / PAN',
                  value: customer.panNumber!,
                  verified: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.verified = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomerColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: CustomerColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (verified)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.verified,
                            color: CustomerColors.green,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'सत्यापित / Verified',
                            style: TextStyle(
                              color: CustomerColors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: CustomerColors.line, indent: 46);
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            color: CustomerColors.ink,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          titleEn,
          style: const TextStyle(
            color: CustomerColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LoansTab extends StatelessWidget {
  const _LoansTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _EmptyState(
          icon: Icons.account_balance_wallet_outlined,
          titleMr: 'गिरवी इतिहास लवकरच',
          titleEn: 'Loan history coming soon',
        ),
      ],
    );
  }
}

class _SchemesTab extends StatelessWidget {
  const _SchemesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _EmptyState(
          icon: Icons.savings_outlined,
          titleMr: 'कोणतीही योजना नाही',
          titleEn: 'No schemes found',
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _EmptyState(
          icon: Icons.history,
          titleMr: 'इतिहास उपलब्ध नाही',
          titleEn: 'No history available',
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomerColors.line),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: CustomerColors.muted),
          const SizedBox(height: 12),
          Text(
            titleMr,
            style: const TextStyle(
              color: CustomerColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titleEn,
            style: const TextStyle(
              color: CustomerColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.mobile});

  final String mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CustomerColors.line)),
        boxShadow: const [
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
                  onTap: () {},
                ),
              ),
              Container(width: 1, height: 36, color: CustomerColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  labelMr: 'WhatsApp',
                  labelEn: 'WhatsApp',
                  onTap: () {},
                ),
              ),
              Container(width: 1, height: 36, color: CustomerColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.share_outlined,
                  labelMr: 'शेअर करा',
                  labelEn: 'Share',
                  onTap: () {},
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
    required this.onTap,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: CustomerColors.navy, size: 22),
            const SizedBox(height: 6),
            Text(
              labelMr,
              style: const TextStyle(
                color: CustomerColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              labelEn,
              style: const TextStyle(
                color: CustomerColors.muted,
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
