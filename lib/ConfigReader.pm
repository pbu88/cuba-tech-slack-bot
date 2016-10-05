package ConfigReader;

use JSON;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $dict = {
        @_
    };
    die 'need config file' unless $dict->{configFile};

    my $self = bless $dict, $class;
    $self->_readConfigFile;
    $self;
}

sub _readConfigFile {
    my $self = shift;
    my $json_text = do {
        open(my $json_fh, "<:encoding(UTF-8)", $self->{configFile})
            or die("Can't open \"$self->{configFile}\": $!\n");
        local $/;
        <$json_fh>
    };

    my $json = JSON->new;
    my $data = $json->decode($json_text);
    $self->{configData} = $data;
}

sub configData {
    my $self = shift;
    $self->{configData};
}

1;
