import 'package:flutter/material.dart';

import '../domain/entities/girvi.dart';
import '../theme/girvi_colors.dart';

class GirviStatusBadge extends StatelessWidget {
  const GirviStatusBadge({super.key, required this.status});

  final GirviStatus status;

  Color get _color {
    switch (status) {
      case GirviStatus.overdue:
        return GirviColors.red;
      case GirviStatus.redeemed:
        return GirviColors.muted;
      case GirviStatus.partialPaid:
      case GirviStatus.renewed:
        return GirviColors.gold;
      case GirviStatus.active:
        return GirviColors.green;
    }
  }

  String get _label {
    switch (status) {
      case GirviStatus.active:
        return 'सक्रिय / Active';
      case GirviStatus.partialPaid:
        return 'आंशिक पेड / Partial';
      case GirviStatus.renewed:
        return 'नवीनीकृत / Renewed';
      case GirviStatus.redeemed:
        return 'मुद्दलपरत / Redeemed';
      case GirviStatus.overdue:
        return 'ओव्हरड्यू / Overdue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
