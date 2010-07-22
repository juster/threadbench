from threading import Thread
from random    import random
from time      import asctime, time
from sys       import argv

child_times = []

def worker ( id, init ):
    start = time()
    print "Coroutine %d :: started at %s" % ( id, asctime() )

    for i in xrange( 1, 10000001 ):
        init += ( i % 4 ) * ( i % 4 ) / ( i % 10 + 1 )

    child_times.append( time() - start )
    print "Coroutine %s :: stopped at %s" % ( id, asctime() )

child_count = 2
try:    child_count = int( argv[1] )
except: pass

print "Running with %d coroutines" % (child_count)
child_count += 1 # increment for range

children = []
start    = time()

children = [ Thread( target = worker,
                     args   = ( i, random() * 10 )
                     ) for i in range( 1, child_count ) ]

for c in children: c.start()
for c in children: c.join()

print "Master logged %.3f runtime" % (time() - start)
print "Coroutines reported %.3f combined runtime" % (sum(child_times))
