import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../l10n/app_l10n_provider.dart';
import '../theme/app_colors.dart';
import 'bilingual_text.dart';

/// Shared full-width bottom navigation used across the main app shells.
///
/// Items (left-to-right):  0=Dashboard  1=Girvi  2=Customers  3=More
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  // (en, mr, hi, icon)
  static const _items = [
    ('Dashboard', 'डॅशबोर्ड', 'डैशबोर्ड', Icons.home_outlined),
    ('Girvi', 'गिरवी', 'गिरवी', Icons.diamond_outlined),
    ('Customers', 'ग्राहक', 'ग्राहक', Icons.groups_outlined),
    ('More', 'अधिक', 'और', Icons.apps_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppLangProvider>();
    final isEnglish =
        (provider?.notifier?.language ?? AppLanguage.en) == AppLanguage.en;

    return Container(
      height: isEnglish ? 64 : 76,
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
          final (en, mr, hi, icon) = _items[index];
          final selected = index == currentIndex;
          final itemColor = selected ? AppColors.gold : AppColors.ink;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: itemColor, size: 22),
                  const SizedBox(height: 3),
                  BilingualText(
                    en: en,
                    mr: mr,
                    hi: hi,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 10,
                      fontWeight:
                          selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
