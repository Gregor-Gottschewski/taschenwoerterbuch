import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';

class Sense {
  const Sense({required this.translations, required this.definitions});

  final List<String> translations;
  final List<String> definitions;
}

/// A dictionary entry for a single lemma.
class Entry {
  const Entry({
    required this.id,
    required this.lemma,
    required this.senses,
    this.pos,
    this.gender,
    this.plural,
    this.ipa,
    this.audioUrl,
    this.auxiliary,
  });

  /// The unique identifier of the entry.
  final int id;

  /// The headword (base form) under which the entry is listed.
  final String lemma;

  /// The part of speech (e.g. `noun`, `verb`, `adj`), if known.
  final String? pos;

  /// The grammatical gender, if applicable.
  final String? gender;

  /// The plural form, if applicable.
  final String? plural;

  /// The pronunciation in IPA notation, if available.
  final String? ipa;

  /// The URL of an audio recording of the pronunciation, if available.
  final String? audioUrl;

  /// The auxiliary verb used for compound tenses, if applicable.
  final String? auxiliary;

  /// The individual meanings, each with its translations and definitions.
  final List<Sense> senses;
}

String? posLabel(AppLocalizations l10n, String? pos) => switch (pos) {
  'noun' => l10n.posNoun,
  'verb' => l10n.posVerb,
  'adj' => l10n.posAdjective,
  'adv' => l10n.posAdverb,
  'proper_noun' => l10n.posProperNoun,
  _ => null,
};
