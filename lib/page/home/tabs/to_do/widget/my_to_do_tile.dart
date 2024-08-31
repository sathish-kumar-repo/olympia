import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:olympia/extension/string_extension.dart';
import 'package:olympia/services/to_do_firestore.dart';

import '../../../../../model/my_to_do.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/helper_fn.dart';
import '../../../../../utils/pop_up_text_field.dart';
import '../../../../../utils/sound.dart';
import '../../../../../widgets/confirmation.dart';
import '../../../../../widgets/my_shadow_container.dart';

class MyToDoTile extends StatefulWidget {
  const MyToDoTile({
    super.key,
    required this.toDo,
  });
  final MyToDo toDo;

  @override
  State<MyToDoTile> createState() => _MyToDoTileState();
}

class _MyToDoTileState extends State<MyToDoTile> {
  final firestoreServices = ToDoFirestoreService();
  final _textController = TextEditingController();
  late bool isFinish;
  @override
  void initState() {
    super.initState();
    isFinish = widget.toDo.isFinish;
  }

  @override
  void dispose() {
    super.dispose();

    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) {
        return _showDeleteConfirmationDialog();
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: AppColor.error,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Icon(
          CupertinoIcons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) => _delete(),
      child: MyShadowContainer(
        borderRadius: 30,
        child: GestureDetector(
          onDoubleTap: _onDelete,
          onLongPress: _onShowAction,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            title: Text(
              widget.toDo.title.toCapitalized(),
            ),
            subtitle: Text(myDate(widget.toDo.dateTime, isTime: true)),
            titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            subtitleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey,
                  fontSize: 13,
                ),
            trailing: MSHCheckbox(
              size: 30,
              value: isFinish,
              colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                checkedColor: AppColor.accent,
                uncheckedColor: AppColor.accent,
              ),
              style: MSHCheckboxStyle.fillScaleColor,
              onChanged: _onComplete,
            ),
          ),
        ),
      ),
    );
  }

  void _onComplete(bool selected) async {
    _update();
    if (selected) {
      audioExperience(audioExperienceType: AudioExperienceType.finish);
    }
    await firestoreServices.completeToDo(
      id: widget.toDo.id,
      isFinish: isFinish,
    );
    _update();
  }

  void _update() {
    setState(() {
      isFinish = !isFinish;
    });
  }

  void _onEdit() {
    popUpTextField(
      context,
      textController: _textController,
      text: widget.toDo.title,
      title: 'My To Do',
      hintText: 'Type Here..',
      onSave: (text) {
        firestoreServices.editToDo(
          id: widget.toDo.id,
          title: text,
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog() {
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
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete != null && confirmDelete) {
      _delete();
    }
  }

  void _delete() {
    firestoreServices.deleteToDo(id: widget.toDo.id);
  }

  void _onShowAction() {
    const TextStyle style = TextStyle(color: Colors.white);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text(
              'Edit',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onEdit();
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
