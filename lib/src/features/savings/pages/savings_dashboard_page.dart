import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../../savings/theme/savings_colors.dart';

class SavingsDashboardPage extends StatelessWidget {
  const SavingsDashboardPage({super.key});

  static const routeName = 'savings-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SavingsColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'बचत योजना',
              titleEn: 'Savings Scheme',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Savings Scheme module coming soon',
                  style: TextStyle(
                    color: SavingsColors.muted,
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
