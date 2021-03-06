package Command::CommandInstruction;

sub new {
    my $class = shift;
    my $dict = {
        @_
    };
    die 'need instruction text' unless $dict->{text};

    my $self = bless $dict, $class;
    $self;
}

sub text {
    shift->{text};
}

sub user {
    shift->{user};
}

sub callback {
    shift->{callback};
}

sub isPrivate {
    shift->{isPrivate};
}

1;
