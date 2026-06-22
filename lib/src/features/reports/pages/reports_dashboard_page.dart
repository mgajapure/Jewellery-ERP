import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../../reports/theme/reports_colors.dart';

class ReportsDashboardPage extends StatelessWidget {
  const ReportsDashboardPage({super.key});

  static const routeName = 'reports-dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReportsColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'अहवाल आणि विश्लेषण',
              titleEn: 'Reports & Analytics',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Reports & Analytics module coming soon',
                  style: TextStyle(
                    color: ReportsColors.muted,
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
