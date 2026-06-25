import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_navigation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shared screen header used across the app.
///
/// Follows the personalized Girvi list header style: a light background, a
/// centered bilingual title, an optional leading back/action button on the
/// left and an optional action icon on the right.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.titleMr,
    required this.titleEn,
    this.leading,
    this.showBackButton = false,
    this.backFallbackRoute,
    this.actions = const [],
  });

  /// Marathi title shown on top.
  final String titleMr;

  /// English subtitle shown below the Marathi title.
  final String titleEn;

  /// Optional leading widget. When [showBackButton] is true a back arrow is
  /// rendered instead.
  final Widget? leading;

  /// Whether to show a back arrow on the left.
  final bool showBackButton;

  /// Route to navigate to when the back arrow is pressed but the navigator has
  /// nothing to pop (e.g. the screen was reached via [context.goNamed]).
  final String? backFallbackRoute;

  /// Optional action widgets shown on the right.
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
                  if (context.canPop()) {
                    context.pop();
                  }
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
            child: Text(
              '$titleMr / $titleEn',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.screenTitle,
            ),
          ),
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Shared list screen header without a back button.
///
/// Matches the Girvi list header: centered bilingual title + optional action
/// icon on the right. Use for top-level shell screens that already have a
/// bottom navigation bar.
class AppListHeader extends StatelessWidget {
  const AppListHeader({
    super.key,
    required this.titleMr,
    required this.titleEn,
    this.actionIcon,
    this.actionTooltip,
    this.onAction,
  });

  final String titleMr;
  final String titleEn;
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
            child: Text(
              '$titleMr / $titleEn',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.screenTitle,
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
