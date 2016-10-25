use Test::Simple tests => 14;
use Test::Mock::Simple;
use CubaTechBot;
use Command::EchoCommand;

use Data::Dumper;

# Mock say method and store its output in a variable
my $mock = Test::Mock::Simple->new(module => 'CubaTechBot');
$mock->add(say => sub {
    $self = shift;
    $replyMsg = {@_};
    $self->{sayOutput} = $replyMsg->{text};
});

$cbt = CubaTechBot->new(
    'nickname' => 'robot',
    token => 'token'
);
ok($cbt);

ok(scalar values $cbt->getPrivateMessageHandlers == 0);

$echoCmd = Command::EchoCommand->new;
$cbt->addPrivateMessageHanlder($echoCmd);
ok(scalar values $cbt->getPrivateMessageHandlers == 1);

$msg = bless {
    'type' => 'message',
    'reply_to' => undef,
    'channel' => '@pbu',
    'text' => 'echo hello',
    'user' => 'someone',
    'ts' => '1475598989.000029'
}, 'Message';

ok(not $cbt->isCommand($msg));
ok($cbt->isPrivateMessage($msg));
$cbt->processMessage($msg);
ok($cbt->{sayOutput} eq 'hello');
$cbt->{sayOutput} = '';

$msg = bless {
    'type' => 'message',
    'reply_to' => undef,
    'channel' => 'general',
    'text' => 'robot echo hello',
    'user' => 'someone',
    'ts' => '1475598989.000029'
}, 'Message';

ok($cbt->isCommand($msg));
ok(not $cbt->isPrivateMessage($msg));

$cbt->addCommandHandler($echoCmd);
ok(scalar values $cbt->getCommandHandlers == 1);
$cbt->processMessage($msg);
ok($cbt->{sayOutput} eq 'hello');
$cbt->{sayOutput} = '';

$msg = bless {
    'type' => 'message',
    'reply_to' => undef,
    'channel' => 'general',
    'text' => 'echo hello',
    'user' => 'someone',
    'ts' => '1475598989.000029'
}, 'Message';

ok(not $cbt->isCommand($msg));
ok(not $cbt->isPrivateMessage($msg));

$cbt->addGeneralHandler($echoCmd);
ok(scalar values $cbt->getGeneralHandlers == 1);
ok($cbt->processMessage($msg) eq 'hello');
$cbt->{sayOutput} = '';
