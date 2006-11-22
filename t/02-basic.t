# $Id: 01-col-inheritance.t 989 2005-09-23 19:58:01Z btrott $

use strict;

use lib 't/lib';
use lib 't/lib/cached';

require 't/lib/db-common.pl';

use Test::More;
use Test::Exception;

BEGIN {
    unless (eval { require DBD::SQLite }) {
        plan skip_all => 'Tests require DBD::SQLite';
    }
    unless (eval { require Cache::Memory }) {
        plan skip_all => 'Tests require Cache::Memory';
    }
}

plan tests => 46;

use Wine;
use Recipe;
use Ingredient;

setup_dbs({
    global => [ qw( wines recipes ingredients) ],
});

# method installation
{ 
    my $w = Wine->new;
    ok $w->name("name");
    ok $w->has_column("name");
    ok ! $w->has_column("inexistent");
    dies_ok { $w->inexistent("hell") } "dies on setting inexistent column : 'inexistent()'";
    dies_ok { $w->column('inexistent') } "dies on setting inexistent column : 'column()'";
}

# refresh
{ 
    my $old ='Cul de Veau à la Sauge'; # tastes good !
    my $new ='At first my tests ran on Recipe, sorry (Yann)';
    my $w1 = Wine->new;
    $w1->name($old);
    ok $w1->save;
    my $id = $w1->id;
    
    my $w2 = Wine->lookup($id);
    $w2->name($new);
    $w2->save;
    cmp_ok $w1->name, 'eq', $old, "Old name not updated...";
    cmp_ok $w2->name, 'eq', $new, "... but new name is set";

    $w1->refresh;

    cmp_ok $w1->name, 'eq', $new, "Refreshed";
    is $w1->remove, 1, 'Remove correct number of rows';
    is $w2->remove, '0E0', 'Remove correct number of rows';
}

# Constructor testing
{
    my $w = Wine->new(name=>'Mouton Rothschild', rating=> 4);

    ok ($w, 'constructed a new Wine');
    is ($w->name, 'Mouton Rothschild', 'name constructor');
    is ($w->rating, 4, 'rating constructor');
}

# lookup with hash (single pk) 
{
    my $w = Wine->new;
    $w->name("Veuve Cliquot");
    $w->save;
    my $id = $w->id;
    undef $w;

    # lookup test
    lives_ok { $w = Wine->lookup({ id => $id })} "Alive !";
    cmp_ok $w->name, 'eq', 'Veuve Cliquot', "simple data test";

    ok $w;
    is $w->remove, 1, 'Remove correct number of rows';
}

# lookup with hash (multiple pk) 
{
    my $r = Recipe->new;
    $r->title("Good one");
    ok $r->save;
    my $rid = $r->recipe_id;
    ok $rid;

    my $i = Ingredient->new;
    $i->recipe_id($rid);
    $i->quantity(1);
    $i->name('Chouchenn');
    ok $i->save;
    my $id = $i->id;
    undef $i;
    
    # lookup test
    dies_ok  { $i = Ingredient->lookup({ id => $id, quantity => 1 })} "Use Search !";
    lives_ok { $i = Ingredient->lookup({ id => $id, recipe_id => $rid })} "Alive";
    cmp_ok $i->name, 'eq', 'Chouchenn', "simple data test";

    is $r->remove, 1, 'Remove correct number of rows';
    is $i->remove, 1, 'Remove correct number or rows';
}

# replace
{ 
    my $r = Recipe->new;
    $r->title("to replace");
    ok $r->replace;
    ok(my $rid = $r->recipe_id);
    my $r2 = Recipe->new;
    $r2->recipe_id($rid);
    $r2->title('new title');
    ok $r2->replace;
    
    ## check
    $r = Recipe->lookup($rid);
    is $r->title, 'new title';
    
    $r2 = Recipe->new;
    $r2->recipe_id($rid);
    ok $r2->replace;

    ## check
    $r = Recipe->lookup($rid);
    is $r->title, undef;
}

# is_changed interface 
{
    my $w = Wine->new;
    $w->name("Veuve Cliquot");
    $w->save;
    ok ! $w->is_changed;
    $w->name("veuve champenoise");
    ok $w->is_changed;
    ok $w->is_changed('name');
    ok ! $w->is_changed('content');
}

# Remove counts
{
    # Clear out the wine table
    ok (Wine->remove(), 'delete all from Wine table');

    is (Wine->remove({name=>'moooo'}), 0E0, 'No rows deleted');
    my @bad_wines = qw(Thunderbird MadDog Franzia);
    foreach my $name (@bad_wines) {
        my $w = Wine->new;
        $w->name($name);
        ok $w->save, "Saving bad_wine $name";
    }
    is (Wine->remove(), scalar(@bad_wines), 'removing all bad wine');

    # Do it again with direct remove from the DB
    foreach my $name (@bad_wines) {
        my $w = Wine->new;
        $w->name($name);
        ok $w->save, "Saving bad_wine $name";
    }
    # note sqlite is stupid and doesn't return the number of affected rows
    is (Wine->remove({}, { nofetch => 1 }), '0E0', 'removing all bad wine');
}

teardown_dbs(qw( global ));

