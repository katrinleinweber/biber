use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 9;

use Biber;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata") ;

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('related.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);

# Now generate the information
$biber->prepare;
my $out = $biber->get_output_obj;
my $section = $biber->sections->get_section(0);
my $shs = $section->get_list('SHORTHANDS');
my $main = $section->get_list('MAIN');
my $bibentries = $section->bibentries;

my $k1 = q|  \entry{key1}{article}{}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{labelyear}{1998}
    \field{journaltitle}{Journal Title}
    \field{number}{5}
    \field{related}{78f825aaa0103319aaa1a30bf4fe3ada,3631578538a2d6ba5879b31a9a42f290,caf8e34be07426ae7127c1b4829983c1}
    \field{relatedtype}{reprintas}
    \field{shorthand}{RK1}
    \field{title}{Original Title}
    \field{volume}{12}
    \field{year}{1998}
    \field{pages}{125\bibrangedash 150}
  \endentry

|;

my $k2 = q|  \entry{key2}{inbook}{}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \list{location}{1}{%
      {Location}%
    }
    \list{publisher}{1}{%
      {Publisher}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{labelyear}{2009}
    \field{booktitle}{Booktitle}
    \field{related}{c2add694bf942dc77b376592d9c862cd}
    \field{relatedstring}{First}
    \field{relatedtype}{reprintof}
    \field{shorthand}{RK2}
    \field{title}{Reprint Title}
    \field{year}{2009}
    \field{pages}{34\bibrangedash 60}
  \endentry

|;

my $k3 = q|  \entry{key3}{inbook}{}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \list{location}{1}{%
      {Location}%
    }
    \list{publisher}{1}{%
      {Publisher2}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{labelyear}{2010}
    \field{booktitle}{Booktitle}
    \field{related}{c2add694bf942dc77b376592d9c862cd}
    \field{relatedstring}{Second}
    \field{relatedtype}{reprintof}
    \field{shorthand}{RK3}
    \field{title}{Reprint Title}
    \field{year}{2010}
    \field{pages}{33\bibrangedash 57}
  \endentry

|;

my $kck1 = q|  \entry{c2add694bf942dc77b376592d9c862cd}{article}{dataonly}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{journaltitle}{Journal Title}
    \field{number}{5}
    \field{shorthand}{RK1}
    \field{title}{Original Title}
    \field{volume}{12}
    \field{year}{1998}
    \field{pages}{125\bibrangedash 150}
  \endentry

|;

my $kck2 = q|  \entry{78f825aaa0103319aaa1a30bf4fe3ada}{inbook}{dataonly}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \list{location}{1}{%
      {Location}%
    }
    \list{publisher}{1}{%
      {Publisher}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{booktitle}{Booktitle}
    \field{shorthand}{RK2}
    \field{title}{Reprint Title}
    \field{year}{2009}
    \field{pages}{34\bibrangedash 60}
  \endentry

|;

my $kck3 = q|  \entry{3631578538a2d6ba5879b31a9a42f290}{inbook}{dataonly}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \list{location}{1}{%
      {Location}%
    }
    \list{publisher}{1}{%
      {Publisher2}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{booktitle}{Booktitle}
    \field{shorthand}{RK3}
    \field{title}{Reprint Title}
    \field{year}{2010}
    \field{pages}{33\bibrangedash 57}
  \endentry

|;

my $kck4 = q|  \entry{caf8e34be07426ae7127c1b4829983c1}{inbook}{dataonly}
    \name{labelname}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \name{author}{1}{%
      {{Author}{A\bibinitperiod}{}{}{}{}{}{}}%
    }
    \list{location}{1}{%
      {Location}%
    }
    \list{publisher}{1}{%
      {Publisher2}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{0}
    \field{booktitle}{Booktitle}
    \field{shorthand}{RK4}
    \field{title}{Reprint Title}
    \field{year}{2011}
    \field{pages}{33\bibrangedash 57}
  \endentry

|;

is( $out->get_output_entry($main,'key1'), $k1, 'Related entry test 1' ) ;
is( $out->get_output_entry($main,'key2'), $k2, 'Related entry test 2' ) ;
is( $out->get_output_entry($main,'key3'), $k3, 'Related entry test 3' ) ;
is( $out->get_output_entry($main,'c2add694bf942dc77b376592d9c862cd'), $kck1, 'Related entry test 4' ) ;
is( $out->get_output_entry($main,'78f825aaa0103319aaa1a30bf4fe3ada'), $kck2, 'Related entry test 5' ) ;
is( $out->get_output_entry($main,'3631578538a2d6ba5879b31a9a42f290'), $kck3, 'Related entry test 6' ) ;
is( $out->get_output_entry($main,'caf8e34be07426ae7127c1b4829983c1'), $kck4, 'Related entry test 7' ) ;
# Key k4 is used only to create a related entry clone but since it isn't cited itself
# it shouldn't be in the .bbl
is( $out->get_output_entry($main,'key4'), undef, 'Related entry test 8' ) ;
is_deeply([$shs->get_keys], ['key1', 'key2', 'key3'], 'Related entry test 9');

unlink <*.utf8>;
