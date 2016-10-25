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
        'description' => 'prints this message, for specific help on a command do "help <command>"'
    );
    $self->{bot} = $bot;
    $self;
}

sub canProcess {
    my $self = shift;
    my $commandInstruction = shift;
    my $msg = $commandInstruction->text;

    my @words = split / /, $msg;
    $words[0] eq 'help';
}

sub _generateOverallHelp {
    my $self = shift;
    my $commandInstruction = shift;
    my $msg = $commandInstruction->text;

    my $res = "*Private Message Commands:*\n";
    my $handlers = $self->{bot}->getPrivateMessageHandlers;
    foreach my $key (keys $handlers) {
        $res .= $handlers->{$key}->name . " - " . $handlers->{$key}->description . "\n";
    }
    
    $res .= "\n*Commands:*\n";
    $handlers = $self->{bot}->getCommandHandlers;
    for my $key (keys $handlers) {
        $res .= $self->{bot}->nickname . " " .$handlers->{$key}->name . " - " . $handlers->{$key}->description . "\n";
    }

    $res;
}

sub _generateCommandHelp {
    my $self = shift;
    my $commandName = shift;
    my $commandInstruction = shift;

    if ($commandInstruction->isPrivate) {
        my $handler = $self->{bot}->getPrivateMessageHandlers->{$commandName};
        defined $handler ? $handler->help : 'unknown command';
    } else {
        my $handler = $self->{bot}->getCommandHandlers->{$commandName};
        defined $handler ? $handler->help : 'unknown command';
    }
}

sub process {
    my $self = shift;
    my $commandInstruction = shift;
    print Dumper($commandInstruction);
    my $msg = $commandInstruction->text;
    my $outputFn = shift;

    if (not $self->canProcess($commandInstruction)) {
        return;
    }

    my @words = split / /, $msg;
    
    my $res;
    if ((scalar @words) == 1) {
        $res = $self->_generateOverallHelp($commandInstruction);
    } else {
        $res = $self->_generateCommandHelp($words[1], $commandInstruction);
    }
    
    $self->_output($res, $commandInstruction);
}

1;
