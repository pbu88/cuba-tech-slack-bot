use Test::Simple tests => 18;
use Command::NameVoteCommand;
use Command::CommandInstruction;
use Data::Dumper;

my $tmpFileForTest = "/tmp/test-name-vote-command".time;
my $nameCommand = Command::NameVoteCommand->new(
    progressFile => $tmpFileForTest
);
ok($nameCommand);

ok($nameCommand->name eq 'name-vote');

my $ci = Command::CommandInstruction->new(
    text =>'name-vote vote paulo',
    user =>'pbu'
);
ok ($nameCommand->canProcess($ci));
$ci = Command::CommandInstruction->new(
    text =>'name-vote results',
    user =>'pbu'
);
ok ($nameCommand->canProcess($ci));
ok (not -e $tmpFileForTest);  # file exists after registering

$ci = Command::CommandInstruction->new(
    text =>'name-vote vote paulo',
    user =>'pbu'
);
ok ($nameCommand->process($ci) eq "name 'paulo' was registered");
ok ( -e $tmpFileForTest);  # file exists after registering
ok ($nameCommand->results->{paulo}{count} == 1);
ok ($nameCommand->process($ci) eq "you cannot vote twice for paulo");
$ci = Command::CommandInstruction->new(
    text =>'name-vote vote paulo',
    user =>'pbu1'
);
ok ($nameCommand->process($ci) eq "name 'paulo' was registered");
ok ($nameCommand->results->{paulo}{count} == 2);
$ci = Command::CommandInstruction->new(
    text =>'name-vote vote pepe',
    user =>'pbu'
);
ok ($nameCommand->process($ci) eq "name 'pepe' was registered");
ok ($nameCommand->results->{pepe}{count} == 1);
my $output = <<'END';
paulo - 2
pepe - 1
END
$ci = Command::CommandInstruction->new(
    text =>'name-vote results',
    user =>'pbu'
);
ok ($nameCommand->process($ci) eq $output);
    
# test if the json file was saved correctly
my $json_text = do {
    open(my $json_fh, "<:encoding(UTF-8)", $tmpFileForTest);
    local $/;
    <$json_fh>
};

my $json = JSON->new;
my $data = $json->decode($json_text);
ok ($data->{paulo}{count} == 2 and $data->{pepe}{count} == 1);


my $nameCommand1 = Command::NameVoteCommand->new(
    progressFile => $tmpFileForTest
);

$output = <<'END';
paulo - 2
pepe - 1
END
$ci = Command::CommandInstruction->new(
    text =>'name-vote results',
    user =>'pbu'
);
ok ($nameCommand1->process($ci) eq $output);
$ci = Command::CommandInstruction->new(
    text =>'name-vote vote pepe',
    user =>'pbu'
);
ok ($nameCommand1->process($ci) eq "you cannot vote twice for pepe");

# test multiple words name
$ci = Command::CommandInstruction->new(
    text =>'name-vote vote bot is so cool',
    user =>'pbu'
);
ok ($nameCommand->process($ci) eq "name 'bot is so cool' was registered");

