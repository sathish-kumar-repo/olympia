import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:olympia/extension/date_extension.dart';
import 'package:olympia/extension/list_extension.dart';

String getPlanTitle(Map<String, dynamic> myTraining) {
  List<String> lst = [];

  myTraining.values.toList().forEach((map) {
    lst.add(map['title']);
  });
  return lst.toCommaSeparatedSentence();
}

Map<String, Map> getSortedMap(Map<String, Map> map) {
  return Map.fromEntries(map.entries.toList()
    ..sort(
      (a, b) => a.value['order'].compareTo(b.value['order']),
    ));
}

String getAppName(int index) {
  switch (index) {
    case 0:
      return 'Training';
    case 1:
      return 'Save';
    case 2:
      return 'To Do';
    default:
      return 'Challenge';
  }
}

IconData getAppIcon(int index) {
  switch (index) {
    case 0:
      return Icons.fitness_center;
    case 1:
      return CupertinoIcons.bookmark;
    case 2:
      return Icons.done_all;
    default:
      return Icons.check_circle_outline_outlined;
  }
}

String myDate(DateTime dateTime, {bool isTime = false}) {
  if (isTime) {
    return DateFormat('EEE, MMM dd yyyy hh:mm a').format(dateTime);
  } else {
    return DateFormat('EEE, MMM dd yyyy').format(dateTime);
  }
}

String getDate(DateTime date, {bool short = false}) {
  if (date.isYesterday) {
    return short ? 'yday' : 'Yesterday';
  } else if (date.isToday) {
    return 'Today';
  } else if (date.isTomorrow) {
    return short ? 'Tmrw' : 'Tomorrow';
  } else {
    return short ? DateFormat('EEE dd').format(date) : myDate(date);
  }
}

String getWeekDay(int weekday) {
  switch (weekday) {
    case 0:
      return 'monday';
    case 1:
      return 'tuesday';
    case 2:
      return 'wednesday';
    case 3:
      return 'thursday';
    case 4:
      return 'friday';
    case 5:
      return 'saturday';
    default:
      return 'sunday';
  }
}
