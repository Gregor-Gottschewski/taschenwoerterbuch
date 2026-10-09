import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_text_field.dart';

/// Searchbar in the app's footer.
class SearchBarBottom extends StatelessWidget {
  const SearchBarBottom({super.key, required this.controller, this.onChanged});

  static const height = 64.0;

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SketchTextField(
      controller: controller,
      hint: AppLocalizations.of(context).searchHint,
      onChanged: onChanged,
      minHeight: height,
    );
  }
}
