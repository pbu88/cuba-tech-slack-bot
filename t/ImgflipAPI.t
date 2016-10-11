use ImgflipAPI;
use Test::Simple tests => 6;
use Mozilla::CA;

use strict;
use warnings;

my $imgflip = ImgflipAPI->new (
    username => 'uname',
    password => 'pwd'
);
ok($imgflip);

ok(not $imgflip->_validate_caption_image_data(
    #template_id => '80874672',
    text0 => 'ARGG',
    text1 => 'NO',
));

ok(not $imgflip->_validate_caption_image_data(
    template_id => '80874672',
    #text0 => 'ARGG',
    text1 => 'NO',
));

ok(not $imgflip->_validate_caption_image_data(
    template_id => '80874672',
    text0 => 'ARGG',
    #text1 => 'NO',
));

# Commenting out these tests because they do actually query Imgflip
#my $r = $imgflip->caption_image(
#    template_id => '80874672',
#    text0 => 'ARGG',
#    text1 => 'NO',
#);
#ok($r->{success});
#ok($r->{data}->{url});
