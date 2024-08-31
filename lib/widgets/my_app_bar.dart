import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';

import 'package:olympia/utils/app_color.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.leading,
  });
  final String title;
  final Widget? leading;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppColor.bar,
      brightness: Brightness.dark,
      middle: Text(
        title.toCapitalized(),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20,
              color: AppColor.accent,
              letterSpacing: 1,
            ),
      ),
      leading: leading,
      trailing: trailing,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
