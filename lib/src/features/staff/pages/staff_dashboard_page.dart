import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../staff/theme/staff_colors.dart';

class StaffDashboardPage extends StatelessWidget {
  const StaffDashboardPage({super.key});

  static const routeName = 'staff-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffColors.screenBg,
      appBar: AppBar(
        backgroundColor: StaffColors.navy,
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
              'कर्मचारी आणि RBAC',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Staff & RBAC',
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
          'Staff & RBAC module coming soon',
          style: TextStyle(
            color: StaffColors.muted,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
