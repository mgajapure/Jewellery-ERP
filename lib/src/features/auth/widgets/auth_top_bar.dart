import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';
import 'language_toggle.dart';

class AuthTopBar extends StatelessWidget {
  const AuthTopBar({required this.onBackPressed, super.key});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: const Icon(Icons.arrow_back, color: AuthColors.ink),
          tooltip: 'Back',
        ),
        const Spacer(),
        const LanguageToggle(),
      ],
    );
  }
}
