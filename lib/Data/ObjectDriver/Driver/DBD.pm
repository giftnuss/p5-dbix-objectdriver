# $Id$

package Data::ObjectDriver::Driver::DBD;
use strict;

sub new {
    my $class = shift;
    my($name) = @_;
    my $subclass = join '::', $class, $name;
    eval "use $subclass";
    die $@ if $@;
    bless {}, $subclass;
}

sub init_dbh { }
sub bind_param_attributes { }
sub db_column_name { $_[2] }
sub fetch_id { }
sub offset_implemented { 1 }

1;