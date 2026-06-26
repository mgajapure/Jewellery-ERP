import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_header.dart';
import '../theme/staff_colors.dart';

class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  static const routeName = 'staff-dashboard';

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  String _search = '';

  final List<_StaffMember> _staff = const [
    _StaffMember(
      id: '1',
      name: 'Rajesh Patil',
      nameMr: 'राजेश पाटील',
      role: _Role.owner,
      phone: '9876543210',
      isActive: true,
      joinDate: '01 Jan 2020',
    ),
    _StaffMember(
      id: '2',
      name: 'Priya Kulkarni',
      nameMr: 'प्रिया कुलकर्णी',
      role: _Role.manager,
      phone: '9823456789',
      isActive: true,
      joinDate: '15 Mar 2021',
    ),
    _StaffMember(
      id: '3',
      name: 'Suresh Deshmukh',
      nameMr: 'सुरेश देशमुख',
      role: _Role.accountant,
      phone: '9765432109',
      isActive: true,
      joinDate: '10 Jun 2022',
    ),
    _StaffMember(
      id: '4',
      name: 'Anita More',
      nameMr: 'अनिता मोरे',
      role: _Role.staff,
      phone: '9654321098',
      isActive: true,
      joinDate: '05 Sep 2023',
    ),
    _StaffMember(
      id: '5',
      name: 'Vijay Shinde',
      nameMr: 'विजय शिंदे',
      role: _Role.staff,
      phone: '9543210987',
      isActive: false,
      joinDate: '20 Dec 2022',
    ),
  ];

  List<_StaffMember> get _filtered {
    if (_search.isEmpty) return _staff;
    final q = _search.toLowerCase();
    return _staff.where((s) =>
      s.name.toLowerCase().contains(q) ||
      s.nameMr.contains(q) ||
      s.phone.contains(q) ||
      s.role.label.toLowerCase().contains(q),
    ).toList();
  }

  int get _activeCount => _staff.where((s) => s.isActive).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              titleMr: 'कर्मचारी आणि RBAC',
              titleEn: 'Staff & RBAC',
              showBackButton: true,
              backFallbackRoute: 'more',
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded,
                      color: StaffColors.navy),
                  tooltip: 'Add Staff',
                  onPressed: () => _showAddStaffSheet(context),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  _SummaryBar(
                    total: _staff.length,
                    active: _activeCount,
                    inactive: _staff.length - _activeCount,
                  ),
                  _SearchBar(
                    onChanged: (v) => setState(() => _search = v),
                  ),
                  const _RoleLegend(),
                  Expanded(
                    child: _filtered.isEmpty
                        ? const _EmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) =>
                                _StaffCard(member: _filtered[i]),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStaffSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddStaffSheet(),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.total,
    required this.active,
    required this.inactive,
  });

  final int total, active, inactive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StaffColors.line),
      ),
      child: Row(
        children: [
          _Stat(label: 'एकूण\nTotal', value: '$total', color: StaffColors.navy),
          _Divider(),
          _Stat(label: 'सक्रिय\nActive', value: '$active',
              color: AppColors.green),
          _Divider(),
          _Stat(label: 'निष्क्रिय\nInactive', value: '$inactive',
              color: AppColors.red),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(
      {required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: AppTextStyles.statLarge.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelLarge.copyWith(height: 1.3)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: StaffColors.line);
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'कर्मचारी शोधा / Search staff...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
          prefixIcon:
              const Icon(Icons.search, color: StaffColors.muted, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: StaffColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: StaffColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: StaffColors.navy, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _RoleLegend extends StatelessWidget {
  const _RoleLegend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: _Role.values
            .map((r) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _RoleBadge(role: r, small: true),
                ))
            .toList(),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({required this.member});
  final _StaffMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StaffColors.line),
      ),
      child: Row(
        children: [
          _Avatar(name: member.name, role: member.role, isActive: member.isActive),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.nameMr,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    _RoleBadge(role: member.role),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.name,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 13, color: StaffColors.muted),
                    const SizedBox(width: 4),
                    Text(member.phone,
                        style: AppTextStyles.bodySmall),
                    const Spacer(),
                    const Icon(Icons.calendar_today_outlined,
                        size: 11, color: StaffColors.muted),
                    const SizedBox(width: 4),
                    Text(member.joinDate,
                        style: AppTextStyles.labelLarge),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _StatusDot(isActive: member.isActive),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(
      {required this.name, required this.role, required this.isActive});
  final String name;
  final _Role role;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').take(2).map((w) => w[0]).join();
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: role.color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                color: role.color,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? AppColors.green : AppColors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role, this.small = false});
  final _Role role;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 8 : 10, vertical: small ? 3 : 4),
      decoration: BoxDecoration(
        color: role.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        small ? role.labelMr : '${role.labelMr} / ${role.label}',
        style: TextStyle(
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w700,
          color: role.color,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          isActive ? Icons.circle : Icons.circle_outlined,
          size: 10,
          color: isActive ? AppColors.green : AppColors.red,
        ),
        const SizedBox(height: 2),
        Text(
          isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 9,
            color: isActive ? AppColors.green : AppColors.red,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline,
              size: 48, color: StaffColors.muted),
          const SizedBox(height: 12),
          Text('कोणताही कर्मचारी सापडला नाही',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.muted)),
          const Text('No staff member found',
              style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _AddStaffSheet extends StatelessWidget {
  const _AddStaffSheet();

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
              const Text('नवीन कर्मचारी / Add Staff',
                  style: AppTextStyles.sectionTitle),
              const Spacer(),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: StaffColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SheetField(label: 'नाव / Name', hint: 'Full name'),
          const SizedBox(height: 12),
          _SheetField(
              label: 'मोबाईल / Mobile',
              hint: '10-digit number',
              keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          Text('भूमिका / Role',
              style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.navy)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _Role.values
                .where((r) => r != _Role.owner)
                .map((r) => _RoleBadge(role: r))
                .toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: StaffColors.navy,
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

class _SheetField extends StatelessWidget {
  const _SheetField(
      {required this.label,
      required this.hint,
      this.keyboardType = TextInputType.text});
  final String label, hint;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.navy)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
            filled: true,
            fillColor: StaffColors.screenBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: StaffColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: StaffColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: StaffColors.navy, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

enum _Role {
  owner,
  manager,
  accountant,
  staff;

  String get label => switch (this) {
        _Role.owner => 'Owner',
        _Role.manager => 'Manager',
        _Role.accountant => 'Accountant',
        _Role.staff => 'Staff',
      };

  String get labelMr => switch (this) {
        _Role.owner => 'मालक',
        _Role.manager => 'व्यवस्थापक',
        _Role.accountant => 'हिशेबनीस',
        _Role.staff => 'कर्मचारी',
      };

  Color get color => switch (this) {
        _Role.owner => AppColors.navy,
        _Role.manager => AppColors.gold,
        _Role.accountant => AppColors.green,
        _Role.staff => AppColors.muted,
      };
}

class _StaffMember {
  const _StaffMember({
    required this.id,
    required this.name,
    required this.nameMr,
    required this.role,
    required this.phone,
    required this.isActive,
    required this.joinDate,
  });

  final String id, name, nameMr, phone, joinDate;
  final _Role role;
  final bool isActive;
}
