import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:olympia/extension/date_extension.dart';

import '../../../utils/app_color.dart';
import '../../../utils/helper_fn.dart';

class ChallengeProgress extends StatelessWidget {
  const ChallengeProgress({
    super.key,
    required this.day,
    required this.date,
    required this.isDone,
    required this.isNote,
    required this.isOverdue,
    required this.onDone,
    required this.onWriteNote,
  });
  final bool isDone;
  final bool isNote;
  final bool isOverdue;
  final int day;
  final DateTime date;
  final VoidCallback onDone;
  final VoidCallback onWriteNote;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    const Duration duration = Duration(milliseconds: 500);
    return GestureDetector(
      onTap: onDone,
      onDoubleTap: onWriteNote,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width / 20),
          color: Colors.black,
          boxShadow: isDone
              ? [
                  const BoxShadow(
                    color: AppColor.accent,
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                  const BoxShadow(
                    color: AppColor.accent,
                    spreadRadius: -2,
                    blurRadius: 5,
                  ),
                ]
              : [
                  const BoxShadow(
                    color: AppColor.accent,
                    spreadRadius: 1,
                    blurRadius: 0,
                  ),
                  const BoxShadow(
                    color: AppColor.accent,
                    spreadRadius: -1,
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 8,
              left: 10,
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: date.isToday ? AppColor.accent : Colors.white,
                  fontSize: width / 25,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              child: AnimatedContainer(
                width: width / 50,
                height: width / 50,
                duration: duration,
                decoration: BoxDecoration(
                  color: isOverdue ? AppColor.error : null,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: AnimatedContainer(
                width: width / 40,
                height: width / 40,
                duration: duration,
                decoration: BoxDecoration(
                  color: isNote ? AppColor.accent : null,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            MSHCheckbox(
              size: width / 9,
              value: isDone,
              colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                checkedColor: AppColor.accent,
                uncheckedColor: Colors.grey,
              ),
              style: MSHCheckboxStyle.stroke,
              onChanged: (selected) => onDone(),
            ),
            Positioned(
              bottom: 3,
              child: Text(
                getDate(date, short: true),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: width / 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
