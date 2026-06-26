import 'package:flutter/material.dart';

import '../../../core/widgets/app_header.dart';
import '../theme/compliance_colors.dart';
import 'compliance_dashboard_page.dart';

/// SCR-038 Forms 11 & 12
///
/// Mandatory pledged articles register (Form 11) and loan transaction
/// register (Form 12) for Maharashtra compliance.
class Forms11_12Page extends StatefulWidget {
  const Forms11_12Page({super.key});

  static const routeName = 'forms11-12';

  @override
  State<Forms11_12Page> createState() => _Forms11_12PageState();
}

class _Forms11_12PageState extends State<Forms11_12Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _form11Rows = const [
    {
      'girviId': 'GRV-2026-000042',
      'customer': 'Ramesh Patil',
      'items': 'Gold chain, 22K, 15g',
      'weight': '15.00',
      'vault': 'VA-A/SF-02/TR-05/SL-18',
    },
    {
      'girviId': 'GRV-2026-000038',
      'customer': 'Suresh Jadhav',
      'items': 'Gold ring, 20K, 8g',
      'weight': '8.00',
      'vault': 'VA-A/SF-01/TR-03/SL-07',
    },
  ];

  final List<Map<String, dynamic>> _form12Rows = const [
    {
      'girviId': 'GRV-2026-000042',
      'loan': 100000.0,
      'interest': 5917.81,
      'payments': 5000.0,
      'outstanding': 100917.81,
    },
    {
      'girviId': 'GRV-2026-000038',
      'loan': 50000.0,
      'interest': 2958.90,
      'payments': 0.0,
      'outstanding': 52958.90,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _format(double value) {
    return '₹ ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComplianceColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'फॉर्म ११ आणि १२',
              titleEn: 'Forms 11 & 12',
              showBackButton: true,
              backFallbackRoute: ComplianceDashboardPage.routeName,
              actions: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF071A49)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('PDF निर्यात लवकरच / PDF export coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.print_outlined, color: Color(0xFF071A49)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('प्रिंट लवकरच / Print coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: ComplianceColors.gold,
                labelColor: ComplianceColors.navy,
                unselectedLabelColor: ComplianceColors.muted,
                tabs: const [
                  Tab(text: 'Form 11'),
                  Tab(text: 'Form 12'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _Form11Tab(rows: _form11Rows),
                  _Form12Tab(rows: _form12Rows, format: _format),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Form11Tab extends StatelessWidget {
  const _Form11Tab({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'तारण वस्तू नोंदवही / Pledged Articles Register',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ComplianceColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        ...rows.map((row) => _Form11Card(row: row)),
      ],
    );
  }
}

class _Form11Card extends StatelessWidget {
  const _Form11Card({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row['girviId'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ComplianceColors.navy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ComplianceColors.cream,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${row['weight']} g',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ComplianceColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.person_outline, text: row['customer'] as String),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.diamond_outlined, text: row['items'] as String),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.location_on_outlined, text: row['vault'] as String),
        ],
      ),
    );
  }
}

class _Form12Tab extends StatelessWidget {
  const _Form12Tab({required this.rows, required this.format});

  final List<Map<String, dynamic>> rows;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'कर्ज व्यवहार नोंदवही / Loan Transaction Register',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ComplianceColors.ink,
          ),
        ),
        const SizedBox(height: 12),
        ...rows.map((row) => _Form12Card(row: row, format: format)),
      ],
    );
  }
}

class _Form12Card extends StatelessWidget {
  const _Form12Card({required this.row, required this.format});

  final Map<String, dynamic> row;
  final String Function(double) format;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ComplianceColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row['girviId'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ComplianceColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _AmountItem(
                  label: 'Loan',
                  value: format(row['loan'] as double),
                  color: ComplianceColors.ink,
                ),
              ),
              Expanded(
                child: _AmountItem(
                  label: 'Interest',
                  value: format(row['interest'] as double),
                  color: ComplianceColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _AmountItem(
                  label: 'Payments',
                  value: format(row['payments'] as double),
                  color: ComplianceColors.green,
                ),
              ),
              Expanded(
                child: _AmountItem(
                  label: 'Outstanding',
                  value: format(row['outstanding'] as double),
                  color: ComplianceColors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ComplianceColors.muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: ComplianceColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountItem extends StatelessWidget {
  const _AmountItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: ComplianceColors.muted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
