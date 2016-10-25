use strict;
use warnings;

use Test::Simple tests => 5;
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
help - prints this message, for specific help on a command do "help <command>"

*Commands:*
robot echo - echoes the rest of the line
robot help - prints this message, for specific help on a command do "help <command>"
END
my $ci = Command::CommandInstruction->new(
    text =>'help'
);
ok((join '', (sort (split /\n/, $helpCommand->process($ci)))) eq (join '', (sort (split /\n/, $output))));

$ci = Command::CommandInstruction->new(
    text =>'help echo'
);
ok($helpCommand->process($ci) eq $echoCommand->{help});

$ci = Command::CommandInstruction->new(
    text =>'help unknown-command'
);
ok($helpCommand->process($ci) eq 'unknown command');
