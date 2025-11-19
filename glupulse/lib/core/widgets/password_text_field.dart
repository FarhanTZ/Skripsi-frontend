import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: AppTheme.inputLabelColor),
            onPressed: onToggleVisibility,
          ),
        ),
        obscureText: !isVisible,
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }
}