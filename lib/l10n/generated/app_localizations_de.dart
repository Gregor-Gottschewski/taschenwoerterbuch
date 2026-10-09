// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Taschenwörterbuch';

  @override
  String get searchTitle => 'Wörterbuch';

  @override
  String get searchHint => 'Wort suchen …';

  @override
  String dictionaryLoadError(Object error) {
    return 'Wörterbuch leider nicht ladbar: $error';
  }

  @override
  String entryLoadError(Object error) {
    return 'Eintrag leider nicht ladbar: $error';
  }

  @override
  String get back => '← Zurück';

  @override
  String get senses => 'Bedeutungen';

  @override
  String pluralAbbr(String plural) {
    return 'Plural: $plural';
  }

  @override
  String auxiliaryVerb(String auxiliary) {
    return 'Hilfsverb: $auxiliary';
  }

  @override
  String get audioUnavailable => 'Audio ist nicht verfügbar';

  @override
  String get noInternet => 'Keine Internetverbindung';

  @override
  String get volumeMuted => 'Dein Ton ist stummgeschaltet';

  @override
  String get playPronunciation => 'Aussprache abspielen';

  @override
  String get loading => 'Lädt';

  @override
  String percentValue(int percent) {
    return '$percent %';
  }

  @override
  String get posNoun => 'Nomen';

  @override
  String get posVerb => 'Verb';

  @override
  String get posAdjective => 'Adjektiv';

  @override
  String get posAdverb => 'Adverb';

  @override
  String get posProperNoun => 'Eigenname';

  @override
  String get listen => 'Anhören';
}
