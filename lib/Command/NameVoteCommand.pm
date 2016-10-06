package Command::NameVoteCommand;
use parent 'Command::BaseCommand';

use JSON;
use Data::Dumper;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        'name'        => 'name-vote',
        'description' => 'a command to vote for a name to the bot (name-vote results will give you the results so far)'
    );

    my %args = @_;
    die unless $args{progressFile};

    $self->{progressFile} = $args{progressFile};
    $self->{results} = {};
    $self->_readResultsFromFileIfExists;
    $self;
}

sub _readResultsFromFileIfExists {
    my $self = shift;
    if (-e $self->{progressFile}) {
        my $json_text = do {
            open(my $json_fh, "<:encoding(UTF-8)", $self->{progressFile});
            local $/;
            <$json_fh>
        };
        my $json = JSON->new;
        my $data = $json->decode($json_text);
        $self->{results} = $data;
    }
};

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

    my $action = shift @words;

    my $res = '';
    if ($action eq 'results') {
        foreach my $name (sort { $self->{results}{$b} <=> $self->{results}{$a} } keys $self->{results}) {
            $res .= "$name - $self->{results}{$name}\n";
        }
    } elsif ($action eq 'register') {
        my $name = shift @words;
        if (! $name) {
            $res = 'please suggest a name';
        }
        $self->{results}->{$name} = 0 unless $self->{results}->{$name};
        $self->{results}->{$name} += 1;
        $self->saveProgressToJsonFile;
        $res = "name $name was registered";
    } else {
        $res = 'unknown action, please use *results* or *register*'
    }
    
    if ($outputFn) {
        $outputFn->($res);
    } else {
        $res;
    }
}

sub saveProgressToJsonFile {
    my $self = shift;
    my $json = encode_json $self->{results};
    open my $fh, ">",$self->{progressFile};
    print $fh $json;
    close $fh;
    $json;
}

sub results {
    my $self = shift;
    $self->{results}
}

1;
