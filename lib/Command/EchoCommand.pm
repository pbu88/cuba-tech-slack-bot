package EchoCommand;

use strict;
use warnings;

use Data::Dumper;


sub new {
    my $class = shift;
    my $self = {};

    bless $self, $class;
}

sub canProcess {
    my $self = shift;
    my $msg = shift;
    my @words = split / /, $msg;

    $words[0] eq 'echo'
}

sub process {
    my $self = shift;
    my $msg = shift;

    if (not $self->canProcess($msg)) {
        return;
    }
    
    my @words = split / /, $msg;
    shift @words;

    join ' ', @words;
}

1;
