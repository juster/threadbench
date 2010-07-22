from multiprocessing import Process, Queue
from random          import randint
from time            import asctime, time
from sys             import argv

timequeue = Queue()

def worker ( id, init ):
    start = time()
    print "Process %d :: started at %s" % ( id, asctime() )

    for i in xrange( 1, 10000000 ):
        init += ( i % 4 ) * ( i % 4 ) / ( i % 10 + 1 )

    timequeue.put( time() - start )
    print "Process %s :: stopped at %s" % ( id, asctime() )

    return

proc_count = 2
try:    proc_count = int( argv[1] )
except: pass

print "Running with %d processes" % (proc_count)
proc_count += 1 # increment for range

start = time()
procs = []

for i in range( 1, proc_count ):
    Process( target = worker, args = ( i, randint( 0, 10 ) )).start()

timesum = 0
for i in range( 1, proc_count ):
    timesum += timequeue.get()

print "Master logged %f runtime" % (time() - start)
print "Threads reported %f combined runtime" % (timesum)
