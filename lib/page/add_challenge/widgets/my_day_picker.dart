import 'package:flutter/cupertino.dart';
import 'package:olympia/utils/app_color.dart';

class MyDayPicker extends StatelessWidget {
  const MyDayPicker({
    super.key,
    required this.onSelectedItemChanged,
    required this.value,
  });
  final void Function(int value) onSelectedItemChanged;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: const BoxDecoration(
        color: AppColor.theme,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: CupertinoPicker(
        itemExtent: 40,
        useMagnifier: true,
        scrollController: FixedExtentScrollController(
          initialItem: (value - 1),
        ),
        onSelectedItemChanged: onSelectedItemChanged,
        children: List.generate(
          365,
          (index) => Text(
            (index + 1).toString(),
          ),
        ),
      ),
    );
  }
}
