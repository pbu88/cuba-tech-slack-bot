use Test::Simple tests => 1;
use Slack::RTM::Bot;

$bot = Slack::RTM::Bot->new(token => 'token');
ok($bot);
