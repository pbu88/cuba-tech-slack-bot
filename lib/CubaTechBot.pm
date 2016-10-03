use strict;
use warnings;

package CubaTechBot;
use parent 'Slack::RTM::Bot';

use Data::Dumper;

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

1;
