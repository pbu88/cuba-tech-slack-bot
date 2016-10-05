use CubaTechBot;
use ConfigReader;
use Command::EchoCommand;
use Command::HelpCommand;

use Data::Dumper;


my $config = ConfigReader->new(configFile => 'config.json');

my $cbt = CubaTechBot->new(
    nickname => $config->configData->{bot}->{nickname},
    token => $config->configData->{bot}->{token}
);

$cbt->addPrivateMessageHanlders(
    Command::EchoCommand->new,
    Command::HelpCommand->new($cbt)
);

$cbt->addCommandHandlers(
    Command::EchoCommand->new,
    Command::HelpCommand->new($cbt)
);

$cbt->start_RTM;

while(1) { sleep 10; print "I'm not dead\n"; }
