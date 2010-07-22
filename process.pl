use strict;
use warnings;
use threads;
use threads::shared;
use Time::HiRes qw/time/;

my @thread_times : shared;

sub workfunc {
    my $start = time();
    print "Thread " . threads::tid() . " :: started at " . localtime() . "\n";
    my $init = shift;
    for ( 1 .. 10_000_000 ) {
        $init += ( ( $_ % 4 ) * ( $_ % 4 ) ) / ( $_ % 10 + 1 );
    }
    my $runtime = time() - $start;
    { lock(@thread_times); push( @thread_times, $runtime ); }
    print "Thread " . threads::tid() . " :: stopped at " . localtime() . "\n";
    return $runtime;
}

# Setup
my $num_threads = shift || 2;
print "Running with $num_threads threads\n";

# Main code
my $master_start = time();
my @threads =
  map { threads->create( \&workfunc, rand(10) ); } 1 .. $num_threads;
my $thread_time = 0;
for my $t (@threads) {
    $thread_time += $t->join();
}
my $master_time = time() - $master_start;

# Find and print times
my $lock_time = 0;
{ lock(@thread_times); $lock_time += $_ for @thread_times; }
print "Master logged $master_time runtime\n";
print "Threads reported $lock_time combined runtime\n";
