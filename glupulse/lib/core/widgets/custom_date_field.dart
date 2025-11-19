import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class CustomDateField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onDateSelected;

  const CustomDateField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onDateSelected,
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
        readOnly: true,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          suffixIcon: const Icon(Icons.calendar_today, color: AppTheme.inputLabelColor),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
          if (pickedDate != null) {
            String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            onDateSelected(formattedDate);
          }
        },
      ),
    );
  }
}
