import 'package:flutter/material.dart';

import '../domain/entities/girvi.dart';
import '../theme/girvi_colors.dart';
import 'girvi_status_badge.dart';
import 'girvi_summary_row.dart';

class GirviCard extends StatelessWidget {
  const GirviCard({
    super.key,
    required this.girvi,
    required this.onTap,
  });

  final Girvi girvi;
  final VoidCallback onTap;

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)}L';
    }
    final str = amount.toStringAsFixed(0);
    final result = StringBuffer();
    final chars = str.split('').reversed.toList();
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) result.write(',');
      result.write(chars[i]);
    }
    return '₹${result.toString().split('').reversed.join()}';
  }

  String get _dueDateLabel {
    final d = girvi.dueDate;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GirviColors.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: GirviColors.ink,
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor: GirviColors.screenBg,
                    child: const Icon(
                      Icons.person,
                      size: 25,
                      color: GirviColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              girvi.customerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: GirviColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          GirviStatusBadge(status: girvi.status),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              girvi.customerNameEn,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: GirviColors.muted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            girvi.serialId,
                            style: const TextStyle(
                              color: GirviColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: GirviColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GirviSummaryRow(
                    labelMr: 'कर्ज रक्कम',
                    labelEn: 'Loan Amount',
                    value: _formatCurrency(girvi.loanAmount),
                  ),
                ),
                Container(width: 1, height: 50, color: GirviColors.line),
                Expanded(
                  child: GirviSummaryRow(
                    labelMr: 'बाकी रक्कम',
                    labelEn: 'Outstanding',
                    value: _formatCurrency(girvi.outstandingAmount),
                  ),
                ),
                Container(width: 1, height: 50, color: GirviColors.line),
                Expanded(
                  child: GirviSummaryRow(
                    labelMr: 'देय तारीख',
                    labelEn: 'Due Date',
                    value: _dueDateLabel,
                  ),
                ),
              ],
            ),
            const Divider(height: 22, color: GirviColors.line),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.diamond_outlined,
                      size: 14,
                      color: GirviColors.muted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${girvi.items.length} वस्तू / Items',
                      style: const TextStyle(
                        color: GirviColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                _DaysLeftChip(daysLeft: girvi.daysLeft),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DaysLeftChip extends StatelessWidget {
  const _DaysLeftChip({required this.daysLeft});

  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final isOverdue = daysLeft < 0;
    final color = isOverdue ? GirviColors.red : GirviColors.ink;
    final text = isOverdue
        ? '${-daysLeft} दिवस उशीर / Days Late'
        : daysLeft == 0
        ? 'आज देय / Due Today'
        : '$daysLeft दिवस शिल्लक / Days Left';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
