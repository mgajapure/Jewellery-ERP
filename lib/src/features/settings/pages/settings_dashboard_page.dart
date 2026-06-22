import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../settings/theme/settings_colors.dart';

class SettingsDashboardPage extends StatelessWidget {
  const SettingsDashboardPage({super.key});

  static const routeName = 'settings-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsColors.screenBg,
      appBar: AppBar(
        backgroundColor: SettingsColors.navy,
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
              'सेटिंग्ज',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Settings module coming soon',
          style: TextStyle(
            color: SettingsColors.muted,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
