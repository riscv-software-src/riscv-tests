#!/usr/bin/perl -w
#==========================================================================
# vvadd_gendata.pl
#
# Author : Christopher Batten (cbatten@mit.edu)
# Date   : April 29, 2005
#
(our $usageMsg = <<'ENDMSG') =~ s/^\#//gm;
#
# Simple script which creates an input data set and the reference data
# for the vvadd benchmark.
#
ENDMSG

use strict "vars";
use warnings;
no  warnings("once");
use Getopt::Long;

#--------------------------------------------------------------------------
# Command line processing
#--------------------------------------------------------------------------

our %opts;

sub usage()
{

  print "\n";
  print " Usage: vvadd_gendata.pl [options] \n";
  print "\n";
  print " Options:\n";
  print "  --help  print this message\n";
  print "  --size  size of input data [1000]\n";
  print "  --seed  random seed [1]\n";
  print "$usageMsg";

  exit();
}

sub processCommandLine()
{

  $opts{"help"} = 0;
  $opts{"size"} = 1000;
  $opts{"seed"} = 1;
  Getopt::Long::GetOptions( \%opts, 'help|?', 'size:i', 'seed:i' ) or usage();
  $opts{"help"} and usage();

}

#--------------------------------------------------------------------------
# Helper Functions
#--------------------------------------------------------------------------

sub printArray
{
  my $arrayName    = $_[0];
  my $arrayRefReal = $_[1];
  my $arrayRefImag = $_[2];

  my $numCols = 20;
  my $arrayLen = scalar(@{$arrayRefReal});

  print "struct Complex ".$arrayName."[DATA_SIZE] = \n";
  print "{\n";

    print "  ";
    for ( my $i = 0; $i < $arrayLen; $i++ ) {
      print sprintf("{%3.2f, %3.2f}",$arrayRefReal->[$i], $arrayRefImag->[$i]);
      if ( $i != $arrayLen-1 ) {
        print ",\n  ";
      }
    }

  print  "\n};\n\n";
}

#--------------------------------------------------------------------------
# Main
#--------------------------------------------------------------------------

sub main()
{

  processCommandLine();
  srand($opts{"seed"});

  my @values_real1;
  my @values_imag1;
  my @values_real2;
  my @values_imag2;
  my @product_real;
  my @product_imag;
  for ( my $i = 0; $i < $opts{"size"}; $i++ ) {
    my $value_real1 = (rand(9.0));
    my $value_imag1 = (rand(9.0));
    my $value_real2 = (rand(9.0));
    my $value_imag2 = (rand(9.0));
    push( @values_real1, $value_real1 );
    push( @values_imag1, $value_imag1 );
    push( @values_real2, $value_real2 );
    push( @values_imag2, $value_imag2 );
    push( @product_real, ($value_real1 * $value_real2) - ($value_imag1 * $value_imag2));
    push( @product_imag, ($value_imag1 * $value_real2) + ($value_real1 * $value_imag2));
  }


  print "\n\#define DATA_SIZE ".$opts{"size"}." \n\n";
  printArray( "input1_data", \@values_real1, \@values_imag1 );
  printArray( "input2_data", \@values_real2, \@values_imag2 );
  printArray( "verify_data", \@product_real, \@product_imag );

}

main();

