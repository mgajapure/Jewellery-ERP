import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';

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

  static const _items = [
    _NavItemConfig(
      icon: Icons.home_outlined,
      titleMr: 'डॅशबोर्ड',
      titleEn: 'Dashboard',
    ),
    _NavItemConfig(
      icon: Icons.diamond_outlined,
      titleMr: 'गिरवी',
      titleEn: 'Girvi',
    ),
    _NavItemConfig(
      icon: Icons.groups_outlined,
      titleMr: 'ग्राहक',
      titleEn: 'Customers',
    ),
    _NavItemConfig(
      icon: Icons.apps_outlined,
      titleMr: 'अधिक',
      titleEn: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.only(top: 8),
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
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final selected = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: selected ? AppColors.secondary : AppColors.ink,
                    size: 22,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.titleMr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? AppColors.secondary : AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    item.titleEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? AppColors.ink : AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
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

class _NavItemConfig {
  const _NavItemConfig({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
}
