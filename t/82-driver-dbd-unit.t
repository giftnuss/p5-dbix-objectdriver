
use strict;
use warnings;

use Test::More tests => 6;

my $class;
BEGIN { $class = 'DBIx::ObjectDriver::Driver::DBD' }; 

use_ok $class;

eval { $class->new };
like($@,qr/No Driver/,'dies when no name given');

my @want = (
    'mysql',
    'SQLite', 
    'Pg',
    'Oracle' 
);

foreach my $driver (@want) {
    my $expectedclass = $class . '::' . $driver;
    
    SKIP: {
        eval "require DBD::$driver";
        skip "class DBD::$driver not installed",1 if $@;
        my $dbd = $class->new($driver);
        isa_ok($dbd, $expectedclass);
    };
}
