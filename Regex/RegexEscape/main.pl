use strict;
use warnings;

$|=1;

use v5.38;

sub main {
	# \d digit
	# \s space
	# \S non-space
	# \w alphanumeric	

	my $text = 'I am 117 years old tomorrow.';
	
	if($text =~ /(\d+)/) {
		print("Age: $1\n");
	}

	if($text =~ /(I\sam\s\d+)/) {
		print("Found age declaration: $1\n");
	}
}

main();
