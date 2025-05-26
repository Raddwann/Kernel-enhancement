#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
  printf("###############getsysinfo#################\n");
  struct sysinfo info;
  if (getsysinfo(&info) == 0) {
    printf("Total processes: %d\n", info.nprocs);
    printf("Runnable processes: %d\n", info.nrunning);
    printf("Free memory: %d bytes\n", info.freemem);
  } else {
    printf("getsysinfo failed\n");
  }
 printf("#########################################\n");
 printf("###############top#################\n"); 

  struct top_proc tops[5];
  int n = top(tops, 5);

  printf("Top %d processes by CPU time:\n", n);
  for (int i = 0; i < n; i++) {
    printf("PID: %d, CPU Time: %d, Name: %s\n", tops[i].pid, tops[i].cputime, tops[i].name);
  }
  printf("##########################################\n"); 
printf("#################getprocinfo#########################\n"); 

 int pid = 1; // example PID
struct procinfo info2;

if (getprocinfo(pid, &info2) == 0) {
  printf("PID: %d, State: %d, PPID: %d, Size: %llu, Name: %s\n",
         info2.pid, info2.state, info2.ppid, (unsigned long long)info2.sz, info2.name);
} else {
  printf("Process %d not found\n", pid);
}
printf("##########################################\n"); 
printf("##############getInterruptCount############################\n"); 


    uint64 count = getinterruptcount();
    printf("Interrupts handled: %d\n", (int)count);
    
printf("##########################################\n"); 
  printf("################ getdiskstats ##########################\n");
  struct diskstats dstats;
  if (getdiskstats(&dstats) == 0) {
    printf("Disk Reads: %lu\n", dstats.read_count);
    printf("Disk Writes: %lu\n", dstats.write_count);
    printf("Bytes Read: %lu\n", dstats.read_bytes);
    printf("Bytes Written: %lu\n", dstats.write_bytes);
  } else {
    printf("getdiskstats syscall failed\n");
  }
  printf("##########################################\n");

  exit(0);
}

