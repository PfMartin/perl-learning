use strict;
use warnings;

use v5.38;

$|=1;

sub main {
	my $input_file = '/home/martin/Perl/Tutorials/TestFiles/mymanjeeves.txt';

	open(my $input_fh, $input_file) or die "Failed to open file: $input_file";

	my $counter = 0;

	while(my $line = <$input_fh>) {
		if($line =~ /(s.*?n)/) {
			$counter++;
			print("$1\n");
		}
	}

	print("=== Found $counter matching lines ===\n");
	close($input_fh);
}

main();
