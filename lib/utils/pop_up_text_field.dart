import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/my_text_field.dart';
import 'app_color.dart';

void popUpTextField(
  BuildContext context, {
  required TextEditingController textController,
  String text = '',
  required String title,
  required String hintText,
  String onSaveText = 'Save',
  required void Function(String text) onSave,
}) {
  if (text.isNotEmpty) {
    textController.text = text;
  }
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          content: Column(
            children: [
              MyTextField(
                controller: textController,
                placeholder: hintText,
                autofocus: true,
              ),
            ],
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
                Navigator.pop(context);
                String txt = textController.text;
                if (txt.isNotEmpty) {
                  onSave(txt);
                }
              },
              child: Text(
                onSaveText,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppColor.accent,
                ),
              ),
            ),
          ],
        ),
      );
    },
  ).then((value) => textController.clear());
}
