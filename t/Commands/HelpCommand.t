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

$cbt->addPrivateMessageHanlder(
    $echoCommand
);
$cbt->addPrivateMessageHanlder(
    $helpCommand
);

$cbt->addCommandHandler(
    $echoCommand
);
$cbt->addCommandHandler(
    $helpCommand
);

ok($helpCommand);
ok($helpCommand->name eq 'help');
my $output = <<'END';
Private Message Commands:
echo - echoes the rest of the line
help - prints this message

Commands:
robot echo - echoes the rest of the line
robot help - prints this message
END
ok($helpCommand->process('help') eq $output);
