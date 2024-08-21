use strict;
use warnings;

use LWP::Simple;

$|=1;

sub get_test_site_title() {
  my $content = get("http://0.0.0.0:8000/test_site.html");

  unless(defined($content)) {
    die "Error: Unreachable url\n";
  }

  if($content =~ /<h1>(.+?)<\/h1>/) {
    my $title = $1;

    print("Title: '$title'\n");
  } else {
    print("Failed to find headline\n");
  };
}

sub character_classes() {
  my $content = "The 39 Steps - a GREAT book - Colours_15 ==%== ABCCCABABABACC";

  my @tests = (
    qr/([0-9]{2,})/,
    qr/([A-Z]{2,})/,
    qr/(C[A-Za-z_0-9]{2,})/,
    qr/([\=\%]{2,})/,
    qr/([ABC]{3,})/,
    qr/([^0-9\s]{5,})/,
  );

  for my $test (@tests) {
  if ($content =~ /$test/) {
    print("Matched: '$1'\n");
  } else {
    print("No match\n");
  }
  }

}


sub main {
  character_classes();

  get_test_site_title();
}

main();