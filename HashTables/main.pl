use strict;
use warnings;

$|=1;

use v5.38;

sub display_months {
  my %months = (
    "Jan" => 1,
    "Feb" => 2,
    "Mar" => 3,
    "Apr" => 4,
  );

  my $april = $months{"Apr"};
  print("$april\n");
}

sub display_days {
  my %days = (
    1 => "Mon",
    2 => "Tue",
    3 => "Wed",
    4 => "Thu",
    5 => "Fri",
    6 => "Sat",
    7 => "Sun",
  );

  my $wednesday = $days{3};
  print("$wednesday\n");
}

sub iterate_over_hash {
  my %days = (
    1 => "Mon",
    2 => "Tue",
    3 => "Wed",
    4 => "Thu",
    5 => "Fri",
    6 => "Sat",
    7 => "Sun",
  );

  print("Iteration with for loop\n");

  my @days = keys(%days);
  for my $day (@days) {
    printf("$day: %s\n", $days{$day})
  }

  print("Iteration with while loop\n");

  while(my ($key, $value) = each(%days)) {
    print("$key: $value\n");
  }
}

sub main {
  display_days();
  display_months();  

  iterate_over_hash();
}

main();