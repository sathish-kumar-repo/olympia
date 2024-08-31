import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:olympia/extension/date_extension.dart';
import 'package:olympia/extension/string_extension.dart';
import 'package:olympia/model/my_challenge.dart';

import 'package:olympia/page/challenge_view/widgets/challenge_score.dart';
import 'package:olympia/services/challenge_firestore.dart';

import 'package:olympia/utils/app_color.dart';
import '../../utils/get_today.dart';

import '../../utils/helper_fn.dart';
import '../../utils/pop_up_text_field.dart';
import 'widgets/challenge_progress.dart';

class ChallengeViewPage extends StatefulWidget {
  const ChallengeViewPage({
    super.key,
    required this.challenge,
  });
  final MyChallenge challenge;

  @override
  State<ChallengeViewPage> createState() => _ChallengeViewPageState();
}

class _ChallengeViewPageState extends State<ChallengeViewPage> {
  final TextEditingController _textController = TextEditingController();
  late ScrollController _scrollController;
  late dynamic result;
  ChallengeFirestoreService fireStoreService = ChallengeFirestoreService();
  //
  final db = FirebaseFirestore.instance;
  // late StreamSubscription sub;
  // late Map myChallengMap;
  //

  @override
  void initState() {
    super.initState();
    //
    // sub = db
    //     .collection('challenge')
    //     .doc(widget.challenge.docId)
    //     .snapshots()
    //     .listen((event) {
    //   setState(() {
    //     myChallengMap = event.data()!;
    //   });
    // });
    //

    result = getToday(widget.challenge);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex();
    });
  }

  void _scrollToIndex() {
    _scrollController = ScrollController();
    int jumpToIndex = 1;
    if (result is num) {
      jumpToIndex = result - 1;
    }
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            (_scrollController.position.maxScrollExtent /
                widget.challenge.track.length *
                (jumpToIndex)),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // sub.cancel();
    _scrollController.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<MyChallenge>(
          stream: fireStoreService.streamChallenge(widget.challenge.docId),
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
              MyChallenge? myChallenge = snapshot.data!;
              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  _buildAppBar(myChallenge),
                  _buildGridView(myChallenge),
                ],
              );
            }
          }),
    );
  }

  SliverAppBar _buildAppBar(MyChallenge myChallenge) {
    return SliverAppBar.large(
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
          color: AppColor.accent,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      stretch: true,
      pinned: true,
      expandedHeight: 500,
      backgroundColor: AppColor.bottomBar,
      surfaceTintColor: AppColor.accent,
      centerTitle: true,
      elevation: 10,
      shadowColor: AppColor.accent,
      title: Text(myChallenge.myChallenge.toCapitalized()),
      titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 20,
            color: AppColor.accent,
            letterSpacing: 1,
          ),
      flexibleSpace: FlexibleSpaceBar(
        background: ChallengeScore(
          challenge: myChallenge,
        ),
        stretchModes: const [
          StretchMode.fadeTitle,
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
      ),
    );
  }

  SliverPadding _buildGridView(MyChallenge myChallenge) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: AnimationLimiter(
        child: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: myChallenge.track.length,
          itemBuilder: (context, index) {
            final List lst = myChallenge.track.values.toList().elementAt(index);
            final DateTime date = lst[2];

            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 3,
              duration: const Duration(milliseconds: 500),
              // Entrie list animation
              child: SlideAnimation(
                verticalOffset: 50,
                child: ScaleAnimation(
                  delay: const Duration(milliseconds: 275),
                  child: ChallengeProgress(
                    day: index + 1,
                    date: date,
                    isDone: lst[0] as bool,
                    isNote: lst[1] != '',
                    isOverdue: (date.isOverdue && lst[0] == false),
                    onDone: () =>
                        _done(date, lst[1] as String, index, myChallenge),
                    onWriteNote: () => _writeNote(
                      date,
                      myChallenge.docId,
                      lst[1] as String,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _writeNote(DateTime date, String docId, String note) {
    popUpTextField(
      context,
      hintText: 'Your note',
      title: getDate(date),
      textController: _textController,
      text: note,
      onSave: (String text) {
        fireStoreService.addAndEditNote(
          docId: docId,
          note: text,
          date: date,
        );
      },
    );
  }

  void _showAlert(DateTime date, String note, MyChallenge myChallenge) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(
          'Its Cheating...',
          style: TextStyle(
            fontSize: 20,
            color: AppColor.accent,
          ),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(
              '${note.isEmpty ? 'Write' : 'Edit'} Note',
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);

              popUpTextField(
                context,
                hintText: 'Your note',
                title: getDate(date),
                textController: _textController,
                text: note,
                onSave: (String text) {
                  fireStoreService.addAndEditNote(
                    docId: myChallenge.docId,
                    note: text,
                    date: date,
                  );
                },
              );
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              'Back to Challenge',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  void _done(DateTime date, String note, int index, MyChallenge myChallenge) {
    List<List> valueList = myChallenge.track.values.toList();
    if (date.isUpComing) {
      _showAlert(date, note, myChallenge);
      return;
    }
    fireStoreService.updateProgress(
      date: date,
      docId: myChallenge.docId,
    );

    if (valueList.length - 1 == index) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          _showDialogToExtendChallenge(myChallenge);
        },
      );
    }
  }

  void _showDialogToExtendChallenge(MyChallenge myChallenge) {
    int days = 1;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: CupertinoAlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Extend Challenge by',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            content: SizedBox(
              height: 100,
              child: CupertinoPicker(
                itemExtent: 40,
                useMagnifier: true,
                scrollController: FixedExtentScrollController(
                  initialItem: 0,
                ),
                onSelectedItemChanged: (value) {
                  days = value + 1;
                },
                children: List.generate(
                  365,
                  (index) => Text(
                    (index + 1).toString(),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  fireStoreService.updateChallengeTrack(
                    docId: myChallenge.docId,
                    howManyDays: days,
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  'Extend',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColor.accent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class AnotherWidget extends StatelessWidget {
//   final Map data;

//   const AnotherWidget({super.key, required this.data});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(data['title'] ?? 'default'),
//     ); // Container
//   }
// }
//                 StreamProvider<List<Weapon>>.value(
// stream: db.streamWeapons (user),
// child: WeaponsList(),
// ), // Stream Provider.value
                // Access also current user


//  @override
//   Widget build(BuildContext context) {
//     final db = FirebaseFirestore.instance;
//     return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: db.collection('collectionPath').doc('id').snapshots(),
//         builder: (context, snapshot) {
//           Map data = snapshot.data!.data()!;
//           print(data['title']);
//           return Scaffold(
//             body: Column(
//               children: [
//                 StreamBuilder<MyChallenge>(
//                   stream: fireStoreService.streamChallenge('id'),
//                   builder: (context, snapshot) {
//                     MyChallenge a = snapshot.data!;
//                     return Container(
//                       child: Text(a.myChallenge),
//                     );
//                   },
//                 ),
//                 CustomScrollView(
//                   controller: _controller,
//                   slivers: <Widget>[
//                     _buildAppBar(),
//                     _buildGridView(),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//   }