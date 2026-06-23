import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/bloc/auth_bloc.dart';
import '../presentation/bloc/auth_state.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_divider_gem.dart';
import '../widgets/auth_logo_mark.dart';
import 'mobile_number_page.dart';
import '../../dashboard/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = 'splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _minTimeElapsed = false;
  AuthState? _pendingNavState;

  @override
  void initState() {
    super.initState();
    // Guarantee the splash is visible for at least 1.5 s.
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _minTimeElapsed = true);
      final pending = _pendingNavState;
      if (pending != null) _navigate(pending);
    });
  }

  void _navigate(AuthState state) {
    if (state is AuthAuthenticated) {
      context.goNamed(DashboardPage.routeName);
    } else if (state is AuthUnauthenticated) {
      context.goNamed(MobileNumberPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated) {
          if (_minTimeElapsed) {
            _navigate(state);
          } else {
            _pendingNavState = state;
          }
        }
      },
      child: const Scaffold(
        body: AuthDarkBackground(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(28, 12, 28, 26),
              child: Column(
                children: [
                  Spacer(flex: 3),
                  AuthLogoMark(size: 120),
                  Spacer(flex: 2),
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
                  Spacer(flex: 2),
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
                  Spacer(flex: 3),
                  AuthDividerGem(width: 210),
                  Spacer(flex: 3),
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AuthColors.mutedGold,
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                  Text(
                    'Loading... कृपया थांबा...',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Spacer(flex: 2),
                  Text(
                    'Secure • Smart • Reliable\nसुरक्षित • स्मार्ट • विश्वासार्ह',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  Spacer(flex: 3),
                  Text(
                    'Version 2.0.0',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
