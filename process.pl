#!/usr/bin/perl

use warnings;
use strict;

use Time::HiRes qw(time);
use List::Util  qw(sum);
use threads;

sub workfunc {
    my ($id, $init) = @_;

    printf "Process %d :: started at %s\n", $id, scalar localtime;
    my $start = time;
    $init += ( $_ % 4 ) * ( $_ % 4 ) / ( $_ % 10 + 1 ) for 1 .. 10_000_000;
    printf "Process %d :: stopped at %s\n", $id, scalar localtime;

    return time - $start;
}

my $num_threads = shift || 2;
print "Running with $num_threads processes\n";

my $master_start = time;
my @threads =
  map { threads->create( \&workfunc, $_, rand 10 ); } 1 .. $num_threads;

my $thread_time = sum map { $_->join() } @threads;
my $master_time = time - $master_start;

printf "Master logged %.3f runtime\n", $master_time;
printf "Processes reported %.3f combined runtime\n", $thread_time;
