import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/auth_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_info_notice.dart';
import '../widgets/auth_round_icon.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/mobile_number_input.dart';
import '../widgets/primary_auth_button.dart';
import 'otp_verification_page.dart';
import 'splash_page.dart';

class MobileNumberPage extends StatelessWidget {
  const MobileNumberPage({super.key});

  static const routeName = 'mobile-number';

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
            const AuthRoundIcon(icon: Icons.phone_android_outlined),
            const SizedBox(height: 28),
            const Text(
              'मोबाईल क्रमांक प्रविष्ट करा',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Enter Mobile Number',
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'आम्ही तुमच्या मोबाईलवर OTP पाठवू\nWe will send OTP on your mobile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AuthColors.ink,
                fontSize: 13,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            const MobileNumberInput(),
            const SizedBox(height: 15),
            const AuthInfoNotice(
              icon: Icons.verified_user_outlined,
              marathi: 'तुमचा क्रमांक सुरक्षित आहे.',
              english: 'Your number is safe with us.',
            ),
            const SizedBox(height: 15),
            PrimaryAuthButton(
              label: 'OTP पाठवा / Send OTP',
              onPressed: () => context.goNamed(OtpVerificationPage.routeName),
            ),
            const SizedBox(height: 22),
            const _NeedHelp(),
            const SizedBox(height: 30),
            const AuthFooter(),
          ],
        ),
      ),
    );
  }
}

class _NeedHelp extends StatelessWidget {
  const _NeedHelp();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, color: AuthColors.ink, size: 18),
        SizedBox(width: 8),
        Text(
          'समस्या आहे? मदत घ्या / Need Help?',
          style: TextStyle(
            color: AuthColors.ink,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
