package CubaTechBot;
use parent 'Slack::RTM::Bot';

use strict;
use warnings;

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);

    @{$self->{pmHandlers}} = ();

    return $self
}

sub addPrivateMessageHanlder {
    my $self = shift;
    my $pmh = shift;

    push @{$self->{pmHandlers}}, $pmh;
}

sub getPrivateMessageHandlers {
    my $self = shift;
    @{$self->{pmHandlers}};
}

sub processMessage {
    my $self = shift;
    my $msg = shift;

    foreach my $handler ($self->getPrivateMessageHandlers) {
        if ($handler->canProcess($msg)) {
            return $handler->process($msg);
        }
    }
}

1;
