use strict;
use warnings;

$|=1;

sub file_exists {
	my ($file_path) = @_;
	
	return -f $file_path;
}

sub main {
	my $file = '/app/TestFiles/mymanjeeves.txt';
	file_exists($file) or die "File doesn't exist";

	open(my $fh, $file) or die "Input file $file not found.\n";

	while(my $line = <$fh>) {
		if($line =~ / egg /) {
			print("$line");
		}
		
	}

	close($fh);
}


main();
