#!/usr/bin/perl

use warnings;
use strict;
use English qw(-no_match_vars);

# Allow paths to perl or python to be overriden by env variables...
my ($PERL, $PYTHON) = ( $ENV{PERL}   || "perl",
                        $ENV{PYTHON} || "python", );

# Allow list of commands to be overriden by command line arguments...
my @commands = ( scalar @ARGV
                 ? @ARGV
                 : ( "$PERL -v", "$PYTHON -V",
                     map { glob } ( 'process.*',   'process-share.*',
                                    'coroutine.*', 'coroutine-share.*', )));

# Pipe our STDOUT and STDERR to output.txt...
open my $output,    '>',  'output.txt' or die "open output.txt: $!";
open my $oldstdout, '>&', \*STDOUT     or die "duping STDOUT: $!"; 

close STDOUT;
close STDERR;

open STDOUT, q{>&}, $output or die "piping STDOUT: $!";
open STDERR, q{>&}, $output or die "piping STDERR: $!";

# Loop through each command and use our interpreter paths if it is a script...
CMD_LOOP:
for my $cmd ( @commands ) {
    print $oldstdout ($cmd, "\n");
    print "COMMAND: $cmd\nOUTPUT:\n";
    if    ( $cmd =~ /[.]pl\z/ ) { system $PERL  , $cmd }
    elsif ( $cmd =~ /[.]py\z/ ) { system $PYTHON, $cmd }
    else                        { system $cmd          }

    if ( $? ) {
        print "Command failed. Aborting benchmark.\n";
        print $oldstdout "Command failed. Aborting benchmark.\n";
        last CMD_LOOP;
    }

    print "\n----\n\n";
}

print "EOF\n";
