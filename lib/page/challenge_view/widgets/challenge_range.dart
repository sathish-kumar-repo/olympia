import 'package:flutter/material.dart';

import '../../../model/my_challenge.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_fn.dart';

class ChallengeRange extends StatelessWidget {
  const ChallengeRange({
    super.key,
    required this.challenge,
  });

  final MyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Start at:  ',
              style: TextStyle(color: AppColor.accent, fontSize: 20),
            ),
            Text(
              getDate(challenge.challengeStartDate),
              style: const TextStyle(fontSize: 17),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'End at:  ',
              style: TextStyle(color: AppColor.accent, fontSize: 20),
            ),
            Text(
              getDate(challenge.challengeEndDate),
              style: const TextStyle(fontSize: 17),
            )
          ],
        ),
      ],
    );
  }
}
