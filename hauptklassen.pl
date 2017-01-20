#!/usr/bin/env perl
use strict;
use v5.14;
use Catmandu -all;
use MARC::Spec;

# Create MARCXML classification records for 
# Basiklassifikation categories and main classes

my $date = '******';
my $exporter = exporter('MARC', type => 'XML', pretty => 1);

my $category;

importer('CSV', file => 'hauptklassen.csv')->each(sub{
    my $notation = $_[0]->{notation};
    my $caption  = $_[0]->{caption};
    my @broader  = (e => $category);

    return if $notation eq '';

    if ($notation !~ /^\d\d$/) {
        $category = $notation;
        @broader = ();
    }

    $exporter->add({
        record => [
            ['LDR', undef, undef, '_', '*****nw' ],
            ['008', undef, undef, '_', $date.'ananaana' ],
            ['040', ' ', ' ', a => 'DE-601', b => 'ger' ],
            ['084', '0', ' ', a => 'bkl', e => 'ger', q => 'DE-601' ],
            ['153', ' ', ' ', a => $notation, @broader, j => $caption],
        ]
    });
});

$exporter->commit;
