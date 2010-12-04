#!/usr/bin/env perl5
use strict;
use warnings;

use Test::More tests => 4;
use CGI::Struct;

# Test that a simple array gets built right

my %inp = (
	'a[0]' => 'arr0',
	'a[1]' => 'arr1',
	'a[2]' => 'arr2',
);
my @errs;
my $hval = build_cgi_struct \%inp, \@errs;

is(@errs, 0, "No errors");
is($hval->{a}[$_], $inp{"a[$_]"}, "a[$_] copied right") for 0..2;
