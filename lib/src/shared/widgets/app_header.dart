import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_navigation.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

/// Shared screen header with bilingual title.
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

  final String titleMr;
  final String titleEn;
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
                } else if (context.canPop()) {
                  context.pop();
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
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.title.copyWith(fontSize: 16),
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

/// List screen header without back button.
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
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 4,
            child: Text(
              '$titleMr / $titleEn',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.title.copyWith(fontSize: 16),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: actionIcon != null
                  ? IconButton(
                      onPressed: onAction,
                      icon: Icon(actionIcon, color: AppColors.ink),
                      tooltip: actionTooltip,
                    )
                  : const SizedBox(width: 48),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header used inside screens.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}
