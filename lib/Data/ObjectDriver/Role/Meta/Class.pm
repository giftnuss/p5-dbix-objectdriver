package Data::ObjectDriver::Role::Meta::Class;
use Carp;
use Moose::Role;
use Moose::Util::TypeConstraints;

sub after_has_changed {
    my $attr = shift;
    return sub {
        my ($instance, $value) = @_;
        #warn "Changing $instance $attr to $value";
        # ugly
        my $changed_columns = $instance->changed_columns || {};
        $changed_columns->{$attr}++;
        $instance->changed_columns($changed_columns);
    }
};

sub set_columns {
    my $meta = shift;
    my $caller = shift;
    my $first = shift;

    ## could be [ col1, col2, ... ]
    if ($first && ref $first && ref $first eq 'ARRAY') {
        return $meta->columns($first);
    }
    ## - or, all, except => [not_col1, not_col2]
    elsif ($first && $first eq 'all') {
        my %except = map { $_ => 1 } @{ $_[1] || [] }; 
        my %attributes = %{ $caller->meta->get_attribute_map };
        for (keys %attributes) {
            $meta->add_after_method_modifier( $_, after_has_changed($_) );
        }
        my @columns = grep { ! $except{$_} } keys %attributes;
        $meta->columns( \@columns );
        return 1;
    }
    Carp::croak("I don't know how to set columns");
}

has column_defs => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { {} },
);

has db => (
    is => 'rw',
    isa => 'Str',
);

has columns => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
);

has datasource => (
    is => 'rw',
    isa => 'Str',
);

has driver => (
    is => 'rw',
    isa => 'Data::ObjectDriver',
);

subtype 'ArrayRefOfColumns'
    => as 'ArrayRef[Str]';

coerce 'ArrayRefOfColumns'
    => from 'Str'
    => via { [ $_ ] };

has primary_key => (
    is     => 'rw',
    isa    => 'ArrayRefOfColumns',
    coerce => 1,
);

no Moose;
1;
