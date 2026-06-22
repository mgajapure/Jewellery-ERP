import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared navigation helpers for the app.
///
/// All back buttons should use [popOrGoNamed] so they keep working even when
/// the current screen was reached via [context.goNamed] (which replaces the
/// whole route stack). In that case [context.pop] has nowhere to go, so we
/// fall back to the supplied named route.
abstract class AppNavigation {
  /// Pops the current route if possible; otherwise navigates to [fallbackRoute].
  static void popOrGoNamed(
    BuildContext context,
    String fallbackRoute, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> extra = const {},
  }) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(
        fallbackRoute,
        pathParameters: pathParameters,
        extra: extra,
      );
    }
  }

  /// Returns the fallback route that should be used for screens launched from
  /// the module hub. Deep screens usually have a more specific parent, but
  /// [MorePage.routeName] is the safest default when the launch source is
  /// unknown.
  static String moduleFallbackRoute(String module) {
    switch (module) {
      case 'inventory':
      case 'vault':
      case 'interest':
      case 'compliance':
      case 'purchase':
      case 'sales':
      case 'savings':
      case 'reports':
      case 'staff':
      case 'settings':
        return 'more';
      default:
        return 'dashboard';
    }
  }
}
