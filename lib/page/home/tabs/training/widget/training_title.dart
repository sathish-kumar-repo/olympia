import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';

class TrainingTitle extends StatelessWidget {
  const TrainingTitle(
    this.txt, {
    super.key,
  });

  final String txt;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        txt.toCapitalized(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 25,
            ),
      ),
    );
  }
}
