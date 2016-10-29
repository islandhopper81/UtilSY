use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'UtilSY',
    license             => 'unknown',
    dist_author         => 'Scott Yourstone <scott.yourstone.com>',
    dist_version_from   => 'lib/UtilSY.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'UtilSY-*' ],
    recursive_test_files => 1,
);

$builder->create_build_script();
