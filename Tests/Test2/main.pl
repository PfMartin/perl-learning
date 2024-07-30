use strict;
use warnings;

use v5.38;

$|=1;

sub openFile {
  my ($file_path) = @_;

  open(my $fh, $file_path) or die "Failed to open file: $file_path\n";

  return $fh;
}

sub closeFile {
  my ($file_handler) = @_;

  close($file_handler);
}

sub isEmptyLine {
  my ($line) = @_;

  return $line !~ /\S+/;
}

sub isValidLine {
  my ($name, $amount, $time) = @_;

  return !(!$name || !$amount || !$time)
}

sub cleanValues {
  for (@_) {
    $_ =~ s/\?|\$|approx.|//g;
    $_ =~ s/^\s*|\s*$//g;
  }
}

sub main {
  my $file_path = '/app/Tests/Test2/test.csv';

  my $fh = openFile($file_path);

  my @payment_record;
  my ($name_key, $amount_key, $time_key);

  my $idx = 0;
  for my $line (<$fh>) {
    chomp($line);
    $line =~ s/^\s*|\s$//g;

    if (isEmptyLine($line)) {
      printf("Warning: Empty line at line number: %d\n", $idx + 1);

      $idx++;
      next;
    }

    my ($name, $amount, $time) = split(/\s*,\s*/, $line);

    if ($idx == 0) {
      ($name_key, $amount_key, $time_key) = ($name, $amount, $time);

      $idx++;
      next;
    }

    if (!isValidLine($name, $amount, $time)) {
      printf("Warning: Invalid line at line number %d: %s\n", $idx + 1, $line);

      $idx++;
      next;
    }

    cleanValues($name, $amount, $time);

    my %payment_entry = (
      $name_key => $name,
      $amount_key => $amount,
      $time_key => $time,
    );

    push(@payment_record, \%payment_entry);

    $idx++;
  }

  closeFile($fh);

  my $total_amount = 0;

  print("\nEntries: \n");
  for (@payment_record) {
    printf("%s: %.2f at %d\n", $_->{$name_key}, $_->{$amount_key}, $_->{$time_key});

    $total_amount += $_->{$amount_key};
  }

  printf("\nTotal Amount: \$%.2f\n", $total_amount);
}

main();