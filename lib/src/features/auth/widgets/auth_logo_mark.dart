import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthLogoMark extends StatelessWidget {
  const AuthLogoMark({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AuthColors.gold, width: 3),
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF08316E), Color(0xFF031B46)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.72,
            height: size * 0.56,
            decoration: BoxDecoration(
              border: Border.all(color: AuthColors.gold, width: 8),
              borderRadius: BorderRadius.circular(size * 0.12),
            ),
          ),
          Icon(Icons.diamond, color: AuthColors.gold, size: size * 0.44),
        ],
      ),
    );
  }
}
