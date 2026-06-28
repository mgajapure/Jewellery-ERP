import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../domain/entities/supplier.dart';
import '../presentation/bloc/supplier_bloc.dart';
import '../theme/purchase_colors.dart';
import 'purchase_dashboard_page.dart';

/// SCR-060 Supplier Management
class SupplierManagementPage extends StatelessWidget {
  const SupplierManagementPage({super.key});

  static const routeName = 'suppliers';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<SupplierBloc>()..add(const SupplierListStarted()),
      child: const _SupplierView(),
    );
  }
}

class _SupplierView extends StatefulWidget {
  const _SupplierView();

  @override
  State<_SupplierView> createState() => _SupplierViewState();
}

class _SupplierViewState extends State<_SupplierView> {
  final _searchCtrl = TextEditingController();

  static const _filters = [
    ('', 'सर्व / All'),
    ('ACTIVE', 'सक्रिय / Active'),
    ('INACTIVE', 'निष्क्रिय / Inactive'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showNewSupplierSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NewSupplierSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PurchaseColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'पुरवठादार यादी',
              titleEn: 'Suppliers',
              showBackButton: true,
              backFallbackRoute: PurchaseDashboardPage.routeName,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: PurchaseColors.ink),
                  tooltip: 'नवीन पुरवठादार / New Supplier',
                  onPressed: () => _showNewSupplierSheet(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _SearchBar(
                controller: _searchCtrl,
                onChanged: (q) => context
                    .read<SupplierBloc>()
                    .add(SupplierSearchChanged(q)),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<SupplierBloc, SupplierState>(
              buildWhen: (p, c) =>
                  (p is SupplierLoaded ? p.filter : '') !=
                  (c is SupplierLoaded ? c.filter : ''),
              builder: (context, state) {
                final selected =
                    state is SupplierLoaded ? state.filter : '';
                return _FilterChips(
                  filters: _filters,
                  selected: selected,
                  onSelected: (f) => context
                      .read<SupplierBloc>()
                      .add(SupplierFilterChanged(f)),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                color: PurchaseColors.navy,
                onRefresh: () async => context
                    .read<SupplierBloc>()
                    .add(const SupplierListRefreshed()),
                child: BlocBuilder<SupplierBloc, SupplierState>(
                  builder: (context, state) {
                    if (state is SupplierLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: PurchaseColors.navy,
                        ),
                      );
                    }
                    if (state is SupplierError) {
                      return _ErrorView(
                        message: state.message,
                        onRetry: () => context
                            .read<SupplierBloc>()
                            .add(const SupplierListStarted()),
                      );
                    }
                    if (state is SupplierLoaded) {
                      if (state.suppliers.isEmpty) {
                        return const _EmptyState();
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: state.suppliers.length,
                        itemBuilder: (_, i) =>
                            _SupplierCard(supplier: state.suppliers[i]),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PurchaseColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: PurchaseColors.muted, size: 22),
          hintText: 'पुरवठादार शोधा / Search supplier',
          hintStyle: TextStyle(
            color: PurchaseColors.muted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<(String, String)> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (value, label) = filters[index];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                color: isSelected ? PurchaseColors.gold : PurchaseColors.ink,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(value),
            selectedColor: PurchaseColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color:
                    isSelected ? PurchaseColors.navy : PurchaseColors.line,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
    final isActive = supplier.status == SupplierStatus.active;
    final statusColor =
        isActive ? PurchaseColors.green : PurchaseColors.muted;

    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _SupplierDetailSheet(supplier: supplier),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PurchaseColors.line),
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
              children: [
                Expanded(
                  child: Text(
                    supplier.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: PurchaseColors.ink,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    supplier.status.labelEn,
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
            _InfoRow(icon: Icons.phone_outlined, value: supplier.mobile),
            const SizedBox(height: 6),
            _InfoRow(
                icon: Icons.numbers_outlined, value: supplier.gstNo),
            const Divider(height: 22, color: PurchaseColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _BiLabel(
                    labelMr: 'येणे बाकी', labelEn: 'Balance Due'),
                Text(
                  '₹${amtFmt.format(supplier.balanceDue)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.ink,
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
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PurchaseColors.muted),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: PurchaseColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BiLabel extends StatelessWidget {
  const _BiLabel({required this.labelMr, required this.labelEn});

  final String labelMr;
  final String labelEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelEn,
          style: const TextStyle(
            color: PurchaseColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_outlined, size: 56, color: PurchaseColors.muted),
          SizedBox(height: 12),
          Text(
            'कोणतेही पुरवठादार आढळले नाहीत',
            style: TextStyle(
              color: PurchaseColors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'No suppliers found',
            style: TextStyle(color: PurchaseColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: PurchaseColors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PurchaseColors.muted),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: PurchaseColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: BilingualText(en: 'Retry', mr: 'पुन्हा प्रयत्न', compact: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewSupplierSheet extends StatefulWidget {
  const _NewSupplierSheet();

  @override
  State<_NewSupplierSheet> createState() => _NewSupplierSheetState();
}

class _NewSupplierSheetState extends State<_NewSupplierSheet> {
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _gstCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _gstCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'नवीन पुरवठादार / New Supplier',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.ink,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: PurchaseColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SheetField(
              controller: _nameCtrl,
              labelMr: 'नाव',
              labelEn: 'Name',
              icon: Icons.business_outlined,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'नाव आवश्यक / Name required'
                  : null,
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: _mobileCtrl,
              labelMr: 'मोबाईल',
              labelEn: 'Mobile',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'वैध मोबाईल / Valid mobile required'
                  : null,
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: _gstCtrl,
              labelMr: 'GST क्रमांक',
              labelEn: 'GST No.',
              icon: Icons.numbers_outlined,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'पुरवठादार जोडणे लवकरच / Add supplier coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PurchaseColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'जतन करा / Save',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.labelMr,
    required this.labelEn,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String labelMr;
  final String labelEn;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: PurchaseColors.muted, size: 20),
        labelText: '$labelMr / $labelEn',
        labelStyle: const TextStyle(color: PurchaseColors.muted, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PurchaseColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PurchaseColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PurchaseColors.navy, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

class _SupplierDetailSheet extends StatelessWidget {
  const _SupplierDetailSheet({required this.supplier});

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    final amtFmt = NumberFormat('#,##,##0.00', 'en_IN');
    final isActive = supplier.status == SupplierStatus.active;
    final statusColor =
        isActive ? PurchaseColors.green : PurchaseColors.muted;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  supplier.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: PurchaseColors.ink,
                  ),
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
                  supplier.status.labelEn,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: PurchaseColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DetailRow(
            icon: Icons.phone_outlined,
            labelMr: 'मोबाईल',
            labelEn: 'Mobile',
            value: supplier.mobile,
          ),
          const Divider(color: PurchaseColors.line),
          _DetailRow(
            icon: Icons.numbers_outlined,
            labelMr: 'GST क्रमांक',
            labelEn: 'GST No.',
            value: supplier.gstNo,
          ),
          const Divider(color: PurchaseColors.line),
          _DetailRow(
            icon: Icons.account_balance_wallet_outlined,
            labelMr: 'येणे बाकी',
            labelEn: 'Balance Due',
            value: '₹${amtFmt.format(supplier.balanceDue)}',
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 18),
                  label: BilingualText(en: 'Close', mr: 'बंद करा', compact: true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PurchaseColors.muted,
                    side: const BorderSide(color: PurchaseColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            BilingualText(en: 'Purchase history coming soon', mr: 'खरेदी इतिहास लवकरच', compact: true),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.history, size: 18),
                  label: BilingualText(en: 'History', mr: 'इतिहास', compact: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PurchaseColors.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: PurchaseColors.muted),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$labelMr / $labelEn',
                style: const TextStyle(
                  color: PurchaseColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: PurchaseColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
