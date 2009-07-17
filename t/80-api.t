# -*- perl -*-
use strict;

BEGIN: {
   eval { require Test::ClassAPI };
   use Test::More $@ ? (skip_all => 'Test::ClassAPI not installed.') : (); 
};

use Data::ObjectDriver;
use Data::ObjectDriver::SQL;
use Data::ObjectDriver::BaseObject;

Test::ClassAPI->execute('complete');


__DATA__
   
Class::Accessor::Fast   = interface
Data::ObjectDriver      = class
Data::ObjectDriver::SQL = class
Data::ObjectDriver::BaseObject = class

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

[Data::ObjectDriver]
Class::Accessor::Fast = implements
new                   = method
init                  = method
cache_object          = method
debug                 = method
end_query             = method
list_or_iterator      = method
pk_generator          = method
profiler              = method
record_query          = method
start_query           = method

[Data::ObjectDriver::SQL]
Class::Accessor::Fast = implements
add_having    = method
add_join      = method
add_select    = method
add_where     = method
as_aggregate  = method
as_limit      = method
as_sql        = method
as_sql_having = method
as_sql_where  = method
bind          = method
from          = method
group         = method
has_where     = method
having        = method
joins         = method
limit         = method
offset        = method
order         = method
select        = method
select_map    = method
select_map_reverse = method
where         = method
where_values  = method

[Data::ObjectDriver::BaseObject]
add_trigger   = method
bulk_insert   = method
call_trigger  = method
changed_cols  = method
changed_cols_and_pk = method
clone         = method
clone_all     = method
column        = method
column_func   = method
column_names  = method
column_values = method
columns_of_type = method
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
is_same_array = method
last_trigger_results = method
lookup        = method
lookup_multi  = method
new           = method
primary_key   = method
primary_key_to_terms = method
primary_key_tuple = method
properties    = method
refresh       = method
remove        = method
replace       = method
save          = method
search        = method
set_values    = method
set_values_internal = method
update        = method
weaken        = method


