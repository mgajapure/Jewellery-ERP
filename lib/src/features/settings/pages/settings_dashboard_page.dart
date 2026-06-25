import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_header.dart';
import '../theme/settings_colors.dart';

class SettingsDashboardPage extends StatefulWidget {
  const SettingsDashboardPage({super.key});

  static const routeName = 'settings-dashboard';

  @override
  State<SettingsDashboardPage> createState() => _SettingsDashboardPageState();
}

class _SettingsDashboardPageState extends State<SettingsDashboardPage> {
  bool _notifyDueReminders = true;
  bool _notifyPayments = true;
  bool _notifyExpiry = false;
  bool _biometricLock = false;
  String _language = 'mr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'सेटिंग्ज',
              titleEn: 'Settings',
              showBackButton: true,
              backFallbackRoute: 'more',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  _Section(
                    icon: Icons.store_rounded,
                    titleMr: 'दुकानाची माहिती',
                    titleEn: 'Shop Profile',
                    color: SettingsColors.navy,
                    children: [
                      _InfoTile(
                        label: 'दुकानाचे नाव / Shop Name',
                        value: 'Patil Jewellers',
                        icon: Icons.storefront_outlined,
                        onTap: () => _editField(context, 'Shop Name'),
                      ),
                      _InfoTile(
                        label: 'पत्ता / Address',
                        value: 'Main Road, Pune - 411001',
                        icon: Icons.location_on_outlined,
                        onTap: () => _editField(context, 'Address'),
                      ),
                      _InfoTile(
                        label: 'GST नंबर / GST Number',
                        value: '27AABCP1234A1Z5',
                        icon: Icons.receipt_long_outlined,
                        onTap: () => _editField(context, 'GST Number'),
                      ),
                      _InfoTile(
                        label: 'PAN नंबर / PAN Number',
                        value: 'AABCP1234A',
                        icon: Icons.badge_outlined,
                        onTap: () => _editField(context, 'PAN Number'),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.monetization_on_rounded,
                    titleMr: 'आजचे भाव',
                    titleEn: 'Today\'s Rates',
                    color: AppColors.gold,
                    children: [
                      _RateTile(
                        labelMr: 'सोने (24K)',
                        labelEn: 'Gold (24K)',
                        value: '₹7,250',
                        unit: 'प्रति ग्राम / per gram',
                        color: AppColors.gold,
                        onTap: () => _editRate(context, 'Gold (24K) Rate'),
                      ),
                      _RateTile(
                        labelMr: 'सोने (22K)',
                        labelEn: 'Gold (22K)',
                        value: '₹6,645',
                        unit: 'प्रति ग्राम / per gram',
                        color: AppColors.gold,
                        onTap: () => _editRate(context, 'Gold (22K) Rate'),
                      ),
                      _RateTile(
                        labelMr: 'चांदी',
                        labelEn: 'Silver',
                        value: '₹85',
                        unit: 'प्रति ग्राम / per gram',
                        color: AppColors.muted,
                        onTap: () => _editRate(context, 'Silver Rate'),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.percent_rounded,
                    titleMr: 'व्याजदर',
                    titleEn: 'Interest Rates',
                    color: AppColors.green,
                    children: [
                      _RateTile(
                        labelMr: 'गिर्‍वी व्याज (मासिक)',
                        labelEn: 'Girvi Interest (monthly)',
                        value: '1.5%',
                        unit: 'प्रति महिना / per month',
                        color: AppColors.green,
                        onTap: () => _editRate(context, 'Girvi Interest Rate'),
                      ),
                      _RateTile(
                        labelMr: 'दंड व्याज',
                        labelEn: 'Penal Interest',
                        value: '2.0%',
                        unit: 'प्रति महिना / per month',
                        color: AppColors.red,
                        onTap: () => _editRate(context, 'Penal Interest Rate'),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.language_rounded,
                    titleMr: 'भाषा',
                    titleEn: 'Language',
                    color: const Color(0xFF5B67CA),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Row(
                          children: [
                            _LangOption(
                              label: 'मराठी',
                              sublabel: 'Marathi',
                              selected: _language == 'mr',
                              onTap: () => setState(() => _language = 'mr'),
                            ),
                            const SizedBox(width: 10),
                            _LangOption(
                              label: 'English',
                              sublabel: 'इंग्रजी',
                              selected: _language == 'en',
                              onTap: () => setState(() => _language = 'en'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.notifications_rounded,
                    titleMr: 'सूचना',
                    titleEn: 'Notifications',
                    color: const Color(0xFF5B67CA),
                    children: [
                      _ToggleTile(
                        labelMr: 'देय तारीख स्मरणपत्र',
                        labelEn: 'Due date reminders',
                        icon: Icons.event_outlined,
                        value: _notifyDueReminders,
                        onChanged: (v) =>
                            setState(() => _notifyDueReminders = v),
                      ),
                      _ToggleTile(
                        labelMr: 'पेमेंट सूचना',
                        labelEn: 'Payment alerts',
                        icon: Icons.payments_outlined,
                        value: _notifyPayments,
                        onChanged: (v) =>
                            setState(() => _notifyPayments = v),
                      ),
                      _ToggleTile(
                        labelMr: 'कालबाह्य सूचना',
                        labelEn: 'Expiry alerts',
                        icon: Icons.warning_amber_outlined,
                        value: _notifyExpiry,
                        onChanged: (v) =>
                            setState(() => _notifyExpiry = v),
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.security_rounded,
                    titleMr: 'सुरक्षा',
                    titleEn: 'Security',
                    color: AppColors.red,
                    children: [
                      _ToggleTile(
                        labelMr: 'बायोमेट्रिक लॉक',
                        labelEn: 'Biometric lock',
                        icon: Icons.fingerprint_outlined,
                        value: _biometricLock,
                        onChanged: (v) =>
                            setState(() => _biometricLock = v),
                      ),
                      _ActionTile(
                        labelMr: 'पिन बदला',
                        labelEn: 'Change PIN',
                        icon: Icons.pin_outlined,
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _Section(
                    icon: Icons.info_outline_rounded,
                    titleMr: 'अॅपबद्दल',
                    titleEn: 'About App',
                    color: SettingsColors.muted,
                    children: [
                      _InfoTile(
                        label: 'आवृत्ती / Version',
                        value: '1.0.0 (Build 1)',
                        icon: Icons.apps_rounded,
                      ),
                      _InfoTile(
                        label: 'डेव्हलपर / Developer',
                        value: 'Jewellery ERP Team',
                        icon: Icons.code_rounded,
                      ),
                      _ActionTile(
                        labelMr: 'गोपनीयता धोरण',
                        labelEn: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined,
                        onTap: () {},
                      ),
                      _ActionTile(
                        labelMr: 'सहाय्य / Support',
                        labelEn: 'Contact Support',
                        icon: Icons.support_agent_outlined,
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _LogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editField(BuildContext context, String field) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditFieldSheet(field: field),
    );
  }

  void _editRate(BuildContext context, String rateLabel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditRateSheet(label: rateLabel),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.titleMr,
    required this.titleEn,
    required this.color,
    required this.children,
  });

  final IconData icon;
  final String titleMr, titleEn;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                '$titleMr / $titleEn',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SettingsColors.line),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    this.isLast = false,
  });

  final String label, value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: SettingsColors.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: AppTextStyles.labelLarge),
                      const SizedBox(height: 2),
                      Text(value,
                          style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy)),
                    ],
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.edit_outlined,
                      size: 16, color: SettingsColors.muted),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 46, color: SettingsColors.line),
      ],
    );
  }
}

class _RateTile extends StatelessWidget {
  const _RateTile({
    required this.labelMr,
    required this.labelEn,
    required this.value,
    required this.unit,
    required this.color,
    required this.onTap,
    this.isLast = false,
  });

  final String labelMr, labelEn, value, unit;
  final Color color;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$labelMr / $labelEn',
                          style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Text(unit,
                          style: AppTextStyles.labelLarge),
                    ],
                  ),
                ),
                Text(value,
                    style: AppTextStyles.statMedium.copyWith(color: color)),
                const SizedBox(width: 8),
                const Icon(Icons.edit_outlined,
                    size: 16, color: SettingsColors.muted),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 16, color: SettingsColors.line),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.labelMr,
    required this.labelEn,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final String labelMr, labelEn;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: SettingsColors.muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text('$labelMr\n$labelEn',
                    style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                        height: 1.4)),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeTrackColor: SettingsColors.navy,
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 46, color: SettingsColors.line),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.labelMr,
    required this.labelEn,
    required this.icon,
    required this.onTap,
    this.isLast = false,
  });

  final String labelMr, labelEn;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: SettingsColors.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('$labelMr / $labelEn',
                      style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy)),
                ),
                const Icon(Icons.chevron_right,
                    size: 18, color: SettingsColors.muted),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, indent: 46, color: SettingsColors.line),
      ],
    );
  }
}

class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  final String label, sublabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? SettingsColors.navy
                : SettingsColors.screenBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? SettingsColors.navy : SettingsColors.line,
            ),
          ),
          child: Column(
            children: [
              Text(label,
                  style: AppTextStyles.sectionTitle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : AppColors.navy)),
              Text(sublabel,
                  style: AppTextStyles.labelLarge.copyWith(
                      color: selected ? Colors.white70 : AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout_rounded,
            color: AppColors.red, size: 18),
        label: const Text('लॉग आउट / Log Out',
            style: TextStyle(
                color: AppColors.red, fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.red),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {},
      ),
    );
  }
}

class _EditFieldSheet extends StatelessWidget {
  const _EditFieldSheet({required this.field});
  final String field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Edit $field',
                  style: AppTextStyles.sectionTitle),
              const Spacer(),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: SettingsColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter $field',
              hintStyle: const TextStyle(color: SettingsColors.muted),
              filled: true,
              fillColor: SettingsColors.screenBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: SettingsColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: SettingsColors.navy, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SettingsColors.navy,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => context.pop(),
              child: const Text('जतन करा / Save',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditRateSheet extends StatelessWidget {
  const _EditRateSheet({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Update $label',
                  style: AppTextStyles.sectionTitle),
              const Spacer(),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: SettingsColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter value',
              prefixText: '₹ ',
              hintStyle: const TextStyle(color: SettingsColors.muted),
              filled: true,
              fillColor: SettingsColors.screenBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: SettingsColors.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: SettingsColors.navy, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SettingsColors.navy,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => context.pop(),
              child: const Text('भाव अपडेट करा / Update Rate',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
