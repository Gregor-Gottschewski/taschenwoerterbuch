/// One person of a tense with its conjugated form(s).
class ConjugationRow {
  const ConjugationRow({required this.person, required this.forms});

  /// Index of the person within the tense (e.g. 0 = je, 5 = ils/elles).
  final int person;

  /// The conjugated form followed by any alternative forms.
  final List<String> forms;
}

/// A single tense (e.g. indicative present) with all of its persons.
class TensePane {
  const TensePane({
    required this.mood,
    required this.tense,
    required this.rows,
  });

  /// Mood key as stored in the data (e.g. `indicative`).
  final String mood;

  /// Tense key as stored in the data (e.g. `present`).
  final String tense;

  /// The persons of this tense, ordered by person.
  final List<ConjugationRow> rows;
}

/// The full conjugation of a verb.
class Conjugation {
  const Conjugation({required this.infinitive, required this.tenses});

  /// The infinitive form of the verb.
  final String infinitive;

  /// All available tenses in display order.
  final List<TensePane> tenses;
}
