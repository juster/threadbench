use strict;
use warnings;
use threads;
use threads::shared;
use Time::HiRes qw/time/;
use List::Util  qw(sum);

sub workfunc {
    my $start = time();
    print "Thread " . threads::tid() . " :: started at " . localtime() . "\n";
    my $init = shift;
    for ( 1 .. 10_000_000 ) {
        $init += ( ( $_ % 4 ) * ( $_ % 4 ) ) / ( $_ % 10 + 1 );
    }
    my $runtime = time() - $start;
    print "Thread " . threads::tid() . " :: stopped at " . localtime() . "\n";
    return $runtime;
}

my $num_threads = shift || 2;
print "Running with $num_threads threads\n";

my $master_start = time();
my @threads =
  map { threads->create( \&workfunc, rand(10) ); } 1 .. $num_threads;

my $thread_time = sum map { $_->join() } @threads;
my $master_time = time() - $master_start;

print "Master logged $master_time runtime\n";
print "Threads reported $thread_time combined runtime\n";
