#!/usr/bin/env perl5
use strict;
use warnings;

use Test::More tests => 3;
use CGI::Struct;

# Test that a simple hash gets built right

my %inp = (
	'h{foo}' => 'hashfoo',
	'h{bar}' => 'hashbar',
	'h{baz}' => 'hashbaz',
);
my $hval = build_cgi_struct \%inp;

is($hval->{h}{$_}, $inp{"h{$_}"}, "h{$_} copied right") for qw/foo bar baz/;
