import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/auth_session.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../presentation/bloc/auth_event.dart';
import '../presentation/bloc/otp_bloc.dart';
import '../presentation/bloc/otp_event.dart';
import '../presentation/bloc/otp_state.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_info_notice.dart';
import '../widgets/auth_round_icon.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/otp_boxes.dart';
import '../widgets/primary_auth_button.dart';
import 'mobile_number_page.dart';
import 'registration_pending_page.dart';
import '../../dashboard/dashboard_page.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key, required this.args});

  static const routeName = 'otp-verification';

  final OtpArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<OtpBloc>()..add(OtpStarted(
            requestId: args.requestId,
            mobile: args.mobile,
            maskedMobile: args.maskedMobile,
          )),
      child: const _OtpView(),
    );
  }
}

class _OtpView extends StatefulWidget {
  const _OtpView();

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  late final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _submit(BuildContext context) {
    final otp = _otp;
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया 6 अंकी OTP टाका.\nEnter the full 6-digit OTP.'),
        ),
      );
      return;
    }
    context.read<OtpBloc>().add(OtpSubmitted(otp));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          context.read<AuthBloc>().add(AuthSessionObtained(state.session));
          context.goNamed(DashboardPage.routeName);
        } else if (state is OtpRegistrationPending) {
          context.goNamed(RegistrationPendingPage.routeName);
        } else if (state is OtpEntry && state.errorMessage != null) {
          final remaining = state.attemptsLeft;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${state.errorMessage}\n'
                '${remaining > 0 ? '$remaining प्रयत्न शिल्लक / $remaining attempts left' : 'कमाल प्रयत्न / Max attempts reached'}',
              ),
              backgroundColor: const Color(0xFFB71C1C),
            ),
          );
        }
      },
      child: BlocBuilder<OtpBloc, OtpState>(
        builder: (context, state) {
          final entry = state is OtpEntry ? state : null;
          final isVerifying = entry?.isVerifying ?? false;
          final isResending = entry?.isResending ?? false;
          final isExpired = entry?.isExpired ?? false;
          final secondsLeft = entry?.secondsLeft ?? 0;
          final maskedMobile = entry?.maskedMobile ?? '—';

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: AuthLightScaffold(
              child: Column(
                children: [
                  AuthTopBar(
                    onBackPressed: () =>
                        context.goNamed(MobileNumberPage.routeName),
                  ),
                  const Spacer(flex: 10),
                  const AuthRoundIcon(icon: Icons.gpp_good),
                  const Spacer(flex: 3),
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
                  const Spacer(flex: 2),
                  Text(
                    '$maskedMobile वर पाठवलेला OTP\nOTP sent on $maskedMobile',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AuthColors.ink,
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                  const Spacer(flex: 2),
                  OtpBoxes(controllers: _controllers),
                  const Spacer(flex: 1),
                  // Timer row
                  if (!isExpired)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${secondsLeft.toString().padLeft(2, '0')}s ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AuthColors.ink,
                            ),
                          ),
                          const TextSpan(
                            text: 'शिल्लक / remaining',
                            style: TextStyle(color: AuthColors.ink),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 13),
                    )
                  else
                    const Text(
                      'OTP कालबाह्य / OTP Expired',
                      style: TextStyle(
                        color: Color(0xFFB71C1C),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const Spacer(flex: 1),
                  const AuthInfoNotice(
                    icon: Icons.verified_user_outlined,
                    marathi: 'OTP कोणाशीही शेअर करू नका.',
                    english: 'Do not share OTP with anyone.',
                  ),
                  const Spacer(flex: 2),
                  const Text(
                    'OTP आला नाही? / Didn\'t receive OTP?',
                    style: TextStyle(color: AuthColors.ink, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: (isExpired || secondsLeft == 0) && !isResending
                        ? () => context
                            .read<OtpBloc>()
                            .add(const OtpResendRequested())
                        : null,
                    child: Text(
                      isResending
                          ? 'पाठवत आहे... / Resending...'
                          : 'पुन्हा पाठवा / Resend OTP',
                      style: TextStyle(
                        color: (isExpired || secondsLeft == 0) && !isResending
                            ? AuthColors.ink
                            : AuthColors.ink.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        decoration: (isExpired || secondsLeft == 0) &&
                                !isResending
                            ? TextDecoration.underline
                            : null,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  PrimaryAuthButton(
                    label: 'पडताळणी करा / Verify OTP',
                    isLoading: isVerifying,
                    onPressed: isVerifying || isExpired
                        ? null
                        : () => _submit(context),
                  ),
                  const Spacer(flex: 2),
                  const _AttemptsLine(),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          );
        },
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
