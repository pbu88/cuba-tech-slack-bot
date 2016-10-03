use Test::Simple tests => 3;
use CubaTechBot;

$cbt = CubaTechBot->new(token => 'token');
ok($cbt);

ok(scalar $cbt->getPrivateMessageHandlers == 0);

$cbt->addPrivateMessageHanlder('pmh');
ok(scalar $cbt->getPrivateMessageHandlers == 1);
