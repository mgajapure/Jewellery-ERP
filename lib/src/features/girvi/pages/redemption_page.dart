import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/girvi_colors.dart';

/// SCR-030 Redemption
///
/// Closes a Girvi contract after full payment, item photo verification,
/// and vault release. Generates a final receipt.
class RedemptionPage extends StatefulWidget {
  const RedemptionPage({super.key});

  static const routeName = 'redemption';

  @override
  State<RedemptionPage> createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage> {
  bool _photoVerified = false;
  bool _vaultReleased = false;
  bool _fullPaymentReceived = false;

  final double _outstanding = 100917.81;
  final String _girviId = 'GRV-2026-000042';
  final String _customer = 'Ramesh Patil';

  bool get _canRedeem {
    return _fullPaymentReceived && _photoVerified && _vaultReleased;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      appBar: AppBar(
        backgroundColor: GirviColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'मुद्दलपरत',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Redemption',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(
                      girviId: _girviId,
                      customer: _customer,
                      outstanding: _outstanding,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      titleMr: 'पूर्वप्रतिमा तपासणी',
                      titleEn: 'Redemption Checklist',
                    ),
                    const SizedBox(height: 12),
                    _ChecklistTile(
                      icon: Icons.currency_rupee,
                      titleMr: 'पूर्ण पेमेंट घेतले',
                      titleEn: 'Full Payment Received',
                      subtitle: '₹ ${_outstanding.toStringAsFixed(2)}',
                      value: _fullPaymentReceived,
                      onChanged: (value) {
                        setState(() => _fullPaymentReceived = value ?? false);
                      },
                    ),
                    const SizedBox(height: 10),
                    _ChecklistTile(
                      icon: Icons.photo_camera_outlined,
                      titleMr: 'वस्तू फोटो पडताळणी',
                      titleEn: 'Item Photo Verified',
                      subtitle: 'Capture returned item photos',
                      value: _photoVerified,
                      onChanged: (value) {
                        setState(() => _photoVerified = value ?? false);
                      },
                    ),
                    const SizedBox(height: 10),
                    _ChecklistTile(
                      icon: Icons.logout_outlined,
                      titleMr: 'तिजोरी मुक्त',
                      titleEn: 'Vault Released',
                      subtitle: 'VA-A/SF-02/TR-05/SL-18',
                      value: _vaultReleased,
                      onChanged: (value) {
                        setState(() => _vaultReleased = value ?? false);
                      },
                    ),
                    const SizedBox(height: 24),
                    _InfoBox(
                      textMr:
                          'मुद्दलपरत झाल्यानंतर सोने ७ कार्यदिवसांच्या आत ग्राहकाला परत करावे.',
                      textEn:
                          'After redemption, gold must be returned to the customer within 7 working days.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GirviColors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: GirviColors.line,
                    disabledForegroundColor: GirviColors.muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _canRedeem
                      ? () {
                          // TODO: close contract, release vault, generate receipt.
                          context.pop();
                        }
                      : null,
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text(
                    'मुद्दलपरत पूर्ण करा / Complete Redemption',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.girviId,
    required this.customer,
    required this.outstanding,
  });

  final String girviId;
  final String customer;
  final double outstanding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GirviColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            girviId,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: GirviColors.gold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            customer,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'पूर्ण पेमेंट देय / Full Payment Due',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${outstanding.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: GirviColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: GirviColors.muted,
          ),
        ),
      ],
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String titleMr;
  final String titleEn;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: value
                  ? GirviColors.green.withAlpha(15)
                  : GirviColors.screenBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? GirviColors.green : GirviColors.navy,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$titleMr / $titleEn',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: GirviColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GirviColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: GirviColors.green,
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.textMr, required this.textEn});

  final String textMr;
  final String textEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GirviColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.gold.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: GirviColors.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textMr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: GirviColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  textEn,
                  style: TextStyle(
                    fontSize: 12,
                    color: GirviColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
