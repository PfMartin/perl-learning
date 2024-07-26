use strict;
use warnings;

use v5.38;

sub main {
	my $file_path = '/app/TestFiles/mymanjeeves.txt';

	open(my $input_fh, $file_path) or die "Failed to open file: $file_path";

	while(my $line = <$input_fh>) {
		if($line =~ /(I..a.)(...)/) {
			print("'$1' is followed by '$2'\n");
		}
	}

	close($input_fh);
}

main()
