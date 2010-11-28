#!/usr/bin/env perl5
use strict;
use warnings;

use Test::More tests => 14;
use CGI::Struct;

# Test dotted forms

my %inp = (
	# Single-level
	'h.foo' => 'hashfoo',
	'h.bar' => 'hashbar',

	# In an array
	'a[0].foo' => 'a0_foo',
	'a[0].bar' => 'a0_bar',

	# or a hash
	'h2{x}.foo' => 'h2_x_foo',
	'h2{x}.bar' => 'h2_x_bar',

	# or a hash of arrays
	'h2{y}[1].foo' => 'h2_y_1_foo',
	'h2{y}[1].bar' => 'h2_y_1_bar',

	# or a hash of arrays of hashes.  Sheesh.
	'h2{y}[2]{z}.foo' => 'h2_y_2_z_foo',
	'h2{y}[2]{z}.bar' => 'h2_y_2_z_bar',

	# And in the middle
	'h2.{z}.foo{a}' => 'h2_z_foo_a',
	'h2.{z}.bar{a}' => 'h2_z_bar_a',
	'h2.{zz}.foo[1]' => 'h2_zz_foo_1',
	'h2.{zz}.bar[1]' => 'h2_zz_bar_1',
);
my $hval = build_cgi_struct \%inp;

for my $k (qw/foo bar/)
{
	is($hval->{h}{$k}, $inp{"h.$k"}, "h.$k copied right");
	is($hval->{a}[0]{$k}, $inp{"a[0].$k"}, "a[0].$k copied right");
	is($hval->{h2}{x}{$k}, $inp{"h2{x}.$k"}, "h2{x}.$k copied right");
	is($hval->{h2}{y}[1]{$k}, $inp{"h2{y}[1].$k"},
	   "h2{y}[1].$k copied right");
	is($hval->{h2}{y}[2]{z}{$k}, $inp{"h2{y}[2]{z}.$k"},
	   "h2{y}[2]{z}.$k copied right");
	is($hval->{h2}{z}{$k}{a}, $inp{"h2{z}.${k}{a}"},
	   "h2{z}.${k}{a} copied right");
	is($hval->{h2}{zz}{$k}[1], $inp{"h2{zz}.${k}[1]"},
	   "h2{z}.${k}[1] copied right");
}

