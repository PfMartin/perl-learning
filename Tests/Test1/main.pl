use strict;
use warnings;

$|=1;
sub hello_world {
	print("Hello World!\n");
}

sub get_emails {
	my @emails = (
		"martinpfatrisch\@gmail.com",
		"notvalid.com",
		"invalid\@com",
		"valid\@web.de",
		"leahaberl\@gmail.com",
		"test\@invalid."	
	);

	return @emails;
}

sub validate_emails {
	my (@emails) = @_;

	for my $email (@emails) {
		if ($email =~ /\w+\@\w+\.\w+/) {
			print("Valid email: $email\n");
		} else {
			print("Invalid email: $email\n");
		}
	}
}

sub main {
	my @emails = get_emails();
	
	validate_emails(@emails);
}

main();
