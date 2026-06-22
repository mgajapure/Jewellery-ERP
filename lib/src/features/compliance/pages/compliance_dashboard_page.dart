import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/compliance_colors.dart';

/// SCR-078 Compliance Dashboard
///
/// Central compliance monitoring screen showing RBI and Maharashtra
/// compliance health, violations, and pending actions.
class ComplianceDashboardPage extends StatelessWidget {
  const ComplianceDashboardPage({super.key});

  static const routeName = 'compliance-dashboard';

  final List<Map<String, dynamic>> _metrics = const [
    {'labelMr': 'सक्रिय गिरवी', 'labelEn': 'Active Girvi', 'value': '124', 'color': 0xFF061C49},
    {'labelMr': 'LTV उल्लंघने', 'labelEn': 'LTV Violations', 'value': '2', 'color': 0xFFE21B2D},
    {'labelMr': 'प्रलंबित KFS', 'labelEn': 'Pending KFS', 'value': '5', 'color': 0xFFF59E0B},
    {'labelMr': 'विमा कालबाह्य', 'labelEn': 'Insurance Expiry', 'value': '1', 'color': 0xFFE21B2D},
    {'labelMr': 'लिलाव सूचना', 'labelEn': 'Auction Notices', 'value': '3', 'color': 0xFFF59E0B},
    {'labelMr': 'सोने परत देय', 'labelEn': 'Gold Return Due', 'value': '7', 'color': 0xFF07934A},
  ];

  final List<Map<String, dynamic>> _alerts = const [
    {
      'title': 'LTV violation detected',
      'subtitle': 'GRV-2026-000055 exceeds 85% LTV limit',
      'severity': 'high',
      'time': '2h ago',
    },
    {
      'title': 'Insurance expiring soon',
      'subtitle': 'Vault-B policy expires on 30 Jun 2026',
      'severity': 'medium',
      'time': '1d ago',
    },
    {
      'title': 'KFS pending acknowledgement',
      'subtitle': '3 customers have not acknowledged KFS',
      'severity': 'medium',
      'time': '2d ago',
    },
    {
      'title': 'Gold return window closing',
      'subtitle': 'GRV-2026-000021 return due in 2 days',
      'severity': 'low',
      'time': '3d ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComplianceColors.screenBg,
      appBar: AppBar(
        backgroundColor: ComplianceColors.navy,
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
              'अनुपालन डॅशबोर्ड',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Compliance Dashboard',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HealthScoreCard(score: 94),
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
                children: _metrics
                    .map((m) => _MetricCard(metric: m))
                    .toList(),
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
              ..._alerts.map((a) => _AlertCard(alert: a)),
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
        ),
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
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
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

  final Map<String, dynamic> metric;

  @override
  Widget build(BuildContext context) {
    final color = Color(metric['color'] as int);
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
              metric['value'] as String,
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
                metric['labelMr'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ComplianceColors.ink,
                ),
              ),
              Text(
                metric['labelEn'] as String,
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

  final Map<String, dynamic> alert;

  Color get _severityColor {
    switch (alert['severity'] as String) {
      case 'high':
        return ComplianceColors.red;
      case 'medium':
        return ComplianceColors.orange;
      default:
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
                  alert['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ComplianceColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ComplianceColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            alert['time'] as String,
            style: const TextStyle(
              fontSize: 11,
              color: ComplianceColors.muted,
            ),
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
            const Icon(
              Icons.chevron_right,
              color: ComplianceColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
