import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../../settings/theme/settings_colors.dart';

class SettingsDashboardPage extends StatelessWidget {
  const SettingsDashboardPage({super.key});

  static const routeName = 'settings-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'सेटिंग्ज',
              titleEn: 'Settings',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Settings module coming soon',
                  style: TextStyle(
                    color: SettingsColors.muted,
                    fontSize: 16,
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
