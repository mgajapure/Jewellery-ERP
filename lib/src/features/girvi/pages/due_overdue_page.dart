import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/girvi_colors.dart';

/// SCR-073 Due & Overdue Management
///
/// Collection management screen showing Girvi contracts that are due today,
/// due this week, or overdue. Supports follow-up actions and reminders.
class DueOverduePage extends StatefulWidget {
  const DueOverduePage({super.key});

  static const routeName = 'due-overdue';

  @override
  State<DueOverduePage> createState() => _DueOverduePageState();
}

class _DueOverduePageState extends State<DueOverduePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _dueToday = const [
    {
      'girviId': 'GRV-2026-000101',
      'customer': 'Ajay Shinde',
      'mobile': '9876543210',
      'amount': 45000.0,
      'dueDate': 'Today',
    },
    {
      'girviId': 'GRV-2026-000098',
      'customer': 'Vijay More',
      'mobile': '9123456780',
      'amount': 72000.0,
      'dueDate': 'Today',
    },
  ];

  final List<Map<String, dynamic>> _dueThisWeek = const [
    {
      'girviId': 'GRV-2026-000095',
      'customer': 'Sanjay Kadam',
      'mobile': '9988776655',
      'amount': 30000.0,
      'dueDate': 'Tomorrow',
    },
    {
      'girviId': 'GRV-2026-000092',
      'customer': 'Nitin Deshmukh',
      'mobile': '9765432109',
      'amount': 55000.0,
      'dueDate': 'In 3 days',
    },
  ];

  final List<Map<String, dynamic>> _overdue = const [
    {
      'girviId': 'GRV-2026-000085',
      'customer': 'Pravin Jadhav',
      'mobile': '9876567890',
      'amount': 85000.0,
      'dueDate': '5 days overdue',
      'days': 5,
    },
    {
      'girviId': 'GRV-2026-000077',
      'customer': 'Rahul Pawar',
      'mobile': '9234567890',
      'amount': 120000.0,
      'dueDate': '12 days overdue',
      'days': 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      appBar: AppBar(
        backgroundColor: GirviColors.navy,
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
              'देय व मुदतीपूर्व व्यवस्थापन',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Due & Overdue',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: GirviColors.gold,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'Overdue'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _DueList(
              items: _dueToday,
              statusColor: GirviColors.gold,
            ),
            _DueList(
              items: _dueThisWeek,
              statusColor: GirviColors.orange,
            ),
            _DueList(
              items: _overdue,
              statusColor: GirviColors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _DueList extends StatelessWidget {
  const _DueList({
    required this.items,
    required this.statusColor,
  });

  final List<Map<String, dynamic>> items;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyState();
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: items
          .map((item) => _DueCard(item: item, statusColor: statusColor))
          .toList(),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({
    required this.item,
    required this.statusColor,
  });

  final Map<String, dynamic> item;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GirviColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['girviId'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: GirviColors.navy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['dueDate'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.person_outline, text: item['customer'] as String),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.phone_outlined, text: item['mobile'] as String),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.currency_rupee,
            text: '₹ ${(item['amount'] as double).toStringAsFixed(2)}',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _ActionChip(
                icon: Icons.phone,
                label: 'Call',
                onTap: () {
                  // TODO: initiate phone call.
                },
              ),
              const SizedBox(width: 8),
              _ActionChip(
                icon: Icons.message_outlined,
                label: 'WhatsApp',
                onTap: () {
                  // TODO: open WhatsApp.
                },
              ),
              const SizedBox(width: 8),
              _ActionChip(
                icon: Icons.note_alt_outlined,
                label: 'Follow-up',
                onTap: () {
                  // TODO: record follow-up.
                },
              ),
              const SizedBox(width: 8),
              _ActionChip(
                icon: Icons.alarm_outlined,
                label: 'Reminder',
                onTap: () {
                  // TODO: create reminder.
                },
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
        Icon(icon, size: 16, color: GirviColors.muted),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: GirviColors.ink,
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: GirviColors.screenBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: GirviColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: GirviColors.navy),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: GirviColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: GirviColors.muted.withAlpha(120),
          ),
          const SizedBox(height: 12),
          const Text(
            'कोणतेही नोंद नाही',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: GirviColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No records in this category',
            style: TextStyle(
              fontSize: 13,
              color: GirviColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
