package CubaTechBot;
use parent 'Slack::RTM::Bot';

use strict;
use warnings;

use Command::CommandInstruction;

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);

    $self->{pmHandlers} = {};
    $self->{commandHandlers} = {};
    $self->{generalHandlers} = {};

    $self->_registerEvents;

    return $self
}

sub _registerEvents {
    my $self = shift;
    $self->on({
            type => 'message',
            text => qr/.*/
        },
        sub {
            my ($response) = @_;
            if ($response->{user} ne 'paulo-bot') {
                $self->processMessage($response);
            }
        }
    );
}

sub nickname {
    my $self = shift;
    $self->{nickname};
}

sub addPrivateMessageHanlder {
    my $self = shift;
    my $h = shift;

    $self->{pmHandlers}->{$h->name} = $h;
}

sub addPrivateMessageHanlders {
    my $self = shift;
    my @handlers = @_;

    foreach my $h (@handlers) {
        $self->addPrivateMessageHanlder($h);
    }
}

sub getPrivateMessageHandlers {
    shift->{pmHandlers};
}

sub getCommandHandlers {
    shift->{commandHandlers};
}

sub getGeneralHandlers {
    my $self = shift;
    $self->{generalHandlers};
}

sub addCommandHandler {
    my $self = shift;
    my $h = shift;

    $self->{commandHandlers}->{$h->name} = $h;
}

sub addCommandHandlers {
    my $self = shift;
    my @handlers = @_;

    foreach my $h (@handlers) {
        $self->addCommandHandler($h);
    }
}


sub addGeneralHandler {
    my $self = shift;
    my $h = shift;

    $self->{generalHandlers}->{$h->name} = $h;

}

sub isPrivateMessage {
    my $self = shift;
    my $msg = shift;

    substr($msg->{channel}, 0, 1) eq '@';
}

sub isCommand {
    my $self = shift;
    my $msg = shift;

    my @words = split / /, $msg->{text};
    $words[0] eq $self->{nickname};
}

sub _getCommandInstructionCallback {
    my $self = shift;
    my $msg = shift;

    sub {
        my $res = shift;
        $self->say(
            channel => $msg->{channel},
            text    => $res
        ) if $res && $res ne '';

    };
}

sub processPrivateMessage {
    my $self = shift;
    my $msg = shift;
    
    my $commandInstruction = Command::CommandInstruction->new(
        text => $msg->{text},
        user => $msg->{user},
        callback => $self->_getCommandInstructionCallback($msg)
    );

    foreach my $handler (values $self->getPrivateMessageHandlers) {
        if ($handler->canProcess($commandInstruction)) {
            return $handler->process($commandInstruction);
        }
    }
}

sub isHelp {
    my $self = shift;
    my $msg = shift;

    $msg->{text} == 'help';
}

sub processCommand {
    my $self = shift;
    my $msg = shift;
    
    my @words = split / /, $msg->{text};
    shift @words;
    my $command = join ' ', @words;
    
    my $commandInstruction = Command::CommandInstruction->new(
        text => $command,
        user => $msg->{user},
        callback => $self->_getCommandInstructionCallback($msg)
    );

    foreach my $handler (values $self->getCommandHandlers) {
        if ($handler->canProcess($commandInstruction)) {
            return $handler->process($commandInstruction);
        }
    }
}

sub processGeneralMessage {
    my $self = shift;
    my $msg = shift;
    my $commandInstruction = Command::CommandInstruction->new(
        text => $msg->{text},
        user => $msg->{user},
        callback => $self->_getCommandInstructionCallback($msg)
    );

    foreach my $handler (values $self->getGeneralHandlers) {
        if ($handler->canProcess($commandInstruction)) {
            return $handler->process($commandInstruction);
        }
    }
}

sub processMessage {
    my $self = shift;
    my $msg = shift;

    if ($self->isPrivateMessage($msg)) {
        return $self->processPrivateMessage($msg);
    } elsif ($self->isCommand($msg)) {
        return $self->processCommand($msg);
    }
    $self->processGeneralMessage($msg);
}

1;
