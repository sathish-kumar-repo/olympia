import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    required this.subTitle,
    this.trailing,
  });
  final String title;
  final String subTitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      title: Text(
        title.toCapitalized(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 17,
          ),
      subtitle: Text(
        subTitle.toCapitalized(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.grey,
          ),
      trailing: trailing,
    );
  }
}
