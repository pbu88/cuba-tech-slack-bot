use Test::Simple tests => 7;
use Command::EchoCommand;
use Command::CommandInstruction;

use strict;
use warnings;

my $echoCommand = Command::EchoCommand->new;
ok($echoCommand);
ok($echoCommand->name eq 'echo');

my $ci = Command::CommandInstruction->new(
    text => 'echo hello'
);
ok ($echoCommand->canProcess($ci));
$ci = Command::CommandInstruction->new(
    text => 'othercmd echo hello'
);
ok (not $echoCommand->canProcess($ci));

$ci = Command::CommandInstruction->new(
    text => 'echo hello'
);
ok ($echoCommand->process($ci) eq 'hello');
$ci = Command::CommandInstruction->new(
    text => 'othercmd echo hello'
);
ok (not $echoCommand->process($ci));

sub callback {
    ok(shift eq 'hello');
}
$ci = Command::CommandInstruction->new(
    text =>'echo hello',
    callback => \&callback
);
$echoCommand->process($ci, \&callback);
