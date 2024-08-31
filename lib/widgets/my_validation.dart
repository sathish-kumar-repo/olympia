import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class MyValidation extends StatelessWidget {
  const MyValidation({
    super.key,
    required this.txt,
  });
  final String txt;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        'Invalid Data',
        style: TextStyle(
          letterSpacing: 1,
          color: AppColor.error,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          txt,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.grey,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Okay',
            style: TextStyle(
              fontSize: 18.0,
              color: AppColor.accent,
            ),
          ),
        ),
      ],
    );
  }
}
