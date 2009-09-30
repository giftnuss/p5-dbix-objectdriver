# $Id$

use strict;

use lib 't/lib';
use lib '../p5-ho-class/lib';
use lib '../p5-ho-trigger/lib';

require 't/lib/db-common.pl';

use Test::More;
unless (eval { require DBD::SQLite }) {
    plan skip_all => 'Tests require DBD::SQLite';
}
plan tests => 17;

setup_dbs({
    global => [ qw( wines ) ],
});

use Wine;

my $wine = Wine->new;

my %expected = map { $_ => 1 } qw(name rating id cluster_id content binchar); 
my %data;
# I know about Test::Deep. Do not ask...
for my $col (@{ $wine->column_names }) {
    $data{$col}++;
    ok $expected{$col}, "$col was expected";
}
for my $col (keys %expected) {
    ok $data{$col}, "expected column $col is present"; 
}

$wine->name("Saumur Champigny, Le Grand Clos 2001");
$wine->rating(4);

ok($wine->save, 'Object saved successfully');

my $id = $wine->id;
ok($id > 0,'new pk > 0');

my $obj = $wine->lookup($id);
isa_ok($obj,'DBIx::ObjectDriver::BaseObject');

ok ($obj->id == $id,'id matches');
ok ($obj->rating == 4,'rating matches');

sub DESTROY { teardown_dbs(qw( global )); }
