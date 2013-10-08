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
	s/\x{062B}/\x{067E}/g;
	s/\x{0636}/\x{0686}/g;
	s/\x{0631}\x{0650}+/\x{0695}/g;
	s/\x{0631}\x{064D}+/\x{0695}/g;
	s/\x{0695}\x{0650}+/\x{0695}/g;
	s/\x{0630}/\x{0698}/g;
	s/\x{0638}/\x{06A4}/g;
	s/\x{0637}/\x{06AF}/g;
	s/\x{0644}\x{064E}+/\x{06B5}/g;
	s/\x{0644}\x{064B}+/\x{06B5}/g;
	s/\x{064E}\x{0644}/\x{06B5}/g;
	s/\x{0644}\x{0623}+/\x{06B5}\x{200C}/g;
	s/\x{0644}\x{0622}+/\x{06B5}\x{0627}/g;
	s/\x{0644}\x{0627}\x{064E}+/\x{06B5}\x{0627}/g;
	s/\x{0622}/\x{06CE}\x{200C}/g;
	s/\x{0649}\x{064E}+/\x{06CE}\x{200C}/g;
	s/\x{064A}\x{064E}+/\x{06CE}/g;
	s/\x{06CC}\x{0640}\x{064E}+/\x{06CE}/g;
	s/\x{06CC}\x{064B}+/\x{06CE}/g;
	s/\x{06CC}\x{064E}+/\x{06CE}/g;
	s/\x{064A}/\x{06CC}/g;
	s/\x{0649}/\x{06CC}\x{200C}/g;
	s/\x{0624}/\x{06C6}/g;
	s/\x{0648}\x{064E}+/\x{06C6}/g;
	s/\x{0676}/\x{06C6}/g;

	print "$_\n";
}

exit 0;
