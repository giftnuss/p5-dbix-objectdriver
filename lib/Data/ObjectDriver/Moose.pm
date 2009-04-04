package Data::ObjectDriver::Moose;

## is the class really has the knowledge of how to persist and
## being inflated from the store, or should that rather be 
## defined at the driver level/controller?
## : should I say, Driver->insert($model), instead of $model->insert
## so, Class provide attributes definition, and buz logic
##     Driver provide persistence mechanisms
##     I can still say. User->driver->lookup($id), but the nice 
##     thing is that the driver is interchangeable.

## note this is also true, If I can say User->driver($replacement_driver)
## But, placing the responsability of the persistence out of the model
## sounds better to me for some reason.
## my $model = $dod->lookup($class, $id)
## $dod->delete($model)
## $dod->save($model)
##
#http://search.cpan.org/~drolsky/Moose-0.73/lib/Moose/Cookbook/Extending/Recipe1.pod
#seems to be the key, especially the part where MetaRole are used

use strict;
use warnings;
use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use Data::ObjectDriver::Moose::Base;
use Data::ObjectDriver::Role::Meta::Class;
use Data::ObjectDriver::Role::Object;

Moose::Exporter->setup_import_methods(
    with_caller => [ 'columns', 'datasource', 'driver', 'primary_key' ],
    also        => 'Moose',
);

sub init_meta {
    shift;
    my %option = @_;
    Moose->init_meta(
        %option,
        base_class => 'Data::ObjectDriver::Moose::Base',
    );
    my $meta = Moose::Util::MetaRole::apply_metaclass_roles(
        for_class       => $option{for_class},
        metaclass_roles => [ 'Data::ObjectDriver::Role::Meta::Class' ],
    );
    Moose::Util::MetaRole::apply_base_class_roles(
        for_class => $option{for_class},
        roles     => [ 'Data::ObjectDriver::Role::Object' ],
    );
    return $meta;
}

sub columns {
    my $caller = shift;
## No real idea of what I'm doing
    if (@_) {
        $caller->meta->set_columns($caller, @_);
    }
    else {
        $caller->meta->columns;
    }
}

sub datasource {
    my $caller = shift;
    $caller->meta->datasource(@_);
}

sub driver {
    my $caller = shift;
    $caller->meta->driver(@_);
}

sub primary_key {
    my $caller = shift;
    $caller->meta->primary_key(@_);
}

no Moose;
1;

