import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../../utils/app_color.dart';

class MyToggle extends StatelessWidget {
  const MyToggle({
    super.key,
    required this.selectedIndex,
    required this.onToggle,
  });
  final int selectedIndex;
  final void Function(int?) onToggle;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ToggleSwitch(
        animate: true,
        radiusStyle: true,
        cornerRadius: 20.0,
        animationDuration: 400,
        dividerColor: Colors.transparent,
        initialLabelIndex: selectedIndex,
        activeBgColor: const [
          AppColor.accent,
        ],
        minWidth: 100,
        totalSwitches: 7,
        activeFgColor: Colors.white,
        inactiveFgColor: Colors.white,
        inactiveBgColor: Theme.of(context).scaffoldBackgroundColor,
        labels: const [
          'M',
          'T',
          'W',
          'T',
          'F',
          'S',
          'S',
        ],
        onToggle: onToggle,
      ),
    );
  }
}
