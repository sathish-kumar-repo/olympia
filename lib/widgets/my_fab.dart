import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class MyFAB extends StatelessWidget {
  const MyFAB({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColor.accent,
      onPressed: onTap,
      elevation: 10,
      child: const Icon(
        Icons.done,
        color: Colors.white,
      ),
    );
  }
}
