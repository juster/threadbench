use strict;
use warnings;
use threads;
use threads::shared;
use Time::HiRes qw/time/;
use List::Util  qw(sum);

sub workfunc {
    my ($id, $init) = @_;

    printf "Thread %d :: started at %s\n", $id, scalar localtime;
    my $start = time;
    $init += ( $_ % 4 ) * ( $_ % 4 ) / ( $_ % 10 + 1 ) for 1 .. 10_000_000;
    printf "Thread %d :: stopped at %s\n", $id, scalar localtime;

    return time - $start;
}

my $num_threads = shift || 2;
print "Running with $num_threads threads\n";

my $master_start = time;
my @threads =
  map { threads->create( \&workfunc, $_, rand 10 ); } 1 .. $num_threads;

my $thread_time = sum map { $_->join() } @threads;
my $master_time = time - $master_start;

printf "Master logged %.3f runtime\n", $master_time;
printf "Threads reported %.3f combined runtime\n", $thread_time;
