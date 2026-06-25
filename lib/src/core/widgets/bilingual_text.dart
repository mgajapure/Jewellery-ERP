import 'dart:math';
import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../l10n/app_l10n_provider.dart';
import '../theme/app_colors.dart';

/// A text widget that adapts to the selected app language.
///
/// Behaviour:
/// - **English** mode  → shows only [en] at [style]'s size
/// - **Marathi/Hindi** → shows native text (style.fontSize + 2, same weight)
///                       followed by [en] in a smaller muted line below
///
/// Falls back to [en] when the native string is not provided.
class BilingualText extends StatelessWidget {
  const BilingualText({
    super.key,
    required this.en,
    this.mr,
    this.hi,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.compact = false,
  });

  /// English text (always required; also the fallback).
  final String en;

  /// Marathi text — shown as primary when Marathi is selected.
  final String? mr;

  /// Hindi text — shown as primary when Hindi is selected. Falls back to [mr].
  final String? hi;

  /// Base text style (used for English display; sizing is adjusted for bilingual).
  final TextStyle? style;

  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  /// When true, bilingual mode shows only the native text at base size
  /// (no secondary English line). Use for badges, chips, and tight spaces.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppLangProvider>();
    final lang = provider?.notifier?.language ?? AppLanguage.en;
    final base = style ?? DefaultTextStyle.of(context).style;
    final baseFontSize = base.fontSize ?? 13;

    switch (lang) {
      case AppLanguage.en:
        return Text(
          en,
          style: base,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        );
      case AppLanguage.mr:
        final native = mr;
        if (native == null) {
          return Text(en, style: base, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
        }
        if (compact) return Text(native, style: base, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
        return _bilingual(native, en, base, baseFontSize);
      case AppLanguage.hi:
        final native = hi ?? mr;
        if (native == null) {
          return Text(en, style: base, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
        }
        if (compact) return Text(native, style: base, maxLines: maxLines, overflow: overflow, textAlign: textAlign);
        return _bilingual(native, en, base, baseFontSize);
    }
  }

  Widget _bilingual(
      String primary, String secondary, TextStyle base, double baseFontSize) {
    final align = textAlign == TextAlign.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        Text(
          primary,
          style: base.copyWith(fontSize: baseFontSize + 2),
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        ),
        Text(
          secondary,
          style: base.copyWith(
            fontSize: max(9, baseFontSize - 2).toDouble(),
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        ),
      ],
    );
  }
}
