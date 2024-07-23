#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

################################################################################
# find_words.pl
#
# This script is used to run the word identification tool on a set of benchmarks
# and display their output. Input is a file with benchmarks to run listed, one
# on each line.
#
# Usage: find_words.pl [--random] -b <benchmark list>
################################################################################

# Check input arguments
my $random;
my $benchmark_file = '';
GetOptions (
            "random"  => \$random,
            "benchmark=s" => \$benchmark_file
           ) 
or die "Error in command line arguments\n";

my $num_runs = 100;

# open benchmark file
open (my $BENCHMARK_LIST, "<", $benchmark_file) 
or die "Could't open $benchmark_file: $!";

# print header
print "benchmark, technique, #gates, #nets, #ffs, #words, #bits, full found, partial found, not found, runtime\n";

# run each benchmark in file
while (<$BENCHMARK_LIST>)
{
  chomp;
  $_ =~ /^.*\/([^\/]+)$/;
  my $benchmark = $_;
  my $short_benchmark = $1;

  # check that both a benchmark and word reference file exists
  (-e "$_.words") or die "No reference file exists for $_\n";
  (-e "$_.bench") or die "No benchmark file exists for $_\n";

  # generate random benchmarks
  if($random)
  {
    for(my $i = 0; $i < $num_runs; $i++)
    {
      `perl ./scripts/randomize_benchmark.pl $benchmark.bench $i.bench`;
    }
  }

  # run word_finder on benchmark
  my @groupings = (["POS+SH", $num_runs], ["POS+CS", $num_runs], ["BFS+SH", 1], ["BFS+CS", 1]);
  for my $grouping (@groupings)
  {

    # keep track of avg stats
    my $run_time = 0;
    my $words_found = 0;
    my $words_not_found = 0;
    my $avg_frag = 0;
    my $everything_else = "";
  
    for(my $i = 0; $i < $grouping->[1]; $i++)
    {
      # run benchmark and parse output
      my $output;
      if ($random) {
        $output = `bin/word_finder -g $grouping->[0] $i.bench $benchmark.words`;
      } else {
        $output = `bin/word_finder -g $grouping->[0] $benchmark.bench $benchmark.words`;
      }
      if(not $output =~ /^(.*),(\d+(\.\d+)?),(\d+(\.\d+)?),(\d+(\.\d+)?),(\d+(\.\d+)?)$/)
      {
        print "ERROR: Couldn't parse program output!\n";
        print $output;
        exit;
      }

      # update metrics
      $words_found += $2;
      $avg_frag += $4;
      $words_not_found += $6;
      $run_time += $8;
      $everything_else = $1;
    }

    # average metrics
    $run_time /= $grouping->[1];
    $words_found /= $grouping->[1];
    $avg_frag /= $grouping->[1];
    $words_not_found /= $grouping->[1];

    # print output
    print "$grouping->[0],$short_benchmark,$everything_else,$words_found,$avg_frag,$words_not_found,$run_time\n";
  }
  
  # clean up random benchmark
  if($random)
  {
    `rm -f *.bench`;
  }
}
