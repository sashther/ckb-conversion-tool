ckb-conversion-tool
===================

Scripts for converting between character sets used in Central Kurdish writing


Background
===================

Before Unicode emerged, Kurdish on computers was made possible with fonts that were mapped to non-Kuirdish layouts. Similar to wingdings, the fonts swapped the characters to different letters. The most popular group of fonts doing this were the Ali-K fonts that are mapped to Arabic-101 layouts. A less popular group were the Dilan fonts that are mapped to a different keyboard layout.

When Unicode encodings appeared a group called KurdITGroup created a real Kurdish keyboard layout that became the standard for Kurdo-Arabic in Unicode. The Unicode layout is, unlike the non-Unicode one, mapped similarly to the Kurdish-Latin QWERTY variant; "Kaf" is placed on "k" (these are equivalent), "Seen" on "s", etc.

People still like to use the non-Unicode variant, either not knowing about the Unicode one or complaining that the Unicode one requires relearning and that the fonts are ugly. Therefore one often needs to convert between Unicode and non-Unicode scripts when working with Kurdo-Arabic texts.

The converters out there are good for short texts, but even the best ones miss things and aren't reliable for large amounts of text.


About
===================

The converter was created by looking at the fonts in a font editor, current font converters (mainly Kurdi Nus 4.0) and analyzing a large amount of text (340 MB of UTF-8 text).

I only briefly looked at direction-changing chars such as RTL marks, they seem to serve the same function as ZWNJ a lot of times, and are totally useless other times. They might have been written by accident. These are changed independent of these settings -- the code needs to be tinkered with if you wish to do anything differently.

Note:
* char-set-vs-font.jpg illustrates differences in output depending on font.
* sample-text can be used with the script to check if it works as it should.

Options
===================

fontIn: Font (or character mapping) of the input text
* 0: Ali-K
* 1: Ali-K web. This is a variant of Ali-K that have slightly different mapping.
* 2: Dilan. This one seems to support an all together different keyboard layout than the Ali-K ones. Therefore character mappings are wildly different on this one. The support for these fonts is not strong in this converter.

standardize: Whether to standardize (or stay close to rendering)?
* 0: Retains some chars where they might have a visual effect.
* 1: Removes non-standard and unneccessary format chars and more like ZWNJ, ZWJ and Tatweel in many places.

orthCheck: Do minor ortographical checking?
* 0: No
* 1: Yes, changes initial Rehs to thick Rehs, initial double Waws to one Waw and fixes some spacing.

hehOut: Char(s) to output hehs with
* 0: Heh+Tatweel at end of words, heh otherwise (standard).
* 1: Heh Doachashmee (not on the standard CKB keyboard).
