# Datenquellen

Das Wörterbuch der App wird aus verschiedenen frei verfügbaren Quellen erstellt.
Der Erstellungsprozess ist ein zentraler Bestandteil der Applikation bzw. dessen Ressourcen, da diese Quellen die App
ausmacht.

Für das App-Wörterbuch wird auf folgende Quellen zurückgegriffen:

- FreeDict-Wörterbuch
- Wikiextract-Wörterbuch
- Verbiste Konjugationen

Der Umfang der verwendeten Daten und die genaue Zusammensetzung des App-Wörterbuches wird folgend erläutert.

## FreeDict

FreeDict-Wörterbücher existieren für mehrere Sprachen, sind frei verfügbar und dürfen auch verändert werden.
Ein großer Vorteil der Wörterbücher abseits der freien Verfügbarkeit ist ein standardisiertes Format.
Dies ist bei anderen Quellen wie z.B. Wiktionary nicht der Fall.

Die Wörterbücher können auf der [Download-Seite von FreeDict](https://freedict.org/de/downloads/) in der Sektion
_Sources_ heruntergeladen werden.
Das heruntergeladene Archiv enthält eine `.tei`-Dateie, die dem Aufbau definiert
in [Guidelines for Electronic Text Encoding and Interchange](https://www.tei-c.org/release/doc/tei-p5-doc/en/Guidelines.pdf)
folgen.

Grundsätzlich besteht das FreeDict-Wörterbuch aus einem `teiHeader`-Header und einem `text`-Körper.
Ein Eintrag eines Wortes ist beispielsweise folgend gezeigt.
Ein Eintrag (`entry`) besteht aus:

* `form` mit `orth` und `pron`
* `gramGrp` mit `pos` und `gen`
* `sense`-Eintrag

```xml

<entry>
    <form>
        <orth>maison</orth>
        <pron>me.zɔ̃</pron>
        <pron>mɛ.zɔ̃</pron>
    </form>
    <gramGrp>
        <pos>n</pos>
        <gen>fem</gen>
    </gramGrp>
    <sense>
        <cit type="trans" xml:lang="de">
            <quote>Haus</quote>
        </cit>
        <sense>
            <def>(Construction) Bâtiment servant de logis, d’habitation, de demeure</def>
        </sense>
        <sense>
            <def>(Par métonymie) Maisonnée, famille</def>
        </sense>
        <sense>
            <def>Entreprise ayant une identité bien définie, souvent présentée comme prestigieuse</def>
        </sense>
        <sense>
            <def>(En particulier) Maison d’édition</def>
        </sense>
    </sense>
    <sense>
        <cit type="trans" xml:lang="de">
            <quote>Heim</quote>
            <quote>Haus</quote>
        </cit>
        <sense>
            <def>Ménage, foyer ; tout ce qui a rapport aux affaires domestiques (qu’il s’agisse réellement d’une maison
                ou d’une autre forme d’habitation)
            </def>
        </sense>
    </sense>
</entry>
```

### `<form>`: Wortformen

**Zweck:** Es fasst alle Angaben zur geschriebenen und gesprochenen Form eines Stichworts zusammen. Meist steht es am
Anfang des Eintrags.

**Typische Kindelemente:**

- `<orth>`: orthographische Form (Attribut `@type` für die Schreibungsart)
- `<pron>`: Aussprache

**Besonderheiten:**

- `<form>` kann wiederholt und rekursiv verschachtelt werden. Beispiel: „hospitaller or US hospitaler (ˈhɒspɪtələ)". Die
  Aussprache gilt für beide Formen, „US" nur für eine.

### `<gramGrp>`: grammatische Angaben

**Zweck:** Es gruppiert morphosyntaktische Informationen zum Stichwort.

**Kindelemente:**

- `<pos>`: Wortart
- `<gen>`: Genus

### `<sense>`: Bedeutung

**Zweck:** Es fasst alle Informationen zu **einer** Wortbedeutung zusammen, z. B. Definitionen, Beispiele und
Übersetzungsäquivalente.

**Typische Inhalte:**

- `<def>`: Definition (enthält den Text direkt und gruppiert nicht nur)
- `<cit>`: Beispiel oder Übersetzung (`type="example"` bzw. `type="translation"`)
- `<gramGrp>`: wenn die Grammatik nur für diese Bedeutung gilt

**Besonderheiten:**

- Es lässt sich beliebig tief schachteln (Unterbedeutungen) und darf in `<entry>`, `<hom>` oder `<sense>` stehen.
- Die Guidelines empfehlen es **auch bei nur einer Bedeutung**, damit die Kodierung konsistent bleibt.

## Verbiste

Die Konjugationen der Applikation werden über Verbiste berechnet.
[Verbiste](http://gvlsywt.cluster051.hosting.ovh.net/dev/verbiste.html) ist ein Projekt, das mittels XML-Dateien
französische Konjugationen zurückrechnen lässt.

Verbiste kommt mit zwei XML-Dateien aus, die folgend näher beleuchtet werden:

1. `verbs-fr.xml`: Liste mit Verben und Templates. Das Template stellt ein Verb dar, das sich in der Konjugation analog
   zu dem Verb verhält.
2. `conjugation-fr.xml`: Regeln für die Zwillingsverben.

Folgend sind Beispiele aus beiden Dateien gegeben:

```xml
<!--verbs-fr.xml-->
<v>
    <i>aberrer</i>
    <t>aim:er</t>
</v>
<v>
<i>abêtir</i>
<t>fin:ir</t>
</v>
<v>
<i>abhorrer</i>
<t>aim:er</t>
</v>
<v>
<i>abîmer</i>
<t>aim:er</t>
</v>
<v>
<i>abjurer</i>
<t>aim:er</t>
</v>
```

```xml
<!--conjugation-fr.xml Auszug für aim:er-->
<template name="aim:er">
    <infinitive>
        <infinitive-present>
            <p>
                <i>er</i>
            </p>
        </infinitive-present>
    </infinitive>
    <indicative>
        <present>
            <p>
                <i>e</i>
            </p>
            <p>
                <i>es</i>
            </p>
            <p>
                <i>e</i>
            </p>
            <p>
                <i>ons</i>
            </p>
            <p>
                <i>ez</i>
            </p>
            <p>
                <i>ent</i>
            </p>
        </present>
        <imperfect>
            <p>
                <i>ais</i>
            </p>
            <p>
                <i>ais</i>
            </p>
            <p>
                <i>ait</i>
            </p>
            <p>
                <i>ions</i>
            </p>
            <p>
                <i>iez</i>
            </p>
            <p>
                <i>aient</i>
            </p>
        </imperfect>
        <future>
            <p>
                <i>erai</i>
            </p>
            <p>
                <i>eras</i>
            </p>
            <p>
                <i>era</i>
            </p>
            <p>
                <i>erons</i>
            </p>
            <p>
                <i>erez</i>
            </p>
            <p>
                <i>eront</i>
            </p>
        </future>
        <simple-past>
            <p>
                <i>ai</i>
            </p>
            <p>
                <i>as</i>
            </p>
            <p>
                <i>a</i>
            </p>
            <p>
                <i>âmes</i>
            </p>
            <p>
                <i>âtes</i>
            </p>
            <p>
                <i>èrent</i>
            </p>
        </simple-past>
    </indicative>
    <conditional>
        <present>
            <p>
                <i>erais</i>
            </p>
            <p>
                <i>erais</i>
            </p>
            <p>
                <i>erait</i>
            </p>
            <p>
                <i>erions</i>
            </p>
            <p>
                <i>eriez</i>
            </p>
            <p>
                <i>eraient</i>
            </p>
        </present>
    </conditional>
    <subjunctive>
        <present>
            <p>
                <i>e</i>
            </p>
            <p>
                <i>es</i>
            </p>
            <p>
                <i>e</i>
            </p>
            <p>
                <i>ions</i>
            </p>
            <p>
                <i>iez</i>
            </p>
            <p>
                <i>ent</i>
            </p>
        </present>
        <imperfect>
            <p>
                <i>asse</i>
            </p>
            <p>
                <i>asses</i>
            </p>
            <p>
                <i>ât</i>
            </p>
            <p>
                <i>assions</i>
            </p>
            <p>
                <i>assiez</i>
            </p>
            <p>
                <i>assent</i>
            </p>
        </imperfect>
    </subjunctive>
    <imperative>
        <imperative-present>
            <p>
                <i>e</i>
            </p>
            <p>
                <i>ons</i>
            </p>
            <p>
                <i>ez</i>
            </p>
        </imperative-present>
    </imperative>
    <participle>
        <present-participle>
            <p>
                <i>ant</i>
            </p>
        </present-participle>
        <past-participle>
            <p>
                <i>é</i>
            </p>
            <p>
                <i>és</i>
            </p>
            <p>
                <i>ée</i>
            </p>
            <p>
                <i>ées</i>
            </p>
        </past-participle>
    </participle>
</template>
```

Für das App-Wörterbuch wird aus diesen Eingabedateien eine SQLite-Datenbank erstellt, die jede Form der enthaltenden
Verben enthält.
Eine Vorabberechnung dieser Verben ist nötig für die Flexionsformerkennung in der Eingabe in der App.

## Wiktionary

Wiktionary-Daten sind u. a. für die Aussprache relevant.
Diese sind im Tag `sounds` zu finden. Die Silbentrennung (`hyphenations`) wird nicht verwendet.

```json
{
  "word": "besinnen",
  "pos": "verb",
  "pos_title": "Verb",
  "lang_code": "de",
  "lang": "Deutsch",
  "sounds": [
    {
      "ipa": "[bəˈzɪnən]"
    },
    {
      "audio": "De-besinnen.ogg",
      "ogg_url": "https://commons.wikimedia.org/wiki/Special:FilePath/De-besinnen.ogg",
      "mp3_url": "https://upload.wikimedia.org/wikipedia/commons/transcoded/3/35/De-besinnen.ogg/De-besinnen.ogg.mp3"
    },
    {
      "rhymes": "ɪnən"
    }
  ],
  "hyphenations": [
    {
      "parts": [
        "be",
        "sin",
        "nen"
      ]
    }
  ]
}
```

### `sounds`: Aussprache

`sounds` hat ein Array als Wert.
Hier soll immer die Audio nach der Form `<lang-code>-<wort>.ogg` gewählt werden.
Es soll nur ein Link auf die MP3-Datei gespeichert werden.

## Erstellung des App-Wörterbuches

Dieser Abschnitt beschreibt, wie aus den drei Quellen das App-Wörterbuch entsteht, wie die Datenbank aufgebaut ist und
warum die Umsetzung so gewählt wurde.

Dateien: `scripts/build_dictionary.py` (Pipeline), `scripts/schema.sql` (Datenbankschema), `scripts/conjugation.py`
(Verbiste-Parser, wird von der Pipeline als Modul genutzt).

### Überblick

**Ein Sprachpaar ergibt genau eine SQLite-Datei.** Es gibt also `dictionary-fr-de.db` (Nutzer sucht Französisch, sieht
deutsche Übersetzungen) und `dictionary-de-fr.db` (umgekehrt).
Die Sprache der Suche heißt im Folgenden _Ausgangssprache_, die Sprache der Übersetzungen _Zielsprache_.

```
FreeDict (fra-deu.tei)  ──┐
Wiktionary (fr_raw-…)   ──┼──►  build_dictionary.py  ──►  dictionary-fr-de.db
Verbiste (nur für fr)   ──┘
```

Aufruf:

```bash
# Französisch → Deutsch (mit Konjugationen)
python scripts/build_dictionary.py --pair fr-de --sources <files-dir> --verbiste <verbiste/data>

# Deutsch → Französisch (deutsche Verben werden nicht konjugiert)
python scripts/build_dictionary.py --pair de-fr --sources <files-dir>
```

`<files-dir>` enthält `freedict/fra-deu.tei`, `freedict/deu-fra.tei` und `wikiextract/fr_raw-wiktextract-data.jsonl`,
`wikiextract/de_raw-wiktextract-data.jsonl`.
Mit `--no-wiktionary` wird der lange Wiktionary-Scan übersprungen (zum Testen), mit `--limit N` werden nur die ersten N
Einträge verarbeitet.

### Ablauf der Pipeline

#### 1. FreeDict lesen: das Gerüst

FreeDict ist der Ausgangspunkt, weil es die kleinste Quelle ist (rund 48.600 Einträge fr-de, 59.600 de-fr) und ein
einheitliches Format hat.
Pro `<entry>` werden übernommen:

| Aus FreeDict          | Wird zu                                                                       |
|-----------------------|-------------------------------------------------------------------------------|
| `form/orth` (erstes)  | Lemma, z. B. `maison`                                                         |
| weitere `orth`        | Varianten (suchbar)                                                           |
| `gramGrp/pos`         | Wortart (`n` → `noun`, `pn` → `proper_noun`, `v` → `verb`, sonst unverändert) |
| `gramGrp/gen`         | Genus (`masc`, `fem`, `neut`)                                                 |
| erstes `form/pron`    | IPA                                                                           |
| `sense` → `cit/quote` | Übersetzungen in der Zielsprache                                              |
| `sense` → `def`       | Erklärungen der Bedeutung                                                     |

Eine `<sense>` auf oberster Ebene wird zu **einer Bedeutung**. Ihre `quote`-Elemente sind die Übersetzungen, die
verschachtelten `def`-Elemente die Erklärungen.

> Die Datei `fra-deu.tei` enthält im Header ein ungültiges `<>` (`<encodingDesc><>`), das sich nicht parsen lässt. Die
> Pipeline entfernt diese Zeichen vor dem Parsen im Speicher. Die Quelldatei bleibt unverändert.

#### 2. Wiktionary lesen: Zusatzinformationen

Die Wiktionary-Dateien sind sehr groß (3 GB bzw. 7 GB). Sie werden **einmal Zeile für Zeile** gelesen. Aus jeder Zeile
wird zuerst nur das Wort gelesen. Nur wenn es in FreeDict vorkommt, wird die Zeile vollständig geparst und auf die
benötigten Felder reduziert.

Zuordnung zu einem FreeDict-Eintrag: gleiches Wort **und** passende Wortart (`noun` ↔ `n`). Gibt es mehrere
Wiktionary-Einträge (z. B. zwei Genera), gewinnt der Eintrag mit dem passenden Genus.

Aus Wiktionary kommen:

| Information                    | Regel                                                                                                               | Beispiel                                   |
|--------------------------------|---------------------------------------------------------------------------------------------------------------------|--------------------------------------------|
| **Plural**                     | nur bei Nomen; erste Form mit Tag `plural` (de: bevorzugt Nominativ)                                                | `Haus` → `Häuser`, `cheval` → `chevaux`    |
| **Hilfsverb** (fr)             | Form mit Tags `infinitive` + `past`, erstes `avoir`/`être` darin                                                    | `avoir lu` → `avoir`; `s’être tu` → `être` |
| **Hilfsverb** (fr, pronominal) | hat das Verb keine solche Form, aber den Tag `pronominal`, ist es `être`                                            | `se candir` → `être`                       |
| **Hilfsverb** (de)             | Form mit Tags `auxiliary` + `perfect`                                                                               | `kaufen` → `haben`                         |
| **IPA**                        | FreeDict zuerst, sonst erste IPA aus Wiktionary (ohne `[]`, `\\`, `//`)                                             | `[ˈkaʊ̯fn̩]` → `ˈkaʊ̯fn̩`                      |
| **Aussprache-Link**            | MP3-Link der Datei `<Lang>-<Wort>.ogg`; gibt es sie nicht, die erste MP3-Aufnahme (Aufnahmen aus Frankreich zuerst) | `De-kaufen.ogg` → MP3-Link                 |
| **Genus-Lücke**                | fehlt das Genus in FreeDict, wird es aus den Wiktionary-Tags ergänzt; mehrere Genera werden mit `/` verbunden       | `élève` → `masc/fem`                       |
| **Flexionsformen**             | alle Einzelwort-Formen (keine Formen mit Leerzeichen wie „habe gekauft“)                                            | `gekauft`, `Häuser`, `chevaux`             |

**Synonyme und Antonyme werden bewusst nicht gespeichert** (siehe [Entscheidungen](#entscheidungen-und-gründe)).

#### 3. Verbiste: Konjugationen (nur Französisch)

Verbiste kennt pro Verb ein **Template** (z. B. `lire` → `l:ire`) und pro Template die Endungen aller Zeiten.
Die Pipeline schneidet die Endung des Templates vom Infinitiv ab und erhält den **Stamm**:

```
lire  +  Template l:ire  →  Stamm „l"
Stamm „l" + Endung „is" (Indikativ Präsens, 1. Person)  →  „lis"
```

- Pro Verb werden Template und Stamm gespeichert.
- Die Endungen jedes Templates werden **einmal** in `conjugation_template` abgelegt (117 Templates statt 4.000 Verben
  mal ca. 90 Formen).
- Alle Formen (`lis`, `lira`, `liraient`, …) werden zusätzlich als Suchbegriffe in `lookup` eingetragen, damit die Suche
  nach einer konjugierten Form das Verb findet.
- Pronominale Verben (`se laver`, `s’arroger`) werden über das Verb ohne `se`/`s’` gefunden.

#### 4. Datenbank schreiben und auswerten

Alles wird in einer Transaktion geschrieben, anschließend laufen `ANALYZE` und `VACUUM`.

### Datenbankstruktur

```
entry ──< sense ──< translation      (Übersetzungen, z. B. „maison“)
  │         └──< definition          (Erklärungen)
  └──< lookup                        (Suchindex: Lemma, Varianten, Flexionsformen)

conjugation_template                 (Endungen je Template, entry.template verweist darauf)
meta                                 (Sprachpaar, Version)
```

#### `entry`: ein Wort mit einer Wortart

| Spalte             | Bedeutung                                                               |
|--------------------|-------------------------------------------------------------------------|
| `id`               | Schlüssel                                                               |
| `lemma`            | Grundform, z. B. `Haus`                                                 |
| `pos`              | Wortart: `noun`, `verb`, `adj`, `adv`, `proper_noun`, …                 |
| `gender`           | `masc`, `fem`, `neut` oder mehrere wie `masc/fem`; leer, wenn unbekannt |
| `plural`           | nur Nomen                                                               |
| `ipa`              | Aussprache ohne Begrenzer                                               |
| `audio_url`        | Link auf die MP3-Datei                                                  |
| `auxiliary`        | Hilfsverb (`avoir`, `être`, `haben`, `sein`), nur Verben                |
| `template`, `stem` | nur französische Verben: Verbiste-Template und Stamm                    |

Beispiel (`dictionary-de-fr.db`):

| id    | lemma | pos  | gender | plural | ipa  | audio_url           |
|-------|-------|------|--------|--------|------|---------------------|
| 16341 | Haus  | noun | neut   | Häuser | haʊ̯s | `…/De-Haus.ogg.mp3` |

Gleich geschriebene Wörter sind **eigene Einträge** mit eigener `id` (z. B. `maison` als Nomen und ein weiterer
FreeDict-Eintrag zu `maison`).

#### `lookup`: der Suchindex

Jede Zeile verbindet einen Suchbegriff mit einem Eintrag.

| Spalte      | Bedeutung                                 |
|-------------|-------------------------------------------|
| `term`      | kleingeschrieben, mit Akzenten: `häuser`  |
| `term_fold` | kleingeschrieben, ohne Akzente: `hauser`  |
| `entry_id`  | Eintrag                                   |
| `kind`      | `0` Lemma, `1` Variante, `2` Flexionsform |

Beispiel für `Haus`:

| term    | term_fold | kind |
|---------|-----------|------|
| haus    | haus      | 0    |
| hauses  | hauses    | 2    |
| häuser  | hauser    | 2    |
| häusern | hausern   | 2    |

Suche des Nutzers (Eingabe wird auf dieselbe Weise normalisiert):

```sql
-- genaue Suche (Akzente zählen)
SELECT e.*
FROM lookup l
         JOIN entry e ON e.id = l.entry_id
WHERE l.term = 'häuser';

-- tolerante Suche (Nutzer tippt „eleve“ statt „élève“)
SELECT e.*
FROM lookup l
         JOIN entry e ON e.id = l.entry_id
WHERE l.term_fold = 'eleve';
```

Treffer mit `kind = 0` sollten vor `kind = 2` angezeigt werden.

#### `sense`, `translation`, `definition`: Bedeutungen

Eine `sense` ist eine Bedeutung des Eintrags (`position` gibt die Reihenfolge). Daran hängen:

- `translation`: die Übersetzungen in der Zielsprache, jede einzeln (damit sie anklickbar sind)
- `definition`: Erklärungen der Bedeutung in der Ausgangssprache

Beispiel `Haus` (de-fr), Übersetzungen pro Bedeutung:

| sense.position | translation.text |
|----------------|------------------|
| 0              | maison           |
| 0              | logis            |
| 1              | maison           |
| 2              | chambre          |

#### `conjugation_template` und die Konjugation

Eine Form berechnet sich als `entry.stem || conjugation_template.ending`.

Beispiel `lire` (Template `l:ire`, Stamm `l`), Indikativ Präsens:

| person | ending | Form   |
|--------|--------|--------|
| 0      | is     | lis    |
| 1      | is     | lis    |
| 2      | it     | lit    |
| 3      | isons  | lisons |
| 4      | isez   | lisez  |
| 5      | isent  | lisent |

```sql
SELECT mood, tense, person, variant, e.stem || t.ending AS form
FROM entry e
         JOIN conjugation_template t ON t.template = e.template
WHERE e.id = :entry_id
ORDER BY mood, tense, person, variant;
```

`person` ist der 0-basierte Index innerhalb der Zeitform (je, tu, il/elle, nous, vous, ils/elles; Imperativ: tu, nous,
vous; Partizip Perfekt: m. sg., m. pl., f. sg., f. pl.). `variant` > 0 sind Alternativformen.

#### `meta`

Schlüssel-Wert-Paare: `source_lang`, `target_lang`, `schema_version`, `entries`.
Die App erkennt daran, welches Sprachpaar die Datei enthält.

### Entscheidungen und Gründe

| Entscheidung                                           | Grund                                                                                                                                                                                                                                                                                                                   |
|--------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **SQLite**                                             | Eine einzelne Datei, lokal und offline nutzbar, die Suche läuft über Indizes statt über das Laden aller Daten. Die Daten sind relational (Eintrag → Bedeutungen → Übersetzungen). In Flutter über `sqflite` oder `drift` nutzbar. JSON/XML müssten komplett geladen werden, NoSQL-Lösungen bringen hier keinen Vorteil. |
| **Ein Sprachpaar = eine Datenbank**                    | Der Nutzer installiert nur, was er braucht. Die Abfragen brauchen keinen Sprachfilter, und es gibt keine Verwechslung gleich geschriebener Wörter in verschiedenen Sprachen (z. B. `Gift`).                                                                                                                             |
| **FreeDict als Ausgangspunkt**                         | Kleinste Quelle mit einheitlichem Format. Wiktionary ergänzt nur. Wörter, die nur in Wiktionary stehen, kommen nicht ins Wörterbuch.                                                                                                                                                                                    |
| **Flexionsformen vorberechnen**                        | Von `gekauft` kann man nicht zuverlässig auf `kaufen` zurückrechnen. Wer die Formen vorab speichert, braucht in der App keine Logik.                                                                                                                                                                                    |
| **Konjugationsendungen als Template speichern**        | Die Formen aller Verben auszuschreiben wäre ein Vielfaches größer (ca. 700.000 Zeilen). Pro Verb genügen Template und Stamm, die Form ergibt sich beim Anzeigen. Nur der Suchindex enthält die Formen ausgeschrieben.                                                                                                   |
| **`term` und `term_fold`**                             | Die genaue Suche bleibt akzentgenau, die tolerante Suche findet auch bei fehlenden Akzenten.                                                                                                                                                                                                                            |
| **Plural nur bei Nomen**                               | Bei Verben liefert Wiktionary Formen mit dem Tag `plural` (Imperativ Plural, z. B. „kauft!“), die kein Plural im Sinne der App sind.                                                                                                                                                                                    |
| **Keine Synonyme und Antonyme**                        | Wiktionary ordnet sie nur im Deutschen verlässlich einzelnen Bedeutungen zu. Im Französischen bliebe nur eine Gesamtliste, die bei Wörtern wie `Bank` irreführend wäre. Eine Funktion, die nur in einer Sprache sinnvoll funktioniert, wird nicht angeboten. Das Schema lässt sich später um eine Tabelle dafür erweitern. |
| **Gleich geschriebene Einträge bleiben getrennt**      | Die Pipeline kann nicht entscheiden, ob zwei Einträge dasselbe Wort sind. Ob die App sie zusammenfasst, ist eine Frage der Oberfläche.                                                                                                                                                                                  |
| **Genus-Lücken aus Wiktionary füllen**                 | Das Genus ist für Lernende wichtig. Schwankendes Genus wird nicht verschwiegen (`masc/neut`).                                                                                                                                                                                                                           |
| **Aussprache: Fallback auf irgendeine MP3**            | Bei Französisch folgt nur jede siebte Datei der Regel `Fr-<Wort>.ogg`. Ohne Fallback hätten über 85 % der Wörter keine Aussprache.                                                                                                                                                                                      |
| **Keine Silbentrennung**                               | Entschieden, nicht Teil des Wörterbuchs. Die französischen Wiktionary-Daten enthalten sie ohnehin nicht.                                                                                                                                                                                                                |
| **Deutsche Verben ohne Konjugation und Flexionssuche** | Aktuell nicht im Umfang. Das Schema lässt eine spätere Erweiterung zu.                                                                                                                                                                                                                                                  |
| **Keine Beispielsätze**                                | Nicht im Umfang der ersten Version; sie würden die Dateigröße stark erhöhen.                                                                                                                                                                                                                                            |

### Bekannte Lücken

Stand der letzten Erstellung:

|                                              | fr-de        | de-fr               |
|----------------------------------------------|--------------|---------------------|
| Einträge                                     | 48.578       | 59.631              |
| Dateigröße                                   | ca. 29 MB    | ca. 39 MB           |
| ohne Wiktionary-Treffer                      | 16           | 3.899               |
| Nomen ohne Genus                             | 105          | 359                 |
| Verben ohne Hilfsverb                        | 913          | 16                  |
| Verben ohne Verbiste-Template                | 1.136        | –                   |
| Einträge ohne Aussprache-Link                | 14.379       | 4.612               |

- **Verben ohne Template:** Rund 900 davon sind Wortgruppen wie `tirer la sonnette d’alarme`. Sie bekommen keine
  Konjugation und werden nicht über konjugierte Formen gefunden. Der Rest sind Neologismen wie `ghoster`.
- **Nomen ohne Genus:** Meist Pluralwörter wie `Eltern`. Die App zeigt dann kein Genus an.
- **Einträge ohne Wiktionary-Treffer:** Sie behalten die FreeDict-Daten, haben aber keinen Plural, keine Aussprache.

> `conjugations.db` im Ordner `scripts/` stammt aus einem früheren Zwischenschritt und wird nicht mehr gebraucht.
> `conjugation.py` bleibt, weil die Pipeline daraus die Verbiste-Dateien einliest.