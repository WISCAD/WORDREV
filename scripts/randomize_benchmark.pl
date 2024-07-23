#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw/shuffle/;

################################################################################
# randomize_benchmark.pl
#
# This script is used to randomize the ordering of a benchmark 
# circuit. Randomizing a benchmark ensures that no information can be gained
# from the original ordering of the netlist. This is essentially creating
# netlist obfuscation. Names are kept intact in order to validate results
#
# Usage: randomize_benchmark.pl <input benchmark> <output file>
################################################################################

# Check input arguments
if (scalar @ARGV != 2)
{
  print "Usage: randomize_benchmark.pl <input benchmark> <output file>\n";
  exit;
}

# open files
open (my $IN_FILE, "<", $ARGV[0]) or die "Couldn't open $ARGV[0]: $!";
open (my $OUT_FILE, ">", $ARGV[1]) or die "Couldn't open $ARGV[0]: $!";

# extract and randomize lines of a benchmark
my @lines = shuffle <$IN_FILE>;

# print lines to output
foreach my $match ((qr/^INPUT/, qr/^OUTPUT/, qr/^(?!INPUT|OUTPUT)/))
{
  foreach my $line (@lines)
  {
    if ($line =~ $match)
    {
      print $OUT_FILE $line;
    }
  }

  print $OUT_FILE "\n";
}
