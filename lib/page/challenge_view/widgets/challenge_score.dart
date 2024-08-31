import 'package:flutter/material.dart';
import 'package:olympia/model/my_challenge.dart';
import 'challenge_days_heading.dart';
import 'challenge_info.dart';
import 'challenge_range.dart';
import 'challenge_title.dart';

class ChallengeScore extends StatelessWidget {
  const ChallengeScore({
    super.key,
    required this.challenge,
  });

  final MyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 70, left: 15, right: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChallengeDaysHeading(getChallengeDays: _getChallengeDays),
          const SizedBox(height: 30),
          ChallengeTitle(challenge: challenge),
          ChallengeInfo(challenge: challenge),
          const SizedBox(height: 20),
          ChallengeRange(challenge: challenge)
        ],
      ),
    );
  }

  int get _getChallengeDays {
    return challenge.track.length;
  }
}
