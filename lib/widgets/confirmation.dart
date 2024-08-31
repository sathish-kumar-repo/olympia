import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class ConfirmDeletion extends StatelessWidget {
  const ConfirmDeletion({
    super.key,
    required this.title,
    required this.onDeleteText,
    required this.message,
  });

  final String title;
  final String onDeleteText;
  final String message;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          letterSpacing: 1,
          color: AppColor.accent,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.grey,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false);
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
            Navigator.of(context).pop(true);
          },
          child: Text(
            onDeleteText,
            style: const TextStyle(
              fontSize: 18.0,
              color: AppColor.accent,
            ),
          ),
        ),
      ],
    );
  }
}
