use strict;
use warnings;

use LWP::Simple;

$|=1;

sub get_content_from_url {
  my ($url) = @_;

  my $content = get($url);

  unless(defined($content)) {
    die "Error: Failed getting content from url: $url\n";
  }

  return $content;
}

sub get_test_site_title {
  my ($url) = @_;

  my $content = get_content_from_url($url);

  if($content =~ /<h1>(.+?)<\/h1>/) {
    my $title = $1;

    print("Title: '$title'\n");
  } else {
    print("Failed to find headline\n");
  };
}

sub match_repeatedly {
  my ($url) = @_;

  my $content = get_content_from_url($url);

  my $matcher = qr|<li>([Ii]tem\s[0-9]{1,}.*?)<\/li>|;

  while($content =~ /$matcher/sig) {
    print("Matched item: '$1'\n");
  }

  my @matched_items = $content =~ /$matcher/sig;
  for (@matched_items) {
    print("Matched items in array: '$_'\n");
  }

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

  my $url = "http://0.0.0.0:8000/test_site.html";
  get_test_site_title($url);
  match_repeatedly($url);

}

main();