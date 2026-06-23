import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation.dart';
import '../domain/entities/customer.dart';
import '../presentation/bloc/customer_list_bloc.dart';
import '../presentation/bloc/customer_list_event.dart';
import '../presentation/bloc/customer_list_state.dart';
import '../theme/customer_colors.dart';
import 'customer_details_page.dart';
import 'customer_list_page.dart';

class CustomerSearchPage extends StatelessWidget {
  const CustomerSearchPage({super.key});

  static const routeName = 'customer-search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CustomerListBloc>(),
      child: const _CustomerSearchView(),
    );
  }
}

class _CustomerSearchView extends StatefulWidget {
  const _CustomerSearchView();

  @override
  State<_CustomerSearchView> createState() => _CustomerSearchViewState();
}

class _CustomerSearchViewState extends State<_CustomerSearchView> {
  final _controller = TextEditingController();
  Timer? _debounce;
  int _modeIndex = 0;

  static const _modes = [
    (label: 'नाव / Name', hint: 'ग्राहकाचे नाव टाका', kb: TextInputType.name),
    (
      label: 'मोबाईल / Mobile',
      hint: 'मोबाईल नंबर टाका',
      kb: TextInputType.phone,
    ),
    (label: 'आयडी / ID', hint: 'ग्राहक ID टाका', kb: TextInputType.text),
    (label: 'QR स्कॅन / QR Scan', hint: 'QR कोड स्कॅन करा', kb: TextInputType.none),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String query) {
    _debounce?.cancel();
    if (_modeIndex == 3) return; // QR mode — no text search
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<CustomerListBloc>().add(SearchCustomerList(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _SearchHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: _SearchField(
                controller: _controller,
                hint: _modes[_modeIndex].hint,
                keyboardType: _modes[_modeIndex].kb,
                onChanged: _onTextChanged,
              ),
            ),
            _SearchModeTabs(
              modes: _modes.map((m) => m.label).toList(),
              selectedIndex: _modeIndex,
              onChanged: (index) {
                setState(() => _modeIndex = index);
                _controller.clear();
                context
                    .read<CustomerListBloc>()
                    .add(const SearchCustomerList(''));
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<CustomerListBloc, CustomerListState>(
                builder: (context, state) {
                  if (state is CustomerListInitial) {
                    return _SearchHint(mode: _modes[_modeIndex].label);
                  }
                  if (state is CustomerListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: CustomerColors.navy,
                        strokeWidth: 2.5,
                      ),
                    );
                  }
                  if (state is CustomerListError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: CustomerColors.muted,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is CustomerListLoaded) {
                    if (state.searchQuery.isEmpty) {
                      return _SearchHint(mode: _modes[_modeIndex].label);
                    }
                    if (state.displayList.isEmpty) {
                      return _NoResults(query: state.searchQuery);
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: state.displayList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _SearchResultCard(customer: state.displayList[index]),
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

class _SearchHeader extends StatelessWidget {
  const _SearchHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
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
              'ग्राहक शोध / Customer Search',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(
          color: CustomerColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(Icons.search, color: CustomerColors.muted),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: CustomerColors.muted),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : const Icon(Icons.mic, color: CustomerColors.muted),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomerColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomerColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CustomerColors.navy, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

class _SearchModeTabs extends StatelessWidget {
  const _SearchModeTabs({
    required this.modes,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> modes;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: modes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return ChoiceChip(
            label: Text(
              modes[index],
              style: TextStyle(
                color: selected ? CustomerColors.gold : CustomerColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected,
            selectedColor: CustomerColors.navy,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected ? CustomerColors.navy : CustomerColors.line,
              ),
            ),
            onSelected: (_) => onChanged(index),
          );
        },
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint({required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 56,
              color: CustomerColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'शोध सुरू करा / Start Searching',
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'वर $mode वापरून शोधा',
              style: const TextStyle(
                color: CustomerColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 56,
              color: CustomerColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'ग्राहक सापडला नाही',
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"$query" साठी कोणताही ग्राहक नाही\nNo customer found for "$query"',
              style: const TextStyle(
                color: CustomerColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.customer});

  final Customer customer;

  String _formatOutstanding(double amount) {
    if (amount == 0) return '₹0';
    if (amount >= 100000) return '₹${(amount / 100000).toStringAsFixed(2)}L';
    if (amount >= 1000) return '₹${(amount / 1000).toStringAsFixed(0)}K';
    return '₹${amount.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.goNamed(
        CustomerDetailsPage.routeName,
        pathParameters: {'id': customer.id},
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: CustomerColors.navy.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.person_outline,
                color: CustomerColors.navy,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CustomerColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 13,
                        color: CustomerColors.muted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        customer.mobile,
                        style: const TextStyle(
                          color: CustomerColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.digitalCustomerId,
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatOutstanding(customer.outstanding),
                  style: const TextStyle(
                    color: CustomerColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${customer.activeGirvi} गिरवी / Girvi',
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (customer.isActive
                            ? CustomerColors.green
                            : CustomerColors.red)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    customer.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: customer.isActive
                          ? CustomerColors.green
                          : CustomerColors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
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
