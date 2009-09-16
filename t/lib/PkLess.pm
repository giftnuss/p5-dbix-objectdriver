# $Id: Wine.pm 1050 2005-12-08 13:46:22Z ykerherve $

use strict;

package PkLess;
use base qw/DBIx::ObjectDriver::BaseObject/;

use DBIx::ObjectDriver::Driver::DBI;

sub class_properties {{
    columns => [ 'anything' ],
    datasource => 'pkless',
    primary_key =>  [ ], # proper way to skip pk (for now XXX)
    driver => DBIx::ObjectDriver::Driver::DBI->new(
        dsn      => 'dbi:SQLite:dbname=global.db',
    ),
}}

1;
