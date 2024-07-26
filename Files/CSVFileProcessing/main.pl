use strict;
use warnings;

use Data::Dumper;

use v5.38.2;

$|=1;

sub get_payments {
	my ($input_file) = @_;

	open(my $input_fh, $input_file) or die "Failed to open file: $input_file\n";

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

sub store_in_array_of_arrays {
	my ($input_file) = @_;

	open(my $input_fh, $input_file) or die "Failed to open file: $input_file\n";

	my @values_array;

	<$input_fh>;
	while(my $line = <$input_fh>) {
		chomp($line);
		my @column_values = split(/\s*,\s*/, $line);

		push(@values_array, \@column_values); # Reference to an array is a scalar
	}

	close($input_fh);

	print("Names\n");
	for my $line (@values_array) {
		printf("%s\n", $line->[0]);
	}

	printf("First name: %s\n", $values_array[0][0]);
}

sub store_in_hash_table {
	my ($input_file) = @_;

	open(my $input_fh, $input_file) or die "Failed to open file: $input_file\n";

	<$input_fh>;
	while(my $line = <$input_fh>) {
		chomp($line);

		my @line_values = split(/\s*,\s*/, $line);


		print("@line_values\n");
	}

	close($input_fh);
}

sub main {
	my $input_file = '/app/TestFiles/payments.csv';

	print("=== Get Payments ===\n");
	get_payments($input_file);

	print("=== Store all values in an array of arrays ===\n");
	store_in_array_of_arrays($input_file);

	print("=== Store all values in hash table ===");
	store_in_hash_table($input_file);
}

main()
