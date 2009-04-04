package Data::ObjectDriver::Moose::Base;
use Moose;

extends 'Moose::Object';

use Class::Trigger qw( pre_save post_save post_load pre_search
                       pre_insert post_insert pre_update post_update
                       pre_remove post_remove post_inflate );

sub ssss { warn "xxx" }
no Moose;
1;
