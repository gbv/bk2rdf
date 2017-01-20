#!/usr/bin/env perl
use strict;
use v5.14;
use Catmandu -all;

my $exporter = exporter('MARC', type => 'XML', pretty => 1);

foreach my $file (@ARGV) {
    importer('MARC', type => 'XML', file => $file)->each(sub { $exporter->add(shift) });
}

$exporter->commit;

