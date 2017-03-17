# Basisklassikation in RDF

Die Basisiklassifikation (BK) ist eine monohierarchische Dezimalklassifikation,
die im Gemeinsamen Bibliotheksverbund (GBV) verwendet wird. Sie basiert auf der
Nederlandse Basisclassificatie (NBC) und besteht aus 5 Bereichen mit 48
Hauptklassen und 2086 Unterklassen (Stand 2014) in mehreren Hierarchieebenen.

Die Basisklassifikation wird von der [Zentralredaktion Sacherschließung]
gepflegt und im Verbundkatalog des GBV (GVK) verwaltet. Die Daten sind unter
[CC0] frei verfügbar. Um die ursprünglich im PICA-Format vorliegenden
Datensätzen nach RDF zu konvertieren besteht folgender Workflow:

* Die BK-Datensätze lassen sich im Format [MARC 21 Classification] (MARCXML)
  aus dem GVK per SRU abrufen (`pica.tbs=kb and pica.mak=Tkv`).

* Die abgerufenen Datensätze müssen noch um hierarchische Verknüpfungen ergänzt
  werden, da diese nur Indirekt in Kategorie angegeben sind.

      $ make unterklassen.xml

* Da für Hauptklassen und Bereiche keine eigenen Datensätze vorhanden sind,
  werden für diese Dummy-Datensätze in MARCXML erstellt:
  
      $ make hauptklassen.xml

* Die gesamten MARCXML-Datensätze werden anschließend mit [mc2skos] nach RDF
  konvertiert wobei die Formate RDF/Turtle und JSKOS angeboten werden.

      $ make rdf

## Weitere Informationen zur Basisklassifikation

* [Wikipedia-Artikel zur BK](https://de.wikipedia.org/wiki/Basisklassifikation)
* [Informationen des GBV zur Erschließung mit der BK](https://www.gbv.de/bibliotheken/verbundbibliotheken/02Verbund/01Erschliessung/05Sacherschliessung/05Sacherschliessung_4289)
* [BK in BARTOC](http://bartoc.org/en/node/745)


[Zentralredaktion Sacherschließung]: https://www.sub.uni-goettingen.de/kontakt/abteilungen-a-z/abteilungs-und-gruppendetails/abteilunggruppe/zentralredaktion-sacherschliessung/

[CC0]: https://creativecommons.org/publicdomain/zero/1.0/deed.de

[MARC 21 Classification]: http://www.loc.gov/marc/classification/

[mc2skos]: https://pypi.python.org/pypi/mc2skos

