import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';
import 'package:olympia/services/save_firestore.dart';
import 'package:olympia/utils/app_color.dart';
import 'package:olympia/utils/helper_fn.dart';
import 'package:olympia/utils/pop_up_text_field.dart';
import 'package:olympia/widgets/confirmation.dart';
import '../../../../../model/my_save.dart';
import '../../../../../widgets/my_shadow_container.dart';
import '../../../../my_editor/my_editor_page.dart';

class MySaveTile extends StatefulWidget {
  const MySaveTile({super.key, required this.save});
  final MySave save;

  @override
  State<MySaveTile> createState() => _MySaveTileState();
}

class _MySaveTileState extends State<MySaveTile> {
  final firestoreServices = SaveFirestoreService();
  final _textController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyShadowContainer(
      borderRadius: 25,
      child: GestureDetector(
        onTap: _onSaveView,
        onLongPress: _onShowAction,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          title: Text(
            widget.save.title.toCapitalized(),
          ),
          titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 17,
              ),
          subtitle: Text(getDate(widget.save.dateTime)),
          subtitleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
              ),
          trailing: const Icon(
            CupertinoIcons.bookmark_fill,
            color: AppColor.accent,
          ),
        ),
      ),
    );
  }

  void _onSaveView() {
    Navigator.of(context)
        .push(CupertinoPageRoute(
      builder: (context) => MyTextEditor(
        title: widget.save.title,
        currentText: widget.save.saveNote,
      ),
    ))
        .then((value) {
      if (value != null) {
        firestoreServices.editSave(
          id: widget.save.id,
          save: value,
        );
      }
    });
  }

  void _onRenameTitle() {
    popUpTextField(
      context,
      textController: _textController,
      title: getDate(widget.save.dateTime),
      text: widget.save.title,
      hintText: 'Your title',
      onSave: (text) {
        firestoreServices.renameTitle(
          id: widget.save.id,
          title: text,
        );
      },
    );
  }

  void _onCopy() {
    firestoreServices.addSave(
      title: '${widget.save.title} - copy',
      save: widget.save.saveNote,
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
      firestoreServices.deleteSave(id: widget.save.id);
    }
  }

  void _onShowAction() {
    const TextStyle style = TextStyle(color: Colors.white);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text(
              'My Notes',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onSaveView();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              'Rename title',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onRenameTitle();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text(
              'Copy',
              style: style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _onCopy();
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
