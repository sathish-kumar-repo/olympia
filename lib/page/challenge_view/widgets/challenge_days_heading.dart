import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class ChallengeDaysHeading extends StatelessWidget {
  const ChallengeDaysHeading({
    super.key,
    required int getChallengeDays,
  }) : _getChallengeDays = getChallengeDays;

  final int _getChallengeDays;

  @override
  Widget build(BuildContext context) {
    String day = _getChallengeDays == 1 ? 'Day' : "Days";
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$_getChallengeDays $day\n',
        style: const TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),
        children: const [
          TextSpan(
            text: 'Challenge',
            style: TextStyle(
              color: AppColor.accent,
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}
