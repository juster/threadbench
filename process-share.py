from multiprocessing import Process, Queue, Value, Lock
from random          import random
from time            import asctime, time
from sys             import argv

timequeue = Queue()
# The below doesn't work with python 2.6 included with Mac OS X... bug?
counter   = Value( 'd', 0, lock = False )
lock      = Lock()

def worker ( id, init ):
    start = time()
    print "Process %d :: started at %s" % ( id, asctime() )

    for i in xrange( 1, 10000001 ):
        init += ( i % 4 ) * ( i % 4 ) / ( i % 10 + 1 )

        lock.acquire()
        # We have to use our own lock, doing += by itself doesn't lock properly.
        counter.value += 1
        lock.release()

    timequeue.put( time() - start )
    print "Process %s :: stopped at %s" % ( id, asctime() )

    # Perl is easier, we cannot return values directly from processes here
    return

proc_count = 2
try:    proc_count = int( argv[1] )
except: pass

print "Running with %d processes" % (proc_count)
proc_count += 1 # increment for range

start = time()
procs = []

for i in range( 1, proc_count ):
    Process( target = worker, args = ( i, random() * 10 )).start()

timesum = 0
for i in range( 1, proc_count ):
    timesum += timequeue.get()

print "Master logged %.3f runtime" % (time() - start)
print "Threads reported %.3f combined runtime" % (timesum)
print "Shared counter equals %d" % (counter.value)
