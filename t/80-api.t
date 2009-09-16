# -*- perl -*-
use strict;

BEGIN: {
   eval { require Test::ClassAPI };
   use Test::More $@ ? (skip_all => 'Test::ClassAPI not installed.') : (); 
};

use DBIx::ObjectDriver;
use DBIx::ObjectDriver::Driver::DBI;
use DBIx::ObjectDriver::SQL;
use DBIx::ObjectDriver::BaseObject;

Test::ClassAPI->execute('complete') unless $@;

__DATA__

Class::Accessor::Fast   = interface
DBIx::ObjectDriver      = class
DBIx::ObjectDriver::Driver::DBI = class
DBIx::ObjectDriver::SQL = class
DBIx::ObjectDriver::BaseObject = class

[Class::Accessor::Fast]
new                             = method
accessor_name_for               = method
best_practice_accessor_name_for = method
best_practice_mutator_name_for  = method
follow_best_practice            = method
make_accessor                   = method
make_ro_accessor                = method
make_wo_accessor                = method
mk_accessors                    = method
mk_ro_accessors                 = method
mk_wo_accessors                 = method
mutator_name_for                = method
get                             = method
set                             = method
subname                         = method

[DBIx::ObjectDriver]
Class::Accessor::Fast = implements
new                   = method
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
pk_generator          = method
profiler              = method
record_query          = method
rollback              = method
start_query           = method
txn_active            = method
uncache_object        = method

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


[DBIx::ObjectDriver::SQL]
Class::Accessor::Fast = implements
add_complex_where     = method
add_having    = method
add_index_hint        = method
add_join      = method
add_select    = method
add_where     = method
as_aggregate  = method
as_limit      = method
as_sql        = method
as_sql_having = method
as_sql_where  = method
bind          = method
column_mutator        = method
comment               = method
distinct              = method
from          = method
group         = method
has_where     = method
having        = method
index_hint            = method
joins         = method
limit         = method
offset        = method
order         = method
select        = method
select_map    = method
select_map_reverse = method
subname            = method
where         = method
where_values  = method

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