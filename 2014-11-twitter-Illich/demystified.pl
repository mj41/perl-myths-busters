#!/usr/bin/perl

use strict;
use warnings;

# Read lines from each file provided on command line.
while ( my $line = <> ) {
	$line =~ s{\n$}{}; # Remove all new lines on the end of string.
	$line =~ s{\|}{}g; # Remove all occurences of | character.

	$line =~ s{^ [-\s]+ }{}x; # Remove all dashes and whitespace characters (any
	                          # combination of them) from the begin of the string.

	while ( $line =~ m{(\G    # \G means match only at pos() (e.g. at the end-of-match
	                          #  position of prior m//g).
			(?<word> [^- ]+)  # Match sequence (at least one character) of all characters
			                  #   except dash and space. Save matched to $+{word}.
			[-\s]*            # Empty string or sequence of whitespace and dash characters.
		)}gx )
	{
		my $word = $+{word};

		# Match e.g. "bbb{xx,yy,zz}eee".
		if ( $word =~ m/^    # Character ^ here match begin of string.
				(?<start> [^{]* )       # Empty string or sequence of all characters except {.
				                        # Saved to $+{start}.
				{                       # Match character {.
					(?<list> [^{}]+)    # Sequence of all characters except { and }. Saved
					                    #   to ${list}.
				}                       # Match character }.
				(?<end> .*)             # All remaining characters (dot means any character)
				                        # to end of $word. Saved to $+{end}.
			$/x )  # Character $ here match end of string.
		{
			# For e.g. "bbb{xx,yy,zz}eee" matched above print string "bbbxxeee", "bbbyyeee"
			# and "bbbzzeee". Each on the new line.
			# Split $list by ',' character.
			foreach my $elem ( split(/,/, $+{list}) ) {
				print "$+{start}$elem$+{end}\n";
			}
			next; # Continue with next word in $line.
		}

		# All others not matched by regexp above.
		$word =~ s{
			[ {}\. ]  # Any of { or } or dot characters are removed (replaced by empty string).
			          # Backslash is used to escape dot (dot means one any character in regexp).
		}{}gx;
		print "$word\n";
	}
}
