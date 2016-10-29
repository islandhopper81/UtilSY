package UtilSY;

use warnings;
use strict;
use Readonly;
use Class::Std::Utils;
use List::MoreUtils qw(any);
use Log::Log4perl qw(:easy);
use Log::Log4perl::CommandLine qw(:all);
use MyX::Generic;
use version; our $VERSION = qv('0.0.1');
use Exporter qw( import );
our @EXPORT_OK = qw( is_defined to_bool check_ref check_file );
our %EXPORT_TAGS = (
    'all' => \@EXPORT_OK,
);

# set up the logging environment
my $logger = get_logger();

{
	# Usage statement
	# use each function individually

	# Attributes #
	# NA -- this object is just a set of utility functions
	
	# Functions #
	sub is_defined;
	sub to_bool;
	sub check_ref;
	sub check_file;



	###############
	# Constructor #
	###############
	# NA -- This object is just a set of utility function that can be exported
	# and used in various scripts.

	#############
	# Functions #
	#############
	sub is_defined {
		my ($val, $val_name) = @_;
		
		# sometimes I forget that a val_name should be passed into this function
		if ( ! defined $val_name ) {
			$val_name = "remember to pass a val_name to is_defined";
		}
		
		if ( ! defined $val ) {
			MyX::Generic::Undef::Param->throw(
				error => "Undefined parameter value ($val_name)"
			);
		}
		
		return 1;
	}
	
	sub to_bool {
		my ($val) = @_;
		
		# make sure val is defined
		is_defined($val, "boolean value");
		
		# quick check to see if it is already a valid boolean
        if ( $val eq 1 or $val eq 0 ) {
            return $val;
        }
		
		# make the characters all upper case
		$val = uc $val;
		
		my $bool = "NA";
     
        my %good_yes_values = map { $_ => 1 } qw(Y YES T TRUE );
        if ( defined $good_yes_values{$val} ) {
            $bool = 1;   # TRUE
        }
		
		my %good_no_values = map {$_ => 1 } qw(N NO F FALSE );
		if ( defined $good_no_values{$val} ) {
			$bool = 0;   # FALSE
		}
		
		if ( $bool != 0 or $bool != 1 ) {
			MyX::Generic::BadValue->throw(
				error => "Doesn't look like a boolean value: $val"
			);
		}
		
        return $bool;
	}
	
	sub check_ref {
		my ($ref, $type) = @_;
		
		is_defined($ref, "object reference");
		is_defined($type, "object type");
		
		if ( ref($ref) ne $type ) {
			MyX::Generic::Ref::UnsupportedType->throw(
				error => "$ref must be of type $type"
			);
		}
		
		return 1;
	}
	
	sub check_file {
		my ($file) = @_;
		
		# check if the file parameter is defined
		is_defined($file, "file");
		
		# check if the file exists
		if ( ! -f $file ) {
			MyX::Generic::DoesNotExist::File->throw(
				error => "File ($file) does not exist"
			)
		}
		
		# check that the file is non empty
		if ( ! -s $file ) {
			MyX::Generic::File::Empty->throw(
				error => "File ($file) is empty"
			);
		}
		
		return 1;
	}
	

}

1; # Magic true value required at end of module
__END__

=head1 NAME

UtilSY - Scott Yourstone's utility functions


=head1 VERSION

This document describes UtilSY version 0.0.1


=head1 SYNOPSIS

    use UtilSY qw(:all);
	
	# Or you can load and use the functions individually. E.g.
	use UtilSY qw(is_defined);
  
  
=head1 DESCRIPTION

These are generic functions that I tend to use in many different scripts and
modules.  It seemed safer and easier to keep them in an independent Perl object
rather than keep copying and pasting the code.


=head1 CONFIGURATION AND ENVIRONMENT
  
UtilSY requires no configuration files or environment variables.


=head1 DEPENDENCIES

warnings
strict
Readonly
Class::Std::Utils
List::MoreUtils qw(any)
Log::Log4perl qw(:easy)
Log::Log4perl::CommandLine qw(:all)
MyX::Generic
version our $VERSION = qv('0.0.1')
Exporter qw( import )


=head1 INCOMPATIBILITIES

None reported.


=head1 METHODS

=over

	is_defined
	to_bool
	check_ref
	check_file

=back

=head1 METHODS DESCRIPTION
	
=head2 is_defined

	Title: is_defined
	Usage: is_defined($val, $val_name)
	Function: checks if a value is defined
	Returns: 1 on success
	Args: -val => value to check
	      -val_name => name of value (for print error message)
	Throws: MyX::Generic::Undef::Param
	Comments: NA
	See Also: NA
	
=head2 to_bool

	Title: to_bool
	Usage: to_bool($val)
	Function: converts a boolean value to either 0 or 1
	Returns: 0 or 1
	Args: -val => a boolean value
	Throws: MyX::Generic::Undef::Param
	        MyX::Generic::BadValue
	Comments: Valid boolean values include: 0, 1, T, True, Y, Yes, F, False,
			  No, and N.
	See Also: NA
	
=head2 check_ref

	Title: check_ref
	Usage: check_ref($ref, $type)
	Function: checks a value to ensure it is of the correct type
	Returns: 1 on success
	Args: -ref => an object reference
	      -type => the expected type
	Throws: MyX::Generic::Undef::Param
	        MyX::Generic::Ref::UnsupportedType
	Comments: Types are case sensitive
	See Also: perl ref function
	
=head2 check_file

	Title: check_file
	Usage: check_file($file)
	Function: checks a file to make sure it exists and is non-empty
	Returns: 1 on success
	Args: -file => file name or path
	Throws: MyX::Generic::Undef::Param
	        MyX::Generic::DoesNotExist::File
			MyX::Generic::File::Empty
	Comments: NA
	See Also: NA


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 TO DO

None

=head1 AUTHOR

Scott Yourstone  C<< scott.yourstone81@gmail.com >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, Scott Yourstone
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
