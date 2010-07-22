#!/usr/bin/perl

use warnings;
use strict;

use Time::HiRes qw(time);
use List::Util  qw(sum);
use Coro;

sub workfunc {
    my ($id, $init) = @_;

    printf "Coroutine %d :: started at %s\n", $id, scalar localtime;
    my $start = time;
    for ( 1 .. 10_000_000 ) {
        $init += ( $_ % 4 ) * ( $_ % 4 ) / ( $_ % 10 + 1 );
        cede;
    }
    printf "Coroutine %d :: stopped at %s\n", $id, scalar localtime;

    terminate time - $start;
}

my $coro_count = shift || 2;
print "Running with $coro_count coroutines\n";

my $master_start = time;
my @coros =
  map { async \&workfunc, $_, rand 10 } 1 .. $coro_count;

my $child_time  = sum map { $_->join() } @coros;
my $master_time = time - $master_start;

printf "Master logged %.3f runtime\n", $master_time;
printf "Coroutines reported %.3f combined runtime\n", $child_time;
