package ImgflipAPI;

use HTTP::Request::Common;
use LWP::UserAgent;
use JSON;

use strict;
use warnings;

my @captionImageRequiredFields = (
    'template_id',
    'text0',
    'text1',
);

my $captionImageAPIEndpoint = 'https://api.imgflip.com/caption_image';

sub new {
    my $pkg = shift;
    my $args = {@_};
    die 'username and password are requires' unless $args->{username} and $args->{password};
    bless $args, $pkg
}

sub _validate_caption_image_data {
    my $self = shift;
    my $data = {@_};

    for my $rf (@captionImageRequiredFields) {
        return 0 unless $data->{$rf};
    }

    1;

}

sub caption_image {
    my $self = shift;
    if (not $self->_validate_caption_image_data(@_)) {
        warn 'missing arguments for caption_image imgflip api call';
        return;
    }
    my $data = {@_};
    $data->{username} = $self->{username};
    $data->{password} = $self->{password};

    my $ua = LWP::UserAgent->new;
    $ua->agent('PerlSlackBot - https://github.com/pbu88/cuba-tech-slack-bot');
    my $r = $ua->request(POST $captionImageAPIEndpoint, $data);
    my $json = JSON->new;
    $json->decode($r->content);
}

1;
