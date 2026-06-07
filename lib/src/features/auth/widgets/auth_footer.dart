import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AuthColors.softLine)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FooterItem(
            icon: Icons.verified_user_outlined,
            title: 'सुरक्षित',
            subtitle: 'Secure',
          ),
          _FooterItem(
            icon: Icons.gpp_good_outlined,
            title: 'विश्वासार्ह',
            subtitle: 'Reliable',
          ),
          _FooterItem(
            icon: Icons.speed_outlined,
            title: 'वेगवान',
            subtitle: 'Fast',
          ),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  const _FooterItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AuthColors.ink, size: 24),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: AuthColors.ink, fontSize: 11),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: AuthColors.ink, fontSize: 11),
        ),
      ],
    );
  }
}
