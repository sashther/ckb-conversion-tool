ckb-conversion-tool
==============

A script for converting non-standard Central Kurdish texts to standard mappings.

Background
=========

Before Unicode, Kurdish on computers was made possible with wingdings-like fonts that swapped characters to letters they werent intended for. The most popular group of fonts doing this were the Ali-K fonts, which are mapped to Arabic-101 layouts. Dilan fonts are another, less popular, font group doing this and are mapped to a different layout.

When Unicode appeared a standard keyboard layout was created for Kurdo-Arabic. This layout is mapped similarly to the Kurdish-Latin QWERTY variant in that equivalent letters are positioned on the same place; "kaf" is placed on "k" etc.

Many still use the non-Unicode variant, either not knowing about the Unicode one or complaining that it requires relearning and the fonts are ugly. Therefore one often needs to convert between Unicode and non-Unicode scripts when working with Kurdo-Arabic texts.

The converters out there are ok for short texts, but even the best ones miss things and aren't very reliable for large amounts of text.


About
=========

This converter was created by analyzing mappings of relevant fonts, current text converters (mainly Kurdi Nus 4.0) and a large amount of Kurdish text (340 MB UTF-8).

Direction-changing chars such as RTL marks haven't been looked at too closely and are changed independent of the options -- the code needs to be tinkered with for different results. They seem to serve the same function as ZWNJ a lot of times and are totally useless at other times (perhaps many are accidental).

Two additional informational files have been included:
* *char-set-vs-font.jpg* illustrates differences in output depending on font, as is seen further down.
* *sample* has some text which can be used to check if the script works as it should.

Options
=========

**fontIn**: The font or character mapping of the input text
* 0: Ali-K
* 1: Ali-K web. This is a variant of Ali-K that have slightly different mapping.
* 2: Dilan. ***Experimental only!*** This one seems to support an all together different keyboard layout than the Ali-K ones. Therefore character mappings are wildly different.

**standardize**: Whether to standardize (or stay close to rendering)
* 0: No; retain (some) chars where they might have a visual effect.
* 1: Yes; Remove non-standard/unneccessary format chars etc. in many places (ZWNJ, ZWJ and Tatweel and more).

**orthCheck**: Do minor orthographical checking?
* 0: No
* 1: Yes (changes initial Rehs to thick Rehs, initial double Waws to one Waw and fixes some spacing).

**fixSpacing**: Fix spacing a bit? (before and after some punctuation marks)
* 0: No
* 1: Yes

**hehOut**: Char(s) to output Hehs with
* 0: Heh+Tatweel at end of words, heh otherwise (standard).
* 1: Heh Doachashmee (not on the standard CKB keyboard).

**convDigits**: Normalize extended Arabic-Indic digits?
* 0: No
* 1: Yes; 4 and 6 are skipped as they look different. 


Illustration of differences in output
========================
![Differences in output of Kurdish texts in Arabic script depending on font](/char-set-vs-font.jpg "Differences in output: 1.US, 2.CKB, 3.AR-101, 4.AR-101 w. Ali")
