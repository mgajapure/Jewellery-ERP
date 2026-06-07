import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/auth_colors.dart';

class OtpBoxes extends StatelessWidget {
  const OtpBoxes({super.key, this.controllers});

  final List<TextEditingController>? controllers;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 42,
          height: 52,
          child: TextField(
            controller: controllers == null ? null : controllers![index],
            autofocus: index == 0,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AuthColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: index == 0 ? AuthColors.ink : const Color(0xFFD4D6DA),
                  width: index == 0 ? 1.4 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AuthColors.ink, width: 1.4),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
