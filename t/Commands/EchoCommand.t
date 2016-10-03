use Test::Simple tests => 7;
use Command::EchoCommand;

$echoCommand = Command::EchoCommand->new;
ok($echoCommand);
ok($echoCommand->name eq 'echo');

ok ($echoCommand->canProcess('echo hello'));
ok (not $echoCommand->canProcess('othercmd hello'));

ok ($echoCommand->process('echo hello') eq 'hello');
ok (not $echoCommand->process('othercmd hello'));

sub callback {
    ok(shift eq 'hello');
}
$echoCommand->process('echo hello', \&callback);
