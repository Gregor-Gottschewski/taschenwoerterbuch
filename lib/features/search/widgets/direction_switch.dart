import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_button.dart';

/// Shows the current language direction and switches on tab.
class DirectionSwitch extends StatelessWidget {
  const DirectionSwitch({
    super.key,
    required this.pair,
    required this.onPressed,
  });

  final LangPair pair;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SketchButton(label: pair.label, onPressed: onPressed);
  }
}
