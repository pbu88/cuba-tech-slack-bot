package Command::EchoCommand;
use parent 'Command::BaseCommand';

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        'name'        => 'echo',
        'description' => 'echoes the rest of the line'
    );
    $self;
}

sub canProcess {
    my $self = shift;
    my $msg = shift;
    my @words = split / /, $msg;

    $words[0] eq $self->name;
}

sub process {
    my $self = shift;
    my $msg = shift;
    my $outputFn = shift;

    if (not $self->canProcess($msg)) {
        return;
    }
    
    my @words = split / /, $msg;
    shift @words;
    
    my $res = join ' ', @words;

    if ($outputFn) {
        $outputFn->($res);
    } else {
        $res;
    }
}

1;
