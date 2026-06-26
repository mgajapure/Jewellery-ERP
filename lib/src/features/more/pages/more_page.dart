import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/bilingual_text.dart';
import '../../compliance/compliance.dart';
import '../../inventory/inventory.dart';
import '../../interest/interest.dart';
import '../../purchase/purchase.dart';
import '../../reports/reports.dart';
import '../../sales/sales.dart';
import '../../savings/savings.dart';
import '../../settings/settings.dart';
import '../../staff/staff.dart';
import '../../vault/vault.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  static const routeName = 'more';

  static const _modules = [
    _ModuleData(
      titleMr: 'स्टॉक',
      titleEn: 'Inventory',
      titleHi: 'स्टॉक',
      descMr: 'स्टॉक, अपडेट, बेस आणि इन्वेंटरी मैनेज करा',
      descEn: 'Track stock, updates and manage your inventory',
      descHi: 'स्टॉक, अपडेट, बेस और इन्वेंटरी को मैनेज करें',
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFFFF9500),
      iconBg: Color(0xFFFFF4E6),
      route: InventoryListPage.routeName,
    ),
    _ModuleData(
      titleMr: 'तिजोरी',
      titleEn: 'Vault',
      titleHi: 'तिजोरी',
      descMr: 'महामूल्य संपत्ती आणि कीमती वस्तू सुरक्षित ठेवा',
      descEn: 'Secure your valuable assets and precious items',
      descHi: 'महामूल्य संपत्तियां और कीमती चीजें सुरक्षित रखें',
      icon: Icons.account_balance_outlined,
      iconColor: Color(0xFF2563EB),
      iconBg: Color(0xFFEBF2FF),
      route: VaultSearchPage.routeName,
    ),
    _ModuleData(
      titleMr: 'व्याज',
      titleEn: 'Interest',
      titleHi: 'ब्याज',
      descMr: 'कर्ज, व्याज आणि परतफेड ट्रॅक करा',
      descEn: 'Track loans, interest and repayments',
      descHi: 'लोन, ब्याज और रिपेमेंट ट्रैक करें',
      icon: Icons.calculate_outlined,
      iconColor: Color(0xFF07934A),
      iconBg: Color(0xFFE6F7EF),
      route: InterestCalculatorPage.routeName,
    ),
    _ModuleData(
      titleMr: 'अनुपालन',
      titleEn: 'Compliance',
      titleHi: 'अनुपालन',
      descMr: 'कायदेशीर अनुपालन आणि ऑडिटसाठी तयार राहा',
      descEn: 'Stay ready for legal compliance and audits',
      descHi: 'कानूनी अनुपालन और ऑडिट के लिए तैयार रहें',
      icon: Icons.verified_user_outlined,
      iconColor: Color(0xFFE7A726),
      iconBg: Color(0xFFFFF8E1),
      route: ComplianceDashboardPage.routeName,
    ),
    _ModuleData(
      titleMr: 'खरेदी',
      titleEn: 'Purchase',
      titleHi: 'खरीद',
      descMr: 'खरेदी, इन्व्हेंटरी आणि विक्रेता मैनेज करा',
      descEn: 'Manage purchases, inventory and vendors',
      descHi: 'खरीद, इन्वेंटरी और विक्रेता को मैनेज करें',
      icon: Icons.shopping_bag_outlined,
      iconColor: Color(0xFF7C3AED),
      iconBg: Color(0xFFF3E8FF),
      route: PurchaseDashboardPage.routeName,
    ),
    _ModuleData(
      titleMr: 'विक्री',
      titleEn: 'Sales',
      titleHi: 'बिक्री',
      descMr: 'इन्व्हॉइस तयार करा, विक्री ट्रॅक करा आणि पेमेंट मैनेज करा',
      descEn: 'Create invoices, track sales and manage payments',
      descHi: 'इन्वाइस बनाएं, बिक्री ट्रैक करें और भुगतान मैनेज करें',
      icon: Icons.point_of_sale_outlined,
      iconColor: Color(0xFF1D4ED8),
      iconBg: Color(0xFFEFF6FF),
      route: SalesDashboardPage.routeName,
    ),
    _ModuleData(
      titleMr: 'बचत योजना',
      titleEn: 'Savings',
      titleHi: 'बचत योजना',
      descMr: 'ग्राहकांच्या बचत योजना व्यवस्थापित करा',
      descEn: 'Manage customer savings schemes',
      descHi: 'ग्राहकों की बचत योजनाएं प्रबंधित करें',
      icon: Icons.savings_outlined,
      iconColor: Color(0xFF0EA5E9),
      iconBg: Color(0xFFE0F2FE),
      route: SavingsDashboardPage.routeName,
    ),
    _ModuleData(
      titleMr: 'अहवाल',
      titleEn: 'Reports',
      titleHi: 'रिपोर्ट',
      descMr: 'व्यवसायाचे विश्लेषण आणि अहवाल पहा',
      descEn: 'View business analytics and reports',
      descHi: 'व्यवसाय विश्लेषण और रिपोर्ट देखें',
      icon: Icons.bar_chart_outlined,
      iconColor: Color(0xFF2563EB),
      iconBg: Color(0xFFEFF6FF),
      route: ReportsDashboardPage.routeName,
    ),
    _ModuleData(
      titleMr: 'कर्मचारी',
      titleEn: 'Staff',
      titleHi: 'कर्मचारी',
      descMr: 'कर्मचारी आणि त्यांचे कार्य व्यवस्थापित करा',
      descEn: 'Manage staff and their responsibilities',
      descHi: 'कर्मचारियों और उनके कार्यों को प्रबंधित करें',
      icon: Icons.badge_outlined,
      iconColor: Color(0xFFF59E0B),
      iconBg: Color(0xFFFEF3C7),
      route: StaffDashboardPage.routeName,
    ),
    _ModuleData(
      titleMr: 'सेटिंग्ज',
      titleEn: 'Settings',
      titleHi: 'सेटिंग्स',
      descMr: 'अ‍ॅप सेटिंग्ज आणि प्राधान्ये कस्टमाइझ करा',
      descEn: 'Customize app settings and preferences',
      descHi: 'ऐप सेटिंग्स और प्राथमिकताएं कस्टमाइज़ करें',
      icon: Icons.settings_outlined,
      iconColor: Color(0xFF5E6880),
      iconBg: Color(0xFFF1F2F6),
      route: SettingsDashboardPage.routeName,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Column(
          children: [
            const _MoreHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const BilingualText(
                      en: 'Modules',
                      mr: 'मॉड्युल्स',
                      hi: 'मॉड्यूल्स',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF071A49),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const BilingualText(
                      en: 'All sections in one place — streamline your business',
                      mr: 'सर्व विभाग एका जागी पहा, व्यवसाय सोपा करा',
                      hi: 'सर्व विभाग एका जागी पहा, अपले व्यवसाय का आसान बनाएं',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5E6880),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _modules.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.80,
                      ),
                      itemBuilder: (context, i) => _ModuleCard(
                        module: _modules[i],
                        onTap: () => context.goNamed(_modules[i].route),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _HelpCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.goNamed('dashboard');
              break;
            case 1:
              context.goNamed('girvi-list');
              break;
            case 2:
              context.goNamed('customer-list');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _MoreHeader extends StatelessWidget {
  const _MoreHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 8, 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF071A49), size: 22),
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          const Expanded(
            child: BilingualText(
              en: 'All Modules',
              mr: 'सर्व मॉड्यूल्स',
              hi: 'सर्व मॉड्यूल्स',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF071A49),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF071A49), size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF071A49), size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ── Module card ───────────────────────────────────────────────────────────────

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.module, required this.onTap});

  final _ModuleData module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E8EF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: module.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(module.icon, color: module.iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            BilingualText(
              en: module.titleEn,
              mr: module.titleMr,
              hi: module.titleHi,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF071A49),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: BilingualText(
                en: module.descEn,
                mr: module.descMr,
                hi: module.descHi,
                compact: true,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5E6880),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: module.iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Help card ─────────────────────────────────────────────────────────────────

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E8EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9500).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headset_mic_outlined,
              color: Color(0xFFFF9500),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BilingualText(
                  en: 'Need Help?',
                  mr: 'सहायता चाहिए?',
                  hi: 'सहायता चाहिए?',
                  compact: true,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF071A49),
                  ),
                ),
                SizedBox(height: 3),
                BilingualText(
                  en: 'Our support team is always ready to help you.',
                  mr: 'आमची सहायता टीम आपल्या मदतीसाठी सदैव तयार आहे.',
                  hi: 'हमारी सहायता टीम आपकी मदद के लिए हमेशा तैयार है।',
                  compact: true,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5E6880),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BilingualText(
                  en: 'Contact',
                  mr: 'संपर्क',
                  hi: 'संपर्क',
                  compact: true,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
                Icon(Icons.chevron_right, color: Color(0xFF2563EB), size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _ModuleData {
  const _ModuleData({
    required this.titleMr,
    required this.titleEn,
    required this.titleHi,
    required this.descMr,
    required this.descEn,
    required this.descHi,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.route,
  });

  final String titleMr;
  final String titleEn;
  final String titleHi;
  final String descMr;
  final String descEn;
  final String descHi;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String route;
}
