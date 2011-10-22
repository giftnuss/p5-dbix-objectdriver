  package DBIx::ObjectDriver::Iterator;
# *************************************
use strict; use warnings;

our $VERSION = '0.08';

my %Iterators = ();

use overload
    '@{}' => sub {
        my $self = shift;
        my @objs = ();

        while (my $obj = $self->()) {
            push @objs, $obj;
        }
        return \@objs;
    },
    fallback => 1;

sub new {
    my $class = shift;
    my( $each, $end ) = @_;
    bless $each, $class;
    if ($end) {
        $Iterators{ $each }{ end } = $end;
    }
    return $each;
}

sub next {
    return shift->();
}

sub end {
    my $each = shift;
    my $hash = delete $Iterators{ $each };
    $hash->{ end }->() if $hash and ref $hash->{ end } eq 'CODE';
}

sub DESTROY {
    my $iter = shift;
#    use YAML; warn Dump \%Iterators;
    $iter->end();
}

1;

__END__

