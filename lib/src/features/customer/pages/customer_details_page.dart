import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../girvi/domain/entities/girvi.dart';
import '../../girvi/pages/create_girvi_wizard_page.dart';
import '../../girvi/pages/girvi_details_page.dart';
import '../../girvi/pages/partial_payment_page.dart';
import '../../girvi/pages/renewal_page.dart';
import '../../girvi/presentation/bloc/girvi_list_bloc.dart';
import '../../girvi/presentation/bloc/girvi_list_event.dart';
import '../../girvi/presentation/bloc/girvi_list_state.dart';
import '../domain/entities/customer.dart';
import '../presentation/bloc/customer_detail_bloc.dart';
import '../presentation/bloc/customer_detail_event.dart';
import '../presentation/bloc/customer_detail_state.dart';
import '../theme/customer_colors.dart';
import 'customer_list_page.dart';
import 'edit_customer_page.dart';

Future<void> _launchCall(BuildContext context, String mobile) async {
  final uri = Uri(scheme: 'tel', path: '+91$mobile');
  if (!await launchUrl(uri) && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('डायलर उघडता आला नाही / Could not open dialer'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<void> _launchWhatsApp(BuildContext context, String mobile) async {
  final uri = Uri.parse('https://wa.me/91$mobile');
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
      context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WhatsApp उघडता आला नाही / Could not open WhatsApp'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

void _shareCustomer(Customer customer) {
  final text = '${customer.name} / ${customer.nameEn}\n'
      'Mobile: ${customer.mobile}\n'
      'ID: ${customer.digitalCustomerId}\n'
      'Address: ${customer.address}';
  Share.share(text, subject: 'Customer: ${customer.nameEn}');
}

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
      length: 5,
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
                    _TabLabel(mr: 'पेमेंट', en: 'Payment'),
                    _TabLabel(mr: 'योजना', en: 'Schemes'),
                    _TabLabel(mr: 'इतिहास', en: 'History'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ProfileTab(customer: customer),
                    _LoansTab(customer: customer),
                    const _PaymentTab(),
                    const _SchemesTab(),
                    const _HistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomActionBar(customer: customer),
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
            onPressed: () => context.pushNamed(
              EditCustomerPage.routeName,
              extra: customer,
            ),
            icon: const Icon(Icons.edit_outlined, color: CustomerColors.ink),
            tooltip: 'Edit',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: CustomerColors.ink),
            tooltip: 'More',
            onSelected: (value) {
              switch (value) {
                case 'copy':
                  Clipboard.setData(
                      ClipboardData(text: customer.mobile));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'मोबाईल नंबर कॉपी झाला / Mobile number copied'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                case 'girvi':
                  context.goNamed('girvi-list');
                case 'savings':
                  context.goNamed('savings-dashboard');
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 18, color: CustomerColors.ink),
                    SizedBox(width: 10),
                    Text('मोबाईल कॉपी करा / Copy Mobile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'girvi',
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined,
                        size: 18, color: CustomerColors.ink),
                    SizedBox(width: 10),
                    Text('गिरवी पहा / View Girvi'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'savings',
                child: Row(
                  children: [
                    Icon(Icons.savings_outlined,
                        size: 18, color: CustomerColors.ink),
                    SizedBox(width: 10),
                    Text('बचत योजना / Savings Schemes'),
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
  const _LoansTab({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GirviListBloc>()..add(const LoadGirviList()),
      child: _LoansTabView(customer: customer),
    );
  }
}

class _LoansTabView extends StatelessWidget {
  const _LoansTabView({required this.customer});

  final Customer customer;

  static final _fmt = NumberFormat('#,##,###', 'en_IN');

  String _formatAmt(double v) => '₹${_fmt.format(v.toInt())}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GirviListBloc, GirviListState>(
      builder: (context, state) {
        if (state is GirviListLoading || state is GirviListInitial) {
          return const AppLoader(message: 'गिरवी लोड होत आहे...');
        }
        if (state is GirviListError) {
          return AppErrorState(
            message: state.message,
            onRetry: () =>
                context.read<GirviListBloc>().add(const LoadGirviList()),
          );
        }
        if (state is GirviListLoaded) {
          final loans = state.girviList
              .where((g) => g.customerId == customer.id)
              .toList();
          final active = loans
              .where((g) =>
                  g.status == GirviStatus.active ||
                  g.status == GirviStatus.partialPaid ||
                  g.status == GirviStatus.overdue)
              .toList();
          final closed = loans
              .where((g) =>
                  g.status == GirviStatus.redeemed ||
                  g.status == GirviStatus.renewed)
              .toList();
          final outstanding =
              active.fold(0.0, (s, g) => s + g.outstandingAmount);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _LoansSummaryCard(
                activeCount: active.length,
                outstanding: outstanding,
                formatAmt: _formatAmt,
                onNewGirvi: () =>
                    context.goNamed(CreateGirviWizardPage.routeName),
              ),
              const SizedBox(height: 16),
              if (active.isNotEmpty) ...[
                _LoansSectionHeader(
                    titleMr: 'सक्रिय गिरवी', titleEn: 'Active Loans'),
                const SizedBox(height: 10),
                ...active.map((g) => _MiniLoanCard(
                      girvi: g,
                      formatAmt: _formatAmt,
                    )),
                const SizedBox(height: 16),
              ],
              if (closed.isNotEmpty) ...[
                _LoansSectionHeader(
                    titleMr: 'बंद गिरवी', titleEn: 'Closed Loans'),
                const SizedBox(height: 10),
                ...closed.map((g) => _MiniLoanCard(
                      girvi: g,
                      formatAmt: _formatAmt,
                    )),
              ],
              if (loans.isEmpty) ...[
                const SizedBox(height: 20),
                _NoLoansBanner(
                  onNewGirvi: () =>
                      context.goNamed(CreateGirviWizardPage.routeName),
                ),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _LoansSummaryCard extends StatelessWidget {
  const _LoansSummaryCard({
    required this.activeCount,
    required this.outstanding,
    required this.formatAmt,
    required this.onNewGirvi,
  });

  final int activeCount;
  final double outstanding;
  final String Function(double) formatAmt;
  final VoidCallback onNewGirvi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomerColors.navy,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'एकूण बकाया रक्कम',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      'Total Outstanding',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatAmt(outstanding),
                      style: const TextStyle(
                        color: CustomerColors.gold,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$activeCount सक्रिय / Active',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onNewGirvi,
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('नवीन गिरवी तयार करा / New Girvi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: CustomerColors.gold,
                side: const BorderSide(color: CustomerColors.gold, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoansSectionHeader extends StatelessWidget {
  const _LoansSectionHeader(
      {required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            color: CustomerColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '/ $titleEn',
          style: const TextStyle(
            color: CustomerColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MiniLoanCard extends StatelessWidget {
  const _MiniLoanCard({required this.girvi, required this.formatAmt});

  final Girvi girvi;
  final String Function(double) formatAmt;

  Color get _statusColor {
    return switch (girvi.status) {
      GirviStatus.overdue => CustomerColors.red,
      GirviStatus.active => CustomerColors.green,
      GirviStatus.partialPaid => const Color(0xFFF59E0B),
      _ => CustomerColors.muted,
    };
  }

  String get _statusLabel {
    return switch (girvi.status) {
      GirviStatus.active => 'सक्रिय / Active',
      GirviStatus.partialPaid => 'आंशिक / Partial',
      GirviStatus.overdue => 'मुदतीपूर्व / Overdue',
      GirviStatus.redeemed => 'परत / Redeemed',
      GirviStatus.renewed => 'नूतन / Renewed',
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(
        GirviDetailsPage.routeName,
        pathParameters: {'id': girvi.id},
      ),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CustomerColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  girvi.serialId,
                  style: const TextStyle(
                    color: CustomerColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _MiniStat(
                  label: 'कर्ज / Loan',
                  value: formatAmt(girvi.loanAmount),
                ),
                _MiniStat(
                  label: 'बाकी / Outstanding',
                  value: formatAmt(girvi.outstandingAmount),
                  valueColor: CustomerColors.gold,
                ),
                _MiniStat(
                  label: 'वस्तू / Items',
                  value: '${girvi.items.length}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (girvi.status == GirviStatus.active ||
                girvi.status == GirviStatus.partialPaid ||
                girvi.status == GirviStatus.overdue)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _MiniActionChip(
                    icon: Icons.payments_outlined,
                    label: 'Pay',
                    onTap: () => context.goNamed(
                      PartialPaymentPage.routeName,
                      pathParameters: {'id': girvi.id},
                    ),
                  ),
                  const SizedBox(width: 8),
                  _MiniActionChip(
                    icon: Icons.refresh_outlined,
                    label: 'Renew',
                    onTap: () => context.goNamed(
                      RenewalPage.routeName,
                      pathParameters: {'id': girvi.id},
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

class _MiniStat extends StatelessWidget {
  const _MiniStat(
      {required this.label,
      required this.value,
      this.valueColor = CustomerColors.ink});

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  color: valueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _MiniActionChip extends StatelessWidget {
  const _MiniActionChip(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: CustomerColors.navy.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: CustomerColors.navy),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: CustomerColors.navy,
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

class _NoLoansBanner extends StatelessWidget {
  const _NoLoansBanner({required this.onNewGirvi});

  final VoidCallback onNewGirvi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomerColors.line),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 48,
            color: CustomerColors.muted,
          ),
          const SizedBox(height: 12),
          const Text(
            'कोणतेही गिरवी नाही',
            style: TextStyle(
              color: CustomerColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No active or past loans found for this customer.',
            textAlign: TextAlign.center,
            style: TextStyle(color: CustomerColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onNewGirvi,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('नवीन गिरवी तयार करा / New Girvi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomerColors.navy,
              foregroundColor: CustomerColors.gold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTab extends StatelessWidget {
  const _PaymentTab();

  @override
  Widget build(BuildContext context) {
    return const _DataPlaceholder(
      icon: Icons.payments_outlined,
      titleMr: 'पेमेंट इतिहास',
      titleEn: 'Payment History',
      bodyMr: 'ग्राहकाची सर्व देयके आणि व्यवहार येथे दिसतील.',
      bodyEn: 'All customer payments and transactions will appear here.',
    );
  }
}

class _SchemesTab extends StatelessWidget {
  const _SchemesTab();

  @override
  Widget build(BuildContext context) {
    return const _DataPlaceholder(
      icon: Icons.savings_outlined,
      titleMr: 'बचत योजना',
      titleEn: 'Savings Schemes',
      bodyMr: 'ग्राहकाच्या बचत योजना येथे दाखवल्या जातील.',
      bodyEn: 'Customer savings schemes will be displayed here.',
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return const _DataPlaceholder(
      icon: Icons.history_outlined,
      titleMr: 'व्यवहार इतिहास',
      titleEn: 'Transaction History',
      bodyMr: 'देयके, नूतनीकरण आणि इतर सर्व व्यवहार येथे दिसतील.',
      bodyEn: 'Payments, renewals and all transactions will appear here.',
    );
  }
}

class _DataPlaceholder extends StatelessWidget {
  const _DataPlaceholder({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.bodyMr,
    required this.bodyEn,
  });

  final IconData icon;
  final String titleMr, titleEn;
  final String bodyMr, bodyEn;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CustomerColors.line),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: CustomerColors.navy.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Icon(icon, size: 36, color: CustomerColors.muted),
              ),
              const SizedBox(height: 16),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$bodyMr\n$bodyEn',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 12,
                  height: 1.5,
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
  const _BottomActionBar({required this.customer});

  final Customer customer;

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
                  onTap: () => _launchCall(context, customer.mobile),
                ),
              ),
              Container(width: 1, height: 36, color: CustomerColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  labelMr: 'WhatsApp',
                  labelEn: 'WhatsApp',
                  onTap: () => _launchWhatsApp(context, customer.mobile),
                ),
              ),
              Container(width: 1, height: 36, color: CustomerColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.share_outlined,
                  labelMr: 'शेअर करा',
                  labelEn: 'Share',
                  onTap: () => _shareCustomer(customer),
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
