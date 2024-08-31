import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class MyIconBtn extends StatelessWidget {
  const MyIconBtn({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: AppColor.accent,
        size: 25,
      ),
      onPressed: onTap,
    );
  }
}
