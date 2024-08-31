import 'package:flutter/material.dart';
import 'package:olympia/utils/app_color.dart';

SnackBar mySnackBar() {
  return const SnackBar(
    content: Text(
      'Tap back again to leave',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    // behavior: SnackBarBehavior.floating,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(10),
    // ),
    backgroundColor: AppColor.accent,
    duration: Duration(milliseconds: 2000),
  );
}
