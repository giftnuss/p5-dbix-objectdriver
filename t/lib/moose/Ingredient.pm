package Ingredient;

use Data::ObjectDriver::Moose;
use Moose::Util::TypeConstraints;

subtype 'vchar'
    => as Str
    => where { defined($_) && bytes::length($_) < 255 }
    => message { "The vchar you provided shouldn't exceed 255 char" };

has id        => ( isa => 'Int', is => 'rw' );
has recipe_id => ( isa => 'Int', is => 'rw' );
has quantity  => ( isa => 'Int', is => 'rw' );
has name      => ( isa => 'vchar', is => 'rw' );

use Carp ();
use Data::ObjectDriver::Driver::DBI;
use Data::ObjectDriver::Driver::Cache::RAM;

our %IDs;

columns     ( 'all', except => [] );
datasource  ( 'ingredients' );
primary_key ( ['recipe_id', 'id'] );
driver      ( Data::ObjectDriver::Driver::Cache::RAM->new(
    fallback => Data::ObjectDriver::Driver::DBI->new(
        dsn      => 'dbi:SQLite:dbname=global.db',
        pk_generator => \&generate_pk,
        reuse_dbh => 1,
    ),
    pk_generator => \&generate_pk,
));

sub generate_pk {
    my($obj) = @_;
    $obj->id(++$IDs{$obj->recipe_id});
    1;
}

no Data::ObjectDriver::Moose;
1;
