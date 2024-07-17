use strict;
use warnings;

$|=1;

sub file_exists {
	my ($file_path) = @_;
	
	return -f $file_path;
}

sub main {
	my $file = '/home/martin/Perl/Tutorials/TestFiles/mymanjeeves.txt';
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
