import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/auth_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_divider_gem.dart';
import '../widgets/auth_logo_mark.dart';
import 'mobile_number_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = 'splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _launchTimer;

  @override
  void initState() {
    super.initState();
    _launchTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.goNamed(MobileNumberPage.routeName);
      }
    });
  }

  @override
  void dispose() {
    _launchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AuthDarkBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, 12, 28, 26),
            child: Column(
              children: [
                Spacer(flex: 2),
                AuthLogoMark(size: 132),
                SizedBox(height: 18),
                Text(
                  'JEWELLERY ERP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AuthColors.gold,
                    fontFamily: 'serif',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ज्वेलरी ERP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AuthColors.gold,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 26),
                Text(
                  'Girvi Management Made Simple\nगिरवी व्यवस्थापन सोपे आणि स्मार्ट',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 34),
                AuthDividerGem(width: 210),
                Spacer(),
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AuthColors.mutedGold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading... कृपया थांबा...',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 24),
                Text(
                  'Secure • Smart • Reliable\nसुरक्षित • स्मार्ट • विश्वासार्ह',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                Spacer(),
                Text(
                  'Version 2.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
