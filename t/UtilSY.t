use strict;
use warnings;

use Test::More tests => 63;
use Test::Exception;

# others to include
use File::Temp qw/ tempfile tempdir /;

BEGIN { use_ok( 'UtilSY', qw(is_defined) ); }
BEGIN { use_ok( 'UtilSY', qw(check_defined) ); }
BEGIN { use_ok( 'UtilSY', qw(to_bool) ); }
BEGIN { use_ok( 'UtilSY', qw(check_ref) ); }
BEGIN { use_ok( 'UtilSY', qw(check_file) ); }
BEGIN { use_ok( 'UtilSY', qw(load_lines) ); }
BEGIN { use_ok( 'UtilSY', qw(aref_to_href) ); }
BEGIN { use_ok( 'UtilSY', qw(href_to_aref) ); }
BEGIN { use_ok( 'UtilSY', qw(aref_to_str) ); }
BEGIN { use_ok( 'UtilSY', qw(href_to_str) ); }
BEGIN { use_ok( 'UtilSY', qw(:all) ); }


# test is_defined
{
    lives_ok( sub{ is_defined(undef) },
              "lives - is_defined(undef)" );
    is( is_defined(undef), 0, "is_defined(undef)" );
    lives_ok( sub{ is_defined("val") },
             "expected to live -- is_defined(val)" );
    is( is_defined("val"), 1, "is_defined(val)" );
}

# test check_defined
{
    throws_ok( sub{ check_defined() },
            'MyX::Generic::Undef::Param', "throws_ok is_defined()" );
    throws_ok( sub{ check_defined(undef, "val_name") },
              'MyX::Generic::Undef::Param',
              "throws_ok is_defined(undef, val_name)" );
    lives_ok( sub{ check_defined("val", "val_name") },
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

# test load_lines
{
    throws_ok( sub{ load_lines() },
              'MyX::Generic::Undef::Param', "throws -- load_lines()" );
    throws_ok( sub{ load_lines("blah") },
              'MyX::Generic::DoesNotExist::File',
              "throws -- load_lines(blah)" );
    
    my ($temp_fh, $temp_file) = tempfile();
    throws_ok( sub{ load_lines($temp_file) },
              'MyX::Generic::File::Empty',
              "throws -- load_lines(temp_file)" );
    
    print $temp_fh "row1\t1\n";
    print $temp_fh "row2\t2\n";
    close($temp_fh);
    my @exp = ("row1\t1", "row2\t2");
    lives_ok( sub{ load_lines($temp_file) },
             "expected to live -- load_lines(temp_file)" );
    is_deeply(load_lines($temp_file), \@exp, "load_lines(temp_file) -- no sep" );
    
    @exp = ("row1", "row2");
    is_deeply(load_lines($temp_file, "\t"), \@exp, "load_lines(temp_file) -- tab sep" );
}

# test aref_to_href
{
    throws_ok( sub{ aref_to_href() },
              'MyX::Generic::Undef::Param', "throws -- aref_to_href()" );
    
    throws_ok( sub{ aref_to_href(4) },
              'MyX::Generic::Ref::UnsupportedType', "throws -- aref_to_href(4)" );
    
    my @arr = (1,2,3,4,5);
    my $href;
    my %exp_hash = (1 => 1, 2=>1, 3=>1, 4=>1, 5=>1);
    lives_ok( sub{ $href = aref_to_href(\@arr) },
             "expected to live -- aref_to_href(aref)" );
    is_deeply($href, \%exp_hash, "aref_to_href(aref) -- check values" );
}

# test href_to_aref
{
    throws_ok( sub{ href_to_aref() },
              'MyX::Generic::Undef::Param', "throws -- href_to_aref()" );
    
    throws_ok( sub{ href_to_aref(4) },
              'MyX::Generic::Ref::UnsupportedType', "throws -- href_to_aref(4)" );
    
    my %hash = (1=>1, 2=>1, 3=>1);
    my $aref;
    my @exp1 = (1, 2, 3);
    lives_ok( sub{ $aref = href_to_aref(\%hash) },
             "expected to live -- href_to_aref(href)" );
    
    # note that the aref is returned in a random order.  so here I just sort it
    # to make it match the expected order from the hash
    my @arr = sort @{$aref};
    is_deeply(\@arr, \@exp1, "href_to_aref(href) -- check values" );
    
    # test when I want to get the values
    lives_ok( sub{ $aref = href_to_aref(\%hash, "T") },
             "expected to live -- href_to_aref(href, T)" );
    my @exp2 = (1,1,1);
    is_deeply($aref, \@exp2, "href_to_aref(href, T) -- check values" );
}

# test aref_to_str
{
    throws_ok( sub{ aref_to_str() },
              'MyX::Generic::Undef::Param', "throws -- aref_to_str()" );
    
    throws_ok( sub{ aref_to_str(4) },
              'MyX::Generic::Ref::UnsupportedType', "throws -- aref_to_str(4)" );
    
    my @arr = (1,2,3,4,5);
    my $str;
    my $exp_str = ("1\n2\n3\n4\n5");
    lives_ok( sub{ $str = aref_to_str(\@arr) },
             "expected to live -- aref_to_str(aref)" );
    is($str, $exp_str, "aref_to_str(aref) -- check str" );
    
    # test the seperater
    $exp_str = ("1\t2\t3\t4\t5");
    lives_ok( sub{ $str = aref_to_str(\@arr, "\t") },
             "expected to live -- aref_to_str(aref)" );
    is($str, $exp_str, "aref_to_str(aref) -- check str" );
}

# test href_to_str
{
    throws_ok( sub{ href_to_str() },
              'MyX::Generic::Undef::Param', "throws -- href_to_str()" );
    
    throws_ok( sub{ href_to_str(4) },
              'MyX::Generic::Ref::UnsupportedType', "throws -- href_to_str(4)" );
    
    my %hash = (1=>1, 2=>1, 3=>1);
    my $str;
    my $exp_str = "1 => 1\n2 => 1\n3 => 1";
    lives_ok( sub{ $str = href_to_str(\%hash) },
             "expected to live -- href_to_str(href)" );
    is($str, $exp_str, "href_to_str(href) --check str");
}

