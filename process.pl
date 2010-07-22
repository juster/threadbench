use strict;
use warnings;
use threads;
use threads::shared;
use Time::HiRes qw/time/;
use List::Util  qw(sum);

sub workfunc {
    printf "Thread %d :: started at %s\n", threads::tid(), scalar localtime;
    my $start = time;
    my $init  = shift;
    for ( 1 .. 10_000_000 ) {
        $init += ( ( $_ % 4 ) * ( $_ % 4 ) ) / ( $_ % 10 + 1 );
    }
    printf "Thread %d :: stopped at %s\n", threads::tid(), scalar localtime;
    return time - $start;
}

my $num_threads = shift || 2;
print "Running with $num_threads threads\n";

my $master_start = time;
my @threads =
  map { threads->create( \&workfunc, rand 10 ); } 1 .. $num_threads;

my $thread_time = sum map { $_->join() } @threads;
my $master_time = time - $master_start;

printf "Master logged %.3f runtime\n", $master_time;
printf "Threads reported %.3f combined runtime\n", $thread_time;
