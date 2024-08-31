import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class TrainindDayHeading extends StatelessWidget {
  const TrainindDayHeading({
    super.key,
    required this.onTap,
    required this.txt,
  });

  final String txt;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Training Day: ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              txt,
              style: const TextStyle(
                color: AppColor.accent,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
