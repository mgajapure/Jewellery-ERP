import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthDarkBackground extends StatelessWidget {
  const AuthDarkBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AuthColors.deepNavy, AuthColors.navy, Color(0xFF00112D)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -30,
              right: -18,
              child: Icon(
                Icons.diamond_outlined,
                color: Colors.white.withValues(alpha: 0.04),
                size: 190,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class AuthLightScaffold extends StatelessWidget {
  const AuthLightScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: child,
        ),
      ),
    );
  }
}
