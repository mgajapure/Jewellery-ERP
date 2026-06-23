import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_header.dart';
import '../domain/entities/compliance_entities.dart';
import '../presentation/bloc/compliance_dashboard_bloc.dart';
import '../theme/compliance_colors.dart';

/// SCR-078 Compliance Dashboard
class ComplianceDashboardPage extends StatelessWidget {
  const ComplianceDashboardPage({super.key});

  static const routeName = 'compliance-dashboard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ComplianceDashboardBloc>()
        ..add(ComplianceDashboardStarted()),
      child: const _ComplianceDashboardScaffold(),
    );
  }
}

class _ComplianceDashboardScaffold extends StatelessWidget {
  const _ComplianceDashboardScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComplianceColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'अनुपालन डॅशबोर्ड',
              titleEn: 'Compliance Dashboard',
              showBackButton: true,
              backFallbackRoute: 'more',
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: ComplianceColors.navy),
                  onPressed: () => context
                      .read<ComplianceDashboardBloc>()
                      .add(ComplianceDashboardRefreshed()),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<ComplianceDashboardBloc,
                  ComplianceDashboardState>(
                builder: (context, state) {
                  if (state is ComplianceDashboardLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: ComplianceColors.navy),
                    );
                  }
                  if (state is ComplianceDashboardError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: ComplianceColors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(
                                  color: ComplianceColors.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<ComplianceDashboardBloc>()
                                .add(ComplianceDashboardRefreshed()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ComplianceColors.navy),
                            child: const Text('पुन्हा प्रयत्न / Retry',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ComplianceDashboardLoaded) {
                    return _LoadedView(stats: state.stats);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.stats});

  final ComplianceDashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HealthScoreCard(score: stats.healthScore),
          const SizedBox(height: 20),
          const Text(
            'मेट्रिक्स / Metrics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ComplianceColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: stats.metrics.map((m) => _MetricCard(metric: m)).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'अलर्ट आणि उल्लंघने / Alerts & Violations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ComplianceColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          ...stats.alerts.map((a) => _AlertCard(alert: a)),
          const SizedBox(height: 24),
          const Text(
            'फॉर्म / Forms',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ComplianceColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          _FormActionCard(
            titleMr: 'फॉर्म ६',
            titleEn: 'Form 6',
            subtitle: 'Money Lending License',
            onTap: () => context.goNamed('form6-generator'),
          ),
          const SizedBox(height: 10),
          _FormActionCard(
            titleMr: 'फॉर्म ९',
            titleEn: 'Form 9',
            subtitle: 'Daily Loan Register',
            onTap: () => context.goNamed('form9-register'),
          ),
          const SizedBox(height: 10),
          _FormActionCard(
            titleMr: 'फॉर्म ११ आणि १२',
            titleEn: 'Forms 11 & 12',
            subtitle: 'Pledged Articles & Loan Register',
            onTap: () => context.goNamed('forms11-12'),
          ),
          const SizedBox(height: 10),
          _FormActionCard(
            titleMr: 'फॉर्म १३',
            titleEn: 'Form 13',
            subtitle: 'Annual Statutory Return',
            onTap: () => context.goNamed('form13-generator'),
          ),
        ],
      ),
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  const _HealthScoreCard({required this.score});

  final int score;

  Color get _scoreColor {
    if (score >= 95) return ComplianceColors.green;
    if (score >= 80) return ComplianceColors.orange;
    return ComplianceColors.red;
  }

  String get _statusText {
    if (score >= 95) return 'उत्कृष्ट / Excellent';
    if (score >= 80) return 'सुधारणा आवश्यक / Needs Improvement';
    return 'गंभीर / Critical';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ComplianceColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'अनुपालन आरोग्य स्कोर / Compliance Health Score',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _scoreColor.withAlpha(30),
                  shape: BoxShape.circle,
                  border: Border.all(color: _scoreColor, width: 3),
                ),
                child: Center(
                  child: Text(
                    '$score%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _scoreColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'शेवटची स्कॅन: १ तासापूर्वी / Last scan: 1 hour ago',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final ComplianceMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = Color(metric.colorHex);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              metric.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.labelMr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ComplianceColors.ink,
                ),
              ),
              Text(
                metric.labelEn,
                style: const TextStyle(
                  fontSize: 11,
                  color: ComplianceColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final ComplianceAlert alert;

  Color get _severityColor {
    switch (alert.severity) {
      case ComplianceSeverity.high:
        return ComplianceColors.red;
      case ComplianceSeverity.medium:
        return ComplianceColors.orange;
      case ComplianceSeverity.low:
        return ComplianceColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: _severityColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ComplianceColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ComplianceColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            alert.time,
            style: const TextStyle(fontSize: 11, color: ComplianceColors.muted),
          ),
        ],
      ),
    );
  }
}

class _FormActionCard extends StatelessWidget {
  const _FormActionCard({
    required this.titleMr,
    required this.titleEn,
    required this.subtitle,
    required this.onTap,
  });

  final String titleMr;
  final String titleEn;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ComplianceColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ComplianceColors.navy.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: ComplianceColors.navy,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$titleMr / $titleEn',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ComplianceColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ComplianceColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: ComplianceColors.muted),
          ],
        ),
      ),
    );
  }
}
