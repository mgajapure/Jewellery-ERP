import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dashboard/dashboard_page.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_divider_gem.dart';
import '../widgets/auth_info_notice.dart';

class RegistrationPendingPage extends StatefulWidget {
  const RegistrationPendingPage({super.key});

  static const routeName = 'registration-pending';

  @override
  State<RegistrationPendingPage> createState() =>
      _RegistrationPendingPageState();
}

class _RegistrationPendingPageState extends State<RegistrationPendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthDarkBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const _PendingBadge(),
                Expanded(child: _PendingSheet(onContinue: () {
                  context.goNamed(DashboardPage.routeName);
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  const _PendingBadge();

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.sizeOf(context).height * 0.16).clamp(80.0, 126.0);
    final boxSize = size + 16;
    return SizedBox(
      height: boxSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0C6F61).withValues(alpha: 0.65),
              border: Border.all(color: AuthColors.mutedGold),
            ),
            child: Icon(
              Icons.hourglass_empty,
              color: AuthColors.gold,
              size: size * 0.26,
            ),
          ),
          Positioned(
            left: boxSize * 0.29,
            top: boxSize * 0.15,
            child: const Icon(Icons.auto_awesome, color: AuthColors.gold, size: 15),
          ),
          Positioned(
            right: boxSize * 0.30,
            bottom: boxSize * 0.20,
            child: const Icon(Icons.auto_awesome, color: AuthColors.gold, size: 15),
          ),
          Positioned(
            left: boxSize * 0.12,
            bottom: boxSize * 0.30,
            child: const Icon(Icons.auto_awesome, color: AuthColors.gold, size: 18),
          ),
        ],
      ),
    );
  }
}

class _PendingSheet extends StatelessWidget {
  const _PendingSheet({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const Spacer(flex: 3),
            const Text(
              'नोंदणी विनंती पाठवली आहे',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Registration Request Sent',
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(flex: 3),
            const AuthDividerGem(width: double.infinity),
            const Spacer(flex: 3),
            const _PendingLine(
              icon: Icons.person_outline,
              marathi: 'तुमची विनंती मालकाकडे पाठवली आहे.',
              english: 'Your request has been sent to the Owner.',
            ),
            const Spacer(flex: 2),
            const _PendingLine(
              icon: Icons.notifications_none,
              marathi: 'मालक मंजुरी देईपर्यंत कृपया थांबा.',
              english: 'Please wait until Owner approves.',
            ),
            const Spacer(flex: 2),
            const _PendingLine(
              icon: Icons.phone_android_outlined,
              marathi: 'मंजुरीनंतर तुम्ही या डिव्हाइसवर लॉगिन करू शकाल.',
              english: 'You will be able to login on this device after approval.',
            ),
            const Spacer(flex: 3),
            const AuthInfoNotice(
              icon: Icons.schedule_outlined,
              marathi: 'हे सामान्यत: काही मिनिटांत पूर्ण होते.',
              english: 'This usually takes a few minutes.',
            ),
            const Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AuthColors.ink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'ठीक आहे, डॅशबोर्डवर जा / Go to Dashboard',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _PendingLine extends StatelessWidget {
  const _PendingLine({
    required this.icon,
    required this.marathi,
    required this.english,
  });

  final IconData icon;
  final String marathi;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AuthColors.ink),
          ),
          child: Icon(icon, color: AuthColors.ink, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            '$marathi\n$english',
            style: const TextStyle(
              color: AuthColors.ink,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
