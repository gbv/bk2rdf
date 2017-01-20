rdf: bk.ttl bk.json bk.ndjson

hauptklassen.xml: hauptklassen.csv
	perl hauptklassen.pl > $@

unterklassen.xml:
	perl unterklassen.pl > $@

bk.xml: hauptklassen.xml unterklassen.xml
	perl merge.pl $? > $@

bk.ttl: bk.xml
	mc2skos -o turtle $< $@

bk.json: bk.xml
	mc2skos -o jskos $< $@

bk.ndjson: bk.xml
	mc2skos -o ndjson $< $@

install:
	cpanm --installdeps .
