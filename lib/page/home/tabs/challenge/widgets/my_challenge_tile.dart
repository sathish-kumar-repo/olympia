import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:olympia/model/my_challenge.dart';
import 'package:olympia/services/challenge_firestore.dart';

import 'package:olympia/utils/my_challenge_fn.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../widgets/confirmation.dart';
import '../../../../../widgets/my_list_tile.dart';
import '../../../../../widgets/my_shadow_container.dart';
import '../../../../add_challenge/add_challenge_page.dart';
import '../../../../challenge_view/challenge_view_page.dart';
import '../../../../my_editor/my_editor_page.dart';
import '../../../../notes_view/notes_view_page.dart';

class MyChallengeTile extends StatefulWidget {
  const MyChallengeTile({
    super.key,
    required this.challenge,
  });
  final MyChallenge challenge;

  @override
  State<MyChallengeTile> createState() => _MyChallengeTileState();
}

class _MyChallengeTileState extends State<MyChallengeTile> {
  final firestoreServices = ChallengeFirestoreService();
  @override
  Widget build(BuildContext context) {
    bool? isTodayPossible =
        widget.challenge.track[getFormattedDate(DateTime.now())]?[0] as bool?;
    bool finishedTask =
        widget.challenge.track.values.toList().every((lst) => lst[0] == true);
    return MyShadowContainer(
      borderRadius: 50,
      child: GestureDetector(
        onTap: _onChallengeView,
        onDoubleTap: _onNotesView,
        onLongPress: _onShowAction,
        child: MyListTile(
          title: widget.challenge.myChallenge,
          subTitle: widget.challenge.description,
          trailing: finishedTask
              ? MSHCheckbox(
                  size: 30,
                  value: true,
                  colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                    checkedColor: AppColor.accent,
                    uncheckedColor: Colors.grey,
                  ),
                  style: MSHCheckboxStyle.fillScaleColor,
                  onChanged: (selected) => _onChallengeView(),
                )
              : isTodayPossible != null
                  ? Container(
                      padding: const EdgeInsets.all(3),
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: AppColor.accent,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: isTodayPossible == true
                          ? Container(
                              decoration: const BoxDecoration(
                                color: AppColor.accent,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    )
                  : null,
        ),
      ),
    );
  }

  void _onChallengeView() {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => ChallengeViewPage(
        challenge: widget.challenge,
      ),
    ));
  }

  void _onNotesView() {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => NotesViewPage(
        challenge: widget.challenge,
      ),
    ));
  }

  void _onMyPlanView() {
    Navigator.of(context)
        .push(CupertinoPageRoute(
      builder: (context) => MyTextEditor(
        title: widget.challenge.myChallenge,
        currentText: widget.challenge.myPlan,
      ),
    ))
        .then((value) {
      if (value != null) {
        firestoreServices.editMyPlan(
          docId: widget.challenge.docId,
          myPlan: value,
        );
      }
    });
  }

  Future<bool?> showDeleteConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return const ConfirmDeletion(
          title: 'Confirm Deletion',
          onDeleteText: 'Delete',
          message: 'Are you sure to delete?',
        );
      },
    );
  }

  Future<void> _onDelete() async {
    bool? confirmDelete = await showDeleteConfirmationDialog();
    if (confirmDelete != null && confirmDelete) {
      firestoreServices.deleteChallenge(widget.challenge.docId);
    }
  }

  _onShowAction() {
    const TextStyle style = TextStyle(color: Colors.white);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text(
              'View Progress',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onChallengeView();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              'My Plan',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onMyPlanView();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              'Notes Journey',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onNotesView();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              'Edit',
              style: style,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddChallengePage(
                    challenge: widget.challenge,
                  ),
                ),
              );
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _onDelete();
            },
          ),
        ],
      ),
    );
  }
}
