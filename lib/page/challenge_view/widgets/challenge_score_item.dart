import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class ChallengScoreItem extends StatelessWidget {
  const ChallengScoreItem({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColor.accent,
            fontSize: 20,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
