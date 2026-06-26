import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_navigation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'bilingual_text.dart';

/// Shared screen header used across the app.
///
/// Title is displayed via [BilingualText]:
/// - English mode → only [titleEn] at screenTitle size
/// - Marathi mode → [titleMr] (larger) + [titleEn] (smaller, muted) below
/// - Hindi mode   → [titleHi] (or [titleMr]) (larger) + [titleEn] below
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.titleMr,
    required this.titleEn,
    this.titleHi,
    this.leading,
    this.showBackButton = false,
    this.backFallbackRoute,
    this.actions = const [],
  });

  final String titleMr;
  final String titleEn;

  /// Optional Hindi title. Falls back to [titleMr] when not provided.
  final String? titleHi;

  final Widget? leading;
  final bool showBackButton;
  final String? backFallbackRoute;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () {
                final fallback = backFallbackRoute;
                if (fallback != null) {
                  AppNavigation.popOrGoNamed(context, fallback);
                } else {
                  if (context.canPop()) context.pop();
                }
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.ink),
              tooltip: 'Back',
            )
          else if (leading != null)
            leading!
          else
            const SizedBox(width: 48),
          Expanded(
            child: BilingualText(
              en: titleEn,
              mr: titleMr,
              hi: titleHi ?? titleMr,
              style: AppTextStyles.screenTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actions.isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: actions)
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Shared list screen header without a back button.
///
/// Use for top-level shell screens that already have a bottom navigation bar.
class AppListHeader extends StatelessWidget {
  const AppListHeader({
    super.key,
    required this.titleMr,
    required this.titleEn,
    this.titleHi,
    this.actionIcon,
    this.actionTooltip,
    this.onAction,
  });

  final String titleMr;
  final String titleEn;
  final String? titleHi;
  final IconData? actionIcon;
  final String? actionTooltip;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: BilingualText(
              en: titleEn,
              mr: titleMr,
              hi: titleHi ?? titleMr,
              style: AppTextStyles.screenTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionIcon != null)
            IconButton(
              onPressed: onAction,
              icon: Icon(actionIcon, color: AppColors.ink),
              tooltip: actionTooltip,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
