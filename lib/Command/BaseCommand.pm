package Command::BaseCommand;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        @_
    };

    bless $self, $class;
}

sub description {
    my $self = shift;
    $self->{description};
}

sub name {
    my $self = shift;
    $self->{name};
}

sub help {
    my $self = shift;
    $self->{help} or $self->description;
}

sub _output {
    my $self = shift;
    my $res = shift;
    my $commandInstruction = shift;

    if ($commandInstruction->callback) {
        $commandInstruction->callback->($res);
    } else {
        $res;
    }
}

1;
