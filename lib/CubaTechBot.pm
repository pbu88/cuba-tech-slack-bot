package CubaTechBot;
use parent 'Slack::RTM::Bot';

use strict;
use warnings;

use Data::Dumper;

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);

    @{$self->{pmHandlers}} = ();
    @{$self->{commandHandlers}} = ();
    @{$self->{generalHandlers}} = ();

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
            print Dumper(@_);
            my ($response) = @_;
            if ($response->{user} ne 'paulo-bot') {
                my $res = $self->processMessage($response);
                $self->say(
                    channel => $response->{channel},
                    text    => $res
                );
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

    push @{$self->{pmHandlers}}, $h;
}

sub getPrivateMessageHandlers {
    my $self = shift;
    @{$self->{pmHandlers}};
}

sub getCommandHandlers {
    my $self = shift;
    @{$self->{commandHandlers}};
}

sub getGeneralHandlers {
    my $self = shift;
    @{$self->{generalHandlers}};
}

sub addCommandHandler {
    my $self = shift;
    my $h = shift;

    push @{$self->{commandHandlers}}, $h;
}

sub addGeneralHandler {
    my $self = shift;
    my $h = shift;

    push @{$self->{generalHandlers}}, $h;
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

sub processPrivateMessage {
    my $self = shift;
    my $msg = shift;

    foreach my $handler ($self->getPrivateMessageHandlers) {
        if ($handler->canProcess($msg->{text})) {
            return $handler->process($msg->{text});
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


    foreach my $handler ($self->getCommandHandlers) {
        if ($handler->canProcess($command)) {
            return $handler->process($command);
        }
    }
}

sub processGeneralMessage {
    my $self = shift;
    my $msg = shift;

    foreach my $handler ($self->getGeneralHandlers) {
        if ($handler->canProcess($msg->{text})) {
            return $handler->process($msg->{text});
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
