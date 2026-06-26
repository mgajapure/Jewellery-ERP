import 'package:flutter/material.dart';

import '../theme/girvi_colors.dart';

class GirviInfoRow extends StatelessWidget {
  const GirviInfoRow({
    super.key,
    required this.labelMr,
    required this.labelEn,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelMr,
                style: const TextStyle(
                  color: GirviColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                labelEn,
                style: const TextStyle(
                  color: GirviColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? GirviColors.ink,
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
