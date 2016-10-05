use ConfigReader;
use Test::Simple tests => 1;

use strict;
use warnings;

my $cr = ConfigReader->new(configFile => 't/config-test.json');
ok($cr);
ok($cr->configData->{bot}->{nickname} eq 'test-bot');
