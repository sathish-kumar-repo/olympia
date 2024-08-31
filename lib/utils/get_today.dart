import 'package:olympia/extension/date_extension.dart';
import 'package:olympia/model/my_challenge.dart';

import 'my_challenge_fn.dart';

enum DateType { future, pending, finish }

dynamic getToday(MyChallenge challenge) {
  List keylst = challenge.track.keys.toList();
  DateTime now = DateTime.now();
  int day = keylst.indexOf(getFormattedDate(now)) + 1;
  if (checkFinish(challenge)) {
    return DateType.finish;
  }
  if (day == 0) {
    if (checkFuture(challenge)) {
      return DateType.future;
    } else if (checkPending(challenge)) {
      return DateType.pending;
    }
  }
  return day;
}

bool checkFuture(MyChallenge challenge) {
  return challenge.track.values.every((lst) {
    DateTime date = lst[2] as DateTime;
    return (date.isFuture) && !date.isToday;
  });
}

bool checkPending(MyChallenge challenge) {
  List valueLst = challenge.track.values.toList();
  bool result1 = valueLst.every((lst) {
    DateTime date = lst[2] as DateTime;
    return (date.isPast) && !date.isToday;
  });
  bool result2 = valueLst.any((lst) => lst[0] == false);
  return result1 && result2;
}

bool checkFinish(MyChallenge challenge) =>
    challenge.track.values.every((lst) => lst[0] == true);
