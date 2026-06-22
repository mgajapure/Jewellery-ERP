import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../reports/theme/reports_colors.dart';

class ReportsDashboardPage extends StatelessWidget {
  const ReportsDashboardPage({super.key});

  static const routeName = 'reports-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReportsColors.screenBg,
      appBar: AppBar(
        backgroundColor: ReportsColors.navy,
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
              'अहवाल आणि विश्लेषण',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Reports & Analytics',
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
          'Reports & Analytics module coming soon',
          style: TextStyle(
            color: ReportsColors.muted,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
