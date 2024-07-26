use strict;
use warnings;

use v5.38;

$|=1;

sub main {
	my $input_file = '../../TestFiles/payments.csv';

	open(my $input_fh, $input_file) or die "Failed to open file: $input_file\n";

	<$input_fh>; # Reads off the first line and ignore it

	my @payment_values;
	while(my $line = <$input_fh>) {
		chomp($line);	
		my @values = split(/\s*,\s*/, $line); # split a zero spaces or more followed by followed by zero spaces or more

		push(@payment_values, $values[1]);
	}

	close($input_fh);

	for my $payment (@payment_values) {
		print("$payment\n");	
	}

}

main()
