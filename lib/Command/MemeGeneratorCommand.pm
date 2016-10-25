package Command::MemeGeneratorCommand;
use parent 'Command::BaseCommand';

use strict;
use warnings;

my %templateNameToId = (
    'batman-and-robin' => '80874672',
);

my @templateNamesForHelpCommand = join ', ', keys %templateNameToId;
my $helpMsg = qq{
Meme Generator: meme <template name> "<upper text>" "<lower text>"
Templates available:
@templateNamesForHelpCommand
};

sub new {
    my $class = shift;
    my $imgflipClient = shift;
    die 'imgflip client is necessary' unless $imgflipClient;
    my $self = $class->SUPER::new(
        name        => 'meme',
        description => 'generates a meme by querying to imgflip',
        help        => $helpMsg
    );

    $self->{imgflipClient} = $imgflipClient;

    $self;
}

sub canProcess {
    my $self = shift;
    my $commandInstruction = shift;
    my $msg = $commandInstruction->text;

    my @r = $self->_match_command_text($msg);

    # all groups from the regex must be defined
    not grep { not defined } @r ;
}

sub _match_command_text {
    my $self = shift;
    my $text = shift;
    my ($templateName, $textUp, $textDown) = $text =~ m/$self->{name} (\S+) ["\x{201c}](.*)["\x{201d}] ["\x{201c}](.*)["\x{201d}]/;
}

sub process {
    my $self = shift;
    my $commandInstruction = shift;
    my $msg = $commandInstruction->text;

    if (not $self->canProcess($commandInstruction)) {
        return;
    }
    
    my ($templateName, $textUp, $textDown) = $self->_match_command_text($msg);
    my $templateId = $templateNameToId{$templateName};

    return $self->_output('unknown template', $commandInstruction) unless $templateId;

    my $r = $self->{imgflipClient}->caption_image(
        template_id => $templateId,
        text0 => $textUp,
        text1 => $textDown
    );

    $self->_output($r->{data}->{url}, $commandInstruction);
}

1;
