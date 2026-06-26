import 'package:flutter/material.dart';

import '../../../core/widgets/bilingual_text.dart';
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

  ({String mr, String en, String hi}) get _label {
    switch (status) {
      case GirviStatus.active:
        return (mr: 'सक्रिय', en: 'Active', hi: 'सक्रिय');
      case GirviStatus.partialPaid:
        return (mr: 'आंशिक पेड', en: 'Partial', hi: 'आंशिक भुगतान');
      case GirviStatus.renewed:
        return (mr: 'नवीनीकृत', en: 'Renewed', hi: 'नवीनीकृत');
      case GirviStatus.redeemed:
        return (mr: 'मुद्दलपरत', en: 'Redeemed', hi: 'मुक्त');
      case GirviStatus.overdue:
        return (mr: 'ओव्हरड्यू', en: 'Overdue', hi: 'अतिदेय');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (:mr, :en, :hi) = _label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: BilingualText(
        en: en,
        mr: mr,
        hi: hi,
        compact: true,
        style: TextStyle(
          color: _color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
