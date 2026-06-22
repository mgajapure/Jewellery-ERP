import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/customer_colors.dart';
import 'customer_list_page.dart';

class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({super.key});

  static const routeName = 'customer-details';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: CustomerColors.screenBg,
        body: SafeArea(
          child: Column(
            children: [
              const _CustomerDetailsHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  children: const [
                    _CustomerProfileHeader(),
                    SizedBox(height: 18),
                    _SummaryGrid(),
                    SizedBox(height: 18),
                    _ActionButtons(),
                    SizedBox(height: 18),
                    _SectionHeader(title: 'तपशील / Details'),
                    SizedBox(height: 12),
                    _ProfileTabContent(),
                    SizedBox(height: 18),
                    _SectionHeader(title: 'अलीकडील घडामोडी / Recent Activity'),
                    SizedBox(height: 12),
                    _RecentActivityList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerDetailsHeader extends StatelessWidget {
  const _CustomerDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigation.popOrGoNamed(
              context,
              CustomerListPage.routeName,
            ),
            icon: const Icon(Icons.arrow_back, color: CustomerColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'ग्राहक तपशील / Customer Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomerColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: CustomerColors.ink),
            tooltip: 'Edit',
          ),
        ],
      ),
    );
  }
}

class _CustomerProfileHeader extends StatelessWidget {
  const _CustomerProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomerColors.navy,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F061C49),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: CustomerColors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(31),
              border: Border.all(color: CustomerColors.gold.withValues(alpha: 0.4)),
            ),
            child: const Icon(
              Icons.person,
              color: CustomerColors.gold,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'सुरेश पाटील',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Suresh Patil',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'CUST-2026-000101',
                  style: TextStyle(
                    color: CustomerColors.gold,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: CustomerColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  color: CustomerColors.gold,
                  size: 30,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'QR',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.25,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _SummaryCard(
          titleMr: 'सक्रिय गिरवी',
          titleEn: 'Active Girvi',
          value: '2',
        ),
        _SummaryCard(
          titleMr: 'बाकी रक्कम',
          titleEn: 'Outstanding',
          value: '₹1,25,000',
        ),
        _SummaryCard(
          titleMr: 'एकूण कर्ज इतिहास',
          titleEn: 'Total Loan History',
          value: '₹5,40,000',
        ),
        _SummaryCard(
          titleMr: 'जोखीम स्तर',
          titleEn: 'Risk Level',
          value: 'LOW',
          valueColor: CustomerColors.green,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.titleMr,
    required this.titleEn,
    required this.value,
    this.valueColor = CustomerColors.ink,
  });

  final String titleMr;
  final String titleEn;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CustomerColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleMr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CustomerColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titleEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CustomerColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _ActionButton(
                icon: Icons.add,
                labelMr: 'नवीन गिरवी',
                labelEn: 'New Girvi',
                filled: true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.folder_outlined,
                labelMr: 'कागदपत्रे',
                labelEn: 'Documents',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _ActionButton(
                icon: Icons.share_outlined,
                labelMr: 'QR शेअर करा',
                labelEn: 'Share QR',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.edit_outlined,
                labelMr: 'संपादन',
                labelEn: 'Edit',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    this.filled = false,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? CustomerColors.navy : Colors.white,
        foregroundColor: filled ? CustomerColors.gold : CustomerColors.ink,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: filled ? CustomerColors.navy : CustomerColors.line,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labelMr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  labelEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CustomerColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTabContent extends StatelessWidget {
  const _ProfileTabContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomerColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: const [
          _ProfileRow(
            icon: Icons.phone_outlined,
            label: 'मोबाईल / Mobile',
            value: '+91 98765 43210',
          ),
          _ProfileDivider(),
          _ProfileRow(
            icon: Icons.phone_android_outlined,
            label: 'पर्यायी मोबाईल / Alt. Mobile',
            value: '+91 91234 56789',
          ),
          _ProfileDivider(),
          _ProfileRow(
            icon: Icons.person_outline,
            label: 'लिंग / Gender',
            value: 'पुरुष / Male',
          ),
          _ProfileDivider(),
          _ProfileRow(
            icon: Icons.calendar_today_outlined,
            label: 'जन्मतारीख / DOB',
            value: '15 Aug 1985',
          ),
          _ProfileDivider(),
          _ProfileRow(
            icon: Icons.home_outlined,
            label: 'पत्ता / Address',
            value: '123, शिवाजी रोड, पुणे, महाराष्ट्र - 411001',
          ),
          _ProfileDivider(),
          _ProfileRow(
            icon: Icons.credit_card_outlined,
            label: 'PAN क्रमांक / PAN',
            value: 'ABCDE1234F',
          ),
          _ProfileDivider(),
          _ProfileRow(
            icon: Icons.badge_outlined,
            label: 'आधार / Aadhaar',
            value: 'XXXX XXXX 9012',
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: CustomerColors.muted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: CustomerColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: CustomerColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: CustomerColors.line),
    );
  }
}

class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomerColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: const [
          _ActivityTile(
            title: 'गिरवी निर्मिती / Girvi Created',
            subtitle: 'GIR-2026-004521',
            date: '12 Jun 2026',
            amount: '₹75,000',
            icon: Icons.diamond_outlined,
          ),
          _ActivityDivider(),
          _ActivityTile(
            title: 'व्याज पेमेंट / Interest Payment',
            subtitle: 'GIR-2026-004521',
            date: '05 Jun 2026',
            amount: '₹3,250',
            icon: Icons.currency_rupee,
          ),
          _ActivityDivider(),
          _ActivityTile(
            title: 'ग्राहक नोंदणी / Customer Registered',
            subtitle: 'CUST-2026-000101',
            date: '01 Jan 2026',
            amount: '',
            icon: Icons.person_add_outlined,
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: CustomerColors.navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Icon(icon, color: CustomerColors.navy, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CustomerColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (amount.isNotEmpty)
            Text(
              amount,
              style: const TextStyle(
                color: CustomerColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityDivider extends StatelessWidget {
  const _ActivityDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: CustomerColors.line, indent: 68);
  }
}


