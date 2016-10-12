use CubaTechBot;
use ConfigReader;
use Command::EchoCommand;
use Command::HelpCommand;
use Command::NameVoteCommand;
use Command::MemeGeneratorCommand;
use ImgflipAPI;

$configFile = @ARGV[0] or 'config.json';
my $config = ConfigReader->new(configFile => $configFile);

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
    Command::HelpCommand->new($cbt),
    Command::NameVoteCommand->new(progressFile => 'votes.json'),
    Command::MemeGeneratorCommand->new(
        ImgflipAPI->new(
            username => $config->configData->{imgflip_api}->{username},
            password => $config->configData->{imgflip_api}->{password}
        )
    )
);

$cbt->start_RTM;

while(1) { sleep 10; print "I'm not dead\n"; }
