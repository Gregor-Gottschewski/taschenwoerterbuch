## Brainstorming
- [ ] Suchleiste
- [x] Fokus auf DE zu FR und FR zu DE
- [x] Konjugationen
- [x] Aussprache
- [x] IPA
- [ ] Favouriten
- [ ] Anbindung zu Vocabulaire
- [x] lokal
- [ ] ansprechendes Design
	* Designsprache:

## Technische Grundlage
FreeDict stellt TEI-XML bereit mit dem folgenden Inhalt:

> Alternativ kann auch auch auf Wikidict zurückgegriffen werden.
> Dieses hat mehr Daten zur Verfügnung und Wikidict wird bereits verwendet, um die Aussprachedatei zu erhalten.

```xml
<entry>
    <form>
        <orth>kaufen</orth>
        <pron>ˈkaʊ̯fm̩</pron>
        <pron>ˈkaʊ̯fn̩</pron>
    </form>
    <gramGrp>
        <pos>v</pos>
    </gramGrp>
    <sense>
        <cit type="trans" xml:lang="fr">
            <quote>acheter</quote>
            <quote>acquérir</quote>
        </cit>
        <sense>
            <def>Ware gegen Entgelt erwerben</def>
        </sense>
    </sense>
    <sense>
        <cit type="trans" xml:lang="fr">
            <quote>acheter</quote>
            <quote>soudoyer</quote>
        </cit>
        <sense>
            <def>transitiv: eine Person bestechen</def>
        </sense>
    </sense>
</entry>
```

Dieser Eintrag würde benutzt werden, wenn der Nutzer `kaufen` in das Suchfeld eingibt.
Der Nutzer sieht hier keine erweiterten Informationen zu den Wörtern `acheter`, `acquérir` oder `soudoyer`.
Klickt der Nutzer auf ein `quote` wird eine Eingabe simuliert, d. h. der Klick auf eien Vokabel in einem Ergebnis ist gleichzusetzen wie das direkte Suchen einer Vokabel.

> Bei einem direkten Klick muss die Sprache mitgegeben werden, um Homographenfehler zu vermeiden, z. B. `Gift` in EN und DE.
> Jedes Wort innerhalbt eines quotes wird einzeln betrachtet. Existiert kein Eintrag, ist die Funktion nicht verfügbar.

**Problem:** Woher erkennt die App, ob die Eingabe Französisch oder Deutsch ist?
**Lösungsansätze:**
* Suche in beiden Wörterbüchern als `orth` und zeige ggfs. beide Ergebnisse klar gentrennt durch z. B. eine Flagge als Kennzeichner an.
* Ausgangssprache wird durch den Nutzer vor der Eingabe festgelegt.

Es folgt als Gegenbeispiel der französische Eintrag, der gezeigt werden würde, wenn der Nutzer auf `acheter` drückt:

```xml
<entry>
    <form>
        <orth>acheter</orth>
        <pron>a.ʃə.te</pron>
        <pron>aʃ.te</pron>
    </form>
    <gramGrp>
        <pos>v</pos>
    </gramGrp>
    <sense>
        <cit type="trans" xml:lang="de">
            <quote>erstehen</quote>
            <quote>abkaufen</quote>
            <quote>einkaufen</quote>
            <quote>sich kaufen</quote>
            <quote>kaufen</quote>
        </cit>
    </sense>
    <sense>
        <cit type="trans" xml:lang="de">
            <quote>kaufen</quote>
        </cit>
        <sense>
            <def>Acquérir quelque chose en l’échangeant contre sa valeur en devise</def>
        </sense>
    </sense>
    <sense>
        <cit type="trans" xml:lang="de">
            <quote>kaufen</quote>
            <quote>bestechen</quote>
        </cit>
        <sense>
            <def>Corrompre quelqu’un à l’aide de pots-de-vin</def>
        </sense>
    </sense>
</entry>
```

Die Konjugationen sollen über Verbiste ermöglicht werden.
Verbiste kommt mit zwei XML-Dateien aus, die folgend näher beleuchtet werden:

1. `verbs-fr.xml`: Liste mit Verben und Templates. Das Template stellt ein Verb dar, das sich in der Konjugation analog zu dem Verb verhält.
2. `conjugation-fr.xml`: Regeln für die Zwillingsverben.

Folgend sind Beispiele aus beiden Dateien gegeben:

```xml
<!--verbs-fr.xml-->
<v><i>aberrer</i>		<t>aim:er</t></v>
<v><i>abêtir</i>		<t>fin:ir</t></v>
<v><i>abhorrer</i>		<t>aim:er</t></v>
<v><i>abîmer</i>		<t>aim:er</t></v>
<v><i>abjurer</i>		<t>aim:er</t></v>
```

```xml
<!--conjugation-fr.xml Auszug für aim:er-->
<template name="aim:er">
	<infinitive>
		<infinitive-present>
			<p><i>er</i></p>
		</infinitive-present>
	</infinitive>
	<indicative>
		<present>
			<p><i>e</i></p>
			<p><i>es</i></p>
			<p><i>e</i></p>
			<p><i>ons</i></p>
			<p><i>ez</i></p>
			<p><i>ent</i></p>
		</present>
		<imperfect>
			<p><i>ais</i></p>
			<p><i>ais</i></p>
			<p><i>ait</i></p>
			<p><i>ions</i></p>
			<p><i>iez</i></p>
			<p><i>aient</i></p>
		</imperfect>
		<future>
			<p><i>erai</i></p>
			<p><i>eras</i></p>
			<p><i>era</i></p>
			<p><i>erons</i></p>
			<p><i>erez</i></p>
			<p><i>eront</i></p>
		</future>
		<simple-past>
			<p><i>ai</i></p>
			<p><i>as</i></p>
			<p><i>a</i></p>
			<p><i>âmes</i></p>
			<p><i>âtes</i></p>
			<p><i>èrent</i></p>
		</simple-past>
	</indicative>
	<conditional>
		<present>
			<p><i>erais</i></p>
			<p><i>erais</i></p>
			<p><i>erait</i></p>
			<p><i>erions</i></p>
			<p><i>eriez</i></p>
			<p><i>eraient</i></p>
		</present>
	</conditional>
	<subjunctive>
		<present>
			<p><i>e</i></p>
			<p><i>es</i></p>
			<p><i>e</i></p>
			<p><i>ions</i></p>
			<p><i>iez</i></p>
			<p><i>ent</i></p>
		</present>
		<imperfect>
			<p><i>asse</i></p>
			<p><i>asses</i></p>
			<p><i>ât</i></p>
			<p><i>assions</i></p>
			<p><i>assiez</i></p>
			<p><i>assent</i></p>
		</imperfect>
	</subjunctive>
	<imperative>
		<imperative-present>
			<p><i>e</i></p>
			<p><i>ons</i></p>
			<p><i>ez</i></p>
		</imperative-present>
	</imperative>
	<participle>
		<present-participle>
			<p><i>ant</i></p>
		</present-participle>
		<past-participle>
			<p><i>é</i></p>
			<p><i>és</i></p>
			<p><i>ée</i></p>
			<p><i>ées</i></p>
		</past-participle>
	</participle>
</template>
```

Damit können die Konjugationstabellen auch angezeigt werden.

Die Aussprache wird nicht generiert, sondern wird über Wiktionary-Daten ermittelt.
[kaikki.org](kaikki.org) bietet bereits pre-processed JSON-Dateien an, die Links zur Aussprache enthalten, siehe z. B. [hier](https://kaikki.org/dewiktionary/rawdata.html).

```json
{
  "word": "kaufen",
  "pos": "verb",
  "pos_title": "Verb",
  "lang_code": "de",
  "lang": "Deutsch",
  "senses": [
    {
      "glosses": [
        "Ware gegen Entgelt erwerben"
      ],
      "examples": [
        {
          "text": "Wenn ich einmal groß bin, kaufe ich mir ein Auto.",
          "bold_text_offsets": [
            [
              26,
              31
            ]
          ]
        },
        {
          "text": "„Alltägliche Nahrungsmittel, die Impfstoffe oder andere medizinisch wirksame Zusatzstoffe enthalten, gibt es zwar noch nicht zu kaufen, sie sind aber schon Gegenstand der Forschung.“",
          "bold_text_offsets": [
            [
              128,
              135
            ]
          ],
          "ref": "wissen.de – Bildwörterbuch „Lebensmittel- und Biotechnologie: Mehr als Käse und Bier“"
        }
      ],
      "sense_index": "1"
    },
    {
      "glosses": [
        "ein Verpflichtungsgeschäft zum Erwerb eines Gegenstands eingehen, das von dem Erfüllungsgeschäft (Übertragung des Eigentums) zu unterscheiden ist."
      ],
      "examples": [
        {
          "text": "Pjotr Ekhahn kaufte einen grünen Ford vom Gebrauchtwagenhändler Hompka mit der Maßgabe, dass die Übereignung desselben nach Zahlung des vollständigen Kaufpreises am darauffolgenden Montag erfolgen sollte.",
          "bold_text_offsets": [
            [
              13,
              19
            ]
          ]
        }
      ],
      "sense_index": "2",
      "topics": [
        "law"
      ]
    },
    {
      "glosses": [
        "eine Person unter Druck setzen, ernsthaft mit ihr diskutieren"
      ],
      "raw_tags": [
        "bei Meinungsverschiedenheiten"
      ],
      "tags": [
        "transitive"
      ],
      "examples": [
        {
          "text": "Pjotr gab an, sich den Hompka bei nächster Gelegenheit wegen des fehlgeschlagenen Autogeschäfts einmal kaufen zu wollen.",
          "bold_text_offsets": [
            [
              103,
              109
            ]
          ]
        }
      ],
      "sense_index": "3"
    },
    {
      "glosses": [
        "eine Person bestechen"
      ],
      "tags": [
        "transitive"
      ],
      "examples": [
        {
          "text": "Nach Presseangaben war der Schiedsrichter in dem Spiel am Gründonnerstag von der Wettmafia gekauft.",
          "bold_text_offsets": [
            [
              91,
              99
            ]
          ]
        }
      ],
      "sense_index": "4"
    }
  ],
  "translations": [
    {
      "sense": "Ware gegen Entgelt erwerben",
      "word": "san",
      "lang_code": "bm",
      "lang": "Bambara",
      "sense_index": "1"
    },
  ],
  "sounds": [
    {
      "ipa": "[ˈkaʊ̯fn̩]"
    },
    {
      "ipa": "[ˈkaʊ̯fm̩]"
    },
    {
      "audio": "De-kaufen.ogg",
      "ogg_url": "https://commons.wikimedia.org/wiki/Special:FilePath/De-kaufen.ogg",
      "mp3_url": "https://upload.wikimedia.org/wikipedia/commons/transcoded/4/42/De-kaufen.ogg/De-kaufen.ogg.mp3"
    },
    {
      "audio": "De-kaufen2.ogg",
      "ogg_url": "https://commons.wikimedia.org/wiki/Special:FilePath/De-kaufen2.ogg",
      "mp3_url": "https://upload.wikimedia.org/wikipedia/commons/transcoded/e/e1/De-kaufen2.ogg/De-kaufen2.ogg.mp3"
    },
    {
      "audio": "De-at-kaufen.ogg",
      "ogg_url": "https://commons.wikimedia.org/wiki/Special:FilePath/De-at-kaufen.ogg",
      "mp3_url": "https://upload.wikimedia.org/wikipedia/commons/transcoded/c/c5/De-at-kaufen.ogg/De-at-kaufen.ogg.mp3",
      "tags": [
        "Austrian German"
      ]
    },
    {
      "rhymes": "aʊ̯fn̩"
    }
  ],
  "antonyms": [
    {
      "word": "stehlen",
      "sense_index": "1"
    },
    {
      "word": "verkaufen",
      "sense_index": "1"
    }
  ],
  "derived": [
    {
      "word": "Kauf"
    },
    {
      "word": "Kaufanreiz"
    },
    {
      "word": "Kaufempfehlung"
    },
  ],
  "expressions": [
    {
      "word": "die Katze im Sack kaufen",
      "note": "etwas unbesehen, ungeprüft kaufen"
    }
  ],
  "synonyms": [
    {
      "word": "anschaffen",
      "sense_index": "1"
    },
    {
      "word": "erstehen",
      "sense_index": "1"
    },
  ],
  "categories": [
    "Anagramm sortiert (Deutsch)",
    "Deutsch",
    "Einträge mit Endreim (Deutsch)",
    "Grundformeintrag (Deutsch)",
    "Roter Audiolink",
    "Rückläufige Wörterliste (Deutsch)",
    "Rückläufige Wörterliste Grundformeintrag (Deutsch)",
    "Verb (Deutsch)",
    "Wiktionary:Audio-Datei",
    "siehe auch"
  ],
  "etymology_texts": [
    "mittelhochdeutsch koufen, althochdeutsch koufōn, germanisch *kaup-ō- „kaufen“, belegt seit dem 8. Jahrhundert"
  ],
  "forms": [
    {
      "form": "kaufe",
      "tags": [
        "present"
      ],
      "pronouns": [
        "ich"
      ]
    },
    {
      "form": "kaufst",
      "tags": [
        "present"
      ],
      "pronouns": [
        "du"
      ]
    },
    {
      "form": "kauft",
      "tags": [
        "present"
      ],
      "pronouns": [
        "er",
        "sie",
        "es"
      ]
    },
    {
      "form": "kaufte",
      "tags": [
        "past"
      ],
      "pronouns": [
        "ich"
      ]
    },
    {
      "form": "kaufte",
      "tags": [
        "subjunctive-ii"
      ],
      "pronouns": [
        "ich"
      ]
    },
    {
      "form": "kauf!",
      "tags": [
        "imperative",
        "singular"
      ]
    },
    {
      "form": "kauft!",
      "tags": [
        "imperative",
        "plural"
      ]
    },
    {
      "form": "gekauft",
      "tags": [
        "participle-2",
        "perfect"
      ]
    },
    {
      "form": "haben",
      "tags": [
        "auxiliary",
        "perfect"
      ]
    },
    {
      "form": "kaufen",
      "tags": [
        "active",
        "infinitive",
        "present"
      ],
      "raw_tags": [
        "Infinitive und Partizipien"
      ],
      "source": "Flexion:kaufen"
    },
    {
      "form": "gekauft haben",
      "tags": [
        "active",
        "infinitive",
        "perfect"
      ],
      "raw_tags": [
        "Infinitive und Partizipien"
      ],
      "source": "Flexion:kaufen"
    },
    {
      "form": "gekauft werden",
      "tags": [
        "processual-passive",
        "infinitive",
        "present"
      ],
      "raw_tags": [
        "Infinitive und Partizipien"
      ],
      "source": "Flexion:kaufen"
    },
    {
      "form": "sie würden gekauft gewesen sein",
      "tags": [
        "third-person",
        "plural",
        "future-ii",
        "statal-passive",
        "subjunctive-ii"
      ],
      "raw_tags": [
        "Finite Formen",
        "Indikativ und Konjunktiv"
      ],
      "source": "Flexion:kaufen"
    }
  ],
  "hyphenations": [
    {
      "parts": [
        "kau",
        "fen"
      ]
    }
  ]
}
```

Beachte, dass ein Wiktionary einer Sprache auch Einträge für andere Sprachen enthält. Lediglich die Erklärungen sind in der jeweils definierten Sprache.

> **Informationen, die aus dieser JSON herausgelesen werden können:**
> * Übersetzung in verschiedene Sprachen
> * Antonyme
> * Aussprache-Links
> * Wortfamilie, z.B. "verkaufen", "ankaufen", "erkaufen" bei Eintrag "kaufen"
> * Synonyme
> * Bedeutung mit ...
> 	* Beispielsätzen
>    * Topics-Tag
>   * Position des Wortes in Beispielsätzen
> * Konjugationsdaten
> * Silbentrennung

Zudem zeigt sich, dass ein Wort mehrere Aussprachen liefern kann.
Diese Unterscheiden sich in dem obigen Beispiel kaum. In der App sollte nur die erste Aussprache angezeigt werden.

### Generierung des App-Wörterbuches
Folgende Informationen soll das App-Wörterbuch enthalten pro Eintrag:

> Die Ziel- und Ausgangssprache wird dynamisch gesetzt.
> Die Suche des Nutzers entspricht immer der Ausgangssprache.

* Wort in Ausgangssprache
* Genus aus FreeDict
* Pluralform 
* IPA in Ausgangssprache
* grammatikalische Gruppe (z.B. Verb)
* Bedeutungen in Zielsprache
	* Erklärung der Bedeutung in Zielsprache
* IPA in Zielsprache
* Hilfsverb
* Template
* Antonyme
* Synonyme
* Aussprache-Link (kein Plural)
* Silbentrennung

Die Konjugationen der Zwillingsverben wird in eine eigene DB-Tabelle überführt.

Ein App-Wörterbuch wird aus den oben genannten Dateien zusammengeführt und als SQLite-Datei bereitgestellt.
Das Wörterbuch muss von dem Nutzer nachträglich installiert werden.

#### Genus
Der Genus kann dem FreeDict ausgelesen werden unter `gramGrp/gen`:
```xml
<gramGrp>
    <pos>n</pos>
    <gen>fem</gen>
</gramGrp>
```

#### Pluralform
Die Pluralform ist in Wikiextract unter `forms` zu finden:

```json
{
  "form": "chevaux",
  "tags": [
    "plural"
  ],
  "ipas": [
    "\\ʃə.vo\\",
	"\\ʃfo\\"
  ]
},
```

#### Aussprache-Link
Es kann mehrere Aussprachedateien zu einer Vokabel geben.
Anhand des Namens soll die zentrale Aussprachedatei gefunden werden.
Bei dem obigen Beispiel (`De-kaufen.ogg`, `De-kaufen2.ogg` und `De-at-kaufen.ogg`) soll `De-kaufen.ogg` gewählt werden.
Eine Analyse der Datengrundlage ist nötig, um zu ermitteln, ob es Wörter gibt, die nicht der Regel `<lang-code>-<word>.ogg` folgen.
Es soll auf die MP3-Datei verwiesen werden.

#### Hilfsverb
Das Hilfsverb kann aus Wikiextract ausgelesen werden. Dieses ist unter `forms` zu finden:

```json
  "forms": [
    {
      "form": "avoir lu",
      "tags": [
        "infinitive",
        "past"
      ],
      "ipas": [
        "\\a.vwaʁ ly\\"
      ],
      "source": "Conjugaison:français/lire"
    },
  ],
```
Dabei muss das Hilfsverb über die Tags ermittelt werden (`infinitive`, `past`).
Das Hilfsverb ist das erste Wort in `form` unter dem obigen Filter.

### Wörterbuchgenerierung
Das Wörterbuch wird aus den obigen Inhalten ermittelt. Dabei soll FreeDict als Ausgang genutzt werden, da es de Quelle mit dem kleinsten Inhalt darstellt.
Aus einem FreeDict-Eintrag sollen folgende Informationen direkt übernommen werden:
* Wort in Ausgangssprache
* Genus aus FreeDict
* Pluralform 
* IPA in Ausgangssprache
* grammatikalische Gruppe (z.B. Verb)
* Bedeutungen in Zielsprache
	* Erklärung der Bedeutung des Wortes der Zielsprache in der Ausgangssprache
* IPA in Zielsprache

Mittels Verbiste sollen die Konjugationen ermittelt werden. Dazu zählt auch das Template.
Beachte, dass Konjugationen nur verfügbar sind für die Zielsprache FR.

> Überlegung: Für die Flexionsformerkennung müssen alle Konjugationen bereits vorberechnet vorliegen, da Zurückrechnen nicht möglich ist.
> Damit könnte im Umkehrschluss die Konjugation direkt in der Tabelle gesetzt werden.
> Eine dynamische Bestimmung der Konjugation ist damit nicht mehr in der App nötig.

Die sonstigen Inhalte werden über Wiktionary-Daten ermittelt.

Ein App-Wörterbuch wird aus den oben genannten Dateien zusammengeführt und als SQLite-Datei bereitgestellt.
Das Wörterbuch muss von dem Nutzer nachträglich installiert werden.

## Datenproblemanalyse
* Haben alle Nomen ein Genus (FreeDict)?
* Wie hoch ist der Anteil von Verben ohne Konjugationszuordnung?
* Gibt es Wörter mit Audiodateien ohne eine Audiodatei, die der Regel `<lang-code>-<word>.ogg` folgt?
* Ist ein Hilfsverb bei jedem Verb eindeutig ermittelbar?

## Flexionsformenerkennung
Sucht der Nutzer nach `gekauft` anstatt `kaufen` kann mit einer einfachen Suche kein Treffer gefunden werden.
Aus diesem Grund soll eine Flexionsformenerkennung hinzugefügt werden. Diese weist jeder Flexionsform ein Lemmata zu.
Diese können aus Verbiste erstellt werden.



## Nutzeroberfläche