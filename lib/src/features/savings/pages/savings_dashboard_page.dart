import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../savings/theme/savings_colors.dart';

class SavingsDashboardPage extends StatelessWidget {
  const SavingsDashboardPage({super.key});

  static const routeName = 'savings-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SavingsColors.screenBg,
      appBar: AppBar(
        backgroundColor: SavingsColors.navy,
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
              'बचत योजना',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Savings Scheme',
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
          'Savings Scheme module coming soon',
          style: TextStyle(
            color: SavingsColors.muted,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
