import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:olympia/model/my_challenge.dart';
import 'package:olympia/services/challenge_firestore.dart';

import 'package:olympia/utils/get_today.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/my_challenge_fn.dart';
import 'widgets/my_challenge_tile.dart';
import '../../../../widgets/place_holder.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  final ChallengeFirestoreService firestoreService =
      ChallengeFirestoreService();
  int _selectedIndex = 0;

  String get _getText {
    switch (_selectedIndex) {
      case 0:
        return 'There are currently no ongoing challenges at this time.';
      case 1:
        return 'There are no upcoming challenges scheduled at the moment.';
      case 2:
        return 'There have been no finished challenges recently.';
      default:
        return 'There are currently no pending challenges awaiting action.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildToggle(),
        _buildListView(),
      ],
    );
  }

  Widget _buildToggle() {
    double width = 110;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ToggleSwitch(
          animate: true,
          radiusStyle: true,
          cornerRadius: 50.0,
          animationDuration: 400,
          dividerColor: Colors.transparent,
          initialLabelIndex: _selectedIndex,
          activeBgColor: const [
            AppColor.accent,
          ],
          customWidths: [width, width, width, width],
          minHeight: 50,
          totalSwitches: 4,
          activeFgColor: Colors.white,
          inactiveFgColor: Colors.white,
          inactiveBgColor: Theme.of(context).scaffoldBackgroundColor,
          labels: const ['On Going', 'Upcoming', 'Finished', 'Pending'],
          onToggle: (index) {
            setState(() {
              _selectedIndex = index ?? 0;
            });
          },
        ),
      ),
    );
  }

  Expanded _buildListView() {
    DateTime now = DateTime.now();
    return Expanded(
      child: StreamBuilder(
        stream: firestoreService.getChallengeStream(),
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
            final List<MyChallenge> originalList = snapshot.data!;

            List<MyChallenge> challengeLst = [];
            if (_selectedIndex == 0) {
              challengeLst = originalList
                  .where(
                    (challengeModel) =>
                        challengeModel.track.keys
                            .toList()
                            .contains(getFormattedDate(now)) &&
                        challengeModel.track.values
                            .toList()
                            .any((lst) => lst[0] == false),
                  )
                  .toList();
              challengeLst.sort(
                (a, b) => a.track[getFormattedDate(DateTime.now())]?[0] == true
                    ? 1
                    : -1,
              );
            } else if (_selectedIndex == 1) {
              challengeLst = originalList
                  .where(
                    (challengeModel) => checkFuture(challengeModel),
                  )
                  .toList();
            } else if (_selectedIndex == 2) {
              challengeLst = originalList
                  .where((challengeModel) => challengeModel.track.values
                      .toList()
                      .every((lst) => lst[0] == true))
                  .toList();
            } else {
              challengeLst = originalList
                  .where(
                    (challengeModel) =>
                        checkPending(challengeModel) &&
                        challengeModel.track.values
                            .toList()
                            .any((lst) => lst[0] == false),
                  )
                  .toList();
            }
            return challengeLst.isEmpty
                ? PlaceHolder(_getText)
                : _buildListViewItems(challengeLst);
          }
        },
      ),
    );
  }

  AnimationLimiter _buildListViewItems(List<MyChallenge> challengeLst) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 50),
        itemCount: challengeLst.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          child: FadeInAnimation(
            delay: const Duration(milliseconds: 275),
            child: MyChallengeTile(
              challenge: challengeLst[index],
            ),
          ),
        ),
      ),
    );
  }
}
