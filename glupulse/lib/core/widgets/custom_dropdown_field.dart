import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<T> items;
  final Function(T?) onChanged;
  final Widget Function(T) itemBuilder;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
            value: value, isExpanded: true, hint: Text(hintText, style: const TextStyle(color: AppTheme.inputLabelColor)), items: items.map((T item) => DropdownMenuItem<T>(value: item, child: itemBuilder(item))).toList(), onChanged: onChanged),
      ),
    );
  }
}
