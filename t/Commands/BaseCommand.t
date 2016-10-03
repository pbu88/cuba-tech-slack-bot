use Test::Simple tests => 3;
use Command::BaseCommand;

$baseCommand = Command::BaseCommand->new(
    'name'        => '',
    'description' => 'base command'
);
ok($baseCommand);
ok($baseCommand->description eq 'base command');
ok($baseCommand->name eq '');

