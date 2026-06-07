import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/auth_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_info_notice.dart';
import '../widgets/auth_round_icon.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/otp_boxes.dart';
import '../widgets/primary_auth_button.dart';
import 'registration_pending_page.dart';
import 'splash_page.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  static const routeName = 'otp-verification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLightScaffold(
        child: Column(
          children: [
            AuthTopBar(
              onBackPressed: () => context.goNamed(SplashPage.routeName),
            ),
            const Spacer(),
            const AuthRoundIcon(icon: Icons.gpp_good),
            const SizedBox(height: 28),
            const Text(
              'OTP प्रविष्ट करा',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Enter OTP',
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              '+91 98765 43210 वर पाठवलेला OTP\nOTP sent on +91 98765 43210',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 13,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            const OtpBoxes(),
            const SizedBox(height: 12),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '00:27 ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: 'सेकंद शिल्लक / sec remaining'),
                ],
              ),
              style: TextStyle(color: AuthColors.ink, fontSize: 13),
            ),
            const SizedBox(height: 8),
            const AuthInfoNotice(
              icon: Icons.verified_user_outlined,
              marathi: 'OTP कोणाशीही शेअर करू नका.',
              english: 'Do not share OTP with anyone.',
            ),
            const SizedBox(height: 24),
            const Text(
              'OTP आला नाही? / Didn\'t receive OTP?',
              style: TextStyle(color: AuthColors.ink, fontSize: 13),
            ),
            const SizedBox(height: 8),
            const Text(
              'पुन्हा पाठवा / Resend OTP',
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 28),
            PrimaryAuthButton(
              label: 'पडताळणी करा / Verify OTP',
              onPressed: () =>
                  context.goNamed(RegistrationPendingPage.routeName),
            ),
            const SizedBox(height: 30),
            const _AttemptsLine(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _AttemptsLine extends StatelessWidget {
  const _AttemptsLine();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, color: AuthColors.ink, size: 18),
        SizedBox(width: 8),
        Text(
          'कमाल 5 प्रयत्न / Max 5 attempts',
          style: TextStyle(color: AuthColors.ink, fontSize: 12),
        ),
      ],
    );
  }
}
