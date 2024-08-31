import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';
import 'package:olympia/utils/app_color.dart';

class MyLabelField extends StatelessWidget {
  const MyLabelField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.accent,
          ),
          const SizedBox(width: 10),
          Text(
            label.toCapitalized(),
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: AppColor.bar,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColor.accent,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
