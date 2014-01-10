ckb-conversion-tool
===================

A script for converting non-standard Central Kurdish texts to standard mappings.


Background
===================

Before Unicode emerged, Kurdish on computers was made possible with fonts that were mapped to non-Kuirdish layouts. Similar to wingdings, theys swapped the characters to different letters. The most popular group of fonts doing this were the Ali-K fonts - they are mapped to Arabic-101 layouts. Dilan fonts are another, less popular group, mapped to a different layout.

When Unicode encodings appeared a group called KurdITGroup created a real Kurdish keyboard layout that set the standard for Kurdo-Arabic in Unicode. This layout is, unlike the Arabic-101, mapped similarly to the Kurdish-Latin QWERTY variant in that equivalent letters are positioned on the same place; "Kaf" is placed on "k", "Seen" on "s", etc.

Many people still use the non-Unicode variant, either not knowing about the Unicode one or complaining that it requires relearning and the fonts are ugly. Therefore one often needs to convert between Unicode and non-Unicode scripts when working with Kurdo-Arabic texts.

The converters out there are good for short texts, but even the best ones miss things and aren't reliable for large amounts of text.


About
===================

This converter was created by looking at the fonts in a font editor, current font converters (mainly Kurdi Nus 4.0) and analyzing a large amount of text (340 MB of UTF-8).

I only briefly looked at direction-changing chars such as RTL marks, they seem to serve the same function as ZWNJ a lot of times, and are totally useless other times (perhaps many are accidental). These chars are changed independent of the option - the code needs to be tinkered with if you wish to do anything differently.

Two additional informational files have been included:
* *char-set-vs-font.jpg* illustrates differences in output depending on font, as is seen further down.
* *sample-text* can be used with the script to check if it works as it should.

Options
===================

**fontIn**: The font or character mapping of the input text
* 0: Ali-K
* 1: Ali-K web. This is a variant of Ali-K that have slightly different mapping.
* 2: Dilan. ***Experimental only!*** This one seems to support an all together different keyboard layout than the Ali-K ones. Therefore character mappings are wildly different.

**standardize**: Whether to standardize (or stay close to rendering)?
* 0: Retains some chars where they might have a visual effect.
* 1: Removes non-standard and unneccessary format chars and more like ZWNJ, ZWJ and Tatweel in many places.

**orthCheck**: Do minor orthographical checking?
* 0: No
* 1: Yes, changes initial Rehs to thick Rehs, initial double Waws to one Waw and fixes some spacing.

**hehOut**: Char(s) to output Hehs with
* 0: Heh+Tatweel at end of words, heh otherwise (standard).
* 1: Heh Doachashmee (not on the standard CKB keyboard).

Illustration of differences in output
=====================================
![Differences in output of Kurdish texts in Arabic script depending on font](/char-set-vs-font.jpg "Differences in output: 1.US, 2.CKB, 3.AR-101, 4.AR-101 w. Ali")
