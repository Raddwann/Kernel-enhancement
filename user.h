
struct stat;

// system calls
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(const char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
//Project
struct sysinfo {
  int nprocs;
  int nrunning;
  int freemem;
};
// Project

struct top_proc {
  int pid;
  int cputime;
  char name[16];
};
#define PROC_NAME_LEN 16

struct procinfo {
  int pid;
  int state;
  int ppid;
  int sz; // memory size in bytes
  char name[PROC_NAME_LEN];
};
struct diskstats {
 uint64 read_count;
  uint64 write_count;
  uint64 read_bytes;
  uint64 write_bytes;
};
int top(struct top_proc *tops, int n);
int getsysinfo(struct sysinfo*);
int getprocinfo(int pid, struct procinfo *info);
uint64 getinterruptcount(void);
int getdiskstats(struct diskstats *stats);

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
int atoi(const char*);
int memcmp(const void *, const void *, uint);
void *memcpy(void *, const void *, uint);

// umalloc.c
void* malloc(uint);
void free(void*);
