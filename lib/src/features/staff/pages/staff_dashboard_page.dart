import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../../staff/theme/staff_colors.dart';

class StaffDashboardPage extends StatelessWidget {
  const StaffDashboardPage({super.key});

  static const routeName = 'staff-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'कर्मचारी आणि RBAC',
              titleEn: 'Staff & RBAC',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Staff & RBAC module coming soon',
                  style: TextStyle(
                    color: StaffColors.muted,
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
