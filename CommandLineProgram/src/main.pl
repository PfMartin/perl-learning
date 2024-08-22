use strict;
use warnings;
use Data::Dumper;
use Getopt::Std;

$|=1;

=pod

  This is ACME XML parser version 1.0
  Use with care.

=cut

sub main {
  my %opts;

  getopts('d:r', \%opts);

  if(!check_usage(\%opts)) {
    print_usage();
    exit();
  }

  my $input_dir = $opts{'d'};

  my @files = get_files($input_dir);

  print(Dumper(\@files));
}

sub get_files {
  my ($input_dir) = @_;

  my $fh;
  unless(opendir($fh, $input_dir)) {
    die "Unable to open directory '$input_dir'\n";
  }


  my @files;
  for my $file_name (readdir($fh)) {
    if ($file_name =~ /\.xml$/i) {
      push(@files, $file_name);
    }
  }

  # Alternative with built-in grep subroutine
  # my @files = readdir($fh);
  # @files = grep(/\.xml$/i, @files);

  closedir($fh);


  return @files;
}


sub check_usage {
  my ($opts) = @_;

  my $r = $opts->{'r'};

  my $directory = $opts->{'d'};

  unless(defined($directory)) {
    return 0;
  }

  return 1;
}

sub print_usage {
  print <<USAGE;

usage: perl main.pl <options>
  -d  <directory>   Specify directory in which to find XML files
  -r                Run the program; Process the files

example usage:
  perl main.pl -d ../files -r

USAGE
}

main();