package Recipe;

use Data::ObjectDriver::Moose;
use Moose::Util::TypeConstraints;

# ========= attributes
## Meta traits?
#has recipe_id => ( isa => 'Int', is => 'rw', persistent => 1  );
#has title     => ( isa => 'vchar', is => 'rw', persistent => 1 );

has recipe_id => ( isa => 'Int', is => 'rw', );
#has title     => ( isa => 'vchar', is => 'rw', );
has title     => ( isa => 'Str', is => 'rw', );

columns ( 'all' );
#columns ( 'all', except => [] );
primary_key ( 'recipe_id' );
 
datasource ( 'recipes' );
driver (
    Data::ObjectDriver::Driver::DBI->new(
        dsn      => 'dbi:SQLite:dbname=global.db',
        reuse_dbh => 1,
));

no Data::ObjectDriver::Moose;
1;
