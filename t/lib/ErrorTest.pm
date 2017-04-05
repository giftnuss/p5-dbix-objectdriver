# $Id$

package ErrorTest;
use strict;
use base qw( DBIx::ObjectDriver::BaseObject );

use DBIx::ObjectDriver::Driver::DBI;

sub class_properties {
	return {
        columns => [ 'foo' ],
        datasource => 'error_test',
        primary_key =>  [ ],
        driver => DBIx::ObjectDriver::Driver::DBI->new(
            dsn      => 'dbi:SQLite:dbname=global.db',
        ),
}}

1;
