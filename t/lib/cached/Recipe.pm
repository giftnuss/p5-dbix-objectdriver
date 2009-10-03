# $Id$

package Recipe;
use strict;
use base qw( DBIx::ObjectDriver::BaseObject );

use DBIx::ObjectDriver::Driver::DBI;

sub class_properties {{
    columns => [ 'recipe_id', 'title' ],
    datasource => 'recipes',
    primary_key => 'recipe_id',
    driver => DBIx::ObjectDriver::Driver::DBI->new(
        dsn      => 'dbi:SQLite:dbname=global.db',
        #reuse_dbh => 1,
    ),
}};

1;
