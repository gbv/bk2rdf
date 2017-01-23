rdf: bk.ttl bk.json bk.ndjson

hauptklassen.xml: hauptklassen.csv
	perl hauptklassen.pl > $@

unterklassen.xml:
	perl unterklassen.pl > $@

bk.xml: hauptklassen.xml unterklassen.xml
	perl merge.pl $? > $@

MC2SKOS_OPTIONS=--indexterms --notes

bk.ttl: bk.xml
	mc2skos -o turtle $(MC2SKOS_OPTIONS) $< $@

bk.json: bk.xml
	mc2skos -o jskos $(MC2SKOS_OPTIONS) $< $@

bk.ndjson: bk.xml
	mc2skos -o ndjson $(MC2SKOS_OPTIONS) $< $@

install:
	cpanm --installdeps .
