package Command::EchoCommand;
use parent 'Command::BaseCommand';

use strict;
use warnings;

my $helpMsg = <<'END';
Will repeat the rest of the line, ie:
"echo hey what's up" will result in "hey what's up" being printed
END

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        name        => 'echo',
        description => 'echoes the rest of the line',
        help          => $helpMsg
    );
    $self;
}

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

    if (not $self->canProcess($commandInstruction)) {
        return;
    }
    
    my @words = split / /, $msg;
    shift @words;
    
    my $res = join ' ', @words;

    $self->_output($res, $commandInstruction);

}

1;
