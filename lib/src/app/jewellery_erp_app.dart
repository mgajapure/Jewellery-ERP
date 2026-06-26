import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/di/injection.dart';
import '../core/l10n/app_language.dart';
import '../core/l10n/app_l10n_provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import 'app_router.dart';

class JewelleryErpApp extends StatefulWidget {
  const JewelleryErpApp({super.key});

  @override
  State<JewelleryErpApp> createState() => _JewelleryErpAppState();
}

class _JewelleryErpAppState extends State<JewelleryErpApp> {
  final _langNotifier = AppLanguageNotifier();

  @override
  void dispose() {
    _langNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.interTextTheme();

    return AppLangProvider(
      notifier: _langNotifier,
      child: BlocProvider(
        create: (_) => getIt<AuthBloc>()..add(const AuthStarted()),
        child: MaterialApp.router(
          title: 'Jewellery ERP',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child ?? const SizedBox.shrink(),
            breakpoints: const [
              Breakpoint(start: 0, end: 599, name: MOBILE),
              Breakpoint(start: 600, end: 1023, name: TABLET),
              Breakpoint(start: 1024, end: 1439, name: DESKTOP),
              Breakpoint(start: 1440, end: double.infinity, name: '4K'),
            ],
          ),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.navy,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.screenBg,
            textTheme: base.copyWith(
              displayLarge: base.displayLarge?.merge(AppTextStyles.statLarge),
              headlineMedium:
                  base.headlineMedium?.merge(AppTextStyles.sectionTitle),
              titleLarge: base.titleLarge?.merge(AppTextStyles.screenTitle),
              titleMedium: base.titleMedium?.merge(AppTextStyles.bodyLarge),
              bodyLarge: base.bodyLarge?.merge(AppTextStyles.bodyMedium),
              bodyMedium: base.bodyMedium?.merge(AppTextStyles.bodySmall),
              labelLarge: base.labelLarge?.merge(AppTextStyles.labelLarge),
              labelSmall: base.labelSmall?.merge(AppTextStyles.labelSmall),
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.line),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              hintStyle:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.navy, width: 1.5),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                elevation: 0,
                textStyle: AppTextStyles.bodyLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            dividerTheme: const DividerThemeData(
              color: AppColors.line,
              thickness: 1,
              space: 1,
            ),
          ),
        ),
      ),
    );
  }
}
