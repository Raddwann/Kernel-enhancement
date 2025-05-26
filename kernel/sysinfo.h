#ifndef SYSINFO_H
#define SYSINFO_H
#define PROC_NAME_LEN 16

struct sysinfo {
  int nprocs;
  int nrunning;
  int freemem;
};

struct top_proc {
  int pid;
  int cputime;
  char name[16];
};

struct procinfo {
  int pid;
  int state;
  int ppid;
  int sz; // memory size in bytes
  char name[PROC_NAME_LEN];
};

#endif
