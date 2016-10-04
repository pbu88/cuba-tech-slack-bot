use Test::Simple tests => 4;
use CubaTechBot;
use Command::EchoCommand;

$cbt = CubaTechBot->new(token => 'token');
ok($cbt);

ok(scalar $cbt->getPrivateMessageHandlers == 0);

$echoCmd = Command::EchoCommand->new;
$cbt->addPrivateMessageHanlder($echoCmd);
ok(scalar $cbt->getPrivateMessageHandlers == 1);

ok($cbt->processMessage('echo hello') eq 'hello');
