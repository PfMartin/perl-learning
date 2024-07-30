use strict;
use warnings;

use v5.38;

$|=1;

sub openCsvFile {
  my ($file_path) = @_;

  open(my $fh, $file_path) or die "Failed to open file: $file_path";

  return $fh;
}

sub closeCsvFile {
  my ($file_handler) = @_;

  close($file_handler);
}

sub isNotEmptyLine {
  my ($line) = @_;

  return $line =~ /\S+/;
}

sub isValidLine {
  my ($name, $amount, $time) = @_;

  if (!$name || !$amount || !$time) {
    return 0
  }

  return 1
}

sub main {
  my $file_path = '/app/TestFiles/payments.csv';

  my $fh = openCsvFile($file_path);

  my @payments_record;

  my ($name_key, $amount_key, $time_key);
  my $idx = 0;
  for my $line (<$fh>) {
    chomp($line);

    isNotEmptyLine($line) || $idx++ && next;

    my ($name, $amount, $time) = split(/\s*,\s*/, $line);

    if (!isValidLine($name, $amount, $time)) {
      printf("Invalid row on line %d: $line.\n", $idx+1);
      $idx++;
      next;
    };

    if ($idx == 0) {
      $name_key = $name;
      $amount_key = $amount;
      $time_key = $time;

      $idx++;
      next;
    }

    my %payment_entry = (
      $name_key => $name,
      $amount_key => $amount,
      $time_key => $time,
    );

    push(@payments_record, \%payment_entry);
  }

  closeCsvFile($fh);


  print("\nEntries:\n");
  for my $entry (@payments_record) {
    printf("%s paid %.2f euros on %d\n", $entry->{$name_key}, $entry->{$amount_key}, $entry->{$time_key});
  }
}

main();