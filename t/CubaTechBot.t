use Test::Simple tests => 14;
use CubaTechBot;
use Command::EchoCommand;

$cbt = CubaTechBot->new(
    'nickname' => 'robot',
    token => 'token'
);
ok($cbt);

ok(scalar $cbt->getPrivateMessageHandlers == 0);

$echoCmd = Command::EchoCommand->new;
$cbt->addPrivateMessageHanlder($echoCmd);
ok(scalar $cbt->getPrivateMessageHandlers == 1);

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
ok($cbt->processMessage($msg) eq 'hello');

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
ok(scalar $cbt->getCommandHandlers == 1);
ok($cbt->processMessage($msg) eq 'hello');

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
ok(scalar $cbt->getGeneralHandlers == 1);
ok($cbt->processMessage($msg) eq 'hello');
