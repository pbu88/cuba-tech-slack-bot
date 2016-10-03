use Test::Simple tests => 5;
use Command::EchoCommand;

$echoCommand = EchoCommand->new;
ok($echoCommand);

ok ($echoCommand->canProcess('echo hello'));

ok (not $echoCommand->canProcess('othercmd hello'));

ok ($echoCommand->process('echo hello') eq 'hello');

ok (not $echoCommand->process('othercmd hello'));
