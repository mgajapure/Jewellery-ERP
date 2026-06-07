import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/auth_colors.dart';

class MobileNumberInput extends StatelessWidget {
  const MobileNumberInput({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD5D5D5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Text(
            '+91',
            style: TextStyle(
              color: AuthColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: AuthColors.ink),
          const VerticalDivider(width: 24, color: Color(0xFFD5D5D5)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                color: AuthColors.ink,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: 'मोबाईल क्रमांक / Mobile Number',
                hintStyle: TextStyle(color: Color(0xFF7D7D7D), fontSize: 15),
                contentPadding: EdgeInsets.only(bottom: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
