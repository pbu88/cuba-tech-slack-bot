use ConfigReader;
use Test::Simple tests => 3;

use strict;
use warnings;

my $cr = ConfigReader->new(configFile => 't/config-test.json');
ok($cr);
ok($cr->configData->{bot}->{nickname} eq 'test-bot');
ok($cr->configData->{bot}->{token} eq 'test-token');
