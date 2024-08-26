package Data::Person;

our $age_key  = "age";
our $name_key = "name";

sub new {
    my $class = shift;

    my $self = {
        "name" => shift,
        "age"  => shift,
    };

    bless( $self, $class );

    return $self;
}

sub greet {
    my ( $self, $other ) = @_;

    my $own_age    = $self->{$age_key};
    my $other_age  = $other->{$age_key};
    my $own_name   = $self->{$name_key};
    my $other_name = $other->{$name_key};

    my $age_comparator = "older than";
    if ( $own_age < $other_age ) {
        $age_comparator = "younger than";
    }
    elsif ( $own_age == $other_age ) {
        $age_comparator = "the same age as";
    }

    print(
        "Hello $other_name, my name is $own_name and I'm $own_age years old.\n"
    );
    print("Seems like I'm $age_comparator you.\n");
}

1;
