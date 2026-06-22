import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/compliance_colors.dart';
import 'compliance_dashboard_page.dart';

/// SCR-039 Form 13 Generator
///
/// Generates the annual statutory return for Maharashtra money-lending
/// compliance.
class Form13GeneratorPage extends StatefulWidget {
  const Form13GeneratorPage({super.key});

  static const routeName = 'form13-generator';

  @override
  State<Form13GeneratorPage> createState() => _Form13GeneratorPageState();
}

class _Form13GeneratorPageState extends State<Form13GeneratorPage> {
  String _financialYear = '2026-27';
  String _branch = 'Main Branch';

  final List<String> _financialYears = const [
    '2025-26',
    '2026-27',
    '2027-28',
  ];

  final List<String> _branches = const [
    'Main Branch',
    'Branch 2',
  ];

  final Map<String, dynamic> _generatedData = const {
    'totalLoans': 1240,
    'totalPrincipal': 48500000.0,
    'totalInterest': 3200000.0,
    'activeAccounts': 312,
    'closedAccounts': 928,
    'auctionAccounts': 4,
  };

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
          onPressed: () => AppNavigation.popOrGoNamed(
            context,
            ComplianceDashboardPage.routeName,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'फॉर्म १३ जनरेटर',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Form 13 Generator',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(
                      titleMr: 'अहवाल कालावधी',
                      titleEn: 'Reporting Period',
                    ),
                    const SizedBox(height: 12),
                    _DropdownField(
                      labelMr: 'आर्थिक वर्ष',
                      labelEn: 'Financial Year',
                      value: _financialYear,
                      items: _financialYears,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _financialYear = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _DropdownField(
                      labelMr: 'शाखा',
                      labelEn: 'Branch',
                      value: _branch,
                      items: _branches,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _branch = value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle(
                      titleMr: 'तयार केलेला सारांश',
                      titleEn: 'Generated Summary',
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _DataCard(
                          labelMr: 'एकूण कर्ज',
                          labelEn: 'Total Loans',
                          value: '${_generatedData['totalLoans']}',
                          color: ComplianceColors.navy,
                        ),
                        _DataCard(
                          labelMr: 'एकूण मूळ',
                          labelEn: 'Total Principal',
                          value:
                              '₹ ${(_generatedData['totalPrincipal'] as double).toStringAsFixed(0)}',
                          color: ComplianceColors.navy,
                        ),
                        _DataCard(
                          labelMr: 'एकूण व्याज',
                          labelEn: 'Total Interest',
                          value:
                              '₹ ${(_generatedData['totalInterest'] as double).toStringAsFixed(0)}',
                          color: ComplianceColors.gold,
                        ),
                        _DataCard(
                          labelMr: 'सक्रिय खाती',
                          labelEn: 'Active Accounts',
                          value: '${_generatedData['activeAccounts']}',
                          color: ComplianceColors.green,
                        ),
                        _DataCard(
                          labelMr: 'बंद खाती',
                          labelEn: 'Closed Accounts',
                          value: '${_generatedData['closedAccounts']}',
                          color: ComplianceColors.muted,
                        ),
                        _DataCard(
                          labelMr: 'लिलाव खाती',
                          labelEn: 'Auction Accounts',
                          value: '${_generatedData['auctionAccounts']}',
                          color: ComplianceColors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _InfoBox(
                      textMr:
                          'फॉर्म १३ हा वार्षिक कायदेशीर परतावा आहे. एकदा तयार झाल्यानंतर अचल राहतो.',
                      textEn:
                          'Form 13 is the annual statutory return. It becomes immutable once generated.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: generate Form 13 PDF.
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                  label: const Text(
                    'फॉर्म १३ तयार करा / Generate Form 13',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ComplianceColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleMr, required this.titleEn});

  final String titleMr;
  final String titleEn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleMr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ComplianceColors.ink,
          ),
        ),
        Text(
          titleEn,
          style: const TextStyle(
            fontSize: 12,
            color: ComplianceColors.muted,
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$labelMr / $labelEn',
            style: const TextStyle(
              fontSize: 11,
              color: ComplianceColors.muted,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.color,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelMr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ComplianceColors.ink,
                ),
              ),
              Text(
                labelEn,
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

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.textMr, required this.textEn});

  final String textMr;
  final String textEn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ComplianceColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.gold.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: ComplianceColors.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textMr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ComplianceColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  textEn,
                  style: TextStyle(
                    fontSize: 12,
                    color: ComplianceColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
