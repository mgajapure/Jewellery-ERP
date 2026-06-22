import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/girvi_colors.dart';

class GirviDetailsPage extends StatelessWidget {
  const GirviDetailsPage({super.key});

  static const routeName = 'girvi-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GirviColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            const _GirviDetailsHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: const [
                  _GirviHeaderCard(),
                  SizedBox(height: 18),
                  _SummaryGrid(),
                  SizedBox(height: 18),
                  _ActionButtons(),
                  SizedBox(height: 18),
                  _SectionHeader(title: 'गिरवी वस्तू / Pledged Items'),
                  SizedBox(height: 12),
                  _ItemsList(),
                  SizedBox(height: 18),
                  _SectionHeader(title: 'व्याज तपशील / Interest Details'),
                  SizedBox(height: 12),
                  _InterestCard(),
                  SizedBox(height: 18),
                  _SectionHeader(title: 'वॉल्ट तपशील / Vault Details'),
                  SizedBox(height: 12),
                  _VaultCard(),
                  SizedBox(height: 18),
                  _SectionHeader(title: 'अलीकडील पेमेंट्स / Recent Payments'),
                  SizedBox(height: 12),
                  _RecentPaymentsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GirviDetailsHeader extends StatelessWidget {
  const _GirviDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: GirviColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'गिरवी तपशील / Girvi Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GirviColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: GirviColors.ink),
            tooltip: 'Share',
          ),
        ],
      ),
    );
  }
}

class _GirviHeaderCard extends StatelessWidget {
  const _GirviHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: GirviColors.navy,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F061C49),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: GirviColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'सक्रिय / Active',
                  style: TextStyle(
                    color: GirviColors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'GRV-2026-000521',
                style: TextStyle(
                  color: GirviColors.gold,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: GirviColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.person,
                  color: GirviColors.gold,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'सुरेश पाटील',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Suresh Patil',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '+91 98765 43210',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _HeaderInfo(
                  labelMr: 'कर्ज रक्कम',
                  labelEn: 'Loan Amount',
                  value: '₹75,000',
                ),
              ),
              Expanded(
                child: _HeaderInfo(
                  labelMr: 'बाकी रक्कम',
                  labelEn: 'Outstanding',
                  value: '₹82,450',
                ),
              ),
              Expanded(
                child: _HeaderInfo(
                  labelMr: 'देय तारीख',
                  labelEn: 'Due Date',
                  value: '15 Jul 2026',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          labelEn,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
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
          titleMr: 'एकूण वस्तू',
          titleEn: 'Total Items',
          value: '2',
        ),
        _SummaryCard(
          titleMr: 'एकूण वजन',
          titleEn: 'Total Weight',
          value: '18.5 g',
        ),
        _SummaryCard(
          titleMr: 'मूल्यांकन',
          titleEn: 'Valuation',
          value: '₹95,500',
        ),
        _SummaryCard(
          titleMr: 'LTV',
          titleEn: 'Loan to Value',
          value: '78.5%',
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
  });

  final String titleMr;
  final String titleEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GirviColors.line),
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
              color: GirviColors.ink,
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
              color: GirviColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: GirviColors.ink,
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
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.currency_rupee,
                labelMr: 'पेमेंट नोंद',
                labelEn: 'Record Payment',
                filled: true,
                onTap: () => context.goNamed(PartialPaymentPage.routeName),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.autorenew,
                labelMr: 'नूतनीकरण',
                labelEn: 'Renew',
                onTap: () => context.goNamed(RenewalPage.routeName),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.check_circle_outline,
                labelMr: 'मुद्दलपरत',
                labelEn: 'Redeem',
                onTap: () => context.goNamed(RedemptionPage.routeName),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.gavel_outlined,
                labelMr: 'लिलाव',
                labelEn: 'Auction',
                onTap: () => context.goNamed(AuctionWorkflowPage.routeName),
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
    this.onTap,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? GirviColors.navy : Colors.white,
        foregroundColor: filled ? GirviColors.gold : GirviColors.ink,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: filled ? GirviColors.navy : GirviColors.line,
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
              color: GirviColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemsList extends StatelessWidget {
  const _ItemsList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
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
          _ItemTile(
            name: '22K सोन्याची चेन',
            nameEn: '22K Gold Chain',
            type: 'Chain',
            weight: '12.5 g',
            purity: '22K',
          ),
          _ListDivider(),
          _ItemTile(
            name: '22K सोन्याची अंगठी',
            nameEn: '22K Gold Ring',
            type: 'Ring',
            weight: '6.0 g',
            purity: '22K',
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.name,
    required this.nameEn,
    required this.type,
    required this.weight,
    required this.purity,
  });

  final String name;
  final String nameEn;
  final String type;
  final String weight;
  final String purity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: GirviColors.navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              color: GirviColors.navy,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: GirviColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nameEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$type • $purity • $weight',
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: GirviColors.muted,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _ListDivider extends StatelessWidget {
  const _ListDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: GirviColors.line, indent: 72);
  }
}

class _InterestCard extends StatelessWidget {
  const _InterestCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailRow(
            labelMr: 'व्याज प्रकार',
            labelEn: 'Interest Type',
            value: 'साधे / Simple',
          ),
          const _DetailDivider(),
          _DetailRow(
            labelMr: 'व्याज दर',
            labelEn: 'Interest Rate',
            value: '18% / वर्ष',
          ),
          const _DetailDivider(),
          _DetailRow(
            labelMr: 'एकूण व्याज',
            labelEn: 'Total Interest',
            value: '₹7,450',
          ),
          const _DetailDivider(),
          _DetailRow(
            labelMr: 'दंड व्याज',
            labelEn: 'Penalty Interest',
            value: '₹0',
          ),
        ],
      ),
    );
  }
}

class _VaultCard extends StatelessWidget {
  const _VaultCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GirviColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: GirviColors.navy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: GirviColors.gold,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'VA-A/SF-02/TR-05/SL-18',
                  style: TextStyle(
                    color: GirviColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Vault A / Safe 02 / Tray 05 / Slot 18',
                  style: TextStyle(
                    color: GirviColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.location_on_outlined,
            color: GirviColors.muted,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.labelMr,
    required this.labelEn,
    required this.value,
  });

  final String labelMr;
  final String labelEn;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelMr,
                style: const TextStyle(
                  color: GirviColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                labelEn,
                style: const TextStyle(
                  color: GirviColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: GirviColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: GirviColors.line),
    );
  }
}

class _RecentPaymentsList extends StatelessWidget {
  const _RecentPaymentsList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
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
          _PaymentTile(
            type: 'व्याज पेमेंट / Interest Payment',
            amount: '₹3,250',
            date: '05 Jun 2026',
          ),
          _ListDivider(),
          _PaymentTile(
            type: 'आंशिक पेमेंट / Partial Payment',
            amount: '₹5,000',
            date: '05 May 2026',
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.type,
    required this.amount,
    required this.date,
  });

  final String type;
  final String amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GirviColors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.south_west,
              color: GirviColors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: GirviColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: GirviColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
