use strict;
use warnings;

use Data::Dumper;
use Getopt::Std;
use XML::Simple;
use DBI;

$| = 1;

=pod

  This is ACME XML parser version 1.0
  Use with care.

=cut

sub main {
    my %opts;

    getopts( 'd:r', \%opts );

    if ( !check_usage( \%opts ) ) {
        print_usage();
        exit();
    }

    my $input_dir = $opts{'d'};

    my @files = get_xml_files($input_dir);

    if ( !$opts{'r'} ) {
        print( Dumper( \@files ) );
        return;
    }

    my @data = process_files( \@files, $input_dir );
    print( Dumper(@data) );

    my %database_config = (
        "db_name"     => "Bands",
        "db_host"     => "0.0.0.0",
        "db_port"     => "3306",
        "db_user"     => "martin",
        "db_password" => "martin",
    );

    my $dsn = sprintf(
        "dbi:mysql:%s:%s:%s",
        $database_config{"db_name"},
        $database_config{"db_host"},
        $database_config{"db_port"}
    );

    my $dbh = DBI->connect(
        $dsn,
        $database_config{"db_user"},
        $database_config{"db_password"}
    );

    unless ( defined($dbh) ) {
        die("Failed to connect to database.\n");
    }
    print("Connected to database \n");

    $dbh->disconnect();

}

sub process_files {
    my ( $files, $input_dir ) = @_;

    my @data;

    for my $file (@$files) {
        my $file_path = "$input_dir/$file";
        push( @data, process_file("$file_path") );
    }

    return @data;
}

sub process_file {
    my ($file_path) = @_;

    print("Processing file: $file_path\n");

    my $has_error = 0;

    open( INPUTFILE, $file_path ) or $has_error = 1;

    my @band_record;
    if ( !$has_error ) {

        # $/ = "</entry>"; # Global variable file separator -> Default is "\n"
        undef($/);    # Reads whole file in one go

        my $content = <INPUTFILE>;
        my $parser  = new XML::Simple;
        my $dom     = $parser->xml_in( $content, ForceArray => 1 );

        for my $band ( @{ $dom->{'entry'} } ) {
            my $band_name = $band->{'band'}->[0];
            my $albums    = $band->{'album'};

            my @band_albums;
            for my $album ( @{$albums} ) {
                my $album_name = $album->{'name'}->[0];
                my $chart_pos  = $album->{'chartposition'}->[0];

                push(
                    @band_albums,
                    {
                        "name"           => $album_name,
                        "chart_position" => $chart_pos,
                    }
                );
            }

            push(
                @band_record,
                {
                    "name"   => $band_name,
                    "albums" => \@band_albums,
                }
            );
        }

        $/ = "\n";
    }
    else {
        print("Failed to open file at path: '$file_path'");
    }

    close(INPUTFILE);
    return @band_record;
}

sub get_xml_files {
    my ($input_dir) = @_;

    my $fh;
    unless ( opendir( $fh, $input_dir ) ) {
        die "Unable to open directory '$input_dir'\n";
    }

    my @files;
    for my $file_name ( readdir($fh) ) {
        if ( $file_name =~ /\.xml$/i ) {
            push( @files, $file_name );
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

    unless ( defined($directory) ) {
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
