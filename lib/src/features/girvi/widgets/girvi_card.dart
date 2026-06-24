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
    this.onPayTap,
    this.onRenewTap,
    this.onRedeemTap,
  });

  final Girvi girvi;
  final VoidCallback onTap;
  final VoidCallback? onPayTap;
  final VoidCallback? onRenewTap;
  final VoidCallback? onRedeemTap;

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

  bool get _isActionable =>
      girvi.status == GirviStatus.active ||
      girvi.status == GirviStatus.partialPaid ||
      girvi.status == GirviStatus.overdue;

  Color? get _accentColor {
    if (girvi.status == GirviStatus.overdue || girvi.daysLeft < 0) {
      return GirviColors.red;
    }
    if (girvi.daysLeft <= 7) return GirviColors.orange;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;
    final showActions = _isActionable &&
        (onPayTap != null || onRenewTap != null || onRedeemTap != null);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent != null
                  ? accent.withValues(alpha: 0.03)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accent != null
                    ? accent.withValues(alpha: 0.35)
                    : GirviColors.line,
              ),
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
                if (showActions) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: GirviColors.line),
                  const SizedBox(height: 8),
                  _ActionRow(
                    onPayTap: onPayTap,
                    onRenewTap: onRenewTap,
                    onRedeemTap: onRedeemTap,
                  ),
                ],
              ],
            ),
          ),
          if (accent != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({this.onPayTap, this.onRenewTap, this.onRedeemTap});

  final VoidCallback? onPayTap;
  final VoidCallback? onRenewTap;
  final VoidCallback? onRedeemTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onPayTap != null)
          Expanded(
            child: _QuickActionBtn(
              icon: Icons.payments_outlined,
              labelMr: 'भरणा',
              labelEn: 'Pay',
              color: GirviColors.green,
              onTap: onPayTap!,
            ),
          ),
        if (onRenewTap != null && onPayTap != null)
          Container(width: 1, height: 32, color: GirviColors.line),
        if (onRenewTap != null)
          Expanded(
            child: _QuickActionBtn(
              icon: Icons.refresh_outlined,
              labelMr: 'नूतन',
              labelEn: 'Renew',
              color: GirviColors.navy,
              onTap: onRenewTap!,
            ),
          ),
        if (onRedeemTap != null && (onPayTap != null || onRenewTap != null))
          Container(width: 1, height: 32, color: GirviColors.line),
        if (onRedeemTap != null)
          Expanded(
            child: _QuickActionBtn(
              icon: Icons.undo_outlined,
              labelMr: 'परत',
              labelEn: 'Redeem',
              color: GirviColors.gold,
              onTap: onRedeemTap!,
            ),
          ),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  const _QuickActionBtn({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 3),
            Text(
              labelMr,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              labelEn,
              style: const TextStyle(
                color: GirviColors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
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
