# -*- perl -*-
use strict;

BEGIN: {
   eval { require Test::ClassAPI };
   use Test::More $@ ? (skip_all => 'Test::ClassAPI not installed.') : (); 
};

use DBIx::ObjectDriver;
use DBIx::ObjectDriver::Driver::DBI;
use DBIx::ObjectDriver::BaseObject;

Test::ClassAPI->execute('complete') unless $@;

__DATA__

DBIx::ObjectDriver = class
DBIx::ObjectDriver::BaseObject = class
DBIx::ObjectDriver::Driver::DBI = class
DBIx::ObjectDriver::Iterator = class

[DBIx::ObjectDriver]
# generated
new                   = method
# accessors
pk_generator          = method
record_map            = method
txn_active            = method
# my additiions
with                  = method
# original api
begin_work            = method
cache_object          = method
commit                = method
debug                 = method
init                  = method
cache_object          = method
debug                 = method
end_query             = method
list_or_iterator      = method
logger                = method
profiler              = method
record_query          = method
rollback              = method
start_query           = method
uncache_object        = method

[DBIx::ObjectDriver::Iterator]
new                   = method
next                  = method
end                   = method

[DBIx::ObjectDriver::Driver::DBI]
begin_work  = method
bulk_insert = method
commit      = method
connect_options = method
direct_remove = method
dbd         = method
dbh         = method
dsn         = method
exists      = method
fetch       = method
fetch_data  = method
force_no_prepared_cache = method
generate_pk = method
get_dbh     = method
init_db     = method
insert      = method
last_error  = method
load_object_from_rec = method
# logger      = method
lookup      = method
lookup_multi = method
password    = method
prefix      = method
prepare_fetch = method
prepare_statement = method
r_handle    = method
remove      = method
replace     = method
reuse_dbh   = method
rollback    = method
rw_handle   = method
search      = method
select_one  = method
subname     = method
table_for   = method
update      = method
username    = method

[DBIx::ObjectDriver::BaseObject]
# add_trigger   = method
begin_work      = method
bulk_insert   = method
call_trigger  = method
changed_cols  = method
changed_cols_and_pk = method
class_properties    = method
clone         = method
clone_all     = method
column        = method
column_func   = method
column_names  = method
column_values = method
columns_of_type = method
commit        = method
datasource    = method
deflate       = method
driver        = method
exists        = method
fetch_data    = method
get_driver    = method
has_a         = method
has_column    = method
has_partitions = method
has_primary_key = method
inflate       = method
init          = method
insert        = method
install_column = method
install_properties = method
is_changed    = method
is_pkless     = method
is_primary_key = method
is_same       = method
is_same_array = method
# last_trigger_results = method
lookup        = method
lookup_multi  = method
new           = method
object_is_stored = method
pk_str        = method
primary_key   = method
primary_key_to_terms = method
primary_key_tuple = method
properties    = method
refresh       = method
remove        = method
replace       = method
reset_changed_cols = method
result        = method
rollback      = method
save          = method
search        = method
set_values    = method
set_values_internal = method
txn_active    = method
txn_debug     = method
uncache_object = method
update        = method
weaken        = method

# Development
Dumper        = method
# TRIGGER
# _trigger      = method
post_inflate = method
post_insert  = method
post_load    = method
post_remove  = method
post_save    = method
post_update  = method
pre_insert   = method
pre_remove   = method
pre_search   = method
pre_update   = method
pre_save     = method
