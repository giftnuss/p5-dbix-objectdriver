package DBIx::ObjectDriver::Record::Auto;
use strict; use warnings; use utf8;

use base 'DBIx::ObjectDriver::Record';

my %record_classes;

sub get_for_class {
    my ($self,$class,$columns) = @_;
    my $num = keys(%record_classes) + 1;
    return $record_classes{$class} if defined $record_classes{$class};

    my $dyn = "DBIx::ObjectDriver::Record::Auto::__ANON__::${num}";
    eval "package $dyn; BEGIN { our \@ISA = ('DBIx::ObjectDriver::Record::Auto'); };"
       . "use HO::class " . join(',',map({sprintf('_rw => %s => \'$\'',$_)} @$columns));

   return $dyn->new;
}

sub get_slot {
    my ($self,$columnname) = @_;
    my $acc = "_$columnname";
    my $idx = $self->$acc;

    die "Invalid column name $columnname." unless defined($idx);
    return \$self->[$idx]
}

1;

__END__

