package DBIx::ObjectDriver::Record;
use strict; use warnings; use utf8;

# =========================
#          CLASS
# =========================


# =========================
#         OBJECT
# =========================
use subs qw/init/;
use HO::class
    init => 'hash',
    _rw => used_columns => '@';


1;

__END__

