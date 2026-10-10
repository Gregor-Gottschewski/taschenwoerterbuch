import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/data/dictionary_providers.dart';
import 'package:taschenwoerterbuch/data/models/conjugation.dart';
import 'package:taschenwoerterbuch/features/detail/detail_controller.dart';

/// Display order of the `mood/tense` panes.
const _tenseOrder = [
  'indicative/present',
  'indicative/imperfect',
  'indicative/simple-past',
  'indicative/future',
  'conditional/present',
  'subjunctive/present',
  'subjunctive/imperfect',
  'imperative/imperative-present',
  'participle/past-participle',
  'participle/present-participle',
];

/// Loads the [Conjugation] of the verb identified by the given [EntryKey].
final conjugationProvider = FutureProvider.family<Conjugation, EntryKey>((
  ref,
  key,
) async {
  final entry = await ref.watch(entryProvider(key).future);
  final db = await ref.watch(dictionaryDbProvider(key.pair).future);

  final rows = await db.rawQuery(
    '''
    SELECT t.mood, t.tense, t.person, t.variant,
           COALESCE(e.stem, '') || t.ending AS form
    FROM entry e
    JOIN conjugation_template t ON t.template = e.template
    WHERE e.id = ?
    ORDER BY t.mood, t.tense, t.person, t.variant
    ''',
    [key.id],
  );

  final grouped = <String, Map<int, List<String>>>{};
  for (final r in rows) {
    final id = '${r['mood']}/${r['tense']}';
    if (id == 'infinitive/infinitive-present') continue;
    grouped
        .putIfAbsent(id, () => {})
        .putIfAbsent(r['person']! as int, () => [])
        .add(r['form']! as String);
  }

  int rank(String id) {
    final i = _tenseOrder.indexOf(id);
    return i < 0 ? _tenseOrder.length : i;
  }

  final ids = grouped.keys.toList()..sort((a, b) => rank(a).compareTo(rank(b)));

  return Conjugation(
    infinitive: entry.lemma,
    tenses: [
      for (final id in ids)
        TensePane(
          mood: id.split('/')[0],
          tense: id.split('/')[1],
          rows: [
            for (final p in grouped[id]!.entries)
              ConjugationRow(person: p.key, forms: p.value),
          ],
        ),
    ],
  );
});
