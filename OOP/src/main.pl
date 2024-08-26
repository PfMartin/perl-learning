use strict;
use warnings;
use Data::Dumper;

use lib "../../lib";
use Communication::Speak ( "test", "greet" );
use Data::Person;

$| = 1;

sub main {

    test();
    greet("Martin");

    my @dogs = qw( retriever labrador alsatian );
    print( Dumper(@dogs) );

    my $person1 = new Data::Person( "Martin", 32 );
    my $person2 = new Data::Person( "Bob",    22 );

    my $age_key  = $Data::Person::age_key;
    my $name_key = $Data::Person::name_key;
    print("\n$age_key\n");
    print("$name_key\n");

    print("\n");
    $person1->greet($person2);
    print("\n");
    $person2->greet($person1);
}

main();
