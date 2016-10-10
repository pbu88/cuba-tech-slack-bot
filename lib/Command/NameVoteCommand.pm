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
    my $commandInstruction = shift;
    my $msg = $commandInstruction->text;
    my @words = split / /, $msg;

    $words[0] eq $self->name;
}

sub process {
    my $self = shift;
    my $commandInstruction = shift;
    my $msg = $commandInstruction->text;
    die 'command instruction must have a user' unless $commandInstruction->user;
    my $outputFn = shift;

    if (not $self->canProcess($commandInstruction)) {
        return;
    }
    
    my @words = split / /, $msg;
    shift @words;

    my $action = shift @words;

    my $res = '';
    if ($action eq 'results') {
        $res = $self->outputResults;
    } elsif ($action eq 'vote') {
        my $name = join ' ', @words;
        if (! $name) {
            $res = 'please suggest a name';
        }
        if (not $self->canRegisterVote($name, $commandInstruction->user)) {
            $res = "you cannot vote twice for $name";
        } else {
            $self->registerVote($name, $commandInstruction->user);
            $self->saveProgressToJsonFile;
            $res = "name '$name' was registered";
        }
    } else {
        $res = 'unknown action, please use *results* or *vote*'
    }
    
    $self->_output($res, $commandInstruction);
}

sub outputResults {
    my $self = shift;
    my $res = '';
    my $intermediateCalculation = {};
    foreach my $name (keys $self->{results} ) {
        $intermediateCalculation->{$name} = $self->{results}{$name}{count};
    }
    foreach my $name (sort { $intermediateCalculation->{$b} <=> $intermediateCalculation->{$a} } keys $intermediateCalculation) {
        $res .= "$name - $intermediateCalculation->{$name}\n";
    }
    $res;
}

sub canRegisterVote {
    my ($self, $name, $user) = @_;
    if (! $self->{results}->{$name}) {
        return 1;
    }
    not grep /$user$/, @{$self->{results}->{$name}{voters}};
}

sub registerVote {
    my ($self, $name, $user) = @_;
    if (! $self->{results}->{$name}) {
        $self->{results}{$name}{count} = 0;
        @{$self->{results}{$name}{voters}} = ();
    }
    $self->{results}{$name}{count} += 1;
    push @{$self->{results}{$name}{voters}}, $user;
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
