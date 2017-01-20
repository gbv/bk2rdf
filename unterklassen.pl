#!/usr/bin/env perl
use strict;
use v5.14;
use LWP::Simple;
use Catmandu -all;
use Catmandu::Fix::marc_map as => 'marc_map';
use Catmandu::Exporter::MARC;

sub log { say STDERR @_ }

my $exporter = exporter('MARC', type => 'XML', pretty => 1);

# get all BK records via SRU
my $importer = importer('SRU', 
    base => 'http://sru.gbv.de/gsocat',
    query => 'pica.tbs=kb and pica.mak=Tkv',
    recordSchema => 'marcxml',
    parser => 'marcxml',
);

log $importer->url;

my $records = $importer->map(sub{
    my $marc = shift;

    # Fix MARC field 008 as documented at
    # http://www.loc.gov/marc/classification/concise/cd008.html
    for my $field (@{$marc->{record}}) {
        $field->[4] =~ s/\|/a/g if $field->[0] eq '008';
    }

    marc_map($marc, '153a', 'notation');
    marc_map($marc, '900a', 'level');

    return $marc;
})->to_array(); 

# Add hierarchy in MARC 153 $e
my @stack;
foreach my $marc (sort { $a->{notation} <=> $b->{notation} } @$records) {
    my $notation = $marc->{notation};

    my $ppn = $marc->{_id};

    unless ($marc->{level} =~ /^00(\d)J$/) {
        warn "Missing level in record $ppn ($notation) - ignoring record!\n";
        next;
    }
    my $level = $1;

    shift @stack while ($level < @stack);
    if ($level > @stack + 1) {
        say STDERR "Hierarachic gap: " . 
                   join(" > ",reverse @stack, '...', $notation);
    }
    unshift @stack, $notation;

    my $broader = @stack > 1 ? $stack[1] : substr($notation, 0, 2);

    #log("$notation " . scalar(@stack) . " < $broader");

    my ($f153) = grep { $_->[0] eq '153' } @{$marc->{record}};
    my @rest = splice @$f153, 5;
    pop @$f153 while @$f153 > 5;
    push @$f153, e => $broader, @rest;

    $exporter->add($marc);
}

$exporter->commit;
log $exporter->count . " records.";
