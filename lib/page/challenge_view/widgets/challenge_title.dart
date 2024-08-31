import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';

import '../../../model/my_challenge.dart';
import '../../../utils/app_color.dart';

class ChallengeTitle extends StatelessWidget {
  const ChallengeTitle({
    super.key,
    required this.challenge,
  });

  final MyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.myChallenge.toCapitalized(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 25),
              ),
              Text(
                challenge.description.toCapitalized(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        const Icon(
          Icons.emoji_events,
          color: AppColor.accent,
          size: 30,
        )
      ],
    );
  }
}
