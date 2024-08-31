import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:olympia/model/my_challenge.dart';
import 'package:olympia/services/challenge_firestore.dart';

import 'package:olympia/utils/app_color.dart';

import 'package:olympia/utils/navigation_bar_color.dart';
import 'package:olympia/utils/share.dart';
import 'package:olympia/widgets/my_app_bar.dart';
import 'package:olympia/widgets/place_holder.dart';

import '../../utils/helper_fn.dart';
import '../../utils/make_dismissible.dart';
import '../../utils/pop_up_text_field.dart';
import '../../widgets/confirmation.dart';
import '../../widgets/my_list_tile.dart';
import '../../widgets/my_shadow_container.dart';
import 'widgets/my_drag_handle.dart';
import 'widgets/my_icon_btn.dart';

class NotesViewPage extends StatefulWidget {
  const NotesViewPage({
    super.key,
    required this.challenge,
  });

  final MyChallenge challenge;
  @override
  State<NotesViewPage> createState() => _NotesViewPageState();
}

class _NotesViewPageState extends State<NotesViewPage> {
  final TextEditingController _textController = TextEditingController();

  ChallengeFirestoreService fireStoreService = ChallengeFirestoreService();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  List<List> _getFilterList(MyChallenge challenge) {
    return challenge.track.values
        .toList()
        .where((lst) => lst[1] != '')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.challenge),
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
              List<List<dynamic>> lstOfValues = _getFilterList(myChallenge);
              return lstOfValues.isEmpty
                  ? const PlaceHolder('No Notes found')
                  : _buildListView(myChallenge, lstOfValues);
            }
          }),
    );
  }

  MyAppBar _buildAppBar(MyChallenge challenge) {
    return MyAppBar(
      title: challenge.myChallenge,
      trailing: MyIconBtn(
        icon: CupertinoIcons.share,
        onTap: () => _onAllNotesShare(challenge),
      ),
    );
  }

  AnimationLimiter _buildListView(
      MyChallenge challenge, List<List<dynamic>> lstOfValues) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 50),
        itemCount: lstOfValues.length,
        itemBuilder: (context, index) {
          final String note = lstOfValues[index][1] as String;
          final DateTime date = lstOfValues[index][2] as DateTime;
          return _buildListViewItem(index, note, date, challenge);
        },
      ),
    );
  }

  AnimationConfiguration _buildListViewItem(
      int index, String note, DateTime date, MyChallenge challenge) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: FadeInAnimation(
        delay: const Duration(milliseconds: 275),
        child: MyShadowContainer(
          borderRadius: 50,
          child: GestureDetector(
            onTap: () => _showNote(note, date, challenge),
            child: MyListTile(
              title: getDate(date),
              subTitle: note,
              trailing: const Icon(
                CupertinoIcons.forward,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showNote(String note, DateTime date, MyChallenge challenge) {
    changeNavigationBarColor();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) => makeDismissible(
        context,
        child: _buildNotesView(date, note, challenge),
      ),
    ).then((value) => normalNavigationBarColor());
  }

  DraggableScrollableSheet _buildNotesView(
      DateTime date, String note, MyChallenge challenge) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      initialChildSize: 0.3,
      builder: (_, scrollController) => Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          top: 5,
        ),
        decoration: const BoxDecoration(
          color: AppColor.theme,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            _buildNotesHeader(scrollController, date, note, challenge),
            _buildNotesBody(scrollController, note, context)
          ],
        ),
      ),
    );
  }

  Expanded _buildNotesBody(
      ScrollController scrollController, String note, BuildContext context) {
    return Expanded(
      child: ListView(
        controller: scrollController,
        children: [
          Text(
            note,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
          ),
        ],
      ),
    );
  }

  ListView _buildNotesHeader(
    ScrollController scrollController,
    DateTime date,
    String note,
    MyChallenge challenge,
  ) {
    return ListView(
      shrinkWrap: true,
      controller: scrollController,
      children: [
        const MyDragHandle(),
        Row(
          children: [
            Expanded(
              child: Text(
                getDate(date),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            MyIconBtn(
              icon: CupertinoIcons.share,
              onTap: () => _shareNote(date, note),
            ),
            MyIconBtn(
              icon: CupertinoIcons.pencil,
              onTap: () => _editNote(date, note, challenge),
            ),
            MyIconBtn(
              icon: CupertinoIcons.delete,
              onTap: () => _deleteNote(date, challenge),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  void _onAllNotesShare(MyChallenge challenge) {
    String shareText = 'My Challenge : ${challenge.myChallenge}\n\n';
    List<List> myLst = challenge.track.values.toList();
    for (List lst in myLst) {
      if (lst[1] != '') {
        shareText +=
            '* Day - ${myLst.indexOf(lst) + 1} (${myDate(lst[2] as DateTime)})\n\t\t\t\t\t\t\t- ${lst[1] as String}\n\n';
      }
    }
    onShare(shareText);
  }

  void _shareNote(DateTime date, String note) {
    Navigator.pop(context);
    onShare('$note (${myDate(date)})');
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

  Future<void> _deleteNote(DateTime date, MyChallenge challenge) async {
    Navigator.pop(context);
    bool? confirmDelete = await showDeleteConfirmationDialog();
    if (confirmDelete != null && confirmDelete) {
      _delete(date, challenge);
    }
  }

  void _delete(DateTime date, MyChallenge challenge) async {
    await fireStoreService.deleteNote(docId: challenge.docId, date: date);
  }

  void _editNote(DateTime date, String note, MyChallenge challenge) {
    Navigator.pop(context);
    popUpTextField(
      context,
      hintText: 'Your note',
      title: getDate(date),
      textController: _textController,
      text: note,
      onSave: (String text) {
        fireStoreService.addAndEditNote(
          docId: challenge.docId,
          note: text,
          date: date,
        );
      },
    );
  }
}
