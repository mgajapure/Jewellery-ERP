import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthInfoNotice extends StatelessWidget {
  const AuthInfoNotice({
    required this.icon,
    required this.marathi,
    required this.english,
    super.key,
  });

  final IconData icon;
  final String marathi;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AuthColors.cream,
        border: Border.all(color: const Color(0xFFF1DFC0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AuthColors.mutedGold, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$marathi\n$english',
              style: const TextStyle(
                color: AuthColors.ink,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
