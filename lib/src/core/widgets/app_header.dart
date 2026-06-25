import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_language.dart';
import '../l10n/app_l10n_provider.dart';
import '../navigation/app_navigation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Shared screen header used across the app.
///
/// Displays the title in the currently selected app language. When [titleHi]
/// is not provided, Hindi falls back to [titleMr].
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

  String _resolveTitle(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppLangProvider>();
    if (provider == null) return '$titleMr / $titleEn';
    switch (provider.notifier!.language) {
      case AppLanguage.mr:
        return titleMr;
      case AppLanguage.hi:
        return titleHi ?? titleMr;
      case AppLanguage.en:
        return titleEn;
    }
  }

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
              _resolveTitle(context),
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

  String _resolveTitle(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppLangProvider>();
    if (provider == null) return '$titleMr / $titleEn';
    switch (provider.notifier!.language) {
      case AppLanguage.mr:
        return titleMr;
      case AppLanguage.hi:
        return titleHi ?? titleMr;
      case AppLanguage.en:
        return titleEn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _resolveTitle(context),
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
