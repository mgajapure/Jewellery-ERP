import 'package:flutter/material.dart';

import '../l10n/app_l10n_provider.dart';
import '../theme/app_colors.dart';

/// Shared full-width bottom navigation used across the main app shells.
///
/// Items (left-to-right):
/// 0 - Dashboard
/// 1 - Girvi
/// 2 - Customers
/// 3 - More
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final s = AppLangProvider.of(context);
    final items = [
      (Icons.home_outlined, s.navDashboard),
      (Icons.diamond_outlined, s.navGirvi),
      (Icons.groups_outlined, s.navCustomers),
      (Icons.apps_outlined, s.navMore),
    ];

    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final (icon, label) = items[index];
          final selected = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: selected ? AppColors.gold : AppColors.ink,
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? AppColors.gold : AppColors.ink,
                      fontSize: 10,
                      fontWeight:
                          selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
