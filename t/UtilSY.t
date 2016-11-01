use strict;
use warnings;

use Test::More tests => 27;
use Test::Exception;

# others to include
use File::Temp qw/ tempfile tempdir /;

BEGIN { use_ok( 'UtilSY', qw(is_defined) ); }
BEGIN { use_ok( 'UtilSY', qw(to_bool) ); }
BEGIN { use_ok( 'UtilSY', qw(check_ref) ); }
BEGIN { use_ok( 'UtilSY', qw(check_file) ); }
BEGIN { use_ok( 'UtilSY', qw(:all) ); }


# test is_defined
{
    throws_ok( sub{ is_defined() },
            'MyX::Generic::Undef::Param', "throws_ok is_defined()" );
    throws_ok( sub{ is_defined(undef, "val_name") },
              'MyX::Generic::Undef::Param',
              "throws_ok is_defined(undef, val_name)" );
    lives_ok( sub{ is_defined("val", "val_name") },
             "expected to live -- is_defined(val, val_name)" );
}

# test to_bool
{
    throws_ok( sub{ to_bool() },
              'MyX::Generic::Undef::Param', "throws -- to_bool()" );
    throws_ok( sub{ to_bool("blah") },
              'MyX::Generic::BadValue', "throws -- to_bool(blah)" );
    
    is( to_bool(1), 1, "to_bool(1)" );
    is( to_bool(0), 0, "to_bool(0)" );
    is( to_bool("Y"), 1, "to_bool(Y)" );
    is( to_bool("y"), 1, "to_bool(y)" );
    is( to_bool("yes"), 1, "to_bool(yes)" );
    is( to_bool("T"), 1, "to_bool(T)" );
    is( to_bool("t"), 1, "to_bool(t)" );
    is( to_bool("True"), 1, "to_bool(True)" );
    is( to_bool("F"), 0, "to_bool(F)" );
}

# test check_ref
{
    throws_ok( sub{ check_ref() },
              'MyX::Generic::Undef::Param', "throws -- check_ref()" );
    throws_ok( sub{ check_ref([1,2]) },
              'MyX::Generic::Undef::Param', "throws -- check_ref([1,2])" );
    
    is( check_ref([1,2], "ARRAY"), 1, "check_ref([1,2], ARRAY)" );
    throws_ok( sub{ check_ref([1,2], "HASH") },
              'MyX::Generic::Ref::UnsupportedType',
              "throws -- check_ref([1,2], HASH)" );
}

# test check_file
{
    throws_ok( sub{ check_file() },
              'MyX::Generic::Undef::Param', "throws -- check_file()" );
    throws_ok( sub{ check_file("blah") },
              'MyX::Generic::DoesNotExist::File',
              "throws -- check_file(blah)" );
    
    my ($temp_fh, $temp_file) = tempfile();
    throws_ok( sub{ check_file($temp_file) },
              'MyX::Generic::File::Empty',
              "throws -- check_file(temp_file)" );
    
    print $temp_fh "test";
    close($temp_fh);
    lives_ok( sub{ check_file($temp_file) },
             "expected to live -- check_file(temp_file)" );
}


