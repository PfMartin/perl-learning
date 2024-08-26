package Communication::Speak;

use Exporter ("import");

@EXPORT_OK = ( "test", "greet" );

sub test {
    print("Hello there.\n");
}

sub greet {
    my $name = shift;

    print("Hello there, $name!\n");
}

1;
