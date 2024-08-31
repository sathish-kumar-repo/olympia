import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class MyShadowContainer extends StatelessWidget {
  const MyShadowContainer({
    super.key,
    required this.child,
    required this.borderRadius,
  });
  final Widget child;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColor.accent.withOpacity(0.9),
            spreadRadius: 4,
            blurRadius: 10,
          ),
          BoxShadow(
            color: AppColor.accent.withOpacity(0.9),
            spreadRadius: -4,
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}
