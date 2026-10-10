import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';

/// Localized title of the tense identified by [mood] and [tense], or the raw
/// `mood tense` keys for unknown tenses.
String tenseLabel(AppLocalizations l10n, String mood, String tense) =>
    switch ('$mood/$tense') {
      'indicative/present' => l10n.tenseIndicativePresent,
      'indicative/imperfect' => l10n.tenseIndicativeImperfect,
      'indicative/simple-past' => l10n.tenseIndicativeSimplePast,
      'indicative/future' => l10n.tenseIndicativeFuture,
      'conditional/present' => l10n.tenseConditionalPresent,
      'subjunctive/present' => l10n.tenseSubjunctivePresent,
      'subjunctive/imperfect' => l10n.tenseSubjunctiveImperfect,
      'imperative/imperative-present' => l10n.tenseImperative,
      'participle/past-participle' => l10n.tensePastParticiple,
      'participle/present-participle' => l10n.tensePresentParticiple,
      _ => '$mood $tense',
    };

const _persons = ['je', 'tu', 'il/elle', 'nous', 'vous', 'ils/elles'];
const _imperativePersons = ['tu', 'nous', 'vous'];
const _pastParticiplePersons = ['m. sg.', 'm. pl.', 'f. sg.', 'f. pl.'];

/// Label of [person] within the given tense, or an empty string if the tense
/// has no persons (e.g. the present participle).
String personLabel(String mood, String tense, int person) {
  final labels = switch ('$mood/$tense') {
    'imperative/imperative-present' => _imperativePersons,
    'participle/past-participle' => _pastParticiplePersons,
    'participle/present-participle' => const <String>[],
    _ => _persons,
  };
  return person >= 0 && person < labels.length ? labels[person] : '';
}
