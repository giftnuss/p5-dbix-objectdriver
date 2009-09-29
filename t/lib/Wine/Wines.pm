package Wine::Wines;
use strict; use warnings;
use DBIx::Define;

column(id => &recordid);
column(cluster_id => &smallint);
column(name => varchar(size => 50));
column(content => &text);
column(binchar => char(size => 50));
column(rating => &smallint);

1;

__END__

