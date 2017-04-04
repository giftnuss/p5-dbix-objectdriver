use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'DBIx::ObjectDriver',
    license             => 'perl',
    dist_author         => 'Mike Würfel <SKNPP@CPAN.ORG>',
    dist_version        => '0.006.001',
    requires => {
        'perl' => '5.10.1',
        'Package::Subroutine' => '0.06.000',
        'HO::class' => 0,
        'HO::Trigger' => 0,
        'DBI' => 0,
        'Class::Load' => '0.11'
    },
    build_requires => {
        'Test::More' => 0,
        'Test::Exception' => 0
    },
    add_to_cleanup      => [ 'HO-DBIx-ObjectDriver-*' ],
    create_makefile_pl  => 'traditional',
    meta_add => {
        resources => {
            repository => 'git://github.com/giftnuss/p5-ho-dbix-objectdriver.git',
            homepage => 'http://github.com/giftnuss/p5-ho-dbix-objectdriver/tree/master'
        }
    }
);

$builder->create_build_script();
