package Command::HelpCommand;
use parent 'Command::BaseCommand';

use Data::Dumper;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $bot = shift;
    my $self = $class->SUPER::new(
        'name'        => 'help',
        'description' => 'prints this message'
    );
    $self->{bot} = $bot;
    $self;
}

sub canProcess {
    my $self = shift;
    my $msg = shift;
    $msg eq 'help';
}

sub process {
    my $self = shift;
    my $msg = shift;
    my $outputFn = shift;

    if (not $self->canProcess($msg)) {
        return;
    }

    my $res = "*Private Message Commands:*\n";
    foreach my $handler ($self->{bot}->getPrivateMessageHandlers) {
        $res .= $handler->name . " - " . $handler->description . "\n";
    }
    
    $res .= "\n*Commands:*\n";
    foreach my $handler ($self->{bot}->getCommandHandlers) {
        $res .= $self->{bot}->nickname . " " .$handler->name . " - " . $handler->description . "\n";
    }
    
    if ($outputFn) {
        $outputFn->($res);
    } else {
        $res;
    }
}

1;
