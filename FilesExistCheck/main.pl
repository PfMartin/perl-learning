use strict;
use warnings;

$|=1;

use v5.38;

sub main {
	my $file_base_path = "/app/TestFiles/";

	my @file_names = (
		"mymanjeeves.txt", 
		"output.txt",
		"missing.txt",
	);

	foreach my $file (@file_names) {
		sleep(1);
		my $file_path = $file_base_path . $file;

		if (-f $file_path) {
			print("Found file: $file_path\n");
		} else {
     			print("File not found: $file_path\n");
		};
	};
};
main();
