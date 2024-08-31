import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, List> generateChallengeTrack({
  required int howManyDays,
  required DateTime startDate,
}) {
  Map<String, List> map = {};
  DateTime generateDate;
  String formattedDate;
  for (int i = 0; i < howManyDays; i++) {
    generateDate = startDate.add(Duration(days: i));
    formattedDate = getFormattedDate(generateDate);
    map[formattedDate] = [
      false,
      '',
      Timestamp.fromDate(generateDate),
    ];
  }

  return map;
}

String getFormattedDate(DateTime date) {
  String formattedDate = "${date.year}-${date.month}-${date.day}";
  return formattedDate;
}

bool isInputDateSmallerThanOrEqualCurrentDate(DateTime inputDate) {
  DateTime currentDate = DateTime.now();
  if (getFormattedDate(currentDate) == getFormattedDate(inputDate)) {
    return true;
  }
  return inputDate.isBefore(currentDate);
}
