import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewellery_erp/src/features/girvi/girvi.dart';

import '../../../core/navigation/app_navigation.dart';
import '../theme/girvi_colors.dart';

/// SCR-018 Girvi Detail View
/// Displays a single girvi/loan with a tabbed layout for Details, Items,
/// Payments and KFS documents, plus quick Call / Take Payment / Renew actions.
class GirviDetailsPage extends StatelessWidget {
  const GirviDetailsPage({super.key});

  static const routeName = 'girvi-details';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: GirviColors.screenBg,
        body: SafeArea(
          child: Column(
            children: const [
              _GirviDetailsHeader(),
              _GirviHeaderCard(),
              _GirviTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    _DetailsTab(),
                    _ItemsTab(),
                    _PaymentsTab(),
                    _KfsDocsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const _BottomActionBar(),
      ),
    );
  }
}

class _GirviDetailsHeader extends StatelessWidget {
  const _GirviDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () =>
                AppNavigation.popOrGoNamed(context, GirviListPage.routeName),
            icon: const Icon(Icons.arrow_back, color: GirviColors.ink),
            tooltip: 'Back',
          ),
          const Expanded(
            child: Text(
              'गिरवी तपशील / Girvi Detail',
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
            icon: const Icon(Icons.print_outlined, color: GirviColors.ink),
            tooltip: 'Print',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: GirviColors.ink),
            tooltip: 'More',
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
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GirviColors.navy,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F061C49),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CustomerAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ramesh Mahajan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '98765 43210',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 14),
                    _InlineInfoRow(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
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
                  const SizedBox(height: 12),
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const _QrCodePlaceholder(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.white24),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _HeaderStat(
                  labelMr: 'कर्ज रक्कम',
                  labelEn: 'Loan Amount',
                  value: '₹1,50,000',
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'बाकी रक्कम',
                  labelEn: 'Outstanding',
                  value: '₹12,450',
                  valueColor: GirviColors.gold,
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  labelMr: 'LTV',
                  labelEn: 'Loan to Value',
                  value: '68%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  const _CustomerAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: GirviColors.gold.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: GirviColors.gold.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: 'https://i.pravatar.cc/150?img=11',
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Icon(Icons.person, color: GirviColors.gold, size: 38),
          errorWidget: (context, url, error) =>
              const Icon(Icons.person, color: GirviColors.gold, size: 38),
        ),
      ),
    );
  }
}

/// A small, deterministic QR-style placeholder used in the header card.
class _QrCodePlaceholder extends StatelessWidget {
  const _QrCodePlaceholder();

  @override
  Widget build(BuildContext context) {
    const size = 48.0;
    const cells = 9;
    const cellSize = size / cells;

    // 9x9 binary pattern that resembles a QR code.
    const pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 1, 0, 1, 0, 1, 0, 1],
    ];

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          for (var row = 0; row < cells; row++)
            Row(
              children: [
                for (var col = 0; col < cells; col++)
                  Container(
                    width: cellSize,
                    height: cellSize,
                    color: pattern[row][col] == 1
                        ? GirviColors.navy
                        : Colors.transparent,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InlineInfoRow extends StatelessWidget {
  const _InlineInfoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _InlineInfo(
          labelMr: 'कर्ज आयडी',
          labelEn: 'Loan ID',
          value: 'GIN-2026-000123',
        ),
        SizedBox(width: 24),
        _InlineInfo(labelMr: 'दिनांक', labelEn: 'Date', value: '06 Jun 2026'),
      ],
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({
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
          '$labelMr / $labelEn',
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String labelMr;
  final String labelEn;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          labelMr,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          labelEn,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _GirviTabBar extends StatelessWidget {
  const _GirviTabBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GirviColors.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: const TabBar(
          indicator: BoxDecoration(
            color: GirviColors.navy,
            borderRadius: BorderRadius.zero,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: GirviColors.muted,
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            _TabLabel(mr: 'तपशील', en: 'Details'),
            _TabLabel(mr: 'दागिने', en: 'Items'),
            _TabLabel(mr: 'पेमेंट्स', en: 'Payments'),
            _TabLabel(mr: 'KFS दस्तऐवज', en: 'KFS Docs'),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({required this.mr, required this.en});

  final String mr;
  final String en;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mr),
          const SizedBox(height: 2),
          Text(en, style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
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
              _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'देय तारीख / Due Date',
                value: '12 Jun 2026 (6 दिवस शिल्लक / 6 days left)',
              ),
              _DetailDivider(),
              _DetailRow(
                icon: Icons.trending_down_outlined,
                label: 'व्याज प्रकार / Interest Type',
                value: 'मासिक घटतं / Monthly Reducing',
              ),
              _DetailDivider(),
              _DetailRow(
                icon: Icons.percent_outlined,
                label: 'व्याज दर / Interest Rate',
                value: '1.50% प्रति महिना / per month',
              ),
              _DetailDivider(),
              _DetailRow(
                icon: Icons.timer_outlined,
                label: 'व्याज थ्रेशहोल्ड / Interest Threshold',
                value: '25 दिवस / 25 days',
              ),
              _DetailDivider(),
              _DetailRow(
                icon: Icons.warning_amber_outlined,
                label: 'दंड / Penalty',
                value: '2% प्रति महिना / per month',
              ),
              _DetailDivider(),
              _DetailRow(
                icon: Icons.lock_outline,
                label: 'वॉल्ट / Vault',
                value: 'VLT-01 • ट्रे / Tray T-04',
              ),
              _DetailDivider(),
              _KfsRow(),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: GirviColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: GirviColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: GirviColors.line, indent: 46);
  }
}

class _KfsRow extends StatelessWidget {
  const _KfsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 20,
            color: GirviColors.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'KFS',
                  style: TextStyle(
                    color: GirviColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'KFS पहा / View KFS',
                  style: TextStyle(
                    color: GirviColors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_outlined,
            color: GirviColors.green,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
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
        ),
      ],
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
          const Icon(Icons.chevron_right, color: GirviColors.muted, size: 22),
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

class _PaymentsTab extends StatelessWidget {
  const _PaymentsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
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
        ),
      ],
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

class _KfsDocsTab extends StatelessWidget {
  const _KfsDocsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GirviColors.line),
          ),
          child: Column(
            children: const [
              Icon(
                Icons.description_outlined,
                size: 40,
                color: GirviColors.muted,
              ),
              SizedBox(height: 12),
              Text(
                'KFS दस्तऐवज',
                style: TextStyle(
                  color: GirviColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'KFS documents will appear here',
                style: TextStyle(
                  color: GirviColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: GirviColors.line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.call,
                  labelMr: 'कॉल करा',
                  labelEn: 'Call',
                  backgroundColor: Colors.white,
                  foregroundColor: GirviColors.ink,
                  onTap: () {},
                ),
              ),
              Container(width: 1, height: 36, color: GirviColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.currency_rupee,
                  labelMr: 'पेमेंट घ्या',
                  labelEn: 'Take Payment',
                  backgroundColor: GirviColors.navy,
                  foregroundColor: Colors.white,
                  onTap: () => context.goNamed(PartialPaymentPage.routeName),
                ),
              ),
              Container(width: 1, height: 36, color: GirviColors.line),
              Expanded(
                child: _ActionButton(
                  icon: Icons.autorenew,
                  labelMr: 'नूतनीकरण',
                  labelEn: 'Renew',
                  backgroundColor: GirviColors.gold,
                  foregroundColor: GirviColors.ink,
                  onTap: () => context.goNamed(RenewalPage.routeName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.labelMr,
    required this.labelEn,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String labelMr;
  final String labelEn;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foregroundColor, size: 22),
            const SizedBox(height: 6),
            Text(
              labelMr,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              labelEn,
              style: TextStyle(
                color: foregroundColor.withValues(alpha: 0.8),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
