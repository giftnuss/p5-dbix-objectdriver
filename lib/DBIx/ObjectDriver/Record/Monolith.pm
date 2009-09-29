package DBIx::ObjectDriver::Record::Monolith;
use strict; use warnings; use utf8;

use base 'DBIx::ObjectDriver::Record';

# reserved words
use constant COLUMN_NAMES => 0;
use constant COLUMN_STARTCOUNT => 2;

my %columns;

sub new {
    my ($self,$cols) = @_;
    my $class = ref $self || $self;
    return bless [ $cols , []], $class
}

sub add_accessor {
    my ($self,$acc) = @_;
    my $idx = keys(%columns) + COLUMN_STARTCOUNT;
    $columns{$acc} = $idx;

    { no strict 'refs';
      *{join('::',ref($self),$acc)} = sub { return $_[0]->[$idx] };
    };

    return $self
}

# INTERFACE
# muss eine Referenz auf den Datenslot zurueck geben
sub get_slot {
    my ($self,$columnname) = @_;
    my $idx = $columns{$columnname};

    die "Invalid column name $columnname." 
        unless defined($idx) && $idx >= COLUMN_STARTCOUNT;
    return \$self->[$idx]
}

1;

__END__

