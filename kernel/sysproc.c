#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h" // project
#include "virtio.h"
//project

uint64 
sys_getdiskstats(void) {
    struct diskstats stats;

    // Copy current disk stats under lock if needed
    stats = disk_stats; // If disk_stats is updated atomically or under lock

    // Copy to user space pointer from arg0
    struct diskstats *user_ptr;
    argaddr(0, (uint64*)&user_ptr);

    if (copyout(myproc()->pagetable, (uint64)user_ptr, (char *)&stats, sizeof(stats)) < 0)
        return -1;

    return 0;
}

uint64
sys_getprocinfo(void)
{
  int pid;
  struct procinfo info;
  uint64 user_addr;  // user pointer to struct procinfo

  // get the pid argument
  argint(0, &pid);

  // get the user-space pointer argument (second argument)
  argaddr(1, &user_addr);
    

  // fill info struct in kernel space
  if (getprocinfo(pid, &info) < 0)
    return -1;

  // copy info from kernel space to user space at user_addr
  if (copyout(myproc()->pagetable, user_addr, (char*)&info, sizeof(info)) < 0)
    return -1;

  return 0;
}

uint64
sys_getinterruptcount(void)
{
  return get_interrupt_count();
}

uint64
sys_top(void)
{
  uint64 addr;
  int n;

  argaddr(0, &addr);   // Gets the user-space address to copy data to
  argint(1, &n);       // Gets the number of top processes requested

  if (n <= 0 || n > NPROC)
    return -1;
  struct top_proc tops[NPROC];  // struct top_proc tops[n];  

  int actual = gettop(tops, n);

  if (copyout(myproc()->pagetable, addr,(char *)tops, actual * sizeof(struct top_proc)) < 0)
    return -1;

  return actual;
}





uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
// Project
extern struct proc proc[NPROC];

uint64
sys_getsysinfo(void)
{
  struct sysinfo info;
  struct proc *p;
  int nprocs = 0;
  int nrunning = 0;

  for (p = proc; p < &proc[NPROC]; p++) {
    if (p->state != UNUSED)
      nprocs++;
    if (p->state == RUNNABLE)
      nrunning++;
  }

  info.nprocs = nprocs;
  info.nrunning = nrunning;
  info.freemem = (freepages()) * PGSIZE; // freepages() returns pages

  uint64 addr;
  argaddr(0, &addr);
  if (copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0)
    return -1;

  return 0;
}
