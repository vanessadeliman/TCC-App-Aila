import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Toggle extends StatefulWidget {
  final Function(bool) ativo;
  const Toggle(this.ativo, {super.key});

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 30.0,
      minHeight: 30,
      borderColor: [Theme.of(context).primaryColor],
      borderWidth: 1,
      activeBorders: [Border.all()],
      cornerRadius: 20.0,
      activeBgColors: const [
        [Colors.white],
        [Colors.white]
      ],
      activeFgColor: Colors.white,
      inactiveBgColor: selectedIndex == 1
          ? Theme.of(context).primaryColor
          : Theme.of(context).unselectedWidgetColor,
      inactiveFgColor: Theme.of(context).primaryColor,
      initialLabelIndex: selectedIndex,
      totalSwitches: 2,
      radiusStyle: true,
      onToggle: (index) {
        setState(() {
          selectedIndex = index ?? 0;
          widget.ativo(index == 1);
        });
        log('switched to: $index');
      },
    );
  }
}
