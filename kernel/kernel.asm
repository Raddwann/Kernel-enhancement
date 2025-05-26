
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	3c013103          	ld	sp,960(sp) # 8000a3c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0c6050ef          	jal	800050dc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00029797          	auipc	a5,0x29
    80000034:	56078793          	addi	a5,a5,1376 # 80029590 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	3dc90913          	addi	s2,s2,988 # 8000a420 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	2f1050ef          	jal	80005b3e <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	379050ef          	jal	80005bd6 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	79a050ef          	jal	80005810 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	6985                	lui	s3,0x1
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	34e50513          	addi	a0,a0,846 # 8000a420 <kmem>
    800000da:	1e5050ef          	jal	80005abe <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00029517          	auipc	a0,0x29
    800000e6:	4ae50513          	addi	a0,a0,1198 # 80029590 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	32048493          	addi	s1,s1,800 # 8000a420 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	235050ef          	jal	80005b3e <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	32f73223          	sd	a5,804(a4) # 8000a438 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	30450513          	addi	a0,a0,772 # 8000a420 <kmem>
    80000124:	2b3050ef          	jal	80005bd6 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <freepages>:

// Project
int
freepages(void) {
    80000134:	1101                	addi	sp,sp,-32
    80000136:	ec06                	sd	ra,24(sp)
    80000138:	e822                	sd	s0,16(sp)
    8000013a:	e426                	sd	s1,8(sp)
    8000013c:	1000                	addi	s0,sp,32
  struct run *r;
  int count = 0;
  acquire(&kmem.lock);
    8000013e:	0000a497          	auipc	s1,0xa
    80000142:	2e248493          	addi	s1,s1,738 # 8000a420 <kmem>
    80000146:	8526                	mv	a0,s1
    80000148:	1f7050ef          	jal	80005b3e <acquire>
  for (r = kmem.freelist; r; r = r->next)
    8000014c:	6c9c                	ld	a5,24(s1)
    8000014e:	c38d                	beqz	a5,80000170 <freepages+0x3c>
  int count = 0;
    80000150:	4481                	li	s1,0
    count++;
    80000152:	2485                	addiw	s1,s1,1
  for (r = kmem.freelist; r; r = r->next)
    80000154:	639c                	ld	a5,0(a5)
    80000156:	fff5                	bnez	a5,80000152 <freepages+0x1e>
  release(&kmem.lock);
    80000158:	0000a517          	auipc	a0,0xa
    8000015c:	2c850513          	addi	a0,a0,712 # 8000a420 <kmem>
    80000160:	277050ef          	jal	80005bd6 <release>
  return count;
}
    80000164:	8526                	mv	a0,s1
    80000166:	60e2                	ld	ra,24(sp)
    80000168:	6442                	ld	s0,16(sp)
    8000016a:	64a2                	ld	s1,8(sp)
    8000016c:	6105                	addi	sp,sp,32
    8000016e:	8082                	ret
  int count = 0;
    80000170:	4481                	li	s1,0
    80000172:	b7dd                	j	80000158 <freepages+0x24>

0000000080000174 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e422                	sd	s0,8(sp)
    80000178:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017a:	ca19                	beqz	a2,80000190 <memset+0x1c>
    8000017c:	87aa                	mv	a5,a0
    8000017e:	1602                	slli	a2,a2,0x20
    80000180:	9201                	srli	a2,a2,0x20
    80000182:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000186:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018a:	0785                	addi	a5,a5,1
    8000018c:	fee79de3          	bne	a5,a4,80000186 <memset+0x12>
  }
  return dst;
}
    80000190:	6422                	ld	s0,8(sp)
    80000192:	0141                	addi	sp,sp,16
    80000194:	8082                	ret

0000000080000196 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000196:	1141                	addi	sp,sp,-16
    80000198:	e422                	sd	s0,8(sp)
    8000019a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000019c:	ca05                	beqz	a2,800001cc <memcmp+0x36>
    8000019e:	fff6069b          	addiw	a3,a2,-1
    800001a2:	1682                	slli	a3,a3,0x20
    800001a4:	9281                	srli	a3,a3,0x20
    800001a6:	0685                	addi	a3,a3,1
    800001a8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001aa:	00054783          	lbu	a5,0(a0)
    800001ae:	0005c703          	lbu	a4,0(a1)
    800001b2:	00e79863          	bne	a5,a4,800001c2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001b6:	0505                	addi	a0,a0,1
    800001b8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001ba:	fed518e3          	bne	a0,a3,800001aa <memcmp+0x14>
  }

  return 0;
    800001be:	4501                	li	a0,0
    800001c0:	a019                	j	800001c6 <memcmp+0x30>
      return *s1 - *s2;
    800001c2:	40e7853b          	subw	a0,a5,a4
}
    800001c6:	6422                	ld	s0,8(sp)
    800001c8:	0141                	addi	sp,sp,16
    800001ca:	8082                	ret
  return 0;
    800001cc:	4501                	li	a0,0
    800001ce:	bfe5                	j	800001c6 <memcmp+0x30>

00000000800001d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d0:	1141                	addi	sp,sp,-16
    800001d2:	e422                	sd	s0,8(sp)
    800001d4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001d6:	c205                	beqz	a2,800001f6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001d8:	02a5e263          	bltu	a1,a0,800001fc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001dc:	1602                	slli	a2,a2,0x20
    800001de:	9201                	srli	a2,a2,0x20
    800001e0:	00c587b3          	add	a5,a1,a2
{
    800001e4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001e6:	0585                	addi	a1,a1,1
    800001e8:	0705                	addi	a4,a4,1
    800001ea:	fff5c683          	lbu	a3,-1(a1)
    800001ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f2:	feb79ae3          	bne	a5,a1,800001e6 <memmove+0x16>

  return dst;
}
    800001f6:	6422                	ld	s0,8(sp)
    800001f8:	0141                	addi	sp,sp,16
    800001fa:	8082                	ret
  if(s < d && s + n > d){
    800001fc:	02061693          	slli	a3,a2,0x20
    80000200:	9281                	srli	a3,a3,0x20
    80000202:	00d58733          	add	a4,a1,a3
    80000206:	fce57be3          	bgeu	a0,a4,800001dc <memmove+0xc>
    d += n;
    8000020a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000020c:	fff6079b          	addiw	a5,a2,-1
    80000210:	1782                	slli	a5,a5,0x20
    80000212:	9381                	srli	a5,a5,0x20
    80000214:	fff7c793          	not	a5,a5
    80000218:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021a:	177d                	addi	a4,a4,-1
    8000021c:	16fd                	addi	a3,a3,-1
    8000021e:	00074603          	lbu	a2,0(a4)
    80000222:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000226:	fef71ae3          	bne	a4,a5,8000021a <memmove+0x4a>
    8000022a:	b7f1                	j	800001f6 <memmove+0x26>

000000008000022c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000022c:	1141                	addi	sp,sp,-16
    8000022e:	e406                	sd	ra,8(sp)
    80000230:	e022                	sd	s0,0(sp)
    80000232:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000234:	f9dff0ef          	jal	800001d0 <memmove>
}
    80000238:	60a2                	ld	ra,8(sp)
    8000023a:	6402                	ld	s0,0(sp)
    8000023c:	0141                	addi	sp,sp,16
    8000023e:	8082                	ret

0000000080000240 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e422                	sd	s0,8(sp)
    80000244:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000246:	ce11                	beqz	a2,80000262 <strncmp+0x22>
    80000248:	00054783          	lbu	a5,0(a0)
    8000024c:	cf89                	beqz	a5,80000266 <strncmp+0x26>
    8000024e:	0005c703          	lbu	a4,0(a1)
    80000252:	00f71a63          	bne	a4,a5,80000266 <strncmp+0x26>
    n--, p++, q++;
    80000256:	367d                	addiw	a2,a2,-1
    80000258:	0505                	addi	a0,a0,1
    8000025a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000025c:	f675                	bnez	a2,80000248 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000025e:	4501                	li	a0,0
    80000260:	a801                	j	80000270 <strncmp+0x30>
    80000262:	4501                	li	a0,0
    80000264:	a031                	j	80000270 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000266:	00054503          	lbu	a0,0(a0)
    8000026a:	0005c783          	lbu	a5,0(a1)
    8000026e:	9d1d                	subw	a0,a0,a5
}
    80000270:	6422                	ld	s0,8(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret

0000000080000276 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000027c:	87aa                	mv	a5,a0
    8000027e:	86b2                	mv	a3,a2
    80000280:	367d                	addiw	a2,a2,-1
    80000282:	02d05563          	blez	a3,800002ac <strncpy+0x36>
    80000286:	0785                	addi	a5,a5,1
    80000288:	0005c703          	lbu	a4,0(a1)
    8000028c:	fee78fa3          	sb	a4,-1(a5)
    80000290:	0585                	addi	a1,a1,1
    80000292:	f775                	bnez	a4,8000027e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000294:	873e                	mv	a4,a5
    80000296:	9fb5                	addw	a5,a5,a3
    80000298:	37fd                	addiw	a5,a5,-1
    8000029a:	00c05963          	blez	a2,800002ac <strncpy+0x36>
    *s++ = 0;
    8000029e:	0705                	addi	a4,a4,1
    800002a0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002a4:	40e786bb          	subw	a3,a5,a4
    800002a8:	fed04be3          	bgtz	a3,8000029e <strncpy+0x28>
  return os;
}
    800002ac:	6422                	ld	s0,8(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret

00000000800002b2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e422                	sd	s0,8(sp)
    800002b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002b8:	02c05363          	blez	a2,800002de <safestrcpy+0x2c>
    800002bc:	fff6069b          	addiw	a3,a2,-1
    800002c0:	1682                	slli	a3,a3,0x20
    800002c2:	9281                	srli	a3,a3,0x20
    800002c4:	96ae                	add	a3,a3,a1
    800002c6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002c8:	00d58963          	beq	a1,a3,800002da <safestrcpy+0x28>
    800002cc:	0585                	addi	a1,a1,1
    800002ce:	0785                	addi	a5,a5,1
    800002d0:	fff5c703          	lbu	a4,-1(a1)
    800002d4:	fee78fa3          	sb	a4,-1(a5)
    800002d8:	fb65                	bnez	a4,800002c8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002da:	00078023          	sb	zero,0(a5)
  return os;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret

00000000800002e4 <strlen>:

int
strlen(const char *s)
{
    800002e4:	1141                	addi	sp,sp,-16
    800002e6:	e422                	sd	s0,8(sp)
    800002e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002ea:	00054783          	lbu	a5,0(a0)
    800002ee:	cf91                	beqz	a5,8000030a <strlen+0x26>
    800002f0:	0505                	addi	a0,a0,1
    800002f2:	87aa                	mv	a5,a0
    800002f4:	86be                	mv	a3,a5
    800002f6:	0785                	addi	a5,a5,1
    800002f8:	fff7c703          	lbu	a4,-1(a5)
    800002fc:	ff65                	bnez	a4,800002f4 <strlen+0x10>
    800002fe:	40a6853b          	subw	a0,a3,a0
    80000302:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000304:	6422                	ld	s0,8(sp)
    80000306:	0141                	addi	sp,sp,16
    80000308:	8082                	ret
  for(n = 0; s[n]; n++)
    8000030a:	4501                	li	a0,0
    8000030c:	bfe5                	j	80000304 <strlen+0x20>

000000008000030e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e406                	sd	ra,8(sp)
    80000312:	e022                	sd	s0,0(sp)
    80000314:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000316:	3d9000ef          	jal	80000eee <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000031a:	0000a717          	auipc	a4,0xa
    8000031e:	0c670713          	addi	a4,a4,198 # 8000a3e0 <started>
  if(cpuid() == 0){
    80000322:	c51d                	beqz	a0,80000350 <main+0x42>
    while(started == 0)
    80000324:	431c                	lw	a5,0(a4)
    80000326:	2781                	sext.w	a5,a5
    80000328:	dff5                	beqz	a5,80000324 <main+0x16>
      ;
    __sync_synchronize();
    8000032a:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000032e:	3c1000ef          	jal	80000eee <cpuid>
    80000332:	85aa                	mv	a1,a0
    80000334:	00007517          	auipc	a0,0x7
    80000338:	d0450513          	addi	a0,a0,-764 # 80007038 <etext+0x38>
    8000033c:	202050ef          	jal	8000553e <printf>
    kvminithart();    // turn on paging
    80000340:	080000ef          	jal	800003c0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000344:	736010ef          	jal	80001a7a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000348:	770040ef          	jal	80004ab8 <plicinithart>
  }

  scheduler();        
    8000034c:	014010ef          	jal	80001360 <scheduler>
    consoleinit();
    80000350:	118050ef          	jal	80005468 <consoleinit>
    printfinit();
    80000354:	4f6050ef          	jal	8000584a <printfinit>
    printf("\n");
    80000358:	00007517          	auipc	a0,0x7
    8000035c:	cc050513          	addi	a0,a0,-832 # 80007018 <etext+0x18>
    80000360:	1de050ef          	jal	8000553e <printf>
    printf("xv6 kernel is booting\n");
    80000364:	00007517          	auipc	a0,0x7
    80000368:	cbc50513          	addi	a0,a0,-836 # 80007020 <etext+0x20>
    8000036c:	1d2050ef          	jal	8000553e <printf>
    printf("\n");
    80000370:	00007517          	auipc	a0,0x7
    80000374:	ca850513          	addi	a0,a0,-856 # 80007018 <etext+0x18>
    80000378:	1c6050ef          	jal	8000553e <printf>
    kinit();         // physical page allocator
    8000037c:	d47ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000380:	2ca000ef          	jal	8000064a <kvminit>
    kvminithart();   // turn on paging
    80000384:	03c000ef          	jal	800003c0 <kvminithart>
    procinit();      // process table
    80000388:	2af000ef          	jal	80000e36 <procinit>
    trapinit();      // trap vectors
    8000038c:	6ca010ef          	jal	80001a56 <trapinit>
    trapinithart();  // install kernel trap vector
    80000390:	6ea010ef          	jal	80001a7a <trapinithart>
    plicinit();      // set up interrupt controller
    80000394:	70a040ef          	jal	80004a9e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000398:	720040ef          	jal	80004ab8 <plicinithart>
    binit();         // buffer cache
    8000039c:	6c1010ef          	jal	8000225c <binit>
    iinit();         // inode table
    800003a0:	4b2020ef          	jal	80002852 <iinit>
    fileinit();      // file table
    800003a4:	25e030ef          	jal	80003602 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003a8:	001040ef          	jal	80004ba8 <virtio_disk_init>
    userinit();      // first user process
    800003ac:	5e1000ef          	jal	8000118c <userinit>
    __sync_synchronize();
    800003b0:	0330000f          	fence	rw,rw
    started = 1;
    800003b4:	4785                	li	a5,1
    800003b6:	0000a717          	auipc	a4,0xa
    800003ba:	02f72523          	sw	a5,42(a4) # 8000a3e0 <started>
    800003be:	b779                	j	8000034c <main+0x3e>

00000000800003c0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003c0:	1141                	addi	sp,sp,-16
    800003c2:	e422                	sd	s0,8(sp)
    800003c4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003c6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003ca:	0000a797          	auipc	a5,0xa
    800003ce:	01e7b783          	ld	a5,30(a5) # 8000a3e8 <kernel_pagetable>
    800003d2:	83b1                	srli	a5,a5,0xc
    800003d4:	577d                	li	a4,-1
    800003d6:	177e                	slli	a4,a4,0x3f
    800003d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003da:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003de:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003e2:	6422                	ld	s0,8(sp)
    800003e4:	0141                	addi	sp,sp,16
    800003e6:	8082                	ret

00000000800003e8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003e8:	7139                	addi	sp,sp,-64
    800003ea:	fc06                	sd	ra,56(sp)
    800003ec:	f822                	sd	s0,48(sp)
    800003ee:	f426                	sd	s1,40(sp)
    800003f0:	f04a                	sd	s2,32(sp)
    800003f2:	ec4e                	sd	s3,24(sp)
    800003f4:	e852                	sd	s4,16(sp)
    800003f6:	e456                	sd	s5,8(sp)
    800003f8:	e05a                	sd	s6,0(sp)
    800003fa:	0080                	addi	s0,sp,64
    800003fc:	84aa                	mv	s1,a0
    800003fe:	89ae                	mv	s3,a1
    80000400:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000402:	57fd                	li	a5,-1
    80000404:	83e9                	srli	a5,a5,0x1a
    80000406:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000408:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000040a:	02b7fc63          	bgeu	a5,a1,80000442 <walk+0x5a>
    panic("walk");
    8000040e:	00007517          	auipc	a0,0x7
    80000412:	c4250513          	addi	a0,a0,-958 # 80007050 <etext+0x50>
    80000416:	3fa050ef          	jal	80005810 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000041a:	060a8263          	beqz	s5,8000047e <walk+0x96>
    8000041e:	cd9ff0ef          	jal	800000f6 <kalloc>
    80000422:	84aa                	mv	s1,a0
    80000424:	c139                	beqz	a0,8000046a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000426:	6605                	lui	a2,0x1
    80000428:	4581                	li	a1,0
    8000042a:	d4bff0ef          	jal	80000174 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000042e:	00c4d793          	srli	a5,s1,0xc
    80000432:	07aa                	slli	a5,a5,0xa
    80000434:	0017e793          	ori	a5,a5,1
    80000438:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000043c:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd5a67>
    8000043e:	036a0063          	beq	s4,s6,8000045e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000442:	0149d933          	srl	s2,s3,s4
    80000446:	1ff97913          	andi	s2,s2,511
    8000044a:	090e                	slli	s2,s2,0x3
    8000044c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000044e:	00093483          	ld	s1,0(s2)
    80000452:	0014f793          	andi	a5,s1,1
    80000456:	d3f1                	beqz	a5,8000041a <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000458:	80a9                	srli	s1,s1,0xa
    8000045a:	04b2                	slli	s1,s1,0xc
    8000045c:	b7c5                	j	8000043c <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000045e:	00c9d513          	srli	a0,s3,0xc
    80000462:	1ff57513          	andi	a0,a0,511
    80000466:	050e                	slli	a0,a0,0x3
    80000468:	9526                	add	a0,a0,s1
}
    8000046a:	70e2                	ld	ra,56(sp)
    8000046c:	7442                	ld	s0,48(sp)
    8000046e:	74a2                	ld	s1,40(sp)
    80000470:	7902                	ld	s2,32(sp)
    80000472:	69e2                	ld	s3,24(sp)
    80000474:	6a42                	ld	s4,16(sp)
    80000476:	6aa2                	ld	s5,8(sp)
    80000478:	6b02                	ld	s6,0(sp)
    8000047a:	6121                	addi	sp,sp,64
    8000047c:	8082                	ret
        return 0;
    8000047e:	4501                	li	a0,0
    80000480:	b7ed                	j	8000046a <walk+0x82>

0000000080000482 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000482:	57fd                	li	a5,-1
    80000484:	83e9                	srli	a5,a5,0x1a
    80000486:	00b7f463          	bgeu	a5,a1,8000048e <walkaddr+0xc>
    return 0;
    8000048a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000048c:	8082                	ret
{
    8000048e:	1141                	addi	sp,sp,-16
    80000490:	e406                	sd	ra,8(sp)
    80000492:	e022                	sd	s0,0(sp)
    80000494:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000496:	4601                	li	a2,0
    80000498:	f51ff0ef          	jal	800003e8 <walk>
  if(pte == 0)
    8000049c:	c105                	beqz	a0,800004bc <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000049e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004a0:	0117f693          	andi	a3,a5,17
    800004a4:	4745                	li	a4,17
    return 0;
    800004a6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004a8:	00e68663          	beq	a3,a4,800004b4 <walkaddr+0x32>
}
    800004ac:	60a2                	ld	ra,8(sp)
    800004ae:	6402                	ld	s0,0(sp)
    800004b0:	0141                	addi	sp,sp,16
    800004b2:	8082                	ret
  pa = PTE2PA(*pte);
    800004b4:	83a9                	srli	a5,a5,0xa
    800004b6:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004ba:	bfcd                	j	800004ac <walkaddr+0x2a>
    return 0;
    800004bc:	4501                	li	a0,0
    800004be:	b7fd                	j	800004ac <walkaddr+0x2a>

00000000800004c0 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c0:	715d                	addi	sp,sp,-80
    800004c2:	e486                	sd	ra,72(sp)
    800004c4:	e0a2                	sd	s0,64(sp)
    800004c6:	fc26                	sd	s1,56(sp)
    800004c8:	f84a                	sd	s2,48(sp)
    800004ca:	f44e                	sd	s3,40(sp)
    800004cc:	f052                	sd	s4,32(sp)
    800004ce:	ec56                	sd	s5,24(sp)
    800004d0:	e85a                	sd	s6,16(sp)
    800004d2:	e45e                	sd	s7,8(sp)
    800004d4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d6:	03459793          	slli	a5,a1,0x34
    800004da:	e7a9                	bnez	a5,80000524 <mappages+0x64>
    800004dc:	8aaa                	mv	s5,a0
    800004de:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e0:	03461793          	slli	a5,a2,0x34
    800004e4:	e7b1                	bnez	a5,80000530 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e6:	ca39                	beqz	a2,8000053c <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004e8:	77fd                	lui	a5,0xfffff
    800004ea:	963e                	add	a2,a2,a5
    800004ec:	00b609b3          	add	s3,a2,a1
  a = va;
    800004f0:	892e                	mv	s2,a1
    800004f2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f6:	6b85                	lui	s7,0x1
    800004f8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	4605                	li	a2,1
    800004fe:	85ca                	mv	a1,s2
    80000500:	8556                	mv	a0,s5
    80000502:	ee7ff0ef          	jal	800003e8 <walk>
    80000506:	c539                	beqz	a0,80000554 <mappages+0x94>
    if(*pte & PTE_V)
    80000508:	611c                	ld	a5,0(a0)
    8000050a:	8b85                	andi	a5,a5,1
    8000050c:	ef95                	bnez	a5,80000548 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000050e:	80b1                	srli	s1,s1,0xc
    80000510:	04aa                	slli	s1,s1,0xa
    80000512:	0164e4b3          	or	s1,s1,s6
    80000516:	0014e493          	ori	s1,s1,1
    8000051a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051c:	05390863          	beq	s2,s3,8000056c <mappages+0xac>
    a += PGSIZE;
    80000520:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000522:	bfd9                	j	800004f8 <mappages+0x38>
    panic("mappages: va not aligned");
    80000524:	00007517          	auipc	a0,0x7
    80000528:	b3450513          	addi	a0,a0,-1228 # 80007058 <etext+0x58>
    8000052c:	2e4050ef          	jal	80005810 <panic>
    panic("mappages: size not aligned");
    80000530:	00007517          	auipc	a0,0x7
    80000534:	b4850513          	addi	a0,a0,-1208 # 80007078 <etext+0x78>
    80000538:	2d8050ef          	jal	80005810 <panic>
    panic("mappages: size");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b5c50513          	addi	a0,a0,-1188 # 80007098 <etext+0x98>
    80000544:	2cc050ef          	jal	80005810 <panic>
      panic("mappages: remap");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b6050513          	addi	a0,a0,-1184 # 800070a8 <etext+0xa8>
    80000550:	2c0050ef          	jal	80005810 <panic>
      return -1;
    80000554:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000556:	60a6                	ld	ra,72(sp)
    80000558:	6406                	ld	s0,64(sp)
    8000055a:	74e2                	ld	s1,56(sp)
    8000055c:	7942                	ld	s2,48(sp)
    8000055e:	79a2                	ld	s3,40(sp)
    80000560:	7a02                	ld	s4,32(sp)
    80000562:	6ae2                	ld	s5,24(sp)
    80000564:	6b42                	ld	s6,16(sp)
    80000566:	6ba2                	ld	s7,8(sp)
    80000568:	6161                	addi	sp,sp,80
    8000056a:	8082                	ret
  return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7e5                	j	80000556 <mappages+0x96>

0000000080000570 <kvmmap>:
{
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f43ff0ef          	jal	800004c0 <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
}
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
    panic("kvmmap");
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	27c050ef          	jal	80005810 <panic>

0000000080000598 <kvmmake>:
{
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a4:	b53ff0ef          	jal	800000f6 <kalloc>
    800005a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005aa:	6605                	lui	a2,0x1
    800005ac:	4581                	li	a1,0
    800005ae:	bc7ff0ef          	jal	80000174 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b2:	4719                	li	a4,6
    800005b4:	6685                	lui	a3,0x1
    800005b6:	10000637          	lui	a2,0x10000
    800005ba:	100005b7          	lui	a1,0x10000
    800005be:	8526                	mv	a0,s1
    800005c0:	fb1ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c4:	4719                	li	a4,6
    800005c6:	6685                	lui	a3,0x1
    800005c8:	10001637          	lui	a2,0x10001
    800005cc:	100015b7          	lui	a1,0x10001
    800005d0:	8526                	mv	a0,s1
    800005d2:	f9fff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d6:	4719                	li	a4,6
    800005d8:	040006b7          	lui	a3,0x4000
    800005dc:	0c000637          	lui	a2,0xc000
    800005e0:	0c0005b7          	lui	a1,0xc000
    800005e4:	8526                	mv	a0,s1
    800005e6:	f8bff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ea:	00007917          	auipc	s2,0x7
    800005ee:	a1690913          	addi	s2,s2,-1514 # 80007000 <etext>
    800005f2:	4729                	li	a4,10
    800005f4:	80007697          	auipc	a3,0x80007
    800005f8:	a0c68693          	addi	a3,a3,-1524 # 7000 <_entry-0x7fff9000>
    800005fc:	4605                	li	a2,1
    800005fe:	067e                	slli	a2,a2,0x1f
    80000600:	85b2                	mv	a1,a2
    80000602:	8526                	mv	a0,s1
    80000604:	f6dff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000608:	46c5                	li	a3,17
    8000060a:	06ee                	slli	a3,a3,0x1b
    8000060c:	4719                	li	a4,6
    8000060e:	412686b3          	sub	a3,a3,s2
    80000612:	864a                	mv	a2,s2
    80000614:	85ca                	mv	a1,s2
    80000616:	8526                	mv	a0,s1
    80000618:	f59ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000061c:	4729                	li	a4,10
    8000061e:	6685                	lui	a3,0x1
    80000620:	00006617          	auipc	a2,0x6
    80000624:	9e060613          	addi	a2,a2,-1568 # 80006000 <_trampoline>
    80000628:	040005b7          	lui	a1,0x4000
    8000062c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000062e:	05b2                	slli	a1,a1,0xc
    80000630:	8526                	mv	a0,s1
    80000632:	f3fff0ef          	jal	80000570 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000636:	8526                	mv	a0,s1
    80000638:	766000ef          	jal	80000d9e <proc_mapstacks>
}
    8000063c:	8526                	mv	a0,s1
    8000063e:	60e2                	ld	ra,24(sp)
    80000640:	6442                	ld	s0,16(sp)
    80000642:	64a2                	ld	s1,8(sp)
    80000644:	6902                	ld	s2,0(sp)
    80000646:	6105                	addi	sp,sp,32
    80000648:	8082                	ret

000000008000064a <kvminit>:
{
    8000064a:	1141                	addi	sp,sp,-16
    8000064c:	e406                	sd	ra,8(sp)
    8000064e:	e022                	sd	s0,0(sp)
    80000650:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000652:	f47ff0ef          	jal	80000598 <kvmmake>
    80000656:	0000a797          	auipc	a5,0xa
    8000065a:	d8a7b923          	sd	a0,-622(a5) # 8000a3e8 <kernel_pagetable>
}
    8000065e:	60a2                	ld	ra,8(sp)
    80000660:	6402                	ld	s0,0(sp)
    80000662:	0141                	addi	sp,sp,16
    80000664:	8082                	ret

0000000080000666 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000666:	715d                	addi	sp,sp,-80
    80000668:	e486                	sd	ra,72(sp)
    8000066a:	e0a2                	sd	s0,64(sp)
    8000066c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    8000066e:	03459793          	slli	a5,a1,0x34
    80000672:	e39d                	bnez	a5,80000698 <uvmunmap+0x32>
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    80000680:	8a2a                	mv	s4,a0
    80000682:	892e                	mv	s2,a1
    80000684:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000686:	0632                	slli	a2,a2,0xc
    80000688:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000068c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000068e:	6b05                	lui	s6,0x1
    80000690:	0935f763          	bgeu	a1,s3,8000071e <uvmunmap+0xb8>
    80000694:	fc26                	sd	s1,56(sp)
    80000696:	a8a1                	j	800006ee <uvmunmap+0x88>
    80000698:	fc26                	sd	s1,56(sp)
    8000069a:	f84a                	sd	s2,48(sp)
    8000069c:	f44e                	sd	s3,40(sp)
    8000069e:	f052                	sd	s4,32(sp)
    800006a0:	ec56                	sd	s5,24(sp)
    800006a2:	e85a                	sd	s6,16(sp)
    800006a4:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a6:	00007517          	auipc	a0,0x7
    800006aa:	a1a50513          	addi	a0,a0,-1510 # 800070c0 <etext+0xc0>
    800006ae:	162050ef          	jal	80005810 <panic>
      panic("uvmunmap: walk");
    800006b2:	00007517          	auipc	a0,0x7
    800006b6:	a2650513          	addi	a0,a0,-1498 # 800070d8 <etext+0xd8>
    800006ba:	156050ef          	jal	80005810 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006be:	85ca                	mv	a1,s2
    800006c0:	00007517          	auipc	a0,0x7
    800006c4:	a2850513          	addi	a0,a0,-1496 # 800070e8 <etext+0xe8>
    800006c8:	677040ef          	jal	8000553e <printf>
      panic("uvmunmap: not mapped");
    800006cc:	00007517          	auipc	a0,0x7
    800006d0:	a2c50513          	addi	a0,a0,-1492 # 800070f8 <etext+0xf8>
    800006d4:	13c050ef          	jal	80005810 <panic>
      panic("uvmunmap: not a leaf");
    800006d8:	00007517          	auipc	a0,0x7
    800006dc:	a3850513          	addi	a0,a0,-1480 # 80007110 <etext+0x110>
    800006e0:	130050ef          	jal	80005810 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006e4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006e8:	995a                	add	s2,s2,s6
    800006ea:	03397963          	bgeu	s2,s3,8000071c <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ee:	4601                	li	a2,0
    800006f0:	85ca                	mv	a1,s2
    800006f2:	8552                	mv	a0,s4
    800006f4:	cf5ff0ef          	jal	800003e8 <walk>
    800006f8:	84aa                	mv	s1,a0
    800006fa:	dd45                	beqz	a0,800006b2 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006fc:	6110                	ld	a2,0(a0)
    800006fe:	00167793          	andi	a5,a2,1
    80000702:	dfd5                	beqz	a5,800006be <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000704:	3ff67793          	andi	a5,a2,1023
    80000708:	fd7788e3          	beq	a5,s7,800006d8 <uvmunmap+0x72>
    if(do_free){
    8000070c:	fc0a8ce3          	beqz	s5,800006e4 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    80000710:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80000712:	00c61513          	slli	a0,a2,0xc
    80000716:	907ff0ef          	jal	8000001c <kfree>
    8000071a:	b7e9                	j	800006e4 <uvmunmap+0x7e>
    8000071c:	74e2                	ld	s1,56(sp)
    8000071e:	7942                	ld	s2,48(sp)
    80000720:	79a2                	ld	s3,40(sp)
    80000722:	7a02                	ld	s4,32(sp)
    80000724:	6ae2                	ld	s5,24(sp)
    80000726:	6b42                	ld	s6,16(sp)
    80000728:	6ba2                	ld	s7,8(sp)
  }
}
    8000072a:	60a6                	ld	ra,72(sp)
    8000072c:	6406                	ld	s0,64(sp)
    8000072e:	6161                	addi	sp,sp,80
    80000730:	8082                	ret

0000000080000732 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000732:	1101                	addi	sp,sp,-32
    80000734:	ec06                	sd	ra,24(sp)
    80000736:	e822                	sd	s0,16(sp)
    80000738:	e426                	sd	s1,8(sp)
    8000073a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000073c:	9bbff0ef          	jal	800000f6 <kalloc>
    80000740:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000742:	c509                	beqz	a0,8000074c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000744:	6605                	lui	a2,0x1
    80000746:	4581                	li	a1,0
    80000748:	a2dff0ef          	jal	80000174 <memset>
  return pagetable;
}
    8000074c:	8526                	mv	a0,s1
    8000074e:	60e2                	ld	ra,24(sp)
    80000750:	6442                	ld	s0,16(sp)
    80000752:	64a2                	ld	s1,8(sp)
    80000754:	6105                	addi	sp,sp,32
    80000756:	8082                	ret

0000000080000758 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000758:	7179                	addi	sp,sp,-48
    8000075a:	f406                	sd	ra,40(sp)
    8000075c:	f022                	sd	s0,32(sp)
    8000075e:	ec26                	sd	s1,24(sp)
    80000760:	e84a                	sd	s2,16(sp)
    80000762:	e44e                	sd	s3,8(sp)
    80000764:	e052                	sd	s4,0(sp)
    80000766:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000768:	6785                	lui	a5,0x1
    8000076a:	04f67063          	bgeu	a2,a5,800007aa <uvmfirst+0x52>
    8000076e:	8a2a                	mv	s4,a0
    80000770:	89ae                	mv	s3,a1
    80000772:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000774:	983ff0ef          	jal	800000f6 <kalloc>
    80000778:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000077a:	6605                	lui	a2,0x1
    8000077c:	4581                	li	a1,0
    8000077e:	9f7ff0ef          	jal	80000174 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000782:	4779                	li	a4,30
    80000784:	86ca                	mv	a3,s2
    80000786:	6605                	lui	a2,0x1
    80000788:	4581                	li	a1,0
    8000078a:	8552                	mv	a0,s4
    8000078c:	d35ff0ef          	jal	800004c0 <mappages>
  memmove(mem, src, sz);
    80000790:	8626                	mv	a2,s1
    80000792:	85ce                	mv	a1,s3
    80000794:	854a                	mv	a0,s2
    80000796:	a3bff0ef          	jal	800001d0 <memmove>
}
    8000079a:	70a2                	ld	ra,40(sp)
    8000079c:	7402                	ld	s0,32(sp)
    8000079e:	64e2                	ld	s1,24(sp)
    800007a0:	6942                	ld	s2,16(sp)
    800007a2:	69a2                	ld	s3,8(sp)
    800007a4:	6a02                	ld	s4,0(sp)
    800007a6:	6145                	addi	sp,sp,48
    800007a8:	8082                	ret
    panic("uvmfirst: more than a page");
    800007aa:	00007517          	auipc	a0,0x7
    800007ae:	97e50513          	addi	a0,a0,-1666 # 80007128 <etext+0x128>
    800007b2:	05e050ef          	jal	80005810 <panic>

00000000800007b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007b6:	1101                	addi	sp,sp,-32
    800007b8:	ec06                	sd	ra,24(sp)
    800007ba:	e822                	sd	s0,16(sp)
    800007bc:	e426                	sd	s1,8(sp)
    800007be:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007c0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007c2:	00b67d63          	bgeu	a2,a1,800007dc <uvmdealloc+0x26>
    800007c6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007c8:	6785                	lui	a5,0x1
    800007ca:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007cc:	00f60733          	add	a4,a2,a5
    800007d0:	76fd                	lui	a3,0xfffff
    800007d2:	8f75                	and	a4,a4,a3
    800007d4:	97ae                	add	a5,a5,a1
    800007d6:	8ff5                	and	a5,a5,a3
    800007d8:	00f76863          	bltu	a4,a5,800007e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007dc:	8526                	mv	a0,s1
    800007de:	60e2                	ld	ra,24(sp)
    800007e0:	6442                	ld	s0,16(sp)
    800007e2:	64a2                	ld	s1,8(sp)
    800007e4:	6105                	addi	sp,sp,32
    800007e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007e8:	8f99                	sub	a5,a5,a4
    800007ea:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ec:	4685                	li	a3,1
    800007ee:	0007861b          	sext.w	a2,a5
    800007f2:	85ba                	mv	a1,a4
    800007f4:	e73ff0ef          	jal	80000666 <uvmunmap>
    800007f8:	b7d5                	j	800007dc <uvmdealloc+0x26>

00000000800007fa <uvmalloc>:
  if(newsz < oldsz)
    800007fa:	08b66b63          	bltu	a2,a1,80000890 <uvmalloc+0x96>
{
    800007fe:	7139                	addi	sp,sp,-64
    80000800:	fc06                	sd	ra,56(sp)
    80000802:	f822                	sd	s0,48(sp)
    80000804:	ec4e                	sd	s3,24(sp)
    80000806:	e852                	sd	s4,16(sp)
    80000808:	e456                	sd	s5,8(sp)
    8000080a:	0080                	addi	s0,sp,64
    8000080c:	8aaa                	mv	s5,a0
    8000080e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000810:	6785                	lui	a5,0x1
    80000812:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000814:	95be                	add	a1,a1,a5
    80000816:	77fd                	lui	a5,0xfffff
    80000818:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    8000081c:	06c9fc63          	bgeu	s3,a2,80000894 <uvmalloc+0x9a>
    80000820:	f426                	sd	s1,40(sp)
    80000822:	f04a                	sd	s2,32(sp)
    80000824:	e05a                	sd	s6,0(sp)
    80000826:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000828:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000082c:	8cbff0ef          	jal	800000f6 <kalloc>
    80000830:	84aa                	mv	s1,a0
    if(mem == 0){
    80000832:	c115                	beqz	a0,80000856 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000834:	875a                	mv	a4,s6
    80000836:	86aa                	mv	a3,a0
    80000838:	6605                	lui	a2,0x1
    8000083a:	85ca                	mv	a1,s2
    8000083c:	8556                	mv	a0,s5
    8000083e:	c83ff0ef          	jal	800004c0 <mappages>
    80000842:	e915                	bnez	a0,80000876 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000844:	6785                	lui	a5,0x1
    80000846:	993e                	add	s2,s2,a5
    80000848:	ff4962e3          	bltu	s2,s4,8000082c <uvmalloc+0x32>
  return newsz;
    8000084c:	8552                	mv	a0,s4
    8000084e:	74a2                	ld	s1,40(sp)
    80000850:	7902                	ld	s2,32(sp)
    80000852:	6b02                	ld	s6,0(sp)
    80000854:	a811                	j	80000868 <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000856:	864e                	mv	a2,s3
    80000858:	85ca                	mv	a1,s2
    8000085a:	8556                	mv	a0,s5
    8000085c:	f5bff0ef          	jal	800007b6 <uvmdealloc>
      return 0;
    80000860:	4501                	li	a0,0
    80000862:	74a2                	ld	s1,40(sp)
    80000864:	7902                	ld	s2,32(sp)
    80000866:	6b02                	ld	s6,0(sp)
}
    80000868:	70e2                	ld	ra,56(sp)
    8000086a:	7442                	ld	s0,48(sp)
    8000086c:	69e2                	ld	s3,24(sp)
    8000086e:	6a42                	ld	s4,16(sp)
    80000870:	6aa2                	ld	s5,8(sp)
    80000872:	6121                	addi	sp,sp,64
    80000874:	8082                	ret
      kfree(mem);
    80000876:	8526                	mv	a0,s1
    80000878:	fa4ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000087c:	864e                	mv	a2,s3
    8000087e:	85ca                	mv	a1,s2
    80000880:	8556                	mv	a0,s5
    80000882:	f35ff0ef          	jal	800007b6 <uvmdealloc>
      return 0;
    80000886:	4501                	li	a0,0
    80000888:	74a2                	ld	s1,40(sp)
    8000088a:	7902                	ld	s2,32(sp)
    8000088c:	6b02                	ld	s6,0(sp)
    8000088e:	bfe9                	j	80000868 <uvmalloc+0x6e>
    return oldsz;
    80000890:	852e                	mv	a0,a1
}
    80000892:	8082                	ret
  return newsz;
    80000894:	8532                	mv	a0,a2
    80000896:	bfc9                	j	80000868 <uvmalloc+0x6e>

0000000080000898 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000898:	7179                	addi	sp,sp,-48
    8000089a:	f406                	sd	ra,40(sp)
    8000089c:	f022                	sd	s0,32(sp)
    8000089e:	ec26                	sd	s1,24(sp)
    800008a0:	e84a                	sd	s2,16(sp)
    800008a2:	e44e                	sd	s3,8(sp)
    800008a4:	e052                	sd	s4,0(sp)
    800008a6:	1800                	addi	s0,sp,48
    800008a8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008aa:	84aa                	mv	s1,a0
    800008ac:	6905                	lui	s2,0x1
    800008ae:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008b0:	4985                	li	s3,1
    800008b2:	a819                	j	800008c8 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008b4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008b6:	00c79513          	slli	a0,a5,0xc
    800008ba:	fdfff0ef          	jal	80000898 <freewalk>
      pagetable[i] = 0;
    800008be:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008c2:	04a1                	addi	s1,s1,8
    800008c4:	01248f63          	beq	s1,s2,800008e2 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008c8:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008ca:	00f7f713          	andi	a4,a5,15
    800008ce:	ff3703e3          	beq	a4,s3,800008b4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008d2:	8b85                	andi	a5,a5,1
    800008d4:	d7fd                	beqz	a5,800008c2 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008d6:	00007517          	auipc	a0,0x7
    800008da:	87250513          	addi	a0,a0,-1934 # 80007148 <etext+0x148>
    800008de:	733040ef          	jal	80005810 <panic>
    }
  }
  kfree((void*)pagetable);
    800008e2:	8552                	mv	a0,s4
    800008e4:	f38ff0ef          	jal	8000001c <kfree>
}
    800008e8:	70a2                	ld	ra,40(sp)
    800008ea:	7402                	ld	s0,32(sp)
    800008ec:	64e2                	ld	s1,24(sp)
    800008ee:	6942                	ld	s2,16(sp)
    800008f0:	69a2                	ld	s3,8(sp)
    800008f2:	6a02                	ld	s4,0(sp)
    800008f4:	6145                	addi	sp,sp,48
    800008f6:	8082                	ret

00000000800008f8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008f8:	1101                	addi	sp,sp,-32
    800008fa:	ec06                	sd	ra,24(sp)
    800008fc:	e822                	sd	s0,16(sp)
    800008fe:	e426                	sd	s1,8(sp)
    80000900:	1000                	addi	s0,sp,32
    80000902:	84aa                	mv	s1,a0
  if(sz > 0)
    80000904:	e989                	bnez	a1,80000916 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000906:	8526                	mv	a0,s1
    80000908:	f91ff0ef          	jal	80000898 <freewalk>
}
    8000090c:	60e2                	ld	ra,24(sp)
    8000090e:	6442                	ld	s0,16(sp)
    80000910:	64a2                	ld	s1,8(sp)
    80000912:	6105                	addi	sp,sp,32
    80000914:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000916:	6785                	lui	a5,0x1
    80000918:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091a:	95be                	add	a1,a1,a5
    8000091c:	4685                	li	a3,1
    8000091e:	00c5d613          	srli	a2,a1,0xc
    80000922:	4581                	li	a1,0
    80000924:	d43ff0ef          	jal	80000666 <uvmunmap>
    80000928:	bff9                	j	80000906 <uvmfree+0xe>

000000008000092a <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    8000092a:	c65d                	beqz	a2,800009d8 <uvmcopy+0xae>
{
    8000092c:	715d                	addi	sp,sp,-80
    8000092e:	e486                	sd	ra,72(sp)
    80000930:	e0a2                	sd	s0,64(sp)
    80000932:	fc26                	sd	s1,56(sp)
    80000934:	f84a                	sd	s2,48(sp)
    80000936:	f44e                	sd	s3,40(sp)
    80000938:	f052                	sd	s4,32(sp)
    8000093a:	ec56                	sd	s5,24(sp)
    8000093c:	e85a                	sd	s6,16(sp)
    8000093e:	e45e                	sd	s7,8(sp)
    80000940:	0880                	addi	s0,sp,80
    80000942:	8b2a                	mv	s6,a0
    80000944:	8aae                	mv	s5,a1
    80000946:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000948:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000094a:	4601                	li	a2,0
    8000094c:	85ce                	mv	a1,s3
    8000094e:	855a                	mv	a0,s6
    80000950:	a99ff0ef          	jal	800003e8 <walk>
    80000954:	c121                	beqz	a0,80000994 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000956:	6118                	ld	a4,0(a0)
    80000958:	00177793          	andi	a5,a4,1
    8000095c:	c3b1                	beqz	a5,800009a0 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000095e:	00a75593          	srli	a1,a4,0xa
    80000962:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000966:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000096a:	f8cff0ef          	jal	800000f6 <kalloc>
    8000096e:	892a                	mv	s2,a0
    80000970:	c129                	beqz	a0,800009b2 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000972:	6605                	lui	a2,0x1
    80000974:	85de                	mv	a1,s7
    80000976:	85bff0ef          	jal	800001d0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000097a:	8726                	mv	a4,s1
    8000097c:	86ca                	mv	a3,s2
    8000097e:	6605                	lui	a2,0x1
    80000980:	85ce                	mv	a1,s3
    80000982:	8556                	mv	a0,s5
    80000984:	b3dff0ef          	jal	800004c0 <mappages>
    80000988:	e115                	bnez	a0,800009ac <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000098a:	6785                	lui	a5,0x1
    8000098c:	99be                	add	s3,s3,a5
    8000098e:	fb49eee3          	bltu	s3,s4,8000094a <uvmcopy+0x20>
    80000992:	a805                	j	800009c2 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000994:	00006517          	auipc	a0,0x6
    80000998:	7c450513          	addi	a0,a0,1988 # 80007158 <etext+0x158>
    8000099c:	675040ef          	jal	80005810 <panic>
      panic("uvmcopy: page not present");
    800009a0:	00006517          	auipc	a0,0x6
    800009a4:	7d850513          	addi	a0,a0,2008 # 80007178 <etext+0x178>
    800009a8:	669040ef          	jal	80005810 <panic>
      kfree(mem);
    800009ac:	854a                	mv	a0,s2
    800009ae:	e6eff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009b2:	4685                	li	a3,1
    800009b4:	00c9d613          	srli	a2,s3,0xc
    800009b8:	4581                	li	a1,0
    800009ba:	8556                	mv	a0,s5
    800009bc:	cabff0ef          	jal	80000666 <uvmunmap>
  return -1;
    800009c0:	557d                	li	a0,-1
}
    800009c2:	60a6                	ld	ra,72(sp)
    800009c4:	6406                	ld	s0,64(sp)
    800009c6:	74e2                	ld	s1,56(sp)
    800009c8:	7942                	ld	s2,48(sp)
    800009ca:	79a2                	ld	s3,40(sp)
    800009cc:	7a02                	ld	s4,32(sp)
    800009ce:	6ae2                	ld	s5,24(sp)
    800009d0:	6b42                	ld	s6,16(sp)
    800009d2:	6ba2                	ld	s7,8(sp)
    800009d4:	6161                	addi	sp,sp,80
    800009d6:	8082                	ret
  return 0;
    800009d8:	4501                	li	a0,0
}
    800009da:	8082                	ret

00000000800009dc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009dc:	1141                	addi	sp,sp,-16
    800009de:	e406                	sd	ra,8(sp)
    800009e0:	e022                	sd	s0,0(sp)
    800009e2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e4:	4601                	li	a2,0
    800009e6:	a03ff0ef          	jal	800003e8 <walk>
  if(pte == 0)
    800009ea:	c901                	beqz	a0,800009fa <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ec:	611c                	ld	a5,0(a0)
    800009ee:	9bbd                	andi	a5,a5,-17
    800009f0:	e11c                	sd	a5,0(a0)
}
    800009f2:	60a2                	ld	ra,8(sp)
    800009f4:	6402                	ld	s0,0(sp)
    800009f6:	0141                	addi	sp,sp,16
    800009f8:	8082                	ret
    panic("uvmclear");
    800009fa:	00006517          	auipc	a0,0x6
    800009fe:	79e50513          	addi	a0,a0,1950 # 80007198 <etext+0x198>
    80000a02:	60f040ef          	jal	80005810 <panic>

0000000080000a06 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a06:	cac1                	beqz	a3,80000a96 <copyout+0x90>
{
    80000a08:	711d                	addi	sp,sp,-96
    80000a0a:	ec86                	sd	ra,88(sp)
    80000a0c:	e8a2                	sd	s0,80(sp)
    80000a0e:	e4a6                	sd	s1,72(sp)
    80000a10:	fc4e                	sd	s3,56(sp)
    80000a12:	f852                	sd	s4,48(sp)
    80000a14:	f456                	sd	s5,40(sp)
    80000a16:	f05a                	sd	s6,32(sp)
    80000a18:	1080                	addi	s0,sp,96
    80000a1a:	8b2a                	mv	s6,a0
    80000a1c:	8a2e                	mv	s4,a1
    80000a1e:	8ab2                	mv	s5,a2
    80000a20:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a22:	74fd                	lui	s1,0xfffff
    80000a24:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a26:	57fd                	li	a5,-1
    80000a28:	83e9                	srli	a5,a5,0x1a
    80000a2a:	0697e863          	bltu	a5,s1,80000a9a <copyout+0x94>
    80000a2e:	e0ca                	sd	s2,64(sp)
    80000a30:	ec5e                	sd	s7,24(sp)
    80000a32:	e862                	sd	s8,16(sp)
    80000a34:	e466                	sd	s9,8(sp)
    80000a36:	6c05                	lui	s8,0x1
    80000a38:	8bbe                	mv	s7,a5
    80000a3a:	a015                	j	80000a5e <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3c:	409a04b3          	sub	s1,s4,s1
    80000a40:	0009061b          	sext.w	a2,s2
    80000a44:	85d6                	mv	a1,s5
    80000a46:	9526                	add	a0,a0,s1
    80000a48:	f88ff0ef          	jal	800001d0 <memmove>

    len -= n;
    80000a4c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a50:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a52:	02098c63          	beqz	s3,80000a8a <copyout+0x84>
    if (va0 >= MAXVA)
    80000a56:	059be463          	bltu	s7,s9,80000a9e <copyout+0x98>
    80000a5a:	84e6                	mv	s1,s9
    80000a5c:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a5e:	4601                	li	a2,0
    80000a60:	85a6                	mv	a1,s1
    80000a62:	855a                	mv	a0,s6
    80000a64:	985ff0ef          	jal	800003e8 <walk>
    80000a68:	c129                	beqz	a0,80000aaa <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a6a:	611c                	ld	a5,0(a0)
    80000a6c:	8b91                	andi	a5,a5,4
    80000a6e:	cfa1                	beqz	a5,80000ac6 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a70:	85a6                	mv	a1,s1
    80000a72:	855a                	mv	a0,s6
    80000a74:	a0fff0ef          	jal	80000482 <walkaddr>
    if(pa0 == 0)
    80000a78:	cd29                	beqz	a0,80000ad2 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a7a:	01848cb3          	add	s9,s1,s8
    80000a7e:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a82:	fb29fde3          	bgeu	s3,s2,80000a3c <copyout+0x36>
    80000a86:	894e                	mv	s2,s3
    80000a88:	bf55                	j	80000a3c <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a8a:	4501                	li	a0,0
    80000a8c:	6906                	ld	s2,64(sp)
    80000a8e:	6be2                	ld	s7,24(sp)
    80000a90:	6c42                	ld	s8,16(sp)
    80000a92:	6ca2                	ld	s9,8(sp)
    80000a94:	a005                	j	80000ab4 <copyout+0xae>
    80000a96:	4501                	li	a0,0
}
    80000a98:	8082                	ret
      return -1;
    80000a9a:	557d                	li	a0,-1
    80000a9c:	a821                	j	80000ab4 <copyout+0xae>
    80000a9e:	557d                	li	a0,-1
    80000aa0:	6906                	ld	s2,64(sp)
    80000aa2:	6be2                	ld	s7,24(sp)
    80000aa4:	6c42                	ld	s8,16(sp)
    80000aa6:	6ca2                	ld	s9,8(sp)
    80000aa8:	a031                	j	80000ab4 <copyout+0xae>
      return -1;
    80000aaa:	557d                	li	a0,-1
    80000aac:	6906                	ld	s2,64(sp)
    80000aae:	6be2                	ld	s7,24(sp)
    80000ab0:	6c42                	ld	s8,16(sp)
    80000ab2:	6ca2                	ld	s9,8(sp)
}
    80000ab4:	60e6                	ld	ra,88(sp)
    80000ab6:	6446                	ld	s0,80(sp)
    80000ab8:	64a6                	ld	s1,72(sp)
    80000aba:	79e2                	ld	s3,56(sp)
    80000abc:	7a42                	ld	s4,48(sp)
    80000abe:	7aa2                	ld	s5,40(sp)
    80000ac0:	7b02                	ld	s6,32(sp)
    80000ac2:	6125                	addi	sp,sp,96
    80000ac4:	8082                	ret
      return -1;
    80000ac6:	557d                	li	a0,-1
    80000ac8:	6906                	ld	s2,64(sp)
    80000aca:	6be2                	ld	s7,24(sp)
    80000acc:	6c42                	ld	s8,16(sp)
    80000ace:	6ca2                	ld	s9,8(sp)
    80000ad0:	b7d5                	j	80000ab4 <copyout+0xae>
      return -1;
    80000ad2:	557d                	li	a0,-1
    80000ad4:	6906                	ld	s2,64(sp)
    80000ad6:	6be2                	ld	s7,24(sp)
    80000ad8:	6c42                	ld	s8,16(sp)
    80000ada:	6ca2                	ld	s9,8(sp)
    80000adc:	bfe1                	j	80000ab4 <copyout+0xae>

0000000080000ade <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ade:	c6a5                	beqz	a3,80000b46 <copyin+0x68>
{
    80000ae0:	715d                	addi	sp,sp,-80
    80000ae2:	e486                	sd	ra,72(sp)
    80000ae4:	e0a2                	sd	s0,64(sp)
    80000ae6:	fc26                	sd	s1,56(sp)
    80000ae8:	f84a                	sd	s2,48(sp)
    80000aea:	f44e                	sd	s3,40(sp)
    80000aec:	f052                	sd	s4,32(sp)
    80000aee:	ec56                	sd	s5,24(sp)
    80000af0:	e85a                	sd	s6,16(sp)
    80000af2:	e45e                	sd	s7,8(sp)
    80000af4:	e062                	sd	s8,0(sp)
    80000af6:	0880                	addi	s0,sp,80
    80000af8:	8b2a                	mv	s6,a0
    80000afa:	8a2e                	mv	s4,a1
    80000afc:	8c32                	mv	s8,a2
    80000afe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b00:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b02:	6a85                	lui	s5,0x1
    80000b04:	a00d                	j	80000b26 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b06:	018505b3          	add	a1,a0,s8
    80000b0a:	0004861b          	sext.w	a2,s1
    80000b0e:	412585b3          	sub	a1,a1,s2
    80000b12:	8552                	mv	a0,s4
    80000b14:	ebcff0ef          	jal	800001d0 <memmove>

    len -= n;
    80000b18:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b1c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b1e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b22:	02098063          	beqz	s3,80000b42 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b26:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b2a:	85ca                	mv	a1,s2
    80000b2c:	855a                	mv	a0,s6
    80000b2e:	955ff0ef          	jal	80000482 <walkaddr>
    if(pa0 == 0)
    80000b32:	cd01                	beqz	a0,80000b4a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b34:	418904b3          	sub	s1,s2,s8
    80000b38:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b3a:	fc99f6e3          	bgeu	s3,s1,80000b06 <copyin+0x28>
    80000b3e:	84ce                	mv	s1,s3
    80000b40:	b7d9                	j	80000b06 <copyin+0x28>
  }
  return 0;
    80000b42:	4501                	li	a0,0
    80000b44:	a021                	j	80000b4c <copyin+0x6e>
    80000b46:	4501                	li	a0,0
}
    80000b48:	8082                	ret
      return -1;
    80000b4a:	557d                	li	a0,-1
}
    80000b4c:	60a6                	ld	ra,72(sp)
    80000b4e:	6406                	ld	s0,64(sp)
    80000b50:	74e2                	ld	s1,56(sp)
    80000b52:	7942                	ld	s2,48(sp)
    80000b54:	79a2                	ld	s3,40(sp)
    80000b56:	7a02                	ld	s4,32(sp)
    80000b58:	6ae2                	ld	s5,24(sp)
    80000b5a:	6b42                	ld	s6,16(sp)
    80000b5c:	6ba2                	ld	s7,8(sp)
    80000b5e:	6c02                	ld	s8,0(sp)
    80000b60:	6161                	addi	sp,sp,80
    80000b62:	8082                	ret

0000000080000b64 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b64:	c6dd                	beqz	a3,80000c12 <copyinstr+0xae>
{
    80000b66:	715d                	addi	sp,sp,-80
    80000b68:	e486                	sd	ra,72(sp)
    80000b6a:	e0a2                	sd	s0,64(sp)
    80000b6c:	fc26                	sd	s1,56(sp)
    80000b6e:	f84a                	sd	s2,48(sp)
    80000b70:	f44e                	sd	s3,40(sp)
    80000b72:	f052                	sd	s4,32(sp)
    80000b74:	ec56                	sd	s5,24(sp)
    80000b76:	e85a                	sd	s6,16(sp)
    80000b78:	e45e                	sd	s7,8(sp)
    80000b7a:	0880                	addi	s0,sp,80
    80000b7c:	8a2a                	mv	s4,a0
    80000b7e:	8b2e                	mv	s6,a1
    80000b80:	8bb2                	mv	s7,a2
    80000b82:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b84:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b86:	6985                	lui	s3,0x1
    80000b88:	a825                	j	80000bc0 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b8a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b8e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b90:	37fd                	addiw	a5,a5,-1
    80000b92:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b96:	60a6                	ld	ra,72(sp)
    80000b98:	6406                	ld	s0,64(sp)
    80000b9a:	74e2                	ld	s1,56(sp)
    80000b9c:	7942                	ld	s2,48(sp)
    80000b9e:	79a2                	ld	s3,40(sp)
    80000ba0:	7a02                	ld	s4,32(sp)
    80000ba2:	6ae2                	ld	s5,24(sp)
    80000ba4:	6b42                	ld	s6,16(sp)
    80000ba6:	6ba2                	ld	s7,8(sp)
    80000ba8:	6161                	addi	sp,sp,80
    80000baa:	8082                	ret
    80000bac:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bb0:	9742                	add	a4,a4,a6
      --max;
    80000bb2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bb6:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bba:	04e58463          	beq	a1,a4,80000c02 <copyinstr+0x9e>
{
    80000bbe:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bc4:	85a6                	mv	a1,s1
    80000bc6:	8552                	mv	a0,s4
    80000bc8:	8bbff0ef          	jal	80000482 <walkaddr>
    if(pa0 == 0)
    80000bcc:	cd0d                	beqz	a0,80000c06 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000bce:	417486b3          	sub	a3,s1,s7
    80000bd2:	96ce                	add	a3,a3,s3
    if(n > max)
    80000bd4:	00d97363          	bgeu	s2,a3,80000bda <copyinstr+0x76>
    80000bd8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bda:	955e                	add	a0,a0,s7
    80000bdc:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bde:	c695                	beqz	a3,80000c0a <copyinstr+0xa6>
    80000be0:	87da                	mv	a5,s6
    80000be2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000be4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000be8:	96da                	add	a3,a3,s6
    80000bea:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bec:	00f60733          	add	a4,a2,a5
    80000bf0:	00074703          	lbu	a4,0(a4)
    80000bf4:	db59                	beqz	a4,80000b8a <copyinstr+0x26>
        *dst = *p;
    80000bf6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bfa:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bfc:	fed797e3          	bne	a5,a3,80000bea <copyinstr+0x86>
    80000c00:	b775                	j	80000bac <copyinstr+0x48>
    80000c02:	4781                	li	a5,0
    80000c04:	b771                	j	80000b90 <copyinstr+0x2c>
      return -1;
    80000c06:	557d                	li	a0,-1
    80000c08:	b779                	j	80000b96 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c0a:	6b85                	lui	s7,0x1
    80000c0c:	9ba6                	add	s7,s7,s1
    80000c0e:	87da                	mv	a5,s6
    80000c10:	b77d                	j	80000bbe <copyinstr+0x5a>
  int got_null = 0;
    80000c12:	4781                	li	a5,0
  if(got_null){
    80000c14:	37fd                	addiw	a5,a5,-1
    80000c16:	0007851b          	sext.w	a0,a5
}
    80000c1a:	8082                	ret

0000000080000c1c <getprocinfo>:
  struct proc proc[NPROC];
} ptable;

uint64
getprocinfo(int pid, struct procinfo *info)
{
    80000c1c:	882e                	mv	a6,a1
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80000c1e:	0000a597          	auipc	a1,0xa
    80000c22:	c5258593          	addi	a1,a1,-942 # 8000a870 <proc>
    80000c26:	00010697          	auipc	a3,0x10
    80000c2a:	84a68693          	addi	a3,a3,-1974 # 80010470 <ptable>
    80000c2e:	a029                	j	80000c38 <getprocinfo+0x1c>
    80000c30:	17058593          	addi	a1,a1,368
    80000c34:	04d58563          	beq	a1,a3,80000c7e <getprocinfo+0x62>
    if(p->state != UNUSED && p->pid == pid){
    80000c38:	5198                	lw	a4,32(a1)
    80000c3a:	db7d                	beqz	a4,80000c30 <getprocinfo+0x14>
    80000c3c:	5d98                	lw	a4,56(a1)
    80000c3e:	fea719e3          	bne	a4,a0,80000c30 <getprocinfo+0x14>
{
    80000c42:	1141                	addi	sp,sp,-16
    80000c44:	e406                	sd	ra,8(sp)
    80000c46:	e022                	sd	s0,0(sp)
    80000c48:	0800                	addi	s0,sp,16
      info->pid = p->pid;
    80000c4a:	00e82023          	sw	a4,0(a6)
      info->state = p->state;
    80000c4e:	5198                	lw	a4,32(a1)
    80000c50:	00e82223          	sw	a4,4(a6)
      info->ppid = p->parent ? p->parent->pid : 0;
    80000c54:	61b4                	ld	a3,64(a1)
    80000c56:	4701                	li	a4,0
    80000c58:	c291                	beqz	a3,80000c5c <getprocinfo+0x40>
    80000c5a:	5e98                	lw	a4,56(a3)
    80000c5c:	00e82423          	sw	a4,8(a6)
      info->sz = p->sz;
    80000c60:	69b8                	ld	a4,80(a1)
    80000c62:	00e82623          	sw	a4,12(a6)
      safestrcpy(info->name, p->name, PROC_NAME_LEN);
    80000c66:	4641                	li	a2,16
    80000c68:	16058593          	addi	a1,a1,352
    80000c6c:	01080513          	addi	a0,a6,16
    80000c70:	e42ff0ef          	jal	800002b2 <safestrcpy>
      return 0;
    80000c74:	4501                	li	a0,0
    }
  }
  return -1;
}
    80000c76:	60a2                	ld	ra,8(sp)
    80000c78:	6402                	ld	s0,0(sp)
    80000c7a:	0141                	addi	sp,sp,16
    80000c7c:	8082                	ret
  return -1;
    80000c7e:	557d                	li	a0,-1
}
    80000c80:	8082                	ret

0000000080000c82 <gettop>:



int
gettop(struct top_proc *tops, int n) {
    80000c82:	711d                	addi	sp,sp,-96
    80000c84:	ec86                	sd	ra,88(sp)
    80000c86:	e8a2                	sd	s0,80(sp)
    80000c88:	e4a6                	sd	s1,72(sp)
    80000c8a:	e0ca                	sd	s2,64(sp)
    80000c8c:	fc4e                	sd	s3,56(sp)
    80000c8e:	f852                	sd	s4,48(sp)
    80000c90:	f456                	sd	s5,40(sp)
    80000c92:	f05a                	sd	s6,32(sp)
    80000c94:	ec5e                	sd	s7,24(sp)
    80000c96:	e862                	sd	s8,16(sp)
    80000c98:	e466                	sd	s9,8(sp)
    80000c9a:	1080                	addi	s0,sp,96
    80000c9c:	8aaa                	mv	s5,a0
    80000c9e:	8b2e                	mv	s6,a1
  struct proc *p;
  int count = 0;

  // Simple insertion sort into a fixed-size array
  for (p = proc; p < &proc[NPROC]; p++) {
    80000ca0:	0000a497          	auipc	s1,0xa
    80000ca4:	d3048493          	addi	s1,s1,-720 # 8000a9d0 <proc+0x160>
    80000ca8:	00010a17          	auipc	s4,0x10
    80000cac:	928a0a13          	addi	s4,s4,-1752 # 800105d0 <ptable+0x160>
  int count = 0;
    80000cb0:	4901                	li	s2,0
    80000cb2:	4989                	li	s3,2
    80000cb4:	fd050c93          	addi	s9,a0,-48
    80000cb8:	5c79                	li	s8,-2
    if (p->state == RUNNING || p->state == SLEEPING || p->state == RUNNABLE) {
      int i;
      for (i = 0; i < count; i++) {
        if (p->cputime > tops[i].cputime) {
    80000cba:	4b81                	li	s7,0
    80000cbc:	a89d                	j	80000d32 <gettop+0xb0>
      for (i = 0; i < count; i++) {
    80000cbe:	4701                	li	a4,0
          break;
        }
      }
      if (count < n) count++;
    80000cc0:	01695363          	bge	s2,s6,80000cc6 <gettop+0x44>
    80000cc4:	2905                	addiw	s2,s2,1
      for (int j = count - 1; j > i; j--) {
    80000cc6:	fff9079b          	addiw	a5,s2,-1
    80000cca:	04f75e63          	bge	a4,a5,80000d26 <gettop+0xa4>
    80000cce:	00179693          	slli	a3,a5,0x1
    80000cd2:	96be                	add	a3,a3,a5
    80000cd4:	068e                	slli	a3,a3,0x3
    80000cd6:	00da87b3          	add	a5,s5,a3
    80000cda:	06e1                	addi	a3,a3,24
    80000cdc:	96e6                	add	a3,a3,s9
    80000cde:	40ec063b          	subw	a2,s8,a4
    80000ce2:	0126063b          	addw	a2,a2,s2
    80000ce6:	1602                	slli	a2,a2,0x20
    80000ce8:	9201                	srli	a2,a2,0x20
    80000cea:	00161513          	slli	a0,a2,0x1
    80000cee:	962a                	add	a2,a2,a0
    80000cf0:	060e                	slli	a2,a2,0x3
    80000cf2:	8e91                	sub	a3,a3,a2
        tops[j] = tops[j - 1];
    80000cf4:	fe87ae03          	lw	t3,-24(a5)
    80000cf8:	fec7a303          	lw	t1,-20(a5)
    80000cfc:	ff07a883          	lw	a7,-16(a5)
    80000d00:	ff47a803          	lw	a6,-12(a5)
    80000d04:	ff87a503          	lw	a0,-8(a5)
    80000d08:	ffc7a603          	lw	a2,-4(a5)
    80000d0c:	01c7a023          	sw	t3,0(a5)
    80000d10:	0067a223          	sw	t1,4(a5)
    80000d14:	0117a423          	sw	a7,8(a5)
    80000d18:	0107a623          	sw	a6,12(a5)
    80000d1c:	cb88                	sw	a0,16(a5)
    80000d1e:	cbd0                	sw	a2,20(a5)
      for (int j = count - 1; j > i; j--) {
    80000d20:	17a1                	addi	a5,a5,-24
    80000d22:	fcd799e3          	bne	a5,a3,80000cf4 <gettop+0x72>
      }
      if (i < n) {
    80000d26:	03674e63          	blt	a4,s6,80000d62 <gettop+0xe0>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d2a:	17048493          	addi	s1,s1,368
    80000d2e:	05448a63          	beq	s1,s4,80000d82 <gettop+0x100>
    if (p->state == RUNNING || p->state == SLEEPING || p->state == RUNNABLE) {
    80000d32:	85a6                	mv	a1,s1
    80000d34:	ec04a783          	lw	a5,-320(s1)
    80000d38:	37f9                	addiw	a5,a5,-2
    80000d3a:	fef9e8e3          	bltu	s3,a5,80000d2a <gettop+0xa8>
      for (i = 0; i < count; i++) {
    80000d3e:	f92050e3          	blez	s2,80000cbe <gettop+0x3c>
        if (p->cputime > tops[i].cputime) {
    80000d42:	ea04b603          	ld	a2,-352(s1)
    80000d46:	004a8793          	addi	a5,s5,4 # fffffffffffff004 <end+0xffffffff7ffd5a74>
    80000d4a:	875e                	mv	a4,s7
    80000d4c:	4394                	lw	a3,0(a5)
    80000d4e:	f6c6e9e3          	bltu	a3,a2,80000cc0 <gettop+0x3e>
      for (i = 0; i < count; i++) {
    80000d52:	2705                	addiw	a4,a4,1
    80000d54:	07e1                	addi	a5,a5,24
    80000d56:	ff271be3          	bne	a4,s2,80000d4c <gettop+0xca>
      if (count < n) count++;
    80000d5a:	874a                	mv	a4,s2
    80000d5c:	f76944e3          	blt	s2,s6,80000cc4 <gettop+0x42>
    80000d60:	b7d9                	j	80000d26 <gettop+0xa4>
        tops[i].pid = p->pid;
    80000d62:	00171513          	slli	a0,a4,0x1
    80000d66:	953a                	add	a0,a0,a4
    80000d68:	050e                	slli	a0,a0,0x3
    80000d6a:	9556                	add	a0,a0,s5
    80000d6c:	ed85a783          	lw	a5,-296(a1)
    80000d70:	c11c                	sw	a5,0(a0)
        tops[i].cputime = p->cputime;
    80000d72:	ea05b783          	ld	a5,-352(a1)
    80000d76:	c15c                	sw	a5,4(a0)
        strncpy(tops[i].name, p->name, 16);
    80000d78:	4641                	li	a2,16
    80000d7a:	0521                	addi	a0,a0,8
    80000d7c:	cfaff0ef          	jal	80000276 <strncpy>
    80000d80:	b76d                	j	80000d2a <gettop+0xa8>
      }
    }
  }

  return count;
}
    80000d82:	854a                	mv	a0,s2
    80000d84:	60e6                	ld	ra,88(sp)
    80000d86:	6446                	ld	s0,80(sp)
    80000d88:	64a6                	ld	s1,72(sp)
    80000d8a:	6906                	ld	s2,64(sp)
    80000d8c:	79e2                	ld	s3,56(sp)
    80000d8e:	7a42                	ld	s4,48(sp)
    80000d90:	7aa2                	ld	s5,40(sp)
    80000d92:	7b02                	ld	s6,32(sp)
    80000d94:	6be2                	ld	s7,24(sp)
    80000d96:	6c42                	ld	s8,16(sp)
    80000d98:	6ca2                	ld	s9,8(sp)
    80000d9a:	6125                	addi	sp,sp,96
    80000d9c:	8082                	ret

0000000080000d9e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d9e:	7139                	addi	sp,sp,-64
    80000da0:	fc06                	sd	ra,56(sp)
    80000da2:	f822                	sd	s0,48(sp)
    80000da4:	f426                	sd	s1,40(sp)
    80000da6:	f04a                	sd	s2,32(sp)
    80000da8:	ec4e                	sd	s3,24(sp)
    80000daa:	e852                	sd	s4,16(sp)
    80000dac:	e456                	sd	s5,8(sp)
    80000dae:	e05a                	sd	s6,0(sp)
    80000db0:	0080                	addi	s0,sp,64
    80000db2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db4:	0000a497          	auipc	s1,0xa
    80000db8:	abc48493          	addi	s1,s1,-1348 # 8000a870 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dbc:	8b26                	mv	s6,s1
    80000dbe:	ff4df937          	lui	s2,0xff4df
    80000dc2:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b542d>
    80000dc6:	0936                	slli	s2,s2,0xd
    80000dc8:	6f590913          	addi	s2,s2,1781
    80000dcc:	0936                	slli	s2,s2,0xd
    80000dce:	bd390913          	addi	s2,s2,-1069
    80000dd2:	0932                	slli	s2,s2,0xc
    80000dd4:	7a790913          	addi	s2,s2,1959
    80000dd8:	040009b7          	lui	s3,0x4000
    80000ddc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000dde:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de0:	0000fa97          	auipc	s5,0xf
    80000de4:	690a8a93          	addi	s5,s5,1680 # 80010470 <ptable>
    char *pa = kalloc();
    80000de8:	b0eff0ef          	jal	800000f6 <kalloc>
    80000dec:	862a                	mv	a2,a0
    if(pa == 0)
    80000dee:	cd15                	beqz	a0,80000e2a <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000df0:	416485b3          	sub	a1,s1,s6
    80000df4:	8591                	srai	a1,a1,0x4
    80000df6:	032585b3          	mul	a1,a1,s2
    80000dfa:	2585                	addiw	a1,a1,1
    80000dfc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e00:	4719                	li	a4,6
    80000e02:	6685                	lui	a3,0x1
    80000e04:	40b985b3          	sub	a1,s3,a1
    80000e08:	8552                	mv	a0,s4
    80000e0a:	f66ff0ef          	jal	80000570 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0e:	17048493          	addi	s1,s1,368
    80000e12:	fd549be3          	bne	s1,s5,80000de8 <proc_mapstacks+0x4a>
  }
}
    80000e16:	70e2                	ld	ra,56(sp)
    80000e18:	7442                	ld	s0,48(sp)
    80000e1a:	74a2                	ld	s1,40(sp)
    80000e1c:	7902                	ld	s2,32(sp)
    80000e1e:	69e2                	ld	s3,24(sp)
    80000e20:	6a42                	ld	s4,16(sp)
    80000e22:	6aa2                	ld	s5,8(sp)
    80000e24:	6b02                	ld	s6,0(sp)
    80000e26:	6121                	addi	sp,sp,64
    80000e28:	8082                	ret
      panic("kalloc");
    80000e2a:	00006517          	auipc	a0,0x6
    80000e2e:	37e50513          	addi	a0,a0,894 # 800071a8 <etext+0x1a8>
    80000e32:	1df040ef          	jal	80005810 <panic>

0000000080000e36 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e36:	7139                	addi	sp,sp,-64
    80000e38:	fc06                	sd	ra,56(sp)
    80000e3a:	f822                	sd	s0,48(sp)
    80000e3c:	f426                	sd	s1,40(sp)
    80000e3e:	f04a                	sd	s2,32(sp)
    80000e40:	ec4e                	sd	s3,24(sp)
    80000e42:	e852                	sd	s4,16(sp)
    80000e44:	e456                	sd	s5,8(sp)
    80000e46:	e05a                	sd	s6,0(sp)
    80000e48:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e4a:	00006597          	auipc	a1,0x6
    80000e4e:	36658593          	addi	a1,a1,870 # 800071b0 <etext+0x1b0>
    80000e52:	00009517          	auipc	a0,0x9
    80000e56:	5ee50513          	addi	a0,a0,1518 # 8000a440 <pid_lock>
    80000e5a:	465040ef          	jal	80005abe <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e5e:	00006597          	auipc	a1,0x6
    80000e62:	35a58593          	addi	a1,a1,858 # 800071b8 <etext+0x1b8>
    80000e66:	00009517          	auipc	a0,0x9
    80000e6a:	5f250513          	addi	a0,a0,1522 # 8000a458 <wait_lock>
    80000e6e:	451040ef          	jal	80005abe <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e72:	0000a497          	auipc	s1,0xa
    80000e76:	9fe48493          	addi	s1,s1,-1538 # 8000a870 <proc>
      initlock(&p->lock, "proc");
    80000e7a:	00006b17          	auipc	s6,0x6
    80000e7e:	34eb0b13          	addi	s6,s6,846 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e82:	8aa6                	mv	s5,s1
    80000e84:	ff4df937          	lui	s2,0xff4df
    80000e88:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b542d>
    80000e8c:	0936                	slli	s2,s2,0xd
    80000e8e:	6f590913          	addi	s2,s2,1781
    80000e92:	0936                	slli	s2,s2,0xd
    80000e94:	bd390913          	addi	s2,s2,-1069
    80000e98:	0932                	slli	s2,s2,0xc
    80000e9a:	7a790913          	addi	s2,s2,1959
    80000e9e:	040009b7          	lui	s3,0x4000
    80000ea2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ea4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea6:	0000fa17          	auipc	s4,0xf
    80000eaa:	5caa0a13          	addi	s4,s4,1482 # 80010470 <ptable>
      initlock(&p->lock, "proc");
    80000eae:	85da                	mv	a1,s6
    80000eb0:	00848513          	addi	a0,s1,8
    80000eb4:	40b040ef          	jal	80005abe <initlock>
      p->state = UNUSED;
    80000eb8:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ebc:	415487b3          	sub	a5,s1,s5
    80000ec0:	8791                	srai	a5,a5,0x4
    80000ec2:	032787b3          	mul	a5,a5,s2
    80000ec6:	2785                	addiw	a5,a5,1
    80000ec8:	00d7979b          	slliw	a5,a5,0xd
    80000ecc:	40f987b3          	sub	a5,s3,a5
    80000ed0:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed2:	17048493          	addi	s1,s1,368
    80000ed6:	fd449ce3          	bne	s1,s4,80000eae <procinit+0x78>
  }
}
    80000eda:	70e2                	ld	ra,56(sp)
    80000edc:	7442                	ld	s0,48(sp)
    80000ede:	74a2                	ld	s1,40(sp)
    80000ee0:	7902                	ld	s2,32(sp)
    80000ee2:	69e2                	ld	s3,24(sp)
    80000ee4:	6a42                	ld	s4,16(sp)
    80000ee6:	6aa2                	ld	s5,8(sp)
    80000ee8:	6b02                	ld	s6,0(sp)
    80000eea:	6121                	addi	sp,sp,64
    80000eec:	8082                	ret

0000000080000eee <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ef4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ef6:	2501                	sext.w	a0,a0
    80000ef8:	6422                	ld	s0,8(sp)
    80000efa:	0141                	addi	sp,sp,16
    80000efc:	8082                	ret

0000000080000efe <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e422                	sd	s0,8(sp)
    80000f02:	0800                	addi	s0,sp,16
    80000f04:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f06:	2781                	sext.w	a5,a5
    80000f08:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f0a:	00009517          	auipc	a0,0x9
    80000f0e:	56650513          	addi	a0,a0,1382 # 8000a470 <cpus>
    80000f12:	953e                	add	a0,a0,a5
    80000f14:	6422                	ld	s0,8(sp)
    80000f16:	0141                	addi	sp,sp,16
    80000f18:	8082                	ret

0000000080000f1a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f1a:	1101                	addi	sp,sp,-32
    80000f1c:	ec06                	sd	ra,24(sp)
    80000f1e:	e822                	sd	s0,16(sp)
    80000f20:	e426                	sd	s1,8(sp)
    80000f22:	1000                	addi	s0,sp,32
  push_off();
    80000f24:	3db040ef          	jal	80005afe <push_off>
    80000f28:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	079e                	slli	a5,a5,0x7
    80000f2e:	00009717          	auipc	a4,0x9
    80000f32:	51270713          	addi	a4,a4,1298 # 8000a440 <pid_lock>
    80000f36:	97ba                	add	a5,a5,a4
    80000f38:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f3a:	449040ef          	jal	80005b82 <pop_off>
  return p;
}
    80000f3e:	8526                	mv	a0,s1
    80000f40:	60e2                	ld	ra,24(sp)
    80000f42:	6442                	ld	s0,16(sp)
    80000f44:	64a2                	ld	s1,8(sp)
    80000f46:	6105                	addi	sp,sp,32
    80000f48:	8082                	ret

0000000080000f4a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e406                	sd	ra,8(sp)
    80000f4e:	e022                	sd	s0,0(sp)
    80000f50:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f52:	fc9ff0ef          	jal	80000f1a <myproc>
    80000f56:	0521                	addi	a0,a0,8
    80000f58:	47f040ef          	jal	80005bd6 <release>

  if (first) {
    80000f5c:	00009797          	auipc	a5,0x9
    80000f60:	4147a783          	lw	a5,1044(a5) # 8000a370 <first.1>
    80000f64:	e799                	bnez	a5,80000f72 <forkret+0x28>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f66:	32d000ef          	jal	80001a92 <usertrapret>
}
    80000f6a:	60a2                	ld	ra,8(sp)
    80000f6c:	6402                	ld	s0,0(sp)
    80000f6e:	0141                	addi	sp,sp,16
    80000f70:	8082                	ret
    fsinit(ROOTDEV);
    80000f72:	4505                	li	a0,1
    80000f74:	073010ef          	jal	800027e6 <fsinit>
    first = 0;
    80000f78:	00009797          	auipc	a5,0x9
    80000f7c:	3e07ac23          	sw	zero,1016(a5) # 8000a370 <first.1>
    __sync_synchronize();
    80000f80:	0330000f          	fence	rw,rw
    80000f84:	b7cd                	j	80000f66 <forkret+0x1c>

0000000080000f86 <allocpid>:
{
    80000f86:	1101                	addi	sp,sp,-32
    80000f88:	ec06                	sd	ra,24(sp)
    80000f8a:	e822                	sd	s0,16(sp)
    80000f8c:	e426                	sd	s1,8(sp)
    80000f8e:	e04a                	sd	s2,0(sp)
    80000f90:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f92:	00009917          	auipc	s2,0x9
    80000f96:	4ae90913          	addi	s2,s2,1198 # 8000a440 <pid_lock>
    80000f9a:	854a                	mv	a0,s2
    80000f9c:	3a3040ef          	jal	80005b3e <acquire>
  pid = nextpid;
    80000fa0:	00009797          	auipc	a5,0x9
    80000fa4:	3d478793          	addi	a5,a5,980 # 8000a374 <nextpid>
    80000fa8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000faa:	0014871b          	addiw	a4,s1,1
    80000fae:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fb0:	854a                	mv	a0,s2
    80000fb2:	425040ef          	jal	80005bd6 <release>
}
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	60e2                	ld	ra,24(sp)
    80000fba:	6442                	ld	s0,16(sp)
    80000fbc:	64a2                	ld	s1,8(sp)
    80000fbe:	6902                	ld	s2,0(sp)
    80000fc0:	6105                	addi	sp,sp,32
    80000fc2:	8082                	ret

0000000080000fc4 <proc_pagetable>:
{
    80000fc4:	1101                	addi	sp,sp,-32
    80000fc6:	ec06                	sd	ra,24(sp)
    80000fc8:	e822                	sd	s0,16(sp)
    80000fca:	e426                	sd	s1,8(sp)
    80000fcc:	e04a                	sd	s2,0(sp)
    80000fce:	1000                	addi	s0,sp,32
    80000fd0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fd2:	f60ff0ef          	jal	80000732 <uvmcreate>
    80000fd6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fd8:	cd05                	beqz	a0,80001010 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fda:	4729                	li	a4,10
    80000fdc:	00005697          	auipc	a3,0x5
    80000fe0:	02468693          	addi	a3,a3,36 # 80006000 <_trampoline>
    80000fe4:	6605                	lui	a2,0x1
    80000fe6:	040005b7          	lui	a1,0x4000
    80000fea:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fec:	05b2                	slli	a1,a1,0xc
    80000fee:	cd2ff0ef          	jal	800004c0 <mappages>
    80000ff2:	02054663          	bltz	a0,8000101e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000ff6:	4719                	li	a4,6
    80000ff8:	06093683          	ld	a3,96(s2)
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	020005b7          	lui	a1,0x2000
    80001002:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001004:	05b6                	slli	a1,a1,0xd
    80001006:	8526                	mv	a0,s1
    80001008:	cb8ff0ef          	jal	800004c0 <mappages>
    8000100c:	00054f63          	bltz	a0,8000102a <proc_pagetable+0x66>
}
    80001010:	8526                	mv	a0,s1
    80001012:	60e2                	ld	ra,24(sp)
    80001014:	6442                	ld	s0,16(sp)
    80001016:	64a2                	ld	s1,8(sp)
    80001018:	6902                	ld	s2,0(sp)
    8000101a:	6105                	addi	sp,sp,32
    8000101c:	8082                	ret
    uvmfree(pagetable, 0);
    8000101e:	4581                	li	a1,0
    80001020:	8526                	mv	a0,s1
    80001022:	8d7ff0ef          	jal	800008f8 <uvmfree>
    return 0;
    80001026:	4481                	li	s1,0
    80001028:	b7e5                	j	80001010 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000102a:	4681                	li	a3,0
    8000102c:	4605                	li	a2,1
    8000102e:	040005b7          	lui	a1,0x4000
    80001032:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001034:	05b2                	slli	a1,a1,0xc
    80001036:	8526                	mv	a0,s1
    80001038:	e2eff0ef          	jal	80000666 <uvmunmap>
    uvmfree(pagetable, 0);
    8000103c:	4581                	li	a1,0
    8000103e:	8526                	mv	a0,s1
    80001040:	8b9ff0ef          	jal	800008f8 <uvmfree>
    return 0;
    80001044:	4481                	li	s1,0
    80001046:	b7e9                	j	80001010 <proc_pagetable+0x4c>

0000000080001048 <proc_freepagetable>:
{
    80001048:	1101                	addi	sp,sp,-32
    8000104a:	ec06                	sd	ra,24(sp)
    8000104c:	e822                	sd	s0,16(sp)
    8000104e:	e426                	sd	s1,8(sp)
    80001050:	e04a                	sd	s2,0(sp)
    80001052:	1000                	addi	s0,sp,32
    80001054:	84aa                	mv	s1,a0
    80001056:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001058:	4681                	li	a3,0
    8000105a:	4605                	li	a2,1
    8000105c:	040005b7          	lui	a1,0x4000
    80001060:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001062:	05b2                	slli	a1,a1,0xc
    80001064:	e02ff0ef          	jal	80000666 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001068:	4681                	li	a3,0
    8000106a:	4605                	li	a2,1
    8000106c:	020005b7          	lui	a1,0x2000
    80001070:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001072:	05b6                	slli	a1,a1,0xd
    80001074:	8526                	mv	a0,s1
    80001076:	df0ff0ef          	jal	80000666 <uvmunmap>
  uvmfree(pagetable, sz);
    8000107a:	85ca                	mv	a1,s2
    8000107c:	8526                	mv	a0,s1
    8000107e:	87bff0ef          	jal	800008f8 <uvmfree>
}
    80001082:	60e2                	ld	ra,24(sp)
    80001084:	6442                	ld	s0,16(sp)
    80001086:	64a2                	ld	s1,8(sp)
    80001088:	6902                	ld	s2,0(sp)
    8000108a:	6105                	addi	sp,sp,32
    8000108c:	8082                	ret

000000008000108e <freeproc>:
{
    8000108e:	1101                	addi	sp,sp,-32
    80001090:	ec06                	sd	ra,24(sp)
    80001092:	e822                	sd	s0,16(sp)
    80001094:	e426                	sd	s1,8(sp)
    80001096:	1000                	addi	s0,sp,32
    80001098:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000109a:	7128                	ld	a0,96(a0)
    8000109c:	c119                	beqz	a0,800010a2 <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000109e:	f7ffe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    800010a2:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800010a6:	6ca8                	ld	a0,88(s1)
    800010a8:	c501                	beqz	a0,800010b0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800010aa:	68ac                	ld	a1,80(s1)
    800010ac:	f9dff0ef          	jal	80001048 <proc_freepagetable>
  p->pagetable = 0;
    800010b0:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800010b4:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800010b8:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800010bc:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    800010c0:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800010c4:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800010c8:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800010cc:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800010d0:	0204a023          	sw	zero,32(s1)
}
    800010d4:	60e2                	ld	ra,24(sp)
    800010d6:	6442                	ld	s0,16(sp)
    800010d8:	64a2                	ld	s1,8(sp)
    800010da:	6105                	addi	sp,sp,32
    800010dc:	8082                	ret

00000000800010de <allocproc>:
{
    800010de:	7179                	addi	sp,sp,-48
    800010e0:	f406                	sd	ra,40(sp)
    800010e2:	f022                	sd	s0,32(sp)
    800010e4:	ec26                	sd	s1,24(sp)
    800010e6:	e84a                	sd	s2,16(sp)
    800010e8:	e44e                	sd	s3,8(sp)
    800010ea:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ec:	00009497          	auipc	s1,0x9
    800010f0:	78448493          	addi	s1,s1,1924 # 8000a870 <proc>
    800010f4:	0000f997          	auipc	s3,0xf
    800010f8:	37c98993          	addi	s3,s3,892 # 80010470 <ptable>
    acquire(&p->lock);
    800010fc:	00848913          	addi	s2,s1,8
    80001100:	854a                	mv	a0,s2
    80001102:	23d040ef          	jal	80005b3e <acquire>
    if(p->state == UNUSED) {
    80001106:	509c                	lw	a5,32(s1)
    80001108:	cb91                	beqz	a5,8000111c <allocproc+0x3e>
      release(&p->lock);
    8000110a:	854a                	mv	a0,s2
    8000110c:	2cb040ef          	jal	80005bd6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001110:	17048493          	addi	s1,s1,368
    80001114:	ff3494e3          	bne	s1,s3,800010fc <allocproc+0x1e>
  return 0;
    80001118:	4481                	li	s1,0
    8000111a:	a089                	j	8000115c <allocproc+0x7e>
  p->pid = allocpid();
    8000111c:	e6bff0ef          	jal	80000f86 <allocpid>
    80001120:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001122:	4785                	li	a5,1
    80001124:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001126:	fd1fe0ef          	jal	800000f6 <kalloc>
    8000112a:	89aa                	mv	s3,a0
    8000112c:	f0a8                	sd	a0,96(s1)
    8000112e:	cd1d                	beqz	a0,8000116c <allocproc+0x8e>
  p->pagetable = proc_pagetable(p);
    80001130:	8526                	mv	a0,s1
    80001132:	e93ff0ef          	jal	80000fc4 <proc_pagetable>
    80001136:	89aa                	mv	s3,a0
    80001138:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    8000113a:	c129                	beqz	a0,8000117c <allocproc+0x9e>
  memset(&p->context, 0, sizeof(p->context));
    8000113c:	07000613          	li	a2,112
    80001140:	4581                	li	a1,0
    80001142:	06848513          	addi	a0,s1,104
    80001146:	82eff0ef          	jal	80000174 <memset>
  p->context.ra = (uint64)forkret;
    8000114a:	00000797          	auipc	a5,0x0
    8000114e:	e0078793          	addi	a5,a5,-512 # 80000f4a <forkret>
    80001152:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001154:	64bc                	ld	a5,72(s1)
    80001156:	6705                	lui	a4,0x1
    80001158:	97ba                	add	a5,a5,a4
    8000115a:	f8bc                	sd	a5,112(s1)
}
    8000115c:	8526                	mv	a0,s1
    8000115e:	70a2                	ld	ra,40(sp)
    80001160:	7402                	ld	s0,32(sp)
    80001162:	64e2                	ld	s1,24(sp)
    80001164:	6942                	ld	s2,16(sp)
    80001166:	69a2                	ld	s3,8(sp)
    80001168:	6145                	addi	sp,sp,48
    8000116a:	8082                	ret
    freeproc(p);
    8000116c:	8526                	mv	a0,s1
    8000116e:	f21ff0ef          	jal	8000108e <freeproc>
    release(&p->lock);
    80001172:	854a                	mv	a0,s2
    80001174:	263040ef          	jal	80005bd6 <release>
    return 0;
    80001178:	84ce                	mv	s1,s3
    8000117a:	b7cd                	j	8000115c <allocproc+0x7e>
    freeproc(p);
    8000117c:	8526                	mv	a0,s1
    8000117e:	f11ff0ef          	jal	8000108e <freeproc>
    release(&p->lock);
    80001182:	854a                	mv	a0,s2
    80001184:	253040ef          	jal	80005bd6 <release>
    return 0;
    80001188:	84ce                	mv	s1,s3
    8000118a:	bfc9                	j	8000115c <allocproc+0x7e>

000000008000118c <userinit>:
{
    8000118c:	1101                	addi	sp,sp,-32
    8000118e:	ec06                	sd	ra,24(sp)
    80001190:	e822                	sd	s0,16(sp)
    80001192:	e426                	sd	s1,8(sp)
    80001194:	1000                	addi	s0,sp,32
  p = allocproc();
    80001196:	f49ff0ef          	jal	800010de <allocproc>
    8000119a:	84aa                	mv	s1,a0
  initproc = p;
    8000119c:	00009797          	auipc	a5,0x9
    800011a0:	24a7ba23          	sd	a0,596(a5) # 8000a3f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a4:	03400613          	li	a2,52
    800011a8:	00009597          	auipc	a1,0x9
    800011ac:	1d858593          	addi	a1,a1,472 # 8000a380 <initcode>
    800011b0:	6d28                	ld	a0,88(a0)
    800011b2:	da6ff0ef          	jal	80000758 <uvmfirst>
  p->sz = PGSIZE;
    800011b6:	6785                	lui	a5,0x1
    800011b8:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ba:	70b8                	ld	a4,96(s1)
    800011bc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c0:	70b8                	ld	a4,96(s1)
    800011c2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c4:	4641                	li	a2,16
    800011c6:	00006597          	auipc	a1,0x6
    800011ca:	00a58593          	addi	a1,a1,10 # 800071d0 <etext+0x1d0>
    800011ce:	16048513          	addi	a0,s1,352
    800011d2:	8e0ff0ef          	jal	800002b2 <safestrcpy>
  p->cwd = namei("/");
    800011d6:	00006517          	auipc	a0,0x6
    800011da:	00a50513          	addi	a0,a0,10 # 800071e0 <etext+0x1e0>
    800011de:	717010ef          	jal	800030f4 <namei>
    800011e2:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800011e6:	478d                	li	a5,3
    800011e8:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800011ea:	00848513          	addi	a0,s1,8
    800011ee:	1e9040ef          	jal	80005bd6 <release>
}
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6105                	addi	sp,sp,32
    800011fa:	8082                	ret

00000000800011fc <growproc>:
{
    800011fc:	1101                	addi	sp,sp,-32
    800011fe:	ec06                	sd	ra,24(sp)
    80001200:	e822                	sd	s0,16(sp)
    80001202:	e426                	sd	s1,8(sp)
    80001204:	e04a                	sd	s2,0(sp)
    80001206:	1000                	addi	s0,sp,32
    80001208:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000120a:	d11ff0ef          	jal	80000f1a <myproc>
    8000120e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001210:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001212:	01204c63          	bgtz	s2,8000122a <growproc+0x2e>
  } else if(n < 0){
    80001216:	02094463          	bltz	s2,8000123e <growproc+0x42>
  p->sz = sz;
    8000121a:	e8ac                	sd	a1,80(s1)
  return 0;
    8000121c:	4501                	li	a0,0
}
    8000121e:	60e2                	ld	ra,24(sp)
    80001220:	6442                	ld	s0,16(sp)
    80001222:	64a2                	ld	s1,8(sp)
    80001224:	6902                	ld	s2,0(sp)
    80001226:	6105                	addi	sp,sp,32
    80001228:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000122a:	4691                	li	a3,4
    8000122c:	00b90633          	add	a2,s2,a1
    80001230:	6d28                	ld	a0,88(a0)
    80001232:	dc8ff0ef          	jal	800007fa <uvmalloc>
    80001236:	85aa                	mv	a1,a0
    80001238:	f16d                	bnez	a0,8000121a <growproc+0x1e>
      return -1;
    8000123a:	557d                	li	a0,-1
    8000123c:	b7cd                	j	8000121e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000123e:	00b90633          	add	a2,s2,a1
    80001242:	6d28                	ld	a0,88(a0)
    80001244:	d72ff0ef          	jal	800007b6 <uvmdealloc>
    80001248:	85aa                	mv	a1,a0
    8000124a:	bfc1                	j	8000121a <growproc+0x1e>

000000008000124c <fork>:
{
    8000124c:	7139                	addi	sp,sp,-64
    8000124e:	fc06                	sd	ra,56(sp)
    80001250:	f822                	sd	s0,48(sp)
    80001252:	ec4e                	sd	s3,24(sp)
    80001254:	e456                	sd	s5,8(sp)
    80001256:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001258:	cc3ff0ef          	jal	80000f1a <myproc>
    8000125c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000125e:	e81ff0ef          	jal	800010de <allocproc>
    80001262:	0e050d63          	beqz	a0,8000135c <fork+0x110>
    80001266:	e852                	sd	s4,16(sp)
    80001268:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000126a:	050ab603          	ld	a2,80(s5)
    8000126e:	6d2c                	ld	a1,88(a0)
    80001270:	058ab503          	ld	a0,88(s5)
    80001274:	eb6ff0ef          	jal	8000092a <uvmcopy>
    80001278:	04054a63          	bltz	a0,800012cc <fork+0x80>
    8000127c:	f426                	sd	s1,40(sp)
    8000127e:	f04a                	sd	s2,32(sp)
  np->sz = p->sz;
    80001280:	050ab783          	ld	a5,80(s5)
    80001284:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001288:	060ab683          	ld	a3,96(s5)
    8000128c:	87b6                	mv	a5,a3
    8000128e:	060a3703          	ld	a4,96(s4)
    80001292:	12068693          	addi	a3,a3,288
    80001296:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000129a:	6788                	ld	a0,8(a5)
    8000129c:	6b8c                	ld	a1,16(a5)
    8000129e:	6f90                	ld	a2,24(a5)
    800012a0:	01073023          	sd	a6,0(a4)
    800012a4:	e708                	sd	a0,8(a4)
    800012a6:	eb0c                	sd	a1,16(a4)
    800012a8:	ef10                	sd	a2,24(a4)
    800012aa:	02078793          	addi	a5,a5,32
    800012ae:	02070713          	addi	a4,a4,32
    800012b2:	fed792e3          	bne	a5,a3,80001296 <fork+0x4a>
  np->trapframe->a0 = 0;
    800012b6:	060a3783          	ld	a5,96(s4)
    800012ba:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012be:	0d8a8493          	addi	s1,s5,216
    800012c2:	0d8a0913          	addi	s2,s4,216
    800012c6:	158a8993          	addi	s3,s5,344
    800012ca:	a839                	j	800012e8 <fork+0x9c>
    freeproc(np);
    800012cc:	8552                	mv	a0,s4
    800012ce:	dc1ff0ef          	jal	8000108e <freeproc>
    release(&np->lock);
    800012d2:	008a0513          	addi	a0,s4,8
    800012d6:	101040ef          	jal	80005bd6 <release>
    return -1;
    800012da:	59fd                	li	s3,-1
    800012dc:	6a42                	ld	s4,16(sp)
    800012de:	a885                	j	8000134e <fork+0x102>
  for(i = 0; i < NOFILE; i++)
    800012e0:	04a1                	addi	s1,s1,8
    800012e2:	0921                	addi	s2,s2,8
    800012e4:	01348963          	beq	s1,s3,800012f6 <fork+0xaa>
    if(p->ofile[i])
    800012e8:	6088                	ld	a0,0(s1)
    800012ea:	d97d                	beqz	a0,800012e0 <fork+0x94>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ec:	398020ef          	jal	80003684 <filedup>
    800012f0:	00a93023          	sd	a0,0(s2)
    800012f4:	b7f5                	j	800012e0 <fork+0x94>
  np->cwd = idup(p->cwd);
    800012f6:	158ab503          	ld	a0,344(s5)
    800012fa:	6ea010ef          	jal	800029e4 <idup>
    800012fe:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001302:	4641                	li	a2,16
    80001304:	160a8593          	addi	a1,s5,352
    80001308:	160a0513          	addi	a0,s4,352
    8000130c:	fa7fe0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    80001310:	038a2983          	lw	s3,56(s4)
  release(&np->lock);
    80001314:	008a0493          	addi	s1,s4,8
    80001318:	8526                	mv	a0,s1
    8000131a:	0bd040ef          	jal	80005bd6 <release>
  acquire(&wait_lock);
    8000131e:	00009917          	auipc	s2,0x9
    80001322:	13a90913          	addi	s2,s2,314 # 8000a458 <wait_lock>
    80001326:	854a                	mv	a0,s2
    80001328:	017040ef          	jal	80005b3e <acquire>
  np->parent = p;
    8000132c:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001330:	854a                	mv	a0,s2
    80001332:	0a5040ef          	jal	80005bd6 <release>
  acquire(&np->lock);
    80001336:	8526                	mv	a0,s1
    80001338:	007040ef          	jal	80005b3e <acquire>
  np->state = RUNNABLE;
    8000133c:	478d                	li	a5,3
    8000133e:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001342:	8526                	mv	a0,s1
    80001344:	093040ef          	jal	80005bd6 <release>
  return pid;
    80001348:	74a2                	ld	s1,40(sp)
    8000134a:	7902                	ld	s2,32(sp)
    8000134c:	6a42                	ld	s4,16(sp)
}
    8000134e:	854e                	mv	a0,s3
    80001350:	70e2                	ld	ra,56(sp)
    80001352:	7442                	ld	s0,48(sp)
    80001354:	69e2                	ld	s3,24(sp)
    80001356:	6aa2                	ld	s5,8(sp)
    80001358:	6121                	addi	sp,sp,64
    8000135a:	8082                	ret
    return -1;
    8000135c:	59fd                	li	s3,-1
    8000135e:	bfc5                	j	8000134e <fork+0x102>

0000000080001360 <scheduler>:
{
    80001360:	711d                	addi	sp,sp,-96
    80001362:	ec86                	sd	ra,88(sp)
    80001364:	e8a2                	sd	s0,80(sp)
    80001366:	e4a6                	sd	s1,72(sp)
    80001368:	e0ca                	sd	s2,64(sp)
    8000136a:	fc4e                	sd	s3,56(sp)
    8000136c:	f852                	sd	s4,48(sp)
    8000136e:	f456                	sd	s5,40(sp)
    80001370:	f05a                	sd	s6,32(sp)
    80001372:	ec5e                	sd	s7,24(sp)
    80001374:	e862                	sd	s8,16(sp)
    80001376:	e466                	sd	s9,8(sp)
    80001378:	1080                	addi	s0,sp,96
    8000137a:	8792                	mv	a5,tp
  int id = r_tp();
    8000137c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000137e:	00779b13          	slli	s6,a5,0x7
    80001382:	00009717          	auipc	a4,0x9
    80001386:	0be70713          	addi	a4,a4,190 # 8000a440 <pid_lock>
    8000138a:	975a                	add	a4,a4,s6
    8000138c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001390:	00009717          	auipc	a4,0x9
    80001394:	0e870713          	addi	a4,a4,232 # 8000a478 <cpus+0x8>
    80001398:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000139a:	4c11                	li	s8,4
        c->proc = p;
    8000139c:	079e                	slli	a5,a5,0x7
    8000139e:	00009a97          	auipc	s5,0x9
    800013a2:	0a2a8a93          	addi	s5,s5,162 # 8000a440 <pid_lock>
    800013a6:	9abe                	add	s5,s5,a5
        found = 1;
    800013a8:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800013aa:	0000fa17          	auipc	s4,0xf
    800013ae:	0c6a0a13          	addi	s4,s4,198 # 80010470 <ptable>
    800013b2:	a891                	j	80001406 <scheduler+0xa6>
      release(&p->lock);
    800013b4:	854a                	mv	a0,s2
    800013b6:	021040ef          	jal	80005bd6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ba:	17048493          	addi	s1,s1,368
    800013be:	03448a63          	beq	s1,s4,800013f2 <scheduler+0x92>
      acquire(&p->lock);
    800013c2:	00848913          	addi	s2,s1,8
    800013c6:	854a                	mv	a0,s2
    800013c8:	776040ef          	jal	80005b3e <acquire>
      if(p->state == RUNNABLE) {
    800013cc:	509c                	lw	a5,32(s1)
    800013ce:	ff3793e3          	bne	a5,s3,800013b4 <scheduler+0x54>
        p->state = RUNNING;
    800013d2:	0384a023          	sw	s8,32(s1)
        c->proc = p;
    800013d6:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    800013da:	06848593          	addi	a1,s1,104
    800013de:	855a                	mv	a0,s6
    800013e0:	5f8000ef          	jal	800019d8 <swtch>
	p->cputime++; // project
    800013e4:	609c                	ld	a5,0(s1)
    800013e6:	0785                	addi	a5,a5,1
    800013e8:	e09c                	sd	a5,0(s1)
        c->proc = 0;
    800013ea:	020ab823          	sd	zero,48(s5)
        found = 1;
    800013ee:	8cde                	mv	s9,s7
    800013f0:	b7d1                	j	800013b4 <scheduler+0x54>
    if(found == 0) {
    800013f2:	000c9a63          	bnez	s9,80001406 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fe:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001402:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001406:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000140a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000140e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001412:	4c81                	li	s9,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001414:	00009497          	auipc	s1,0x9
    80001418:	45c48493          	addi	s1,s1,1116 # 8000a870 <proc>
      if(p->state == RUNNABLE) {
    8000141c:	498d                	li	s3,3
    8000141e:	b755                	j	800013c2 <scheduler+0x62>

0000000080001420 <sched>:
{
    80001420:	7179                	addi	sp,sp,-48
    80001422:	f406                	sd	ra,40(sp)
    80001424:	f022                	sd	s0,32(sp)
    80001426:	ec26                	sd	s1,24(sp)
    80001428:	e84a                	sd	s2,16(sp)
    8000142a:	e44e                	sd	s3,8(sp)
    8000142c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000142e:	aedff0ef          	jal	80000f1a <myproc>
    80001432:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001434:	0521                	addi	a0,a0,8
    80001436:	69e040ef          	jal	80005ad4 <holding>
    8000143a:	c92d                	beqz	a0,800014ac <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	00009717          	auipc	a4,0x9
    80001446:	ffe70713          	addi	a4,a4,-2 # 8000a440 <pid_lock>
    8000144a:	97ba                	add	a5,a5,a4
    8000144c:	0a87a703          	lw	a4,168(a5)
    80001450:	4785                	li	a5,1
    80001452:	06f71363          	bne	a4,a5,800014b8 <sched+0x98>
  if(p->state == RUNNING)
    80001456:	5098                	lw	a4,32(s1)
    80001458:	4791                	li	a5,4
    8000145a:	06f70563          	beq	a4,a5,800014c4 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001462:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001464:	e7b5                	bnez	a5,800014d0 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001468:	00009917          	auipc	s2,0x9
    8000146c:	fd890913          	addi	s2,s2,-40 # 8000a440 <pid_lock>
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	97ca                	add	a5,a5,s2
    80001476:	0ac7a983          	lw	s3,172(a5)
    8000147a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000147c:	2781                	sext.w	a5,a5
    8000147e:	079e                	slli	a5,a5,0x7
    80001480:	00009597          	auipc	a1,0x9
    80001484:	ff858593          	addi	a1,a1,-8 # 8000a478 <cpus+0x8>
    80001488:	95be                	add	a1,a1,a5
    8000148a:	06848513          	addi	a0,s1,104
    8000148e:	54a000ef          	jal	800019d8 <swtch>
    80001492:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001494:	2781                	sext.w	a5,a5
    80001496:	079e                	slli	a5,a5,0x7
    80001498:	993e                	add	s2,s2,a5
    8000149a:	0b392623          	sw	s3,172(s2)
}
    8000149e:	70a2                	ld	ra,40(sp)
    800014a0:	7402                	ld	s0,32(sp)
    800014a2:	64e2                	ld	s1,24(sp)
    800014a4:	6942                	ld	s2,16(sp)
    800014a6:	69a2                	ld	s3,8(sp)
    800014a8:	6145                	addi	sp,sp,48
    800014aa:	8082                	ret
    panic("sched p->lock");
    800014ac:	00006517          	auipc	a0,0x6
    800014b0:	d3c50513          	addi	a0,a0,-708 # 800071e8 <etext+0x1e8>
    800014b4:	35c040ef          	jal	80005810 <panic>
    panic("sched locks");
    800014b8:	00006517          	auipc	a0,0x6
    800014bc:	d4050513          	addi	a0,a0,-704 # 800071f8 <etext+0x1f8>
    800014c0:	350040ef          	jal	80005810 <panic>
    panic("sched running");
    800014c4:	00006517          	auipc	a0,0x6
    800014c8:	d4450513          	addi	a0,a0,-700 # 80007208 <etext+0x208>
    800014cc:	344040ef          	jal	80005810 <panic>
    panic("sched interruptible");
    800014d0:	00006517          	auipc	a0,0x6
    800014d4:	d4850513          	addi	a0,a0,-696 # 80007218 <etext+0x218>
    800014d8:	338040ef          	jal	80005810 <panic>

00000000800014dc <yield>:
{
    800014dc:	1101                	addi	sp,sp,-32
    800014de:	ec06                	sd	ra,24(sp)
    800014e0:	e822                	sd	s0,16(sp)
    800014e2:	e426                	sd	s1,8(sp)
    800014e4:	e04a                	sd	s2,0(sp)
    800014e6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e8:	a33ff0ef          	jal	80000f1a <myproc>
    800014ec:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ee:	00850913          	addi	s2,a0,8
    800014f2:	854a                	mv	a0,s2
    800014f4:	64a040ef          	jal	80005b3e <acquire>
  p->state = RUNNABLE;
    800014f8:	478d                	li	a5,3
    800014fa:	d09c                	sw	a5,32(s1)
  sched();
    800014fc:	f25ff0ef          	jal	80001420 <sched>
  release(&p->lock);
    80001500:	854a                	mv	a0,s2
    80001502:	6d4040ef          	jal	80005bd6 <release>
}
    80001506:	60e2                	ld	ra,24(sp)
    80001508:	6442                	ld	s0,16(sp)
    8000150a:	64a2                	ld	s1,8(sp)
    8000150c:	6902                	ld	s2,0(sp)
    8000150e:	6105                	addi	sp,sp,32
    80001510:	8082                	ret

0000000080001512 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001512:	7179                	addi	sp,sp,-48
    80001514:	f406                	sd	ra,40(sp)
    80001516:	f022                	sd	s0,32(sp)
    80001518:	ec26                	sd	s1,24(sp)
    8000151a:	e84a                	sd	s2,16(sp)
    8000151c:	e44e                	sd	s3,8(sp)
    8000151e:	e052                	sd	s4,0(sp)
    80001520:	1800                	addi	s0,sp,48
    80001522:	89aa                	mv	s3,a0
    80001524:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001526:	9f5ff0ef          	jal	80000f1a <myproc>
    8000152a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152c:	00850a13          	addi	s4,a0,8
    80001530:	8552                	mv	a0,s4
    80001532:	60c040ef          	jal	80005b3e <acquire>
  release(lk);
    80001536:	854a                	mv	a0,s2
    80001538:	69e040ef          	jal	80005bd6 <release>

  // Go to sleep.
  p->chan = chan;
    8000153c:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001540:	4789                	li	a5,2
    80001542:	d09c                	sw	a5,32(s1)

  sched();
    80001544:	eddff0ef          	jal	80001420 <sched>

  // Tidy up.
  p->chan = 0;
    80001548:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154c:	8552                	mv	a0,s4
    8000154e:	688040ef          	jal	80005bd6 <release>
  acquire(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	5ea040ef          	jal	80005b3e <acquire>
}
    80001558:	70a2                	ld	ra,40(sp)
    8000155a:	7402                	ld	s0,32(sp)
    8000155c:	64e2                	ld	s1,24(sp)
    8000155e:	6942                	ld	s2,16(sp)
    80001560:	69a2                	ld	s3,8(sp)
    80001562:	6a02                	ld	s4,0(sp)
    80001564:	6145                	addi	sp,sp,48
    80001566:	8082                	ret

0000000080001568 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001568:	7139                	addi	sp,sp,-64
    8000156a:	fc06                	sd	ra,56(sp)
    8000156c:	f822                	sd	s0,48(sp)
    8000156e:	f426                	sd	s1,40(sp)
    80001570:	f04a                	sd	s2,32(sp)
    80001572:	ec4e                	sd	s3,24(sp)
    80001574:	e852                	sd	s4,16(sp)
    80001576:	e456                	sd	s5,8(sp)
    80001578:	e05a                	sd	s6,0(sp)
    8000157a:	0080                	addi	s0,sp,64
    8000157c:	8aaa                	mv	s5,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000157e:	00009497          	auipc	s1,0x9
    80001582:	2f248493          	addi	s1,s1,754 # 8000a870 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001586:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001588:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000158a:	0000f997          	auipc	s3,0xf
    8000158e:	ee698993          	addi	s3,s3,-282 # 80010470 <ptable>
    80001592:	a801                	j	800015a2 <wakeup+0x3a>
      }
      release(&p->lock);
    80001594:	854a                	mv	a0,s2
    80001596:	640040ef          	jal	80005bd6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000159a:	17048493          	addi	s1,s1,368
    8000159e:	03348463          	beq	s1,s3,800015c6 <wakeup+0x5e>
    if(p != myproc()){
    800015a2:	979ff0ef          	jal	80000f1a <myproc>
    800015a6:	fea48ae3          	beq	s1,a0,8000159a <wakeup+0x32>
      acquire(&p->lock);
    800015aa:	00848913          	addi	s2,s1,8
    800015ae:	854a                	mv	a0,s2
    800015b0:	58e040ef          	jal	80005b3e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b4:	509c                	lw	a5,32(s1)
    800015b6:	fd479fe3          	bne	a5,s4,80001594 <wakeup+0x2c>
    800015ba:	749c                	ld	a5,40(s1)
    800015bc:	fd579ce3          	bne	a5,s5,80001594 <wakeup+0x2c>
        p->state = RUNNABLE;
    800015c0:	0364a023          	sw	s6,32(s1)
    800015c4:	bfc1                	j	80001594 <wakeup+0x2c>
    }
  }
}
    800015c6:	70e2                	ld	ra,56(sp)
    800015c8:	7442                	ld	s0,48(sp)
    800015ca:	74a2                	ld	s1,40(sp)
    800015cc:	7902                	ld	s2,32(sp)
    800015ce:	69e2                	ld	s3,24(sp)
    800015d0:	6a42                	ld	s4,16(sp)
    800015d2:	6aa2                	ld	s5,8(sp)
    800015d4:	6b02                	ld	s6,0(sp)
    800015d6:	6121                	addi	sp,sp,64
    800015d8:	8082                	ret

00000000800015da <reparent>:
{
    800015da:	7179                	addi	sp,sp,-48
    800015dc:	f406                	sd	ra,40(sp)
    800015de:	f022                	sd	s0,32(sp)
    800015e0:	ec26                	sd	s1,24(sp)
    800015e2:	e84a                	sd	s2,16(sp)
    800015e4:	e44e                	sd	s3,8(sp)
    800015e6:	e052                	sd	s4,0(sp)
    800015e8:	1800                	addi	s0,sp,48
    800015ea:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015ec:	00009497          	auipc	s1,0x9
    800015f0:	28448493          	addi	s1,s1,644 # 8000a870 <proc>
      pp->parent = initproc;
    800015f4:	00009a17          	auipc	s4,0x9
    800015f8:	dfca0a13          	addi	s4,s4,-516 # 8000a3f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015fc:	0000f997          	auipc	s3,0xf
    80001600:	e7498993          	addi	s3,s3,-396 # 80010470 <ptable>
    80001604:	a029                	j	8000160e <reparent+0x34>
    80001606:	17048493          	addi	s1,s1,368
    8000160a:	01348b63          	beq	s1,s3,80001620 <reparent+0x46>
    if(pp->parent == p){
    8000160e:	60bc                	ld	a5,64(s1)
    80001610:	ff279be3          	bne	a5,s2,80001606 <reparent+0x2c>
      pp->parent = initproc;
    80001614:	000a3503          	ld	a0,0(s4)
    80001618:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000161a:	f4fff0ef          	jal	80001568 <wakeup>
    8000161e:	b7e5                	j	80001606 <reparent+0x2c>
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6a02                	ld	s4,0(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret

0000000080001630 <exit>:
{
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001642:	8d9ff0ef          	jal	80000f1a <myproc>
    80001646:	89aa                	mv	s3,a0
  if(p == initproc)
    80001648:	00009797          	auipc	a5,0x9
    8000164c:	da87b783          	ld	a5,-600(a5) # 8000a3f0 <initproc>
    80001650:	0d850493          	addi	s1,a0,216
    80001654:	15850913          	addi	s2,a0,344
    80001658:	00a79f63          	bne	a5,a0,80001676 <exit+0x46>
    panic("init exiting");
    8000165c:	00006517          	auipc	a0,0x6
    80001660:	bd450513          	addi	a0,a0,-1068 # 80007230 <etext+0x230>
    80001664:	1ac040ef          	jal	80005810 <panic>
      fileclose(f);
    80001668:	062020ef          	jal	800036ca <fileclose>
      p->ofile[fd] = 0;
    8000166c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001670:	04a1                	addi	s1,s1,8
    80001672:	01248563          	beq	s1,s2,8000167c <exit+0x4c>
    if(p->ofile[fd]){
    80001676:	6088                	ld	a0,0(s1)
    80001678:	f965                	bnez	a0,80001668 <exit+0x38>
    8000167a:	bfdd                	j	80001670 <exit+0x40>
  begin_op();
    8000167c:	435010ef          	jal	800032b0 <begin_op>
  iput(p->cwd);
    80001680:	1589b503          	ld	a0,344(s3)
    80001684:	518010ef          	jal	80002b9c <iput>
  end_op();
    80001688:	493010ef          	jal	8000331a <end_op>
  p->cwd = 0;
    8000168c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001690:	00009497          	auipc	s1,0x9
    80001694:	dc848493          	addi	s1,s1,-568 # 8000a458 <wait_lock>
    80001698:	8526                	mv	a0,s1
    8000169a:	4a4040ef          	jal	80005b3e <acquire>
  reparent(p);
    8000169e:	854e                	mv	a0,s3
    800016a0:	f3bff0ef          	jal	800015da <reparent>
  wakeup(p->parent);
    800016a4:	0409b503          	ld	a0,64(s3)
    800016a8:	ec1ff0ef          	jal	80001568 <wakeup>
  acquire(&p->lock);
    800016ac:	00898513          	addi	a0,s3,8
    800016b0:	48e040ef          	jal	80005b3e <acquire>
  p->xstate = status;
    800016b4:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800016b8:	4795                	li	a5,5
    800016ba:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	516040ef          	jal	80005bd6 <release>
  sched();
    800016c4:	d5dff0ef          	jal	80001420 <sched>
  panic("zombie exit");
    800016c8:	00006517          	auipc	a0,0x6
    800016cc:	b7850513          	addi	a0,a0,-1160 # 80007240 <etext+0x240>
    800016d0:	140040ef          	jal	80005810 <panic>

00000000800016d4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016d4:	7179                	addi	sp,sp,-48
    800016d6:	f406                	sd	ra,40(sp)
    800016d8:	f022                	sd	s0,32(sp)
    800016da:	ec26                	sd	s1,24(sp)
    800016dc:	e84a                	sd	s2,16(sp)
    800016de:	e44e                	sd	s3,8(sp)
    800016e0:	e052                	sd	s4,0(sp)
    800016e2:	1800                	addi	s0,sp,48
    800016e4:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800016e6:	00009497          	auipc	s1,0x9
    800016ea:	18a48493          	addi	s1,s1,394 # 8000a870 <proc>
    800016ee:	0000fa17          	auipc	s4,0xf
    800016f2:	d82a0a13          	addi	s4,s4,-638 # 80010470 <ptable>
    acquire(&p->lock);
    800016f6:	00848913          	addi	s2,s1,8
    800016fa:	854a                	mv	a0,s2
    800016fc:	442040ef          	jal	80005b3e <acquire>
    if(p->pid == pid){
    80001700:	5c9c                	lw	a5,56(s1)
    80001702:	01378b63          	beq	a5,s3,80001718 <kill+0x44>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001706:	854a                	mv	a0,s2
    80001708:	4ce040ef          	jal	80005bd6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000170c:	17048493          	addi	s1,s1,368
    80001710:	ff4493e3          	bne	s1,s4,800016f6 <kill+0x22>
  }
  return -1;
    80001714:	557d                	li	a0,-1
    80001716:	a819                	j	8000172c <kill+0x58>
      p->killed = 1;
    80001718:	4785                	li	a5,1
    8000171a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000171c:	5098                	lw	a4,32(s1)
    8000171e:	4789                	li	a5,2
    80001720:	00f70e63          	beq	a4,a5,8000173c <kill+0x68>
      release(&p->lock);
    80001724:	854a                	mv	a0,s2
    80001726:	4b0040ef          	jal	80005bd6 <release>
      return 0;
    8000172a:	4501                	li	a0,0
}
    8000172c:	70a2                	ld	ra,40(sp)
    8000172e:	7402                	ld	s0,32(sp)
    80001730:	64e2                	ld	s1,24(sp)
    80001732:	6942                	ld	s2,16(sp)
    80001734:	69a2                	ld	s3,8(sp)
    80001736:	6a02                	ld	s4,0(sp)
    80001738:	6145                	addi	sp,sp,48
    8000173a:	8082                	ret
        p->state = RUNNABLE;
    8000173c:	478d                	li	a5,3
    8000173e:	d09c                	sw	a5,32(s1)
    80001740:	b7d5                	j	80001724 <kill+0x50>

0000000080001742 <setkilled>:

void
setkilled(struct proc *p)
{
    80001742:	1101                	addi	sp,sp,-32
    80001744:	ec06                	sd	ra,24(sp)
    80001746:	e822                	sd	s0,16(sp)
    80001748:	e426                	sd	s1,8(sp)
    8000174a:	e04a                	sd	s2,0(sp)
    8000174c:	1000                	addi	s0,sp,32
    8000174e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001750:	00850913          	addi	s2,a0,8
    80001754:	854a                	mv	a0,s2
    80001756:	3e8040ef          	jal	80005b3e <acquire>
  p->killed = 1;
    8000175a:	4785                	li	a5,1
    8000175c:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    8000175e:	854a                	mv	a0,s2
    80001760:	476040ef          	jal	80005bd6 <release>
}
    80001764:	60e2                	ld	ra,24(sp)
    80001766:	6442                	ld	s0,16(sp)
    80001768:	64a2                	ld	s1,8(sp)
    8000176a:	6902                	ld	s2,0(sp)
    8000176c:	6105                	addi	sp,sp,32
    8000176e:	8082                	ret

0000000080001770 <killed>:

int
killed(struct proc *p)
{
    80001770:	1101                	addi	sp,sp,-32
    80001772:	ec06                	sd	ra,24(sp)
    80001774:	e822                	sd	s0,16(sp)
    80001776:	e426                	sd	s1,8(sp)
    80001778:	e04a                	sd	s2,0(sp)
    8000177a:	1000                	addi	s0,sp,32
    8000177c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000177e:	00850913          	addi	s2,a0,8
    80001782:	854a                	mv	a0,s2
    80001784:	3ba040ef          	jal	80005b3e <acquire>
  k = p->killed;
    80001788:	5884                	lw	s1,48(s1)
  release(&p->lock);
    8000178a:	854a                	mv	a0,s2
    8000178c:	44a040ef          	jal	80005bd6 <release>
  return k;
}
    80001790:	8526                	mv	a0,s1
    80001792:	60e2                	ld	ra,24(sp)
    80001794:	6442                	ld	s0,16(sp)
    80001796:	64a2                	ld	s1,8(sp)
    80001798:	6902                	ld	s2,0(sp)
    8000179a:	6105                	addi	sp,sp,32
    8000179c:	8082                	ret

000000008000179e <wait>:
{
    8000179e:	711d                	addi	sp,sp,-96
    800017a0:	ec86                	sd	ra,88(sp)
    800017a2:	e8a2                	sd	s0,80(sp)
    800017a4:	e4a6                	sd	s1,72(sp)
    800017a6:	e0ca                	sd	s2,64(sp)
    800017a8:	fc4e                	sd	s3,56(sp)
    800017aa:	f852                	sd	s4,48(sp)
    800017ac:	f456                	sd	s5,40(sp)
    800017ae:	f05a                	sd	s6,32(sp)
    800017b0:	ec5e                	sd	s7,24(sp)
    800017b2:	e862                	sd	s8,16(sp)
    800017b4:	e466                	sd	s9,8(sp)
    800017b6:	1080                	addi	s0,sp,96
    800017b8:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800017ba:	f60ff0ef          	jal	80000f1a <myproc>
    800017be:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017c0:	00009517          	auipc	a0,0x9
    800017c4:	c9850513          	addi	a0,a0,-872 # 8000a458 <wait_lock>
    800017c8:	376040ef          	jal	80005b3e <acquire>
    havekids = 0;
    800017cc:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800017ce:	4a95                	li	s5,5
        havekids = 1;
    800017d0:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017d2:	0000f997          	auipc	s3,0xf
    800017d6:	c9e98993          	addi	s3,s3,-866 # 80010470 <ptable>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017da:	00009c97          	auipc	s9,0x9
    800017de:	c7ec8c93          	addi	s9,s9,-898 # 8000a458 <wait_lock>
    800017e2:	a04d                	j	80001884 <wait+0xe6>
          pid = pp->pid;
    800017e4:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800017e8:	000b8c63          	beqz	s7,80001800 <wait+0x62>
    800017ec:	4691                	li	a3,4
    800017ee:	03448613          	addi	a2,s1,52
    800017f2:	85de                	mv	a1,s7
    800017f4:	05893503          	ld	a0,88(s2)
    800017f8:	a0eff0ef          	jal	80000a06 <copyout>
    800017fc:	02054c63          	bltz	a0,80001834 <wait+0x96>
          freeproc(pp);
    80001800:	8526                	mv	a0,s1
    80001802:	88dff0ef          	jal	8000108e <freeproc>
          release(&pp->lock);
    80001806:	8552                	mv	a0,s4
    80001808:	3ce040ef          	jal	80005bd6 <release>
          release(&wait_lock);
    8000180c:	00009517          	auipc	a0,0x9
    80001810:	c4c50513          	addi	a0,a0,-948 # 8000a458 <wait_lock>
    80001814:	3c2040ef          	jal	80005bd6 <release>
}
    80001818:	854e                	mv	a0,s3
    8000181a:	60e6                	ld	ra,88(sp)
    8000181c:	6446                	ld	s0,80(sp)
    8000181e:	64a6                	ld	s1,72(sp)
    80001820:	6906                	ld	s2,64(sp)
    80001822:	79e2                	ld	s3,56(sp)
    80001824:	7a42                	ld	s4,48(sp)
    80001826:	7aa2                	ld	s5,40(sp)
    80001828:	7b02                	ld	s6,32(sp)
    8000182a:	6be2                	ld	s7,24(sp)
    8000182c:	6c42                	ld	s8,16(sp)
    8000182e:	6ca2                	ld	s9,8(sp)
    80001830:	6125                	addi	sp,sp,96
    80001832:	8082                	ret
            release(&pp->lock);
    80001834:	8552                	mv	a0,s4
    80001836:	3a0040ef          	jal	80005bd6 <release>
            release(&wait_lock);
    8000183a:	00009517          	auipc	a0,0x9
    8000183e:	c1e50513          	addi	a0,a0,-994 # 8000a458 <wait_lock>
    80001842:	394040ef          	jal	80005bd6 <release>
            return -1;
    80001846:	59fd                	li	s3,-1
    80001848:	bfc1                	j	80001818 <wait+0x7a>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000184a:	17048493          	addi	s1,s1,368
    8000184e:	03348263          	beq	s1,s3,80001872 <wait+0xd4>
      if(pp->parent == p){
    80001852:	60bc                	ld	a5,64(s1)
    80001854:	ff279be3          	bne	a5,s2,8000184a <wait+0xac>
        acquire(&pp->lock);
    80001858:	00848a13          	addi	s4,s1,8
    8000185c:	8552                	mv	a0,s4
    8000185e:	2e0040ef          	jal	80005b3e <acquire>
        if(pp->state == ZOMBIE){
    80001862:	509c                	lw	a5,32(s1)
    80001864:	f95780e3          	beq	a5,s5,800017e4 <wait+0x46>
        release(&pp->lock);
    80001868:	8552                	mv	a0,s4
    8000186a:	36c040ef          	jal	80005bd6 <release>
        havekids = 1;
    8000186e:	875a                	mv	a4,s6
    80001870:	bfe9                	j	8000184a <wait+0xac>
    if(!havekids || killed(p)){
    80001872:	cf19                	beqz	a4,80001890 <wait+0xf2>
    80001874:	854a                	mv	a0,s2
    80001876:	efbff0ef          	jal	80001770 <killed>
    8000187a:	e919                	bnez	a0,80001890 <wait+0xf2>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000187c:	85e6                	mv	a1,s9
    8000187e:	854a                	mv	a0,s2
    80001880:	c93ff0ef          	jal	80001512 <sleep>
    havekids = 0;
    80001884:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001886:	00009497          	auipc	s1,0x9
    8000188a:	fea48493          	addi	s1,s1,-22 # 8000a870 <proc>
    8000188e:	b7d1                	j	80001852 <wait+0xb4>
      release(&wait_lock);
    80001890:	00009517          	auipc	a0,0x9
    80001894:	bc850513          	addi	a0,a0,-1080 # 8000a458 <wait_lock>
    80001898:	33e040ef          	jal	80005bd6 <release>
      return -1;
    8000189c:	59fd                	li	s3,-1
    8000189e:	bfad                	j	80001818 <wait+0x7a>

00000000800018a0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a0:	7179                	addi	sp,sp,-48
    800018a2:	f406                	sd	ra,40(sp)
    800018a4:	f022                	sd	s0,32(sp)
    800018a6:	ec26                	sd	s1,24(sp)
    800018a8:	e84a                	sd	s2,16(sp)
    800018aa:	e44e                	sd	s3,8(sp)
    800018ac:	e052                	sd	s4,0(sp)
    800018ae:	1800                	addi	s0,sp,48
    800018b0:	84aa                	mv	s1,a0
    800018b2:	892e                	mv	s2,a1
    800018b4:	89b2                	mv	s3,a2
    800018b6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018b8:	e62ff0ef          	jal	80000f1a <myproc>
  if(user_dst){
    800018bc:	cc99                	beqz	s1,800018da <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800018be:	86d2                	mv	a3,s4
    800018c0:	864e                	mv	a2,s3
    800018c2:	85ca                	mv	a1,s2
    800018c4:	6d28                	ld	a0,88(a0)
    800018c6:	940ff0ef          	jal	80000a06 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018ca:	70a2                	ld	ra,40(sp)
    800018cc:	7402                	ld	s0,32(sp)
    800018ce:	64e2                	ld	s1,24(sp)
    800018d0:	6942                	ld	s2,16(sp)
    800018d2:	69a2                	ld	s3,8(sp)
    800018d4:	6a02                	ld	s4,0(sp)
    800018d6:	6145                	addi	sp,sp,48
    800018d8:	8082                	ret
    memmove((char *)dst, src, len);
    800018da:	000a061b          	sext.w	a2,s4
    800018de:	85ce                	mv	a1,s3
    800018e0:	854a                	mv	a0,s2
    800018e2:	8effe0ef          	jal	800001d0 <memmove>
    return 0;
    800018e6:	8526                	mv	a0,s1
    800018e8:	b7cd                	j	800018ca <either_copyout+0x2a>

00000000800018ea <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018ea:	7179                	addi	sp,sp,-48
    800018ec:	f406                	sd	ra,40(sp)
    800018ee:	f022                	sd	s0,32(sp)
    800018f0:	ec26                	sd	s1,24(sp)
    800018f2:	e84a                	sd	s2,16(sp)
    800018f4:	e44e                	sd	s3,8(sp)
    800018f6:	e052                	sd	s4,0(sp)
    800018f8:	1800                	addi	s0,sp,48
    800018fa:	892a                	mv	s2,a0
    800018fc:	84ae                	mv	s1,a1
    800018fe:	89b2                	mv	s3,a2
    80001900:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001902:	e18ff0ef          	jal	80000f1a <myproc>
  if(user_src){
    80001906:	cc99                	beqz	s1,80001924 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001908:	86d2                	mv	a3,s4
    8000190a:	864e                	mv	a2,s3
    8000190c:	85ca                	mv	a1,s2
    8000190e:	6d28                	ld	a0,88(a0)
    80001910:	9ceff0ef          	jal	80000ade <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001914:	70a2                	ld	ra,40(sp)
    80001916:	7402                	ld	s0,32(sp)
    80001918:	64e2                	ld	s1,24(sp)
    8000191a:	6942                	ld	s2,16(sp)
    8000191c:	69a2                	ld	s3,8(sp)
    8000191e:	6a02                	ld	s4,0(sp)
    80001920:	6145                	addi	sp,sp,48
    80001922:	8082                	ret
    memmove(dst, (char*)src, len);
    80001924:	000a061b          	sext.w	a2,s4
    80001928:	85ce                	mv	a1,s3
    8000192a:	854a                	mv	a0,s2
    8000192c:	8a5fe0ef          	jal	800001d0 <memmove>
    return 0;
    80001930:	8526                	mv	a0,s1
    80001932:	b7cd                	j	80001914 <either_copyin+0x2a>

0000000080001934 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001934:	715d                	addi	sp,sp,-80
    80001936:	e486                	sd	ra,72(sp)
    80001938:	e0a2                	sd	s0,64(sp)
    8000193a:	fc26                	sd	s1,56(sp)
    8000193c:	f84a                	sd	s2,48(sp)
    8000193e:	f44e                	sd	s3,40(sp)
    80001940:	f052                	sd	s4,32(sp)
    80001942:	ec56                	sd	s5,24(sp)
    80001944:	e85a                	sd	s6,16(sp)
    80001946:	e45e                	sd	s7,8(sp)
    80001948:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000194a:	00005517          	auipc	a0,0x5
    8000194e:	6ce50513          	addi	a0,a0,1742 # 80007018 <etext+0x18>
    80001952:	3ed030ef          	jal	8000553e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001956:	00009497          	auipc	s1,0x9
    8000195a:	07a48493          	addi	s1,s1,122 # 8000a9d0 <proc+0x160>
    8000195e:	0000f917          	auipc	s2,0xf
    80001962:	c7290913          	addi	s2,s2,-910 # 800105d0 <ptable+0x160>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001966:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001968:	00006997          	auipc	s3,0x6
    8000196c:	8e898993          	addi	s3,s3,-1816 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    80001970:	00006a97          	auipc	s5,0x6
    80001974:	8e8a8a93          	addi	s5,s5,-1816 # 80007258 <etext+0x258>
    printf("\n");
    80001978:	00005a17          	auipc	s4,0x5
    8000197c:	6a0a0a13          	addi	s4,s4,1696 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001980:	00006b97          	auipc	s7,0x6
    80001984:	e00b8b93          	addi	s7,s7,-512 # 80007780 <states.0>
    80001988:	a829                	j	800019a2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000198a:	ed86a583          	lw	a1,-296(a3)
    8000198e:	8556                	mv	a0,s5
    80001990:	3af030ef          	jal	8000553e <printf>
    printf("\n");
    80001994:	8552                	mv	a0,s4
    80001996:	3a9030ef          	jal	8000553e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000199a:	17048493          	addi	s1,s1,368
    8000199e:	03248263          	beq	s1,s2,800019c2 <procdump+0x8e>
    if(p->state == UNUSED)
    800019a2:	86a6                	mv	a3,s1
    800019a4:	ec04a783          	lw	a5,-320(s1)
    800019a8:	dbed                	beqz	a5,8000199a <procdump+0x66>
      state = "???";
    800019aa:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ac:	fcfb6fe3          	bltu	s6,a5,8000198a <procdump+0x56>
    800019b0:	02079713          	slli	a4,a5,0x20
    800019b4:	01d75793          	srli	a5,a4,0x1d
    800019b8:	97de                	add	a5,a5,s7
    800019ba:	6390                	ld	a2,0(a5)
    800019bc:	f679                	bnez	a2,8000198a <procdump+0x56>
      state = "???";
    800019be:	864e                	mv	a2,s3
    800019c0:	b7e9                	j	8000198a <procdump+0x56>
  }
}
    800019c2:	60a6                	ld	ra,72(sp)
    800019c4:	6406                	ld	s0,64(sp)
    800019c6:	74e2                	ld	s1,56(sp)
    800019c8:	7942                	ld	s2,48(sp)
    800019ca:	79a2                	ld	s3,40(sp)
    800019cc:	7a02                	ld	s4,32(sp)
    800019ce:	6ae2                	ld	s5,24(sp)
    800019d0:	6b42                	ld	s6,16(sp)
    800019d2:	6ba2                	ld	s7,8(sp)
    800019d4:	6161                	addi	sp,sp,80
    800019d6:	8082                	ret

00000000800019d8 <swtch>:
    800019d8:	00153023          	sd	ra,0(a0)
    800019dc:	00253423          	sd	sp,8(a0)
    800019e0:	e900                	sd	s0,16(a0)
    800019e2:	ed04                	sd	s1,24(a0)
    800019e4:	03253023          	sd	s2,32(a0)
    800019e8:	03353423          	sd	s3,40(a0)
    800019ec:	03453823          	sd	s4,48(a0)
    800019f0:	03553c23          	sd	s5,56(a0)
    800019f4:	05653023          	sd	s6,64(a0)
    800019f8:	05753423          	sd	s7,72(a0)
    800019fc:	05853823          	sd	s8,80(a0)
    80001a00:	05953c23          	sd	s9,88(a0)
    80001a04:	07a53023          	sd	s10,96(a0)
    80001a08:	07b53423          	sd	s11,104(a0)
    80001a0c:	0005b083          	ld	ra,0(a1)
    80001a10:	0085b103          	ld	sp,8(a1)
    80001a14:	6980                	ld	s0,16(a1)
    80001a16:	6d84                	ld	s1,24(a1)
    80001a18:	0205b903          	ld	s2,32(a1)
    80001a1c:	0285b983          	ld	s3,40(a1)
    80001a20:	0305ba03          	ld	s4,48(a1)
    80001a24:	0385ba83          	ld	s5,56(a1)
    80001a28:	0405bb03          	ld	s6,64(a1)
    80001a2c:	0485bb83          	ld	s7,72(a1)
    80001a30:	0505bc03          	ld	s8,80(a1)
    80001a34:	0585bc83          	ld	s9,88(a1)
    80001a38:	0605bd03          	ld	s10,96(a1)
    80001a3c:	0685bd83          	ld	s11,104(a1)
    80001a40:	8082                	ret

0000000080001a42 <get_interrupt_count>:
uint64 interrupt_count = 0;
extern uint64 interrupt_count;

uint64
get_interrupt_count(void)
{
    80001a42:	1141                	addi	sp,sp,-16
    80001a44:	e422                	sd	s0,8(sp)
    80001a46:	0800                	addi	s0,sp,16
    return interrupt_count;
}
    80001a48:	00009517          	auipc	a0,0x9
    80001a4c:	9b853503          	ld	a0,-1608(a0) # 8000a400 <interrupt_count>
    80001a50:	6422                	ld	s0,8(sp)
    80001a52:	0141                	addi	sp,sp,16
    80001a54:	8082                	ret

0000000080001a56 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a56:	1141                	addi	sp,sp,-16
    80001a58:	e406                	sd	ra,8(sp)
    80001a5a:	e022                	sd	s0,0(sp)
    80001a5c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a5e:	00006597          	auipc	a1,0x6
    80001a62:	83a58593          	addi	a1,a1,-1990 # 80007298 <etext+0x298>
    80001a66:	00014517          	auipc	a0,0x14
    80001a6a:	62250513          	addi	a0,a0,1570 # 80016088 <tickslock>
    80001a6e:	050040ef          	jal	80005abe <initlock>
}
    80001a72:	60a2                	ld	ra,8(sp)
    80001a74:	6402                	ld	s0,0(sp)
    80001a76:	0141                	addi	sp,sp,16
    80001a78:	8082                	ret

0000000080001a7a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a7a:	1141                	addi	sp,sp,-16
    80001a7c:	e422                	sd	s0,8(sp)
    80001a7e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a80:	00003797          	auipc	a5,0x3
    80001a84:	fc078793          	addi	a5,a5,-64 # 80004a40 <kernelvec>
    80001a88:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001a8c:	6422                	ld	s0,8(sp)
    80001a8e:	0141                	addi	sp,sp,16
    80001a90:	8082                	ret

0000000080001a92 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001a92:	1141                	addi	sp,sp,-16
    80001a94:	e406                	sd	ra,8(sp)
    80001a96:	e022                	sd	s0,0(sp)
    80001a98:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001a9a:	c80ff0ef          	jal	80000f1a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001aa2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aa4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001aa8:	00004697          	auipc	a3,0x4
    80001aac:	55868693          	addi	a3,a3,1368 # 80006000 <_trampoline>
    80001ab0:	00004717          	auipc	a4,0x4
    80001ab4:	55070713          	addi	a4,a4,1360 # 80006000 <_trampoline>
    80001ab8:	8f15                	sub	a4,a4,a3
    80001aba:	040007b7          	lui	a5,0x4000
    80001abe:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ac0:	07b2                	slli	a5,a5,0xc
    80001ac2:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ac4:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ac8:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001aca:	18002673          	csrr	a2,satp
    80001ace:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ad0:	7130                	ld	a2,96(a0)
    80001ad2:	6538                	ld	a4,72(a0)
    80001ad4:	6585                	lui	a1,0x1
    80001ad6:	972e                	add	a4,a4,a1
    80001ad8:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ada:	7138                	ld	a4,96(a0)
    80001adc:	00000617          	auipc	a2,0x0
    80001ae0:	11860613          	addi	a2,a2,280 # 80001bf4 <usertrap>
    80001ae4:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ae6:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ae8:	8612                	mv	a2,tp
    80001aea:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aec:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001af0:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001af4:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001af8:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001afc:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001afe:	6f18                	ld	a4,24(a4)
    80001b00:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b04:	6d28                	ld	a0,88(a0)
    80001b06:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b08:	00004717          	auipc	a4,0x4
    80001b0c:	59470713          	addi	a4,a4,1428 # 8000609c <userret>
    80001b10:	8f15                	sub	a4,a4,a3
    80001b12:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b14:	577d                	li	a4,-1
    80001b16:	177e                	slli	a4,a4,0x3f
    80001b18:	8d59                	or	a0,a0,a4
    80001b1a:	9782                	jalr	a5
}
    80001b1c:	60a2                	ld	ra,8(sp)
    80001b1e:	6402                	ld	s0,0(sp)
    80001b20:	0141                	addi	sp,sp,16
    80001b22:	8082                	ret

0000000080001b24 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b24:	1101                	addi	sp,sp,-32
    80001b26:	ec06                	sd	ra,24(sp)
    80001b28:	e822                	sd	s0,16(sp)
    80001b2a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001b2c:	bc2ff0ef          	jal	80000eee <cpuid>
    80001b30:	cd11                	beqz	a0,80001b4c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001b32:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001b36:	000f4737          	lui	a4,0xf4
    80001b3a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001b3e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001b40:	14d79073          	csrw	stimecmp,a5
}
    80001b44:	60e2                	ld	ra,24(sp)
    80001b46:	6442                	ld	s0,16(sp)
    80001b48:	6105                	addi	sp,sp,32
    80001b4a:	8082                	ret
    80001b4c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001b4e:	00014497          	auipc	s1,0x14
    80001b52:	53a48493          	addi	s1,s1,1338 # 80016088 <tickslock>
    80001b56:	8526                	mv	a0,s1
    80001b58:	7e7030ef          	jal	80005b3e <acquire>
    ticks++;
    80001b5c:	00009517          	auipc	a0,0x9
    80001b60:	89c50513          	addi	a0,a0,-1892 # 8000a3f8 <ticks>
    80001b64:	411c                	lw	a5,0(a0)
    80001b66:	2785                	addiw	a5,a5,1
    80001b68:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001b6a:	9ffff0ef          	jal	80001568 <wakeup>
    release(&tickslock);
    80001b6e:	8526                	mv	a0,s1
    80001b70:	066040ef          	jal	80005bd6 <release>
    80001b74:	64a2                	ld	s1,8(sp)
    80001b76:	bf75                	j	80001b32 <clockintr+0xe>

0000000080001b78 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b78:	1101                	addi	sp,sp,-32
    80001b7a:	ec06                	sd	ra,24(sp)
    80001b7c:	e822                	sd	s0,16(sp)
    80001b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b80:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001b84:	57fd                	li	a5,-1
    80001b86:	17fe                	slli	a5,a5,0x3f
    80001b88:	07a5                	addi	a5,a5,9
    80001b8a:	00f70c63          	beq	a4,a5,80001ba2 <devintr+0x2a>
    if(irq)
      plic_complete(irq);
    // Increment interrupt count for external interrupts
    interrupt_count++;
    return 1;
  } else if(scause == 0x8000000000000005L){
    80001b8e:	57fd                	li	a5,-1
    80001b90:	17fe                	slli	a5,a5,0x3f
    80001b92:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001b94:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001b96:	04f70b63          	beq	a4,a5,80001bec <devintr+0x74>
  }
}
    80001b9a:	60e2                	ld	ra,24(sp)
    80001b9c:	6442                	ld	s0,16(sp)
    80001b9e:	6105                	addi	sp,sp,32
    80001ba0:	8082                	ret
    80001ba2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001ba4:	749020ef          	jal	80004aec <plic_claim>
    80001ba8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001baa:	47a9                	li	a5,10
    80001bac:	02f50a63          	beq	a0,a5,80001be0 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001bb0:	4785                	li	a5,1
    80001bb2:	02f50a63          	beq	a0,a5,80001be6 <devintr+0x6e>
    } else if(irq){
    80001bb6:	c919                	beqz	a0,80001bcc <devintr+0x54>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bb8:	85aa                	mv	a1,a0
    80001bba:	00005517          	auipc	a0,0x5
    80001bbe:	6e650513          	addi	a0,a0,1766 # 800072a0 <etext+0x2a0>
    80001bc2:	17d030ef          	jal	8000553e <printf>
      plic_complete(irq);
    80001bc6:	8526                	mv	a0,s1
    80001bc8:	745020ef          	jal	80004b0c <plic_complete>
    interrupt_count++;
    80001bcc:	00009717          	auipc	a4,0x9
    80001bd0:	83470713          	addi	a4,a4,-1996 # 8000a400 <interrupt_count>
    80001bd4:	631c                	ld	a5,0(a4)
    80001bd6:	0785                	addi	a5,a5,1
    80001bd8:	e31c                	sd	a5,0(a4)
    return 1;
    80001bda:	4505                	li	a0,1
    80001bdc:	64a2                	ld	s1,8(sp)
    80001bde:	bf75                	j	80001b9a <devintr+0x22>
      uartintr();
    80001be0:	6a3030ef          	jal	80005a82 <uartintr>
    if(irq)
    80001be4:	b7cd                	j	80001bc6 <devintr+0x4e>
      virtio_disk_intr();
    80001be6:	3cc030ef          	jal	80004fb2 <virtio_disk_intr>
    if(irq)
    80001bea:	bff1                	j	80001bc6 <devintr+0x4e>
    clockintr();
    80001bec:	f39ff0ef          	jal	80001b24 <clockintr>
    return 2;
    80001bf0:	4509                	li	a0,2
    80001bf2:	b765                	j	80001b9a <devintr+0x22>

0000000080001bf4 <usertrap>:
{
    80001bf4:	1101                	addi	sp,sp,-32
    80001bf6:	ec06                	sd	ra,24(sp)
    80001bf8:	e822                	sd	s0,16(sp)
    80001bfa:	e426                	sd	s1,8(sp)
    80001bfc:	e04a                	sd	s2,0(sp)
    80001bfe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c00:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c04:	1007f793          	andi	a5,a5,256
    80001c08:	ef85                	bnez	a5,80001c40 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c0a:	00003797          	auipc	a5,0x3
    80001c0e:	e3678793          	addi	a5,a5,-458 # 80004a40 <kernelvec>
    80001c12:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c16:	b04ff0ef          	jal	80000f1a <myproc>
    80001c1a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c1c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c1e:	14102773          	csrr	a4,sepc
    80001c22:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c24:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c28:	47a1                	li	a5,8
    80001c2a:	02f70163          	beq	a4,a5,80001c4c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001c2e:	f4bff0ef          	jal	80001b78 <devintr>
    80001c32:	892a                	mv	s2,a0
    80001c34:	c135                	beqz	a0,80001c98 <usertrap+0xa4>
  if(killed(p))
    80001c36:	8526                	mv	a0,s1
    80001c38:	b39ff0ef          	jal	80001770 <killed>
    80001c3c:	cd1d                	beqz	a0,80001c7a <usertrap+0x86>
    80001c3e:	a81d                	j	80001c74 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001c40:	00005517          	auipc	a0,0x5
    80001c44:	68050513          	addi	a0,a0,1664 # 800072c0 <etext+0x2c0>
    80001c48:	3c9030ef          	jal	80005810 <panic>
    if(killed(p))
    80001c4c:	b25ff0ef          	jal	80001770 <killed>
    80001c50:	e121                	bnez	a0,80001c90 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001c52:	70b8                	ld	a4,96(s1)
    80001c54:	6f1c                	ld	a5,24(a4)
    80001c56:	0791                	addi	a5,a5,4
    80001c58:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c5a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c62:	10079073          	csrw	sstatus,a5
    syscall();
    80001c66:	248000ef          	jal	80001eae <syscall>
  if(killed(p))
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	b05ff0ef          	jal	80001770 <killed>
    80001c70:	c901                	beqz	a0,80001c80 <usertrap+0x8c>
    80001c72:	4901                	li	s2,0
    exit(-1);
    80001c74:	557d                	li	a0,-1
    80001c76:	9bbff0ef          	jal	80001630 <exit>
  if(which_dev == 2)
    80001c7a:	4789                	li	a5,2
    80001c7c:	04f90563          	beq	s2,a5,80001cc6 <usertrap+0xd2>
  usertrapret();
    80001c80:	e13ff0ef          	jal	80001a92 <usertrapret>
}
    80001c84:	60e2                	ld	ra,24(sp)
    80001c86:	6442                	ld	s0,16(sp)
    80001c88:	64a2                	ld	s1,8(sp)
    80001c8a:	6902                	ld	s2,0(sp)
    80001c8c:	6105                	addi	sp,sp,32
    80001c8e:	8082                	ret
      exit(-1);
    80001c90:	557d                	li	a0,-1
    80001c92:	99fff0ef          	jal	80001630 <exit>
    80001c96:	bf75                	j	80001c52 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c98:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001c9c:	5c90                	lw	a2,56(s1)
    80001c9e:	00005517          	auipc	a0,0x5
    80001ca2:	64250513          	addi	a0,a0,1602 # 800072e0 <etext+0x2e0>
    80001ca6:	099030ef          	jal	8000553e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001caa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cae:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001cb2:	00005517          	auipc	a0,0x5
    80001cb6:	65e50513          	addi	a0,a0,1630 # 80007310 <etext+0x310>
    80001cba:	085030ef          	jal	8000553e <printf>
    setkilled(p);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	a83ff0ef          	jal	80001742 <setkilled>
    80001cc4:	b75d                	j	80001c6a <usertrap+0x76>
    yield();
    80001cc6:	817ff0ef          	jal	800014dc <yield>
    80001cca:	bf5d                	j	80001c80 <usertrap+0x8c>

0000000080001ccc <kerneltrap>:
{
    80001ccc:	7179                	addi	sp,sp,-48
    80001cce:	f406                	sd	ra,40(sp)
    80001cd0:	f022                	sd	s0,32(sp)
    80001cd2:	ec26                	sd	s1,24(sp)
    80001cd4:	e84a                	sd	s2,16(sp)
    80001cd6:	e44e                	sd	s3,8(sp)
    80001cd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ce6:	1004f793          	andi	a5,s1,256
    80001cea:	c795                	beqz	a5,80001d16 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001cf0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001cf2:	eb85                	bnez	a5,80001d22 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001cf4:	e85ff0ef          	jal	80001b78 <devintr>
    80001cf8:	c91d                	beqz	a0,80001d2e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001cfa:	4789                	li	a5,2
    80001cfc:	04f50a63          	beq	a0,a5,80001d50 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d00:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d04:	10049073          	csrw	sstatus,s1
}
    80001d08:	70a2                	ld	ra,40(sp)
    80001d0a:	7402                	ld	s0,32(sp)
    80001d0c:	64e2                	ld	s1,24(sp)
    80001d0e:	6942                	ld	s2,16(sp)
    80001d10:	69a2                	ld	s3,8(sp)
    80001d12:	6145                	addi	sp,sp,48
    80001d14:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d16:	00005517          	auipc	a0,0x5
    80001d1a:	62250513          	addi	a0,a0,1570 # 80007338 <etext+0x338>
    80001d1e:	2f3030ef          	jal	80005810 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d22:	00005517          	auipc	a0,0x5
    80001d26:	63e50513          	addi	a0,a0,1598 # 80007360 <etext+0x360>
    80001d2a:	2e7030ef          	jal	80005810 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d32:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001d36:	85ce                	mv	a1,s3
    80001d38:	00005517          	auipc	a0,0x5
    80001d3c:	64850513          	addi	a0,a0,1608 # 80007380 <etext+0x380>
    80001d40:	7fe030ef          	jal	8000553e <printf>
    panic("kerneltrap");
    80001d44:	00005517          	auipc	a0,0x5
    80001d48:	66450513          	addi	a0,a0,1636 # 800073a8 <etext+0x3a8>
    80001d4c:	2c5030ef          	jal	80005810 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001d50:	9caff0ef          	jal	80000f1a <myproc>
    80001d54:	d555                	beqz	a0,80001d00 <kerneltrap+0x34>
    yield();
    80001d56:	f86ff0ef          	jal	800014dc <yield>
    80001d5a:	b75d                	j	80001d00 <kerneltrap+0x34>

0000000080001d5c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001d5c:	1101                	addi	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	e426                	sd	s1,8(sp)
    80001d64:	1000                	addi	s0,sp,32
    80001d66:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d68:	9b2ff0ef          	jal	80000f1a <myproc>
  switch (n) {
    80001d6c:	4795                	li	a5,5
    80001d6e:	0497e163          	bltu	a5,s1,80001db0 <argraw+0x54>
    80001d72:	048a                	slli	s1,s1,0x2
    80001d74:	00006717          	auipc	a4,0x6
    80001d78:	a3c70713          	addi	a4,a4,-1476 # 800077b0 <states.0+0x30>
    80001d7c:	94ba                	add	s1,s1,a4
    80001d7e:	409c                	lw	a5,0(s1)
    80001d80:	97ba                	add	a5,a5,a4
    80001d82:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001d84:	713c                	ld	a5,96(a0)
    80001d86:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001d88:	60e2                	ld	ra,24(sp)
    80001d8a:	6442                	ld	s0,16(sp)
    80001d8c:	64a2                	ld	s1,8(sp)
    80001d8e:	6105                	addi	sp,sp,32
    80001d90:	8082                	ret
    return p->trapframe->a1;
    80001d92:	713c                	ld	a5,96(a0)
    80001d94:	7fa8                	ld	a0,120(a5)
    80001d96:	bfcd                	j	80001d88 <argraw+0x2c>
    return p->trapframe->a2;
    80001d98:	713c                	ld	a5,96(a0)
    80001d9a:	63c8                	ld	a0,128(a5)
    80001d9c:	b7f5                	j	80001d88 <argraw+0x2c>
    return p->trapframe->a3;
    80001d9e:	713c                	ld	a5,96(a0)
    80001da0:	67c8                	ld	a0,136(a5)
    80001da2:	b7dd                	j	80001d88 <argraw+0x2c>
    return p->trapframe->a4;
    80001da4:	713c                	ld	a5,96(a0)
    80001da6:	6bc8                	ld	a0,144(a5)
    80001da8:	b7c5                	j	80001d88 <argraw+0x2c>
    return p->trapframe->a5;
    80001daa:	713c                	ld	a5,96(a0)
    80001dac:	6fc8                	ld	a0,152(a5)
    80001dae:	bfe9                	j	80001d88 <argraw+0x2c>
  panic("argraw");
    80001db0:	00005517          	auipc	a0,0x5
    80001db4:	60850513          	addi	a0,a0,1544 # 800073b8 <etext+0x3b8>
    80001db8:	259030ef          	jal	80005810 <panic>

0000000080001dbc <fetchaddr>:
{
    80001dbc:	1101                	addi	sp,sp,-32
    80001dbe:	ec06                	sd	ra,24(sp)
    80001dc0:	e822                	sd	s0,16(sp)
    80001dc2:	e426                	sd	s1,8(sp)
    80001dc4:	e04a                	sd	s2,0(sp)
    80001dc6:	1000                	addi	s0,sp,32
    80001dc8:	84aa                	mv	s1,a0
    80001dca:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001dcc:	94eff0ef          	jal	80000f1a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001dd0:	693c                	ld	a5,80(a0)
    80001dd2:	02f4f663          	bgeu	s1,a5,80001dfe <fetchaddr+0x42>
    80001dd6:	00848713          	addi	a4,s1,8
    80001dda:	02e7e463          	bltu	a5,a4,80001e02 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001dde:	46a1                	li	a3,8
    80001de0:	8626                	mv	a2,s1
    80001de2:	85ca                	mv	a1,s2
    80001de4:	6d28                	ld	a0,88(a0)
    80001de6:	cf9fe0ef          	jal	80000ade <copyin>
    80001dea:	00a03533          	snez	a0,a0
    80001dee:	40a00533          	neg	a0,a0
}
    80001df2:	60e2                	ld	ra,24(sp)
    80001df4:	6442                	ld	s0,16(sp)
    80001df6:	64a2                	ld	s1,8(sp)
    80001df8:	6902                	ld	s2,0(sp)
    80001dfa:	6105                	addi	sp,sp,32
    80001dfc:	8082                	ret
    return -1;
    80001dfe:	557d                	li	a0,-1
    80001e00:	bfcd                	j	80001df2 <fetchaddr+0x36>
    80001e02:	557d                	li	a0,-1
    80001e04:	b7fd                	j	80001df2 <fetchaddr+0x36>

0000000080001e06 <fetchstr>:
{
    80001e06:	7179                	addi	sp,sp,-48
    80001e08:	f406                	sd	ra,40(sp)
    80001e0a:	f022                	sd	s0,32(sp)
    80001e0c:	ec26                	sd	s1,24(sp)
    80001e0e:	e84a                	sd	s2,16(sp)
    80001e10:	e44e                	sd	s3,8(sp)
    80001e12:	1800                	addi	s0,sp,48
    80001e14:	892a                	mv	s2,a0
    80001e16:	84ae                	mv	s1,a1
    80001e18:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001e1a:	900ff0ef          	jal	80000f1a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001e1e:	86ce                	mv	a3,s3
    80001e20:	864a                	mv	a2,s2
    80001e22:	85a6                	mv	a1,s1
    80001e24:	6d28                	ld	a0,88(a0)
    80001e26:	d3ffe0ef          	jal	80000b64 <copyinstr>
    80001e2a:	00054c63          	bltz	a0,80001e42 <fetchstr+0x3c>
  return strlen(buf);
    80001e2e:	8526                	mv	a0,s1
    80001e30:	cb4fe0ef          	jal	800002e4 <strlen>
}
    80001e34:	70a2                	ld	ra,40(sp)
    80001e36:	7402                	ld	s0,32(sp)
    80001e38:	64e2                	ld	s1,24(sp)
    80001e3a:	6942                	ld	s2,16(sp)
    80001e3c:	69a2                	ld	s3,8(sp)
    80001e3e:	6145                	addi	sp,sp,48
    80001e40:	8082                	ret
    return -1;
    80001e42:	557d                	li	a0,-1
    80001e44:	bfc5                	j	80001e34 <fetchstr+0x2e>

0000000080001e46 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001e46:	1101                	addi	sp,sp,-32
    80001e48:	ec06                	sd	ra,24(sp)
    80001e4a:	e822                	sd	s0,16(sp)
    80001e4c:	e426                	sd	s1,8(sp)
    80001e4e:	1000                	addi	s0,sp,32
    80001e50:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e52:	f0bff0ef          	jal	80001d5c <argraw>
    80001e56:	c088                	sw	a0,0(s1)
}
    80001e58:	60e2                	ld	ra,24(sp)
    80001e5a:	6442                	ld	s0,16(sp)
    80001e5c:	64a2                	ld	s1,8(sp)
    80001e5e:	6105                	addi	sp,sp,32
    80001e60:	8082                	ret

0000000080001e62 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001e62:	1101                	addi	sp,sp,-32
    80001e64:	ec06                	sd	ra,24(sp)
    80001e66:	e822                	sd	s0,16(sp)
    80001e68:	e426                	sd	s1,8(sp)
    80001e6a:	1000                	addi	s0,sp,32
    80001e6c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001e6e:	eefff0ef          	jal	80001d5c <argraw>
    80001e72:	e088                	sd	a0,0(s1)
}
    80001e74:	60e2                	ld	ra,24(sp)
    80001e76:	6442                	ld	s0,16(sp)
    80001e78:	64a2                	ld	s1,8(sp)
    80001e7a:	6105                	addi	sp,sp,32
    80001e7c:	8082                	ret

0000000080001e7e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001e7e:	7179                	addi	sp,sp,-48
    80001e80:	f406                	sd	ra,40(sp)
    80001e82:	f022                	sd	s0,32(sp)
    80001e84:	ec26                	sd	s1,24(sp)
    80001e86:	e84a                	sd	s2,16(sp)
    80001e88:	1800                	addi	s0,sp,48
    80001e8a:	84ae                	mv	s1,a1
    80001e8c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001e8e:	fd840593          	addi	a1,s0,-40
    80001e92:	fd1ff0ef          	jal	80001e62 <argaddr>
  return fetchstr(addr, buf, max);
    80001e96:	864a                	mv	a2,s2
    80001e98:	85a6                	mv	a1,s1
    80001e9a:	fd843503          	ld	a0,-40(s0)
    80001e9e:	f69ff0ef          	jal	80001e06 <fetchstr>
}
    80001ea2:	70a2                	ld	ra,40(sp)
    80001ea4:	7402                	ld	s0,32(sp)
    80001ea6:	64e2                	ld	s1,24(sp)
    80001ea8:	6942                	ld	s2,16(sp)
    80001eaa:	6145                	addi	sp,sp,48
    80001eac:	8082                	ret

0000000080001eae <syscall>:
[SYS_getdiskstats] sys_getdiskstats,
};

void
syscall(void)
{
    80001eae:	1101                	addi	sp,sp,-32
    80001eb0:	ec06                	sd	ra,24(sp)
    80001eb2:	e822                	sd	s0,16(sp)
    80001eb4:	e426                	sd	s1,8(sp)
    80001eb6:	e04a                	sd	s2,0(sp)
    80001eb8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001eba:	860ff0ef          	jal	80000f1a <myproc>
    80001ebe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ec0:	06053903          	ld	s2,96(a0)
    80001ec4:	0a893783          	ld	a5,168(s2)
    80001ec8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ecc:	37fd                	addiw	a5,a5,-1
    80001ece:	4765                	li	a4,25
    80001ed0:	00f76f63          	bltu	a4,a5,80001eee <syscall+0x40>
    80001ed4:	00369713          	slli	a4,a3,0x3
    80001ed8:	00006797          	auipc	a5,0x6
    80001edc:	8f078793          	addi	a5,a5,-1808 # 800077c8 <syscalls>
    80001ee0:	97ba                	add	a5,a5,a4
    80001ee2:	639c                	ld	a5,0(a5)
    80001ee4:	c789                	beqz	a5,80001eee <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001ee6:	9782                	jalr	a5
    80001ee8:	06a93823          	sd	a0,112(s2)
    80001eec:	a829                	j	80001f06 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001eee:	16048613          	addi	a2,s1,352
    80001ef2:	5c8c                	lw	a1,56(s1)
    80001ef4:	00005517          	auipc	a0,0x5
    80001ef8:	4cc50513          	addi	a0,a0,1228 # 800073c0 <etext+0x3c0>
    80001efc:	642030ef          	jal	8000553e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001f00:	70bc                	ld	a5,96(s1)
    80001f02:	577d                	li	a4,-1
    80001f04:	fbb8                	sd	a4,112(a5)
  }
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6902                	ld	s2,0(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret

0000000080001f12 <sys_getdiskstats>:
#include "sysinfo.h" // project
#include "virtio.h"
//project

uint64 
sys_getdiskstats(void) {
    80001f12:	7139                	addi	sp,sp,-64
    80001f14:	fc06                	sd	ra,56(sp)
    80001f16:	f822                	sd	s0,48(sp)
    80001f18:	0080                	addi	s0,sp,64
    struct diskstats stats;

    // Copy current disk stats under lock if needed
    stats = disk_stats; // If disk_stats is updated atomically or under lock
    80001f1a:	0001f797          	auipc	a5,0x1f
    80001f1e:	54e78793          	addi	a5,a5,1358 # 80021468 <disk_stats>
    80001f22:	6390                	ld	a2,0(a5)
    80001f24:	6794                	ld	a3,8(a5)
    80001f26:	6b98                	ld	a4,16(a5)
    80001f28:	6f9c                	ld	a5,24(a5)
    80001f2a:	fcc43823          	sd	a2,-48(s0)
    80001f2e:	fcd43c23          	sd	a3,-40(s0)
    80001f32:	fee43023          	sd	a4,-32(s0)
    80001f36:	fef43423          	sd	a5,-24(s0)

    // Copy to user space pointer from arg0
    struct diskstats *user_ptr;
    argaddr(0, (uint64*)&user_ptr);
    80001f3a:	fc840593          	addi	a1,s0,-56
    80001f3e:	4501                	li	a0,0
    80001f40:	f23ff0ef          	jal	80001e62 <argaddr>

    if (copyout(myproc()->pagetable, (uint64)user_ptr, (char *)&stats, sizeof(stats)) < 0)
    80001f44:	fd7fe0ef          	jal	80000f1a <myproc>
    80001f48:	02000693          	li	a3,32
    80001f4c:	fd040613          	addi	a2,s0,-48
    80001f50:	fc843583          	ld	a1,-56(s0)
    80001f54:	6d28                	ld	a0,88(a0)
    80001f56:	ab1fe0ef          	jal	80000a06 <copyout>
        return -1;

    return 0;
}
    80001f5a:	957d                	srai	a0,a0,0x3f
    80001f5c:	70e2                	ld	ra,56(sp)
    80001f5e:	7442                	ld	s0,48(sp)
    80001f60:	6121                	addi	sp,sp,64
    80001f62:	8082                	ret

0000000080001f64 <sys_getprocinfo>:

uint64
sys_getprocinfo(void)
{
    80001f64:	7139                	addi	sp,sp,-64
    80001f66:	fc06                	sd	ra,56(sp)
    80001f68:	f822                	sd	s0,48(sp)
    80001f6a:	0080                	addi	s0,sp,64
  int pid;
  struct procinfo info;
  uint64 user_addr;  // user pointer to struct procinfo

  // get the pid argument
  argint(0, &pid);
    80001f6c:	fec40593          	addi	a1,s0,-20
    80001f70:	4501                	li	a0,0
    80001f72:	ed5ff0ef          	jal	80001e46 <argint>

  // get the user-space pointer argument (second argument)
  argaddr(1, &user_addr);
    80001f76:	fc040593          	addi	a1,s0,-64
    80001f7a:	4505                	li	a0,1
    80001f7c:	ee7ff0ef          	jal	80001e62 <argaddr>
    

  // fill info struct in kernel space
  if (getprocinfo(pid, &info) < 0)
    80001f80:	fc840593          	addi	a1,s0,-56
    80001f84:	fec42503          	lw	a0,-20(s0)
    80001f88:	c95fe0ef          	jal	80000c1c <getprocinfo>
    return -1;

  // copy info from kernel space to user space at user_addr
  if (copyout(myproc()->pagetable, user_addr, (char*)&info, sizeof(info)) < 0)
    80001f8c:	f8ffe0ef          	jal	80000f1a <myproc>
    80001f90:	02000693          	li	a3,32
    80001f94:	fc840613          	addi	a2,s0,-56
    80001f98:	fc043583          	ld	a1,-64(s0)
    80001f9c:	6d28                	ld	a0,88(a0)
    80001f9e:	a69fe0ef          	jal	80000a06 <copyout>
    return -1;

  return 0;
}
    80001fa2:	957d                	srai	a0,a0,0x3f
    80001fa4:	70e2                	ld	ra,56(sp)
    80001fa6:	7442                	ld	s0,48(sp)
    80001fa8:	6121                	addi	sp,sp,64
    80001faa:	8082                	ret

0000000080001fac <sys_getinterruptcount>:

uint64
sys_getinterruptcount(void)
{
    80001fac:	1141                	addi	sp,sp,-16
    80001fae:	e406                	sd	ra,8(sp)
    80001fb0:	e022                	sd	s0,0(sp)
    80001fb2:	0800                	addi	s0,sp,16
  return get_interrupt_count();
    80001fb4:	a8fff0ef          	jal	80001a42 <get_interrupt_count>
}
    80001fb8:	60a2                	ld	ra,8(sp)
    80001fba:	6402                	ld	s0,0(sp)
    80001fbc:	0141                	addi	sp,sp,16
    80001fbe:	8082                	ret

0000000080001fc0 <sys_top>:

uint64
sys_top(void)
{
    80001fc0:	9d010113          	addi	sp,sp,-1584
    80001fc4:	62113423          	sd	ra,1576(sp)
    80001fc8:	62813023          	sd	s0,1568(sp)
    80001fcc:	61213823          	sd	s2,1552(sp)
    80001fd0:	63010413          	addi	s0,sp,1584
  uint64 addr;
  int n;

  argaddr(0, &addr);   // Gets the user-space address to copy data to
    80001fd4:	fd840593          	addi	a1,s0,-40
    80001fd8:	4501                	li	a0,0
    80001fda:	e89ff0ef          	jal	80001e62 <argaddr>
  argint(1, &n);       // Gets the number of top processes requested
    80001fde:	fd440593          	addi	a1,s0,-44
    80001fe2:	4505                	li	a0,1
    80001fe4:	e63ff0ef          	jal	80001e46 <argint>

  if (n <= 0 || n > NPROC)
    80001fe8:	fd442583          	lw	a1,-44(s0)
    80001fec:	fff5871b          	addiw	a4,a1,-1 # fff <_entry-0x7ffff001>
    80001ff0:	03f00793          	li	a5,63
    return -1;
    80001ff4:	597d                	li	s2,-1
  if (n <= 0 || n > NPROC)
    80001ff6:	02e7eb63          	bltu	a5,a4,8000202c <sys_top+0x6c>
    80001ffa:	60913c23          	sd	s1,1560(sp)
  struct top_proc tops[NPROC];  // struct top_proc tops[n];  

  int actual = gettop(tops, n);
    80001ffe:	9d040513          	addi	a0,s0,-1584
    80002002:	c81fe0ef          	jal	80000c82 <gettop>
    80002006:	84aa                	mv	s1,a0

  if (copyout(myproc()->pagetable, addr,(char *)tops, actual * sizeof(struct top_proc)) < 0)
    80002008:	f13fe0ef          	jal	80000f1a <myproc>
    8000200c:	8926                	mv	s2,s1
    8000200e:	00149693          	slli	a3,s1,0x1
    80002012:	96a6                	add	a3,a3,s1
    80002014:	068e                	slli	a3,a3,0x3
    80002016:	9d040613          	addi	a2,s0,-1584
    8000201a:	fd843583          	ld	a1,-40(s0)
    8000201e:	6d28                	ld	a0,88(a0)
    80002020:	9e7fe0ef          	jal	80000a06 <copyout>
    80002024:	00054e63          	bltz	a0,80002040 <sys_top+0x80>
    80002028:	61813483          	ld	s1,1560(sp)
    return -1;

  return actual;
}
    8000202c:	854a                	mv	a0,s2
    8000202e:	62813083          	ld	ra,1576(sp)
    80002032:	62013403          	ld	s0,1568(sp)
    80002036:	61013903          	ld	s2,1552(sp)
    8000203a:	63010113          	addi	sp,sp,1584
    8000203e:	8082                	ret
    return -1;
    80002040:	597d                	li	s2,-1
    80002042:	61813483          	ld	s1,1560(sp)
    80002046:	b7dd                	j	8000202c <sys_top+0x6c>

0000000080002048 <sys_exit>:



uint64
sys_exit(void)
{
    80002048:	1101                	addi	sp,sp,-32
    8000204a:	ec06                	sd	ra,24(sp)
    8000204c:	e822                	sd	s0,16(sp)
    8000204e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002050:	fec40593          	addi	a1,s0,-20
    80002054:	4501                	li	a0,0
    80002056:	df1ff0ef          	jal	80001e46 <argint>
  exit(n);
    8000205a:	fec42503          	lw	a0,-20(s0)
    8000205e:	dd2ff0ef          	jal	80001630 <exit>
  return 0;  // not reached
}
    80002062:	4501                	li	a0,0
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000206c:	1141                	addi	sp,sp,-16
    8000206e:	e406                	sd	ra,8(sp)
    80002070:	e022                	sd	s0,0(sp)
    80002072:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002074:	ea7fe0ef          	jal	80000f1a <myproc>
}
    80002078:	5d08                	lw	a0,56(a0)
    8000207a:	60a2                	ld	ra,8(sp)
    8000207c:	6402                	ld	s0,0(sp)
    8000207e:	0141                	addi	sp,sp,16
    80002080:	8082                	ret

0000000080002082 <sys_fork>:

uint64
sys_fork(void)
{
    80002082:	1141                	addi	sp,sp,-16
    80002084:	e406                	sd	ra,8(sp)
    80002086:	e022                	sd	s0,0(sp)
    80002088:	0800                	addi	s0,sp,16
  return fork();
    8000208a:	9c2ff0ef          	jal	8000124c <fork>
}
    8000208e:	60a2                	ld	ra,8(sp)
    80002090:	6402                	ld	s0,0(sp)
    80002092:	0141                	addi	sp,sp,16
    80002094:	8082                	ret

0000000080002096 <sys_wait>:

uint64
sys_wait(void)
{
    80002096:	1101                	addi	sp,sp,-32
    80002098:	ec06                	sd	ra,24(sp)
    8000209a:	e822                	sd	s0,16(sp)
    8000209c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000209e:	fe840593          	addi	a1,s0,-24
    800020a2:	4501                	li	a0,0
    800020a4:	dbfff0ef          	jal	80001e62 <argaddr>
  return wait(p);
    800020a8:	fe843503          	ld	a0,-24(s0)
    800020ac:	ef2ff0ef          	jal	8000179e <wait>
}
    800020b0:	60e2                	ld	ra,24(sp)
    800020b2:	6442                	ld	s0,16(sp)
    800020b4:	6105                	addi	sp,sp,32
    800020b6:	8082                	ret

00000000800020b8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020b8:	7179                	addi	sp,sp,-48
    800020ba:	f406                	sd	ra,40(sp)
    800020bc:	f022                	sd	s0,32(sp)
    800020be:	ec26                	sd	s1,24(sp)
    800020c0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020c2:	fdc40593          	addi	a1,s0,-36
    800020c6:	4501                	li	a0,0
    800020c8:	d7fff0ef          	jal	80001e46 <argint>
  addr = myproc()->sz;
    800020cc:	e4ffe0ef          	jal	80000f1a <myproc>
    800020d0:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    800020d2:	fdc42503          	lw	a0,-36(s0)
    800020d6:	926ff0ef          	jal	800011fc <growproc>
    800020da:	00054863          	bltz	a0,800020ea <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800020de:	8526                	mv	a0,s1
    800020e0:	70a2                	ld	ra,40(sp)
    800020e2:	7402                	ld	s0,32(sp)
    800020e4:	64e2                	ld	s1,24(sp)
    800020e6:	6145                	addi	sp,sp,48
    800020e8:	8082                	ret
    return -1;
    800020ea:	54fd                	li	s1,-1
    800020ec:	bfcd                	j	800020de <sys_sbrk+0x26>

00000000800020ee <sys_sleep>:

uint64
sys_sleep(void)
{
    800020ee:	7139                	addi	sp,sp,-64
    800020f0:	fc06                	sd	ra,56(sp)
    800020f2:	f822                	sd	s0,48(sp)
    800020f4:	f04a                	sd	s2,32(sp)
    800020f6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800020f8:	fcc40593          	addi	a1,s0,-52
    800020fc:	4501                	li	a0,0
    800020fe:	d49ff0ef          	jal	80001e46 <argint>
  if(n < 0)
    80002102:	fcc42783          	lw	a5,-52(s0)
    80002106:	0607c763          	bltz	a5,80002174 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000210a:	00014517          	auipc	a0,0x14
    8000210e:	f7e50513          	addi	a0,a0,-130 # 80016088 <tickslock>
    80002112:	22d030ef          	jal	80005b3e <acquire>
  ticks0 = ticks;
    80002116:	00008917          	auipc	s2,0x8
    8000211a:	2e292903          	lw	s2,738(s2) # 8000a3f8 <ticks>
  while(ticks - ticks0 < n){
    8000211e:	fcc42783          	lw	a5,-52(s0)
    80002122:	cf8d                	beqz	a5,8000215c <sys_sleep+0x6e>
    80002124:	f426                	sd	s1,40(sp)
    80002126:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002128:	00014997          	auipc	s3,0x14
    8000212c:	f6098993          	addi	s3,s3,-160 # 80016088 <tickslock>
    80002130:	00008497          	auipc	s1,0x8
    80002134:	2c848493          	addi	s1,s1,712 # 8000a3f8 <ticks>
    if(killed(myproc())){
    80002138:	de3fe0ef          	jal	80000f1a <myproc>
    8000213c:	e34ff0ef          	jal	80001770 <killed>
    80002140:	ed0d                	bnez	a0,8000217a <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002142:	85ce                	mv	a1,s3
    80002144:	8526                	mv	a0,s1
    80002146:	bccff0ef          	jal	80001512 <sleep>
  while(ticks - ticks0 < n){
    8000214a:	409c                	lw	a5,0(s1)
    8000214c:	412787bb          	subw	a5,a5,s2
    80002150:	fcc42703          	lw	a4,-52(s0)
    80002154:	fee7e2e3          	bltu	a5,a4,80002138 <sys_sleep+0x4a>
    80002158:	74a2                	ld	s1,40(sp)
    8000215a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000215c:	00014517          	auipc	a0,0x14
    80002160:	f2c50513          	addi	a0,a0,-212 # 80016088 <tickslock>
    80002164:	273030ef          	jal	80005bd6 <release>
  return 0;
    80002168:	4501                	li	a0,0
}
    8000216a:	70e2                	ld	ra,56(sp)
    8000216c:	7442                	ld	s0,48(sp)
    8000216e:	7902                	ld	s2,32(sp)
    80002170:	6121                	addi	sp,sp,64
    80002172:	8082                	ret
    n = 0;
    80002174:	fc042623          	sw	zero,-52(s0)
    80002178:	bf49                	j	8000210a <sys_sleep+0x1c>
      release(&tickslock);
    8000217a:	00014517          	auipc	a0,0x14
    8000217e:	f0e50513          	addi	a0,a0,-242 # 80016088 <tickslock>
    80002182:	255030ef          	jal	80005bd6 <release>
      return -1;
    80002186:	557d                	li	a0,-1
    80002188:	74a2                	ld	s1,40(sp)
    8000218a:	69e2                	ld	s3,24(sp)
    8000218c:	bff9                	j	8000216a <sys_sleep+0x7c>

000000008000218e <sys_kill>:

uint64
sys_kill(void)
{
    8000218e:	1101                	addi	sp,sp,-32
    80002190:	ec06                	sd	ra,24(sp)
    80002192:	e822                	sd	s0,16(sp)
    80002194:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002196:	fec40593          	addi	a1,s0,-20
    8000219a:	4501                	li	a0,0
    8000219c:	cabff0ef          	jal	80001e46 <argint>
  return kill(pid);
    800021a0:	fec42503          	lw	a0,-20(s0)
    800021a4:	d30ff0ef          	jal	800016d4 <kill>
}
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret

00000000800021b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021b0:	1101                	addi	sp,sp,-32
    800021b2:	ec06                	sd	ra,24(sp)
    800021b4:	e822                	sd	s0,16(sp)
    800021b6:	e426                	sd	s1,8(sp)
    800021b8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021ba:	00014517          	auipc	a0,0x14
    800021be:	ece50513          	addi	a0,a0,-306 # 80016088 <tickslock>
    800021c2:	17d030ef          	jal	80005b3e <acquire>
  xticks = ticks;
    800021c6:	00008497          	auipc	s1,0x8
    800021ca:	2324a483          	lw	s1,562(s1) # 8000a3f8 <ticks>
  release(&tickslock);
    800021ce:	00014517          	auipc	a0,0x14
    800021d2:	eba50513          	addi	a0,a0,-326 # 80016088 <tickslock>
    800021d6:	201030ef          	jal	80005bd6 <release>
  return xticks;
}
    800021da:	02049513          	slli	a0,s1,0x20
    800021de:	9101                	srli	a0,a0,0x20
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	64a2                	ld	s1,8(sp)
    800021e6:	6105                	addi	sp,sp,32
    800021e8:	8082                	ret

00000000800021ea <sys_getsysinfo>:
// Project
extern struct proc proc[NPROC];

uint64
sys_getsysinfo(void)
{
    800021ea:	7179                	addi	sp,sp,-48
    800021ec:	f406                	sd	ra,40(sp)
    800021ee:	f022                	sd	s0,32(sp)
    800021f0:	1800                	addi	s0,sp,48
  struct sysinfo info;
  struct proc *p;
  int nprocs = 0;
  int nrunning = 0;
    800021f2:	4581                	li	a1,0
  int nprocs = 0;
    800021f4:	4681                	li	a3,0

  for (p = proc; p < &proc[NPROC]; p++) {
    800021f6:	00008797          	auipc	a5,0x8
    800021fa:	67a78793          	addi	a5,a5,1658 # 8000a870 <proc>
    if (p->state != UNUSED)
      nprocs++;
    if (p->state == RUNNABLE)
    800021fe:	450d                	li	a0,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80002200:	0000e617          	auipc	a2,0xe
    80002204:	27060613          	addi	a2,a2,624 # 80010470 <ptable>
    80002208:	a029                	j	80002212 <sys_getsysinfo+0x28>
    8000220a:	17078793          	addi	a5,a5,368
    8000220e:	00c78963          	beq	a5,a2,80002220 <sys_getsysinfo+0x36>
    if (p->state != UNUSED)
    80002212:	5398                	lw	a4,32(a5)
    80002214:	db7d                	beqz	a4,8000220a <sys_getsysinfo+0x20>
      nprocs++;
    80002216:	2685                	addiw	a3,a3,1
    if (p->state == RUNNABLE)
    80002218:	fea719e3          	bne	a4,a0,8000220a <sys_getsysinfo+0x20>
      nrunning++;
    8000221c:	2585                	addiw	a1,a1,1
    8000221e:	b7f5                	j	8000220a <sys_getsysinfo+0x20>
  }

  info.nprocs = nprocs;
    80002220:	fed42023          	sw	a3,-32(s0)
  info.nrunning = nrunning;
    80002224:	feb42223          	sw	a1,-28(s0)
  info.freemem = (freepages()) * PGSIZE; // freepages() returns pages
    80002228:	f0dfd0ef          	jal	80000134 <freepages>
    8000222c:	00c5179b          	slliw	a5,a0,0xc
    80002230:	fef42423          	sw	a5,-24(s0)

  uint64 addr;
  argaddr(0, &addr);
    80002234:	fd840593          	addi	a1,s0,-40
    80002238:	4501                	li	a0,0
    8000223a:	c29ff0ef          	jal	80001e62 <argaddr>
  if (copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0)
    8000223e:	cddfe0ef          	jal	80000f1a <myproc>
    80002242:	46b1                	li	a3,12
    80002244:	fe040613          	addi	a2,s0,-32
    80002248:	fd843583          	ld	a1,-40(s0)
    8000224c:	6d28                	ld	a0,88(a0)
    8000224e:	fb8fe0ef          	jal	80000a06 <copyout>
    return -1;

  return 0;
}
    80002252:	957d                	srai	a0,a0,0x3f
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	6145                	addi	sp,sp,48
    8000225a:	8082                	ret

000000008000225c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000225c:	7179                	addi	sp,sp,-48
    8000225e:	f406                	sd	ra,40(sp)
    80002260:	f022                	sd	s0,32(sp)
    80002262:	ec26                	sd	s1,24(sp)
    80002264:	e84a                	sd	s2,16(sp)
    80002266:	e44e                	sd	s3,8(sp)
    80002268:	e052                	sd	s4,0(sp)
    8000226a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000226c:	00005597          	auipc	a1,0x5
    80002270:	17458593          	addi	a1,a1,372 # 800073e0 <etext+0x3e0>
    80002274:	00014517          	auipc	a0,0x14
    80002278:	e2c50513          	addi	a0,a0,-468 # 800160a0 <bcache>
    8000227c:	043030ef          	jal	80005abe <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002280:	0001c797          	auipc	a5,0x1c
    80002284:	e2078793          	addi	a5,a5,-480 # 8001e0a0 <bcache+0x8000>
    80002288:	0001c717          	auipc	a4,0x1c
    8000228c:	08070713          	addi	a4,a4,128 # 8001e308 <bcache+0x8268>
    80002290:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002294:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002298:	00014497          	auipc	s1,0x14
    8000229c:	e2048493          	addi	s1,s1,-480 # 800160b8 <bcache+0x18>
    b->next = bcache.head.next;
    800022a0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022a2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022a4:	00005a17          	auipc	s4,0x5
    800022a8:	144a0a13          	addi	s4,s4,324 # 800073e8 <etext+0x3e8>
    b->next = bcache.head.next;
    800022ac:	2b893783          	ld	a5,696(s2)
    800022b0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022b2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022b6:	85d2                	mv	a1,s4
    800022b8:	01048513          	addi	a0,s1,16
    800022bc:	248010ef          	jal	80003504 <initsleeplock>
    bcache.head.next->prev = b;
    800022c0:	2b893783          	ld	a5,696(s2)
    800022c4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022c6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ca:	45848493          	addi	s1,s1,1112
    800022ce:	fd349fe3          	bne	s1,s3,800022ac <binit+0x50>
  }
}
    800022d2:	70a2                	ld	ra,40(sp)
    800022d4:	7402                	ld	s0,32(sp)
    800022d6:	64e2                	ld	s1,24(sp)
    800022d8:	6942                	ld	s2,16(sp)
    800022da:	69a2                	ld	s3,8(sp)
    800022dc:	6a02                	ld	s4,0(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret

00000000800022e2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022e2:	7179                	addi	sp,sp,-48
    800022e4:	f406                	sd	ra,40(sp)
    800022e6:	f022                	sd	s0,32(sp)
    800022e8:	ec26                	sd	s1,24(sp)
    800022ea:	e84a                	sd	s2,16(sp)
    800022ec:	e44e                	sd	s3,8(sp)
    800022ee:	1800                	addi	s0,sp,48
    800022f0:	892a                	mv	s2,a0
    800022f2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022f4:	00014517          	auipc	a0,0x14
    800022f8:	dac50513          	addi	a0,a0,-596 # 800160a0 <bcache>
    800022fc:	043030ef          	jal	80005b3e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002300:	0001c497          	auipc	s1,0x1c
    80002304:	0584b483          	ld	s1,88(s1) # 8001e358 <bcache+0x82b8>
    80002308:	0001c797          	auipc	a5,0x1c
    8000230c:	00078793          	mv	a5,a5
    80002310:	02f48b63          	beq	s1,a5,80002346 <bread+0x64>
    80002314:	873e                	mv	a4,a5
    80002316:	a021                	j	8000231e <bread+0x3c>
    80002318:	68a4                	ld	s1,80(s1)
    8000231a:	02e48663          	beq	s1,a4,80002346 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000231e:	449c                	lw	a5,8(s1)
    80002320:	ff279ce3          	bne	a5,s2,80002318 <bread+0x36>
    80002324:	44dc                	lw	a5,12(s1)
    80002326:	ff3799e3          	bne	a5,s3,80002318 <bread+0x36>
      b->refcnt++;
    8000232a:	40bc                	lw	a5,64(s1)
    8000232c:	2785                	addiw	a5,a5,1 # ffffffff8001e309 <end+0xfffffffeffff4d79>
    8000232e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002330:	00014517          	auipc	a0,0x14
    80002334:	d7050513          	addi	a0,a0,-656 # 800160a0 <bcache>
    80002338:	09f030ef          	jal	80005bd6 <release>
      acquiresleep(&b->lock);
    8000233c:	01048513          	addi	a0,s1,16
    80002340:	1fa010ef          	jal	8000353a <acquiresleep>
      return b;
    80002344:	a889                	j	80002396 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002346:	0001c497          	auipc	s1,0x1c
    8000234a:	00a4b483          	ld	s1,10(s1) # 8001e350 <bcache+0x82b0>
    8000234e:	0001c797          	auipc	a5,0x1c
    80002352:	fba78793          	addi	a5,a5,-70 # 8001e308 <bcache+0x8268>
    80002356:	00f48863          	beq	s1,a5,80002366 <bread+0x84>
    8000235a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000235c:	40bc                	lw	a5,64(s1)
    8000235e:	cb91                	beqz	a5,80002372 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002360:	64a4                	ld	s1,72(s1)
    80002362:	fee49de3          	bne	s1,a4,8000235c <bread+0x7a>
  panic("bget: no buffers");
    80002366:	00005517          	auipc	a0,0x5
    8000236a:	08a50513          	addi	a0,a0,138 # 800073f0 <etext+0x3f0>
    8000236e:	4a2030ef          	jal	80005810 <panic>
      b->dev = dev;
    80002372:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002376:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000237a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000237e:	4785                	li	a5,1
    80002380:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002382:	00014517          	auipc	a0,0x14
    80002386:	d1e50513          	addi	a0,a0,-738 # 800160a0 <bcache>
    8000238a:	04d030ef          	jal	80005bd6 <release>
      acquiresleep(&b->lock);
    8000238e:	01048513          	addi	a0,s1,16
    80002392:	1a8010ef          	jal	8000353a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002396:	409c                	lw	a5,0(s1)
    80002398:	cb89                	beqz	a5,800023aa <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000239a:	8526                	mv	a0,s1
    8000239c:	70a2                	ld	ra,40(sp)
    8000239e:	7402                	ld	s0,32(sp)
    800023a0:	64e2                	ld	s1,24(sp)
    800023a2:	6942                	ld	s2,16(sp)
    800023a4:	69a2                	ld	s3,8(sp)
    800023a6:	6145                	addi	sp,sp,48
    800023a8:	8082                	ret
    virtio_disk_rw(b, 0);
    800023aa:	4581                	li	a1,0
    800023ac:	8526                	mv	a0,s1
    800023ae:	1f3020ef          	jal	80004da0 <virtio_disk_rw>
    b->valid = 1;
    800023b2:	4785                	li	a5,1
    800023b4:	c09c                	sw	a5,0(s1)
  return b;
    800023b6:	b7d5                	j	8000239a <bread+0xb8>

00000000800023b8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023b8:	1101                	addi	sp,sp,-32
    800023ba:	ec06                	sd	ra,24(sp)
    800023bc:	e822                	sd	s0,16(sp)
    800023be:	e426                	sd	s1,8(sp)
    800023c0:	1000                	addi	s0,sp,32
    800023c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c4:	0541                	addi	a0,a0,16
    800023c6:	1f2010ef          	jal	800035b8 <holdingsleep>
    800023ca:	c911                	beqz	a0,800023de <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023cc:	4585                	li	a1,1
    800023ce:	8526                	mv	a0,s1
    800023d0:	1d1020ef          	jal	80004da0 <virtio_disk_rw>
}
    800023d4:	60e2                	ld	ra,24(sp)
    800023d6:	6442                	ld	s0,16(sp)
    800023d8:	64a2                	ld	s1,8(sp)
    800023da:	6105                	addi	sp,sp,32
    800023dc:	8082                	ret
    panic("bwrite");
    800023de:	00005517          	auipc	a0,0x5
    800023e2:	02a50513          	addi	a0,a0,42 # 80007408 <etext+0x408>
    800023e6:	42a030ef          	jal	80005810 <panic>

00000000800023ea <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023ea:	1101                	addi	sp,sp,-32
    800023ec:	ec06                	sd	ra,24(sp)
    800023ee:	e822                	sd	s0,16(sp)
    800023f0:	e426                	sd	s1,8(sp)
    800023f2:	e04a                	sd	s2,0(sp)
    800023f4:	1000                	addi	s0,sp,32
    800023f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023f8:	01050913          	addi	s2,a0,16
    800023fc:	854a                	mv	a0,s2
    800023fe:	1ba010ef          	jal	800035b8 <holdingsleep>
    80002402:	c135                	beqz	a0,80002466 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002404:	854a                	mv	a0,s2
    80002406:	17a010ef          	jal	80003580 <releasesleep>

  acquire(&bcache.lock);
    8000240a:	00014517          	auipc	a0,0x14
    8000240e:	c9650513          	addi	a0,a0,-874 # 800160a0 <bcache>
    80002412:	72c030ef          	jal	80005b3e <acquire>
  b->refcnt--;
    80002416:	40bc                	lw	a5,64(s1)
    80002418:	37fd                	addiw	a5,a5,-1
    8000241a:	0007871b          	sext.w	a4,a5
    8000241e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002420:	e71d                	bnez	a4,8000244e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002422:	68b8                	ld	a4,80(s1)
    80002424:	64bc                	ld	a5,72(s1)
    80002426:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002428:	68b8                	ld	a4,80(s1)
    8000242a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000242c:	0001c797          	auipc	a5,0x1c
    80002430:	c7478793          	addi	a5,a5,-908 # 8001e0a0 <bcache+0x8000>
    80002434:	2b87b703          	ld	a4,696(a5)
    80002438:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000243a:	0001c717          	auipc	a4,0x1c
    8000243e:	ece70713          	addi	a4,a4,-306 # 8001e308 <bcache+0x8268>
    80002442:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002444:	2b87b703          	ld	a4,696(a5)
    80002448:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000244a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000244e:	00014517          	auipc	a0,0x14
    80002452:	c5250513          	addi	a0,a0,-942 # 800160a0 <bcache>
    80002456:	780030ef          	jal	80005bd6 <release>
}
    8000245a:	60e2                	ld	ra,24(sp)
    8000245c:	6442                	ld	s0,16(sp)
    8000245e:	64a2                	ld	s1,8(sp)
    80002460:	6902                	ld	s2,0(sp)
    80002462:	6105                	addi	sp,sp,32
    80002464:	8082                	ret
    panic("brelse");
    80002466:	00005517          	auipc	a0,0x5
    8000246a:	faa50513          	addi	a0,a0,-86 # 80007410 <etext+0x410>
    8000246e:	3a2030ef          	jal	80005810 <panic>

0000000080002472 <bpin>:

void
bpin(struct buf *b) {
    80002472:	1101                	addi	sp,sp,-32
    80002474:	ec06                	sd	ra,24(sp)
    80002476:	e822                	sd	s0,16(sp)
    80002478:	e426                	sd	s1,8(sp)
    8000247a:	1000                	addi	s0,sp,32
    8000247c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000247e:	00014517          	auipc	a0,0x14
    80002482:	c2250513          	addi	a0,a0,-990 # 800160a0 <bcache>
    80002486:	6b8030ef          	jal	80005b3e <acquire>
  b->refcnt++;
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	2785                	addiw	a5,a5,1
    8000248e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002490:	00014517          	auipc	a0,0x14
    80002494:	c1050513          	addi	a0,a0,-1008 # 800160a0 <bcache>
    80002498:	73e030ef          	jal	80005bd6 <release>
}
    8000249c:	60e2                	ld	ra,24(sp)
    8000249e:	6442                	ld	s0,16(sp)
    800024a0:	64a2                	ld	s1,8(sp)
    800024a2:	6105                	addi	sp,sp,32
    800024a4:	8082                	ret

00000000800024a6 <bunpin>:

void
bunpin(struct buf *b) {
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	e426                	sd	s1,8(sp)
    800024ae:	1000                	addi	s0,sp,32
    800024b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024b2:	00014517          	auipc	a0,0x14
    800024b6:	bee50513          	addi	a0,a0,-1042 # 800160a0 <bcache>
    800024ba:	684030ef          	jal	80005b3e <acquire>
  b->refcnt--;
    800024be:	40bc                	lw	a5,64(s1)
    800024c0:	37fd                	addiw	a5,a5,-1
    800024c2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c4:	00014517          	auipc	a0,0x14
    800024c8:	bdc50513          	addi	a0,a0,-1060 # 800160a0 <bcache>
    800024cc:	70a030ef          	jal	80005bd6 <release>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	64a2                	ld	s1,8(sp)
    800024d6:	6105                	addi	sp,sp,32
    800024d8:	8082                	ret

00000000800024da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	e426                	sd	s1,8(sp)
    800024e2:	e04a                	sd	s2,0(sp)
    800024e4:	1000                	addi	s0,sp,32
    800024e6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024e8:	00d5d59b          	srliw	a1,a1,0xd
    800024ec:	0001c797          	auipc	a5,0x1c
    800024f0:	2907a783          	lw	a5,656(a5) # 8001e77c <sb+0x1c>
    800024f4:	9dbd                	addw	a1,a1,a5
    800024f6:	dedff0ef          	jal	800022e2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024fa:	0074f713          	andi	a4,s1,7
    800024fe:	4785                	li	a5,1
    80002500:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002504:	14ce                	slli	s1,s1,0x33
    80002506:	90d9                	srli	s1,s1,0x36
    80002508:	00950733          	add	a4,a0,s1
    8000250c:	05874703          	lbu	a4,88(a4)
    80002510:	00e7f6b3          	and	a3,a5,a4
    80002514:	c29d                	beqz	a3,8000253a <bfree+0x60>
    80002516:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002518:	94aa                	add	s1,s1,a0
    8000251a:	fff7c793          	not	a5,a5
    8000251e:	8f7d                	and	a4,a4,a5
    80002520:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002524:	711000ef          	jal	80003434 <log_write>
  brelse(bp);
    80002528:	854a                	mv	a0,s2
    8000252a:	ec1ff0ef          	jal	800023ea <brelse>
}
    8000252e:	60e2                	ld	ra,24(sp)
    80002530:	6442                	ld	s0,16(sp)
    80002532:	64a2                	ld	s1,8(sp)
    80002534:	6902                	ld	s2,0(sp)
    80002536:	6105                	addi	sp,sp,32
    80002538:	8082                	ret
    panic("freeing free block");
    8000253a:	00005517          	auipc	a0,0x5
    8000253e:	ede50513          	addi	a0,a0,-290 # 80007418 <etext+0x418>
    80002542:	2ce030ef          	jal	80005810 <panic>

0000000080002546 <balloc>:
{
    80002546:	711d                	addi	sp,sp,-96
    80002548:	ec86                	sd	ra,88(sp)
    8000254a:	e8a2                	sd	s0,80(sp)
    8000254c:	e4a6                	sd	s1,72(sp)
    8000254e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002550:	0001c797          	auipc	a5,0x1c
    80002554:	2147a783          	lw	a5,532(a5) # 8001e764 <sb+0x4>
    80002558:	0e078f63          	beqz	a5,80002656 <balloc+0x110>
    8000255c:	e0ca                	sd	s2,64(sp)
    8000255e:	fc4e                	sd	s3,56(sp)
    80002560:	f852                	sd	s4,48(sp)
    80002562:	f456                	sd	s5,40(sp)
    80002564:	f05a                	sd	s6,32(sp)
    80002566:	ec5e                	sd	s7,24(sp)
    80002568:	e862                	sd	s8,16(sp)
    8000256a:	e466                	sd	s9,8(sp)
    8000256c:	8baa                	mv	s7,a0
    8000256e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002570:	0001cb17          	auipc	s6,0x1c
    80002574:	1f0b0b13          	addi	s6,s6,496 # 8001e760 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002578:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000257a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000257c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000257e:	6c89                	lui	s9,0x2
    80002580:	a0b5                	j	800025ec <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002582:	97ca                	add	a5,a5,s2
    80002584:	8e55                	or	a2,a2,a3
    80002586:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000258a:	854a                	mv	a0,s2
    8000258c:	6a9000ef          	jal	80003434 <log_write>
        brelse(bp);
    80002590:	854a                	mv	a0,s2
    80002592:	e59ff0ef          	jal	800023ea <brelse>
  bp = bread(dev, bno);
    80002596:	85a6                	mv	a1,s1
    80002598:	855e                	mv	a0,s7
    8000259a:	d49ff0ef          	jal	800022e2 <bread>
    8000259e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025a0:	40000613          	li	a2,1024
    800025a4:	4581                	li	a1,0
    800025a6:	05850513          	addi	a0,a0,88
    800025aa:	bcbfd0ef          	jal	80000174 <memset>
  log_write(bp);
    800025ae:	854a                	mv	a0,s2
    800025b0:	685000ef          	jal	80003434 <log_write>
  brelse(bp);
    800025b4:	854a                	mv	a0,s2
    800025b6:	e35ff0ef          	jal	800023ea <brelse>
}
    800025ba:	6906                	ld	s2,64(sp)
    800025bc:	79e2                	ld	s3,56(sp)
    800025be:	7a42                	ld	s4,48(sp)
    800025c0:	7aa2                	ld	s5,40(sp)
    800025c2:	7b02                	ld	s6,32(sp)
    800025c4:	6be2                	ld	s7,24(sp)
    800025c6:	6c42                	ld	s8,16(sp)
    800025c8:	6ca2                	ld	s9,8(sp)
}
    800025ca:	8526                	mv	a0,s1
    800025cc:	60e6                	ld	ra,88(sp)
    800025ce:	6446                	ld	s0,80(sp)
    800025d0:	64a6                	ld	s1,72(sp)
    800025d2:	6125                	addi	sp,sp,96
    800025d4:	8082                	ret
    brelse(bp);
    800025d6:	854a                	mv	a0,s2
    800025d8:	e13ff0ef          	jal	800023ea <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025dc:	015c87bb          	addw	a5,s9,s5
    800025e0:	00078a9b          	sext.w	s5,a5
    800025e4:	004b2703          	lw	a4,4(s6)
    800025e8:	04eaff63          	bgeu	s5,a4,80002646 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800025ec:	41fad79b          	sraiw	a5,s5,0x1f
    800025f0:	0137d79b          	srliw	a5,a5,0x13
    800025f4:	015787bb          	addw	a5,a5,s5
    800025f8:	40d7d79b          	sraiw	a5,a5,0xd
    800025fc:	01cb2583          	lw	a1,28(s6)
    80002600:	9dbd                	addw	a1,a1,a5
    80002602:	855e                	mv	a0,s7
    80002604:	cdfff0ef          	jal	800022e2 <bread>
    80002608:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000260a:	004b2503          	lw	a0,4(s6)
    8000260e:	000a849b          	sext.w	s1,s5
    80002612:	8762                	mv	a4,s8
    80002614:	fca4f1e3          	bgeu	s1,a0,800025d6 <balloc+0x90>
      m = 1 << (bi % 8);
    80002618:	00777693          	andi	a3,a4,7
    8000261c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002620:	41f7579b          	sraiw	a5,a4,0x1f
    80002624:	01d7d79b          	srliw	a5,a5,0x1d
    80002628:	9fb9                	addw	a5,a5,a4
    8000262a:	4037d79b          	sraiw	a5,a5,0x3
    8000262e:	00f90633          	add	a2,s2,a5
    80002632:	05864603          	lbu	a2,88(a2)
    80002636:	00c6f5b3          	and	a1,a3,a2
    8000263a:	d5a1                	beqz	a1,80002582 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000263c:	2705                	addiw	a4,a4,1
    8000263e:	2485                	addiw	s1,s1,1
    80002640:	fd471ae3          	bne	a4,s4,80002614 <balloc+0xce>
    80002644:	bf49                	j	800025d6 <balloc+0x90>
    80002646:	6906                	ld	s2,64(sp)
    80002648:	79e2                	ld	s3,56(sp)
    8000264a:	7a42                	ld	s4,48(sp)
    8000264c:	7aa2                	ld	s5,40(sp)
    8000264e:	7b02                	ld	s6,32(sp)
    80002650:	6be2                	ld	s7,24(sp)
    80002652:	6c42                	ld	s8,16(sp)
    80002654:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002656:	00005517          	auipc	a0,0x5
    8000265a:	dda50513          	addi	a0,a0,-550 # 80007430 <etext+0x430>
    8000265e:	6e1020ef          	jal	8000553e <printf>
  return 0;
    80002662:	4481                	li	s1,0
    80002664:	b79d                	j	800025ca <balloc+0x84>

0000000080002666 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002666:	7179                	addi	sp,sp,-48
    80002668:	f406                	sd	ra,40(sp)
    8000266a:	f022                	sd	s0,32(sp)
    8000266c:	ec26                	sd	s1,24(sp)
    8000266e:	e84a                	sd	s2,16(sp)
    80002670:	e44e                	sd	s3,8(sp)
    80002672:	1800                	addi	s0,sp,48
    80002674:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002676:	47ad                	li	a5,11
    80002678:	02b7e663          	bltu	a5,a1,800026a4 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000267c:	02059793          	slli	a5,a1,0x20
    80002680:	01e7d593          	srli	a1,a5,0x1e
    80002684:	00b504b3          	add	s1,a0,a1
    80002688:	0504a903          	lw	s2,80(s1)
    8000268c:	06091a63          	bnez	s2,80002700 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002690:	4108                	lw	a0,0(a0)
    80002692:	eb5ff0ef          	jal	80002546 <balloc>
    80002696:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000269a:	06090363          	beqz	s2,80002700 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000269e:	0524a823          	sw	s2,80(s1)
    800026a2:	a8b9                	j	80002700 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800026a4:	ff45849b          	addiw	s1,a1,-12
    800026a8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026ac:	0ff00793          	li	a5,255
    800026b0:	06e7ee63          	bltu	a5,a4,8000272c <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800026b4:	08052903          	lw	s2,128(a0)
    800026b8:	00091d63          	bnez	s2,800026d2 <bmap+0x6c>
      addr = balloc(ip->dev);
    800026bc:	4108                	lw	a0,0(a0)
    800026be:	e89ff0ef          	jal	80002546 <balloc>
    800026c2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026c6:	02090d63          	beqz	s2,80002700 <bmap+0x9a>
    800026ca:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800026cc:	0929a023          	sw	s2,128(s3)
    800026d0:	a011                	j	800026d4 <bmap+0x6e>
    800026d2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800026d4:	85ca                	mv	a1,s2
    800026d6:	0009a503          	lw	a0,0(s3)
    800026da:	c09ff0ef          	jal	800022e2 <bread>
    800026de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026e0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026e4:	02049713          	slli	a4,s1,0x20
    800026e8:	01e75593          	srli	a1,a4,0x1e
    800026ec:	00b784b3          	add	s1,a5,a1
    800026f0:	0004a903          	lw	s2,0(s1)
    800026f4:	00090e63          	beqz	s2,80002710 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800026f8:	8552                	mv	a0,s4
    800026fa:	cf1ff0ef          	jal	800023ea <brelse>
    return addr;
    800026fe:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002700:	854a                	mv	a0,s2
    80002702:	70a2                	ld	ra,40(sp)
    80002704:	7402                	ld	s0,32(sp)
    80002706:	64e2                	ld	s1,24(sp)
    80002708:	6942                	ld	s2,16(sp)
    8000270a:	69a2                	ld	s3,8(sp)
    8000270c:	6145                	addi	sp,sp,48
    8000270e:	8082                	ret
      addr = balloc(ip->dev);
    80002710:	0009a503          	lw	a0,0(s3)
    80002714:	e33ff0ef          	jal	80002546 <balloc>
    80002718:	0005091b          	sext.w	s2,a0
      if(addr){
    8000271c:	fc090ee3          	beqz	s2,800026f8 <bmap+0x92>
        a[bn] = addr;
    80002720:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002724:	8552                	mv	a0,s4
    80002726:	50f000ef          	jal	80003434 <log_write>
    8000272a:	b7f9                	j	800026f8 <bmap+0x92>
    8000272c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000272e:	00005517          	auipc	a0,0x5
    80002732:	d1a50513          	addi	a0,a0,-742 # 80007448 <etext+0x448>
    80002736:	0da030ef          	jal	80005810 <panic>

000000008000273a <iget>:
{
    8000273a:	7179                	addi	sp,sp,-48
    8000273c:	f406                	sd	ra,40(sp)
    8000273e:	f022                	sd	s0,32(sp)
    80002740:	ec26                	sd	s1,24(sp)
    80002742:	e84a                	sd	s2,16(sp)
    80002744:	e44e                	sd	s3,8(sp)
    80002746:	e052                	sd	s4,0(sp)
    80002748:	1800                	addi	s0,sp,48
    8000274a:	89aa                	mv	s3,a0
    8000274c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000274e:	0001c517          	auipc	a0,0x1c
    80002752:	03250513          	addi	a0,a0,50 # 8001e780 <itable>
    80002756:	3e8030ef          	jal	80005b3e <acquire>
  empty = 0;
    8000275a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000275c:	0001c497          	auipc	s1,0x1c
    80002760:	03c48493          	addi	s1,s1,60 # 8001e798 <itable+0x18>
    80002764:	0001e697          	auipc	a3,0x1e
    80002768:	ac468693          	addi	a3,a3,-1340 # 80020228 <log>
    8000276c:	a039                	j	8000277a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000276e:	02090963          	beqz	s2,800027a0 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002772:	08848493          	addi	s1,s1,136
    80002776:	02d48863          	beq	s1,a3,800027a6 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000277a:	449c                	lw	a5,8(s1)
    8000277c:	fef059e3          	blez	a5,8000276e <iget+0x34>
    80002780:	4098                	lw	a4,0(s1)
    80002782:	ff3716e3          	bne	a4,s3,8000276e <iget+0x34>
    80002786:	40d8                	lw	a4,4(s1)
    80002788:	ff4713e3          	bne	a4,s4,8000276e <iget+0x34>
      ip->ref++;
    8000278c:	2785                	addiw	a5,a5,1
    8000278e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002790:	0001c517          	auipc	a0,0x1c
    80002794:	ff050513          	addi	a0,a0,-16 # 8001e780 <itable>
    80002798:	43e030ef          	jal	80005bd6 <release>
      return ip;
    8000279c:	8926                	mv	s2,s1
    8000279e:	a02d                	j	800027c8 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027a0:	fbe9                	bnez	a5,80002772 <iget+0x38>
      empty = ip;
    800027a2:	8926                	mv	s2,s1
    800027a4:	b7f9                	j	80002772 <iget+0x38>
  if(empty == 0)
    800027a6:	02090a63          	beqz	s2,800027da <iget+0xa0>
  ip->dev = dev;
    800027aa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027ae:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027b2:	4785                	li	a5,1
    800027b4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027b8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027bc:	0001c517          	auipc	a0,0x1c
    800027c0:	fc450513          	addi	a0,a0,-60 # 8001e780 <itable>
    800027c4:	412030ef          	jal	80005bd6 <release>
}
    800027c8:	854a                	mv	a0,s2
    800027ca:	70a2                	ld	ra,40(sp)
    800027cc:	7402                	ld	s0,32(sp)
    800027ce:	64e2                	ld	s1,24(sp)
    800027d0:	6942                	ld	s2,16(sp)
    800027d2:	69a2                	ld	s3,8(sp)
    800027d4:	6a02                	ld	s4,0(sp)
    800027d6:	6145                	addi	sp,sp,48
    800027d8:	8082                	ret
    panic("iget: no inodes");
    800027da:	00005517          	auipc	a0,0x5
    800027de:	c8650513          	addi	a0,a0,-890 # 80007460 <etext+0x460>
    800027e2:	02e030ef          	jal	80005810 <panic>

00000000800027e6 <fsinit>:
fsinit(int dev) {
    800027e6:	7179                	addi	sp,sp,-48
    800027e8:	f406                	sd	ra,40(sp)
    800027ea:	f022                	sd	s0,32(sp)
    800027ec:	ec26                	sd	s1,24(sp)
    800027ee:	e84a                	sd	s2,16(sp)
    800027f0:	e44e                	sd	s3,8(sp)
    800027f2:	1800                	addi	s0,sp,48
    800027f4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800027f6:	4585                	li	a1,1
    800027f8:	aebff0ef          	jal	800022e2 <bread>
    800027fc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800027fe:	0001c997          	auipc	s3,0x1c
    80002802:	f6298993          	addi	s3,s3,-158 # 8001e760 <sb>
    80002806:	02000613          	li	a2,32
    8000280a:	05850593          	addi	a1,a0,88
    8000280e:	854e                	mv	a0,s3
    80002810:	9c1fd0ef          	jal	800001d0 <memmove>
  brelse(bp);
    80002814:	8526                	mv	a0,s1
    80002816:	bd5ff0ef          	jal	800023ea <brelse>
  if(sb.magic != FSMAGIC)
    8000281a:	0009a703          	lw	a4,0(s3)
    8000281e:	102037b7          	lui	a5,0x10203
    80002822:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002826:	02f71063          	bne	a4,a5,80002846 <fsinit+0x60>
  initlog(dev, &sb);
    8000282a:	0001c597          	auipc	a1,0x1c
    8000282e:	f3658593          	addi	a1,a1,-202 # 8001e760 <sb>
    80002832:	854a                	mv	a0,s2
    80002834:	1f9000ef          	jal	8000322c <initlog>
}
    80002838:	70a2                	ld	ra,40(sp)
    8000283a:	7402                	ld	s0,32(sp)
    8000283c:	64e2                	ld	s1,24(sp)
    8000283e:	6942                	ld	s2,16(sp)
    80002840:	69a2                	ld	s3,8(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    panic("invalid file system");
    80002846:	00005517          	auipc	a0,0x5
    8000284a:	c2a50513          	addi	a0,a0,-982 # 80007470 <etext+0x470>
    8000284e:	7c3020ef          	jal	80005810 <panic>

0000000080002852 <iinit>:
{
    80002852:	7179                	addi	sp,sp,-48
    80002854:	f406                	sd	ra,40(sp)
    80002856:	f022                	sd	s0,32(sp)
    80002858:	ec26                	sd	s1,24(sp)
    8000285a:	e84a                	sd	s2,16(sp)
    8000285c:	e44e                	sd	s3,8(sp)
    8000285e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002860:	00005597          	auipc	a1,0x5
    80002864:	c2858593          	addi	a1,a1,-984 # 80007488 <etext+0x488>
    80002868:	0001c517          	auipc	a0,0x1c
    8000286c:	f1850513          	addi	a0,a0,-232 # 8001e780 <itable>
    80002870:	24e030ef          	jal	80005abe <initlock>
  for(i = 0; i < NINODE; i++) {
    80002874:	0001c497          	auipc	s1,0x1c
    80002878:	f3448493          	addi	s1,s1,-204 # 8001e7a8 <itable+0x28>
    8000287c:	0001e997          	auipc	s3,0x1e
    80002880:	9bc98993          	addi	s3,s3,-1604 # 80020238 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002884:	00005917          	auipc	s2,0x5
    80002888:	c0c90913          	addi	s2,s2,-1012 # 80007490 <etext+0x490>
    8000288c:	85ca                	mv	a1,s2
    8000288e:	8526                	mv	a0,s1
    80002890:	475000ef          	jal	80003504 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002894:	08848493          	addi	s1,s1,136
    80002898:	ff349ae3          	bne	s1,s3,8000288c <iinit+0x3a>
}
    8000289c:	70a2                	ld	ra,40(sp)
    8000289e:	7402                	ld	s0,32(sp)
    800028a0:	64e2                	ld	s1,24(sp)
    800028a2:	6942                	ld	s2,16(sp)
    800028a4:	69a2                	ld	s3,8(sp)
    800028a6:	6145                	addi	sp,sp,48
    800028a8:	8082                	ret

00000000800028aa <ialloc>:
{
    800028aa:	7139                	addi	sp,sp,-64
    800028ac:	fc06                	sd	ra,56(sp)
    800028ae:	f822                	sd	s0,48(sp)
    800028b0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800028b2:	0001c717          	auipc	a4,0x1c
    800028b6:	eba72703          	lw	a4,-326(a4) # 8001e76c <sb+0xc>
    800028ba:	4785                	li	a5,1
    800028bc:	06e7f063          	bgeu	a5,a4,8000291c <ialloc+0x72>
    800028c0:	f426                	sd	s1,40(sp)
    800028c2:	f04a                	sd	s2,32(sp)
    800028c4:	ec4e                	sd	s3,24(sp)
    800028c6:	e852                	sd	s4,16(sp)
    800028c8:	e456                	sd	s5,8(sp)
    800028ca:	e05a                	sd	s6,0(sp)
    800028cc:	8aaa                	mv	s5,a0
    800028ce:	8b2e                	mv	s6,a1
    800028d0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800028d2:	0001ca17          	auipc	s4,0x1c
    800028d6:	e8ea0a13          	addi	s4,s4,-370 # 8001e760 <sb>
    800028da:	00495593          	srli	a1,s2,0x4
    800028de:	018a2783          	lw	a5,24(s4)
    800028e2:	9dbd                	addw	a1,a1,a5
    800028e4:	8556                	mv	a0,s5
    800028e6:	9fdff0ef          	jal	800022e2 <bread>
    800028ea:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800028ec:	05850993          	addi	s3,a0,88
    800028f0:	00f97793          	andi	a5,s2,15
    800028f4:	079a                	slli	a5,a5,0x6
    800028f6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800028f8:	00099783          	lh	a5,0(s3)
    800028fc:	cb9d                	beqz	a5,80002932 <ialloc+0x88>
    brelse(bp);
    800028fe:	aedff0ef          	jal	800023ea <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002902:	0905                	addi	s2,s2,1
    80002904:	00ca2703          	lw	a4,12(s4)
    80002908:	0009079b          	sext.w	a5,s2
    8000290c:	fce7e7e3          	bltu	a5,a4,800028da <ialloc+0x30>
    80002910:	74a2                	ld	s1,40(sp)
    80002912:	7902                	ld	s2,32(sp)
    80002914:	69e2                	ld	s3,24(sp)
    80002916:	6a42                	ld	s4,16(sp)
    80002918:	6aa2                	ld	s5,8(sp)
    8000291a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000291c:	00005517          	auipc	a0,0x5
    80002920:	b7c50513          	addi	a0,a0,-1156 # 80007498 <etext+0x498>
    80002924:	41b020ef          	jal	8000553e <printf>
  return 0;
    80002928:	4501                	li	a0,0
}
    8000292a:	70e2                	ld	ra,56(sp)
    8000292c:	7442                	ld	s0,48(sp)
    8000292e:	6121                	addi	sp,sp,64
    80002930:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002932:	04000613          	li	a2,64
    80002936:	4581                	li	a1,0
    80002938:	854e                	mv	a0,s3
    8000293a:	83bfd0ef          	jal	80000174 <memset>
      dip->type = type;
    8000293e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002942:	8526                	mv	a0,s1
    80002944:	2f1000ef          	jal	80003434 <log_write>
      brelse(bp);
    80002948:	8526                	mv	a0,s1
    8000294a:	aa1ff0ef          	jal	800023ea <brelse>
      return iget(dev, inum);
    8000294e:	0009059b          	sext.w	a1,s2
    80002952:	8556                	mv	a0,s5
    80002954:	de7ff0ef          	jal	8000273a <iget>
    80002958:	74a2                	ld	s1,40(sp)
    8000295a:	7902                	ld	s2,32(sp)
    8000295c:	69e2                	ld	s3,24(sp)
    8000295e:	6a42                	ld	s4,16(sp)
    80002960:	6aa2                	ld	s5,8(sp)
    80002962:	6b02                	ld	s6,0(sp)
    80002964:	b7d9                	j	8000292a <ialloc+0x80>

0000000080002966 <iupdate>:
{
    80002966:	1101                	addi	sp,sp,-32
    80002968:	ec06                	sd	ra,24(sp)
    8000296a:	e822                	sd	s0,16(sp)
    8000296c:	e426                	sd	s1,8(sp)
    8000296e:	e04a                	sd	s2,0(sp)
    80002970:	1000                	addi	s0,sp,32
    80002972:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002974:	415c                	lw	a5,4(a0)
    80002976:	0047d79b          	srliw	a5,a5,0x4
    8000297a:	0001c597          	auipc	a1,0x1c
    8000297e:	dfe5a583          	lw	a1,-514(a1) # 8001e778 <sb+0x18>
    80002982:	9dbd                	addw	a1,a1,a5
    80002984:	4108                	lw	a0,0(a0)
    80002986:	95dff0ef          	jal	800022e2 <bread>
    8000298a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000298c:	05850793          	addi	a5,a0,88
    80002990:	40d8                	lw	a4,4(s1)
    80002992:	8b3d                	andi	a4,a4,15
    80002994:	071a                	slli	a4,a4,0x6
    80002996:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002998:	04449703          	lh	a4,68(s1)
    8000299c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800029a0:	04649703          	lh	a4,70(s1)
    800029a4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800029a8:	04849703          	lh	a4,72(s1)
    800029ac:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800029b0:	04a49703          	lh	a4,74(s1)
    800029b4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800029b8:	44f8                	lw	a4,76(s1)
    800029ba:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800029bc:	03400613          	li	a2,52
    800029c0:	05048593          	addi	a1,s1,80
    800029c4:	00c78513          	addi	a0,a5,12
    800029c8:	809fd0ef          	jal	800001d0 <memmove>
  log_write(bp);
    800029cc:	854a                	mv	a0,s2
    800029ce:	267000ef          	jal	80003434 <log_write>
  brelse(bp);
    800029d2:	854a                	mv	a0,s2
    800029d4:	a17ff0ef          	jal	800023ea <brelse>
}
    800029d8:	60e2                	ld	ra,24(sp)
    800029da:	6442                	ld	s0,16(sp)
    800029dc:	64a2                	ld	s1,8(sp)
    800029de:	6902                	ld	s2,0(sp)
    800029e0:	6105                	addi	sp,sp,32
    800029e2:	8082                	ret

00000000800029e4 <idup>:
{
    800029e4:	1101                	addi	sp,sp,-32
    800029e6:	ec06                	sd	ra,24(sp)
    800029e8:	e822                	sd	s0,16(sp)
    800029ea:	e426                	sd	s1,8(sp)
    800029ec:	1000                	addi	s0,sp,32
    800029ee:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029f0:	0001c517          	auipc	a0,0x1c
    800029f4:	d9050513          	addi	a0,a0,-624 # 8001e780 <itable>
    800029f8:	146030ef          	jal	80005b3e <acquire>
  ip->ref++;
    800029fc:	449c                	lw	a5,8(s1)
    800029fe:	2785                	addiw	a5,a5,1
    80002a00:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a02:	0001c517          	auipc	a0,0x1c
    80002a06:	d7e50513          	addi	a0,a0,-642 # 8001e780 <itable>
    80002a0a:	1cc030ef          	jal	80005bd6 <release>
}
    80002a0e:	8526                	mv	a0,s1
    80002a10:	60e2                	ld	ra,24(sp)
    80002a12:	6442                	ld	s0,16(sp)
    80002a14:	64a2                	ld	s1,8(sp)
    80002a16:	6105                	addi	sp,sp,32
    80002a18:	8082                	ret

0000000080002a1a <ilock>:
{
    80002a1a:	1101                	addi	sp,sp,-32
    80002a1c:	ec06                	sd	ra,24(sp)
    80002a1e:	e822                	sd	s0,16(sp)
    80002a20:	e426                	sd	s1,8(sp)
    80002a22:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a24:	cd19                	beqz	a0,80002a42 <ilock+0x28>
    80002a26:	84aa                	mv	s1,a0
    80002a28:	451c                	lw	a5,8(a0)
    80002a2a:	00f05c63          	blez	a5,80002a42 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002a2e:	0541                	addi	a0,a0,16
    80002a30:	30b000ef          	jal	8000353a <acquiresleep>
  if(ip->valid == 0){
    80002a34:	40bc                	lw	a5,64(s1)
    80002a36:	cf89                	beqz	a5,80002a50 <ilock+0x36>
}
    80002a38:	60e2                	ld	ra,24(sp)
    80002a3a:	6442                	ld	s0,16(sp)
    80002a3c:	64a2                	ld	s1,8(sp)
    80002a3e:	6105                	addi	sp,sp,32
    80002a40:	8082                	ret
    80002a42:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002a44:	00005517          	auipc	a0,0x5
    80002a48:	a6c50513          	addi	a0,a0,-1428 # 800074b0 <etext+0x4b0>
    80002a4c:	5c5020ef          	jal	80005810 <panic>
    80002a50:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a52:	40dc                	lw	a5,4(s1)
    80002a54:	0047d79b          	srliw	a5,a5,0x4
    80002a58:	0001c597          	auipc	a1,0x1c
    80002a5c:	d205a583          	lw	a1,-736(a1) # 8001e778 <sb+0x18>
    80002a60:	9dbd                	addw	a1,a1,a5
    80002a62:	4088                	lw	a0,0(s1)
    80002a64:	87fff0ef          	jal	800022e2 <bread>
    80002a68:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a6a:	05850593          	addi	a1,a0,88
    80002a6e:	40dc                	lw	a5,4(s1)
    80002a70:	8bbd                	andi	a5,a5,15
    80002a72:	079a                	slli	a5,a5,0x6
    80002a74:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002a76:	00059783          	lh	a5,0(a1)
    80002a7a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002a7e:	00259783          	lh	a5,2(a1)
    80002a82:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002a86:	00459783          	lh	a5,4(a1)
    80002a8a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002a8e:	00659783          	lh	a5,6(a1)
    80002a92:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002a96:	459c                	lw	a5,8(a1)
    80002a98:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002a9a:	03400613          	li	a2,52
    80002a9e:	05b1                	addi	a1,a1,12
    80002aa0:	05048513          	addi	a0,s1,80
    80002aa4:	f2cfd0ef          	jal	800001d0 <memmove>
    brelse(bp);
    80002aa8:	854a                	mv	a0,s2
    80002aaa:	941ff0ef          	jal	800023ea <brelse>
    ip->valid = 1;
    80002aae:	4785                	li	a5,1
    80002ab0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ab2:	04449783          	lh	a5,68(s1)
    80002ab6:	c399                	beqz	a5,80002abc <ilock+0xa2>
    80002ab8:	6902                	ld	s2,0(sp)
    80002aba:	bfbd                	j	80002a38 <ilock+0x1e>
      panic("ilock: no type");
    80002abc:	00005517          	auipc	a0,0x5
    80002ac0:	9fc50513          	addi	a0,a0,-1540 # 800074b8 <etext+0x4b8>
    80002ac4:	54d020ef          	jal	80005810 <panic>

0000000080002ac8 <iunlock>:
{
    80002ac8:	1101                	addi	sp,sp,-32
    80002aca:	ec06                	sd	ra,24(sp)
    80002acc:	e822                	sd	s0,16(sp)
    80002ace:	e426                	sd	s1,8(sp)
    80002ad0:	e04a                	sd	s2,0(sp)
    80002ad2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ad4:	c505                	beqz	a0,80002afc <iunlock+0x34>
    80002ad6:	84aa                	mv	s1,a0
    80002ad8:	01050913          	addi	s2,a0,16
    80002adc:	854a                	mv	a0,s2
    80002ade:	2db000ef          	jal	800035b8 <holdingsleep>
    80002ae2:	cd09                	beqz	a0,80002afc <iunlock+0x34>
    80002ae4:	449c                	lw	a5,8(s1)
    80002ae6:	00f05b63          	blez	a5,80002afc <iunlock+0x34>
  releasesleep(&ip->lock);
    80002aea:	854a                	mv	a0,s2
    80002aec:	295000ef          	jal	80003580 <releasesleep>
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	64a2                	ld	s1,8(sp)
    80002af6:	6902                	ld	s2,0(sp)
    80002af8:	6105                	addi	sp,sp,32
    80002afa:	8082                	ret
    panic("iunlock");
    80002afc:	00005517          	auipc	a0,0x5
    80002b00:	9cc50513          	addi	a0,a0,-1588 # 800074c8 <etext+0x4c8>
    80002b04:	50d020ef          	jal	80005810 <panic>

0000000080002b08 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b08:	7179                	addi	sp,sp,-48
    80002b0a:	f406                	sd	ra,40(sp)
    80002b0c:	f022                	sd	s0,32(sp)
    80002b0e:	ec26                	sd	s1,24(sp)
    80002b10:	e84a                	sd	s2,16(sp)
    80002b12:	e44e                	sd	s3,8(sp)
    80002b14:	1800                	addi	s0,sp,48
    80002b16:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b18:	05050493          	addi	s1,a0,80
    80002b1c:	08050913          	addi	s2,a0,128
    80002b20:	a021                	j	80002b28 <itrunc+0x20>
    80002b22:	0491                	addi	s1,s1,4
    80002b24:	01248b63          	beq	s1,s2,80002b3a <itrunc+0x32>
    if(ip->addrs[i]){
    80002b28:	408c                	lw	a1,0(s1)
    80002b2a:	dde5                	beqz	a1,80002b22 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002b2c:	0009a503          	lw	a0,0(s3)
    80002b30:	9abff0ef          	jal	800024da <bfree>
      ip->addrs[i] = 0;
    80002b34:	0004a023          	sw	zero,0(s1)
    80002b38:	b7ed                	j	80002b22 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002b3a:	0809a583          	lw	a1,128(s3)
    80002b3e:	ed89                	bnez	a1,80002b58 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002b40:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002b44:	854e                	mv	a0,s3
    80002b46:	e21ff0ef          	jal	80002966 <iupdate>
}
    80002b4a:	70a2                	ld	ra,40(sp)
    80002b4c:	7402                	ld	s0,32(sp)
    80002b4e:	64e2                	ld	s1,24(sp)
    80002b50:	6942                	ld	s2,16(sp)
    80002b52:	69a2                	ld	s3,8(sp)
    80002b54:	6145                	addi	sp,sp,48
    80002b56:	8082                	ret
    80002b58:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002b5a:	0009a503          	lw	a0,0(s3)
    80002b5e:	f84ff0ef          	jal	800022e2 <bread>
    80002b62:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002b64:	05850493          	addi	s1,a0,88
    80002b68:	45850913          	addi	s2,a0,1112
    80002b6c:	a021                	j	80002b74 <itrunc+0x6c>
    80002b6e:	0491                	addi	s1,s1,4
    80002b70:	01248963          	beq	s1,s2,80002b82 <itrunc+0x7a>
      if(a[j])
    80002b74:	408c                	lw	a1,0(s1)
    80002b76:	dde5                	beqz	a1,80002b6e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002b78:	0009a503          	lw	a0,0(s3)
    80002b7c:	95fff0ef          	jal	800024da <bfree>
    80002b80:	b7fd                	j	80002b6e <itrunc+0x66>
    brelse(bp);
    80002b82:	8552                	mv	a0,s4
    80002b84:	867ff0ef          	jal	800023ea <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002b88:	0809a583          	lw	a1,128(s3)
    80002b8c:	0009a503          	lw	a0,0(s3)
    80002b90:	94bff0ef          	jal	800024da <bfree>
    ip->addrs[NDIRECT] = 0;
    80002b94:	0809a023          	sw	zero,128(s3)
    80002b98:	6a02                	ld	s4,0(sp)
    80002b9a:	b75d                	j	80002b40 <itrunc+0x38>

0000000080002b9c <iput>:
{
    80002b9c:	1101                	addi	sp,sp,-32
    80002b9e:	ec06                	sd	ra,24(sp)
    80002ba0:	e822                	sd	s0,16(sp)
    80002ba2:	e426                	sd	s1,8(sp)
    80002ba4:	1000                	addi	s0,sp,32
    80002ba6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ba8:	0001c517          	auipc	a0,0x1c
    80002bac:	bd850513          	addi	a0,a0,-1064 # 8001e780 <itable>
    80002bb0:	78f020ef          	jal	80005b3e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002bb4:	4498                	lw	a4,8(s1)
    80002bb6:	4785                	li	a5,1
    80002bb8:	02f70063          	beq	a4,a5,80002bd8 <iput+0x3c>
  ip->ref--;
    80002bbc:	449c                	lw	a5,8(s1)
    80002bbe:	37fd                	addiw	a5,a5,-1
    80002bc0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bc2:	0001c517          	auipc	a0,0x1c
    80002bc6:	bbe50513          	addi	a0,a0,-1090 # 8001e780 <itable>
    80002bca:	00c030ef          	jal	80005bd6 <release>
}
    80002bce:	60e2                	ld	ra,24(sp)
    80002bd0:	6442                	ld	s0,16(sp)
    80002bd2:	64a2                	ld	s1,8(sp)
    80002bd4:	6105                	addi	sp,sp,32
    80002bd6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002bd8:	40bc                	lw	a5,64(s1)
    80002bda:	d3ed                	beqz	a5,80002bbc <iput+0x20>
    80002bdc:	04a49783          	lh	a5,74(s1)
    80002be0:	fff1                	bnez	a5,80002bbc <iput+0x20>
    80002be2:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002be4:	01048913          	addi	s2,s1,16
    80002be8:	854a                	mv	a0,s2
    80002bea:	151000ef          	jal	8000353a <acquiresleep>
    release(&itable.lock);
    80002bee:	0001c517          	auipc	a0,0x1c
    80002bf2:	b9250513          	addi	a0,a0,-1134 # 8001e780 <itable>
    80002bf6:	7e1020ef          	jal	80005bd6 <release>
    itrunc(ip);
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	f0dff0ef          	jal	80002b08 <itrunc>
    ip->type = 0;
    80002c00:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002c04:	8526                	mv	a0,s1
    80002c06:	d61ff0ef          	jal	80002966 <iupdate>
    ip->valid = 0;
    80002c0a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002c0e:	854a                	mv	a0,s2
    80002c10:	171000ef          	jal	80003580 <releasesleep>
    acquire(&itable.lock);
    80002c14:	0001c517          	auipc	a0,0x1c
    80002c18:	b6c50513          	addi	a0,a0,-1172 # 8001e780 <itable>
    80002c1c:	723020ef          	jal	80005b3e <acquire>
    80002c20:	6902                	ld	s2,0(sp)
    80002c22:	bf69                	j	80002bbc <iput+0x20>

0000000080002c24 <iunlockput>:
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	1000                	addi	s0,sp,32
    80002c2e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002c30:	e99ff0ef          	jal	80002ac8 <iunlock>
  iput(ip);
    80002c34:	8526                	mv	a0,s1
    80002c36:	f67ff0ef          	jal	80002b9c <iput>
}
    80002c3a:	60e2                	ld	ra,24(sp)
    80002c3c:	6442                	ld	s0,16(sp)
    80002c3e:	64a2                	ld	s1,8(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret

0000000080002c44 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c44:	1141                	addi	sp,sp,-16
    80002c46:	e422                	sd	s0,8(sp)
    80002c48:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c4a:	411c                	lw	a5,0(a0)
    80002c4c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c4e:	415c                	lw	a5,4(a0)
    80002c50:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c52:	04451783          	lh	a5,68(a0)
    80002c56:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c5a:	04a51783          	lh	a5,74(a0)
    80002c5e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c62:	04c56783          	lwu	a5,76(a0)
    80002c66:	e99c                	sd	a5,16(a1)
}
    80002c68:	6422                	ld	s0,8(sp)
    80002c6a:	0141                	addi	sp,sp,16
    80002c6c:	8082                	ret

0000000080002c6e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c6e:	457c                	lw	a5,76(a0)
    80002c70:	0ed7eb63          	bltu	a5,a3,80002d66 <readi+0xf8>
{
    80002c74:	7159                	addi	sp,sp,-112
    80002c76:	f486                	sd	ra,104(sp)
    80002c78:	f0a2                	sd	s0,96(sp)
    80002c7a:	eca6                	sd	s1,88(sp)
    80002c7c:	e0d2                	sd	s4,64(sp)
    80002c7e:	fc56                	sd	s5,56(sp)
    80002c80:	f85a                	sd	s6,48(sp)
    80002c82:	f45e                	sd	s7,40(sp)
    80002c84:	1880                	addi	s0,sp,112
    80002c86:	8b2a                	mv	s6,a0
    80002c88:	8bae                	mv	s7,a1
    80002c8a:	8a32                	mv	s4,a2
    80002c8c:	84b6                	mv	s1,a3
    80002c8e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002c90:	9f35                	addw	a4,a4,a3
    return 0;
    80002c92:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002c94:	0cd76063          	bltu	a4,a3,80002d54 <readi+0xe6>
    80002c98:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002c9a:	00e7f463          	bgeu	a5,a4,80002ca2 <readi+0x34>
    n = ip->size - off;
    80002c9e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ca2:	080a8f63          	beqz	s5,80002d40 <readi+0xd2>
    80002ca6:	e8ca                	sd	s2,80(sp)
    80002ca8:	f062                	sd	s8,32(sp)
    80002caa:	ec66                	sd	s9,24(sp)
    80002cac:	e86a                	sd	s10,16(sp)
    80002cae:	e46e                	sd	s11,8(sp)
    80002cb0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cb2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002cb6:	5c7d                	li	s8,-1
    80002cb8:	a80d                	j	80002cea <readi+0x7c>
    80002cba:	020d1d93          	slli	s11,s10,0x20
    80002cbe:	020ddd93          	srli	s11,s11,0x20
    80002cc2:	05890613          	addi	a2,s2,88
    80002cc6:	86ee                	mv	a3,s11
    80002cc8:	963a                	add	a2,a2,a4
    80002cca:	85d2                	mv	a1,s4
    80002ccc:	855e                	mv	a0,s7
    80002cce:	bd3fe0ef          	jal	800018a0 <either_copyout>
    80002cd2:	05850763          	beq	a0,s8,80002d20 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002cd6:	854a                	mv	a0,s2
    80002cd8:	f12ff0ef          	jal	800023ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002cdc:	013d09bb          	addw	s3,s10,s3
    80002ce0:	009d04bb          	addw	s1,s10,s1
    80002ce4:	9a6e                	add	s4,s4,s11
    80002ce6:	0559f763          	bgeu	s3,s5,80002d34 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002cea:	00a4d59b          	srliw	a1,s1,0xa
    80002cee:	855a                	mv	a0,s6
    80002cf0:	977ff0ef          	jal	80002666 <bmap>
    80002cf4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002cf8:	c5b1                	beqz	a1,80002d44 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002cfa:	000b2503          	lw	a0,0(s6)
    80002cfe:	de4ff0ef          	jal	800022e2 <bread>
    80002d02:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d04:	3ff4f713          	andi	a4,s1,1023
    80002d08:	40ec87bb          	subw	a5,s9,a4
    80002d0c:	413a86bb          	subw	a3,s5,s3
    80002d10:	8d3e                	mv	s10,a5
    80002d12:	2781                	sext.w	a5,a5
    80002d14:	0006861b          	sext.w	a2,a3
    80002d18:	faf671e3          	bgeu	a2,a5,80002cba <readi+0x4c>
    80002d1c:	8d36                	mv	s10,a3
    80002d1e:	bf71                	j	80002cba <readi+0x4c>
      brelse(bp);
    80002d20:	854a                	mv	a0,s2
    80002d22:	ec8ff0ef          	jal	800023ea <brelse>
      tot = -1;
    80002d26:	59fd                	li	s3,-1
      break;
    80002d28:	6946                	ld	s2,80(sp)
    80002d2a:	7c02                	ld	s8,32(sp)
    80002d2c:	6ce2                	ld	s9,24(sp)
    80002d2e:	6d42                	ld	s10,16(sp)
    80002d30:	6da2                	ld	s11,8(sp)
    80002d32:	a831                	j	80002d4e <readi+0xe0>
    80002d34:	6946                	ld	s2,80(sp)
    80002d36:	7c02                	ld	s8,32(sp)
    80002d38:	6ce2                	ld	s9,24(sp)
    80002d3a:	6d42                	ld	s10,16(sp)
    80002d3c:	6da2                	ld	s11,8(sp)
    80002d3e:	a801                	j	80002d4e <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d40:	89d6                	mv	s3,s5
    80002d42:	a031                	j	80002d4e <readi+0xe0>
    80002d44:	6946                	ld	s2,80(sp)
    80002d46:	7c02                	ld	s8,32(sp)
    80002d48:	6ce2                	ld	s9,24(sp)
    80002d4a:	6d42                	ld	s10,16(sp)
    80002d4c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d4e:	0009851b          	sext.w	a0,s3
    80002d52:	69a6                	ld	s3,72(sp)
}
    80002d54:	70a6                	ld	ra,104(sp)
    80002d56:	7406                	ld	s0,96(sp)
    80002d58:	64e6                	ld	s1,88(sp)
    80002d5a:	6a06                	ld	s4,64(sp)
    80002d5c:	7ae2                	ld	s5,56(sp)
    80002d5e:	7b42                	ld	s6,48(sp)
    80002d60:	7ba2                	ld	s7,40(sp)
    80002d62:	6165                	addi	sp,sp,112
    80002d64:	8082                	ret
    return 0;
    80002d66:	4501                	li	a0,0
}
    80002d68:	8082                	ret

0000000080002d6a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d6a:	457c                	lw	a5,76(a0)
    80002d6c:	10d7e063          	bltu	a5,a3,80002e6c <writei+0x102>
{
    80002d70:	7159                	addi	sp,sp,-112
    80002d72:	f486                	sd	ra,104(sp)
    80002d74:	f0a2                	sd	s0,96(sp)
    80002d76:	e8ca                	sd	s2,80(sp)
    80002d78:	e0d2                	sd	s4,64(sp)
    80002d7a:	fc56                	sd	s5,56(sp)
    80002d7c:	f85a                	sd	s6,48(sp)
    80002d7e:	f45e                	sd	s7,40(sp)
    80002d80:	1880                	addi	s0,sp,112
    80002d82:	8aaa                	mv	s5,a0
    80002d84:	8bae                	mv	s7,a1
    80002d86:	8a32                	mv	s4,a2
    80002d88:	8936                	mv	s2,a3
    80002d8a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d8c:	00e687bb          	addw	a5,a3,a4
    80002d90:	0ed7e063          	bltu	a5,a3,80002e70 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002d94:	00043737          	lui	a4,0x43
    80002d98:	0cf76e63          	bltu	a4,a5,80002e74 <writei+0x10a>
    80002d9c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d9e:	0a0b0f63          	beqz	s6,80002e5c <writei+0xf2>
    80002da2:	eca6                	sd	s1,88(sp)
    80002da4:	f062                	sd	s8,32(sp)
    80002da6:	ec66                	sd	s9,24(sp)
    80002da8:	e86a                	sd	s10,16(sp)
    80002daa:	e46e                	sd	s11,8(sp)
    80002dac:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dae:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002db2:	5c7d                	li	s8,-1
    80002db4:	a825                	j	80002dec <writei+0x82>
    80002db6:	020d1d93          	slli	s11,s10,0x20
    80002dba:	020ddd93          	srli	s11,s11,0x20
    80002dbe:	05848513          	addi	a0,s1,88
    80002dc2:	86ee                	mv	a3,s11
    80002dc4:	8652                	mv	a2,s4
    80002dc6:	85de                	mv	a1,s7
    80002dc8:	953a                	add	a0,a0,a4
    80002dca:	b21fe0ef          	jal	800018ea <either_copyin>
    80002dce:	05850a63          	beq	a0,s8,80002e22 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	660000ef          	jal	80003434 <log_write>
    brelse(bp);
    80002dd8:	8526                	mv	a0,s1
    80002dda:	e10ff0ef          	jal	800023ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002dde:	013d09bb          	addw	s3,s10,s3
    80002de2:	012d093b          	addw	s2,s10,s2
    80002de6:	9a6e                	add	s4,s4,s11
    80002de8:	0569f063          	bgeu	s3,s6,80002e28 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002dec:	00a9559b          	srliw	a1,s2,0xa
    80002df0:	8556                	mv	a0,s5
    80002df2:	875ff0ef          	jal	80002666 <bmap>
    80002df6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002dfa:	c59d                	beqz	a1,80002e28 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002dfc:	000aa503          	lw	a0,0(s5)
    80002e00:	ce2ff0ef          	jal	800022e2 <bread>
    80002e04:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e06:	3ff97713          	andi	a4,s2,1023
    80002e0a:	40ec87bb          	subw	a5,s9,a4
    80002e0e:	413b06bb          	subw	a3,s6,s3
    80002e12:	8d3e                	mv	s10,a5
    80002e14:	2781                	sext.w	a5,a5
    80002e16:	0006861b          	sext.w	a2,a3
    80002e1a:	f8f67ee3          	bgeu	a2,a5,80002db6 <writei+0x4c>
    80002e1e:	8d36                	mv	s10,a3
    80002e20:	bf59                	j	80002db6 <writei+0x4c>
      brelse(bp);
    80002e22:	8526                	mv	a0,s1
    80002e24:	dc6ff0ef          	jal	800023ea <brelse>
  }

  if(off > ip->size)
    80002e28:	04caa783          	lw	a5,76(s5)
    80002e2c:	0327fa63          	bgeu	a5,s2,80002e60 <writei+0xf6>
    ip->size = off;
    80002e30:	052aa623          	sw	s2,76(s5)
    80002e34:	64e6                	ld	s1,88(sp)
    80002e36:	7c02                	ld	s8,32(sp)
    80002e38:	6ce2                	ld	s9,24(sp)
    80002e3a:	6d42                	ld	s10,16(sp)
    80002e3c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e3e:	8556                	mv	a0,s5
    80002e40:	b27ff0ef          	jal	80002966 <iupdate>

  return tot;
    80002e44:	0009851b          	sext.w	a0,s3
    80002e48:	69a6                	ld	s3,72(sp)
}
    80002e4a:	70a6                	ld	ra,104(sp)
    80002e4c:	7406                	ld	s0,96(sp)
    80002e4e:	6946                	ld	s2,80(sp)
    80002e50:	6a06                	ld	s4,64(sp)
    80002e52:	7ae2                	ld	s5,56(sp)
    80002e54:	7b42                	ld	s6,48(sp)
    80002e56:	7ba2                	ld	s7,40(sp)
    80002e58:	6165                	addi	sp,sp,112
    80002e5a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e5c:	89da                	mv	s3,s6
    80002e5e:	b7c5                	j	80002e3e <writei+0xd4>
    80002e60:	64e6                	ld	s1,88(sp)
    80002e62:	7c02                	ld	s8,32(sp)
    80002e64:	6ce2                	ld	s9,24(sp)
    80002e66:	6d42                	ld	s10,16(sp)
    80002e68:	6da2                	ld	s11,8(sp)
    80002e6a:	bfd1                	j	80002e3e <writei+0xd4>
    return -1;
    80002e6c:	557d                	li	a0,-1
}
    80002e6e:	8082                	ret
    return -1;
    80002e70:	557d                	li	a0,-1
    80002e72:	bfe1                	j	80002e4a <writei+0xe0>
    return -1;
    80002e74:	557d                	li	a0,-1
    80002e76:	bfd1                	j	80002e4a <writei+0xe0>

0000000080002e78 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e78:	1141                	addi	sp,sp,-16
    80002e7a:	e406                	sd	ra,8(sp)
    80002e7c:	e022                	sd	s0,0(sp)
    80002e7e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e80:	4639                	li	a2,14
    80002e82:	bbefd0ef          	jal	80000240 <strncmp>
}
    80002e86:	60a2                	ld	ra,8(sp)
    80002e88:	6402                	ld	s0,0(sp)
    80002e8a:	0141                	addi	sp,sp,16
    80002e8c:	8082                	ret

0000000080002e8e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002e8e:	7139                	addi	sp,sp,-64
    80002e90:	fc06                	sd	ra,56(sp)
    80002e92:	f822                	sd	s0,48(sp)
    80002e94:	f426                	sd	s1,40(sp)
    80002e96:	f04a                	sd	s2,32(sp)
    80002e98:	ec4e                	sd	s3,24(sp)
    80002e9a:	e852                	sd	s4,16(sp)
    80002e9c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002e9e:	04451703          	lh	a4,68(a0)
    80002ea2:	4785                	li	a5,1
    80002ea4:	00f71a63          	bne	a4,a5,80002eb8 <dirlookup+0x2a>
    80002ea8:	892a                	mv	s2,a0
    80002eaa:	89ae                	mv	s3,a1
    80002eac:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eae:	457c                	lw	a5,76(a0)
    80002eb0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002eb2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eb4:	e39d                	bnez	a5,80002eda <dirlookup+0x4c>
    80002eb6:	a095                	j	80002f1a <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002eb8:	00004517          	auipc	a0,0x4
    80002ebc:	61850513          	addi	a0,a0,1560 # 800074d0 <etext+0x4d0>
    80002ec0:	151020ef          	jal	80005810 <panic>
      panic("dirlookup read");
    80002ec4:	00004517          	auipc	a0,0x4
    80002ec8:	62450513          	addi	a0,a0,1572 # 800074e8 <etext+0x4e8>
    80002ecc:	145020ef          	jal	80005810 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ed0:	24c1                	addiw	s1,s1,16
    80002ed2:	04c92783          	lw	a5,76(s2)
    80002ed6:	04f4f163          	bgeu	s1,a5,80002f18 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eda:	4741                	li	a4,16
    80002edc:	86a6                	mv	a3,s1
    80002ede:	fc040613          	addi	a2,s0,-64
    80002ee2:	4581                	li	a1,0
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	d89ff0ef          	jal	80002c6e <readi>
    80002eea:	47c1                	li	a5,16
    80002eec:	fcf51ce3          	bne	a0,a5,80002ec4 <dirlookup+0x36>
    if(de.inum == 0)
    80002ef0:	fc045783          	lhu	a5,-64(s0)
    80002ef4:	dff1                	beqz	a5,80002ed0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002ef6:	fc240593          	addi	a1,s0,-62
    80002efa:	854e                	mv	a0,s3
    80002efc:	f7dff0ef          	jal	80002e78 <namecmp>
    80002f00:	f961                	bnez	a0,80002ed0 <dirlookup+0x42>
      if(poff)
    80002f02:	000a0463          	beqz	s4,80002f0a <dirlookup+0x7c>
        *poff = off;
    80002f06:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002f0a:	fc045583          	lhu	a1,-64(s0)
    80002f0e:	00092503          	lw	a0,0(s2)
    80002f12:	829ff0ef          	jal	8000273a <iget>
    80002f16:	a011                	j	80002f1a <dirlookup+0x8c>
  return 0;
    80002f18:	4501                	li	a0,0
}
    80002f1a:	70e2                	ld	ra,56(sp)
    80002f1c:	7442                	ld	s0,48(sp)
    80002f1e:	74a2                	ld	s1,40(sp)
    80002f20:	7902                	ld	s2,32(sp)
    80002f22:	69e2                	ld	s3,24(sp)
    80002f24:	6a42                	ld	s4,16(sp)
    80002f26:	6121                	addi	sp,sp,64
    80002f28:	8082                	ret

0000000080002f2a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002f2a:	711d                	addi	sp,sp,-96
    80002f2c:	ec86                	sd	ra,88(sp)
    80002f2e:	e8a2                	sd	s0,80(sp)
    80002f30:	e4a6                	sd	s1,72(sp)
    80002f32:	e0ca                	sd	s2,64(sp)
    80002f34:	fc4e                	sd	s3,56(sp)
    80002f36:	f852                	sd	s4,48(sp)
    80002f38:	f456                	sd	s5,40(sp)
    80002f3a:	f05a                	sd	s6,32(sp)
    80002f3c:	ec5e                	sd	s7,24(sp)
    80002f3e:	e862                	sd	s8,16(sp)
    80002f40:	e466                	sd	s9,8(sp)
    80002f42:	1080                	addi	s0,sp,96
    80002f44:	84aa                	mv	s1,a0
    80002f46:	8b2e                	mv	s6,a1
    80002f48:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f4a:	00054703          	lbu	a4,0(a0)
    80002f4e:	02f00793          	li	a5,47
    80002f52:	00f70e63          	beq	a4,a5,80002f6e <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f56:	fc5fd0ef          	jal	80000f1a <myproc>
    80002f5a:	15853503          	ld	a0,344(a0)
    80002f5e:	a87ff0ef          	jal	800029e4 <idup>
    80002f62:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f64:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002f68:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f6a:	4b85                	li	s7,1
    80002f6c:	a871                	j	80003008 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002f6e:	4585                	li	a1,1
    80002f70:	4505                	li	a0,1
    80002f72:	fc8ff0ef          	jal	8000273a <iget>
    80002f76:	8a2a                	mv	s4,a0
    80002f78:	b7f5                	j	80002f64 <namex+0x3a>
      iunlockput(ip);
    80002f7a:	8552                	mv	a0,s4
    80002f7c:	ca9ff0ef          	jal	80002c24 <iunlockput>
      return 0;
    80002f80:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f82:	8552                	mv	a0,s4
    80002f84:	60e6                	ld	ra,88(sp)
    80002f86:	6446                	ld	s0,80(sp)
    80002f88:	64a6                	ld	s1,72(sp)
    80002f8a:	6906                	ld	s2,64(sp)
    80002f8c:	79e2                	ld	s3,56(sp)
    80002f8e:	7a42                	ld	s4,48(sp)
    80002f90:	7aa2                	ld	s5,40(sp)
    80002f92:	7b02                	ld	s6,32(sp)
    80002f94:	6be2                	ld	s7,24(sp)
    80002f96:	6c42                	ld	s8,16(sp)
    80002f98:	6ca2                	ld	s9,8(sp)
    80002f9a:	6125                	addi	sp,sp,96
    80002f9c:	8082                	ret
      iunlock(ip);
    80002f9e:	8552                	mv	a0,s4
    80002fa0:	b29ff0ef          	jal	80002ac8 <iunlock>
      return ip;
    80002fa4:	bff9                	j	80002f82 <namex+0x58>
      iunlockput(ip);
    80002fa6:	8552                	mv	a0,s4
    80002fa8:	c7dff0ef          	jal	80002c24 <iunlockput>
      return 0;
    80002fac:	8a4e                	mv	s4,s3
    80002fae:	bfd1                	j	80002f82 <namex+0x58>
  len = path - s;
    80002fb0:	40998633          	sub	a2,s3,s1
    80002fb4:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002fb8:	099c5063          	bge	s8,s9,80003038 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002fbc:	4639                	li	a2,14
    80002fbe:	85a6                	mv	a1,s1
    80002fc0:	8556                	mv	a0,s5
    80002fc2:	a0efd0ef          	jal	800001d0 <memmove>
    80002fc6:	84ce                	mv	s1,s3
  while(*path == '/')
    80002fc8:	0004c783          	lbu	a5,0(s1)
    80002fcc:	01279763          	bne	a5,s2,80002fda <namex+0xb0>
    path++;
    80002fd0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002fd2:	0004c783          	lbu	a5,0(s1)
    80002fd6:	ff278de3          	beq	a5,s2,80002fd0 <namex+0xa6>
    ilock(ip);
    80002fda:	8552                	mv	a0,s4
    80002fdc:	a3fff0ef          	jal	80002a1a <ilock>
    if(ip->type != T_DIR){
    80002fe0:	044a1783          	lh	a5,68(s4)
    80002fe4:	f9779be3          	bne	a5,s7,80002f7a <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002fe8:	000b0563          	beqz	s6,80002ff2 <namex+0xc8>
    80002fec:	0004c783          	lbu	a5,0(s1)
    80002ff0:	d7dd                	beqz	a5,80002f9e <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002ff2:	4601                	li	a2,0
    80002ff4:	85d6                	mv	a1,s5
    80002ff6:	8552                	mv	a0,s4
    80002ff8:	e97ff0ef          	jal	80002e8e <dirlookup>
    80002ffc:	89aa                	mv	s3,a0
    80002ffe:	d545                	beqz	a0,80002fa6 <namex+0x7c>
    iunlockput(ip);
    80003000:	8552                	mv	a0,s4
    80003002:	c23ff0ef          	jal	80002c24 <iunlockput>
    ip = next;
    80003006:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003008:	0004c783          	lbu	a5,0(s1)
    8000300c:	01279763          	bne	a5,s2,8000301a <namex+0xf0>
    path++;
    80003010:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003012:	0004c783          	lbu	a5,0(s1)
    80003016:	ff278de3          	beq	a5,s2,80003010 <namex+0xe6>
  if(*path == 0)
    8000301a:	cb8d                	beqz	a5,8000304c <namex+0x122>
  while(*path != '/' && *path != 0)
    8000301c:	0004c783          	lbu	a5,0(s1)
    80003020:	89a6                	mv	s3,s1
  len = path - s;
    80003022:	4c81                	li	s9,0
    80003024:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003026:	01278963          	beq	a5,s2,80003038 <namex+0x10e>
    8000302a:	d3d9                	beqz	a5,80002fb0 <namex+0x86>
    path++;
    8000302c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000302e:	0009c783          	lbu	a5,0(s3)
    80003032:	ff279ce3          	bne	a5,s2,8000302a <namex+0x100>
    80003036:	bfad                	j	80002fb0 <namex+0x86>
    memmove(name, s, len);
    80003038:	2601                	sext.w	a2,a2
    8000303a:	85a6                	mv	a1,s1
    8000303c:	8556                	mv	a0,s5
    8000303e:	992fd0ef          	jal	800001d0 <memmove>
    name[len] = 0;
    80003042:	9cd6                	add	s9,s9,s5
    80003044:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003048:	84ce                	mv	s1,s3
    8000304a:	bfbd                	j	80002fc8 <namex+0x9e>
  if(nameiparent){
    8000304c:	f20b0be3          	beqz	s6,80002f82 <namex+0x58>
    iput(ip);
    80003050:	8552                	mv	a0,s4
    80003052:	b4bff0ef          	jal	80002b9c <iput>
    return 0;
    80003056:	4a01                	li	s4,0
    80003058:	b72d                	j	80002f82 <namex+0x58>

000000008000305a <dirlink>:
{
    8000305a:	7139                	addi	sp,sp,-64
    8000305c:	fc06                	sd	ra,56(sp)
    8000305e:	f822                	sd	s0,48(sp)
    80003060:	f04a                	sd	s2,32(sp)
    80003062:	ec4e                	sd	s3,24(sp)
    80003064:	e852                	sd	s4,16(sp)
    80003066:	0080                	addi	s0,sp,64
    80003068:	892a                	mv	s2,a0
    8000306a:	8a2e                	mv	s4,a1
    8000306c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000306e:	4601                	li	a2,0
    80003070:	e1fff0ef          	jal	80002e8e <dirlookup>
    80003074:	e535                	bnez	a0,800030e0 <dirlink+0x86>
    80003076:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003078:	04c92483          	lw	s1,76(s2)
    8000307c:	c48d                	beqz	s1,800030a6 <dirlink+0x4c>
    8000307e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003080:	4741                	li	a4,16
    80003082:	86a6                	mv	a3,s1
    80003084:	fc040613          	addi	a2,s0,-64
    80003088:	4581                	li	a1,0
    8000308a:	854a                	mv	a0,s2
    8000308c:	be3ff0ef          	jal	80002c6e <readi>
    80003090:	47c1                	li	a5,16
    80003092:	04f51b63          	bne	a0,a5,800030e8 <dirlink+0x8e>
    if(de.inum == 0)
    80003096:	fc045783          	lhu	a5,-64(s0)
    8000309a:	c791                	beqz	a5,800030a6 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000309c:	24c1                	addiw	s1,s1,16
    8000309e:	04c92783          	lw	a5,76(s2)
    800030a2:	fcf4efe3          	bltu	s1,a5,80003080 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800030a6:	4639                	li	a2,14
    800030a8:	85d2                	mv	a1,s4
    800030aa:	fc240513          	addi	a0,s0,-62
    800030ae:	9c8fd0ef          	jal	80000276 <strncpy>
  de.inum = inum;
    800030b2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030b6:	4741                	li	a4,16
    800030b8:	86a6                	mv	a3,s1
    800030ba:	fc040613          	addi	a2,s0,-64
    800030be:	4581                	li	a1,0
    800030c0:	854a                	mv	a0,s2
    800030c2:	ca9ff0ef          	jal	80002d6a <writei>
    800030c6:	1541                	addi	a0,a0,-16
    800030c8:	00a03533          	snez	a0,a0
    800030cc:	40a00533          	neg	a0,a0
    800030d0:	74a2                	ld	s1,40(sp)
}
    800030d2:	70e2                	ld	ra,56(sp)
    800030d4:	7442                	ld	s0,48(sp)
    800030d6:	7902                	ld	s2,32(sp)
    800030d8:	69e2                	ld	s3,24(sp)
    800030da:	6a42                	ld	s4,16(sp)
    800030dc:	6121                	addi	sp,sp,64
    800030de:	8082                	ret
    iput(ip);
    800030e0:	abdff0ef          	jal	80002b9c <iput>
    return -1;
    800030e4:	557d                	li	a0,-1
    800030e6:	b7f5                	j	800030d2 <dirlink+0x78>
      panic("dirlink read");
    800030e8:	00004517          	auipc	a0,0x4
    800030ec:	41050513          	addi	a0,a0,1040 # 800074f8 <etext+0x4f8>
    800030f0:	720020ef          	jal	80005810 <panic>

00000000800030f4 <namei>:

struct inode*
namei(char *path)
{
    800030f4:	1101                	addi	sp,sp,-32
    800030f6:	ec06                	sd	ra,24(sp)
    800030f8:	e822                	sd	s0,16(sp)
    800030fa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800030fc:	fe040613          	addi	a2,s0,-32
    80003100:	4581                	li	a1,0
    80003102:	e29ff0ef          	jal	80002f2a <namex>
}
    80003106:	60e2                	ld	ra,24(sp)
    80003108:	6442                	ld	s0,16(sp)
    8000310a:	6105                	addi	sp,sp,32
    8000310c:	8082                	ret

000000008000310e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000310e:	1141                	addi	sp,sp,-16
    80003110:	e406                	sd	ra,8(sp)
    80003112:	e022                	sd	s0,0(sp)
    80003114:	0800                	addi	s0,sp,16
    80003116:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003118:	4585                	li	a1,1
    8000311a:	e11ff0ef          	jal	80002f2a <namex>
}
    8000311e:	60a2                	ld	ra,8(sp)
    80003120:	6402                	ld	s0,0(sp)
    80003122:	0141                	addi	sp,sp,16
    80003124:	8082                	ret

0000000080003126 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003126:	1101                	addi	sp,sp,-32
    80003128:	ec06                	sd	ra,24(sp)
    8000312a:	e822                	sd	s0,16(sp)
    8000312c:	e426                	sd	s1,8(sp)
    8000312e:	e04a                	sd	s2,0(sp)
    80003130:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003132:	0001d917          	auipc	s2,0x1d
    80003136:	0f690913          	addi	s2,s2,246 # 80020228 <log>
    8000313a:	01892583          	lw	a1,24(s2)
    8000313e:	02892503          	lw	a0,40(s2)
    80003142:	9a0ff0ef          	jal	800022e2 <bread>
    80003146:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003148:	02c92603          	lw	a2,44(s2)
    8000314c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000314e:	00c05f63          	blez	a2,8000316c <write_head+0x46>
    80003152:	0001d717          	auipc	a4,0x1d
    80003156:	10670713          	addi	a4,a4,262 # 80020258 <log+0x30>
    8000315a:	87aa                	mv	a5,a0
    8000315c:	060a                	slli	a2,a2,0x2
    8000315e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003160:	4314                	lw	a3,0(a4)
    80003162:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003164:	0711                	addi	a4,a4,4
    80003166:	0791                	addi	a5,a5,4
    80003168:	fec79ce3          	bne	a5,a2,80003160 <write_head+0x3a>
  }
  bwrite(buf);
    8000316c:	8526                	mv	a0,s1
    8000316e:	a4aff0ef          	jal	800023b8 <bwrite>
  brelse(buf);
    80003172:	8526                	mv	a0,s1
    80003174:	a76ff0ef          	jal	800023ea <brelse>
}
    80003178:	60e2                	ld	ra,24(sp)
    8000317a:	6442                	ld	s0,16(sp)
    8000317c:	64a2                	ld	s1,8(sp)
    8000317e:	6902                	ld	s2,0(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003184:	0001d797          	auipc	a5,0x1d
    80003188:	0d07a783          	lw	a5,208(a5) # 80020254 <log+0x2c>
    8000318c:	08f05f63          	blez	a5,8000322a <install_trans+0xa6>
{
    80003190:	7139                	addi	sp,sp,-64
    80003192:	fc06                	sd	ra,56(sp)
    80003194:	f822                	sd	s0,48(sp)
    80003196:	f426                	sd	s1,40(sp)
    80003198:	f04a                	sd	s2,32(sp)
    8000319a:	ec4e                	sd	s3,24(sp)
    8000319c:	e852                	sd	s4,16(sp)
    8000319e:	e456                	sd	s5,8(sp)
    800031a0:	e05a                	sd	s6,0(sp)
    800031a2:	0080                	addi	s0,sp,64
    800031a4:	8b2a                	mv	s6,a0
    800031a6:	0001da97          	auipc	s5,0x1d
    800031aa:	0b2a8a93          	addi	s5,s5,178 # 80020258 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031ae:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031b0:	0001d997          	auipc	s3,0x1d
    800031b4:	07898993          	addi	s3,s3,120 # 80020228 <log>
    800031b8:	a829                	j	800031d2 <install_trans+0x4e>
    brelse(lbuf);
    800031ba:	854a                	mv	a0,s2
    800031bc:	a2eff0ef          	jal	800023ea <brelse>
    brelse(dbuf);
    800031c0:	8526                	mv	a0,s1
    800031c2:	a28ff0ef          	jal	800023ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c6:	2a05                	addiw	s4,s4,1
    800031c8:	0a91                	addi	s5,s5,4
    800031ca:	02c9a783          	lw	a5,44(s3)
    800031ce:	04fa5463          	bge	s4,a5,80003216 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031d2:	0189a583          	lw	a1,24(s3)
    800031d6:	014585bb          	addw	a1,a1,s4
    800031da:	2585                	addiw	a1,a1,1
    800031dc:	0289a503          	lw	a0,40(s3)
    800031e0:	902ff0ef          	jal	800022e2 <bread>
    800031e4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800031e6:	000aa583          	lw	a1,0(s5)
    800031ea:	0289a503          	lw	a0,40(s3)
    800031ee:	8f4ff0ef          	jal	800022e2 <bread>
    800031f2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800031f4:	40000613          	li	a2,1024
    800031f8:	05890593          	addi	a1,s2,88
    800031fc:	05850513          	addi	a0,a0,88
    80003200:	fd1fc0ef          	jal	800001d0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003204:	8526                	mv	a0,s1
    80003206:	9b2ff0ef          	jal	800023b8 <bwrite>
    if(recovering == 0)
    8000320a:	fa0b18e3          	bnez	s6,800031ba <install_trans+0x36>
      bunpin(dbuf);
    8000320e:	8526                	mv	a0,s1
    80003210:	a96ff0ef          	jal	800024a6 <bunpin>
    80003214:	b75d                	j	800031ba <install_trans+0x36>
}
    80003216:	70e2                	ld	ra,56(sp)
    80003218:	7442                	ld	s0,48(sp)
    8000321a:	74a2                	ld	s1,40(sp)
    8000321c:	7902                	ld	s2,32(sp)
    8000321e:	69e2                	ld	s3,24(sp)
    80003220:	6a42                	ld	s4,16(sp)
    80003222:	6aa2                	ld	s5,8(sp)
    80003224:	6b02                	ld	s6,0(sp)
    80003226:	6121                	addi	sp,sp,64
    80003228:	8082                	ret
    8000322a:	8082                	ret

000000008000322c <initlog>:
{
    8000322c:	7179                	addi	sp,sp,-48
    8000322e:	f406                	sd	ra,40(sp)
    80003230:	f022                	sd	s0,32(sp)
    80003232:	ec26                	sd	s1,24(sp)
    80003234:	e84a                	sd	s2,16(sp)
    80003236:	e44e                	sd	s3,8(sp)
    80003238:	1800                	addi	s0,sp,48
    8000323a:	892a                	mv	s2,a0
    8000323c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000323e:	0001d497          	auipc	s1,0x1d
    80003242:	fea48493          	addi	s1,s1,-22 # 80020228 <log>
    80003246:	00004597          	auipc	a1,0x4
    8000324a:	2c258593          	addi	a1,a1,706 # 80007508 <etext+0x508>
    8000324e:	8526                	mv	a0,s1
    80003250:	06f020ef          	jal	80005abe <initlock>
  log.start = sb->logstart;
    80003254:	0149a583          	lw	a1,20(s3)
    80003258:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000325a:	0109a783          	lw	a5,16(s3)
    8000325e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003260:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003264:	854a                	mv	a0,s2
    80003266:	87cff0ef          	jal	800022e2 <bread>
  log.lh.n = lh->n;
    8000326a:	4d30                	lw	a2,88(a0)
    8000326c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000326e:	00c05f63          	blez	a2,8000328c <initlog+0x60>
    80003272:	87aa                	mv	a5,a0
    80003274:	0001d717          	auipc	a4,0x1d
    80003278:	fe470713          	addi	a4,a4,-28 # 80020258 <log+0x30>
    8000327c:	060a                	slli	a2,a2,0x2
    8000327e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003280:	4ff4                	lw	a3,92(a5)
    80003282:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003284:	0791                	addi	a5,a5,4
    80003286:	0711                	addi	a4,a4,4
    80003288:	fec79ce3          	bne	a5,a2,80003280 <initlog+0x54>
  brelse(buf);
    8000328c:	95eff0ef          	jal	800023ea <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003290:	4505                	li	a0,1
    80003292:	ef3ff0ef          	jal	80003184 <install_trans>
  log.lh.n = 0;
    80003296:	0001d797          	auipc	a5,0x1d
    8000329a:	fa07af23          	sw	zero,-66(a5) # 80020254 <log+0x2c>
  write_head(); // clear the log
    8000329e:	e89ff0ef          	jal	80003126 <write_head>
}
    800032a2:	70a2                	ld	ra,40(sp)
    800032a4:	7402                	ld	s0,32(sp)
    800032a6:	64e2                	ld	s1,24(sp)
    800032a8:	6942                	ld	s2,16(sp)
    800032aa:	69a2                	ld	s3,8(sp)
    800032ac:	6145                	addi	sp,sp,48
    800032ae:	8082                	ret

00000000800032b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800032b0:	1101                	addi	sp,sp,-32
    800032b2:	ec06                	sd	ra,24(sp)
    800032b4:	e822                	sd	s0,16(sp)
    800032b6:	e426                	sd	s1,8(sp)
    800032b8:	e04a                	sd	s2,0(sp)
    800032ba:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800032bc:	0001d517          	auipc	a0,0x1d
    800032c0:	f6c50513          	addi	a0,a0,-148 # 80020228 <log>
    800032c4:	07b020ef          	jal	80005b3e <acquire>
  while(1){
    if(log.committing){
    800032c8:	0001d497          	auipc	s1,0x1d
    800032cc:	f6048493          	addi	s1,s1,-160 # 80020228 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032d0:	4979                	li	s2,30
    800032d2:	a029                	j	800032dc <begin_op+0x2c>
      sleep(&log, &log.lock);
    800032d4:	85a6                	mv	a1,s1
    800032d6:	8526                	mv	a0,s1
    800032d8:	a3afe0ef          	jal	80001512 <sleep>
    if(log.committing){
    800032dc:	50dc                	lw	a5,36(s1)
    800032de:	fbfd                	bnez	a5,800032d4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800032e0:	5098                	lw	a4,32(s1)
    800032e2:	2705                	addiw	a4,a4,1
    800032e4:	0027179b          	slliw	a5,a4,0x2
    800032e8:	9fb9                	addw	a5,a5,a4
    800032ea:	0017979b          	slliw	a5,a5,0x1
    800032ee:	54d4                	lw	a3,44(s1)
    800032f0:	9fb5                	addw	a5,a5,a3
    800032f2:	00f95763          	bge	s2,a5,80003300 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800032f6:	85a6                	mv	a1,s1
    800032f8:	8526                	mv	a0,s1
    800032fa:	a18fe0ef          	jal	80001512 <sleep>
    800032fe:	bff9                	j	800032dc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003300:	0001d517          	auipc	a0,0x1d
    80003304:	f2850513          	addi	a0,a0,-216 # 80020228 <log>
    80003308:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000330a:	0cd020ef          	jal	80005bd6 <release>
      break;
    }
  }
}
    8000330e:	60e2                	ld	ra,24(sp)
    80003310:	6442                	ld	s0,16(sp)
    80003312:	64a2                	ld	s1,8(sp)
    80003314:	6902                	ld	s2,0(sp)
    80003316:	6105                	addi	sp,sp,32
    80003318:	8082                	ret

000000008000331a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000331a:	7139                	addi	sp,sp,-64
    8000331c:	fc06                	sd	ra,56(sp)
    8000331e:	f822                	sd	s0,48(sp)
    80003320:	f426                	sd	s1,40(sp)
    80003322:	f04a                	sd	s2,32(sp)
    80003324:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003326:	0001d497          	auipc	s1,0x1d
    8000332a:	f0248493          	addi	s1,s1,-254 # 80020228 <log>
    8000332e:	8526                	mv	a0,s1
    80003330:	00f020ef          	jal	80005b3e <acquire>
  log.outstanding -= 1;
    80003334:	509c                	lw	a5,32(s1)
    80003336:	37fd                	addiw	a5,a5,-1
    80003338:	0007891b          	sext.w	s2,a5
    8000333c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000333e:	50dc                	lw	a5,36(s1)
    80003340:	ef9d                	bnez	a5,8000337e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003342:	04091763          	bnez	s2,80003390 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003346:	0001d497          	auipc	s1,0x1d
    8000334a:	ee248493          	addi	s1,s1,-286 # 80020228 <log>
    8000334e:	4785                	li	a5,1
    80003350:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003352:	8526                	mv	a0,s1
    80003354:	083020ef          	jal	80005bd6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003358:	54dc                	lw	a5,44(s1)
    8000335a:	04f04b63          	bgtz	a5,800033b0 <end_op+0x96>
    acquire(&log.lock);
    8000335e:	0001d497          	auipc	s1,0x1d
    80003362:	eca48493          	addi	s1,s1,-310 # 80020228 <log>
    80003366:	8526                	mv	a0,s1
    80003368:	7d6020ef          	jal	80005b3e <acquire>
    log.committing = 0;
    8000336c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003370:	8526                	mv	a0,s1
    80003372:	9f6fe0ef          	jal	80001568 <wakeup>
    release(&log.lock);
    80003376:	8526                	mv	a0,s1
    80003378:	05f020ef          	jal	80005bd6 <release>
}
    8000337c:	a025                	j	800033a4 <end_op+0x8a>
    8000337e:	ec4e                	sd	s3,24(sp)
    80003380:	e852                	sd	s4,16(sp)
    80003382:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003384:	00004517          	auipc	a0,0x4
    80003388:	18c50513          	addi	a0,a0,396 # 80007510 <etext+0x510>
    8000338c:	484020ef          	jal	80005810 <panic>
    wakeup(&log);
    80003390:	0001d497          	auipc	s1,0x1d
    80003394:	e9848493          	addi	s1,s1,-360 # 80020228 <log>
    80003398:	8526                	mv	a0,s1
    8000339a:	9cefe0ef          	jal	80001568 <wakeup>
  release(&log.lock);
    8000339e:	8526                	mv	a0,s1
    800033a0:	037020ef          	jal	80005bd6 <release>
}
    800033a4:	70e2                	ld	ra,56(sp)
    800033a6:	7442                	ld	s0,48(sp)
    800033a8:	74a2                	ld	s1,40(sp)
    800033aa:	7902                	ld	s2,32(sp)
    800033ac:	6121                	addi	sp,sp,64
    800033ae:	8082                	ret
    800033b0:	ec4e                	sd	s3,24(sp)
    800033b2:	e852                	sd	s4,16(sp)
    800033b4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b6:	0001da97          	auipc	s5,0x1d
    800033ba:	ea2a8a93          	addi	s5,s5,-350 # 80020258 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800033be:	0001da17          	auipc	s4,0x1d
    800033c2:	e6aa0a13          	addi	s4,s4,-406 # 80020228 <log>
    800033c6:	018a2583          	lw	a1,24(s4)
    800033ca:	012585bb          	addw	a1,a1,s2
    800033ce:	2585                	addiw	a1,a1,1
    800033d0:	028a2503          	lw	a0,40(s4)
    800033d4:	f0ffe0ef          	jal	800022e2 <bread>
    800033d8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800033da:	000aa583          	lw	a1,0(s5)
    800033de:	028a2503          	lw	a0,40(s4)
    800033e2:	f01fe0ef          	jal	800022e2 <bread>
    800033e6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800033e8:	40000613          	li	a2,1024
    800033ec:	05850593          	addi	a1,a0,88
    800033f0:	05848513          	addi	a0,s1,88
    800033f4:	dddfc0ef          	jal	800001d0 <memmove>
    bwrite(to);  // write the log
    800033f8:	8526                	mv	a0,s1
    800033fa:	fbffe0ef          	jal	800023b8 <bwrite>
    brelse(from);
    800033fe:	854e                	mv	a0,s3
    80003400:	febfe0ef          	jal	800023ea <brelse>
    brelse(to);
    80003404:	8526                	mv	a0,s1
    80003406:	fe5fe0ef          	jal	800023ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000340a:	2905                	addiw	s2,s2,1
    8000340c:	0a91                	addi	s5,s5,4
    8000340e:	02ca2783          	lw	a5,44(s4)
    80003412:	faf94ae3          	blt	s2,a5,800033c6 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003416:	d11ff0ef          	jal	80003126 <write_head>
    install_trans(0); // Now install writes to home locations
    8000341a:	4501                	li	a0,0
    8000341c:	d69ff0ef          	jal	80003184 <install_trans>
    log.lh.n = 0;
    80003420:	0001d797          	auipc	a5,0x1d
    80003424:	e207aa23          	sw	zero,-460(a5) # 80020254 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003428:	cffff0ef          	jal	80003126 <write_head>
    8000342c:	69e2                	ld	s3,24(sp)
    8000342e:	6a42                	ld	s4,16(sp)
    80003430:	6aa2                	ld	s5,8(sp)
    80003432:	b735                	j	8000335e <end_op+0x44>

0000000080003434 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003434:	1101                	addi	sp,sp,-32
    80003436:	ec06                	sd	ra,24(sp)
    80003438:	e822                	sd	s0,16(sp)
    8000343a:	e426                	sd	s1,8(sp)
    8000343c:	e04a                	sd	s2,0(sp)
    8000343e:	1000                	addi	s0,sp,32
    80003440:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003442:	0001d917          	auipc	s2,0x1d
    80003446:	de690913          	addi	s2,s2,-538 # 80020228 <log>
    8000344a:	854a                	mv	a0,s2
    8000344c:	6f2020ef          	jal	80005b3e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003450:	02c92603          	lw	a2,44(s2)
    80003454:	47f5                	li	a5,29
    80003456:	06c7c363          	blt	a5,a2,800034bc <log_write+0x88>
    8000345a:	0001d797          	auipc	a5,0x1d
    8000345e:	dea7a783          	lw	a5,-534(a5) # 80020244 <log+0x1c>
    80003462:	37fd                	addiw	a5,a5,-1
    80003464:	04f65c63          	bge	a2,a5,800034bc <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003468:	0001d797          	auipc	a5,0x1d
    8000346c:	de07a783          	lw	a5,-544(a5) # 80020248 <log+0x20>
    80003470:	04f05c63          	blez	a5,800034c8 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003474:	4781                	li	a5,0
    80003476:	04c05f63          	blez	a2,800034d4 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000347a:	44cc                	lw	a1,12(s1)
    8000347c:	0001d717          	auipc	a4,0x1d
    80003480:	ddc70713          	addi	a4,a4,-548 # 80020258 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003484:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003486:	4314                	lw	a3,0(a4)
    80003488:	04b68663          	beq	a3,a1,800034d4 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000348c:	2785                	addiw	a5,a5,1
    8000348e:	0711                	addi	a4,a4,4
    80003490:	fef61be3          	bne	a2,a5,80003486 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003494:	0621                	addi	a2,a2,8
    80003496:	060a                	slli	a2,a2,0x2
    80003498:	0001d797          	auipc	a5,0x1d
    8000349c:	d9078793          	addi	a5,a5,-624 # 80020228 <log>
    800034a0:	97b2                	add	a5,a5,a2
    800034a2:	44d8                	lw	a4,12(s1)
    800034a4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800034a6:	8526                	mv	a0,s1
    800034a8:	fcbfe0ef          	jal	80002472 <bpin>
    log.lh.n++;
    800034ac:	0001d717          	auipc	a4,0x1d
    800034b0:	d7c70713          	addi	a4,a4,-644 # 80020228 <log>
    800034b4:	575c                	lw	a5,44(a4)
    800034b6:	2785                	addiw	a5,a5,1
    800034b8:	d75c                	sw	a5,44(a4)
    800034ba:	a80d                	j	800034ec <log_write+0xb8>
    panic("too big a transaction");
    800034bc:	00004517          	auipc	a0,0x4
    800034c0:	06450513          	addi	a0,a0,100 # 80007520 <etext+0x520>
    800034c4:	34c020ef          	jal	80005810 <panic>
    panic("log_write outside of trans");
    800034c8:	00004517          	auipc	a0,0x4
    800034cc:	07050513          	addi	a0,a0,112 # 80007538 <etext+0x538>
    800034d0:	340020ef          	jal	80005810 <panic>
  log.lh.block[i] = b->blockno;
    800034d4:	00878693          	addi	a3,a5,8
    800034d8:	068a                	slli	a3,a3,0x2
    800034da:	0001d717          	auipc	a4,0x1d
    800034de:	d4e70713          	addi	a4,a4,-690 # 80020228 <log>
    800034e2:	9736                	add	a4,a4,a3
    800034e4:	44d4                	lw	a3,12(s1)
    800034e6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800034e8:	faf60fe3          	beq	a2,a5,800034a6 <log_write+0x72>
  }
  release(&log.lock);
    800034ec:	0001d517          	auipc	a0,0x1d
    800034f0:	d3c50513          	addi	a0,a0,-708 # 80020228 <log>
    800034f4:	6e2020ef          	jal	80005bd6 <release>
}
    800034f8:	60e2                	ld	ra,24(sp)
    800034fa:	6442                	ld	s0,16(sp)
    800034fc:	64a2                	ld	s1,8(sp)
    800034fe:	6902                	ld	s2,0(sp)
    80003500:	6105                	addi	sp,sp,32
    80003502:	8082                	ret

0000000080003504 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003504:	1101                	addi	sp,sp,-32
    80003506:	ec06                	sd	ra,24(sp)
    80003508:	e822                	sd	s0,16(sp)
    8000350a:	e426                	sd	s1,8(sp)
    8000350c:	e04a                	sd	s2,0(sp)
    8000350e:	1000                	addi	s0,sp,32
    80003510:	84aa                	mv	s1,a0
    80003512:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003514:	00004597          	auipc	a1,0x4
    80003518:	04458593          	addi	a1,a1,68 # 80007558 <etext+0x558>
    8000351c:	0521                	addi	a0,a0,8
    8000351e:	5a0020ef          	jal	80005abe <initlock>
  lk->name = name;
    80003522:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003526:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000352a:	0204a423          	sw	zero,40(s1)
}
    8000352e:	60e2                	ld	ra,24(sp)
    80003530:	6442                	ld	s0,16(sp)
    80003532:	64a2                	ld	s1,8(sp)
    80003534:	6902                	ld	s2,0(sp)
    80003536:	6105                	addi	sp,sp,32
    80003538:	8082                	ret

000000008000353a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000353a:	1101                	addi	sp,sp,-32
    8000353c:	ec06                	sd	ra,24(sp)
    8000353e:	e822                	sd	s0,16(sp)
    80003540:	e426                	sd	s1,8(sp)
    80003542:	e04a                	sd	s2,0(sp)
    80003544:	1000                	addi	s0,sp,32
    80003546:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003548:	00850913          	addi	s2,a0,8
    8000354c:	854a                	mv	a0,s2
    8000354e:	5f0020ef          	jal	80005b3e <acquire>
  while (lk->locked) {
    80003552:	409c                	lw	a5,0(s1)
    80003554:	c799                	beqz	a5,80003562 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003556:	85ca                	mv	a1,s2
    80003558:	8526                	mv	a0,s1
    8000355a:	fb9fd0ef          	jal	80001512 <sleep>
  while (lk->locked) {
    8000355e:	409c                	lw	a5,0(s1)
    80003560:	fbfd                	bnez	a5,80003556 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003562:	4785                	li	a5,1
    80003564:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003566:	9b5fd0ef          	jal	80000f1a <myproc>
    8000356a:	5d1c                	lw	a5,56(a0)
    8000356c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000356e:	854a                	mv	a0,s2
    80003570:	666020ef          	jal	80005bd6 <release>
}
    80003574:	60e2                	ld	ra,24(sp)
    80003576:	6442                	ld	s0,16(sp)
    80003578:	64a2                	ld	s1,8(sp)
    8000357a:	6902                	ld	s2,0(sp)
    8000357c:	6105                	addi	sp,sp,32
    8000357e:	8082                	ret

0000000080003580 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003580:	1101                	addi	sp,sp,-32
    80003582:	ec06                	sd	ra,24(sp)
    80003584:	e822                	sd	s0,16(sp)
    80003586:	e426                	sd	s1,8(sp)
    80003588:	e04a                	sd	s2,0(sp)
    8000358a:	1000                	addi	s0,sp,32
    8000358c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000358e:	00850913          	addi	s2,a0,8
    80003592:	854a                	mv	a0,s2
    80003594:	5aa020ef          	jal	80005b3e <acquire>
  lk->locked = 0;
    80003598:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000359c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800035a0:	8526                	mv	a0,s1
    800035a2:	fc7fd0ef          	jal	80001568 <wakeup>
  release(&lk->lk);
    800035a6:	854a                	mv	a0,s2
    800035a8:	62e020ef          	jal	80005bd6 <release>
}
    800035ac:	60e2                	ld	ra,24(sp)
    800035ae:	6442                	ld	s0,16(sp)
    800035b0:	64a2                	ld	s1,8(sp)
    800035b2:	6902                	ld	s2,0(sp)
    800035b4:	6105                	addi	sp,sp,32
    800035b6:	8082                	ret

00000000800035b8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800035b8:	7179                	addi	sp,sp,-48
    800035ba:	f406                	sd	ra,40(sp)
    800035bc:	f022                	sd	s0,32(sp)
    800035be:	ec26                	sd	s1,24(sp)
    800035c0:	e84a                	sd	s2,16(sp)
    800035c2:	1800                	addi	s0,sp,48
    800035c4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800035c6:	00850913          	addi	s2,a0,8
    800035ca:	854a                	mv	a0,s2
    800035cc:	572020ef          	jal	80005b3e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800035d0:	409c                	lw	a5,0(s1)
    800035d2:	ef81                	bnez	a5,800035ea <holdingsleep+0x32>
    800035d4:	4481                	li	s1,0
  release(&lk->lk);
    800035d6:	854a                	mv	a0,s2
    800035d8:	5fe020ef          	jal	80005bd6 <release>
  return r;
}
    800035dc:	8526                	mv	a0,s1
    800035de:	70a2                	ld	ra,40(sp)
    800035e0:	7402                	ld	s0,32(sp)
    800035e2:	64e2                	ld	s1,24(sp)
    800035e4:	6942                	ld	s2,16(sp)
    800035e6:	6145                	addi	sp,sp,48
    800035e8:	8082                	ret
    800035ea:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800035ec:	0284a983          	lw	s3,40(s1)
    800035f0:	92bfd0ef          	jal	80000f1a <myproc>
    800035f4:	5d04                	lw	s1,56(a0)
    800035f6:	413484b3          	sub	s1,s1,s3
    800035fa:	0014b493          	seqz	s1,s1
    800035fe:	69a2                	ld	s3,8(sp)
    80003600:	bfd9                	j	800035d6 <holdingsleep+0x1e>

0000000080003602 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003602:	1141                	addi	sp,sp,-16
    80003604:	e406                	sd	ra,8(sp)
    80003606:	e022                	sd	s0,0(sp)
    80003608:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000360a:	00004597          	auipc	a1,0x4
    8000360e:	f5e58593          	addi	a1,a1,-162 # 80007568 <etext+0x568>
    80003612:	0001d517          	auipc	a0,0x1d
    80003616:	d5e50513          	addi	a0,a0,-674 # 80020370 <ftable>
    8000361a:	4a4020ef          	jal	80005abe <initlock>
}
    8000361e:	60a2                	ld	ra,8(sp)
    80003620:	6402                	ld	s0,0(sp)
    80003622:	0141                	addi	sp,sp,16
    80003624:	8082                	ret

0000000080003626 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003626:	1101                	addi	sp,sp,-32
    80003628:	ec06                	sd	ra,24(sp)
    8000362a:	e822                	sd	s0,16(sp)
    8000362c:	e426                	sd	s1,8(sp)
    8000362e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003630:	0001d517          	auipc	a0,0x1d
    80003634:	d4050513          	addi	a0,a0,-704 # 80020370 <ftable>
    80003638:	506020ef          	jal	80005b3e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000363c:	0001d497          	auipc	s1,0x1d
    80003640:	d4c48493          	addi	s1,s1,-692 # 80020388 <ftable+0x18>
    80003644:	0001e717          	auipc	a4,0x1e
    80003648:	ce470713          	addi	a4,a4,-796 # 80021328 <disk>
    if(f->ref == 0){
    8000364c:	40dc                	lw	a5,4(s1)
    8000364e:	cf89                	beqz	a5,80003668 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003650:	02848493          	addi	s1,s1,40
    80003654:	fee49ce3          	bne	s1,a4,8000364c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003658:	0001d517          	auipc	a0,0x1d
    8000365c:	d1850513          	addi	a0,a0,-744 # 80020370 <ftable>
    80003660:	576020ef          	jal	80005bd6 <release>
  return 0;
    80003664:	4481                	li	s1,0
    80003666:	a809                	j	80003678 <filealloc+0x52>
      f->ref = 1;
    80003668:	4785                	li	a5,1
    8000366a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000366c:	0001d517          	auipc	a0,0x1d
    80003670:	d0450513          	addi	a0,a0,-764 # 80020370 <ftable>
    80003674:	562020ef          	jal	80005bd6 <release>
}
    80003678:	8526                	mv	a0,s1
    8000367a:	60e2                	ld	ra,24(sp)
    8000367c:	6442                	ld	s0,16(sp)
    8000367e:	64a2                	ld	s1,8(sp)
    80003680:	6105                	addi	sp,sp,32
    80003682:	8082                	ret

0000000080003684 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	1000                	addi	s0,sp,32
    8000368e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003690:	0001d517          	auipc	a0,0x1d
    80003694:	ce050513          	addi	a0,a0,-800 # 80020370 <ftable>
    80003698:	4a6020ef          	jal	80005b3e <acquire>
  if(f->ref < 1)
    8000369c:	40dc                	lw	a5,4(s1)
    8000369e:	02f05063          	blez	a5,800036be <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800036a2:	2785                	addiw	a5,a5,1
    800036a4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800036a6:	0001d517          	auipc	a0,0x1d
    800036aa:	cca50513          	addi	a0,a0,-822 # 80020370 <ftable>
    800036ae:	528020ef          	jal	80005bd6 <release>
  return f;
}
    800036b2:	8526                	mv	a0,s1
    800036b4:	60e2                	ld	ra,24(sp)
    800036b6:	6442                	ld	s0,16(sp)
    800036b8:	64a2                	ld	s1,8(sp)
    800036ba:	6105                	addi	sp,sp,32
    800036bc:	8082                	ret
    panic("filedup");
    800036be:	00004517          	auipc	a0,0x4
    800036c2:	eb250513          	addi	a0,a0,-334 # 80007570 <etext+0x570>
    800036c6:	14a020ef          	jal	80005810 <panic>

00000000800036ca <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800036ca:	7139                	addi	sp,sp,-64
    800036cc:	fc06                	sd	ra,56(sp)
    800036ce:	f822                	sd	s0,48(sp)
    800036d0:	f426                	sd	s1,40(sp)
    800036d2:	0080                	addi	s0,sp,64
    800036d4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800036d6:	0001d517          	auipc	a0,0x1d
    800036da:	c9a50513          	addi	a0,a0,-870 # 80020370 <ftable>
    800036de:	460020ef          	jal	80005b3e <acquire>
  if(f->ref < 1)
    800036e2:	40dc                	lw	a5,4(s1)
    800036e4:	04f05a63          	blez	a5,80003738 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800036e8:	37fd                	addiw	a5,a5,-1
    800036ea:	0007871b          	sext.w	a4,a5
    800036ee:	c0dc                	sw	a5,4(s1)
    800036f0:	04e04e63          	bgtz	a4,8000374c <fileclose+0x82>
    800036f4:	f04a                	sd	s2,32(sp)
    800036f6:	ec4e                	sd	s3,24(sp)
    800036f8:	e852                	sd	s4,16(sp)
    800036fa:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800036fc:	0004a903          	lw	s2,0(s1)
    80003700:	0094ca83          	lbu	s5,9(s1)
    80003704:	0104ba03          	ld	s4,16(s1)
    80003708:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000370c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003710:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003714:	0001d517          	auipc	a0,0x1d
    80003718:	c5c50513          	addi	a0,a0,-932 # 80020370 <ftable>
    8000371c:	4ba020ef          	jal	80005bd6 <release>

  if(ff.type == FD_PIPE){
    80003720:	4785                	li	a5,1
    80003722:	04f90063          	beq	s2,a5,80003762 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003726:	3979                	addiw	s2,s2,-2
    80003728:	4785                	li	a5,1
    8000372a:	0527f563          	bgeu	a5,s2,80003774 <fileclose+0xaa>
    8000372e:	7902                	ld	s2,32(sp)
    80003730:	69e2                	ld	s3,24(sp)
    80003732:	6a42                	ld	s4,16(sp)
    80003734:	6aa2                	ld	s5,8(sp)
    80003736:	a00d                	j	80003758 <fileclose+0x8e>
    80003738:	f04a                	sd	s2,32(sp)
    8000373a:	ec4e                	sd	s3,24(sp)
    8000373c:	e852                	sd	s4,16(sp)
    8000373e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003740:	00004517          	auipc	a0,0x4
    80003744:	e3850513          	addi	a0,a0,-456 # 80007578 <etext+0x578>
    80003748:	0c8020ef          	jal	80005810 <panic>
    release(&ftable.lock);
    8000374c:	0001d517          	auipc	a0,0x1d
    80003750:	c2450513          	addi	a0,a0,-988 # 80020370 <ftable>
    80003754:	482020ef          	jal	80005bd6 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003758:	70e2                	ld	ra,56(sp)
    8000375a:	7442                	ld	s0,48(sp)
    8000375c:	74a2                	ld	s1,40(sp)
    8000375e:	6121                	addi	sp,sp,64
    80003760:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003762:	85d6                	mv	a1,s5
    80003764:	8552                	mv	a0,s4
    80003766:	336000ef          	jal	80003a9c <pipeclose>
    8000376a:	7902                	ld	s2,32(sp)
    8000376c:	69e2                	ld	s3,24(sp)
    8000376e:	6a42                	ld	s4,16(sp)
    80003770:	6aa2                	ld	s5,8(sp)
    80003772:	b7dd                	j	80003758 <fileclose+0x8e>
    begin_op();
    80003774:	b3dff0ef          	jal	800032b0 <begin_op>
    iput(ff.ip);
    80003778:	854e                	mv	a0,s3
    8000377a:	c22ff0ef          	jal	80002b9c <iput>
    end_op();
    8000377e:	b9dff0ef          	jal	8000331a <end_op>
    80003782:	7902                	ld	s2,32(sp)
    80003784:	69e2                	ld	s3,24(sp)
    80003786:	6a42                	ld	s4,16(sp)
    80003788:	6aa2                	ld	s5,8(sp)
    8000378a:	b7f9                	j	80003758 <fileclose+0x8e>

000000008000378c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000378c:	715d                	addi	sp,sp,-80
    8000378e:	e486                	sd	ra,72(sp)
    80003790:	e0a2                	sd	s0,64(sp)
    80003792:	fc26                	sd	s1,56(sp)
    80003794:	f44e                	sd	s3,40(sp)
    80003796:	0880                	addi	s0,sp,80
    80003798:	84aa                	mv	s1,a0
    8000379a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000379c:	f7efd0ef          	jal	80000f1a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800037a0:	409c                	lw	a5,0(s1)
    800037a2:	37f9                	addiw	a5,a5,-2
    800037a4:	4705                	li	a4,1
    800037a6:	04f76063          	bltu	a4,a5,800037e6 <filestat+0x5a>
    800037aa:	f84a                	sd	s2,48(sp)
    800037ac:	892a                	mv	s2,a0
    ilock(f->ip);
    800037ae:	6c88                	ld	a0,24(s1)
    800037b0:	a6aff0ef          	jal	80002a1a <ilock>
    stati(f->ip, &st);
    800037b4:	fb840593          	addi	a1,s0,-72
    800037b8:	6c88                	ld	a0,24(s1)
    800037ba:	c8aff0ef          	jal	80002c44 <stati>
    iunlock(f->ip);
    800037be:	6c88                	ld	a0,24(s1)
    800037c0:	b08ff0ef          	jal	80002ac8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800037c4:	46e1                	li	a3,24
    800037c6:	fb840613          	addi	a2,s0,-72
    800037ca:	85ce                	mv	a1,s3
    800037cc:	05893503          	ld	a0,88(s2)
    800037d0:	a36fd0ef          	jal	80000a06 <copyout>
    800037d4:	41f5551b          	sraiw	a0,a0,0x1f
    800037d8:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800037da:	60a6                	ld	ra,72(sp)
    800037dc:	6406                	ld	s0,64(sp)
    800037de:	74e2                	ld	s1,56(sp)
    800037e0:	79a2                	ld	s3,40(sp)
    800037e2:	6161                	addi	sp,sp,80
    800037e4:	8082                	ret
  return -1;
    800037e6:	557d                	li	a0,-1
    800037e8:	bfcd                	j	800037da <filestat+0x4e>

00000000800037ea <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800037ea:	7179                	addi	sp,sp,-48
    800037ec:	f406                	sd	ra,40(sp)
    800037ee:	f022                	sd	s0,32(sp)
    800037f0:	e84a                	sd	s2,16(sp)
    800037f2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800037f4:	00854783          	lbu	a5,8(a0)
    800037f8:	cfd1                	beqz	a5,80003894 <fileread+0xaa>
    800037fa:	ec26                	sd	s1,24(sp)
    800037fc:	e44e                	sd	s3,8(sp)
    800037fe:	84aa                	mv	s1,a0
    80003800:	89ae                	mv	s3,a1
    80003802:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003804:	411c                	lw	a5,0(a0)
    80003806:	4705                	li	a4,1
    80003808:	04e78363          	beq	a5,a4,8000384e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000380c:	470d                	li	a4,3
    8000380e:	04e78763          	beq	a5,a4,8000385c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003812:	4709                	li	a4,2
    80003814:	06e79a63          	bne	a5,a4,80003888 <fileread+0x9e>
    ilock(f->ip);
    80003818:	6d08                	ld	a0,24(a0)
    8000381a:	a00ff0ef          	jal	80002a1a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000381e:	874a                	mv	a4,s2
    80003820:	5094                	lw	a3,32(s1)
    80003822:	864e                	mv	a2,s3
    80003824:	4585                	li	a1,1
    80003826:	6c88                	ld	a0,24(s1)
    80003828:	c46ff0ef          	jal	80002c6e <readi>
    8000382c:	892a                	mv	s2,a0
    8000382e:	00a05563          	blez	a0,80003838 <fileread+0x4e>
      f->off += r;
    80003832:	509c                	lw	a5,32(s1)
    80003834:	9fa9                	addw	a5,a5,a0
    80003836:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003838:	6c88                	ld	a0,24(s1)
    8000383a:	a8eff0ef          	jal	80002ac8 <iunlock>
    8000383e:	64e2                	ld	s1,24(sp)
    80003840:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003842:	854a                	mv	a0,s2
    80003844:	70a2                	ld	ra,40(sp)
    80003846:	7402                	ld	s0,32(sp)
    80003848:	6942                	ld	s2,16(sp)
    8000384a:	6145                	addi	sp,sp,48
    8000384c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000384e:	6908                	ld	a0,16(a0)
    80003850:	388000ef          	jal	80003bd8 <piperead>
    80003854:	892a                	mv	s2,a0
    80003856:	64e2                	ld	s1,24(sp)
    80003858:	69a2                	ld	s3,8(sp)
    8000385a:	b7e5                	j	80003842 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000385c:	02451783          	lh	a5,36(a0)
    80003860:	03079693          	slli	a3,a5,0x30
    80003864:	92c1                	srli	a3,a3,0x30
    80003866:	4725                	li	a4,9
    80003868:	02d76863          	bltu	a4,a3,80003898 <fileread+0xae>
    8000386c:	0792                	slli	a5,a5,0x4
    8000386e:	0001d717          	auipc	a4,0x1d
    80003872:	a6270713          	addi	a4,a4,-1438 # 800202d0 <devsw>
    80003876:	97ba                	add	a5,a5,a4
    80003878:	639c                	ld	a5,0(a5)
    8000387a:	c39d                	beqz	a5,800038a0 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000387c:	4505                	li	a0,1
    8000387e:	9782                	jalr	a5
    80003880:	892a                	mv	s2,a0
    80003882:	64e2                	ld	s1,24(sp)
    80003884:	69a2                	ld	s3,8(sp)
    80003886:	bf75                	j	80003842 <fileread+0x58>
    panic("fileread");
    80003888:	00004517          	auipc	a0,0x4
    8000388c:	d0050513          	addi	a0,a0,-768 # 80007588 <etext+0x588>
    80003890:	781010ef          	jal	80005810 <panic>
    return -1;
    80003894:	597d                	li	s2,-1
    80003896:	b775                	j	80003842 <fileread+0x58>
      return -1;
    80003898:	597d                	li	s2,-1
    8000389a:	64e2                	ld	s1,24(sp)
    8000389c:	69a2                	ld	s3,8(sp)
    8000389e:	b755                	j	80003842 <fileread+0x58>
    800038a0:	597d                	li	s2,-1
    800038a2:	64e2                	ld	s1,24(sp)
    800038a4:	69a2                	ld	s3,8(sp)
    800038a6:	bf71                	j	80003842 <fileread+0x58>

00000000800038a8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800038a8:	00954783          	lbu	a5,9(a0)
    800038ac:	10078b63          	beqz	a5,800039c2 <filewrite+0x11a>
{
    800038b0:	715d                	addi	sp,sp,-80
    800038b2:	e486                	sd	ra,72(sp)
    800038b4:	e0a2                	sd	s0,64(sp)
    800038b6:	f84a                	sd	s2,48(sp)
    800038b8:	f052                	sd	s4,32(sp)
    800038ba:	e85a                	sd	s6,16(sp)
    800038bc:	0880                	addi	s0,sp,80
    800038be:	892a                	mv	s2,a0
    800038c0:	8b2e                	mv	s6,a1
    800038c2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800038c4:	411c                	lw	a5,0(a0)
    800038c6:	4705                	li	a4,1
    800038c8:	02e78763          	beq	a5,a4,800038f6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800038cc:	470d                	li	a4,3
    800038ce:	02e78863          	beq	a5,a4,800038fe <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800038d2:	4709                	li	a4,2
    800038d4:	0ce79c63          	bne	a5,a4,800039ac <filewrite+0x104>
    800038d8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800038da:	0ac05863          	blez	a2,8000398a <filewrite+0xe2>
    800038de:	fc26                	sd	s1,56(sp)
    800038e0:	ec56                	sd	s5,24(sp)
    800038e2:	e45e                	sd	s7,8(sp)
    800038e4:	e062                	sd	s8,0(sp)
    int i = 0;
    800038e6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800038e8:	6b85                	lui	s7,0x1
    800038ea:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800038ee:	6c05                	lui	s8,0x1
    800038f0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800038f4:	a8b5                	j	80003970 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800038f6:	6908                	ld	a0,16(a0)
    800038f8:	1fc000ef          	jal	80003af4 <pipewrite>
    800038fc:	a04d                	j	8000399e <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800038fe:	02451783          	lh	a5,36(a0)
    80003902:	03079693          	slli	a3,a5,0x30
    80003906:	92c1                	srli	a3,a3,0x30
    80003908:	4725                	li	a4,9
    8000390a:	0ad76e63          	bltu	a4,a3,800039c6 <filewrite+0x11e>
    8000390e:	0792                	slli	a5,a5,0x4
    80003910:	0001d717          	auipc	a4,0x1d
    80003914:	9c070713          	addi	a4,a4,-1600 # 800202d0 <devsw>
    80003918:	97ba                	add	a5,a5,a4
    8000391a:	679c                	ld	a5,8(a5)
    8000391c:	c7dd                	beqz	a5,800039ca <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000391e:	4505                	li	a0,1
    80003920:	9782                	jalr	a5
    80003922:	a8b5                	j	8000399e <filewrite+0xf6>
      if(n1 > max)
    80003924:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003928:	989ff0ef          	jal	800032b0 <begin_op>
      ilock(f->ip);
    8000392c:	01893503          	ld	a0,24(s2)
    80003930:	8eaff0ef          	jal	80002a1a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003934:	8756                	mv	a4,s5
    80003936:	02092683          	lw	a3,32(s2)
    8000393a:	01698633          	add	a2,s3,s6
    8000393e:	4585                	li	a1,1
    80003940:	01893503          	ld	a0,24(s2)
    80003944:	c26ff0ef          	jal	80002d6a <writei>
    80003948:	84aa                	mv	s1,a0
    8000394a:	00a05763          	blez	a0,80003958 <filewrite+0xb0>
        f->off += r;
    8000394e:	02092783          	lw	a5,32(s2)
    80003952:	9fa9                	addw	a5,a5,a0
    80003954:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003958:	01893503          	ld	a0,24(s2)
    8000395c:	96cff0ef          	jal	80002ac8 <iunlock>
      end_op();
    80003960:	9bbff0ef          	jal	8000331a <end_op>

      if(r != n1){
    80003964:	029a9563          	bne	s5,s1,8000398e <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003968:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000396c:	0149da63          	bge	s3,s4,80003980 <filewrite+0xd8>
      int n1 = n - i;
    80003970:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003974:	0004879b          	sext.w	a5,s1
    80003978:	fafbd6e3          	bge	s7,a5,80003924 <filewrite+0x7c>
    8000397c:	84e2                	mv	s1,s8
    8000397e:	b75d                	j	80003924 <filewrite+0x7c>
    80003980:	74e2                	ld	s1,56(sp)
    80003982:	6ae2                	ld	s5,24(sp)
    80003984:	6ba2                	ld	s7,8(sp)
    80003986:	6c02                	ld	s8,0(sp)
    80003988:	a039                	j	80003996 <filewrite+0xee>
    int i = 0;
    8000398a:	4981                	li	s3,0
    8000398c:	a029                	j	80003996 <filewrite+0xee>
    8000398e:	74e2                	ld	s1,56(sp)
    80003990:	6ae2                	ld	s5,24(sp)
    80003992:	6ba2                	ld	s7,8(sp)
    80003994:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003996:	033a1c63          	bne	s4,s3,800039ce <filewrite+0x126>
    8000399a:	8552                	mv	a0,s4
    8000399c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000399e:	60a6                	ld	ra,72(sp)
    800039a0:	6406                	ld	s0,64(sp)
    800039a2:	7942                	ld	s2,48(sp)
    800039a4:	7a02                	ld	s4,32(sp)
    800039a6:	6b42                	ld	s6,16(sp)
    800039a8:	6161                	addi	sp,sp,80
    800039aa:	8082                	ret
    800039ac:	fc26                	sd	s1,56(sp)
    800039ae:	f44e                	sd	s3,40(sp)
    800039b0:	ec56                	sd	s5,24(sp)
    800039b2:	e45e                	sd	s7,8(sp)
    800039b4:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800039b6:	00004517          	auipc	a0,0x4
    800039ba:	be250513          	addi	a0,a0,-1054 # 80007598 <etext+0x598>
    800039be:	653010ef          	jal	80005810 <panic>
    return -1;
    800039c2:	557d                	li	a0,-1
}
    800039c4:	8082                	ret
      return -1;
    800039c6:	557d                	li	a0,-1
    800039c8:	bfd9                	j	8000399e <filewrite+0xf6>
    800039ca:	557d                	li	a0,-1
    800039cc:	bfc9                	j	8000399e <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800039ce:	557d                	li	a0,-1
    800039d0:	79a2                	ld	s3,40(sp)
    800039d2:	b7f1                	j	8000399e <filewrite+0xf6>

00000000800039d4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800039d4:	7179                	addi	sp,sp,-48
    800039d6:	f406                	sd	ra,40(sp)
    800039d8:	f022                	sd	s0,32(sp)
    800039da:	ec26                	sd	s1,24(sp)
    800039dc:	e052                	sd	s4,0(sp)
    800039de:	1800                	addi	s0,sp,48
    800039e0:	84aa                	mv	s1,a0
    800039e2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800039e4:	0005b023          	sd	zero,0(a1)
    800039e8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800039ec:	c3bff0ef          	jal	80003626 <filealloc>
    800039f0:	e088                	sd	a0,0(s1)
    800039f2:	c549                	beqz	a0,80003a7c <pipealloc+0xa8>
    800039f4:	c33ff0ef          	jal	80003626 <filealloc>
    800039f8:	00aa3023          	sd	a0,0(s4)
    800039fc:	cd25                	beqz	a0,80003a74 <pipealloc+0xa0>
    800039fe:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003a00:	ef6fc0ef          	jal	800000f6 <kalloc>
    80003a04:	892a                	mv	s2,a0
    80003a06:	c12d                	beqz	a0,80003a68 <pipealloc+0x94>
    80003a08:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003a0a:	4985                	li	s3,1
    80003a0c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003a10:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003a14:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003a18:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003a1c:	00004597          	auipc	a1,0x4
    80003a20:	b8c58593          	addi	a1,a1,-1140 # 800075a8 <etext+0x5a8>
    80003a24:	09a020ef          	jal	80005abe <initlock>
  (*f0)->type = FD_PIPE;
    80003a28:	609c                	ld	a5,0(s1)
    80003a2a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003a2e:	609c                	ld	a5,0(s1)
    80003a30:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003a34:	609c                	ld	a5,0(s1)
    80003a36:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003a3a:	609c                	ld	a5,0(s1)
    80003a3c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003a40:	000a3783          	ld	a5,0(s4)
    80003a44:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003a48:	000a3783          	ld	a5,0(s4)
    80003a4c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003a50:	000a3783          	ld	a5,0(s4)
    80003a54:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003a58:	000a3783          	ld	a5,0(s4)
    80003a5c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003a60:	4501                	li	a0,0
    80003a62:	6942                	ld	s2,16(sp)
    80003a64:	69a2                	ld	s3,8(sp)
    80003a66:	a01d                	j	80003a8c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003a68:	6088                	ld	a0,0(s1)
    80003a6a:	c119                	beqz	a0,80003a70 <pipealloc+0x9c>
    80003a6c:	6942                	ld	s2,16(sp)
    80003a6e:	a029                	j	80003a78 <pipealloc+0xa4>
    80003a70:	6942                	ld	s2,16(sp)
    80003a72:	a029                	j	80003a7c <pipealloc+0xa8>
    80003a74:	6088                	ld	a0,0(s1)
    80003a76:	c10d                	beqz	a0,80003a98 <pipealloc+0xc4>
    fileclose(*f0);
    80003a78:	c53ff0ef          	jal	800036ca <fileclose>
  if(*f1)
    80003a7c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003a80:	557d                	li	a0,-1
  if(*f1)
    80003a82:	c789                	beqz	a5,80003a8c <pipealloc+0xb8>
    fileclose(*f1);
    80003a84:	853e                	mv	a0,a5
    80003a86:	c45ff0ef          	jal	800036ca <fileclose>
  return -1;
    80003a8a:	557d                	li	a0,-1
}
    80003a8c:	70a2                	ld	ra,40(sp)
    80003a8e:	7402                	ld	s0,32(sp)
    80003a90:	64e2                	ld	s1,24(sp)
    80003a92:	6a02                	ld	s4,0(sp)
    80003a94:	6145                	addi	sp,sp,48
    80003a96:	8082                	ret
  return -1;
    80003a98:	557d                	li	a0,-1
    80003a9a:	bfcd                	j	80003a8c <pipealloc+0xb8>

0000000080003a9c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003a9c:	1101                	addi	sp,sp,-32
    80003a9e:	ec06                	sd	ra,24(sp)
    80003aa0:	e822                	sd	s0,16(sp)
    80003aa2:	e426                	sd	s1,8(sp)
    80003aa4:	e04a                	sd	s2,0(sp)
    80003aa6:	1000                	addi	s0,sp,32
    80003aa8:	84aa                	mv	s1,a0
    80003aaa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003aac:	092020ef          	jal	80005b3e <acquire>
  if(writable){
    80003ab0:	02090763          	beqz	s2,80003ade <pipeclose+0x42>
    pi->writeopen = 0;
    80003ab4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ab8:	21848513          	addi	a0,s1,536
    80003abc:	aadfd0ef          	jal	80001568 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ac0:	2204b783          	ld	a5,544(s1)
    80003ac4:	e785                	bnez	a5,80003aec <pipeclose+0x50>
    release(&pi->lock);
    80003ac6:	8526                	mv	a0,s1
    80003ac8:	10e020ef          	jal	80005bd6 <release>
    kfree((char*)pi);
    80003acc:	8526                	mv	a0,s1
    80003ace:	d4efc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ad2:	60e2                	ld	ra,24(sp)
    80003ad4:	6442                	ld	s0,16(sp)
    80003ad6:	64a2                	ld	s1,8(sp)
    80003ad8:	6902                	ld	s2,0(sp)
    80003ada:	6105                	addi	sp,sp,32
    80003adc:	8082                	ret
    pi->readopen = 0;
    80003ade:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ae2:	21c48513          	addi	a0,s1,540
    80003ae6:	a83fd0ef          	jal	80001568 <wakeup>
    80003aea:	bfd9                	j	80003ac0 <pipeclose+0x24>
    release(&pi->lock);
    80003aec:	8526                	mv	a0,s1
    80003aee:	0e8020ef          	jal	80005bd6 <release>
}
    80003af2:	b7c5                	j	80003ad2 <pipeclose+0x36>

0000000080003af4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003af4:	711d                	addi	sp,sp,-96
    80003af6:	ec86                	sd	ra,88(sp)
    80003af8:	e8a2                	sd	s0,80(sp)
    80003afa:	e4a6                	sd	s1,72(sp)
    80003afc:	e0ca                	sd	s2,64(sp)
    80003afe:	fc4e                	sd	s3,56(sp)
    80003b00:	f852                	sd	s4,48(sp)
    80003b02:	f456                	sd	s5,40(sp)
    80003b04:	1080                	addi	s0,sp,96
    80003b06:	84aa                	mv	s1,a0
    80003b08:	8aae                	mv	s5,a1
    80003b0a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003b0c:	c0efd0ef          	jal	80000f1a <myproc>
    80003b10:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003b12:	8526                	mv	a0,s1
    80003b14:	02a020ef          	jal	80005b3e <acquire>
  while(i < n){
    80003b18:	0b405a63          	blez	s4,80003bcc <pipewrite+0xd8>
    80003b1c:	f05a                	sd	s6,32(sp)
    80003b1e:	ec5e                	sd	s7,24(sp)
    80003b20:	e862                	sd	s8,16(sp)
  int i = 0;
    80003b22:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b24:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003b26:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003b2a:	21c48b93          	addi	s7,s1,540
    80003b2e:	a81d                	j	80003b64 <pipewrite+0x70>
      release(&pi->lock);
    80003b30:	8526                	mv	a0,s1
    80003b32:	0a4020ef          	jal	80005bd6 <release>
      return -1;
    80003b36:	597d                	li	s2,-1
    80003b38:	7b02                	ld	s6,32(sp)
    80003b3a:	6be2                	ld	s7,24(sp)
    80003b3c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003b3e:	854a                	mv	a0,s2
    80003b40:	60e6                	ld	ra,88(sp)
    80003b42:	6446                	ld	s0,80(sp)
    80003b44:	64a6                	ld	s1,72(sp)
    80003b46:	6906                	ld	s2,64(sp)
    80003b48:	79e2                	ld	s3,56(sp)
    80003b4a:	7a42                	ld	s4,48(sp)
    80003b4c:	7aa2                	ld	s5,40(sp)
    80003b4e:	6125                	addi	sp,sp,96
    80003b50:	8082                	ret
      wakeup(&pi->nread);
    80003b52:	8562                	mv	a0,s8
    80003b54:	a15fd0ef          	jal	80001568 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003b58:	85a6                	mv	a1,s1
    80003b5a:	855e                	mv	a0,s7
    80003b5c:	9b7fd0ef          	jal	80001512 <sleep>
  while(i < n){
    80003b60:	05495b63          	bge	s2,s4,80003bb6 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003b64:	2204a783          	lw	a5,544(s1)
    80003b68:	d7e1                	beqz	a5,80003b30 <pipewrite+0x3c>
    80003b6a:	854e                	mv	a0,s3
    80003b6c:	c05fd0ef          	jal	80001770 <killed>
    80003b70:	f161                	bnez	a0,80003b30 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003b72:	2184a783          	lw	a5,536(s1)
    80003b76:	21c4a703          	lw	a4,540(s1)
    80003b7a:	2007879b          	addiw	a5,a5,512
    80003b7e:	fcf70ae3          	beq	a4,a5,80003b52 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003b82:	4685                	li	a3,1
    80003b84:	01590633          	add	a2,s2,s5
    80003b88:	faf40593          	addi	a1,s0,-81
    80003b8c:	0589b503          	ld	a0,88(s3)
    80003b90:	f4ffc0ef          	jal	80000ade <copyin>
    80003b94:	03650e63          	beq	a0,s6,80003bd0 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003b98:	21c4a783          	lw	a5,540(s1)
    80003b9c:	0017871b          	addiw	a4,a5,1
    80003ba0:	20e4ae23          	sw	a4,540(s1)
    80003ba4:	1ff7f793          	andi	a5,a5,511
    80003ba8:	97a6                	add	a5,a5,s1
    80003baa:	faf44703          	lbu	a4,-81(s0)
    80003bae:	00e78c23          	sb	a4,24(a5)
      i++;
    80003bb2:	2905                	addiw	s2,s2,1
    80003bb4:	b775                	j	80003b60 <pipewrite+0x6c>
    80003bb6:	7b02                	ld	s6,32(sp)
    80003bb8:	6be2                	ld	s7,24(sp)
    80003bba:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003bbc:	21848513          	addi	a0,s1,536
    80003bc0:	9a9fd0ef          	jal	80001568 <wakeup>
  release(&pi->lock);
    80003bc4:	8526                	mv	a0,s1
    80003bc6:	010020ef          	jal	80005bd6 <release>
  return i;
    80003bca:	bf95                	j	80003b3e <pipewrite+0x4a>
  int i = 0;
    80003bcc:	4901                	li	s2,0
    80003bce:	b7fd                	j	80003bbc <pipewrite+0xc8>
    80003bd0:	7b02                	ld	s6,32(sp)
    80003bd2:	6be2                	ld	s7,24(sp)
    80003bd4:	6c42                	ld	s8,16(sp)
    80003bd6:	b7dd                	j	80003bbc <pipewrite+0xc8>

0000000080003bd8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003bd8:	715d                	addi	sp,sp,-80
    80003bda:	e486                	sd	ra,72(sp)
    80003bdc:	e0a2                	sd	s0,64(sp)
    80003bde:	fc26                	sd	s1,56(sp)
    80003be0:	f84a                	sd	s2,48(sp)
    80003be2:	f44e                	sd	s3,40(sp)
    80003be4:	f052                	sd	s4,32(sp)
    80003be6:	ec56                	sd	s5,24(sp)
    80003be8:	0880                	addi	s0,sp,80
    80003bea:	84aa                	mv	s1,a0
    80003bec:	892e                	mv	s2,a1
    80003bee:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003bf0:	b2afd0ef          	jal	80000f1a <myproc>
    80003bf4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003bf6:	8526                	mv	a0,s1
    80003bf8:	747010ef          	jal	80005b3e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003bfc:	2184a703          	lw	a4,536(s1)
    80003c00:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c04:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c08:	02f71563          	bne	a4,a5,80003c32 <piperead+0x5a>
    80003c0c:	2244a783          	lw	a5,548(s1)
    80003c10:	cb85                	beqz	a5,80003c40 <piperead+0x68>
    if(killed(pr)){
    80003c12:	8552                	mv	a0,s4
    80003c14:	b5dfd0ef          	jal	80001770 <killed>
    80003c18:	ed19                	bnez	a0,80003c36 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c1a:	85a6                	mv	a1,s1
    80003c1c:	854e                	mv	a0,s3
    80003c1e:	8f5fd0ef          	jal	80001512 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c22:	2184a703          	lw	a4,536(s1)
    80003c26:	21c4a783          	lw	a5,540(s1)
    80003c2a:	fef701e3          	beq	a4,a5,80003c0c <piperead+0x34>
    80003c2e:	e85a                	sd	s6,16(sp)
    80003c30:	a809                	j	80003c42 <piperead+0x6a>
    80003c32:	e85a                	sd	s6,16(sp)
    80003c34:	a039                	j	80003c42 <piperead+0x6a>
      release(&pi->lock);
    80003c36:	8526                	mv	a0,s1
    80003c38:	79f010ef          	jal	80005bd6 <release>
      return -1;
    80003c3c:	59fd                	li	s3,-1
    80003c3e:	a8b1                	j	80003c9a <piperead+0xc2>
    80003c40:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c42:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c44:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c46:	05505263          	blez	s5,80003c8a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003c4a:	2184a783          	lw	a5,536(s1)
    80003c4e:	21c4a703          	lw	a4,540(s1)
    80003c52:	02f70c63          	beq	a4,a5,80003c8a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003c56:	0017871b          	addiw	a4,a5,1
    80003c5a:	20e4ac23          	sw	a4,536(s1)
    80003c5e:	1ff7f793          	andi	a5,a5,511
    80003c62:	97a6                	add	a5,a5,s1
    80003c64:	0187c783          	lbu	a5,24(a5)
    80003c68:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003c6c:	4685                	li	a3,1
    80003c6e:	fbf40613          	addi	a2,s0,-65
    80003c72:	85ca                	mv	a1,s2
    80003c74:	058a3503          	ld	a0,88(s4)
    80003c78:	d8ffc0ef          	jal	80000a06 <copyout>
    80003c7c:	01650763          	beq	a0,s6,80003c8a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003c80:	2985                	addiw	s3,s3,1
    80003c82:	0905                	addi	s2,s2,1
    80003c84:	fd3a93e3          	bne	s5,s3,80003c4a <piperead+0x72>
    80003c88:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003c8a:	21c48513          	addi	a0,s1,540
    80003c8e:	8dbfd0ef          	jal	80001568 <wakeup>
  release(&pi->lock);
    80003c92:	8526                	mv	a0,s1
    80003c94:	743010ef          	jal	80005bd6 <release>
    80003c98:	6b42                	ld	s6,16(sp)
  return i;
}
    80003c9a:	854e                	mv	a0,s3
    80003c9c:	60a6                	ld	ra,72(sp)
    80003c9e:	6406                	ld	s0,64(sp)
    80003ca0:	74e2                	ld	s1,56(sp)
    80003ca2:	7942                	ld	s2,48(sp)
    80003ca4:	79a2                	ld	s3,40(sp)
    80003ca6:	7a02                	ld	s4,32(sp)
    80003ca8:	6ae2                	ld	s5,24(sp)
    80003caa:	6161                	addi	sp,sp,80
    80003cac:	8082                	ret

0000000080003cae <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003cae:	1141                	addi	sp,sp,-16
    80003cb0:	e422                	sd	s0,8(sp)
    80003cb2:	0800                	addi	s0,sp,16
    80003cb4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003cb6:	8905                	andi	a0,a0,1
    80003cb8:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003cba:	8b89                	andi	a5,a5,2
    80003cbc:	c399                	beqz	a5,80003cc2 <flags2perm+0x14>
      perm |= PTE_W;
    80003cbe:	00456513          	ori	a0,a0,4
    return perm;
}
    80003cc2:	6422                	ld	s0,8(sp)
    80003cc4:	0141                	addi	sp,sp,16
    80003cc6:	8082                	ret

0000000080003cc8 <exec>:

int
exec(char *path, char **argv)
{
    80003cc8:	df010113          	addi	sp,sp,-528
    80003ccc:	20113423          	sd	ra,520(sp)
    80003cd0:	20813023          	sd	s0,512(sp)
    80003cd4:	ffa6                	sd	s1,504(sp)
    80003cd6:	fbca                	sd	s2,496(sp)
    80003cd8:	0c00                	addi	s0,sp,528
    80003cda:	892a                	mv	s2,a0
    80003cdc:	dea43c23          	sd	a0,-520(s0)
    80003ce0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ce4:	a36fd0ef          	jal	80000f1a <myproc>
    80003ce8:	84aa                	mv	s1,a0

  begin_op();
    80003cea:	dc6ff0ef          	jal	800032b0 <begin_op>

  if((ip = namei(path)) == 0){
    80003cee:	854a                	mv	a0,s2
    80003cf0:	c04ff0ef          	jal	800030f4 <namei>
    80003cf4:	c931                	beqz	a0,80003d48 <exec+0x80>
    80003cf6:	f3d2                	sd	s4,480(sp)
    80003cf8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003cfa:	d21fe0ef          	jal	80002a1a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003cfe:	04000713          	li	a4,64
    80003d02:	4681                	li	a3,0
    80003d04:	e5040613          	addi	a2,s0,-432
    80003d08:	4581                	li	a1,0
    80003d0a:	8552                	mv	a0,s4
    80003d0c:	f63fe0ef          	jal	80002c6e <readi>
    80003d10:	04000793          	li	a5,64
    80003d14:	00f51a63          	bne	a0,a5,80003d28 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003d18:	e5042703          	lw	a4,-432(s0)
    80003d1c:	464c47b7          	lui	a5,0x464c4
    80003d20:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003d24:	02f70663          	beq	a4,a5,80003d50 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003d28:	8552                	mv	a0,s4
    80003d2a:	efbfe0ef          	jal	80002c24 <iunlockput>
    end_op();
    80003d2e:	decff0ef          	jal	8000331a <end_op>
  }
  return -1;
    80003d32:	557d                	li	a0,-1
    80003d34:	7a1e                	ld	s4,480(sp)
}
    80003d36:	20813083          	ld	ra,520(sp)
    80003d3a:	20013403          	ld	s0,512(sp)
    80003d3e:	74fe                	ld	s1,504(sp)
    80003d40:	795e                	ld	s2,496(sp)
    80003d42:	21010113          	addi	sp,sp,528
    80003d46:	8082                	ret
    end_op();
    80003d48:	dd2ff0ef          	jal	8000331a <end_op>
    return -1;
    80003d4c:	557d                	li	a0,-1
    80003d4e:	b7e5                	j	80003d36 <exec+0x6e>
    80003d50:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003d52:	8526                	mv	a0,s1
    80003d54:	a70fd0ef          	jal	80000fc4 <proc_pagetable>
    80003d58:	8b2a                	mv	s6,a0
    80003d5a:	2c050b63          	beqz	a0,80004030 <exec+0x368>
    80003d5e:	f7ce                	sd	s3,488(sp)
    80003d60:	efd6                	sd	s5,472(sp)
    80003d62:	e7de                	sd	s7,456(sp)
    80003d64:	e3e2                	sd	s8,448(sp)
    80003d66:	ff66                	sd	s9,440(sp)
    80003d68:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d6a:	e7042d03          	lw	s10,-400(s0)
    80003d6e:	e8845783          	lhu	a5,-376(s0)
    80003d72:	12078963          	beqz	a5,80003ea4 <exec+0x1dc>
    80003d76:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d78:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d7a:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003d7c:	6c85                	lui	s9,0x1
    80003d7e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003d82:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003d86:	6a85                	lui	s5,0x1
    80003d88:	a085                	j	80003de8 <exec+0x120>
      panic("loadseg: address should exist");
    80003d8a:	00004517          	auipc	a0,0x4
    80003d8e:	82650513          	addi	a0,a0,-2010 # 800075b0 <etext+0x5b0>
    80003d92:	27f010ef          	jal	80005810 <panic>
    if(sz - i < PGSIZE)
    80003d96:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003d98:	8726                	mv	a4,s1
    80003d9a:	012c06bb          	addw	a3,s8,s2
    80003d9e:	4581                	li	a1,0
    80003da0:	8552                	mv	a0,s4
    80003da2:	ecdfe0ef          	jal	80002c6e <readi>
    80003da6:	2501                	sext.w	a0,a0
    80003da8:	24a49a63          	bne	s1,a0,80003ffc <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003dac:	012a893b          	addw	s2,s5,s2
    80003db0:	03397363          	bgeu	s2,s3,80003dd6 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003db4:	02091593          	slli	a1,s2,0x20
    80003db8:	9181                	srli	a1,a1,0x20
    80003dba:	95de                	add	a1,a1,s7
    80003dbc:	855a                	mv	a0,s6
    80003dbe:	ec4fc0ef          	jal	80000482 <walkaddr>
    80003dc2:	862a                	mv	a2,a0
    if(pa == 0)
    80003dc4:	d179                	beqz	a0,80003d8a <exec+0xc2>
    if(sz - i < PGSIZE)
    80003dc6:	412984bb          	subw	s1,s3,s2
    80003dca:	0004879b          	sext.w	a5,s1
    80003dce:	fcfcf4e3          	bgeu	s9,a5,80003d96 <exec+0xce>
    80003dd2:	84d6                	mv	s1,s5
    80003dd4:	b7c9                	j	80003d96 <exec+0xce>
    sz = sz1;
    80003dd6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003dda:	2d85                	addiw	s11,s11,1
    80003ddc:	038d0d1b          	addiw	s10,s10,56
    80003de0:	e8845783          	lhu	a5,-376(s0)
    80003de4:	08fdd063          	bge	s11,a5,80003e64 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003de8:	2d01                	sext.w	s10,s10
    80003dea:	03800713          	li	a4,56
    80003dee:	86ea                	mv	a3,s10
    80003df0:	e1840613          	addi	a2,s0,-488
    80003df4:	4581                	li	a1,0
    80003df6:	8552                	mv	a0,s4
    80003df8:	e77fe0ef          	jal	80002c6e <readi>
    80003dfc:	03800793          	li	a5,56
    80003e00:	1cf51663          	bne	a0,a5,80003fcc <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003e04:	e1842783          	lw	a5,-488(s0)
    80003e08:	4705                	li	a4,1
    80003e0a:	fce798e3          	bne	a5,a4,80003dda <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003e0e:	e4043483          	ld	s1,-448(s0)
    80003e12:	e3843783          	ld	a5,-456(s0)
    80003e16:	1af4ef63          	bltu	s1,a5,80003fd4 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003e1a:	e2843783          	ld	a5,-472(s0)
    80003e1e:	94be                	add	s1,s1,a5
    80003e20:	1af4ee63          	bltu	s1,a5,80003fdc <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003e24:	df043703          	ld	a4,-528(s0)
    80003e28:	8ff9                	and	a5,a5,a4
    80003e2a:	1a079d63          	bnez	a5,80003fe4 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003e2e:	e1c42503          	lw	a0,-484(s0)
    80003e32:	e7dff0ef          	jal	80003cae <flags2perm>
    80003e36:	86aa                	mv	a3,a0
    80003e38:	8626                	mv	a2,s1
    80003e3a:	85ca                	mv	a1,s2
    80003e3c:	855a                	mv	a0,s6
    80003e3e:	9bdfc0ef          	jal	800007fa <uvmalloc>
    80003e42:	e0a43423          	sd	a0,-504(s0)
    80003e46:	1a050363          	beqz	a0,80003fec <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003e4a:	e2843b83          	ld	s7,-472(s0)
    80003e4e:	e2042c03          	lw	s8,-480(s0)
    80003e52:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003e56:	00098463          	beqz	s3,80003e5e <exec+0x196>
    80003e5a:	4901                	li	s2,0
    80003e5c:	bfa1                	j	80003db4 <exec+0xec>
    sz = sz1;
    80003e5e:	e0843903          	ld	s2,-504(s0)
    80003e62:	bfa5                	j	80003dda <exec+0x112>
    80003e64:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003e66:	8552                	mv	a0,s4
    80003e68:	dbdfe0ef          	jal	80002c24 <iunlockput>
  end_op();
    80003e6c:	caeff0ef          	jal	8000331a <end_op>
  p = myproc();
    80003e70:	8aafd0ef          	jal	80000f1a <myproc>
    80003e74:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003e76:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80003e7a:	6985                	lui	s3,0x1
    80003e7c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003e7e:	99ca                	add	s3,s3,s2
    80003e80:	77fd                	lui	a5,0xfffff
    80003e82:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003e86:	4691                	li	a3,4
    80003e88:	6609                	lui	a2,0x2
    80003e8a:	964e                	add	a2,a2,s3
    80003e8c:	85ce                	mv	a1,s3
    80003e8e:	855a                	mv	a0,s6
    80003e90:	96bfc0ef          	jal	800007fa <uvmalloc>
    80003e94:	892a                	mv	s2,a0
    80003e96:	e0a43423          	sd	a0,-504(s0)
    80003e9a:	e519                	bnez	a0,80003ea8 <exec+0x1e0>
  if(pagetable)
    80003e9c:	e1343423          	sd	s3,-504(s0)
    80003ea0:	4a01                	li	s4,0
    80003ea2:	aab1                	j	80003ffe <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ea4:	4901                	li	s2,0
    80003ea6:	b7c1                	j	80003e66 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ea8:	75f9                	lui	a1,0xffffe
    80003eaa:	95aa                	add	a1,a1,a0
    80003eac:	855a                	mv	a0,s6
    80003eae:	b2ffc0ef          	jal	800009dc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003eb2:	7bfd                	lui	s7,0xfffff
    80003eb4:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003eb6:	e0043783          	ld	a5,-512(s0)
    80003eba:	6388                	ld	a0,0(a5)
    80003ebc:	cd39                	beqz	a0,80003f1a <exec+0x252>
    80003ebe:	e9040993          	addi	s3,s0,-368
    80003ec2:	f9040c13          	addi	s8,s0,-112
    80003ec6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003ec8:	c1cfc0ef          	jal	800002e4 <strlen>
    80003ecc:	0015079b          	addiw	a5,a0,1
    80003ed0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003ed4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003ed8:	11796e63          	bltu	s2,s7,80003ff4 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003edc:	e0043d03          	ld	s10,-512(s0)
    80003ee0:	000d3a03          	ld	s4,0(s10)
    80003ee4:	8552                	mv	a0,s4
    80003ee6:	bfefc0ef          	jal	800002e4 <strlen>
    80003eea:	0015069b          	addiw	a3,a0,1
    80003eee:	8652                	mv	a2,s4
    80003ef0:	85ca                	mv	a1,s2
    80003ef2:	855a                	mv	a0,s6
    80003ef4:	b13fc0ef          	jal	80000a06 <copyout>
    80003ef8:	10054063          	bltz	a0,80003ff8 <exec+0x330>
    ustack[argc] = sp;
    80003efc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003f00:	0485                	addi	s1,s1,1
    80003f02:	008d0793          	addi	a5,s10,8
    80003f06:	e0f43023          	sd	a5,-512(s0)
    80003f0a:	008d3503          	ld	a0,8(s10)
    80003f0e:	c909                	beqz	a0,80003f20 <exec+0x258>
    if(argc >= MAXARG)
    80003f10:	09a1                	addi	s3,s3,8
    80003f12:	fb899be3          	bne	s3,s8,80003ec8 <exec+0x200>
  ip = 0;
    80003f16:	4a01                	li	s4,0
    80003f18:	a0dd                	j	80003ffe <exec+0x336>
  sp = sz;
    80003f1a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003f1e:	4481                	li	s1,0
  ustack[argc] = 0;
    80003f20:	00349793          	slli	a5,s1,0x3
    80003f24:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5a00>
    80003f28:	97a2                	add	a5,a5,s0
    80003f2a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003f2e:	00148693          	addi	a3,s1,1
    80003f32:	068e                	slli	a3,a3,0x3
    80003f34:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003f38:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003f3c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003f40:	f5796ee3          	bltu	s2,s7,80003e9c <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003f44:	e9040613          	addi	a2,s0,-368
    80003f48:	85ca                	mv	a1,s2
    80003f4a:	855a                	mv	a0,s6
    80003f4c:	abbfc0ef          	jal	80000a06 <copyout>
    80003f50:	0e054263          	bltz	a0,80004034 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003f54:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80003f58:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003f5c:	df843783          	ld	a5,-520(s0)
    80003f60:	0007c703          	lbu	a4,0(a5)
    80003f64:	cf11                	beqz	a4,80003f80 <exec+0x2b8>
    80003f66:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003f68:	02f00693          	li	a3,47
    80003f6c:	a039                	j	80003f7a <exec+0x2b2>
      last = s+1;
    80003f6e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003f72:	0785                	addi	a5,a5,1
    80003f74:	fff7c703          	lbu	a4,-1(a5)
    80003f78:	c701                	beqz	a4,80003f80 <exec+0x2b8>
    if(*s == '/')
    80003f7a:	fed71ce3          	bne	a4,a3,80003f72 <exec+0x2aa>
    80003f7e:	bfc5                	j	80003f6e <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003f80:	4641                	li	a2,16
    80003f82:	df843583          	ld	a1,-520(s0)
    80003f86:	160a8513          	addi	a0,s5,352
    80003f8a:	b28fc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003f8e:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80003f92:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80003f96:	e0843783          	ld	a5,-504(s0)
    80003f9a:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003f9e:	060ab783          	ld	a5,96(s5)
    80003fa2:	e6843703          	ld	a4,-408(s0)
    80003fa6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003fa8:	060ab783          	ld	a5,96(s5)
    80003fac:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003fb0:	85e6                	mv	a1,s9
    80003fb2:	896fd0ef          	jal	80001048 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003fb6:	0004851b          	sext.w	a0,s1
    80003fba:	79be                	ld	s3,488(sp)
    80003fbc:	7a1e                	ld	s4,480(sp)
    80003fbe:	6afe                	ld	s5,472(sp)
    80003fc0:	6b5e                	ld	s6,464(sp)
    80003fc2:	6bbe                	ld	s7,456(sp)
    80003fc4:	6c1e                	ld	s8,448(sp)
    80003fc6:	7cfa                	ld	s9,440(sp)
    80003fc8:	7d5a                	ld	s10,432(sp)
    80003fca:	b3b5                	j	80003d36 <exec+0x6e>
    80003fcc:	e1243423          	sd	s2,-504(s0)
    80003fd0:	7dba                	ld	s11,424(sp)
    80003fd2:	a035                	j	80003ffe <exec+0x336>
    80003fd4:	e1243423          	sd	s2,-504(s0)
    80003fd8:	7dba                	ld	s11,424(sp)
    80003fda:	a015                	j	80003ffe <exec+0x336>
    80003fdc:	e1243423          	sd	s2,-504(s0)
    80003fe0:	7dba                	ld	s11,424(sp)
    80003fe2:	a831                	j	80003ffe <exec+0x336>
    80003fe4:	e1243423          	sd	s2,-504(s0)
    80003fe8:	7dba                	ld	s11,424(sp)
    80003fea:	a811                	j	80003ffe <exec+0x336>
    80003fec:	e1243423          	sd	s2,-504(s0)
    80003ff0:	7dba                	ld	s11,424(sp)
    80003ff2:	a031                	j	80003ffe <exec+0x336>
  ip = 0;
    80003ff4:	4a01                	li	s4,0
    80003ff6:	a021                	j	80003ffe <exec+0x336>
    80003ff8:	4a01                	li	s4,0
  if(pagetable)
    80003ffa:	a011                	j	80003ffe <exec+0x336>
    80003ffc:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003ffe:	e0843583          	ld	a1,-504(s0)
    80004002:	855a                	mv	a0,s6
    80004004:	844fd0ef          	jal	80001048 <proc_freepagetable>
  return -1;
    80004008:	557d                	li	a0,-1
  if(ip){
    8000400a:	000a1b63          	bnez	s4,80004020 <exec+0x358>
    8000400e:	79be                	ld	s3,488(sp)
    80004010:	7a1e                	ld	s4,480(sp)
    80004012:	6afe                	ld	s5,472(sp)
    80004014:	6b5e                	ld	s6,464(sp)
    80004016:	6bbe                	ld	s7,456(sp)
    80004018:	6c1e                	ld	s8,448(sp)
    8000401a:	7cfa                	ld	s9,440(sp)
    8000401c:	7d5a                	ld	s10,432(sp)
    8000401e:	bb21                	j	80003d36 <exec+0x6e>
    80004020:	79be                	ld	s3,488(sp)
    80004022:	6afe                	ld	s5,472(sp)
    80004024:	6b5e                	ld	s6,464(sp)
    80004026:	6bbe                	ld	s7,456(sp)
    80004028:	6c1e                	ld	s8,448(sp)
    8000402a:	7cfa                	ld	s9,440(sp)
    8000402c:	7d5a                	ld	s10,432(sp)
    8000402e:	b9ed                	j	80003d28 <exec+0x60>
    80004030:	6b5e                	ld	s6,464(sp)
    80004032:	b9dd                	j	80003d28 <exec+0x60>
  sz = sz1;
    80004034:	e0843983          	ld	s3,-504(s0)
    80004038:	b595                	j	80003e9c <exec+0x1d4>

000000008000403a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000403a:	7179                	addi	sp,sp,-48
    8000403c:	f406                	sd	ra,40(sp)
    8000403e:	f022                	sd	s0,32(sp)
    80004040:	ec26                	sd	s1,24(sp)
    80004042:	e84a                	sd	s2,16(sp)
    80004044:	1800                	addi	s0,sp,48
    80004046:	892e                	mv	s2,a1
    80004048:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000404a:	fdc40593          	addi	a1,s0,-36
    8000404e:	df9fd0ef          	jal	80001e46 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004052:	fdc42703          	lw	a4,-36(s0)
    80004056:	47bd                	li	a5,15
    80004058:	02e7e963          	bltu	a5,a4,8000408a <argfd+0x50>
    8000405c:	ebffc0ef          	jal	80000f1a <myproc>
    80004060:	fdc42703          	lw	a4,-36(s0)
    80004064:	01a70793          	addi	a5,a4,26
    80004068:	078e                	slli	a5,a5,0x3
    8000406a:	953e                	add	a0,a0,a5
    8000406c:	651c                	ld	a5,8(a0)
    8000406e:	c385                	beqz	a5,8000408e <argfd+0x54>
    return -1;
  if(pfd)
    80004070:	00090463          	beqz	s2,80004078 <argfd+0x3e>
    *pfd = fd;
    80004074:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004078:	4501                	li	a0,0
  if(pf)
    8000407a:	c091                	beqz	s1,8000407e <argfd+0x44>
    *pf = f;
    8000407c:	e09c                	sd	a5,0(s1)
}
    8000407e:	70a2                	ld	ra,40(sp)
    80004080:	7402                	ld	s0,32(sp)
    80004082:	64e2                	ld	s1,24(sp)
    80004084:	6942                	ld	s2,16(sp)
    80004086:	6145                	addi	sp,sp,48
    80004088:	8082                	ret
    return -1;
    8000408a:	557d                	li	a0,-1
    8000408c:	bfcd                	j	8000407e <argfd+0x44>
    8000408e:	557d                	li	a0,-1
    80004090:	b7fd                	j	8000407e <argfd+0x44>

0000000080004092 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004092:	1101                	addi	sp,sp,-32
    80004094:	ec06                	sd	ra,24(sp)
    80004096:	e822                	sd	s0,16(sp)
    80004098:	e426                	sd	s1,8(sp)
    8000409a:	1000                	addi	s0,sp,32
    8000409c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000409e:	e7dfc0ef          	jal	80000f1a <myproc>
    800040a2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800040a4:	0d850793          	addi	a5,a0,216
    800040a8:	4501                	li	a0,0
    800040aa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800040ac:	6398                	ld	a4,0(a5)
    800040ae:	cb19                	beqz	a4,800040c4 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800040b0:	2505                	addiw	a0,a0,1
    800040b2:	07a1                	addi	a5,a5,8
    800040b4:	fed51ce3          	bne	a0,a3,800040ac <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800040b8:	557d                	li	a0,-1
}
    800040ba:	60e2                	ld	ra,24(sp)
    800040bc:	6442                	ld	s0,16(sp)
    800040be:	64a2                	ld	s1,8(sp)
    800040c0:	6105                	addi	sp,sp,32
    800040c2:	8082                	ret
      p->ofile[fd] = f;
    800040c4:	01a50793          	addi	a5,a0,26
    800040c8:	078e                	slli	a5,a5,0x3
    800040ca:	963e                	add	a2,a2,a5
    800040cc:	e604                	sd	s1,8(a2)
      return fd;
    800040ce:	b7f5                	j	800040ba <fdalloc+0x28>

00000000800040d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800040d0:	715d                	addi	sp,sp,-80
    800040d2:	e486                	sd	ra,72(sp)
    800040d4:	e0a2                	sd	s0,64(sp)
    800040d6:	fc26                	sd	s1,56(sp)
    800040d8:	f84a                	sd	s2,48(sp)
    800040da:	f44e                	sd	s3,40(sp)
    800040dc:	ec56                	sd	s5,24(sp)
    800040de:	e85a                	sd	s6,16(sp)
    800040e0:	0880                	addi	s0,sp,80
    800040e2:	8b2e                	mv	s6,a1
    800040e4:	89b2                	mv	s3,a2
    800040e6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800040e8:	fb040593          	addi	a1,s0,-80
    800040ec:	822ff0ef          	jal	8000310e <nameiparent>
    800040f0:	84aa                	mv	s1,a0
    800040f2:	10050a63          	beqz	a0,80004206 <create+0x136>
    return 0;

  ilock(dp);
    800040f6:	925fe0ef          	jal	80002a1a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800040fa:	4601                	li	a2,0
    800040fc:	fb040593          	addi	a1,s0,-80
    80004100:	8526                	mv	a0,s1
    80004102:	d8dfe0ef          	jal	80002e8e <dirlookup>
    80004106:	8aaa                	mv	s5,a0
    80004108:	c129                	beqz	a0,8000414a <create+0x7a>
    iunlockput(dp);
    8000410a:	8526                	mv	a0,s1
    8000410c:	b19fe0ef          	jal	80002c24 <iunlockput>
    ilock(ip);
    80004110:	8556                	mv	a0,s5
    80004112:	909fe0ef          	jal	80002a1a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004116:	4789                	li	a5,2
    80004118:	02fb1463          	bne	s6,a5,80004140 <create+0x70>
    8000411c:	044ad783          	lhu	a5,68(s5)
    80004120:	37f9                	addiw	a5,a5,-2
    80004122:	17c2                	slli	a5,a5,0x30
    80004124:	93c1                	srli	a5,a5,0x30
    80004126:	4705                	li	a4,1
    80004128:	00f76c63          	bltu	a4,a5,80004140 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000412c:	8556                	mv	a0,s5
    8000412e:	60a6                	ld	ra,72(sp)
    80004130:	6406                	ld	s0,64(sp)
    80004132:	74e2                	ld	s1,56(sp)
    80004134:	7942                	ld	s2,48(sp)
    80004136:	79a2                	ld	s3,40(sp)
    80004138:	6ae2                	ld	s5,24(sp)
    8000413a:	6b42                	ld	s6,16(sp)
    8000413c:	6161                	addi	sp,sp,80
    8000413e:	8082                	ret
    iunlockput(ip);
    80004140:	8556                	mv	a0,s5
    80004142:	ae3fe0ef          	jal	80002c24 <iunlockput>
    return 0;
    80004146:	4a81                	li	s5,0
    80004148:	b7d5                	j	8000412c <create+0x5c>
    8000414a:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    8000414c:	85da                	mv	a1,s6
    8000414e:	4088                	lw	a0,0(s1)
    80004150:	f5afe0ef          	jal	800028aa <ialloc>
    80004154:	8a2a                	mv	s4,a0
    80004156:	cd15                	beqz	a0,80004192 <create+0xc2>
  ilock(ip);
    80004158:	8c3fe0ef          	jal	80002a1a <ilock>
  ip->major = major;
    8000415c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004160:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004164:	4905                	li	s2,1
    80004166:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000416a:	8552                	mv	a0,s4
    8000416c:	ffafe0ef          	jal	80002966 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004170:	032b0763          	beq	s6,s2,8000419e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004174:	004a2603          	lw	a2,4(s4)
    80004178:	fb040593          	addi	a1,s0,-80
    8000417c:	8526                	mv	a0,s1
    8000417e:	eddfe0ef          	jal	8000305a <dirlink>
    80004182:	06054563          	bltz	a0,800041ec <create+0x11c>
  iunlockput(dp);
    80004186:	8526                	mv	a0,s1
    80004188:	a9dfe0ef          	jal	80002c24 <iunlockput>
  return ip;
    8000418c:	8ad2                	mv	s5,s4
    8000418e:	7a02                	ld	s4,32(sp)
    80004190:	bf71                	j	8000412c <create+0x5c>
    iunlockput(dp);
    80004192:	8526                	mv	a0,s1
    80004194:	a91fe0ef          	jal	80002c24 <iunlockput>
    return 0;
    80004198:	8ad2                	mv	s5,s4
    8000419a:	7a02                	ld	s4,32(sp)
    8000419c:	bf41                	j	8000412c <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000419e:	004a2603          	lw	a2,4(s4)
    800041a2:	00003597          	auipc	a1,0x3
    800041a6:	42e58593          	addi	a1,a1,1070 # 800075d0 <etext+0x5d0>
    800041aa:	8552                	mv	a0,s4
    800041ac:	eaffe0ef          	jal	8000305a <dirlink>
    800041b0:	02054e63          	bltz	a0,800041ec <create+0x11c>
    800041b4:	40d0                	lw	a2,4(s1)
    800041b6:	00003597          	auipc	a1,0x3
    800041ba:	42258593          	addi	a1,a1,1058 # 800075d8 <etext+0x5d8>
    800041be:	8552                	mv	a0,s4
    800041c0:	e9bfe0ef          	jal	8000305a <dirlink>
    800041c4:	02054463          	bltz	a0,800041ec <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800041c8:	004a2603          	lw	a2,4(s4)
    800041cc:	fb040593          	addi	a1,s0,-80
    800041d0:	8526                	mv	a0,s1
    800041d2:	e89fe0ef          	jal	8000305a <dirlink>
    800041d6:	00054b63          	bltz	a0,800041ec <create+0x11c>
    dp->nlink++;  // for ".."
    800041da:	04a4d783          	lhu	a5,74(s1)
    800041de:	2785                	addiw	a5,a5,1
    800041e0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041e4:	8526                	mv	a0,s1
    800041e6:	f80fe0ef          	jal	80002966 <iupdate>
    800041ea:	bf71                	j	80004186 <create+0xb6>
  ip->nlink = 0;
    800041ec:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800041f0:	8552                	mv	a0,s4
    800041f2:	f74fe0ef          	jal	80002966 <iupdate>
  iunlockput(ip);
    800041f6:	8552                	mv	a0,s4
    800041f8:	a2dfe0ef          	jal	80002c24 <iunlockput>
  iunlockput(dp);
    800041fc:	8526                	mv	a0,s1
    800041fe:	a27fe0ef          	jal	80002c24 <iunlockput>
  return 0;
    80004202:	7a02                	ld	s4,32(sp)
    80004204:	b725                	j	8000412c <create+0x5c>
    return 0;
    80004206:	8aaa                	mv	s5,a0
    80004208:	b715                	j	8000412c <create+0x5c>

000000008000420a <sys_dup>:
{
    8000420a:	7179                	addi	sp,sp,-48
    8000420c:	f406                	sd	ra,40(sp)
    8000420e:	f022                	sd	s0,32(sp)
    80004210:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004212:	fd840613          	addi	a2,s0,-40
    80004216:	4581                	li	a1,0
    80004218:	4501                	li	a0,0
    8000421a:	e21ff0ef          	jal	8000403a <argfd>
    return -1;
    8000421e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004220:	02054363          	bltz	a0,80004246 <sys_dup+0x3c>
    80004224:	ec26                	sd	s1,24(sp)
    80004226:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004228:	fd843903          	ld	s2,-40(s0)
    8000422c:	854a                	mv	a0,s2
    8000422e:	e65ff0ef          	jal	80004092 <fdalloc>
    80004232:	84aa                	mv	s1,a0
    return -1;
    80004234:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004236:	00054d63          	bltz	a0,80004250 <sys_dup+0x46>
  filedup(f);
    8000423a:	854a                	mv	a0,s2
    8000423c:	c48ff0ef          	jal	80003684 <filedup>
  return fd;
    80004240:	87a6                	mv	a5,s1
    80004242:	64e2                	ld	s1,24(sp)
    80004244:	6942                	ld	s2,16(sp)
}
    80004246:	853e                	mv	a0,a5
    80004248:	70a2                	ld	ra,40(sp)
    8000424a:	7402                	ld	s0,32(sp)
    8000424c:	6145                	addi	sp,sp,48
    8000424e:	8082                	ret
    80004250:	64e2                	ld	s1,24(sp)
    80004252:	6942                	ld	s2,16(sp)
    80004254:	bfcd                	j	80004246 <sys_dup+0x3c>

0000000080004256 <sys_read>:
{
    80004256:	7179                	addi	sp,sp,-48
    80004258:	f406                	sd	ra,40(sp)
    8000425a:	f022                	sd	s0,32(sp)
    8000425c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000425e:	fd840593          	addi	a1,s0,-40
    80004262:	4505                	li	a0,1
    80004264:	bfffd0ef          	jal	80001e62 <argaddr>
  argint(2, &n);
    80004268:	fe440593          	addi	a1,s0,-28
    8000426c:	4509                	li	a0,2
    8000426e:	bd9fd0ef          	jal	80001e46 <argint>
  if(argfd(0, 0, &f) < 0)
    80004272:	fe840613          	addi	a2,s0,-24
    80004276:	4581                	li	a1,0
    80004278:	4501                	li	a0,0
    8000427a:	dc1ff0ef          	jal	8000403a <argfd>
    8000427e:	87aa                	mv	a5,a0
    return -1;
    80004280:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004282:	0007ca63          	bltz	a5,80004296 <sys_read+0x40>
  return fileread(f, p, n);
    80004286:	fe442603          	lw	a2,-28(s0)
    8000428a:	fd843583          	ld	a1,-40(s0)
    8000428e:	fe843503          	ld	a0,-24(s0)
    80004292:	d58ff0ef          	jal	800037ea <fileread>
}
    80004296:	70a2                	ld	ra,40(sp)
    80004298:	7402                	ld	s0,32(sp)
    8000429a:	6145                	addi	sp,sp,48
    8000429c:	8082                	ret

000000008000429e <sys_write>:
{
    8000429e:	7179                	addi	sp,sp,-48
    800042a0:	f406                	sd	ra,40(sp)
    800042a2:	f022                	sd	s0,32(sp)
    800042a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042a6:	fd840593          	addi	a1,s0,-40
    800042aa:	4505                	li	a0,1
    800042ac:	bb7fd0ef          	jal	80001e62 <argaddr>
  argint(2, &n);
    800042b0:	fe440593          	addi	a1,s0,-28
    800042b4:	4509                	li	a0,2
    800042b6:	b91fd0ef          	jal	80001e46 <argint>
  if(argfd(0, 0, &f) < 0)
    800042ba:	fe840613          	addi	a2,s0,-24
    800042be:	4581                	li	a1,0
    800042c0:	4501                	li	a0,0
    800042c2:	d79ff0ef          	jal	8000403a <argfd>
    800042c6:	87aa                	mv	a5,a0
    return -1;
    800042c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800042ca:	0007ca63          	bltz	a5,800042de <sys_write+0x40>
  return filewrite(f, p, n);
    800042ce:	fe442603          	lw	a2,-28(s0)
    800042d2:	fd843583          	ld	a1,-40(s0)
    800042d6:	fe843503          	ld	a0,-24(s0)
    800042da:	dceff0ef          	jal	800038a8 <filewrite>
}
    800042de:	70a2                	ld	ra,40(sp)
    800042e0:	7402                	ld	s0,32(sp)
    800042e2:	6145                	addi	sp,sp,48
    800042e4:	8082                	ret

00000000800042e6 <sys_close>:
{
    800042e6:	1101                	addi	sp,sp,-32
    800042e8:	ec06                	sd	ra,24(sp)
    800042ea:	e822                	sd	s0,16(sp)
    800042ec:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800042ee:	fe040613          	addi	a2,s0,-32
    800042f2:	fec40593          	addi	a1,s0,-20
    800042f6:	4501                	li	a0,0
    800042f8:	d43ff0ef          	jal	8000403a <argfd>
    return -1;
    800042fc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800042fe:	02054063          	bltz	a0,8000431e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004302:	c19fc0ef          	jal	80000f1a <myproc>
    80004306:	fec42783          	lw	a5,-20(s0)
    8000430a:	07e9                	addi	a5,a5,26
    8000430c:	078e                	slli	a5,a5,0x3
    8000430e:	953e                	add	a0,a0,a5
    80004310:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004314:	fe043503          	ld	a0,-32(s0)
    80004318:	bb2ff0ef          	jal	800036ca <fileclose>
  return 0;
    8000431c:	4781                	li	a5,0
}
    8000431e:	853e                	mv	a0,a5
    80004320:	60e2                	ld	ra,24(sp)
    80004322:	6442                	ld	s0,16(sp)
    80004324:	6105                	addi	sp,sp,32
    80004326:	8082                	ret

0000000080004328 <sys_fstat>:
{
    80004328:	1101                	addi	sp,sp,-32
    8000432a:	ec06                	sd	ra,24(sp)
    8000432c:	e822                	sd	s0,16(sp)
    8000432e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004330:	fe040593          	addi	a1,s0,-32
    80004334:	4505                	li	a0,1
    80004336:	b2dfd0ef          	jal	80001e62 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000433a:	fe840613          	addi	a2,s0,-24
    8000433e:	4581                	li	a1,0
    80004340:	4501                	li	a0,0
    80004342:	cf9ff0ef          	jal	8000403a <argfd>
    80004346:	87aa                	mv	a5,a0
    return -1;
    80004348:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000434a:	0007c863          	bltz	a5,8000435a <sys_fstat+0x32>
  return filestat(f, st);
    8000434e:	fe043583          	ld	a1,-32(s0)
    80004352:	fe843503          	ld	a0,-24(s0)
    80004356:	c36ff0ef          	jal	8000378c <filestat>
}
    8000435a:	60e2                	ld	ra,24(sp)
    8000435c:	6442                	ld	s0,16(sp)
    8000435e:	6105                	addi	sp,sp,32
    80004360:	8082                	ret

0000000080004362 <sys_link>:
{
    80004362:	7169                	addi	sp,sp,-304
    80004364:	f606                	sd	ra,296(sp)
    80004366:	f222                	sd	s0,288(sp)
    80004368:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000436a:	08000613          	li	a2,128
    8000436e:	ed040593          	addi	a1,s0,-304
    80004372:	4501                	li	a0,0
    80004374:	b0bfd0ef          	jal	80001e7e <argstr>
    return -1;
    80004378:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000437a:	0c054e63          	bltz	a0,80004456 <sys_link+0xf4>
    8000437e:	08000613          	li	a2,128
    80004382:	f5040593          	addi	a1,s0,-176
    80004386:	4505                	li	a0,1
    80004388:	af7fd0ef          	jal	80001e7e <argstr>
    return -1;
    8000438c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000438e:	0c054463          	bltz	a0,80004456 <sys_link+0xf4>
    80004392:	ee26                	sd	s1,280(sp)
  begin_op();
    80004394:	f1dfe0ef          	jal	800032b0 <begin_op>
  if((ip = namei(old)) == 0){
    80004398:	ed040513          	addi	a0,s0,-304
    8000439c:	d59fe0ef          	jal	800030f4 <namei>
    800043a0:	84aa                	mv	s1,a0
    800043a2:	c53d                	beqz	a0,80004410 <sys_link+0xae>
  ilock(ip);
    800043a4:	e76fe0ef          	jal	80002a1a <ilock>
  if(ip->type == T_DIR){
    800043a8:	04449703          	lh	a4,68(s1)
    800043ac:	4785                	li	a5,1
    800043ae:	06f70663          	beq	a4,a5,8000441a <sys_link+0xb8>
    800043b2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800043b4:	04a4d783          	lhu	a5,74(s1)
    800043b8:	2785                	addiw	a5,a5,1
    800043ba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800043be:	8526                	mv	a0,s1
    800043c0:	da6fe0ef          	jal	80002966 <iupdate>
  iunlock(ip);
    800043c4:	8526                	mv	a0,s1
    800043c6:	f02fe0ef          	jal	80002ac8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800043ca:	fd040593          	addi	a1,s0,-48
    800043ce:	f5040513          	addi	a0,s0,-176
    800043d2:	d3dfe0ef          	jal	8000310e <nameiparent>
    800043d6:	892a                	mv	s2,a0
    800043d8:	cd21                	beqz	a0,80004430 <sys_link+0xce>
  ilock(dp);
    800043da:	e40fe0ef          	jal	80002a1a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800043de:	00092703          	lw	a4,0(s2)
    800043e2:	409c                	lw	a5,0(s1)
    800043e4:	04f71363          	bne	a4,a5,8000442a <sys_link+0xc8>
    800043e8:	40d0                	lw	a2,4(s1)
    800043ea:	fd040593          	addi	a1,s0,-48
    800043ee:	854a                	mv	a0,s2
    800043f0:	c6bfe0ef          	jal	8000305a <dirlink>
    800043f4:	02054b63          	bltz	a0,8000442a <sys_link+0xc8>
  iunlockput(dp);
    800043f8:	854a                	mv	a0,s2
    800043fa:	82bfe0ef          	jal	80002c24 <iunlockput>
  iput(ip);
    800043fe:	8526                	mv	a0,s1
    80004400:	f9cfe0ef          	jal	80002b9c <iput>
  end_op();
    80004404:	f17fe0ef          	jal	8000331a <end_op>
  return 0;
    80004408:	4781                	li	a5,0
    8000440a:	64f2                	ld	s1,280(sp)
    8000440c:	6952                	ld	s2,272(sp)
    8000440e:	a0a1                	j	80004456 <sys_link+0xf4>
    end_op();
    80004410:	f0bfe0ef          	jal	8000331a <end_op>
    return -1;
    80004414:	57fd                	li	a5,-1
    80004416:	64f2                	ld	s1,280(sp)
    80004418:	a83d                	j	80004456 <sys_link+0xf4>
    iunlockput(ip);
    8000441a:	8526                	mv	a0,s1
    8000441c:	809fe0ef          	jal	80002c24 <iunlockput>
    end_op();
    80004420:	efbfe0ef          	jal	8000331a <end_op>
    return -1;
    80004424:	57fd                	li	a5,-1
    80004426:	64f2                	ld	s1,280(sp)
    80004428:	a03d                	j	80004456 <sys_link+0xf4>
    iunlockput(dp);
    8000442a:	854a                	mv	a0,s2
    8000442c:	ff8fe0ef          	jal	80002c24 <iunlockput>
  ilock(ip);
    80004430:	8526                	mv	a0,s1
    80004432:	de8fe0ef          	jal	80002a1a <ilock>
  ip->nlink--;
    80004436:	04a4d783          	lhu	a5,74(s1)
    8000443a:	37fd                	addiw	a5,a5,-1
    8000443c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004440:	8526                	mv	a0,s1
    80004442:	d24fe0ef          	jal	80002966 <iupdate>
  iunlockput(ip);
    80004446:	8526                	mv	a0,s1
    80004448:	fdcfe0ef          	jal	80002c24 <iunlockput>
  end_op();
    8000444c:	ecffe0ef          	jal	8000331a <end_op>
  return -1;
    80004450:	57fd                	li	a5,-1
    80004452:	64f2                	ld	s1,280(sp)
    80004454:	6952                	ld	s2,272(sp)
}
    80004456:	853e                	mv	a0,a5
    80004458:	70b2                	ld	ra,296(sp)
    8000445a:	7412                	ld	s0,288(sp)
    8000445c:	6155                	addi	sp,sp,304
    8000445e:	8082                	ret

0000000080004460 <sys_unlink>:
{
    80004460:	7151                	addi	sp,sp,-240
    80004462:	f586                	sd	ra,232(sp)
    80004464:	f1a2                	sd	s0,224(sp)
    80004466:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004468:	08000613          	li	a2,128
    8000446c:	f3040593          	addi	a1,s0,-208
    80004470:	4501                	li	a0,0
    80004472:	a0dfd0ef          	jal	80001e7e <argstr>
    80004476:	16054063          	bltz	a0,800045d6 <sys_unlink+0x176>
    8000447a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000447c:	e35fe0ef          	jal	800032b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004480:	fb040593          	addi	a1,s0,-80
    80004484:	f3040513          	addi	a0,s0,-208
    80004488:	c87fe0ef          	jal	8000310e <nameiparent>
    8000448c:	84aa                	mv	s1,a0
    8000448e:	c945                	beqz	a0,8000453e <sys_unlink+0xde>
  ilock(dp);
    80004490:	d8afe0ef          	jal	80002a1a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004494:	00003597          	auipc	a1,0x3
    80004498:	13c58593          	addi	a1,a1,316 # 800075d0 <etext+0x5d0>
    8000449c:	fb040513          	addi	a0,s0,-80
    800044a0:	9d9fe0ef          	jal	80002e78 <namecmp>
    800044a4:	10050e63          	beqz	a0,800045c0 <sys_unlink+0x160>
    800044a8:	00003597          	auipc	a1,0x3
    800044ac:	13058593          	addi	a1,a1,304 # 800075d8 <etext+0x5d8>
    800044b0:	fb040513          	addi	a0,s0,-80
    800044b4:	9c5fe0ef          	jal	80002e78 <namecmp>
    800044b8:	10050463          	beqz	a0,800045c0 <sys_unlink+0x160>
    800044bc:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800044be:	f2c40613          	addi	a2,s0,-212
    800044c2:	fb040593          	addi	a1,s0,-80
    800044c6:	8526                	mv	a0,s1
    800044c8:	9c7fe0ef          	jal	80002e8e <dirlookup>
    800044cc:	892a                	mv	s2,a0
    800044ce:	0e050863          	beqz	a0,800045be <sys_unlink+0x15e>
  ilock(ip);
    800044d2:	d48fe0ef          	jal	80002a1a <ilock>
  if(ip->nlink < 1)
    800044d6:	04a91783          	lh	a5,74(s2)
    800044da:	06f05763          	blez	a5,80004548 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800044de:	04491703          	lh	a4,68(s2)
    800044e2:	4785                	li	a5,1
    800044e4:	06f70963          	beq	a4,a5,80004556 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800044e8:	4641                	li	a2,16
    800044ea:	4581                	li	a1,0
    800044ec:	fc040513          	addi	a0,s0,-64
    800044f0:	c85fb0ef          	jal	80000174 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044f4:	4741                	li	a4,16
    800044f6:	f2c42683          	lw	a3,-212(s0)
    800044fa:	fc040613          	addi	a2,s0,-64
    800044fe:	4581                	li	a1,0
    80004500:	8526                	mv	a0,s1
    80004502:	869fe0ef          	jal	80002d6a <writei>
    80004506:	47c1                	li	a5,16
    80004508:	08f51b63          	bne	a0,a5,8000459e <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000450c:	04491703          	lh	a4,68(s2)
    80004510:	4785                	li	a5,1
    80004512:	08f70d63          	beq	a4,a5,800045ac <sys_unlink+0x14c>
  iunlockput(dp);
    80004516:	8526                	mv	a0,s1
    80004518:	f0cfe0ef          	jal	80002c24 <iunlockput>
  ip->nlink--;
    8000451c:	04a95783          	lhu	a5,74(s2)
    80004520:	37fd                	addiw	a5,a5,-1
    80004522:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004526:	854a                	mv	a0,s2
    80004528:	c3efe0ef          	jal	80002966 <iupdate>
  iunlockput(ip);
    8000452c:	854a                	mv	a0,s2
    8000452e:	ef6fe0ef          	jal	80002c24 <iunlockput>
  end_op();
    80004532:	de9fe0ef          	jal	8000331a <end_op>
  return 0;
    80004536:	4501                	li	a0,0
    80004538:	64ee                	ld	s1,216(sp)
    8000453a:	694e                	ld	s2,208(sp)
    8000453c:	a849                	j	800045ce <sys_unlink+0x16e>
    end_op();
    8000453e:	dddfe0ef          	jal	8000331a <end_op>
    return -1;
    80004542:	557d                	li	a0,-1
    80004544:	64ee                	ld	s1,216(sp)
    80004546:	a061                	j	800045ce <sys_unlink+0x16e>
    80004548:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000454a:	00003517          	auipc	a0,0x3
    8000454e:	09650513          	addi	a0,a0,150 # 800075e0 <etext+0x5e0>
    80004552:	2be010ef          	jal	80005810 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004556:	04c92703          	lw	a4,76(s2)
    8000455a:	02000793          	li	a5,32
    8000455e:	f8e7f5e3          	bgeu	a5,a4,800044e8 <sys_unlink+0x88>
    80004562:	e5ce                	sd	s3,200(sp)
    80004564:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004568:	4741                	li	a4,16
    8000456a:	86ce                	mv	a3,s3
    8000456c:	f1840613          	addi	a2,s0,-232
    80004570:	4581                	li	a1,0
    80004572:	854a                	mv	a0,s2
    80004574:	efafe0ef          	jal	80002c6e <readi>
    80004578:	47c1                	li	a5,16
    8000457a:	00f51c63          	bne	a0,a5,80004592 <sys_unlink+0x132>
    if(de.inum != 0)
    8000457e:	f1845783          	lhu	a5,-232(s0)
    80004582:	efa1                	bnez	a5,800045da <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004584:	29c1                	addiw	s3,s3,16
    80004586:	04c92783          	lw	a5,76(s2)
    8000458a:	fcf9efe3          	bltu	s3,a5,80004568 <sys_unlink+0x108>
    8000458e:	69ae                	ld	s3,200(sp)
    80004590:	bfa1                	j	800044e8 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004592:	00003517          	auipc	a0,0x3
    80004596:	06650513          	addi	a0,a0,102 # 800075f8 <etext+0x5f8>
    8000459a:	276010ef          	jal	80005810 <panic>
    8000459e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800045a0:	00003517          	auipc	a0,0x3
    800045a4:	07050513          	addi	a0,a0,112 # 80007610 <etext+0x610>
    800045a8:	268010ef          	jal	80005810 <panic>
    dp->nlink--;
    800045ac:	04a4d783          	lhu	a5,74(s1)
    800045b0:	37fd                	addiw	a5,a5,-1
    800045b2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045b6:	8526                	mv	a0,s1
    800045b8:	baefe0ef          	jal	80002966 <iupdate>
    800045bc:	bfa9                	j	80004516 <sys_unlink+0xb6>
    800045be:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800045c0:	8526                	mv	a0,s1
    800045c2:	e62fe0ef          	jal	80002c24 <iunlockput>
  end_op();
    800045c6:	d55fe0ef          	jal	8000331a <end_op>
  return -1;
    800045ca:	557d                	li	a0,-1
    800045cc:	64ee                	ld	s1,216(sp)
}
    800045ce:	70ae                	ld	ra,232(sp)
    800045d0:	740e                	ld	s0,224(sp)
    800045d2:	616d                	addi	sp,sp,240
    800045d4:	8082                	ret
    return -1;
    800045d6:	557d                	li	a0,-1
    800045d8:	bfdd                	j	800045ce <sys_unlink+0x16e>
    iunlockput(ip);
    800045da:	854a                	mv	a0,s2
    800045dc:	e48fe0ef          	jal	80002c24 <iunlockput>
    goto bad;
    800045e0:	694e                	ld	s2,208(sp)
    800045e2:	69ae                	ld	s3,200(sp)
    800045e4:	bff1                	j	800045c0 <sys_unlink+0x160>

00000000800045e6 <sys_open>:

uint64
sys_open(void)
{
    800045e6:	7131                	addi	sp,sp,-192
    800045e8:	fd06                	sd	ra,184(sp)
    800045ea:	f922                	sd	s0,176(sp)
    800045ec:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800045ee:	f4c40593          	addi	a1,s0,-180
    800045f2:	4505                	li	a0,1
    800045f4:	853fd0ef          	jal	80001e46 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800045f8:	08000613          	li	a2,128
    800045fc:	f5040593          	addi	a1,s0,-176
    80004600:	4501                	li	a0,0
    80004602:	87dfd0ef          	jal	80001e7e <argstr>
    80004606:	87aa                	mv	a5,a0
    return -1;
    80004608:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000460a:	0a07c263          	bltz	a5,800046ae <sys_open+0xc8>
    8000460e:	f526                	sd	s1,168(sp)

  begin_op();
    80004610:	ca1fe0ef          	jal	800032b0 <begin_op>

  if(omode & O_CREATE){
    80004614:	f4c42783          	lw	a5,-180(s0)
    80004618:	2007f793          	andi	a5,a5,512
    8000461c:	c3d5                	beqz	a5,800046c0 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000461e:	4681                	li	a3,0
    80004620:	4601                	li	a2,0
    80004622:	4589                	li	a1,2
    80004624:	f5040513          	addi	a0,s0,-176
    80004628:	aa9ff0ef          	jal	800040d0 <create>
    8000462c:	84aa                	mv	s1,a0
    if(ip == 0){
    8000462e:	c541                	beqz	a0,800046b6 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004630:	04449703          	lh	a4,68(s1)
    80004634:	478d                	li	a5,3
    80004636:	00f71763          	bne	a4,a5,80004644 <sys_open+0x5e>
    8000463a:	0464d703          	lhu	a4,70(s1)
    8000463e:	47a5                	li	a5,9
    80004640:	0ae7ed63          	bltu	a5,a4,800046fa <sys_open+0x114>
    80004644:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004646:	fe1fe0ef          	jal	80003626 <filealloc>
    8000464a:	892a                	mv	s2,a0
    8000464c:	c179                	beqz	a0,80004712 <sys_open+0x12c>
    8000464e:	ed4e                	sd	s3,152(sp)
    80004650:	a43ff0ef          	jal	80004092 <fdalloc>
    80004654:	89aa                	mv	s3,a0
    80004656:	0a054a63          	bltz	a0,8000470a <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000465a:	04449703          	lh	a4,68(s1)
    8000465e:	478d                	li	a5,3
    80004660:	0cf70263          	beq	a4,a5,80004724 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004664:	4789                	li	a5,2
    80004666:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000466a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000466e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004672:	f4c42783          	lw	a5,-180(s0)
    80004676:	0017c713          	xori	a4,a5,1
    8000467a:	8b05                	andi	a4,a4,1
    8000467c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004680:	0037f713          	andi	a4,a5,3
    80004684:	00e03733          	snez	a4,a4
    80004688:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000468c:	4007f793          	andi	a5,a5,1024
    80004690:	c791                	beqz	a5,8000469c <sys_open+0xb6>
    80004692:	04449703          	lh	a4,68(s1)
    80004696:	4789                	li	a5,2
    80004698:	08f70d63          	beq	a4,a5,80004732 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000469c:	8526                	mv	a0,s1
    8000469e:	c2afe0ef          	jal	80002ac8 <iunlock>
  end_op();
    800046a2:	c79fe0ef          	jal	8000331a <end_op>

  return fd;
    800046a6:	854e                	mv	a0,s3
    800046a8:	74aa                	ld	s1,168(sp)
    800046aa:	790a                	ld	s2,160(sp)
    800046ac:	69ea                	ld	s3,152(sp)
}
    800046ae:	70ea                	ld	ra,184(sp)
    800046b0:	744a                	ld	s0,176(sp)
    800046b2:	6129                	addi	sp,sp,192
    800046b4:	8082                	ret
      end_op();
    800046b6:	c65fe0ef          	jal	8000331a <end_op>
      return -1;
    800046ba:	557d                	li	a0,-1
    800046bc:	74aa                	ld	s1,168(sp)
    800046be:	bfc5                	j	800046ae <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800046c0:	f5040513          	addi	a0,s0,-176
    800046c4:	a31fe0ef          	jal	800030f4 <namei>
    800046c8:	84aa                	mv	s1,a0
    800046ca:	c11d                	beqz	a0,800046f0 <sys_open+0x10a>
    ilock(ip);
    800046cc:	b4efe0ef          	jal	80002a1a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800046d0:	04449703          	lh	a4,68(s1)
    800046d4:	4785                	li	a5,1
    800046d6:	f4f71de3          	bne	a4,a5,80004630 <sys_open+0x4a>
    800046da:	f4c42783          	lw	a5,-180(s0)
    800046de:	d3bd                	beqz	a5,80004644 <sys_open+0x5e>
      iunlockput(ip);
    800046e0:	8526                	mv	a0,s1
    800046e2:	d42fe0ef          	jal	80002c24 <iunlockput>
      end_op();
    800046e6:	c35fe0ef          	jal	8000331a <end_op>
      return -1;
    800046ea:	557d                	li	a0,-1
    800046ec:	74aa                	ld	s1,168(sp)
    800046ee:	b7c1                	j	800046ae <sys_open+0xc8>
      end_op();
    800046f0:	c2bfe0ef          	jal	8000331a <end_op>
      return -1;
    800046f4:	557d                	li	a0,-1
    800046f6:	74aa                	ld	s1,168(sp)
    800046f8:	bf5d                	j	800046ae <sys_open+0xc8>
    iunlockput(ip);
    800046fa:	8526                	mv	a0,s1
    800046fc:	d28fe0ef          	jal	80002c24 <iunlockput>
    end_op();
    80004700:	c1bfe0ef          	jal	8000331a <end_op>
    return -1;
    80004704:	557d                	li	a0,-1
    80004706:	74aa                	ld	s1,168(sp)
    80004708:	b75d                	j	800046ae <sys_open+0xc8>
      fileclose(f);
    8000470a:	854a                	mv	a0,s2
    8000470c:	fbffe0ef          	jal	800036ca <fileclose>
    80004710:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004712:	8526                	mv	a0,s1
    80004714:	d10fe0ef          	jal	80002c24 <iunlockput>
    end_op();
    80004718:	c03fe0ef          	jal	8000331a <end_op>
    return -1;
    8000471c:	557d                	li	a0,-1
    8000471e:	74aa                	ld	s1,168(sp)
    80004720:	790a                	ld	s2,160(sp)
    80004722:	b771                	j	800046ae <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004724:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004728:	04649783          	lh	a5,70(s1)
    8000472c:	02f91223          	sh	a5,36(s2)
    80004730:	bf3d                	j	8000466e <sys_open+0x88>
    itrunc(ip);
    80004732:	8526                	mv	a0,s1
    80004734:	bd4fe0ef          	jal	80002b08 <itrunc>
    80004738:	b795                	j	8000469c <sys_open+0xb6>

000000008000473a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000473a:	7175                	addi	sp,sp,-144
    8000473c:	e506                	sd	ra,136(sp)
    8000473e:	e122                	sd	s0,128(sp)
    80004740:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004742:	b6ffe0ef          	jal	800032b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004746:	08000613          	li	a2,128
    8000474a:	f7040593          	addi	a1,s0,-144
    8000474e:	4501                	li	a0,0
    80004750:	f2efd0ef          	jal	80001e7e <argstr>
    80004754:	02054363          	bltz	a0,8000477a <sys_mkdir+0x40>
    80004758:	4681                	li	a3,0
    8000475a:	4601                	li	a2,0
    8000475c:	4585                	li	a1,1
    8000475e:	f7040513          	addi	a0,s0,-144
    80004762:	96fff0ef          	jal	800040d0 <create>
    80004766:	c911                	beqz	a0,8000477a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004768:	cbcfe0ef          	jal	80002c24 <iunlockput>
  end_op();
    8000476c:	baffe0ef          	jal	8000331a <end_op>
  return 0;
    80004770:	4501                	li	a0,0
}
    80004772:	60aa                	ld	ra,136(sp)
    80004774:	640a                	ld	s0,128(sp)
    80004776:	6149                	addi	sp,sp,144
    80004778:	8082                	ret
    end_op();
    8000477a:	ba1fe0ef          	jal	8000331a <end_op>
    return -1;
    8000477e:	557d                	li	a0,-1
    80004780:	bfcd                	j	80004772 <sys_mkdir+0x38>

0000000080004782 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004782:	7135                	addi	sp,sp,-160
    80004784:	ed06                	sd	ra,152(sp)
    80004786:	e922                	sd	s0,144(sp)
    80004788:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000478a:	b27fe0ef          	jal	800032b0 <begin_op>
  argint(1, &major);
    8000478e:	f6c40593          	addi	a1,s0,-148
    80004792:	4505                	li	a0,1
    80004794:	eb2fd0ef          	jal	80001e46 <argint>
  argint(2, &minor);
    80004798:	f6840593          	addi	a1,s0,-152
    8000479c:	4509                	li	a0,2
    8000479e:	ea8fd0ef          	jal	80001e46 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047a2:	08000613          	li	a2,128
    800047a6:	f7040593          	addi	a1,s0,-144
    800047aa:	4501                	li	a0,0
    800047ac:	ed2fd0ef          	jal	80001e7e <argstr>
    800047b0:	02054563          	bltz	a0,800047da <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800047b4:	f6841683          	lh	a3,-152(s0)
    800047b8:	f6c41603          	lh	a2,-148(s0)
    800047bc:	458d                	li	a1,3
    800047be:	f7040513          	addi	a0,s0,-144
    800047c2:	90fff0ef          	jal	800040d0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047c6:	c911                	beqz	a0,800047da <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047c8:	c5cfe0ef          	jal	80002c24 <iunlockput>
  end_op();
    800047cc:	b4ffe0ef          	jal	8000331a <end_op>
  return 0;
    800047d0:	4501                	li	a0,0
}
    800047d2:	60ea                	ld	ra,152(sp)
    800047d4:	644a                	ld	s0,144(sp)
    800047d6:	610d                	addi	sp,sp,160
    800047d8:	8082                	ret
    end_op();
    800047da:	b41fe0ef          	jal	8000331a <end_op>
    return -1;
    800047de:	557d                	li	a0,-1
    800047e0:	bfcd                	j	800047d2 <sys_mknod+0x50>

00000000800047e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800047e2:	7135                	addi	sp,sp,-160
    800047e4:	ed06                	sd	ra,152(sp)
    800047e6:	e922                	sd	s0,144(sp)
    800047e8:	e14a                	sd	s2,128(sp)
    800047ea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800047ec:	f2efc0ef          	jal	80000f1a <myproc>
    800047f0:	892a                	mv	s2,a0
  
  begin_op();
    800047f2:	abffe0ef          	jal	800032b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800047f6:	08000613          	li	a2,128
    800047fa:	f6040593          	addi	a1,s0,-160
    800047fe:	4501                	li	a0,0
    80004800:	e7efd0ef          	jal	80001e7e <argstr>
    80004804:	04054363          	bltz	a0,8000484a <sys_chdir+0x68>
    80004808:	e526                	sd	s1,136(sp)
    8000480a:	f6040513          	addi	a0,s0,-160
    8000480e:	8e7fe0ef          	jal	800030f4 <namei>
    80004812:	84aa                	mv	s1,a0
    80004814:	c915                	beqz	a0,80004848 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004816:	a04fe0ef          	jal	80002a1a <ilock>
  if(ip->type != T_DIR){
    8000481a:	04449703          	lh	a4,68(s1)
    8000481e:	4785                	li	a5,1
    80004820:	02f71963          	bne	a4,a5,80004852 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004824:	8526                	mv	a0,s1
    80004826:	aa2fe0ef          	jal	80002ac8 <iunlock>
  iput(p->cwd);
    8000482a:	15893503          	ld	a0,344(s2)
    8000482e:	b6efe0ef          	jal	80002b9c <iput>
  end_op();
    80004832:	ae9fe0ef          	jal	8000331a <end_op>
  p->cwd = ip;
    80004836:	14993c23          	sd	s1,344(s2)
  return 0;
    8000483a:	4501                	li	a0,0
    8000483c:	64aa                	ld	s1,136(sp)
}
    8000483e:	60ea                	ld	ra,152(sp)
    80004840:	644a                	ld	s0,144(sp)
    80004842:	690a                	ld	s2,128(sp)
    80004844:	610d                	addi	sp,sp,160
    80004846:	8082                	ret
    80004848:	64aa                	ld	s1,136(sp)
    end_op();
    8000484a:	ad1fe0ef          	jal	8000331a <end_op>
    return -1;
    8000484e:	557d                	li	a0,-1
    80004850:	b7fd                	j	8000483e <sys_chdir+0x5c>
    iunlockput(ip);
    80004852:	8526                	mv	a0,s1
    80004854:	bd0fe0ef          	jal	80002c24 <iunlockput>
    end_op();
    80004858:	ac3fe0ef          	jal	8000331a <end_op>
    return -1;
    8000485c:	557d                	li	a0,-1
    8000485e:	64aa                	ld	s1,136(sp)
    80004860:	bff9                	j	8000483e <sys_chdir+0x5c>

0000000080004862 <sys_exec>:

uint64
sys_exec(void)
{
    80004862:	7121                	addi	sp,sp,-448
    80004864:	ff06                	sd	ra,440(sp)
    80004866:	fb22                	sd	s0,432(sp)
    80004868:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000486a:	e4840593          	addi	a1,s0,-440
    8000486e:	4505                	li	a0,1
    80004870:	df2fd0ef          	jal	80001e62 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004874:	08000613          	li	a2,128
    80004878:	f5040593          	addi	a1,s0,-176
    8000487c:	4501                	li	a0,0
    8000487e:	e00fd0ef          	jal	80001e7e <argstr>
    80004882:	87aa                	mv	a5,a0
    return -1;
    80004884:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004886:	0c07c463          	bltz	a5,8000494e <sys_exec+0xec>
    8000488a:	f726                	sd	s1,424(sp)
    8000488c:	f34a                	sd	s2,416(sp)
    8000488e:	ef4e                	sd	s3,408(sp)
    80004890:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004892:	10000613          	li	a2,256
    80004896:	4581                	li	a1,0
    80004898:	e5040513          	addi	a0,s0,-432
    8000489c:	8d9fb0ef          	jal	80000174 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800048a0:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800048a4:	89a6                	mv	s3,s1
    800048a6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800048a8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800048ac:	00391513          	slli	a0,s2,0x3
    800048b0:	e4040593          	addi	a1,s0,-448
    800048b4:	e4843783          	ld	a5,-440(s0)
    800048b8:	953e                	add	a0,a0,a5
    800048ba:	d02fd0ef          	jal	80001dbc <fetchaddr>
    800048be:	02054663          	bltz	a0,800048ea <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800048c2:	e4043783          	ld	a5,-448(s0)
    800048c6:	c3a9                	beqz	a5,80004908 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800048c8:	82ffb0ef          	jal	800000f6 <kalloc>
    800048cc:	85aa                	mv	a1,a0
    800048ce:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800048d2:	cd01                	beqz	a0,800048ea <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800048d4:	6605                	lui	a2,0x1
    800048d6:	e4043503          	ld	a0,-448(s0)
    800048da:	d2cfd0ef          	jal	80001e06 <fetchstr>
    800048de:	00054663          	bltz	a0,800048ea <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800048e2:	0905                	addi	s2,s2,1
    800048e4:	09a1                	addi	s3,s3,8
    800048e6:	fd4913e3          	bne	s2,s4,800048ac <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800048ea:	f5040913          	addi	s2,s0,-176
    800048ee:	6088                	ld	a0,0(s1)
    800048f0:	c931                	beqz	a0,80004944 <sys_exec+0xe2>
    kfree(argv[i]);
    800048f2:	f2afb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800048f6:	04a1                	addi	s1,s1,8
    800048f8:	ff249be3          	bne	s1,s2,800048ee <sys_exec+0x8c>
  return -1;
    800048fc:	557d                	li	a0,-1
    800048fe:	74ba                	ld	s1,424(sp)
    80004900:	791a                	ld	s2,416(sp)
    80004902:	69fa                	ld	s3,408(sp)
    80004904:	6a5a                	ld	s4,400(sp)
    80004906:	a0a1                	j	8000494e <sys_exec+0xec>
      argv[i] = 0;
    80004908:	0009079b          	sext.w	a5,s2
    8000490c:	078e                	slli	a5,a5,0x3
    8000490e:	fd078793          	addi	a5,a5,-48
    80004912:	97a2                	add	a5,a5,s0
    80004914:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004918:	e5040593          	addi	a1,s0,-432
    8000491c:	f5040513          	addi	a0,s0,-176
    80004920:	ba8ff0ef          	jal	80003cc8 <exec>
    80004924:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004926:	f5040993          	addi	s3,s0,-176
    8000492a:	6088                	ld	a0,0(s1)
    8000492c:	c511                	beqz	a0,80004938 <sys_exec+0xd6>
    kfree(argv[i]);
    8000492e:	eeefb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004932:	04a1                	addi	s1,s1,8
    80004934:	ff349be3          	bne	s1,s3,8000492a <sys_exec+0xc8>
  return ret;
    80004938:	854a                	mv	a0,s2
    8000493a:	74ba                	ld	s1,424(sp)
    8000493c:	791a                	ld	s2,416(sp)
    8000493e:	69fa                	ld	s3,408(sp)
    80004940:	6a5a                	ld	s4,400(sp)
    80004942:	a031                	j	8000494e <sys_exec+0xec>
  return -1;
    80004944:	557d                	li	a0,-1
    80004946:	74ba                	ld	s1,424(sp)
    80004948:	791a                	ld	s2,416(sp)
    8000494a:	69fa                	ld	s3,408(sp)
    8000494c:	6a5a                	ld	s4,400(sp)
}
    8000494e:	70fa                	ld	ra,440(sp)
    80004950:	745a                	ld	s0,432(sp)
    80004952:	6139                	addi	sp,sp,448
    80004954:	8082                	ret

0000000080004956 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004956:	7139                	addi	sp,sp,-64
    80004958:	fc06                	sd	ra,56(sp)
    8000495a:	f822                	sd	s0,48(sp)
    8000495c:	f426                	sd	s1,40(sp)
    8000495e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004960:	dbafc0ef          	jal	80000f1a <myproc>
    80004964:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004966:	fd840593          	addi	a1,s0,-40
    8000496a:	4501                	li	a0,0
    8000496c:	cf6fd0ef          	jal	80001e62 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004970:	fc840593          	addi	a1,s0,-56
    80004974:	fd040513          	addi	a0,s0,-48
    80004978:	85cff0ef          	jal	800039d4 <pipealloc>
    return -1;
    8000497c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000497e:	0a054463          	bltz	a0,80004a26 <sys_pipe+0xd0>
  fd0 = -1;
    80004982:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004986:	fd043503          	ld	a0,-48(s0)
    8000498a:	f08ff0ef          	jal	80004092 <fdalloc>
    8000498e:	fca42223          	sw	a0,-60(s0)
    80004992:	08054163          	bltz	a0,80004a14 <sys_pipe+0xbe>
    80004996:	fc843503          	ld	a0,-56(s0)
    8000499a:	ef8ff0ef          	jal	80004092 <fdalloc>
    8000499e:	fca42023          	sw	a0,-64(s0)
    800049a2:	06054063          	bltz	a0,80004a02 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800049a6:	4691                	li	a3,4
    800049a8:	fc440613          	addi	a2,s0,-60
    800049ac:	fd843583          	ld	a1,-40(s0)
    800049b0:	6ca8                	ld	a0,88(s1)
    800049b2:	854fc0ef          	jal	80000a06 <copyout>
    800049b6:	00054e63          	bltz	a0,800049d2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800049ba:	4691                	li	a3,4
    800049bc:	fc040613          	addi	a2,s0,-64
    800049c0:	fd843583          	ld	a1,-40(s0)
    800049c4:	0591                	addi	a1,a1,4
    800049c6:	6ca8                	ld	a0,88(s1)
    800049c8:	83efc0ef          	jal	80000a06 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800049cc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800049ce:	04055c63          	bgez	a0,80004a26 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800049d2:	fc442783          	lw	a5,-60(s0)
    800049d6:	07e9                	addi	a5,a5,26
    800049d8:	078e                	slli	a5,a5,0x3
    800049da:	97a6                	add	a5,a5,s1
    800049dc:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800049e0:	fc042783          	lw	a5,-64(s0)
    800049e4:	07e9                	addi	a5,a5,26
    800049e6:	078e                	slli	a5,a5,0x3
    800049e8:	94be                	add	s1,s1,a5
    800049ea:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800049ee:	fd043503          	ld	a0,-48(s0)
    800049f2:	cd9fe0ef          	jal	800036ca <fileclose>
    fileclose(wf);
    800049f6:	fc843503          	ld	a0,-56(s0)
    800049fa:	cd1fe0ef          	jal	800036ca <fileclose>
    return -1;
    800049fe:	57fd                	li	a5,-1
    80004a00:	a01d                	j	80004a26 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004a02:	fc442783          	lw	a5,-60(s0)
    80004a06:	0007c763          	bltz	a5,80004a14 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004a0a:	07e9                	addi	a5,a5,26
    80004a0c:	078e                	slli	a5,a5,0x3
    80004a0e:	97a6                	add	a5,a5,s1
    80004a10:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004a14:	fd043503          	ld	a0,-48(s0)
    80004a18:	cb3fe0ef          	jal	800036ca <fileclose>
    fileclose(wf);
    80004a1c:	fc843503          	ld	a0,-56(s0)
    80004a20:	cabfe0ef          	jal	800036ca <fileclose>
    return -1;
    80004a24:	57fd                	li	a5,-1
}
    80004a26:	853e                	mv	a0,a5
    80004a28:	70e2                	ld	ra,56(sp)
    80004a2a:	7442                	ld	s0,48(sp)
    80004a2c:	74a2                	ld	s1,40(sp)
    80004a2e:	6121                	addi	sp,sp,64
    80004a30:	8082                	ret
	...

0000000080004a40 <kernelvec>:
    80004a40:	7111                	addi	sp,sp,-256
    80004a42:	e006                	sd	ra,0(sp)
    80004a44:	e40a                	sd	sp,8(sp)
    80004a46:	e80e                	sd	gp,16(sp)
    80004a48:	ec12                	sd	tp,24(sp)
    80004a4a:	f016                	sd	t0,32(sp)
    80004a4c:	f41a                	sd	t1,40(sp)
    80004a4e:	f81e                	sd	t2,48(sp)
    80004a50:	e4aa                	sd	a0,72(sp)
    80004a52:	e8ae                	sd	a1,80(sp)
    80004a54:	ecb2                	sd	a2,88(sp)
    80004a56:	f0b6                	sd	a3,96(sp)
    80004a58:	f4ba                	sd	a4,104(sp)
    80004a5a:	f8be                	sd	a5,112(sp)
    80004a5c:	fcc2                	sd	a6,120(sp)
    80004a5e:	e146                	sd	a7,128(sp)
    80004a60:	edf2                	sd	t3,216(sp)
    80004a62:	f1f6                	sd	t4,224(sp)
    80004a64:	f5fa                	sd	t5,232(sp)
    80004a66:	f9fe                	sd	t6,240(sp)
    80004a68:	a64fd0ef          	jal	80001ccc <kerneltrap>
    80004a6c:	6082                	ld	ra,0(sp)
    80004a6e:	6122                	ld	sp,8(sp)
    80004a70:	61c2                	ld	gp,16(sp)
    80004a72:	7282                	ld	t0,32(sp)
    80004a74:	7322                	ld	t1,40(sp)
    80004a76:	73c2                	ld	t2,48(sp)
    80004a78:	6526                	ld	a0,72(sp)
    80004a7a:	65c6                	ld	a1,80(sp)
    80004a7c:	6666                	ld	a2,88(sp)
    80004a7e:	7686                	ld	a3,96(sp)
    80004a80:	7726                	ld	a4,104(sp)
    80004a82:	77c6                	ld	a5,112(sp)
    80004a84:	7866                	ld	a6,120(sp)
    80004a86:	688a                	ld	a7,128(sp)
    80004a88:	6e6e                	ld	t3,216(sp)
    80004a8a:	7e8e                	ld	t4,224(sp)
    80004a8c:	7f2e                	ld	t5,232(sp)
    80004a8e:	7fce                	ld	t6,240(sp)
    80004a90:	6111                	addi	sp,sp,256
    80004a92:	10200073          	sret
	...

0000000080004a9e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004a9e:	1141                	addi	sp,sp,-16
    80004aa0:	e422                	sd	s0,8(sp)
    80004aa2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004aa4:	0c0007b7          	lui	a5,0xc000
    80004aa8:	4705                	li	a4,1
    80004aaa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004aac:	0c0007b7          	lui	a5,0xc000
    80004ab0:	c3d8                	sw	a4,4(a5)
}
    80004ab2:	6422                	ld	s0,8(sp)
    80004ab4:	0141                	addi	sp,sp,16
    80004ab6:	8082                	ret

0000000080004ab8 <plicinithart>:

void
plicinithart(void)
{
    80004ab8:	1141                	addi	sp,sp,-16
    80004aba:	e406                	sd	ra,8(sp)
    80004abc:	e022                	sd	s0,0(sp)
    80004abe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ac0:	c2efc0ef          	jal	80000eee <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004ac4:	0085171b          	slliw	a4,a0,0x8
    80004ac8:	0c0027b7          	lui	a5,0xc002
    80004acc:	97ba                	add	a5,a5,a4
    80004ace:	40200713          	li	a4,1026
    80004ad2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004ad6:	00d5151b          	slliw	a0,a0,0xd
    80004ada:	0c2017b7          	lui	a5,0xc201
    80004ade:	97aa                	add	a5,a5,a0
    80004ae0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004ae4:	60a2                	ld	ra,8(sp)
    80004ae6:	6402                	ld	s0,0(sp)
    80004ae8:	0141                	addi	sp,sp,16
    80004aea:	8082                	ret

0000000080004aec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004aec:	1141                	addi	sp,sp,-16
    80004aee:	e406                	sd	ra,8(sp)
    80004af0:	e022                	sd	s0,0(sp)
    80004af2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004af4:	bfafc0ef          	jal	80000eee <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004af8:	00d5151b          	slliw	a0,a0,0xd
    80004afc:	0c2017b7          	lui	a5,0xc201
    80004b00:	97aa                	add	a5,a5,a0
  return irq;
}
    80004b02:	43c8                	lw	a0,4(a5)
    80004b04:	60a2                	ld	ra,8(sp)
    80004b06:	6402                	ld	s0,0(sp)
    80004b08:	0141                	addi	sp,sp,16
    80004b0a:	8082                	ret

0000000080004b0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004b0c:	1101                	addi	sp,sp,-32
    80004b0e:	ec06                	sd	ra,24(sp)
    80004b10:	e822                	sd	s0,16(sp)
    80004b12:	e426                	sd	s1,8(sp)
    80004b14:	1000                	addi	s0,sp,32
    80004b16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004b18:	bd6fc0ef          	jal	80000eee <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004b1c:	00d5151b          	slliw	a0,a0,0xd
    80004b20:	0c2017b7          	lui	a5,0xc201
    80004b24:	97aa                	add	a5,a5,a0
    80004b26:	c3c4                	sw	s1,4(a5)
}
    80004b28:	60e2                	ld	ra,24(sp)
    80004b2a:	6442                	ld	s0,16(sp)
    80004b2c:	64a2                	ld	s1,8(sp)
    80004b2e:	6105                	addi	sp,sp,32
    80004b30:	8082                	ret

0000000080004b32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004b32:	1141                	addi	sp,sp,-16
    80004b34:	e406                	sd	ra,8(sp)
    80004b36:	e022                	sd	s0,0(sp)
    80004b38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004b3a:	479d                	li	a5,7
    80004b3c:	04a7ca63          	blt	a5,a0,80004b90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004b40:	0001c797          	auipc	a5,0x1c
    80004b44:	7e878793          	addi	a5,a5,2024 # 80021328 <disk>
    80004b48:	97aa                	add	a5,a5,a0
    80004b4a:	0187c783          	lbu	a5,24(a5)
    80004b4e:	e7b9                	bnez	a5,80004b9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004b50:	00451693          	slli	a3,a0,0x4
    80004b54:	0001c797          	auipc	a5,0x1c
    80004b58:	7d478793          	addi	a5,a5,2004 # 80021328 <disk>
    80004b5c:	6398                	ld	a4,0(a5)
    80004b5e:	9736                	add	a4,a4,a3
    80004b60:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004b64:	6398                	ld	a4,0(a5)
    80004b66:	9736                	add	a4,a4,a3
    80004b68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004b6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004b70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004b74:	97aa                	add	a5,a5,a0
    80004b76:	4705                	li	a4,1
    80004b78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004b7c:	0001c517          	auipc	a0,0x1c
    80004b80:	7c450513          	addi	a0,a0,1988 # 80021340 <disk+0x18>
    80004b84:	9e5fc0ef          	jal	80001568 <wakeup>
}
    80004b88:	60a2                	ld	ra,8(sp)
    80004b8a:	6402                	ld	s0,0(sp)
    80004b8c:	0141                	addi	sp,sp,16
    80004b8e:	8082                	ret
    panic("free_desc 1");
    80004b90:	00003517          	auipc	a0,0x3
    80004b94:	a9050513          	addi	a0,a0,-1392 # 80007620 <etext+0x620>
    80004b98:	479000ef          	jal	80005810 <panic>
    panic("free_desc 2");
    80004b9c:	00003517          	auipc	a0,0x3
    80004ba0:	a9450513          	addi	a0,a0,-1388 # 80007630 <etext+0x630>
    80004ba4:	46d000ef          	jal	80005810 <panic>

0000000080004ba8 <virtio_disk_init>:
{
    80004ba8:	1101                	addi	sp,sp,-32
    80004baa:	ec06                	sd	ra,24(sp)
    80004bac:	e822                	sd	s0,16(sp)
    80004bae:	e426                	sd	s1,8(sp)
    80004bb0:	e04a                	sd	s2,0(sp)
    80004bb2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004bb4:	00003597          	auipc	a1,0x3
    80004bb8:	a8c58593          	addi	a1,a1,-1396 # 80007640 <etext+0x640>
    80004bbc:	0001d517          	auipc	a0,0x1d
    80004bc0:	89450513          	addi	a0,a0,-1900 # 80021450 <disk+0x128>
    80004bc4:	6fb000ef          	jal	80005abe <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004bc8:	100017b7          	lui	a5,0x10001
    80004bcc:	4398                	lw	a4,0(a5)
    80004bce:	2701                	sext.w	a4,a4
    80004bd0:	747277b7          	lui	a5,0x74727
    80004bd4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004bd8:	18f71063          	bne	a4,a5,80004d58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004bdc:	100017b7          	lui	a5,0x10001
    80004be0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004be2:	439c                	lw	a5,0(a5)
    80004be4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004be6:	4709                	li	a4,2
    80004be8:	16e79863          	bne	a5,a4,80004d58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004bec:	100017b7          	lui	a5,0x10001
    80004bf0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004bf2:	439c                	lw	a5,0(a5)
    80004bf4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004bf6:	16e79163          	bne	a5,a4,80004d58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004bfa:	100017b7          	lui	a5,0x10001
    80004bfe:	47d8                	lw	a4,12(a5)
    80004c00:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c02:	554d47b7          	lui	a5,0x554d4
    80004c06:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004c0a:	14f71763          	bne	a4,a5,80004d58 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c0e:	100017b7          	lui	a5,0x10001
    80004c12:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c16:	4705                	li	a4,1
    80004c18:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c1a:	470d                	li	a4,3
    80004c1c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004c1e:	10001737          	lui	a4,0x10001
    80004c22:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004c24:	c7ffe737          	lui	a4,0xc7ffe
    80004c28:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd51cf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004c2c:	8ef9                	and	a3,a3,a4
    80004c2e:	10001737          	lui	a4,0x10001
    80004c32:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c34:	472d                	li	a4,11
    80004c36:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c38:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004c3c:	439c                	lw	a5,0(a5)
    80004c3e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004c42:	8ba1                	andi	a5,a5,8
    80004c44:	12078063          	beqz	a5,80004d64 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004c48:	100017b7          	lui	a5,0x10001
    80004c4c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004c50:	100017b7          	lui	a5,0x10001
    80004c54:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004c58:	439c                	lw	a5,0(a5)
    80004c5a:	2781                	sext.w	a5,a5
    80004c5c:	10079a63          	bnez	a5,80004d70 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004c60:	100017b7          	lui	a5,0x10001
    80004c64:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004c68:	439c                	lw	a5,0(a5)
    80004c6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004c6c:	10078863          	beqz	a5,80004d7c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004c70:	471d                	li	a4,7
    80004c72:	10f77b63          	bgeu	a4,a5,80004d88 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004c76:	c80fb0ef          	jal	800000f6 <kalloc>
    80004c7a:	0001c497          	auipc	s1,0x1c
    80004c7e:	6ae48493          	addi	s1,s1,1710 # 80021328 <disk>
    80004c82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004c84:	c72fb0ef          	jal	800000f6 <kalloc>
    80004c88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004c8a:	c6cfb0ef          	jal	800000f6 <kalloc>
    80004c8e:	87aa                	mv	a5,a0
    80004c90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004c92:	6088                	ld	a0,0(s1)
    80004c94:	10050063          	beqz	a0,80004d94 <virtio_disk_init+0x1ec>
    80004c98:	0001c717          	auipc	a4,0x1c
    80004c9c:	69873703          	ld	a4,1688(a4) # 80021330 <disk+0x8>
    80004ca0:	0e070a63          	beqz	a4,80004d94 <virtio_disk_init+0x1ec>
    80004ca4:	0e078863          	beqz	a5,80004d94 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004ca8:	6605                	lui	a2,0x1
    80004caa:	4581                	li	a1,0
    80004cac:	cc8fb0ef          	jal	80000174 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004cb0:	0001c497          	auipc	s1,0x1c
    80004cb4:	67848493          	addi	s1,s1,1656 # 80021328 <disk>
    80004cb8:	6605                	lui	a2,0x1
    80004cba:	4581                	li	a1,0
    80004cbc:	6488                	ld	a0,8(s1)
    80004cbe:	cb6fb0ef          	jal	80000174 <memset>
  memset(disk.used, 0, PGSIZE);
    80004cc2:	6605                	lui	a2,0x1
    80004cc4:	4581                	li	a1,0
    80004cc6:	6888                	ld	a0,16(s1)
    80004cc8:	cacfb0ef          	jal	80000174 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004ccc:	100017b7          	lui	a5,0x10001
    80004cd0:	4721                	li	a4,8
    80004cd2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004cd4:	4098                	lw	a4,0(s1)
    80004cd6:	100017b7          	lui	a5,0x10001
    80004cda:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004cde:	40d8                	lw	a4,4(s1)
    80004ce0:	100017b7          	lui	a5,0x10001
    80004ce4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ce8:	649c                	ld	a5,8(s1)
    80004cea:	0007869b          	sext.w	a3,a5
    80004cee:	10001737          	lui	a4,0x10001
    80004cf2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004cf6:	9781                	srai	a5,a5,0x20
    80004cf8:	10001737          	lui	a4,0x10001
    80004cfc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d00:	689c                	ld	a5,16(s1)
    80004d02:	0007869b          	sext.w	a3,a5
    80004d06:	10001737          	lui	a4,0x10001
    80004d0a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d0e:	9781                	srai	a5,a5,0x20
    80004d10:	10001737          	lui	a4,0x10001
    80004d14:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004d18:	10001737          	lui	a4,0x10001
    80004d1c:	4785                	li	a5,1
    80004d1e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004d20:	00f48c23          	sb	a5,24(s1)
    80004d24:	00f48ca3          	sb	a5,25(s1)
    80004d28:	00f48d23          	sb	a5,26(s1)
    80004d2c:	00f48da3          	sb	a5,27(s1)
    80004d30:	00f48e23          	sb	a5,28(s1)
    80004d34:	00f48ea3          	sb	a5,29(s1)
    80004d38:	00f48f23          	sb	a5,30(s1)
    80004d3c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004d40:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d44:	100017b7          	lui	a5,0x10001
    80004d48:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004d4c:	60e2                	ld	ra,24(sp)
    80004d4e:	6442                	ld	s0,16(sp)
    80004d50:	64a2                	ld	s1,8(sp)
    80004d52:	6902                	ld	s2,0(sp)
    80004d54:	6105                	addi	sp,sp,32
    80004d56:	8082                	ret
    panic("could not find virtio disk");
    80004d58:	00003517          	auipc	a0,0x3
    80004d5c:	8f850513          	addi	a0,a0,-1800 # 80007650 <etext+0x650>
    80004d60:	2b1000ef          	jal	80005810 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004d64:	00003517          	auipc	a0,0x3
    80004d68:	90c50513          	addi	a0,a0,-1780 # 80007670 <etext+0x670>
    80004d6c:	2a5000ef          	jal	80005810 <panic>
    panic("virtio disk should not be ready");
    80004d70:	00003517          	auipc	a0,0x3
    80004d74:	92050513          	addi	a0,a0,-1760 # 80007690 <etext+0x690>
    80004d78:	299000ef          	jal	80005810 <panic>
    panic("virtio disk has no queue 0");
    80004d7c:	00003517          	auipc	a0,0x3
    80004d80:	93450513          	addi	a0,a0,-1740 # 800076b0 <etext+0x6b0>
    80004d84:	28d000ef          	jal	80005810 <panic>
    panic("virtio disk max queue too short");
    80004d88:	00003517          	auipc	a0,0x3
    80004d8c:	94850513          	addi	a0,a0,-1720 # 800076d0 <etext+0x6d0>
    80004d90:	281000ef          	jal	80005810 <panic>
    panic("virtio disk kalloc");
    80004d94:	00003517          	auipc	a0,0x3
    80004d98:	95c50513          	addi	a0,a0,-1700 # 800076f0 <etext+0x6f0>
    80004d9c:	275000ef          	jal	80005810 <panic>

0000000080004da0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004da0:	7159                	addi	sp,sp,-112
    80004da2:	f486                	sd	ra,104(sp)
    80004da4:	f0a2                	sd	s0,96(sp)
    80004da6:	eca6                	sd	s1,88(sp)
    80004da8:	e8ca                	sd	s2,80(sp)
    80004daa:	e4ce                	sd	s3,72(sp)
    80004dac:	e0d2                	sd	s4,64(sp)
    80004dae:	fc56                	sd	s5,56(sp)
    80004db0:	f85a                	sd	s6,48(sp)
    80004db2:	f45e                	sd	s7,40(sp)
    80004db4:	f062                	sd	s8,32(sp)
    80004db6:	ec66                	sd	s9,24(sp)
    80004db8:	1880                	addi	s0,sp,112
    80004dba:	8a2a                	mv	s4,a0
    80004dbc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004dbe:	00c52c83          	lw	s9,12(a0)
    80004dc2:	001c9c9b          	slliw	s9,s9,0x1
    80004dc6:	1c82                	slli	s9,s9,0x20
    80004dc8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004dcc:	0001c517          	auipc	a0,0x1c
    80004dd0:	68450513          	addi	a0,a0,1668 # 80021450 <disk+0x128>
    80004dd4:	56b000ef          	jal	80005b3e <acquire>
  for(int i = 0; i < 3; i++){
    80004dd8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004dda:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004ddc:	0001cb17          	auipc	s6,0x1c
    80004de0:	54cb0b13          	addi	s6,s6,1356 # 80021328 <disk>
  for(int i = 0; i < 3; i++){
    80004de4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004de6:	0001cc17          	auipc	s8,0x1c
    80004dea:	66ac0c13          	addi	s8,s8,1642 # 80021450 <disk+0x128>
    80004dee:	a8b9                	j	80004e4c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004df0:	00fb0733          	add	a4,s6,a5
    80004df4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004df8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004dfa:	0207c563          	bltz	a5,80004e24 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004dfe:	2905                	addiw	s2,s2,1
    80004e00:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e02:	05590963          	beq	s2,s5,80004e54 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004e06:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e08:	0001c717          	auipc	a4,0x1c
    80004e0c:	52070713          	addi	a4,a4,1312 # 80021328 <disk>
    80004e10:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004e12:	01874683          	lbu	a3,24(a4)
    80004e16:	fee9                	bnez	a3,80004df0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004e18:	2785                	addiw	a5,a5,1
    80004e1a:	0705                	addi	a4,a4,1
    80004e1c:	fe979be3          	bne	a5,s1,80004e12 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004e20:	57fd                	li	a5,-1
    80004e22:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004e24:	01205d63          	blez	s2,80004e3e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e28:	f9042503          	lw	a0,-112(s0)
    80004e2c:	d07ff0ef          	jal	80004b32 <free_desc>
      for(int j = 0; j < i; j++)
    80004e30:	4785                	li	a5,1
    80004e32:	0127d663          	bge	a5,s2,80004e3e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004e36:	f9442503          	lw	a0,-108(s0)
    80004e3a:	cf9ff0ef          	jal	80004b32 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004e3e:	85e2                	mv	a1,s8
    80004e40:	0001c517          	auipc	a0,0x1c
    80004e44:	50050513          	addi	a0,a0,1280 # 80021340 <disk+0x18>
    80004e48:	ecafc0ef          	jal	80001512 <sleep>
  for(int i = 0; i < 3; i++){
    80004e4c:	f9040613          	addi	a2,s0,-112
    80004e50:	894e                	mv	s2,s3
    80004e52:	bf55                	j	80004e06 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004e54:	f9042503          	lw	a0,-112(s0)
    80004e58:	00451693          	slli	a3,a0,0x4

  if(write)
    80004e5c:	0001c797          	auipc	a5,0x1c
    80004e60:	4cc78793          	addi	a5,a5,1228 # 80021328 <disk>
    80004e64:	00a50713          	addi	a4,a0,10
    80004e68:	0712                	slli	a4,a4,0x4
    80004e6a:	973e                	add	a4,a4,a5
    80004e6c:	01703633          	snez	a2,s7
    80004e70:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004e72:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004e76:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004e7a:	6398                	ld	a4,0(a5)
    80004e7c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004e7e:	0a868613          	addi	a2,a3,168
    80004e82:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004e84:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004e86:	6390                	ld	a2,0(a5)
    80004e88:	00d605b3          	add	a1,a2,a3
    80004e8c:	4741                	li	a4,16
    80004e8e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004e90:	4805                	li	a6,1
    80004e92:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004e96:	f9442703          	lw	a4,-108(s0)
    80004e9a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004e9e:	0712                	slli	a4,a4,0x4
    80004ea0:	963a                	add	a2,a2,a4
    80004ea2:	058a0593          	addi	a1,s4,88
    80004ea6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ea8:	0007b883          	ld	a7,0(a5)
    80004eac:	9746                	add	a4,a4,a7
    80004eae:	40000613          	li	a2,1024
    80004eb2:	c710                	sw	a2,8(a4)
  if(write)
    80004eb4:	001bb613          	seqz	a2,s7
    80004eb8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ebc:	00166613          	ori	a2,a2,1
    80004ec0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ec4:	f9842583          	lw	a1,-104(s0)
    80004ec8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ecc:	00250613          	addi	a2,a0,2
    80004ed0:	0612                	slli	a2,a2,0x4
    80004ed2:	963e                	add	a2,a2,a5
    80004ed4:	577d                	li	a4,-1
    80004ed6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004eda:	0592                	slli	a1,a1,0x4
    80004edc:	98ae                	add	a7,a7,a1
    80004ede:	03068713          	addi	a4,a3,48
    80004ee2:	973e                	add	a4,a4,a5
    80004ee4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004ee8:	6398                	ld	a4,0(a5)
    80004eea:	972e                	add	a4,a4,a1
    80004eec:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004ef0:	4689                	li	a3,2
    80004ef2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004ef6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004efa:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004efe:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f02:	6794                	ld	a3,8(a5)
    80004f04:	0026d703          	lhu	a4,2(a3)
    80004f08:	8b1d                	andi	a4,a4,7
    80004f0a:	0706                	slli	a4,a4,0x1
    80004f0c:	96ba                	add	a3,a3,a4
    80004f0e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f12:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f16:	6798                	ld	a4,8(a5)
    80004f18:	00275783          	lhu	a5,2(a4)
    80004f1c:	2785                	addiw	a5,a5,1
    80004f1e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004f22:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004f26:	100017b7          	lui	a5,0x10001
    80004f2a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004f2e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004f32:	0001c917          	auipc	s2,0x1c
    80004f36:	51e90913          	addi	s2,s2,1310 # 80021450 <disk+0x128>
  while(b->disk == 1) {
    80004f3a:	4485                	li	s1,1
    80004f3c:	01079a63          	bne	a5,a6,80004f50 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004f40:	85ca                	mv	a1,s2
    80004f42:	8552                	mv	a0,s4
    80004f44:	dcefc0ef          	jal	80001512 <sleep>
  while(b->disk == 1) {
    80004f48:	004a2783          	lw	a5,4(s4)
    80004f4c:	fe978ae3          	beq	a5,s1,80004f40 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004f50:	f9042903          	lw	s2,-112(s0)
    80004f54:	00290713          	addi	a4,s2,2
    80004f58:	0712                	slli	a4,a4,0x4
    80004f5a:	0001c797          	auipc	a5,0x1c
    80004f5e:	3ce78793          	addi	a5,a5,974 # 80021328 <disk>
    80004f62:	97ba                	add	a5,a5,a4
    80004f64:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004f68:	0001c997          	auipc	s3,0x1c
    80004f6c:	3c098993          	addi	s3,s3,960 # 80021328 <disk>
    80004f70:	00491713          	slli	a4,s2,0x4
    80004f74:	0009b783          	ld	a5,0(s3)
    80004f78:	97ba                	add	a5,a5,a4
    80004f7a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004f7e:	854a                	mv	a0,s2
    80004f80:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004f84:	bafff0ef          	jal	80004b32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004f88:	8885                	andi	s1,s1,1
    80004f8a:	f0fd                	bnez	s1,80004f70 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004f8c:	0001c517          	auipc	a0,0x1c
    80004f90:	4c450513          	addi	a0,a0,1220 # 80021450 <disk+0x128>
    80004f94:	443000ef          	jal	80005bd6 <release>
}
    80004f98:	70a6                	ld	ra,104(sp)
    80004f9a:	7406                	ld	s0,96(sp)
    80004f9c:	64e6                	ld	s1,88(sp)
    80004f9e:	6946                	ld	s2,80(sp)
    80004fa0:	69a6                	ld	s3,72(sp)
    80004fa2:	6a06                	ld	s4,64(sp)
    80004fa4:	7ae2                	ld	s5,56(sp)
    80004fa6:	7b42                	ld	s6,48(sp)
    80004fa8:	7ba2                	ld	s7,40(sp)
    80004faa:	7c02                	ld	s8,32(sp)
    80004fac:	6ce2                	ld	s9,24(sp)
    80004fae:	6165                	addi	sp,sp,112
    80004fb0:	8082                	ret

0000000080004fb2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004fb2:	1101                	addi	sp,sp,-32
    80004fb4:	ec06                	sd	ra,24(sp)
    80004fb6:	e822                	sd	s0,16(sp)
    80004fb8:	e426                	sd	s1,8(sp)
    80004fba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004fbc:	0001c497          	auipc	s1,0x1c
    80004fc0:	36c48493          	addi	s1,s1,876 # 80021328 <disk>
    80004fc4:	0001c517          	auipc	a0,0x1c
    80004fc8:	48c50513          	addi	a0,a0,1164 # 80021450 <disk+0x128>
    80004fcc:	373000ef          	jal	80005b3e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004fd0:	100017b7          	lui	a5,0x10001
    80004fd4:	53b8                	lw	a4,96(a5)
    80004fd6:	8b0d                	andi	a4,a4,3
    80004fd8:	100017b7          	lui	a5,0x10001
    80004fdc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004fde:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004fe2:	689c                	ld	a5,16(s1)
    80004fe4:	0204d703          	lhu	a4,32(s1)
    80004fe8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004fec:	08f70b63          	beq	a4,a5,80005082 <virtio_disk_intr+0xd0>
    80004ff0:	e04a                	sd	s2,0(sp)
    80004ff2:	a835                	j	8000502e <virtio_disk_intr+0x7c>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;

    if(disk.info[id].status != 0)
      panic("virtio_disk_intr status");
    80004ff4:	00002517          	auipc	a0,0x2
    80004ff8:	71450513          	addi	a0,a0,1812 # 80007708 <etext+0x708>
    80004ffc:	015000ef          	jal	80005810 <panic>
    // project
    if (!b->valid) { // read completed
  disk_stats.read_count++;
  disk_stats.read_bytes  += BSIZE;  // usually 512 bytes * sectors, here BSIZE is the buffer size
} else { // write completed
  disk_stats.write_count++;
    80005000:	1484b783          	ld	a5,328(s1)
    80005004:	0785                	addi	a5,a5,1
    80005006:	14f4b423          	sd	a5,328(s1)
  disk_stats.write_bytes  += BSIZE;
    8000500a:	1584b783          	ld	a5,344(s1)
    8000500e:	40078793          	addi	a5,a5,1024
    80005012:	14f4bc23          	sd	a5,344(s1)
}
    disk.used_idx += 1;
    80005016:	0204d783          	lhu	a5,32(s1)
    8000501a:	2785                	addiw	a5,a5,1
    8000501c:	17c2                	slli	a5,a5,0x30
    8000501e:	93c1                	srli	a5,a5,0x30
    80005020:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005024:	6898                	ld	a4,16(s1)
    80005026:	00275703          	lhu	a4,2(a4)
    8000502a:	04f70b63          	beq	a4,a5,80005080 <virtio_disk_intr+0xce>
    __sync_synchronize();
    8000502e:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005032:	6898                	ld	a4,16(s1)
    80005034:	0204d783          	lhu	a5,32(s1)
    80005038:	8b9d                	andi	a5,a5,7
    8000503a:	078e                	slli	a5,a5,0x3
    8000503c:	97ba                	add	a5,a5,a4
    8000503e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80005040:	00278713          	addi	a4,a5,2
    80005044:	0712                	slli	a4,a4,0x4
    80005046:	9726                	add	a4,a4,s1
    80005048:	01074703          	lbu	a4,16(a4)
    8000504c:	f745                	bnez	a4,80004ff4 <virtio_disk_intr+0x42>
    struct buf *b = disk.info[id].b;
    8000504e:	0789                	addi	a5,a5,2
    80005050:	0792                	slli	a5,a5,0x4
    80005052:	97a6                	add	a5,a5,s1
    80005054:	0087b903          	ld	s2,8(a5)
    b->disk = 0;   // disk is done with buf
    80005058:	00092223          	sw	zero,4(s2)
    wakeup(b);
    8000505c:	854a                	mv	a0,s2
    8000505e:	d0afc0ef          	jal	80001568 <wakeup>
    if (!b->valid) { // read completed
    80005062:	00092783          	lw	a5,0(s2)
    80005066:	ffc9                	bnez	a5,80005000 <virtio_disk_intr+0x4e>
  disk_stats.read_count++;
    80005068:	1404b783          	ld	a5,320(s1)
    8000506c:	0785                	addi	a5,a5,1
    8000506e:	14f4b023          	sd	a5,320(s1)
  disk_stats.read_bytes  += BSIZE;  // usually 512 bytes * sectors, here BSIZE is the buffer size
    80005072:	1504b783          	ld	a5,336(s1)
    80005076:	40078793          	addi	a5,a5,1024
    8000507a:	14f4b823          	sd	a5,336(s1)
    8000507e:	bf61                	j	80005016 <virtio_disk_intr+0x64>
    80005080:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005082:	0001c517          	auipc	a0,0x1c
    80005086:	3ce50513          	addi	a0,a0,974 # 80021450 <disk+0x128>
    8000508a:	34d000ef          	jal	80005bd6 <release>
}
    8000508e:	60e2                	ld	ra,24(sp)
    80005090:	6442                	ld	s0,16(sp)
    80005092:	64a2                	ld	s1,8(sp)
    80005094:	6105                	addi	sp,sp,32
    80005096:	8082                	ret

0000000080005098 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80005098:	1141                	addi	sp,sp,-16
    8000509a:	e422                	sd	s0,8(sp)
    8000509c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000509e:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800050a2:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800050a6:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800050aa:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050ae:	577d                	li	a4,-1
    800050b0:	177e                	slli	a4,a4,0x3f
    800050b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050b4:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800050b8:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800050bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800050c0:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800050c4:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800050c8:	000f4737          	lui	a4,0xf4
    800050cc:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800050d0:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800050d2:	14d79073          	csrw	stimecmp,a5
}
    800050d6:	6422                	ld	s0,8(sp)
    800050d8:	0141                	addi	sp,sp,16
    800050da:	8082                	ret

00000000800050dc <start>:
{
    800050dc:	1141                	addi	sp,sp,-16
    800050de:	e406                	sd	ra,8(sp)
    800050e0:	e022                	sd	s0,0(sp)
    800050e2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800050e4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800050e8:	7779                	lui	a4,0xffffe
    800050ea:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd526f>
    800050ee:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800050f0:	6705                	lui	a4,0x1
    800050f2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800050f6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800050f8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800050fc:	ffffb797          	auipc	a5,0xffffb
    80005100:	21278793          	addi	a5,a5,530 # 8000030e <main>
    80005104:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005108:	4781                	li	a5,0
    8000510a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000510e:	67c1                	lui	a5,0x10
    80005110:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005112:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005116:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000511a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000511e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005122:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005126:	57fd                	li	a5,-1
    80005128:	83a9                	srli	a5,a5,0xa
    8000512a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000512e:	47bd                	li	a5,15
    80005130:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005134:	f65ff0ef          	jal	80005098 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005138:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000513c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000513e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005140:	30200073          	mret
}
    80005144:	60a2                	ld	ra,8(sp)
    80005146:	6402                	ld	s0,0(sp)
    80005148:	0141                	addi	sp,sp,16
    8000514a:	8082                	ret

000000008000514c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000514c:	715d                	addi	sp,sp,-80
    8000514e:	e486                	sd	ra,72(sp)
    80005150:	e0a2                	sd	s0,64(sp)
    80005152:	f84a                	sd	s2,48(sp)
    80005154:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005156:	04c05263          	blez	a2,8000519a <consolewrite+0x4e>
    8000515a:	fc26                	sd	s1,56(sp)
    8000515c:	f44e                	sd	s3,40(sp)
    8000515e:	f052                	sd	s4,32(sp)
    80005160:	ec56                	sd	s5,24(sp)
    80005162:	8a2a                	mv	s4,a0
    80005164:	84ae                	mv	s1,a1
    80005166:	89b2                	mv	s3,a2
    80005168:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000516a:	5afd                	li	s5,-1
    8000516c:	4685                	li	a3,1
    8000516e:	8626                	mv	a2,s1
    80005170:	85d2                	mv	a1,s4
    80005172:	fbf40513          	addi	a0,s0,-65
    80005176:	f74fc0ef          	jal	800018ea <either_copyin>
    8000517a:	03550263          	beq	a0,s5,8000519e <consolewrite+0x52>
      break;
    uartputc(c);
    8000517e:	fbf44503          	lbu	a0,-65(s0)
    80005182:	035000ef          	jal	800059b6 <uartputc>
  for(i = 0; i < n; i++){
    80005186:	2905                	addiw	s2,s2,1
    80005188:	0485                	addi	s1,s1,1
    8000518a:	ff2991e3          	bne	s3,s2,8000516c <consolewrite+0x20>
    8000518e:	894e                	mv	s2,s3
    80005190:	74e2                	ld	s1,56(sp)
    80005192:	79a2                	ld	s3,40(sp)
    80005194:	7a02                	ld	s4,32(sp)
    80005196:	6ae2                	ld	s5,24(sp)
    80005198:	a039                	j	800051a6 <consolewrite+0x5a>
    8000519a:	4901                	li	s2,0
    8000519c:	a029                	j	800051a6 <consolewrite+0x5a>
    8000519e:	74e2                	ld	s1,56(sp)
    800051a0:	79a2                	ld	s3,40(sp)
    800051a2:	7a02                	ld	s4,32(sp)
    800051a4:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800051a6:	854a                	mv	a0,s2
    800051a8:	60a6                	ld	ra,72(sp)
    800051aa:	6406                	ld	s0,64(sp)
    800051ac:	7942                	ld	s2,48(sp)
    800051ae:	6161                	addi	sp,sp,80
    800051b0:	8082                	ret

00000000800051b2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800051b2:	711d                	addi	sp,sp,-96
    800051b4:	ec86                	sd	ra,88(sp)
    800051b6:	e8a2                	sd	s0,80(sp)
    800051b8:	e4a6                	sd	s1,72(sp)
    800051ba:	e0ca                	sd	s2,64(sp)
    800051bc:	fc4e                	sd	s3,56(sp)
    800051be:	f852                	sd	s4,48(sp)
    800051c0:	f456                	sd	s5,40(sp)
    800051c2:	f05a                	sd	s6,32(sp)
    800051c4:	1080                	addi	s0,sp,96
    800051c6:	8aaa                	mv	s5,a0
    800051c8:	8a2e                	mv	s4,a1
    800051ca:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800051cc:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800051d0:	00024517          	auipc	a0,0x24
    800051d4:	2c050513          	addi	a0,a0,704 # 80029490 <cons>
    800051d8:	167000ef          	jal	80005b3e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800051dc:	00024497          	auipc	s1,0x24
    800051e0:	2b448493          	addi	s1,s1,692 # 80029490 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800051e4:	00024917          	auipc	s2,0x24
    800051e8:	34490913          	addi	s2,s2,836 # 80029528 <cons+0x98>
  while(n > 0){
    800051ec:	0b305d63          	blez	s3,800052a6 <consoleread+0xf4>
    while(cons.r == cons.w){
    800051f0:	0984a783          	lw	a5,152(s1)
    800051f4:	09c4a703          	lw	a4,156(s1)
    800051f8:	0af71263          	bne	a4,a5,8000529c <consoleread+0xea>
      if(killed(myproc())){
    800051fc:	d1ffb0ef          	jal	80000f1a <myproc>
    80005200:	d70fc0ef          	jal	80001770 <killed>
    80005204:	e12d                	bnez	a0,80005266 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005206:	85a6                	mv	a1,s1
    80005208:	854a                	mv	a0,s2
    8000520a:	b08fc0ef          	jal	80001512 <sleep>
    while(cons.r == cons.w){
    8000520e:	0984a783          	lw	a5,152(s1)
    80005212:	09c4a703          	lw	a4,156(s1)
    80005216:	fef703e3          	beq	a4,a5,800051fc <consoleread+0x4a>
    8000521a:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000521c:	00024717          	auipc	a4,0x24
    80005220:	27470713          	addi	a4,a4,628 # 80029490 <cons>
    80005224:	0017869b          	addiw	a3,a5,1
    80005228:	08d72c23          	sw	a3,152(a4)
    8000522c:	07f7f693          	andi	a3,a5,127
    80005230:	9736                	add	a4,a4,a3
    80005232:	01874703          	lbu	a4,24(a4)
    80005236:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000523a:	4691                	li	a3,4
    8000523c:	04db8663          	beq	s7,a3,80005288 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005240:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005244:	4685                	li	a3,1
    80005246:	faf40613          	addi	a2,s0,-81
    8000524a:	85d2                	mv	a1,s4
    8000524c:	8556                	mv	a0,s5
    8000524e:	e52fc0ef          	jal	800018a0 <either_copyout>
    80005252:	57fd                	li	a5,-1
    80005254:	04f50863          	beq	a0,a5,800052a4 <consoleread+0xf2>
      break;

    dst++;
    80005258:	0a05                	addi	s4,s4,1
    --n;
    8000525a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000525c:	47a9                	li	a5,10
    8000525e:	04fb8d63          	beq	s7,a5,800052b8 <consoleread+0x106>
    80005262:	6be2                	ld	s7,24(sp)
    80005264:	b761                	j	800051ec <consoleread+0x3a>
        release(&cons.lock);
    80005266:	00024517          	auipc	a0,0x24
    8000526a:	22a50513          	addi	a0,a0,554 # 80029490 <cons>
    8000526e:	169000ef          	jal	80005bd6 <release>
        return -1;
    80005272:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005274:	60e6                	ld	ra,88(sp)
    80005276:	6446                	ld	s0,80(sp)
    80005278:	64a6                	ld	s1,72(sp)
    8000527a:	6906                	ld	s2,64(sp)
    8000527c:	79e2                	ld	s3,56(sp)
    8000527e:	7a42                	ld	s4,48(sp)
    80005280:	7aa2                	ld	s5,40(sp)
    80005282:	7b02                	ld	s6,32(sp)
    80005284:	6125                	addi	sp,sp,96
    80005286:	8082                	ret
      if(n < target){
    80005288:	0009871b          	sext.w	a4,s3
    8000528c:	01677a63          	bgeu	a4,s6,800052a0 <consoleread+0xee>
        cons.r--;
    80005290:	00024717          	auipc	a4,0x24
    80005294:	28f72c23          	sw	a5,664(a4) # 80029528 <cons+0x98>
    80005298:	6be2                	ld	s7,24(sp)
    8000529a:	a031                	j	800052a6 <consoleread+0xf4>
    8000529c:	ec5e                	sd	s7,24(sp)
    8000529e:	bfbd                	j	8000521c <consoleread+0x6a>
    800052a0:	6be2                	ld	s7,24(sp)
    800052a2:	a011                	j	800052a6 <consoleread+0xf4>
    800052a4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800052a6:	00024517          	auipc	a0,0x24
    800052aa:	1ea50513          	addi	a0,a0,490 # 80029490 <cons>
    800052ae:	129000ef          	jal	80005bd6 <release>
  return target - n;
    800052b2:	413b053b          	subw	a0,s6,s3
    800052b6:	bf7d                	j	80005274 <consoleread+0xc2>
    800052b8:	6be2                	ld	s7,24(sp)
    800052ba:	b7f5                	j	800052a6 <consoleread+0xf4>

00000000800052bc <consputc>:
{
    800052bc:	1141                	addi	sp,sp,-16
    800052be:	e406                	sd	ra,8(sp)
    800052c0:	e022                	sd	s0,0(sp)
    800052c2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800052c4:	10000793          	li	a5,256
    800052c8:	00f50863          	beq	a0,a5,800052d8 <consputc+0x1c>
    uartputc_sync(c);
    800052cc:	604000ef          	jal	800058d0 <uartputc_sync>
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800052d8:	4521                	li	a0,8
    800052da:	5f6000ef          	jal	800058d0 <uartputc_sync>
    800052de:	02000513          	li	a0,32
    800052e2:	5ee000ef          	jal	800058d0 <uartputc_sync>
    800052e6:	4521                	li	a0,8
    800052e8:	5e8000ef          	jal	800058d0 <uartputc_sync>
    800052ec:	b7d5                	j	800052d0 <consputc+0x14>

00000000800052ee <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800052ee:	1101                	addi	sp,sp,-32
    800052f0:	ec06                	sd	ra,24(sp)
    800052f2:	e822                	sd	s0,16(sp)
    800052f4:	e426                	sd	s1,8(sp)
    800052f6:	1000                	addi	s0,sp,32
    800052f8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800052fa:	00024517          	auipc	a0,0x24
    800052fe:	19650513          	addi	a0,a0,406 # 80029490 <cons>
    80005302:	03d000ef          	jal	80005b3e <acquire>

  switch(c){
    80005306:	47d5                	li	a5,21
    80005308:	08f48f63          	beq	s1,a5,800053a6 <consoleintr+0xb8>
    8000530c:	0297c563          	blt	a5,s1,80005336 <consoleintr+0x48>
    80005310:	47a1                	li	a5,8
    80005312:	0ef48463          	beq	s1,a5,800053fa <consoleintr+0x10c>
    80005316:	47c1                	li	a5,16
    80005318:	10f49563          	bne	s1,a5,80005422 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000531c:	e18fc0ef          	jal	80001934 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005320:	00024517          	auipc	a0,0x24
    80005324:	17050513          	addi	a0,a0,368 # 80029490 <cons>
    80005328:	0af000ef          	jal	80005bd6 <release>
}
    8000532c:	60e2                	ld	ra,24(sp)
    8000532e:	6442                	ld	s0,16(sp)
    80005330:	64a2                	ld	s1,8(sp)
    80005332:	6105                	addi	sp,sp,32
    80005334:	8082                	ret
  switch(c){
    80005336:	07f00793          	li	a5,127
    8000533a:	0cf48063          	beq	s1,a5,800053fa <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000533e:	00024717          	auipc	a4,0x24
    80005342:	15270713          	addi	a4,a4,338 # 80029490 <cons>
    80005346:	0a072783          	lw	a5,160(a4)
    8000534a:	09872703          	lw	a4,152(a4)
    8000534e:	9f99                	subw	a5,a5,a4
    80005350:	07f00713          	li	a4,127
    80005354:	fcf766e3          	bltu	a4,a5,80005320 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005358:	47b5                	li	a5,13
    8000535a:	0cf48763          	beq	s1,a5,80005428 <consoleintr+0x13a>
      consputc(c);
    8000535e:	8526                	mv	a0,s1
    80005360:	f5dff0ef          	jal	800052bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005364:	00024797          	auipc	a5,0x24
    80005368:	12c78793          	addi	a5,a5,300 # 80029490 <cons>
    8000536c:	0a07a683          	lw	a3,160(a5)
    80005370:	0016871b          	addiw	a4,a3,1
    80005374:	0007061b          	sext.w	a2,a4
    80005378:	0ae7a023          	sw	a4,160(a5)
    8000537c:	07f6f693          	andi	a3,a3,127
    80005380:	97b6                	add	a5,a5,a3
    80005382:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005386:	47a9                	li	a5,10
    80005388:	0cf48563          	beq	s1,a5,80005452 <consoleintr+0x164>
    8000538c:	4791                	li	a5,4
    8000538e:	0cf48263          	beq	s1,a5,80005452 <consoleintr+0x164>
    80005392:	00024797          	auipc	a5,0x24
    80005396:	1967a783          	lw	a5,406(a5) # 80029528 <cons+0x98>
    8000539a:	9f1d                	subw	a4,a4,a5
    8000539c:	08000793          	li	a5,128
    800053a0:	f8f710e3          	bne	a4,a5,80005320 <consoleintr+0x32>
    800053a4:	a07d                	j	80005452 <consoleintr+0x164>
    800053a6:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800053a8:	00024717          	auipc	a4,0x24
    800053ac:	0e870713          	addi	a4,a4,232 # 80029490 <cons>
    800053b0:	0a072783          	lw	a5,160(a4)
    800053b4:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053b8:	00024497          	auipc	s1,0x24
    800053bc:	0d848493          	addi	s1,s1,216 # 80029490 <cons>
    while(cons.e != cons.w &&
    800053c0:	4929                	li	s2,10
    800053c2:	02f70863          	beq	a4,a5,800053f2 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800053c6:	37fd                	addiw	a5,a5,-1
    800053c8:	07f7f713          	andi	a4,a5,127
    800053cc:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800053ce:	01874703          	lbu	a4,24(a4)
    800053d2:	03270263          	beq	a4,s2,800053f6 <consoleintr+0x108>
      cons.e--;
    800053d6:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800053da:	10000513          	li	a0,256
    800053de:	edfff0ef          	jal	800052bc <consputc>
    while(cons.e != cons.w &&
    800053e2:	0a04a783          	lw	a5,160(s1)
    800053e6:	09c4a703          	lw	a4,156(s1)
    800053ea:	fcf71ee3          	bne	a4,a5,800053c6 <consoleintr+0xd8>
    800053ee:	6902                	ld	s2,0(sp)
    800053f0:	bf05                	j	80005320 <consoleintr+0x32>
    800053f2:	6902                	ld	s2,0(sp)
    800053f4:	b735                	j	80005320 <consoleintr+0x32>
    800053f6:	6902                	ld	s2,0(sp)
    800053f8:	b725                	j	80005320 <consoleintr+0x32>
    if(cons.e != cons.w){
    800053fa:	00024717          	auipc	a4,0x24
    800053fe:	09670713          	addi	a4,a4,150 # 80029490 <cons>
    80005402:	0a072783          	lw	a5,160(a4)
    80005406:	09c72703          	lw	a4,156(a4)
    8000540a:	f0f70be3          	beq	a4,a5,80005320 <consoleintr+0x32>
      cons.e--;
    8000540e:	37fd                	addiw	a5,a5,-1
    80005410:	00024717          	auipc	a4,0x24
    80005414:	12f72023          	sw	a5,288(a4) # 80029530 <cons+0xa0>
      consputc(BACKSPACE);
    80005418:	10000513          	li	a0,256
    8000541c:	ea1ff0ef          	jal	800052bc <consputc>
    80005420:	b701                	j	80005320 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005422:	ee048fe3          	beqz	s1,80005320 <consoleintr+0x32>
    80005426:	bf21                	j	8000533e <consoleintr+0x50>
      consputc(c);
    80005428:	4529                	li	a0,10
    8000542a:	e93ff0ef          	jal	800052bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000542e:	00024797          	auipc	a5,0x24
    80005432:	06278793          	addi	a5,a5,98 # 80029490 <cons>
    80005436:	0a07a703          	lw	a4,160(a5)
    8000543a:	0017069b          	addiw	a3,a4,1
    8000543e:	0006861b          	sext.w	a2,a3
    80005442:	0ad7a023          	sw	a3,160(a5)
    80005446:	07f77713          	andi	a4,a4,127
    8000544a:	97ba                	add	a5,a5,a4
    8000544c:	4729                	li	a4,10
    8000544e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005452:	00024797          	auipc	a5,0x24
    80005456:	0cc7ad23          	sw	a2,218(a5) # 8002952c <cons+0x9c>
        wakeup(&cons.r);
    8000545a:	00024517          	auipc	a0,0x24
    8000545e:	0ce50513          	addi	a0,a0,206 # 80029528 <cons+0x98>
    80005462:	906fc0ef          	jal	80001568 <wakeup>
    80005466:	bd6d                	j	80005320 <consoleintr+0x32>

0000000080005468 <consoleinit>:

void
consoleinit(void)
{
    80005468:	1141                	addi	sp,sp,-16
    8000546a:	e406                	sd	ra,8(sp)
    8000546c:	e022                	sd	s0,0(sp)
    8000546e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005470:	00002597          	auipc	a1,0x2
    80005474:	2b058593          	addi	a1,a1,688 # 80007720 <etext+0x720>
    80005478:	00024517          	auipc	a0,0x24
    8000547c:	01850513          	addi	a0,a0,24 # 80029490 <cons>
    80005480:	63e000ef          	jal	80005abe <initlock>

  uartinit();
    80005484:	3f4000ef          	jal	80005878 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005488:	0001b797          	auipc	a5,0x1b
    8000548c:	e4878793          	addi	a5,a5,-440 # 800202d0 <devsw>
    80005490:	00000717          	auipc	a4,0x0
    80005494:	d2270713          	addi	a4,a4,-734 # 800051b2 <consoleread>
    80005498:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000549a:	00000717          	auipc	a4,0x0
    8000549e:	cb270713          	addi	a4,a4,-846 # 8000514c <consolewrite>
    800054a2:	ef98                	sd	a4,24(a5)
}
    800054a4:	60a2                	ld	ra,8(sp)
    800054a6:	6402                	ld	s0,0(sp)
    800054a8:	0141                	addi	sp,sp,16
    800054aa:	8082                	ret

00000000800054ac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800054ac:	7179                	addi	sp,sp,-48
    800054ae:	f406                	sd	ra,40(sp)
    800054b0:	f022                	sd	s0,32(sp)
    800054b2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800054b4:	c219                	beqz	a2,800054ba <printint+0xe>
    800054b6:	08054063          	bltz	a0,80005536 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800054ba:	4881                	li	a7,0
    800054bc:	fd040693          	addi	a3,s0,-48

  i = 0;
    800054c0:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800054c2:	00002617          	auipc	a2,0x2
    800054c6:	3de60613          	addi	a2,a2,990 # 800078a0 <digits>
    800054ca:	883e                	mv	a6,a5
    800054cc:	2785                	addiw	a5,a5,1
    800054ce:	02b57733          	remu	a4,a0,a1
    800054d2:	9732                	add	a4,a4,a2
    800054d4:	00074703          	lbu	a4,0(a4)
    800054d8:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800054dc:	872a                	mv	a4,a0
    800054de:	02b55533          	divu	a0,a0,a1
    800054e2:	0685                	addi	a3,a3,1
    800054e4:	feb773e3          	bgeu	a4,a1,800054ca <printint+0x1e>

  if(sign)
    800054e8:	00088a63          	beqz	a7,800054fc <printint+0x50>
    buf[i++] = '-';
    800054ec:	1781                	addi	a5,a5,-32
    800054ee:	97a2                	add	a5,a5,s0
    800054f0:	02d00713          	li	a4,45
    800054f4:	fee78823          	sb	a4,-16(a5)
    800054f8:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800054fc:	02f05963          	blez	a5,8000552e <printint+0x82>
    80005500:	ec26                	sd	s1,24(sp)
    80005502:	e84a                	sd	s2,16(sp)
    80005504:	fd040713          	addi	a4,s0,-48
    80005508:	00f704b3          	add	s1,a4,a5
    8000550c:	fff70913          	addi	s2,a4,-1
    80005510:	993e                	add	s2,s2,a5
    80005512:	37fd                	addiw	a5,a5,-1
    80005514:	1782                	slli	a5,a5,0x20
    80005516:	9381                	srli	a5,a5,0x20
    80005518:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000551c:	fff4c503          	lbu	a0,-1(s1)
    80005520:	d9dff0ef          	jal	800052bc <consputc>
  while(--i >= 0)
    80005524:	14fd                	addi	s1,s1,-1
    80005526:	ff249be3          	bne	s1,s2,8000551c <printint+0x70>
    8000552a:	64e2                	ld	s1,24(sp)
    8000552c:	6942                	ld	s2,16(sp)
}
    8000552e:	70a2                	ld	ra,40(sp)
    80005530:	7402                	ld	s0,32(sp)
    80005532:	6145                	addi	sp,sp,48
    80005534:	8082                	ret
    x = -xx;
    80005536:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000553a:	4885                	li	a7,1
    x = -xx;
    8000553c:	b741                	j	800054bc <printint+0x10>

000000008000553e <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000553e:	7155                	addi	sp,sp,-208
    80005540:	e506                	sd	ra,136(sp)
    80005542:	e122                	sd	s0,128(sp)
    80005544:	f0d2                	sd	s4,96(sp)
    80005546:	0900                	addi	s0,sp,144
    80005548:	8a2a                	mv	s4,a0
    8000554a:	e40c                	sd	a1,8(s0)
    8000554c:	e810                	sd	a2,16(s0)
    8000554e:	ec14                	sd	a3,24(s0)
    80005550:	f018                	sd	a4,32(s0)
    80005552:	f41c                	sd	a5,40(s0)
    80005554:	03043823          	sd	a6,48(s0)
    80005558:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000555c:	00024797          	auipc	a5,0x24
    80005560:	ff47a783          	lw	a5,-12(a5) # 80029550 <pr+0x18>
    80005564:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005568:	e3a1                	bnez	a5,800055a8 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000556a:	00840793          	addi	a5,s0,8
    8000556e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005572:	00054503          	lbu	a0,0(a0)
    80005576:	26050763          	beqz	a0,800057e4 <printf+0x2a6>
    8000557a:	fca6                	sd	s1,120(sp)
    8000557c:	f8ca                	sd	s2,112(sp)
    8000557e:	f4ce                	sd	s3,104(sp)
    80005580:	ecd6                	sd	s5,88(sp)
    80005582:	e8da                	sd	s6,80(sp)
    80005584:	e0e2                	sd	s8,64(sp)
    80005586:	fc66                	sd	s9,56(sp)
    80005588:	f86a                	sd	s10,48(sp)
    8000558a:	f46e                	sd	s11,40(sp)
    8000558c:	4981                	li	s3,0
    if(cx != '%'){
    8000558e:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005592:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005596:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000559a:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000559e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800055a2:	07000d93          	li	s11,112
    800055a6:	a815                	j	800055da <printf+0x9c>
    acquire(&pr.lock);
    800055a8:	00024517          	auipc	a0,0x24
    800055ac:	f9050513          	addi	a0,a0,-112 # 80029538 <pr>
    800055b0:	58e000ef          	jal	80005b3e <acquire>
  va_start(ap, fmt);
    800055b4:	00840793          	addi	a5,s0,8
    800055b8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055bc:	000a4503          	lbu	a0,0(s4)
    800055c0:	fd4d                	bnez	a0,8000557a <printf+0x3c>
    800055c2:	a481                	j	80005802 <printf+0x2c4>
      consputc(cx);
    800055c4:	cf9ff0ef          	jal	800052bc <consputc>
      continue;
    800055c8:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055ca:	0014899b          	addiw	s3,s1,1
    800055ce:	013a07b3          	add	a5,s4,s3
    800055d2:	0007c503          	lbu	a0,0(a5)
    800055d6:	1e050b63          	beqz	a0,800057cc <printf+0x28e>
    if(cx != '%'){
    800055da:	ff5515e3          	bne	a0,s5,800055c4 <printf+0x86>
    i++;
    800055de:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800055e2:	009a07b3          	add	a5,s4,s1
    800055e6:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800055ea:	1e090163          	beqz	s2,800057cc <printf+0x28e>
    800055ee:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800055f2:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800055f4:	c789                	beqz	a5,800055fe <printf+0xc0>
    800055f6:	009a0733          	add	a4,s4,s1
    800055fa:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800055fe:	03690763          	beq	s2,s6,8000562c <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005602:	05890163          	beq	s2,s8,80005644 <printf+0x106>
    } else if(c0 == 'u'){
    80005606:	0d990b63          	beq	s2,s9,800056dc <printf+0x19e>
    } else if(c0 == 'x'){
    8000560a:	13a90163          	beq	s2,s10,8000572c <printf+0x1ee>
    } else if(c0 == 'p'){
    8000560e:	13b90b63          	beq	s2,s11,80005744 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005612:	07300793          	li	a5,115
    80005616:	16f90a63          	beq	s2,a5,8000578a <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000561a:	1b590463          	beq	s2,s5,800057c2 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    8000561e:	8556                	mv	a0,s5
    80005620:	c9dff0ef          	jal	800052bc <consputc>
      consputc(c0);
    80005624:	854a                	mv	a0,s2
    80005626:	c97ff0ef          	jal	800052bc <consputc>
    8000562a:	b745                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000562c:	f8843783          	ld	a5,-120(s0)
    80005630:	00878713          	addi	a4,a5,8
    80005634:	f8e43423          	sd	a4,-120(s0)
    80005638:	4605                	li	a2,1
    8000563a:	45a9                	li	a1,10
    8000563c:	4388                	lw	a0,0(a5)
    8000563e:	e6fff0ef          	jal	800054ac <printint>
    80005642:	b761                	j	800055ca <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005644:	03678663          	beq	a5,s6,80005670 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005648:	05878263          	beq	a5,s8,8000568c <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000564c:	0b978463          	beq	a5,s9,800056f4 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005650:	fda797e3          	bne	a5,s10,8000561e <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005654:	f8843783          	ld	a5,-120(s0)
    80005658:	00878713          	addi	a4,a5,8
    8000565c:	f8e43423          	sd	a4,-120(s0)
    80005660:	4601                	li	a2,0
    80005662:	45c1                	li	a1,16
    80005664:	6388                	ld	a0,0(a5)
    80005666:	e47ff0ef          	jal	800054ac <printint>
      i += 1;
    8000566a:	0029849b          	addiw	s1,s3,2
    8000566e:	bfb1                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005670:	f8843783          	ld	a5,-120(s0)
    80005674:	00878713          	addi	a4,a5,8
    80005678:	f8e43423          	sd	a4,-120(s0)
    8000567c:	4605                	li	a2,1
    8000567e:	45a9                	li	a1,10
    80005680:	6388                	ld	a0,0(a5)
    80005682:	e2bff0ef          	jal	800054ac <printint>
      i += 1;
    80005686:	0029849b          	addiw	s1,s3,2
    8000568a:	b781                	j	800055ca <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000568c:	06400793          	li	a5,100
    80005690:	02f68863          	beq	a3,a5,800056c0 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005694:	07500793          	li	a5,117
    80005698:	06f68c63          	beq	a3,a5,80005710 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000569c:	07800793          	li	a5,120
    800056a0:	f6f69fe3          	bne	a3,a5,8000561e <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800056a4:	f8843783          	ld	a5,-120(s0)
    800056a8:	00878713          	addi	a4,a5,8
    800056ac:	f8e43423          	sd	a4,-120(s0)
    800056b0:	4601                	li	a2,0
    800056b2:	45c1                	li	a1,16
    800056b4:	6388                	ld	a0,0(a5)
    800056b6:	df7ff0ef          	jal	800054ac <printint>
      i += 2;
    800056ba:	0039849b          	addiw	s1,s3,3
    800056be:	b731                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800056c0:	f8843783          	ld	a5,-120(s0)
    800056c4:	00878713          	addi	a4,a5,8
    800056c8:	f8e43423          	sd	a4,-120(s0)
    800056cc:	4605                	li	a2,1
    800056ce:	45a9                	li	a1,10
    800056d0:	6388                	ld	a0,0(a5)
    800056d2:	ddbff0ef          	jal	800054ac <printint>
      i += 2;
    800056d6:	0039849b          	addiw	s1,s3,3
    800056da:	bdc5                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800056dc:	f8843783          	ld	a5,-120(s0)
    800056e0:	00878713          	addi	a4,a5,8
    800056e4:	f8e43423          	sd	a4,-120(s0)
    800056e8:	4601                	li	a2,0
    800056ea:	45a9                	li	a1,10
    800056ec:	4388                	lw	a0,0(a5)
    800056ee:	dbfff0ef          	jal	800054ac <printint>
    800056f2:	bde1                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800056f4:	f8843783          	ld	a5,-120(s0)
    800056f8:	00878713          	addi	a4,a5,8
    800056fc:	f8e43423          	sd	a4,-120(s0)
    80005700:	4601                	li	a2,0
    80005702:	45a9                	li	a1,10
    80005704:	6388                	ld	a0,0(a5)
    80005706:	da7ff0ef          	jal	800054ac <printint>
      i += 1;
    8000570a:	0029849b          	addiw	s1,s3,2
    8000570e:	bd75                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005710:	f8843783          	ld	a5,-120(s0)
    80005714:	00878713          	addi	a4,a5,8
    80005718:	f8e43423          	sd	a4,-120(s0)
    8000571c:	4601                	li	a2,0
    8000571e:	45a9                	li	a1,10
    80005720:	6388                	ld	a0,0(a5)
    80005722:	d8bff0ef          	jal	800054ac <printint>
      i += 2;
    80005726:	0039849b          	addiw	s1,s3,3
    8000572a:	b545                	j	800055ca <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000572c:	f8843783          	ld	a5,-120(s0)
    80005730:	00878713          	addi	a4,a5,8
    80005734:	f8e43423          	sd	a4,-120(s0)
    80005738:	4601                	li	a2,0
    8000573a:	45c1                	li	a1,16
    8000573c:	4388                	lw	a0,0(a5)
    8000573e:	d6fff0ef          	jal	800054ac <printint>
    80005742:	b561                	j	800055ca <printf+0x8c>
    80005744:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005746:	f8843783          	ld	a5,-120(s0)
    8000574a:	00878713          	addi	a4,a5,8
    8000574e:	f8e43423          	sd	a4,-120(s0)
    80005752:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005756:	03000513          	li	a0,48
    8000575a:	b63ff0ef          	jal	800052bc <consputc>
  consputc('x');
    8000575e:	07800513          	li	a0,120
    80005762:	b5bff0ef          	jal	800052bc <consputc>
    80005766:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005768:	00002b97          	auipc	s7,0x2
    8000576c:	138b8b93          	addi	s7,s7,312 # 800078a0 <digits>
    80005770:	03c9d793          	srli	a5,s3,0x3c
    80005774:	97de                	add	a5,a5,s7
    80005776:	0007c503          	lbu	a0,0(a5)
    8000577a:	b43ff0ef          	jal	800052bc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000577e:	0992                	slli	s3,s3,0x4
    80005780:	397d                	addiw	s2,s2,-1
    80005782:	fe0917e3          	bnez	s2,80005770 <printf+0x232>
    80005786:	6ba6                	ld	s7,72(sp)
    80005788:	b589                	j	800055ca <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000578a:	f8843783          	ld	a5,-120(s0)
    8000578e:	00878713          	addi	a4,a5,8
    80005792:	f8e43423          	sd	a4,-120(s0)
    80005796:	0007b903          	ld	s2,0(a5)
    8000579a:	00090d63          	beqz	s2,800057b4 <printf+0x276>
      for(; *s; s++)
    8000579e:	00094503          	lbu	a0,0(s2)
    800057a2:	e20504e3          	beqz	a0,800055ca <printf+0x8c>
        consputc(*s);
    800057a6:	b17ff0ef          	jal	800052bc <consputc>
      for(; *s; s++)
    800057aa:	0905                	addi	s2,s2,1
    800057ac:	00094503          	lbu	a0,0(s2)
    800057b0:	f97d                	bnez	a0,800057a6 <printf+0x268>
    800057b2:	bd21                	j	800055ca <printf+0x8c>
        s = "(null)";
    800057b4:	00002917          	auipc	s2,0x2
    800057b8:	f7490913          	addi	s2,s2,-140 # 80007728 <etext+0x728>
      for(; *s; s++)
    800057bc:	02800513          	li	a0,40
    800057c0:	b7dd                	j	800057a6 <printf+0x268>
      consputc('%');
    800057c2:	02500513          	li	a0,37
    800057c6:	af7ff0ef          	jal	800052bc <consputc>
    800057ca:	b501                	j	800055ca <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800057cc:	f7843783          	ld	a5,-136(s0)
    800057d0:	e385                	bnez	a5,800057f0 <printf+0x2b2>
    800057d2:	74e6                	ld	s1,120(sp)
    800057d4:	7946                	ld	s2,112(sp)
    800057d6:	79a6                	ld	s3,104(sp)
    800057d8:	6ae6                	ld	s5,88(sp)
    800057da:	6b46                	ld	s6,80(sp)
    800057dc:	6c06                	ld	s8,64(sp)
    800057de:	7ce2                	ld	s9,56(sp)
    800057e0:	7d42                	ld	s10,48(sp)
    800057e2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800057e4:	4501                	li	a0,0
    800057e6:	60aa                	ld	ra,136(sp)
    800057e8:	640a                	ld	s0,128(sp)
    800057ea:	7a06                	ld	s4,96(sp)
    800057ec:	6169                	addi	sp,sp,208
    800057ee:	8082                	ret
    800057f0:	74e6                	ld	s1,120(sp)
    800057f2:	7946                	ld	s2,112(sp)
    800057f4:	79a6                	ld	s3,104(sp)
    800057f6:	6ae6                	ld	s5,88(sp)
    800057f8:	6b46                	ld	s6,80(sp)
    800057fa:	6c06                	ld	s8,64(sp)
    800057fc:	7ce2                	ld	s9,56(sp)
    800057fe:	7d42                	ld	s10,48(sp)
    80005800:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005802:	00024517          	auipc	a0,0x24
    80005806:	d3650513          	addi	a0,a0,-714 # 80029538 <pr>
    8000580a:	3cc000ef          	jal	80005bd6 <release>
    8000580e:	bfd9                	j	800057e4 <printf+0x2a6>

0000000080005810 <panic>:

void
panic(char *s)
{
    80005810:	1101                	addi	sp,sp,-32
    80005812:	ec06                	sd	ra,24(sp)
    80005814:	e822                	sd	s0,16(sp)
    80005816:	e426                	sd	s1,8(sp)
    80005818:	1000                	addi	s0,sp,32
    8000581a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000581c:	00024797          	auipc	a5,0x24
    80005820:	d207aa23          	sw	zero,-716(a5) # 80029550 <pr+0x18>
  printf("panic: ");
    80005824:	00002517          	auipc	a0,0x2
    80005828:	f0c50513          	addi	a0,a0,-244 # 80007730 <etext+0x730>
    8000582c:	d13ff0ef          	jal	8000553e <printf>
  printf("%s\n", s);
    80005830:	85a6                	mv	a1,s1
    80005832:	00002517          	auipc	a0,0x2
    80005836:	f0650513          	addi	a0,a0,-250 # 80007738 <etext+0x738>
    8000583a:	d05ff0ef          	jal	8000553e <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000583e:	4785                	li	a5,1
    80005840:	00005717          	auipc	a4,0x5
    80005844:	bcf72423          	sw	a5,-1080(a4) # 8000a408 <panicked>
  for(;;)
    80005848:	a001                	j	80005848 <panic+0x38>

000000008000584a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000584a:	1101                	addi	sp,sp,-32
    8000584c:	ec06                	sd	ra,24(sp)
    8000584e:	e822                	sd	s0,16(sp)
    80005850:	e426                	sd	s1,8(sp)
    80005852:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005854:	00024497          	auipc	s1,0x24
    80005858:	ce448493          	addi	s1,s1,-796 # 80029538 <pr>
    8000585c:	00002597          	auipc	a1,0x2
    80005860:	ee458593          	addi	a1,a1,-284 # 80007740 <etext+0x740>
    80005864:	8526                	mv	a0,s1
    80005866:	258000ef          	jal	80005abe <initlock>
  pr.locking = 1;
    8000586a:	4785                	li	a5,1
    8000586c:	cc9c                	sw	a5,24(s1)
}
    8000586e:	60e2                	ld	ra,24(sp)
    80005870:	6442                	ld	s0,16(sp)
    80005872:	64a2                	ld	s1,8(sp)
    80005874:	6105                	addi	sp,sp,32
    80005876:	8082                	ret

0000000080005878 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005878:	1141                	addi	sp,sp,-16
    8000587a:	e406                	sd	ra,8(sp)
    8000587c:	e022                	sd	s0,0(sp)
    8000587e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005880:	100007b7          	lui	a5,0x10000
    80005884:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005888:	10000737          	lui	a4,0x10000
    8000588c:	f8000693          	li	a3,-128
    80005890:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005894:	468d                	li	a3,3
    80005896:	10000637          	lui	a2,0x10000
    8000589a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000589e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800058a2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800058a6:	10000737          	lui	a4,0x10000
    800058aa:	461d                	li	a2,7
    800058ac:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800058b0:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800058b4:	00002597          	auipc	a1,0x2
    800058b8:	e9458593          	addi	a1,a1,-364 # 80007748 <etext+0x748>
    800058bc:	00024517          	auipc	a0,0x24
    800058c0:	c9c50513          	addi	a0,a0,-868 # 80029558 <uart_tx_lock>
    800058c4:	1fa000ef          	jal	80005abe <initlock>
}
    800058c8:	60a2                	ld	ra,8(sp)
    800058ca:	6402                	ld	s0,0(sp)
    800058cc:	0141                	addi	sp,sp,16
    800058ce:	8082                	ret

00000000800058d0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800058d0:	1101                	addi	sp,sp,-32
    800058d2:	ec06                	sd	ra,24(sp)
    800058d4:	e822                	sd	s0,16(sp)
    800058d6:	e426                	sd	s1,8(sp)
    800058d8:	1000                	addi	s0,sp,32
    800058da:	84aa                	mv	s1,a0
  push_off();
    800058dc:	222000ef          	jal	80005afe <push_off>

  if(panicked){
    800058e0:	00005797          	auipc	a5,0x5
    800058e4:	b287a783          	lw	a5,-1240(a5) # 8000a408 <panicked>
    800058e8:	e795                	bnez	a5,80005914 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800058ea:	10000737          	lui	a4,0x10000
    800058ee:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800058f0:	00074783          	lbu	a5,0(a4)
    800058f4:	0207f793          	andi	a5,a5,32
    800058f8:	dfe5                	beqz	a5,800058f0 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800058fa:	0ff4f513          	zext.b	a0,s1
    800058fe:	100007b7          	lui	a5,0x10000
    80005902:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005906:	27c000ef          	jal	80005b82 <pop_off>
}
    8000590a:	60e2                	ld	ra,24(sp)
    8000590c:	6442                	ld	s0,16(sp)
    8000590e:	64a2                	ld	s1,8(sp)
    80005910:	6105                	addi	sp,sp,32
    80005912:	8082                	ret
    for(;;)
    80005914:	a001                	j	80005914 <uartputc_sync+0x44>

0000000080005916 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005916:	00005797          	auipc	a5,0x5
    8000591a:	afa7b783          	ld	a5,-1286(a5) # 8000a410 <uart_tx_r>
    8000591e:	00005717          	auipc	a4,0x5
    80005922:	afa73703          	ld	a4,-1286(a4) # 8000a418 <uart_tx_w>
    80005926:	08f70263          	beq	a4,a5,800059aa <uartstart+0x94>
{
    8000592a:	7139                	addi	sp,sp,-64
    8000592c:	fc06                	sd	ra,56(sp)
    8000592e:	f822                	sd	s0,48(sp)
    80005930:	f426                	sd	s1,40(sp)
    80005932:	f04a                	sd	s2,32(sp)
    80005934:	ec4e                	sd	s3,24(sp)
    80005936:	e852                	sd	s4,16(sp)
    80005938:	e456                	sd	s5,8(sp)
    8000593a:	e05a                	sd	s6,0(sp)
    8000593c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000593e:	10000937          	lui	s2,0x10000
    80005942:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005944:	00024a97          	auipc	s5,0x24
    80005948:	c14a8a93          	addi	s5,s5,-1004 # 80029558 <uart_tx_lock>
    uart_tx_r += 1;
    8000594c:	00005497          	auipc	s1,0x5
    80005950:	ac448493          	addi	s1,s1,-1340 # 8000a410 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005954:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005958:	00005997          	auipc	s3,0x5
    8000595c:	ac098993          	addi	s3,s3,-1344 # 8000a418 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005960:	00094703          	lbu	a4,0(s2)
    80005964:	02077713          	andi	a4,a4,32
    80005968:	c71d                	beqz	a4,80005996 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000596a:	01f7f713          	andi	a4,a5,31
    8000596e:	9756                	add	a4,a4,s5
    80005970:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005974:	0785                	addi	a5,a5,1
    80005976:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80005978:	8526                	mv	a0,s1
    8000597a:	beffb0ef          	jal	80001568 <wakeup>
    WriteReg(THR, c);
    8000597e:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005982:	609c                	ld	a5,0(s1)
    80005984:	0009b703          	ld	a4,0(s3)
    80005988:	fcf71ce3          	bne	a4,a5,80005960 <uartstart+0x4a>
      ReadReg(ISR);
    8000598c:	100007b7          	lui	a5,0x10000
    80005990:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005992:	0007c783          	lbu	a5,0(a5)
  }
}
    80005996:	70e2                	ld	ra,56(sp)
    80005998:	7442                	ld	s0,48(sp)
    8000599a:	74a2                	ld	s1,40(sp)
    8000599c:	7902                	ld	s2,32(sp)
    8000599e:	69e2                	ld	s3,24(sp)
    800059a0:	6a42                	ld	s4,16(sp)
    800059a2:	6aa2                	ld	s5,8(sp)
    800059a4:	6b02                	ld	s6,0(sp)
    800059a6:	6121                	addi	sp,sp,64
    800059a8:	8082                	ret
      ReadReg(ISR);
    800059aa:	100007b7          	lui	a5,0x10000
    800059ae:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800059b0:	0007c783          	lbu	a5,0(a5)
      return;
    800059b4:	8082                	ret

00000000800059b6 <uartputc>:
{
    800059b6:	7179                	addi	sp,sp,-48
    800059b8:	f406                	sd	ra,40(sp)
    800059ba:	f022                	sd	s0,32(sp)
    800059bc:	ec26                	sd	s1,24(sp)
    800059be:	e84a                	sd	s2,16(sp)
    800059c0:	e44e                	sd	s3,8(sp)
    800059c2:	e052                	sd	s4,0(sp)
    800059c4:	1800                	addi	s0,sp,48
    800059c6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800059c8:	00024517          	auipc	a0,0x24
    800059cc:	b9050513          	addi	a0,a0,-1136 # 80029558 <uart_tx_lock>
    800059d0:	16e000ef          	jal	80005b3e <acquire>
  if(panicked){
    800059d4:	00005797          	auipc	a5,0x5
    800059d8:	a347a783          	lw	a5,-1484(a5) # 8000a408 <panicked>
    800059dc:	efbd                	bnez	a5,80005a5a <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800059de:	00005717          	auipc	a4,0x5
    800059e2:	a3a73703          	ld	a4,-1478(a4) # 8000a418 <uart_tx_w>
    800059e6:	00005797          	auipc	a5,0x5
    800059ea:	a2a7b783          	ld	a5,-1494(a5) # 8000a410 <uart_tx_r>
    800059ee:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800059f2:	00024997          	auipc	s3,0x24
    800059f6:	b6698993          	addi	s3,s3,-1178 # 80029558 <uart_tx_lock>
    800059fa:	00005497          	auipc	s1,0x5
    800059fe:	a1648493          	addi	s1,s1,-1514 # 8000a410 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a02:	00005917          	auipc	s2,0x5
    80005a06:	a1690913          	addi	s2,s2,-1514 # 8000a418 <uart_tx_w>
    80005a0a:	00e79d63          	bne	a5,a4,80005a24 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005a0e:	85ce                	mv	a1,s3
    80005a10:	8526                	mv	a0,s1
    80005a12:	b01fb0ef          	jal	80001512 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005a16:	00093703          	ld	a4,0(s2)
    80005a1a:	609c                	ld	a5,0(s1)
    80005a1c:	02078793          	addi	a5,a5,32
    80005a20:	fee787e3          	beq	a5,a4,80005a0e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005a24:	00024497          	auipc	s1,0x24
    80005a28:	b3448493          	addi	s1,s1,-1228 # 80029558 <uart_tx_lock>
    80005a2c:	01f77793          	andi	a5,a4,31
    80005a30:	97a6                	add	a5,a5,s1
    80005a32:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005a36:	0705                	addi	a4,a4,1
    80005a38:	00005797          	auipc	a5,0x5
    80005a3c:	9ee7b023          	sd	a4,-1568(a5) # 8000a418 <uart_tx_w>
  uartstart();
    80005a40:	ed7ff0ef          	jal	80005916 <uartstart>
  release(&uart_tx_lock);
    80005a44:	8526                	mv	a0,s1
    80005a46:	190000ef          	jal	80005bd6 <release>
}
    80005a4a:	70a2                	ld	ra,40(sp)
    80005a4c:	7402                	ld	s0,32(sp)
    80005a4e:	64e2                	ld	s1,24(sp)
    80005a50:	6942                	ld	s2,16(sp)
    80005a52:	69a2                	ld	s3,8(sp)
    80005a54:	6a02                	ld	s4,0(sp)
    80005a56:	6145                	addi	sp,sp,48
    80005a58:	8082                	ret
    for(;;)
    80005a5a:	a001                	j	80005a5a <uartputc+0xa4>

0000000080005a5c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005a5c:	1141                	addi	sp,sp,-16
    80005a5e:	e422                	sd	s0,8(sp)
    80005a60:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005a62:	100007b7          	lui	a5,0x10000
    80005a66:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005a68:	0007c783          	lbu	a5,0(a5)
    80005a6c:	8b85                	andi	a5,a5,1
    80005a6e:	cb81                	beqz	a5,80005a7e <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005a70:	100007b7          	lui	a5,0x10000
    80005a74:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005a78:	6422                	ld	s0,8(sp)
    80005a7a:	0141                	addi	sp,sp,16
    80005a7c:	8082                	ret
    return -1;
    80005a7e:	557d                	li	a0,-1
    80005a80:	bfe5                	j	80005a78 <uartgetc+0x1c>

0000000080005a82 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005a82:	1101                	addi	sp,sp,-32
    80005a84:	ec06                	sd	ra,24(sp)
    80005a86:	e822                	sd	s0,16(sp)
    80005a88:	e426                	sd	s1,8(sp)
    80005a8a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005a8c:	54fd                	li	s1,-1
    80005a8e:	a019                	j	80005a94 <uartintr+0x12>
      break;
    consoleintr(c);
    80005a90:	85fff0ef          	jal	800052ee <consoleintr>
    int c = uartgetc();
    80005a94:	fc9ff0ef          	jal	80005a5c <uartgetc>
    if(c == -1)
    80005a98:	fe951ce3          	bne	a0,s1,80005a90 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005a9c:	00024497          	auipc	s1,0x24
    80005aa0:	abc48493          	addi	s1,s1,-1348 # 80029558 <uart_tx_lock>
    80005aa4:	8526                	mv	a0,s1
    80005aa6:	098000ef          	jal	80005b3e <acquire>
  uartstart();
    80005aaa:	e6dff0ef          	jal	80005916 <uartstart>
  release(&uart_tx_lock);
    80005aae:	8526                	mv	a0,s1
    80005ab0:	126000ef          	jal	80005bd6 <release>
}
    80005ab4:	60e2                	ld	ra,24(sp)
    80005ab6:	6442                	ld	s0,16(sp)
    80005ab8:	64a2                	ld	s1,8(sp)
    80005aba:	6105                	addi	sp,sp,32
    80005abc:	8082                	ret

0000000080005abe <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005abe:	1141                	addi	sp,sp,-16
    80005ac0:	e422                	sd	s0,8(sp)
    80005ac2:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ac4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005ac6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005aca:	00053823          	sd	zero,16(a0)
}
    80005ace:	6422                	ld	s0,8(sp)
    80005ad0:	0141                	addi	sp,sp,16
    80005ad2:	8082                	ret

0000000080005ad4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005ad4:	411c                	lw	a5,0(a0)
    80005ad6:	e399                	bnez	a5,80005adc <holding+0x8>
    80005ad8:	4501                	li	a0,0
  return r;
}
    80005ada:	8082                	ret
{
    80005adc:	1101                	addi	sp,sp,-32
    80005ade:	ec06                	sd	ra,24(sp)
    80005ae0:	e822                	sd	s0,16(sp)
    80005ae2:	e426                	sd	s1,8(sp)
    80005ae4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005ae6:	6904                	ld	s1,16(a0)
    80005ae8:	c16fb0ef          	jal	80000efe <mycpu>
    80005aec:	40a48533          	sub	a0,s1,a0
    80005af0:	00153513          	seqz	a0,a0
}
    80005af4:	60e2                	ld	ra,24(sp)
    80005af6:	6442                	ld	s0,16(sp)
    80005af8:	64a2                	ld	s1,8(sp)
    80005afa:	6105                	addi	sp,sp,32
    80005afc:	8082                	ret

0000000080005afe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005afe:	1101                	addi	sp,sp,-32
    80005b00:	ec06                	sd	ra,24(sp)
    80005b02:	e822                	sd	s0,16(sp)
    80005b04:	e426                	sd	s1,8(sp)
    80005b06:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b08:	100024f3          	csrr	s1,sstatus
    80005b0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005b10:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005b12:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005b16:	be8fb0ef          	jal	80000efe <mycpu>
    80005b1a:	5d3c                	lw	a5,120(a0)
    80005b1c:	cb99                	beqz	a5,80005b32 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005b1e:	be0fb0ef          	jal	80000efe <mycpu>
    80005b22:	5d3c                	lw	a5,120(a0)
    80005b24:	2785                	addiw	a5,a5,1
    80005b26:	dd3c                	sw	a5,120(a0)
}
    80005b28:	60e2                	ld	ra,24(sp)
    80005b2a:	6442                	ld	s0,16(sp)
    80005b2c:	64a2                	ld	s1,8(sp)
    80005b2e:	6105                	addi	sp,sp,32
    80005b30:	8082                	ret
    mycpu()->intena = old;
    80005b32:	bccfb0ef          	jal	80000efe <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005b36:	8085                	srli	s1,s1,0x1
    80005b38:	8885                	andi	s1,s1,1
    80005b3a:	dd64                	sw	s1,124(a0)
    80005b3c:	b7cd                	j	80005b1e <push_off+0x20>

0000000080005b3e <acquire>:
{
    80005b3e:	1101                	addi	sp,sp,-32
    80005b40:	ec06                	sd	ra,24(sp)
    80005b42:	e822                	sd	s0,16(sp)
    80005b44:	e426                	sd	s1,8(sp)
    80005b46:	1000                	addi	s0,sp,32
    80005b48:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005b4a:	fb5ff0ef          	jal	80005afe <push_off>
  if(holding(lk))
    80005b4e:	8526                	mv	a0,s1
    80005b50:	f85ff0ef          	jal	80005ad4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b54:	4705                	li	a4,1
  if(holding(lk))
    80005b56:	e105                	bnez	a0,80005b76 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005b58:	87ba                	mv	a5,a4
    80005b5a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005b5e:	2781                	sext.w	a5,a5
    80005b60:	ffe5                	bnez	a5,80005b58 <acquire+0x1a>
  __sync_synchronize();
    80005b62:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005b66:	b98fb0ef          	jal	80000efe <mycpu>
    80005b6a:	e888                	sd	a0,16(s1)
}
    80005b6c:	60e2                	ld	ra,24(sp)
    80005b6e:	6442                	ld	s0,16(sp)
    80005b70:	64a2                	ld	s1,8(sp)
    80005b72:	6105                	addi	sp,sp,32
    80005b74:	8082                	ret
    panic("acquire");
    80005b76:	00002517          	auipc	a0,0x2
    80005b7a:	bda50513          	addi	a0,a0,-1062 # 80007750 <etext+0x750>
    80005b7e:	c93ff0ef          	jal	80005810 <panic>

0000000080005b82 <pop_off>:

void
pop_off(void)
{
    80005b82:	1141                	addi	sp,sp,-16
    80005b84:	e406                	sd	ra,8(sp)
    80005b86:	e022                	sd	s0,0(sp)
    80005b88:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005b8a:	b74fb0ef          	jal	80000efe <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005b8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005b92:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005b94:	e78d                	bnez	a5,80005bbe <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005b96:	5d3c                	lw	a5,120(a0)
    80005b98:	02f05963          	blez	a5,80005bca <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005b9c:	37fd                	addiw	a5,a5,-1
    80005b9e:	0007871b          	sext.w	a4,a5
    80005ba2:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005ba4:	eb09                	bnez	a4,80005bb6 <pop_off+0x34>
    80005ba6:	5d7c                	lw	a5,124(a0)
    80005ba8:	c799                	beqz	a5,80005bb6 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005baa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005bae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005bb2:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005bb6:	60a2                	ld	ra,8(sp)
    80005bb8:	6402                	ld	s0,0(sp)
    80005bba:	0141                	addi	sp,sp,16
    80005bbc:	8082                	ret
    panic("pop_off - interruptible");
    80005bbe:	00002517          	auipc	a0,0x2
    80005bc2:	b9a50513          	addi	a0,a0,-1126 # 80007758 <etext+0x758>
    80005bc6:	c4bff0ef          	jal	80005810 <panic>
    panic("pop_off");
    80005bca:	00002517          	auipc	a0,0x2
    80005bce:	ba650513          	addi	a0,a0,-1114 # 80007770 <etext+0x770>
    80005bd2:	c3fff0ef          	jal	80005810 <panic>

0000000080005bd6 <release>:
{
    80005bd6:	1101                	addi	sp,sp,-32
    80005bd8:	ec06                	sd	ra,24(sp)
    80005bda:	e822                	sd	s0,16(sp)
    80005bdc:	e426                	sd	s1,8(sp)
    80005bde:	1000                	addi	s0,sp,32
    80005be0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005be2:	ef3ff0ef          	jal	80005ad4 <holding>
    80005be6:	c105                	beqz	a0,80005c06 <release+0x30>
  lk->cpu = 0;
    80005be8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005bec:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005bf0:	0310000f          	fence	rw,w
    80005bf4:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005bf8:	f8bff0ef          	jal	80005b82 <pop_off>
}
    80005bfc:	60e2                	ld	ra,24(sp)
    80005bfe:	6442                	ld	s0,16(sp)
    80005c00:	64a2                	ld	s1,8(sp)
    80005c02:	6105                	addi	sp,sp,32
    80005c04:	8082                	ret
    panic("release");
    80005c06:	00002517          	auipc	a0,0x2
    80005c0a:	b7250513          	addi	a0,a0,-1166 # 80007778 <etext+0x778>
    80005c0e:	c03ff0ef          	jal	80005810 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
