import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:olympia/services/training_firestore.dart';
import 'package:olympia/utils/padding.dart';
import 'package:olympia/page/home/tabs/training/widget/training_view.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/helper_fn.dart';
import 'widget/my_toggle.dart';
import 'widget/training_title.dart';

class Training extends StatefulWidget {
  const Training({super.key, required this.selectedWeekDay});
  final Function(int) selectedWeekDay;
  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  int _weekday = DateTime.now().weekday - 1;

  final firestoreService = TrainingFirestoreServices();
  @override
  void initState() {
    widget.selectedWeekDay(_weekday);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestoreService.getTrainingStream(getWeekDay(_weekday)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                color: AppColor.accent,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong!'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data'),
            );
          } else {
            var training = snapshot.data!.data()!['training'];
            Map<String, Map>? myTraining =
                training != null ? Map<String, Map>.from(training) : null;

            return _buildTrainingView(myTraining);
          }
        });
  }

  Container _buildTrainingView(Map<String, Map<dynamic, dynamic>>? myTraining) {
    return Container(
      padding: getHomePad(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyToggle(
            selectedIndex: _weekday,
            onToggle: (index) {
              setState(() {
                widget.selectedWeekDay(index ?? _weekday);
                _weekday = index ?? _weekday;
              });
            },
          ),
          if (myTraining == null || myTraining.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No Training Data',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ),
            )
          else ...[
            const SizedBox(height: 20),
            TrainingTitle(getPlanTitle(getSortedMap(myTraining))),
            const SizedBox(height: 10),
            TrainingView(
              map: getSortedMap(myTraining),
              selectedWeekDayIndex: _weekday,
              docName: getWeekDay(_weekday),
            )
          ],
        ],
      ),
    );
  }
}
