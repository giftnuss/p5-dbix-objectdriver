
use strict;
use warnings;

use Test::More tests => 2;

use_ok 'DBIx::ObjectDriver';

my $driver = DBIx::ObjectDriver->new;
isa_ok($driver,'DBIx::ObjectDriver','plain constructor works');

#$driver->with('a' => 'b');
#is($driver->record_map->{'a'},'b');
