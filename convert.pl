#!/usr/bin/perl

use strict;
use warnings;
use utf8;

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

#
# OPTIONS
#
	
# The font or character mapping of the input text
# 0: Ali-K, 1: Ali-K web, 2: Dilan.
my $fontIn = 0;

# Standardize (or stay close to rendering)?
# 0: Retain (some) chars where they might have a visual effect.
# 1: Remove non-standard/unneccessary format chars etc. in many places
# (ZWNJ, ZWJ and Tatweel and more).
my $standardize = 1;

# Normalize extended Arabic-Indic digits?
# 0: No
# 1: Yes (4 and 6 are skipped as they look different)
my $convDigits = 1;

# Do minor ortographical checking?
# Initial Reh => thick Reh and initial double Waw => one Waw.
# 0: No
# 1: Yes
my $orthCheck = 1;

# Fix spacing a bit? (before and after some punctuation marks)
# 0: No
# 1: Yes.
my $fixSpacing = 1;

# Char(s) to output hehs with
# 0: Heh+Tatweel at end of words, heh otherwise (standard)
# 1: Heh Doachashmee
my $hehOut = 0;
	
#
# GENERAL REGEXES
#
	
my $b = '[^\p{IsArabic}\p{Mn}\p{Cf}\x{0640}]'; # Word boundary
my $b2 = '[^\p{IsArabic}\p{Mn}\p{Cf}]'; # Word boundary variant
my $treatAsZWNJ = "\x{200E}\x{200F}\x{2028}-\x{202F}\x{2060}\x{FEFF}";
my $nonJoiningLetters =	"\x{0627}\x{062F}\x{0631}\x{0632}\x{0648}"
	 . "\x{0695}\x{0698}\x{06C6}\x{06D5}"; # Non-joining initially
my $joiningLetters = "\x{0628}\x{062A}\x{062D}\x{062E}\x{0633}\x{0634}"
	 . "\x{0639}\x{063A}\x{0641}\x{0642}\x{0643}\x{0644}\x{0645}\x{0646}"
	 . "\x{0647}\x{067E}\x{0686}\x{06A4}\x{06A9}\x{06AF}\x{06B5}\x{06BE}"
	 . "\x{06CC}\x{06CE}";
	
# Transform in Arial when preceded by joining character (varies by font).
my $transJoiningLetters = "\x{0626}\x{0627}\x{062C}\x{062D}\x{062E}"
	 . "\x{0639}\x{063A}\x{0647}\x{0686}\x{06A9}\x{06AF}\x{06BE}\x{06CC}"
	 . "\x{06CE}\x{06D5}"; 
	
my $tempHamza = "#h4mz4#"; # Temp char to use for intentional Hamzas
	
# Temp char to use for "beginning of line", must match /^(?=[\s\r\n])/
# when added. Perl does not allow variable look-behinds, which is needed to
# find some bad word boundaries. As a compromise we add this extra step,
# skip the variable look-behinds and later revert the changes.
# $tempCaret must not occur in the original text!
my $tempCaret = "\x{2003}";

# Format chars to clean up
my $cfToClean =
	  '(?<=[^\p{IsArabic}\p{Cf}\p{Mn}])(?:[\x{200D}\x{200C}]*\x{200C}|[\x{200D}\x{200C}]*\x{200D}+(?![\p{Mn}\x{200D}]*[$transJoiningLetters]))'
	. '|(?<=[^\p{IsArabic}\p{Cf}\p{Mn}]\p{Mn})(?:[\x{200D}\x{200C}]*\x{200C}|[\x{200D}\x{200C}]*\x{200D}+(?![\p{Mn}\x{200D}]*[$transJoiningLetters]))' # Above one + diacritic
	. '|(?<!\x{0647})\x{200C}([\x{200C}\x{200D}]*\x{200C})?(?=\p{Mn}*[^\p{IsArabic}\p{Cf}\p{Mn}\x{0640}]|$)'
	. '|(?<=[$joiningLetters])\x{200D}+(?=[\p{IsArabic}\x{0640}])'
	. '|(?<=[^$joiningLetters])\x{200D}+(?![$transJoiningLetters])'
	. '|(?<=[$nonJoiningLetters])\x{200C}(?:[\x{200C}\x{200D}]*\x{200C})?'
	. '|(?<=[$nonJoiningLetters]\p{Mn})\x{200C}(?:[\x{200C}\x{200D}]*\x{200C})?'; # Above one + diacritic

while (<STDIN>) {
	chomp;
	
	#
	# CONVERSION BEGIN
	# The full names of all letters are "Arabic letter XXX",
	# the first part of the name is implied from here on.
	#
	
	# Remove these after ending hehs so heh+ZWNJ isn't matched as Ae later.
	s/(?<=\x{0647})[$treatAsZWNJ]+\p{Cf}*(?=$b|$)//g;
	
	# Convert format chars other than ZWNJ/ZWJ
	# These often have the same effect as ZWNJ because of the context.
	s/[$treatAsZWNJ]+/\x{200C}/g;
	
	# Clean format characters where they have no effect
	s/$cfToClean//g;
	
	if ($fontIn == 1) { # Ali-K web conversion
		s/\x{0635}/\x{06CE}/g;
		s/\x{0623}/\x{0695}/g;
		s/(?<!\x{0644})\x{0622}/\x{2731}/g;
		s/\x{0644}\x{0623}/\x{0644}\x{0695}/g;
		s/\x{0625}//g;
	} elsif ($fontIn == 2) { # Dilan conversion. Not finished!
		s/\x{0635}/\x{06B5}/g;
		s/\x{062B}/\x{06CE}/g;
		s/\x{0630}/\x{0695}/g;
		s/(?<!\x{0644})\x{0622}/\x{0627}/g;
	}
				
	# Lam with small v. 0644 064E renders as such, the rest are slightly
	# different and rare variations that are sometimes used.
	s/[\x{0644}\x{06B5}]\x{0640}*[\x{064B}\x{064E}\x{0651}]+/\x{06B5}/g;
	
	# Lam with small v + Alef
	s/\x{0644}(?:\x{0622}|\x{0627}\x{064E}+)/\x{06B5}\x{0627}/g;
	if ($standardize) {
		s/\x{0644}\x{0623}/\x{06B5}/g; # Lam with small v + Alef
		s/\x{0622}|\x{0649}\x{064E}+/\x{06CE}/g; # Yeh with small v
		s/\x{0649}/\x{06CC}/g; # Farsi Yeh
	} else {
		s/\x{0644}\x{0623}/\x{06B5}\x{200C}/g; # Lam with small v + Alef
		s/\x{0622}|\x{0649}\x{064E}+/\x{06CE}\x{200C}/g; # Yeh with small v
		s/\x{0649}/\x{06CC}\x{200C}/g; # Farsi Yeh
	}
	
	# Yeh with small v
	s/[\x{064A}\x{06CC}]\x{0640}*\x{064E}+|[\x{06CC}\x{06CE}][\x{064B}\x{064E}\x{0651}]+/\x{06CE}/gx;

	s/\x{064A}/\x{06CC}/g; # Farsi Yeh

	# Kafs
	if ($standardize) { # Kaf -> Keheh
		s/\x{0643}/\x{06A9}/g;
	} else { # initial/medial Kaf -> Keheh
		s/\x{0643}(?!\p{Mn}*\x{200C}|\p{Mn}*(?:$b|$))/\x{06A9}/g;
	}
	if($fontIn != 2) { # Skips for Dilan font
		s/\x{0637}/\x{06AF}/g; # Gaf
		s/\x{0638}/\x{06A4}/g; # Veh
	}
	s/\x{062B}/\x{067E}/g; # Peh
	s/\x{0636}/\x{0686}/g; # Tcheh
	s/\x{0630}/\x{0698}/g; # Jeh
	
	# Oe. 0624, 0648 064E and 0621 064E render as such, the rest are rare.
	s/[\x{0624}\x{0676}]|[\x{0648}\x{06C6}][\x{064B}\x{064E}]+|\x{0621}\x{064E}+(?!\p{Mn}*(?:$b|$))/\x{06C6}/g;
	
	# Reh with small v below. 0631 0650 renders as such, the rest are rare.
	s/[\x{0631}\x{0695}][\x{064D}\x{0650}]+|\x{0650}+\x{0631}|[\x{064D}\x{0650}]+\x{0695}/\x{0695}/g;

	# Reduces multiples of the same diacritic or other ZW chars to one occurance.
	s/([\p{Mn}\p{Cf}])\1+/$1/g;
	s/(?<!\p{Cf})(\p{Cf})\p{Cf}+(?<!\u200D)/$1/g;
	s/(?<!\p{Cf})(\p{Cf})\p{Cf}*\1/$1/g;
	
	# Temporary replacement since variable look-behinds aren't supported,
	# \r\n written explicitly since I'm not about \s in Perl.
	s/^([^\s\r\n])/$tempCaret$1/g;
	
	# Clean format chars where they have no effect
	s/$cfToClean//g;
	
	if ($standardize) {
	 	# Heh + final Tatweel/ZWJ -> Heh Doachashmee.
		s/\x{0647}[\x{200D}\x{0640}]+(?=[\p{Mn}\x{0640}]*(?:$b|$))/\x{06BE}/g;
		# Remove Tatweels in words, 
		s/(?:	(?<=\p{IsArabic})
			|(?<=\p{IsArabic}[\p{Mn}\p{Cf}])
			|(?<=\p{IsArabic}[\p{Mn}\p{Cf}\x{0640}][\p{Mn}\p{Cf}])
		)\x{0640}+(?:\p{Cf}+\x{0640}+)*
		|\x{0640}+(?:\p{Cf}+\x{0640}+)*(?=[\p{Mn}\p{Cf}\x{0640}]*[\p{IsArabic}\p{Mn}])
		//gx;
	} else {
		# Heh + final Tatweel/ZWJ -> Heh Doachashmee while keeping the Tatweels.
		s/\x{0647}(?=[\x{200D}\x{0640}])\x{200D}*(\x{0640}*)\x{200D}*(?=[u200D\x{0640}]*(?:$b|$))/\x{06BE}$1/g;
	}
		
	# Final Heh in rare words (behbeh, beh beh, ah, oh, gunah and heh) -> Heh doachashmee.
	s/	(
			(?<=$b)
			(?:
				(?:\x{0628}[\x{0647}\x{06D5}\x{0629}]\x{200C}*\x{0640}*\x{0647}[\x{200C}\x{200D}\x{0640}]*)*\x{0628}[\x{0647}\x{06D5}\x{0629}]\x{200C}*
				|[\x{0647}\x{06BE}]\x{0640}*[\x{0627}\x{0647}\x{06D5}\x{0629}]\x{200C}*
				|\x{0626}\x{0640}*[\x{0627}\x{06C6}\x{0647}\x{06D5}\x{0629}]\x{200C}*
			)\x{0640}*
			|(?<=$b[\p{Cf}\x{0640}])
			(?:
				(?:\x{0628}[\x{0647}\x{06D5}\x{0629}]\x{200C}*\x{0640}*\x{0647}[\x{200C}\x{200D}\x{0640}]*)*\x{0628}[\x{0647}\x{06D5}\x{0629}]\x{200C}*
				|[\x{0647}\x{06BE}]\x{0640}*[\x{0627}\x{0647}\x{06D5}\x{0629}]\x{200C}*
				|\x{0626}\x{0640}*[\x{0627}\x{06C6}\x{0647}\x{06D5}\x{0629}]\x{200C}*
			)\x{0640}*
			|[\x{06AF}\x{0637}]\x{0640}*\x{0648}+\x{0646}\x{0640}*\x{0627}\x{0640}*
		)
		\x{0647}[\x{200C}\x{200D}\x{0640}]*+(\x{0648}?)(?=[\p{Cf}\x{0640}]*(?:$b|$))
		/$1\x{06BE}$2/gx;
	# Ae
	s/\x{0629}\x{200C}*|[\x{0647}\x{06D5}]\x{200C}+/\x{06D5}/g;
	
	# Final heh preceded by vowels Ae, Alef, Oe or Yeh with small v -> Heh Doachashmee
	s/(?<=[\x{0627}\x{06D5}\x{06CE}\x{06C6}])([\p{Mn}\p{Cf}\x{0640}]*)\x{0647}(?=[^\p{IsArabic}\p{Mn}\p{Cf}\x{0640}]|$)/$1\x{06BE}/g;
	
	# Final Heh in the rest -> Ae
	s/(?<=[\p{IsArabic}\p{Mn}\x{0640}])\x{0647}(?=$b|$)/\x{06D5}/g;
	
	# Same as above with diaritic
	s/(?<=[\p{IsArabic}\p{Mn}\x{0640}]\p{Cf})\x{0647}(?=$b|$)/\x{06D5}/g;

	# Hamzas
	# These are non-joined Waws in Ali font and often, represent
	# "and-conjunctions" when at the end of words. According to standard
	# orthography all "ands" must have a space before them. It's hard to
	# determine when it's an "and", so we have to compromise.
	# With $standardize = 0 all final Hamzas become ZWNJ + Waw to look
	# the same as the source text, otherwise the ZWNJ simply wont be used.
	if ($fontIn == 0) { # Skip for Ali-K web and Dilan font)
		
		# Temporary replacement for intentional Hamzas in the word(s): Ne.
		s/(?<=$b2)(\x{0646}\x{0640}*[\x{0629}\x{06D5}\x{0647}]\x{200C}*)(?:\x{0621}|\x{0020}?\x{0652})\p{Cf}*(?=$b2|$)/$1$tempHamza/g;
		
		# Same as above with diacritic.
		s/(?<=$b2\p{Cf})(\x{0646}\x{0640}*[\x{0629}\x{06D5}\x{0647}]\x{200C}*)(?:\x{0621}|\x{0020}?\x{0652})\p{Cf}*(?=$b2|$)/$1$tempHamza/g;
		
		if (!$standardize) {
			
			# Hamza preceded by joining character -> ZWNJ + Waw.
			s/\x{200C}+\x{0621}|(?<=[\p{IsArabic}\x{0640}](?<![$nonJoiningLetters]))\x{0621}|(?<=[\p{IsArabic}\x{0640}](?<![$nonJoiningLetters])[\p{Mn}\x{200D}])\x{0621}/\x{200C}\x{0648}/g;
		}
		
		s/\x{0621}/\x{0648}/g; # The rest of the Hamzas are converted
	}

	s/[\x{064E}\x{0651}]+[\x{0644}\x{06B5}]/\x{06B5}/g; # Lam with small v

	if ($convDigits) {
		s/\x{06F0}/\x{0660}/g; # 0
		s/\x{06F1}/\x{0661}/g; # 1
		s/\x{06F2}/\x{0662}/g; # 2
		s/\x{06F3}/\x{0663}/g; # 3
		s/\x{06F5}/\x{0665}/g; # 5
		s/\x{06F7}/\x{0667}/g; # 7
		s/\x{06F8}/\x{0668}/g; # 8
		s/\x{06F9}/\x{0669}/g; # 9
	}

	if ($orthCheck) {
		# Initial Rehs -> Reh with small v below.
		s/(?<=$b)[\p{Cf}\p{Mn}]*\x{0631}(?=[\p{Mn}\p{Cf}\x{0640}]*\p{IsArabic})/\x{0695}/g;

		# Initial double Waw -> Waw.
		s/(?<=$b)\x{0648}{2,}+(?=[\p{Cf}\x{0640}]*\p{IsArabic})/\x{0648}/g;
	}

	if ($fixSpacing) {		
		# Remove spaces before certain punctuation marks
		s/\x{0020}+(?=[,!?;:\x{060C}\x{061B}\x{061F}]|\.(?!\.))//g;

		# Add space after some punctuation characters
		s/([;:,!?\x{060C}\x{061B}\x{061F}])(?=\p{Letter})/$1\x{0020}/g;
	}

	if ($standardize) {
		# Final Waw preceded by latin/final punctuation/etc. -> space + Waw.
		s/(?<=[\p{Latin}\d\p{Pe}\p{Pf}%,;:!?\x{0609}\x{060A}\x{060C}-\x{060E}\x{061B}\x{061E}\x{061F}])\p{Cf}*\x{0648}[\p{Cf}\x{0640}]*(?=$b|$)|(?<=\.)\p{Cf}*\x{0648}[\p{Cf}\x{0640}]*(?=[^.\p{IsArabic}\p{Mn}\p{Cf}\x{0640}]|$)/\x{0020}\x{0648}/g;
		
		# Remove format chars.
		s/\p{Cf}//g;
	}
	
	# Heh
	if ($hehOut == 0) {
		s/\x{06BE}\x{200D}*\x{0640}?+\x{200D}*(?=[\p{Cf}\x{0640}]*(?:$b|$))/\x{0647}\x{0640}/g;
		s/\x{06BE}/\x{0647}/g;
	} else {
		s/\x{0647}/\x{06BE}/g;
	}

	s/$tempHamza/\x{0621}/g; # Revert the temporary replacement for Hamzas.
	s/^$tempCaret//g; # Revert the temporary replacement for beginning of lines.

	print "$_\n";
}

exit 0;
