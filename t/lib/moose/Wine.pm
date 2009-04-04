package HasRating;
use Moose::Role;

has rating => ( isa => 'Int', is => 'rw', );

no Moose;

package Wine;
use Data::ObjectDriver::Moose;

with 'HasRating';

use Data::ObjectDriver::Driver::DBI;

has id         => ( isa => 'Int', is => 'rw', );
has cluster_id => ( isa => 'Int', is => 'rw', );
has name       => ( isa => 'Str', is => 'rw', );
has content    => ( isa => 'Str', is => 'rw', );
has binchar    => ( isa => 'Str', is => 'rw', );

#columns([ 'id', 'cluster_id', 'name', 'content', 'binchar', 'rating' ]);
columns ('all', except => []);
datasource('wines');
primary_key('id');
#column_defs => { content => 'blob', binchar => 'binchar' },
driver( Data::ObjectDriver::Driver::DBI->new(
        dsn      => 'dbi:SQLite:dbname=global.db',
    ),
);

sub insert {
    my $obj = shift;
    ## Choose a cluster for this recipe. This isn't a very solid way of
    ## doing this, but it works for testing.
    $obj->cluster_id(int(rand 2) + 1);
    $obj->SUPER::insert(@_);
}

no Data::ObjectDriver::Moose;
1;
