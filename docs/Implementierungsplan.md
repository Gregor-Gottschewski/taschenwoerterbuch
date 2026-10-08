# Implementierungsplan

Dieses Dokument beschreibt den Aufbau der App (Dateien, Strukturen, UI) und teilt die Implementierung in Meilensteine
auf.
Grundlage sind `docs/Grundidee.md`, `docs/datasources.md`, die Wireframes in `wireframes/` und die Datenbankquellen in
`scripts/`.

> `Grundidee.md` nennt noch Synonyme/Antonyme, Silbentrennung und „IPA in Zielsprache“. `datasources.md` hat das
> verworfen.
> Dieser Plan folgt `datasources.md` und `scripts/schema.sql`.

## 1. Ziel und Umfang

**Im Umfang:**

* Suche DE → FR und FR → DE, mit toleranter Suche (Akzente) und Flexionsformen
* Detailansicht mit Genus, Plural, IPA, Wortart, Hilfsverb, Bedeutungen und anklickbaren Übersetzungen
* Konjugationstabellen (nur Französisch)
* Aussprache (MP3-Stream)
* Favoriten und Verlauf
* Wörterbuch-Verwaltung (Herunterladen, Löschen, Aktualisieren)
* Nach dem Download vollständig offline nutzbar (Ausnahme: Audio)

**Nicht im Umfang:** Synonyme/Antonyme, Silbentrennung, Beispielsätze, deutsche Konjugation, Anbindung an Vocabulaire,
zusammengesetzte Zeiten (z. B. Passé composé; die Datenbank enthält nur einfache Zeiten).

## 2. Technische Entscheidungen

| Thema       | Entscheidung                                                                                                                                              |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Framework   | Flutter (bereits vorhanden), Dart ^3.13                                                                                                                   |
| DB-Zugriff  | `sqflite`; Wörterbuch-DBs nur lesend geöffnet; `sqflite_common_ffi` in Tests                                                                              |
| State       | `flutter_riverpod` (ein Provider pro Feature, `AsyncNotifier` für die Suche)                                                                              |
| Navigation  | Imperativer `Navigator`-Stack. Der Brotkrumen-Pfad („Suche › Haus › maison“) und „← Zurück zu „Haus““ ergeben sich direkt aus dem Stack. Kein `go_router` |
| Nutzerdaten | Eigene `user.db` (sqflite) für Favoriten und Verlauf; `shared_preferences` für Einstellungen (zuletzt genutzte Richtung)                                  |
| Download    | `dio` mit Fortschritt, Abbruch und SHA-256-Prüfung; Ablage in `getApplicationSupportDirectory()`                                                          |
| Audio       | `just_audio` (Streaming der `audio_url`)                                                                                                                  |
| Teilen      | `share_plus`                                                                                                                                              |
| Schrift     | IBM Plex Sans (wie in den Wireframes), als Asset gebündelt statt über Google Fonts, da die App offline läuft                                              |
| Tests       | `flutter_test`; kleine Fixture-DB `test/fixtures/mini-fr-de.db`, erzeugt mit `build_dictionary.py --pair fr-de --limit 300 --no-wiktionary`               |

## 3. Dateistruktur

```
lib/
  main.dart                        # runApp, ProviderScope
  app.dart                         # MaterialApp, Theme, Start-Route
  core/
    theme/
      tokens.dart                  # Farben, Radien, Abstände, Textstile (aus wireframes/*/wf.css)
      app_theme.dart
    text_normalizer.dart           # lowercase + NFC + Akzentfaltung, identisch zu build_dictionary.py
    paths.dart                     # Speicherorte der Datenbanken
  data/
    models/
      entry.dart  sense.dart  search_hit.dart  conjugation.dart
      lang_pair.dart  dictionary_info.dart  favorite.dart  history_item.dart
    dictionary_db.dart             # öffnet eine Wörterbuch-DB, enthält die Abfragen
    dictionary_repository.dart     # eine DictionaryDb je installiertem Sprachpaar
    user_db.dart                   # Favoriten + Verlauf
    dictionary_catalog.dart        # Manifest lesen (Version, URL, Größe, SHA-256)
    dictionary_installer.dart      # Download, Entpacken, Prüfen, Löschen, Update
    audio_service.dart
  features/
    search/        search_screen.dart  search_controller.dart
      widgets/     search_bar_bottom.dart  direction_switch.dart  hit_tile.dart
                   recent_list.dart  no_results_view.dart  missing_dictionary_card.dart
    detail/        detail_screen.dart  detail_controller.dart
      widgets/     entry_header.dart  sense_tile.dart  translation_chip.dart
                   action_bar.dart  breadcrumb.dart
    conjugation/   conjugation_sheet.dart  conjugation_controller.dart
                   tense_card.dart  labels.dart
    library/       library_screen.dart  favorites_controller.dart        # Favoriten + Verlauf
    dictionaries/  dictionaries_screen.dart  dictionary_card.dart
                   dictionaries_controller.dart                          # Wörterbücher
  shared/widgets/
    gender_badge.dart  pos_tag.dart  lang_flag.dart
    section_header.dart  speaker_button.dart
test/
  text_normalizer_test.dart  dictionary_db_test.dart  search_test.dart
  conjugation_test.dart  installer_test.dart  widgets/…  fixtures/
assets/
  fonts/                           # IBM Plex Sans
  dev/                             # Entwicklungs-DBs, in .gitignore
```

Die Wörterbuch-DBs gehören im Release **nicht** in `assets/`. Für die Entwicklung gibt es `assets/dev/` und einen
Debug-Import, der die DBs in den App-Speicher kopiert, bis der Download (M7) existiert.

## 4. Datenschicht

Grundlage ist `scripts/schema.sql` (Schema-Version 1). Ein Sprachpaar ist eine SQLite-Datei:
`dictionary-fr-de.db` (48.578 Einträge, ca. 29 MB) und `dictionary-de-fr.db` (59.631 Einträge, ca. 39 MB).
`scripts/conjugations.db` ist veraltet und wird nicht verwendet.

### Modelle und Tabellen

| Tabelle                              | Dart-Modell / Verwendung                                                                                           |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| `meta`                               | `DictionaryInfo`: `source_lang`, `target_lang`, `schema_version`, `entries`. Die App prüft die Version beim Öffnen |
| `entry`                              | `Entry`: Lemma, Wortart, Genus (ggf. `masc/fem`), Plural, IPA, `audio_url`, Hilfsverb, `template`, `stem`          |
| `lookup`                             | Suchindex (`term`, `term_fold`, `kind`) → `SearchHit`                                                              |
| `sense`, `translation`, `definition` | `Sense` mit Übersetzungen (einzeln anklickbar) und Erklärungen                                                     |
| `conjugation_template`               | `Conjugation`: Endungen je Template; Form = `entry.stem \|\| ending`                                               |

### Abfragen

* **Live-Suche:** Eingabe normalisieren (`term`, `term_fold`). Präfixsuche per Bereichsabfrage
  (`term >= ? AND term < ?`),
  damit der Primärschlüsselindex genutzt wird, sowie über `term_fold` (Index `idx_lookup_fold`).
  Sortierung: `kind` (Lemma, Variante, Flexionsform), dann Länge; `LIMIT 20`.
  Flexionstreffer werden auf den Grundeintrag aufgelöst und dedupliziert (kein eigener Abschnitt).
* **Vorschau je Treffer:** Übersetzungen der ersten Bedeutung, kommagetrennt (`acheter, acquérir`);
  bei Nomen zusätzlich `Pl. …`.
* **Detail:** Eintrag, Bedeutungen (nach `position`), Übersetzungen und Erklärungen.
* **Anklickbare Übersetzungen:** Jede Übersetzung wird einzeln exakt in der Datenbank der **Gegenrichtung** gesucht (ein
  Batch pro Detailansicht). Treffer → tippbarer Chip. Kein Treffer oder Gegenrichtung nicht installiert → nicht
  tippbar (kursiv). Ein Treffer öffnet direkt das Detail, mehrere öffnen die Trefferliste (Klick = simulierte Eingabe,
  siehe `Grundidee.md`).
* **Konjugation:** `SELECT mood, tense, person, variant, stem || ending …` (siehe `datasources.md`), gruppiert zu
  `mood → tense → person → [Formen]`. `variant > 0` wird als „alt.:“ angezeigt.
* **Beschriftung** (`labels.dart`): `indicative/present` → „Indicatif / Présent“; Personen je, tu, il/elle, nous, vous,
  ils/elles; Imperativ nur tu, nous, vous; Partizip Perfekt masc. sg./pl., fém. sg./pl.

### Nutzerdaten (`user.db`)

```sql
CREATE TABLE favorite
(
    pair       TEXT    NOT NULL,
    lemma      TEXT    NOT NULL,
    pos        TEXT    NOT NULL,
    gender     TEXT,
    created_at INTEGER NOT NULL,
    PRIMARY KEY (pair, lemma, pos)
);
CREATE TABLE history
(
    pair        TEXT    NOT NULL,
    term        TEXT    NOT NULL,
    lemma       TEXT    NOT NULL,
    pos         TEXT    NOT NULL,
    gender      TEXT,
    searched_at INTEGER NOT NULL,
    PRIMARY KEY (pair, lemma, pos)
);
```

Der Schlüssel ist `(pair, lemma, pos)`, nicht `entry.id`, weil IDs bei einem Wörterbuch-Update neu vergeben werden.
Der Verlauf wird auf 50 Einträge begrenzt.

## 5. UI

Die Wireframes (`wireframes/Suche`, `wireframes/Detail, Navigation, Konjugation-html`,
`wireframes/Sonderfälle und Listen-html`) sind graustufig und dienen als Struktur- und Maßvorlage.

**Allgemein:**

* Keine Tab-Leiste. Navigation über Kopfzeile (★, ⚙) und „← Zurück“.
* Suchleiste unten (Daumenzone); die Trefferliste wächst von unten (umgekehrte `ListView`, ca. 20 Zeilen, nach oben
  scrollbar).
* Mindest-Touchfläche 44 px.
* Maße aus `wf.css` in `tokens.dart`: Titel 34/700, Überschrift 20/700, Listenlemma 18/700, Chips 17/600,
  Suchleiste 52 px hoch, Button-Radius 12, Karten-Radius 16.
* **Genus-Badge:** m = gefülltes Quadrat, f = Kreis mit Rand, n = schraffiert; kombinierte Genera (`masc/fem`) als zwei
  Badges.

| Screen            | Wireframe | Komponenten und Verhalten                                                                                                                                                                                                                                      |
|-------------------|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Start             | 1a        | Kopf „Wörterbuch“ mit ★/⚙. `MissingDictionaryCard` (Hinweis, Download-Button mit Größe) nur, wenn das Paar fehlt. „Zuletzt gesucht“ mit „Alle löschen“ (Flagge, Lemma, Wortart, ✕). Karte „★ Favoriten (n)“. Unten `DirectionSwitch` und `SearchBarBottom` |
| Fokus             | 1b        | Leiste liegt direkt über der Tastatur, Verlauf bleibt sichtbar                                                                                                                                                                                                 |
| Live-Vorschläge   | 2         | Abschnitt „Treffer“; `HitTile` mit `GenderBadge`, Lemma, Vorschau und `PosTag`. Debounce ca. 120 ms, veraltete Abfragen werden verworfen. ✕ leert die Eingabe                                                                                                 |
| Kein Treffer      | 3         | Leerzustand mit Hinweisen; Button „In FR → DE suchen“ wechselt die Richtung und wiederholt die Suche                                                                                                                                                           |
| Mehrere Treffer   | 4         | Beim Absenden mit mehreren exakten Treffern Abschnitte „Nomen“ und „Verb / Adjektiv“ (nur mit Treffern). Genau ein Treffer öffnet direkt das Detail                                                                                                            |
| Detail Nomen      | 5         | `EntryHeader` (Lemma, Richtungsflagge, `PosTag`, großes `GenderBadge`, „Pl.: …“, IPA in `[ ]`, `SpeakerButton`); Abschnitt „Bedeutungen“ mit nummerierten `SenseTile` (Chips und Erklärung); `ActionBar`: Brotkrumen, ← Zurück, ☆, ⤴                          |
| Navigation        | 7         | Chip öffnet das Detail in der Gegenrichtung; Brotkrumen „Suche › Haus › maison“; „← Zurück zu „Haus““; ohne `audio_url` kein Lautsprecher                                                                                                                      |
| Detail Verb       | 6a, 6d    | Zusätzlich Hilfsverb-Tag (avoir/être, haben/sein). Bei FR-Verben mit `template` Button „Konjugation ▴“                                                                                                                                                         |
| Ohne Konjugation  | 6c        | Verb ohne `template` oder DE → FR: Button fehlt, **kein** Fehlerzustand                                                                                                                                                                                        |
| Konjugation       | 6b, 6b′   | Bottom-Sheet über dem Detail (Scrim, Griff, ✕). Segmente Ind./Subj./Cond./Impér./Part./Inf.; je Zeit eine `TenseCard` mit Tabelle; Untertitel „Indicatif · Hilfsverb avoir“                                                                                   |
| Favoriten/Verlauf | 8         | Liste mit Flagge, Lemma, Genus, Wortart, ›. Umschalter Favoriten/Verlauf unten. Wischen nach links löscht (`Dismissible`), Tippen öffnet das Detail                                                                                                            |
| Wörterbücher      | 9         | `DictionaryCard` mit Zuständen: installiert (Größe, Löschen), nicht installiert (Herunterladen), lädt (Fortschrittsbalken, Abbrechen), Update verfügbar (Aktualisieren)                                                                                        |

### Navigationsfluss

```
Start ──Eingabe──► Live-Vorschläge ──Treffer──► Detail ──Chip──► Detail (Gegenrichtung) ──► …
  │                       └─ kein Treffer ─► Kein-Treffer-Ansicht        └─ Konjugation ─► Bottom-Sheet
  ├─ ★ ─► Favoriten/Verlauf ─► Detail
  └─ ⚙ ─► Wörterbücher
```

### Designsprache

Die Wireframes sind bewusst graustufig; die Designsprache aus `Grundidee.md` („ansprechendes Design“) ist noch offen.
Alle Werte laufen über `tokens.dart`, sodass Farben, Typografie und Dark Mode in M8 ohne Strukturänderung gesetzt werden
können.

## 6. Meilensteine

Jeder Meilenstein endet mit lauffähiger App, grünen Tests und einem Abnahmekriterium.

| #  | Meilenstein                 | Inhalt                                                                                                                                                                                | Abnahme                                                                         |
|----|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| M0 | Projektbasis                | Demo-App entfernen; Pakete, Ordnerstruktur, Theme-Tokens, Schrift-Assets; Dev-DBs in `assets/dev/` mit Debug-Import; Mini-Fixture-DB; `text_normalizer` mit Tests (Parität zu Python) | `flutter test` grün; App startet mit leerem Start-Screen                        |
| M1 | Datenschicht                | Modelle, `DictionaryDb`, `DictionaryRepository`; Suche (exakt, tolerant, Flexion); Detail- und Konjugationsabfrage; Unit-Tests gegen die Fixture                                      | `eleve` → `élève`, `häuser` → `Haus`, `lis` → `lire`; Tests grün                |
| M2 | Suche (1a–4)                | Start, `SearchBarBottom`, `DirectionSwitch`, Live-Liste, Kein-Treffer, Gruppierung bei mehreren Treffern; Richtung wird gespeichert                                                   | Wireframes 1a–4 mit Dev-DB nachgestellt; Trefferliste ohne spürbare Verzögerung |
| M3 | Detail (5, 6a, 6c, 6d)      | Header, Bedeutungen, Chips, Genus, Wortart, Hilfsverb, IPA, Plural; Leer- und Sonderfälle                                                                                             | Haus, lire, kaufen, tirer la sonnette d’alarme werden korrekt dargestellt       |
| M4 | Navigation & Aussprache (7) | Chip-Navigation in die Gegenrichtung, Brotkrumen, „Zurück zu …“, Lautsprecher (`just_audio`), Teilen                                                                                  | Haus → maison → Haus; Audio spielt; ohne URL kein Lautsprecher                  |
| M5 | Konjugation (6b, 6b′)       | Sheet, Segmente, `TenseCard`, Labels, Alternativformen                                                                                                                                | `lire` entspricht dem Wireframe; Stichprobe `aimer`, `finir`, `être` stimmt     |
| M6 | Favoriten & Verlauf (8)     | `user.db`, ☆-Umschalter, Verlaufseintrag beim Öffnen eines Details, Wischen-Löschen, „Alle löschen“, Karte „★ Favoriten (n)“                                                        | Favoriten und Verlauf überleben einen App-Neustart                              |
| M7 | Wörterbuch-Verwaltung (9)   | Manifest, Download mit Fortschritt und Abbruch, SHA-256-Prüfung, Löschen, Update, atomares Ersetzen; Dev-Assets entfernen; Fehlerfälle (Netz, Speicher)                               | Frischinstallation → Download → Suche im Flugmodus funktioniert                 |
| M8 | Design & Feinschliff        | Designsprache über Tokens, Dark Mode, Barrierefreiheit (Semantics, Schriftskalierung), Leistungsmessung, App-Icon/Launch-Screen, iOS-Release-Build                                    | Release-Build läuft auf einem Gerät; Checkliste unten erfüllt                   |

**Reihenfolge:** M0 → M1 → M2 → M3 → (M4, M5, M6 parallel möglich) → M7 → M8.
Bis M6 wird gegen die Dev-DBs entwickelt, damit der Download nicht blockiert.

**Checkliste M8:** Kontraste in Hell/Dunkel geprüft · Schriftskalierung bis 200 % ohne abgeschnittene Texte ·
VoiceOver liest Genus, Wortart und Chips sinnvoll · Kaltstart und erste Suche gemessen · Flugmodus-Test.

## 7. Teststrategie

* **Unit:** Normalisierung (Parität zu `build_dictionary.py`), Suche, Konjugation gegen die Fixture.
* **Widget:** `HitTile`, `GenderBadge`, `SenseTile` (tippbar/nicht tippbar), `ConjugationSheet`.
* **Integration:** Suche → Detail → Chip → Zurück; Download-Flow gegen einen gefakten Server.
* **Datenabgleich:** Stichproben der Konjugation gegen `scripts/dictionary-fr-de.db` direkt per SQL.

## 8. Risiken und offene Punkte

* **Hosting der Wörterbücher:** Es gibt noch keinen Download-Server. Vorschlag: GitHub Releases oder ein statischer
  Server
  mit `manifest.json` (Paar, Version, Größe, URL, SHA-256); die DBs werden gezippt ausgeliefert, die Manifest-URL ist
  konfigurierbar. Zu entscheiden vor M7.
* **Aussprache nur online:** `audio_url` ist ein MP3-Link (Streaming). Lokales Caching wäre eine spätere Erweiterung.
* **Richtungsfeld „FR → DE“:** Das Wireframe markiert es als tippbar. Angenommen wird dasselbe Verhalten wie bei ⇄
  (Umschalten).
* **Chips brauchen beide Wörterbücher:** Ist die Gegenrichtung nicht installiert, sind Chips nicht tippbar.
  Ein Hinweis mit Download-Angebot ist optional.
* **Datenlücken** (Stand `datasources.md`): 1.136 FR-Verben ohne Template (kein Konjugationsbutton), 14.379 FR-Einträge
  ohne Audio, 105 (fr-de) bzw. 359 (de-fr) Nomen ohne Genus (kein Badge). Im UI sind das Normalfälle, keine Fehler.
* **Plattformen:** Im Repo existiert nur `ios/`. Android lässt sich bei Bedarf mit
  `flutter create --platforms=android .` ergänzen.
* **Gleich geschriebene Einträge** bleiben getrennte Einträge (Entscheidung aus `datasources.md`); die Trennung zeigt
  die
  Trefferliste (Wireframe 4).
