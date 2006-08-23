# $Id$

use strict;

use Data::ObjectDriver::SQL;
use Test::More tests => 53;

my $stmt = ns();
ok($stmt, 'Created SQL object');

## Testing FROM
$stmt->from([ 'foo' ]);
is($stmt->as_sql, "FROM foo\n");

$stmt->from([ 'foo', 'bar' ]);
is($stmt->as_sql, "FROM foo, bar\n");

## Testing JOINs
$stmt->from([]);
$stmt->joins([]);
$stmt->add_join(foo => { type => 'inner', table => 'baz',
                         condition => 'foo.baz_id = baz.baz_id' });
is($stmt->as_sql, "FROM foo INNER JOIN baz ON foo.baz_id = baz.baz_id\n");

$stmt->from([ 'bar' ]);
is($stmt->as_sql, "FROM foo INNER JOIN baz ON foo.baz_id = baz.baz_id, bar\n");

$stmt->from([]);
$stmt->joins([]);
$stmt->add_join(foo => [
        { type => 'inner', table => 'baz b1',
          condition => 'foo.baz_id = b1.baz_id AND b1.quux_id = 1' },
        { type => 'left', table => 'baz b2',
          condition => 'foo.baz_id = b2.baz_id AND b2.quux_id = 2' },
    ]);
is $stmt->as_sql, "FROM foo INNER JOIN baz b1 ON foo.baz_id = b1.baz_id AND b1.quux_id = 1 LEFT JOIN baz b2 ON foo.baz_id = b2.baz_id AND b2.quux_id = 2\n";

## Testing GROUP BY
$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->group({ column => 'baz' });
is($stmt->as_sql, "FROM foo\nGROUP BY baz\n", 'single bare group by');

$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->group({ column => 'baz', desc => 'DESC' });
is($stmt->as_sql, "FROM foo\nGROUP BY baz DESC\n", 'single group by with desc');

$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->group([ { column => 'baz' }, { column => 'quux' }, ]);
is($stmt->as_sql, "FROM foo\nGROUP BY baz, quux\n", 'multiple group by');

$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->group([ { column => 'baz',  desc => 'DESC' },
               { column => 'quux', desc => 'DESC' }, ]);
is($stmt->as_sql, "FROM foo\nGROUP BY baz DESC, quux DESC\n", 'multiple group by with desc');

## Testing ORDER BY
$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->order({ column => 'baz', desc => 'DESC' });
is($stmt->as_sql, "FROM foo\nORDER BY baz DESC\n", 'single order by');

$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->order([ { column => 'baz',  desc => 'DESC' },
               { column => 'quux', desc => 'ASC'  }, ]);
is($stmt->as_sql, "FROM foo\nORDER BY baz DESC, quux ASC\n", 'multiple order by');

## Testing GROUP BY plus ORDER BY
$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->group({ column => 'quux' });
$stmt->order({ column => 'baz', desc => 'DESC' });
is($stmt->as_sql, "FROM foo\nGROUP BY quux\nORDER BY baz DESC\n", 'group by with order by');

## Testing LIMIT and OFFSET
$stmt = ns();
$stmt->from([ 'foo' ]);
$stmt->limit(5);
is($stmt->as_sql, "FROM foo\nLIMIT 5\n");
$stmt->offset(10);
is($stmt->as_sql, "FROM foo\nLIMIT 5 OFFSET 10\n");
$stmt->limit("  15g");  ## Non-numerics should cause an error
{
    my $sql = eval { $stmt->as_sql };
    like($@, qr/Non-numerics/, "bogus limit causes as_sql assertion");
}

## Testing WHERE
$stmt = ns(); $stmt->add_where(foo => 'bar');
is($stmt->as_sql_where, "WHERE (foo = ?)\n");
is(scalar @{ $stmt->bind }, 1);
is($stmt->bind->[0], 'bar');

$stmt = ns(); $stmt->add_where(foo => [ 'bar', 'baz' ]);
is($stmt->as_sql_where, "WHERE (foo IN (?,?))\n");
is(scalar @{ $stmt->bind }, 2);
is($stmt->bind->[0], 'bar');
is($stmt->bind->[1], 'baz');

$stmt = ns(); $stmt->add_where(foo => { op => '!=', value => 'bar' });
is($stmt->as_sql_where, "WHERE (foo != ?)\n");
is(scalar @{ $stmt->bind }, 1);
is($stmt->bind->[0], 'bar');

$stmt = ns(); $stmt->add_where(foo => \'IS NOT NULL');
is($stmt->as_sql_where, "WHERE (foo IS NOT NULL)\n");
is(scalar @{ $stmt->bind }, 0);

$stmt = ns();
$stmt->add_where(foo => 'bar');
$stmt->add_where(baz => 'quux');
is($stmt->as_sql_where, "WHERE (foo = ?) AND (baz = ?)\n");
is(scalar @{ $stmt->bind }, 2);
is($stmt->bind->[0], 'bar');
is($stmt->bind->[1], 'quux');

$stmt = ns();
$stmt->add_where(foo => [ { op => '>', value => 'bar' },
                          { op => '<', value => 'baz' } ]);
is($stmt->as_sql_where, "WHERE (foo > ? OR foo < ?)\n");
is(scalar @{ $stmt->bind }, 2);
is($stmt->bind->[0], 'bar');
is($stmt->bind->[1], 'baz');

$stmt = ns();
$stmt->add_where(foo => [ -and => { op => '>', value => 'bar' },
                                  { op => '<', value => 'baz' } ]);
is($stmt->as_sql_where, "WHERE (foo > ? AND foo < ?)\n");
is(scalar @{ $stmt->bind }, 2);
is($stmt->bind->[0], 'bar');
is($stmt->bind->[1], 'baz');

$stmt = ns();
$stmt->add_where(foo => [ -and => 'foo', 'bar', 'baz']);
is($stmt->as_sql_where, "WHERE (foo = ? AND foo = ? AND foo = ?)\n");
is(scalar @{ $stmt->bind }, 3);
is($stmt->bind->[0], 'foo');
is($stmt->bind->[1], 'bar');
is($stmt->bind->[2], 'baz');

## regression bug. modified parameters
my %terms = ( foo => [-and => 'foo', 'bar', 'baz']);
$stmt = ns();
$stmt->add_where(%terms);
is($stmt->as_sql_where, "WHERE (foo = ? AND foo = ? AND foo = ?)\n");
$stmt->add_where(%terms);
is($stmt->as_sql_where, "WHERE (foo = ? AND foo = ? AND foo = ?) AND (foo = ? AND foo = ? AND foo = ?)\n");

$stmt = ns();
$stmt->add_select(foo => 'foo');
$stmt->add_select(bar => 'bar');
$stmt->from([ qw( baz ) ]);
is($stmt->as_sql, "SELECT foo, bar\nFROM baz\n");

$stmt = ns();
$stmt->add_select('f.foo' => 'foo');
$stmt->add_select('COUNT(*)' => 'count');
$stmt->from([ qw( baz ) ]);
is($stmt->as_sql, "SELECT f.foo, COUNT(*) count\nFROM baz\n");
my $map = $stmt->select_map;
is(scalar(keys %$map), 2);
is($map->{'f.foo'}, 'foo');
is($map->{'COUNT(*)'}, 'count');

# HAVING
$stmt = ns();
$stmt->add_select(foo => 'foo');
$stmt->add_select('COUNT(*)' => 'count');
$stmt->from([ qw(baz) ]);
$stmt->add_where(foo => 1);
$stmt->group({ column => 'baz' });
$stmt->order({ column => 'foo', desc => 'DESC' });
$stmt->limit(2);
$stmt->add_having(count => 2);

is($stmt->as_sql, <<SQL);
SELECT foo, COUNT(*) count
FROM baz
WHERE (foo = ?)
GROUP BY baz
HAVING (COUNT(*) = ?)
ORDER BY foo DESC
LIMIT 2
SQL

sub ns { Data::ObjectDriver::SQL->new }
