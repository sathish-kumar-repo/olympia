import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_color.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.autofocus = false,
    this.onChanged,
    this.isDigitOnly = false,
    this.icon,
    this.isBorder = true,
  });
  final TextEditingController controller;
  final String placeholder;
  final bool autofocus;
  final void Function(String)? onChanged;
  final bool isDigitOnly;
  final IconData? icon;
  final bool isBorder;
  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      placeholder: placeholder,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 17,
          ),
      placeholderStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.placeholderText,
          ),
      onChanged: onChanged,
      autofocus: autofocus,
      cursorOpacityAnimates: true,
      clearButtonMode: OverlayVisibilityMode.editing,
      prefix: icon != null
          ? Icon(
              icon,
              color: AppColor.accent,
            )
          : null,
      inputFormatters: isDigitOnly
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      keyboardType: isDigitOnly ? TextInputType.number : null,
      maxLines: null,
      decoration: BoxDecoration(
        border: isBorder
            ? Border.all(
                color: AppColor.accent,
                width: 1.5,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
