use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'UtilSY',
    license             => 'unknown',
    dist_author         => 'Scott Yourstone <scott.yourstone.com>',
    dist_version_from   => 'lib/UtilSY.pm',
    requires => {
		'Readonly' => 0,
		'Class::Std::Utils' => 0,
		'Data::Dumper' => 0,
		'List::MoreUtils' => 0,
		'Log::Log4perl' => 0,
		'Log::Log4perl::ComandLine' => 0,
		'Exporter' => 0,
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'UtilSY-*' ],
    recursive_test_files => 1,
);

$builder->create_build_script();
