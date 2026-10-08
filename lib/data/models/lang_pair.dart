/// Übersetzungsrichtung: Quellsprache → Zielsprache.
enum LangPair {
  frDe('FR→DE'),
  deFr('DE→FR');

  const LangPair(this.label);

  final String label;

  LangPair get reversed => this == frDe ? deFr : frDe;
}
