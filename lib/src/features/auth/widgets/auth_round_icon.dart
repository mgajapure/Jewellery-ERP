import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthRoundIcon extends StatelessWidget {
  const AuthRoundIcon({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AuthColors.navy, Color(0xFF04275C)],
        ),
      ),
      child: Icon(icon, color: AuthColors.gold, size: 42),
    );
  }
}
