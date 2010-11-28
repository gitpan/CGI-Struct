#!/usr/bin/env perl5
use strict;
use warnings;

use Test::More tests => 12;
use CGI::Struct;

# Test various bad inputs

my %inp = (
	# Mismatched delims
	'h{foo]' => 'hashfoo',
	'a[0}'   => 'arr0',

	# Missing delim
	'h{bar'  => 'hbar',

	# Multiple delims in a row
	'h{{{}'  => 'wtf',

	# Non-integer array key
	'a[bar]' => 'arrbar',
	'a[0bar]' => 'arr0bar',

	# Bad starting char
	'{xyz'  => 'badstart',

	# No key
	'h{}'   => 'nokey',
	'h.'    => 'dot nokey',
	'h..'   => 'dot dot nokey',
	'h{foo}.{bar}' => 'nested dot nokey',

	# Create a mismatch
	'm{xyz}' => 'mhash',
	'm[1]'   => 'marr',
);
my @errs;
my $hval = build_cgi_struct \%inp, \@errs;

# Should have a warning about the mismatches
ok(grep(/ender for { in foo]/, @errs), "Got error for h{foo]");
ok(grep(/ender for \[ in 0}/, @errs), "Got error for a[0}");

# And the missing
ok(grep(/ender for { in bar/, @errs), "Got error for h{bar");

# Multiple?
ok(grep(/ender for { in  for h{{{}/, @errs), "Got error for h{{{}");

# Plus the non-integer keys
ok(grep(/should be a number, not bar in a\[bar]/, @errs),
   "Got error for a[bar]");
ok(grep(/should be a number, not 0bar in a\[0bar]/, @errs),
   "Got error for a[0bar]");

# Bad starting char
ok(grep(/unexpected initial char in {xyz/, @errs),
   "Got error for {xyz");

# No key
ok(grep(/Zero-length name element found in h{}/, @errs),
   "Got error for h{}");
ok(grep(/Zero-length name element found in h./, @errs),
   "Got error for h.");
ok(grep(/Zero-length name element found in h../, @errs),
   "Got error for h..");
ok(grep(/Zero-length name element found in h{foo}.{bar}/, @errs),
   "Got error for h{foo}.{bar}");

# This mismatch could come in either order
ok(grep(/already have [A-Z]+, expecting [a-z]+ for (1|xyz) in m{xyz}/,
        @errs),
   "Got error for m{xyz}");
