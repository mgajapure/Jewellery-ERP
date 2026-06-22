import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Currency formatter for INR.
extension CurrencyFormatting on double {
  String toRupeeString() {
    return '₹${NumberFormat('#,##,##0', 'en_IN').format(toInt())}';
  }
}

/// Date formatting helpers.
extension DateFormatting on DateTime {
  String toDisplayDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }
}

/// SnackBar helper.
extension BuildContextX on BuildContext {
  void showAppSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFE21B2D) : const Color(0xFF07934A),
      ),
    );
  }
}
