import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Single source of truth for all text styles in the app.
///
/// Scale:
///   screenTitle  – 17 w800  – screen/module titles in headers
///   sectionTitle – 15 w700  – card/section headings
///   bodyLarge    – 14 w600  – primary emphasis (names, key values)
///   bodyMedium   – 13 w400  – standard body text
///   bodySmall    – 12 w400  – secondary body, helper text
///   labelLarge   – 11 w600  – badges, chips, small headings
///   labelSmall   – 10 w500  – timestamps, metadata, tiny info
///   statLarge    – 22 w800  – hero stat numbers
///   statMedium   – 18 w800  – card stat numbers
///   amountLarge  – 20 w800  – monetary amounts (primary)
///   amountMedium – 16 w700  – monetary amounts (secondary)
abstract class AppTextStyles {
  static const screenTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.ink,
  );

  static const sectionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );

  static const bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );

  static const labelLarge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
  );

  static const labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  static const statLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );

  static const statMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );

  static const amountLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );

  static const amountMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );
}
