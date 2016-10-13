use strict;
use warnings;

use Test::Simple tests => 3;
use Command::HelpCommand;
use Command::EchoCommand;
use CubaTechBot;

my $cbt = CubaTechBot->new(
    nickname => 'robot',
    token => 'token'
);
my $helpCommand = Command::HelpCommand->new($cbt);
my $echoCommand = Command::EchoCommand->new;

$cbt->addPrivateMessageHanlders(
    $echoCommand,
    $helpCommand
);

$cbt->addCommandHandlers(
    $echoCommand,
    $helpCommand
);

ok($helpCommand);
ok($helpCommand->name eq 'help');
my $output = <<'END';
*Private Message Commands:*
echo - echoes the rest of the line
help - prints this message

*Commands:*
robot echo - echoes the rest of the line
robot help - prints this message
END
my $ci = Command::CommandInstruction->new(
    text =>'help'
);
ok((join '', (sort (split /\n/, $helpCommand->process($ci)))) eq (join '', (sort (split /\n/, $output))));
