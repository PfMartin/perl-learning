use strict;
use warnings;

$|=1;
 
use v5.38;

sub main {
	my $input_file = '/home/martin/Perl/Tutorials/TestFiles/mymanjeeves.txt';
	open(my $input_fh, $input_file) or die "Failed to open file: $input_file\n";
	

	my $output_file = 'output.txt';
	open(my $output_fh, '>'.$output_file) or die "Failed to create file: $output_file\n";

	while(my $line = <$input_fh>) {
		if($line =~ /\begg\b/) {
			$line =~ s/you/YOU/ig; # it searches for the word 'you' withoug case sensitivity and replaces it in all occurences
			print($output_fh $line);	
		}
	}


	close($input_fh);
	close($output_fh);
}

main();
