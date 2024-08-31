import 'package:flutter/material.dart';
import 'package:olympia/extension/date_extension.dart';
import 'package:olympia/extension/double_extension.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../model/my_challenge.dart';
import '../../../utils/app_color.dart';
import '../../../utils/get_today.dart';
import 'challenge_score_item.dart';

class ChallengeInfo extends StatelessWidget {
  const ChallengeInfo({
    super.key,
    required this.challenge,
  });
  final MyChallenge challenge;
  @override
  Widget build(BuildContext context) {
    double percent = _getPercent;
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            left: 0,
            child: ChallengScoreItem(
              title: _getTitle,
              value: _getValue,
            ),
          ),
          Positioned(
            top: 20,
            right: 0,
            child: ChallengScoreItem(
              title: 'Notes',
              value: _getNotes,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: ChallengScoreItem(
              title: 'Best',
              value: _getBest,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ChallengScoreItem(
              title: 'Fail',
              value: _getPending,
            ),
          ),
          CircularPercentIndicator(
            radius: 90,
            percent: percent,
            progressColor: AppColor.accent,
            backgroundColor: AppColor.accent.withOpacity(0.3),
            animation: true,
            animationDuration: 1000,
            circularStrokeCap: CircularStrokeCap.round,
            animateFromLastPercent: true,
            lineWidth: 20,
            center: Text(
              "${(percent * 100).toFormattedString()}%",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            arcType: ArcType.FULL_REVERSED,
            arcBackgroundColor: AppColor.accent.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  String get _getNotes {
    int length =
        challenge.track.values.where((lst) => lst[1] != '').toList().length;
    return length.toString();
  }

  String get _getBest {
    int length =
        challenge.track.values.where((lst) => lst[0] == true).toList().length;
    return length.toString();
  }

  String get _getPending {
    int length = challenge.track.values
        .where((lst) => (lst[0] == false && (lst[2] as DateTime).isOverdue))
        .toList()
        .length;
    return length.toString();
  }

  double get _getPercent {
    int length =
        challenge.track.values.where((lst) => lst[0] == true).toList().length;
    int total = challenge.track.values.length;

    return (length / total);
  }

  String get _getTitle {
    dynamic result = getToday(challenge);
    switch (result) {
      case DateType.pending:
        return 'Overdue';
      case DateType.future:
        return 'Future';
      case DateType.finish:
        return 'Finish';
      default:
        return 'Day';
    }
  }

  String get _getValue {
    dynamic result = getToday(challenge);
    if ([DateType.pending, DateType.future, DateType.finish].contains(result)) {
      return '';
    }
    return result.toString();
  }
}
