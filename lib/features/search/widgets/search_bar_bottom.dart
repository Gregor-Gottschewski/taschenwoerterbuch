import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_text_field.dart';

/// Suchleiste für den Footer des Such-Screens.
class SearchBarBottom extends StatelessWidget {
  const SearchBarBottom({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SketchTextField(
      controller: controller,
      hint: 'Wort suchen …',
      onChanged: onChanged,
    );
  }
}
