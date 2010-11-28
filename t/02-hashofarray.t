#!/usr/bin/env perl5
use strict;
use warnings;

use Test::More tests => 8;
use CGI::Struct;

# Test hashes of arrays

my %inp = (
	'h{friends}[0]' => 'james',
	'h{friends}[1]' => 'jill',
	'h{friends}[2]' => 'joe',
	'h{friends}[3]' => 'judy',
	'h{enemies}[0]' => 'bianca',
	'h{enemies}[1]' => 'bill',
	'h{enemies}[2]' => 'bob',
	'h{enemies}[3]' => 'brenda',
);
my $hval = build_cgi_struct \%inp;

for my $k (qw/friends enemies/)
{
	is($hval->{h}{$k}[$_], $inp{"h{$k}[$_]"},
	   "h{$k}[$_] copied right") for 0..3;
}
