use Test::Simple tests => 13;
use Test::Mock::Simple;
use Command::MemeGeneratorCommand;
use Command::CommandInstruction;
use ImgflipAPI;
use JSON;

use strict;
use warnings;

# Mock caption_image method and store its output in a variable
my $imgflipApiResponse = <<'END';
{
    "success": true,
    "data": {
        "url": "http://i.imgflip.com/123abc.jpg",
        "page_url": "https://imgflip.com/i/123abc"
    }
}
END
my $mock = Test::Mock::Simple->new(module => 'ImgflipAPI');
$mock->add(caption_image => sub {
    my $json = JSON->new;
    return $json->decode($imgflipApiResponse);
});

my $memeCommand = Command::MemeGeneratorCommand->new(
    ImgflipAPI->new(username => 'username', password => 'passwd')
);
ok($memeCommand);
ok($memeCommand->name eq 'meme');

my $ci = Command::CommandInstruction->new(
    text => 'echo hello'
);
ok (not $memeCommand->canProcess($ci));

$ci = Command::CommandInstruction->new(
    text => 'meme batman-and-robin'
);
ok (not $memeCommand->canProcess($ci));

$ci = Command::CommandInstruction->new(
    text => 'meme batman-and-robin "upper text"'
);
ok (not $memeCommand->canProcess($ci));

$ci = Command::CommandInstruction->new(
    text => 'meme batman-and-robin "upper text" "lower text"'
);
ok ($memeCommand->canProcess($ci));

$ci = Command::CommandInstruction->new(
    text => "ctb meme batman-and-robin \x{201c}hello hello\x{2026}\x{201d} \x{201c}bye!\""
);
ok ($memeCommand->canProcess($ci));

my @r = $memeCommand->_match_command_text('meme batman-and-robin "hello" "goodbye"');
ok($r[0] eq 'batman-and-robin');
ok($r[1] eq 'hello');
ok($r[2] eq 'goodbye');

@r = $memeCommand->_match_command_text('mem batman-and-robin "hello" "goodbye"');
ok(not defined $r[1]);

$ci = Command::CommandInstruction->new(
    text => 'meme batman-and-robin "upper text" "lower text"'
);

ok($memeCommand->process($ci) eq "http://i.imgflip.com/123abc.jpg");

$ci = Command::CommandInstruction->new(
    text => 'meme unknown-template "upper text" "lower text"'
);

ok($memeCommand->process($ci) eq "unknown template");
