import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/customer_colors.dart';
import 'customer_details_page.dart';

class CustomerSearchPage extends StatefulWidget {
  const CustomerSearchPage({super.key});

  static const routeName = 'customer-search';

  @override
  State<CustomerSearchPage> createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {
  final _controller = TextEditingController();
  int _modeIndex = 0;

  final List<String> _modes = const [
    'नाव / Name',
    'मोबाईल / Mobile',
    'आयडी / ID',
    'QR स्कॅन / QR Scan',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                hint: _modes[_modeIndex],
              ),
            ),
            _SearchModeTabs(
              modes: _modes,
              selectedIndex: _modeIndex,
              onChanged: (index) => setState(() => _modeIndex = index),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  _SearchResultCard(
                    name: 'सुरेश पाटील',
                    nameEn: 'Suresh Patil',
                    mobile: '+91 98765 43210',
                    activeGirvi: 2,
                    outstanding: '₹1,25,000',
                    lastTransaction: '12 Jun 2026',
                    onTap: () => context.goNamed(CustomerDetailsPage.routeName),
                  ),
                  const SizedBox(height: 12),
                  _SearchResultCard(
                    name: 'मीना जाधव',
                    nameEn: 'Meena Jadhav',
                    mobile: '+91 87654 32109',
                    activeGirvi: 1,
                    outstanding: '₹45,000',
                    lastTransaction: '10 Jun 2026',
                    onTap: () => context.goNamed(CustomerDetailsPage.routeName),
                  ),
                  const SizedBox(height: 12),
                  _SearchResultCard(
                    name: 'अमोल देशमुख',
                    nameEn: 'Amol Deshmukh',
                    mobile: '+91 76543 21098',
                    activeGirvi: 3,
                    outstanding: '₹2,80,000',
                    lastTransaction: '08 Jun 2026',
                    onTap: () => context.goNamed(CustomerDetailsPage.routeName),
                  ),
                ],
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
            onPressed: () => context.pop(),
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
  const _SearchField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
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
        suffixIcon: const Icon(Icons.mic, color: CustomerColors.muted),
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

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.name,
    required this.nameEn,
    required this.mobile,
    required this.activeGirvi,
    required this.outstanding,
    required this.lastTransaction,
    this.onTap,
  });

  final String name;
  final String nameEn;
  final String mobile;
  final int activeGirvi;
  final String outstanding;
  final String lastTransaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                    name,
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
                    nameEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: CustomerColors.muted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        mobile,
                        style: const TextStyle(
                          color: CustomerColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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
                Text(
                  outstanding,
                  style: const TextStyle(
                    color: CustomerColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$activeGirvi गिरवी / Girvi',
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lastTransaction,
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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
