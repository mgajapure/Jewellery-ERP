import 'package:flutter/widgets.dart';

import 'app_language.dart';
import 'app_l10n.dart';

/// InheritedNotifier that makes [AppLanguageNotifier] and [AppL10n] accessible
/// to any descendant widget via [AppLangProvider.of] / [AppLangProvider.notifierOf].
class AppLangProvider extends InheritedNotifier<AppLanguageNotifier> {
  const AppLangProvider({
    super.key,
    required AppLanguageNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppLanguageNotifier notifierOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppLangProvider>()!
        .notifier!;
  }

  /// Returns the [AppL10n] instance for the currently selected language.
  /// Widgets that call this will rebuild automatically on language change.
  static AppL10n of(BuildContext context) =>
      AppL10n.forLanguage(notifierOf(context).language);
}
