import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthDividerGem extends StatelessWidget {
  const AuthDividerGem({required this.width, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const Row(
        children: [
          Expanded(child: Divider(color: AuthColors.mutedGold, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              Icons.diamond_outlined,
              color: AuthColors.gold,
              size: 16,
            ),
          ),
          Expanded(child: Divider(color: AuthColors.mutedGold, thickness: 1)),
        ],
      ),
    );
  }
}
