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

    getopts( 'i:e', \%opts );

    if ( !check_usage( \%opts ) ) {
        print_usage();
        exit();
    }

    my $database_handler = get_db_handler();

    if ( $opts{"i"} ) {
        my $input_dir = $opts{'i'};
        my @files     = get_xml_files($input_dir);
        my @data      = process_files( \@files, $input_dir );

        add_to_database( $database_handler, \@data );
    }

    if ( $opts{"e"} ) {
        export_from_database($database_handler);
    }

    $database_handler->disconnect();
}

sub get_db_handler {
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
        $database_config{"db_password"},
        {
            mysql_ssl => 1,
        }
    );

    unless ( defined($dbh) ) {
        die("Failed to connect to database.\n");
    }

    print("Connected to database \n");

    return $dbh;
}

sub add_to_database {
    my ( $db_handler, $data ) = @_;

    clear_database($db_handler);

    my $sth_bands = $db_handler->prepare('insert into Bands (name) values (?)')
      or die("Failed preparing SQL for inserting bands\n");

    my $sth_albums = $db_handler->prepare(
        'insert into Albums (name, position, band_id) values (?, ?, ?)')
      or die("Failed preparing SQL for inserting albums\n");

    for my $data ( @{$data} ) {
        my $band_name = $data->{"name"};
        my $albums    = $data->{"albums"};

        $sth_bands->execute($band_name)
          or die "Failed adding '$band_name' to the database\n";

        my $band_id = $sth_bands->{"mysql_insertid"};
        print("Inserted $band_name with ID: $band_id\n");

        for my $album ( @{$albums} ) {
            my $album_name     = $album->{"name"};
            my $album_position = $album->{"chart_position"};

            $sth_albums->execute( $album_name, $album_position, $band_id )
              or print(
"Error: Failed to insert album for $band_name with values: $album_name, $album_position, $band_id\n"
              );
        }
    }

    $sth_bands->finish();
    $sth_albums->finish();
    print("Done inserting\n");
}

sub export_from_database {
    my ($db_handler) = @_;

    print("Exporting data...\n");

    my $sql =
"SELECT b.id as band_id, b.name as band_name, a.id as album_id, a.name as album_name, a.position as album_chart_position "
      . "FROM Bands as b "
      . "JOIN Albums a on a.band_id=b.id";

    my $sth = $db_handler->prepare($sql)
      or die "Unable to prepare export query\n";

    unless ( $sth->execute() ) {
        die "Unable to execute export query\n";
    }

    while ( my $row = $sth->fetchrow_hashref() ) {
        my $band_id              = $row->{"band_id"};
        my $band_name            = $row->{"band_name"};
        my $album_id             = $row->{"album_id"};
        my $album_name           = $row->{"album_name"};
        my $album_chart_position = $row->{"album_chart_position"};
        print(
"$band_id, $band_name, $album_id, $album_name, $album_chart_position\n"
        );
    }

    $sth->finish();
}

sub clear_database {
    my ($db_handler) = @_;

    $db_handler->do('delete from Albums')
      or die "Failed to delete all entries from the Albums table";
    $db_handler->do('delete from Bands')
      or die "Failed to delete all entries from the Bands table";

    print("Done deleting\n");
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

    my $directory = $opts->{'i'};

    unless ( defined($directory) ) {
        return 0;
    }

    return 1;
}

sub print_usage {
    print <<USAGE;

usage: perl main.pl <options>
    -i  <directory> Import data; specify directory in which to find XML files
    -e              Export data from database

example usage:
    perl main.pl -i ../files
    perl main.pl -e

USAGE
}

main();
