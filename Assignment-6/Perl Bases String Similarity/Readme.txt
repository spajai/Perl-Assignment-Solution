
####################################################
# Summary
####################################################

Create a Perl function (a subroutine) that:
1. Breaks a string into several smaller sub-strings of width N.
2. Compares all the smaller substrings against all the other substrings to count how many of the strings match.
3. A loop inside another loop may be used to iterate through all the possibilities.
4. Do not make the same comparison twice.
5. Calculate the percentage of cases where a string matches another string.

The development process is broken down below into some steps intended to make the coding process easier by:
1. Starting with one feature, and then
2. Adding additional features, one feature at a time.

####################################################
# VERSION ONE
####################################################

STEP ONE
Create a sub-module that receives a string as a parameter.

STEP TWO
Break the string into array of substrings that are N characters wide.
We will start by assuming N is 48.

Each substring begins where the previous ended.
For example:
Position 0 through 47 is first item.
Position 48 through 95 is second item.
Position 96 through 143 is third item.
Position 144 thorugh 191 is forth item.
Et cetera.

STEP TWO
Compare every substring against every other substring.
A loop inside another loop can be used for this.
Be careful to not make the same comparison more than once.

STEP THREE
Count the number of substrings that match other substrings.

STEP FOUR
Calculate the percentage of matches, by dividing the count of matches by the total number of substrings.

STEP FIVE
Return that percentage as a return value from the submodule.

####################################################
# VERSION TWO
####################################################

In version one, we examined widths that are 48 characters wide.

Version two adds a parameter so that we can specify other widths for N.

We can call this parameter 'window_size'.

For example, we might want to look at substrings that are 96 characters wide.
Or, we might want to look at substrings that are 24 characters wide.

####################################################
# VERSION THREE
####################################################

In the first two versions, as we examined each substring and compared against all the other substrings, what counted was only exact matches.

Version three improves upon the previous versions by adding the capability to recognize cases that are not exact matches.

Although very sophisticated algorithms exist to measure the similarity between two strings, what is prefered here is a very simple measure of similarity that works like this:

When comparing two substrings, examine string 1 and string 2 one character at a time.
Determine the percentage of characters that are identical between string 1 and string 2.

For example, the two strings below are identical except for two characters. 
22 of the 24 characters are identical.
We can therefore say that the two strings are 91.67 percent identical.
When counting strings that are identical, a perfect match would receive a count of 1.0000.
But the count assigned for something like this example with a 91.67 percent match would be 0.9167.

0110000111100010101001101
0110000101100010111001101

####################################################
# VERSION FOUR
####################################################

In version four, we add the capability to examine the reverse of a string.

So, for example, when we break the input string into several small substrings and compare them,
when we are looking at substring 1 and substring 2, we will look to see if string 2 is the mirror image of string 1.

For example, the second string below is the mirror image of the first.
010111110000
000011111010

This could be done in either 1 of 2 ways:
1. One of the strings could be reversed, or
2. The comparison could iterate through in forward order for one string while iterating in reverse order for the other string.

The same logic from version three that we added to consider cases that are similar but not identical will also apply to these reverse comparisons.

As a result, we will not have two types of comparisons between each string pair:
1. A forwards comparison
2. A comparison that looks to see if one is the mirror image of the other.

Therefore, we now have two evaluation scores for each pair of strings.
The highest score of the two will be selected to represent the similarity of the string pair.

####################################################
# VERSION FIVE
####################################################

In the logic thus far, the string that was received by the input parameter was broken into smaller strings of width N ('window_size'), 
and the point where each string begins is at N+1 where the previous string ended.
The strings were non-overlapping.

Version five adds a parameter that allows us to indicate a preference to break apart the string into smaller strings of width N that begin at a separation of X.

We may call this parameter 'step_size'.

For example, if we indicate we want to break apart the larger string into smaller substrings of width N and have the starting point of each substring be separated by X characters,
and if we were to indicate N=48 and X=24, then:

window_size parameter will be 48
step_size parameter will be 24, and therefore...

Position 0 through 47 is first item.
Position 24 through 71 is second item.
Position 48 through 95 is third item.
Position 72 thorugh 119 is forth item.
Position 96 thorugh 143 is fifth item.
Position 120 thorugh 167 is sixth item.
Et cetera.
