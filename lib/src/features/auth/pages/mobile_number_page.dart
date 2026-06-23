import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/auth_session.dart';
import '../presentation/bloc/mobile_bloc.dart';
import '../presentation/bloc/mobile_event.dart';
import '../presentation/bloc/mobile_state.dart';
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
    return BlocProvider(
      create: (_) => getIt<MobileBloc>(),
      child: const _MobileView(),
    );
  }
}

class _MobileView extends StatefulWidget {
  const _MobileView();

  @override
  State<_MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<_MobileView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final mobile = _controller.text.trim();
    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया 10 अंकी मोबाईल क्रमांक टाका.\nEnter a valid 10-digit mobile number.'),
        ),
      );
      return;
    }
    context.read<MobileBloc>().add(MobileSubmit(mobile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MobileBloc, MobileState>(
      listener: (context, state) {
        if (state is MobileOtpSent) {
          context.goNamed(
            OtpVerificationPage.routeName,
            extra: OtpArgs(
              requestId: state.requestId,
              mobile: state.mobile,
              maskedMobile: state.maskedMobile,
            ),
          );
        } else if (state is MobileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFB71C1C),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthLightScaffold(
          child: BlocBuilder<MobileBloc, MobileState>(
            builder: (context, state) {
              final isLoading = state is MobileSubmitting;
              return Column(
                children: [
                  AuthTopBar(
                    onBackPressed: () =>
                        context.goNamed(SplashPage.routeName),
                  ),
                  const Spacer(flex: 10),
                  const AuthRoundIcon(icon: Icons.phone_android_outlined),
                  const Spacer(flex: 3),
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
                  const Spacer(flex: 2),
                  const Text(
                    'आम्ही तुमच्या मोबाईलवर OTP पाठवू\nWe will send OTP on your mobile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AuthColors.ink,
                      fontSize: 13,
                      height: 1.55,
                    ),
                  ),
                  const Spacer(flex: 2),
                  MobileNumberInput(controller: _controller),
                  const Spacer(flex: 2),
                  const AuthInfoNotice(
                    icon: Icons.verified_user_outlined,
                    marathi: 'तुमचा क्रमांक सुरक्षित आहे.',
                    english: 'Your number is safe with us.',
                  ),
                  const Spacer(flex: 2),
                  PrimaryAuthButton(
                    label: 'OTP पाठवा / Send OTP',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(context),
                  ),
                  const Spacer(flex: 2),
                  const _NeedHelp(),
                  const Spacer(flex: 2),
                  const AuthFooter(),
                ],
              );
            },
          ),
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
