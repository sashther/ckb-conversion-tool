#!/usr/bin/perl

use strict;
use warnings;
use utf8;

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

while (<STDIN>) {
	chomp;
	# literal characters
	# s/X/Y/g;
	# by Unicode code points
	# s/\x{2018}/\x{02BB}/g;
	print "$_\n";
}

exit 0;
