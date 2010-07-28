import math
import random
import time
import sys
import threading
thread_times = []

def workfunc(id,init):
 l = threading.local()
 l.start = time.clock()
 print "Thread "+str(id)+" :: started at "+time.asctime()
 for i in xrange (1, 10000000):
  init += ((i%4)*(i%4)) / (i%10+1)
 l.runtime = time.clock() - l.start
 thread_times.append(l.runtime)
 print "Thread "+str(id)+" :: stopped at "+time.asctime()
 return l.runtime

# Setup
num_threads = 2
if len(sys.argv)>1:
 num_threads = int(sys.argv[1])
print "Running with "+str(num_threads)+" threads"

# Main code
master_start = time.clock()
threads = []
for i in xrange (1, num_threads+1):
 t = threading.Thread(target=workfunc,args=(i,random.random()*10))
 t.start()
 threads.append(t)
for t in threads:
 t.join()
master_time = time.clock() - master_start

# Find and print times
thread_time = 0
for t in thread_times:
 thread_time += t
print "Master logged "+str(master_time)+" runtime";
print "Threads reported "+str(thread_time)+" combined runtime";
