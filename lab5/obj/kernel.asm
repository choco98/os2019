
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 12 00 	lgdtl  0x12a018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 a0 12 c0       	mov    $0xc012a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b8 f0 19 c0       	mov    $0xc019f0b8,%edx
c0100035:	b8 2a bf 19 c0       	mov    $0xc019bf2a,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 2a bf 19 c0 	movl   $0xc019bf2a,(%esp)
c0100051:	e8 58 bb 00 00       	call   c010bbae <memset>

    cons_init();                // init the console
c0100056:	e8 80 16 00 00       	call   c01016db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 40 bd 10 c0 	movl   $0xc010bd40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 5c bd 10 c0 	movl   $0xc010bd5c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 05 09 00 00       	call   c010097f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 7a 56 00 00       	call   c01056fe <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 20 00 00       	call   c01020b9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 a8 21 00 00       	call   c0102236 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 26 85 00 00       	call   c01085b9 <vmm_init>
    proc_init();                // init process table
c0100093:	e8 d9 aa 00 00       	call   c010ab71 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 6f 17 00 00       	call   c010180c <ide_init>
    swap_init();                // init swap
c010009d:	e8 0f 6d 00 00       	call   c0106db1 <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 ea 0d 00 00       	call   c0100e91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 7b 1f 00 00       	call   c0102027 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 7f ac 00 00       	call   c010ad30 <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 f0 0c 00 00       	call   c0100dc3 <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 61 bd 10 c0 	movl   $0xc010bd61,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 6f bd 10 c0 	movl   $0xc010bd6f,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 7d bd 10 c0 	movl   $0xc010bd7d,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 8b bd 10 c0 	movl   $0xc010bd8b,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 99 bd 10 c0 	movl   $0xc010bd99,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 40 bf 19 c0       	mov    0xc019bf40,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 40 bf 19 c0       	mov    %eax,0xc019bf40
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 a8 bd 10 c0 	movl   $0xc010bda8,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 c8 bd 10 c0 	movl   $0xc010bdc8,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 e7 bd 10 c0 	movl   $0xc010bde7,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 60 bf 19 c0    	mov    %dl,-0x3fe640a0(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 60 bf 19 c0       	add    $0xc019bf60,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 60 bf 19 c0       	mov    $0xc019bf60,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 f6 13 00 00       	call   c0101707 <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 a1 af 00 00       	call   c010b2ef <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 7d 13 00 00       	call   c0101707 <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 5d 13 00 00       	call   c0101743 <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 ec bd 10 c0    	movl   $0xc010bdec,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 ec bd 10 c0 	movl   $0xc010bdec,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058a:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100591:	76 21                	jbe    c01005b4 <debuginfo_eip+0x6a>
        stabs = __STAB_BEGIN__;
c0100593:	c7 45 f4 40 e4 10 c0 	movl   $0xc010e440,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059a:	c7 45 f0 a8 26 12 c0 	movl   $0xc01226a8,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a1:	c7 45 ec a9 26 12 c0 	movl   $0xc01226a9,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005a8:	c7 45 e8 9b 73 12 c0 	movl   $0xc012739b,-0x18(%ebp)
c01005af:	e9 ea 00 00 00       	jmp    c010069e <debuginfo_eip+0x154>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b4:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005bb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c0:	85 c0                	test   %eax,%eax
c01005c2:	74 11                	je     c01005d5 <debuginfo_eip+0x8b>
c01005c4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01005c9:	8b 40 18             	mov    0x18(%eax),%eax
c01005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d3:	75 0a                	jne    c01005df <debuginfo_eip+0x95>
            return -1;
c01005d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005da:	e9 9e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005e9:	00 
c01005ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f1:	00 
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 a5 88 00 00       	call   c0108ea6 <user_mem_check>
c0100601:	85 c0                	test   %eax,%eax
c0100603:	75 0a                	jne    c010060f <debuginfo_eip+0xc5>
            return -1;
c0100605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060a:	e9 6e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }

        stabs = usd->stabs;
c010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	8b 40 04             	mov    0x4(%eax),%eax
c010061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100623:	8b 40 08             	mov    0x8(%eax),%eax
c0100626:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c0100629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062c:	8b 40 0c             	mov    0xc(%eax),%eax
c010062f:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100638:	29 c2                	sub    %eax,%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100644:	00 
c0100645:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100650:	89 04 24             	mov    %eax,(%esp)
c0100653:	e8 4e 88 00 00       	call   c0108ea6 <user_mem_check>
c0100658:	85 c0                	test   %eax,%eax
c010065a:	75 0a                	jne    c0100666 <debuginfo_eip+0x11c>
            return -1;
c010065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100661:	e9 17 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c0100666:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100669:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066c:	29 c2                	sub    %eax,%edx
c010066e:	89 d0                	mov    %edx,%eax
c0100670:	89 c2                	mov    %eax,%edx
c0100672:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010067c:	00 
c010067d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100681:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100685:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100688:	89 04 24             	mov    %eax,(%esp)
c010068b:	e8 16 88 00 00       	call   c0108ea6 <user_mem_check>
c0100690:	85 c0                	test   %eax,%eax
c0100692:	75 0a                	jne    c010069e <debuginfo_eip+0x154>
            return -1;
c0100694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100699:	e9 df 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010069e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006a4:	76 0d                	jbe    c01006b3 <debuginfo_eip+0x169>
c01006a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a9:	83 e8 01             	sub    $0x1,%eax
c01006ac:	0f b6 00             	movzbl (%eax),%eax
c01006af:	84 c0                	test   %al,%al
c01006b1:	74 0a                	je     c01006bd <debuginfo_eip+0x173>
        return -1;
c01006b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b8:	e9 c0 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ca:	29 c2                	sub    %eax,%edx
c01006cc:	89 d0                	mov    %edx,%eax
c01006ce:	c1 f8 02             	sar    $0x2,%eax
c01006d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006d7:	83 e8 01             	sub    $0x1,%eax
c01006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006eb:	00 
c01006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fd:	89 04 24             	mov    %eax,(%esp)
c0100700:	e8 ef fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c0100705:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100708:	85 c0                	test   %eax,%eax
c010070a:	75 0a                	jne    c0100716 <debuginfo_eip+0x1cc>
        return -1;
c010070c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100711:	e9 67 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100716:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010071c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010071f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100722:	8b 45 08             	mov    0x8(%ebp),%eax
c0100725:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100729:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100730:	00 
c0100731:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100734:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100738:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010073b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100742:	89 04 24             	mov    %eax,(%esp)
c0100745:	e8 aa fc ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c010074a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010074d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100750:	39 c2                	cmp    %eax,%edx
c0100752:	7f 7c                	jg     c01007d0 <debuginfo_eip+0x286>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	89 d0                	mov    %edx,%eax
c010075b:	01 c0                	add    %eax,%eax
c010075d:	01 d0                	add    %edx,%eax
c010075f:	c1 e0 02             	shl    $0x2,%eax
c0100762:	89 c2                	mov    %eax,%edx
c0100764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100767:	01 d0                	add    %edx,%eax
c0100769:	8b 10                	mov    (%eax),%edx
c010076b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100771:	29 c1                	sub    %eax,%ecx
c0100773:	89 c8                	mov    %ecx,%eax
c0100775:	39 c2                	cmp    %eax,%edx
c0100777:	73 22                	jae    c010079b <debuginfo_eip+0x251>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077c:	89 c2                	mov    %eax,%edx
c010077e:	89 d0                	mov    %edx,%eax
c0100780:	01 c0                	add    %eax,%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	c1 e0 02             	shl    $0x2,%eax
c0100787:	89 c2                	mov    %eax,%edx
c0100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078c:	01 d0                	add    %edx,%eax
c010078e:	8b 10                	mov    (%eax),%edx
c0100790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100793:	01 c2                	add    %eax,%edx
c0100795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100798:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	8b 50 08             	mov    0x8(%eax),%edx
c01007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bc:	8b 40 10             	mov    0x10(%eax),%eax
c01007bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007ce:	eb 15                	jmp    c01007e5 <debuginfo_eip+0x29b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e8:	8b 40 08             	mov    0x8(%eax),%eax
c01007eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f2:	00 
c01007f3:	89 04 24             	mov    %eax,(%esp)
c01007f6:	e8 27 b2 00 00       	call   c010ba22 <strfind>
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100800:	8b 40 08             	mov    0x8(%eax),%eax
c0100803:	29 c2                	sub    %eax,%edx
c0100805:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100808:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010080b:	8b 45 08             	mov    0x8(%ebp),%eax
c010080e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100812:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100819:	00 
c010081a:	8d 45 c8             	lea    -0x38(%ebp),%eax
c010081d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100821:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100824:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082b:	89 04 24             	mov    %eax,(%esp)
c010082e:	e8 c1 fb ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c0100833:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100836:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100839:	39 c2                	cmp    %eax,%edx
c010083b:	7f 24                	jg     c0100861 <debuginfo_eip+0x317>
        info->eip_line = stabs[rline].n_desc;
c010083d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100840:	89 c2                	mov    %eax,%edx
c0100842:	89 d0                	mov    %edx,%eax
c0100844:	01 c0                	add    %eax,%eax
c0100846:	01 d0                	add    %edx,%eax
c0100848:	c1 e0 02             	shl    $0x2,%eax
c010084b:	89 c2                	mov    %eax,%edx
c010084d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100850:	01 d0                	add    %edx,%eax
c0100852:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100856:	0f b7 d0             	movzwl %ax,%edx
c0100859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010085c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010085f:	eb 13                	jmp    c0100874 <debuginfo_eip+0x32a>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100866:	e9 12 01 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010086b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010086e:	83 e8 01             	sub    $0x1,%eax
c0100871:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100874:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100877:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010087a:	39 c2                	cmp    %eax,%edx
c010087c:	7c 56                	jl     c01008d4 <debuginfo_eip+0x38a>
           && stabs[lline].n_type != N_SOL
c010087e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100881:	89 c2                	mov    %eax,%edx
c0100883:	89 d0                	mov    %edx,%eax
c0100885:	01 c0                	add    %eax,%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	c1 e0 02             	shl    $0x2,%eax
c010088c:	89 c2                	mov    %eax,%edx
c010088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100891:	01 d0                	add    %edx,%eax
c0100893:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100897:	3c 84                	cmp    $0x84,%al
c0100899:	74 39                	je     c01008d4 <debuginfo_eip+0x38a>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010089b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008b4:	3c 64                	cmp    $0x64,%al
c01008b6:	75 b3                	jne    c010086b <debuginfo_eip+0x321>
c01008b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008bb:	89 c2                	mov    %eax,%edx
c01008bd:	89 d0                	mov    %edx,%eax
c01008bf:	01 c0                	add    %eax,%eax
c01008c1:	01 d0                	add    %edx,%eax
c01008c3:	c1 e0 02             	shl    $0x2,%eax
c01008c6:	89 c2                	mov    %eax,%edx
c01008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cb:	01 d0                	add    %edx,%eax
c01008cd:	8b 40 08             	mov    0x8(%eax),%eax
c01008d0:	85 c0                	test   %eax,%eax
c01008d2:	74 97                	je     c010086b <debuginfo_eip+0x321>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008da:	39 c2                	cmp    %eax,%edx
c01008dc:	7c 46                	jl     c0100924 <debuginfo_eip+0x3da>
c01008de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008e1:	89 c2                	mov    %eax,%edx
c01008e3:	89 d0                	mov    %edx,%eax
c01008e5:	01 c0                	add    %eax,%eax
c01008e7:	01 d0                	add    %edx,%eax
c01008e9:	c1 e0 02             	shl    $0x2,%eax
c01008ec:	89 c2                	mov    %eax,%edx
c01008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f1:	01 d0                	add    %edx,%eax
c01008f3:	8b 10                	mov    (%eax),%edx
c01008f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008fb:	29 c1                	sub    %eax,%ecx
c01008fd:	89 c8                	mov    %ecx,%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	73 21                	jae    c0100924 <debuginfo_eip+0x3da>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100903:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100906:	89 c2                	mov    %eax,%edx
c0100908:	89 d0                	mov    %edx,%eax
c010090a:	01 c0                	add    %eax,%eax
c010090c:	01 d0                	add    %edx,%eax
c010090e:	c1 e0 02             	shl    $0x2,%eax
c0100911:	89 c2                	mov    %eax,%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8b 10                	mov    (%eax),%edx
c010091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091d:	01 c2                	add    %eax,%edx
c010091f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100922:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100927:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010092a:	39 c2                	cmp    %eax,%edx
c010092c:	7d 4a                	jge    c0100978 <debuginfo_eip+0x42e>
        for (lline = lfun + 1;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	83 c0 01             	add    $0x1,%eax
c0100934:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0100937:	eb 18                	jmp    c0100951 <debuginfo_eip+0x407>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100948:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010094b:	83 c0 01             	add    $0x1,%eax
c010094e:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100951:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100954:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100957:	39 c2                	cmp    %eax,%edx
c0100959:	7d 1d                	jge    c0100978 <debuginfo_eip+0x42e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010095e:	89 c2                	mov    %eax,%edx
c0100960:	89 d0                	mov    %edx,%eax
c0100962:	01 c0                	add    %eax,%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	c1 e0 02             	shl    $0x2,%eax
c0100969:	89 c2                	mov    %eax,%edx
c010096b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096e:	01 d0                	add    %edx,%eax
c0100970:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100974:	3c a0                	cmp    $0xa0,%al
c0100976:	74 c1                	je     c0100939 <debuginfo_eip+0x3ef>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100978:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097d:	c9                   	leave  
c010097e:	c3                   	ret    

c010097f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097f:	55                   	push   %ebp
c0100980:	89 e5                	mov    %esp,%ebp
c0100982:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100985:	c7 04 24 f6 bd 10 c0 	movl   $0xc010bdf6,(%esp)
c010098c:	e8 c2 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100991:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100998:	c0 
c0100999:	c7 04 24 0f be 10 c0 	movl   $0xc010be0f,(%esp)
c01009a0:	e8 ae f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a5:	c7 44 24 04 37 bd 10 	movl   $0xc010bd37,0x4(%esp)
c01009ac:	c0 
c01009ad:	c7 04 24 27 be 10 c0 	movl   $0xc010be27,(%esp)
c01009b4:	e8 9a f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009b9:	c7 44 24 04 2a bf 19 	movl   $0xc019bf2a,0x4(%esp)
c01009c0:	c0 
c01009c1:	c7 04 24 3f be 10 c0 	movl   $0xc010be3f,(%esp)
c01009c8:	e8 86 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cd:	c7 44 24 04 b8 f0 19 	movl   $0xc019f0b8,0x4(%esp)
c01009d4:	c0 
c01009d5:	c7 04 24 57 be 10 c0 	movl   $0xc010be57,(%esp)
c01009dc:	e8 72 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e1:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c01009e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009f1:	29 c2                	sub    %eax,%edx
c01009f3:	89 d0                	mov    %edx,%eax
c01009f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009fb:	85 c0                	test   %eax,%eax
c01009fd:	0f 48 c2             	cmovs  %edx,%eax
c0100a00:	c1 f8 0a             	sar    $0xa,%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 70 be 10 c0 	movl   $0xc010be70,(%esp)
c0100a0e:	e8 40 f9 ff ff       	call   c0100353 <cprintf>
}
c0100a13:	c9                   	leave  
c0100a14:	c3                   	ret    

c0100a15 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a15:	55                   	push   %ebp
c0100a16:	89 e5                	mov    %esp,%ebp
c0100a18:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a1e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a28:	89 04 24             	mov    %eax,(%esp)
c0100a2b:	e8 1a fb ff ff       	call   c010054a <debuginfo_eip>
c0100a30:	85 c0                	test   %eax,%eax
c0100a32:	74 15                	je     c0100a49 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 9a be 10 c0 	movl   $0xc010be9a,(%esp)
c0100a42:	e8 0c f9 ff ff       	call   c0100353 <cprintf>
c0100a47:	eb 6d                	jmp    c0100ab6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a50:	eb 1c                	jmp    c0100a6e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a66:	01 ca                	add    %ecx,%edx
c0100a68:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a74:	7f dc                	jg     c0100a52 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a76:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7f:	01 d0                	add    %edx,%eax
c0100a81:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8a:	89 d1                	mov    %edx,%ecx
c0100a8c:	29 c1                	sub    %eax,%ecx
c0100a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a94:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a98:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaa:	c7 04 24 b6 be 10 c0 	movl   $0xc010beb6,(%esp)
c0100ab1:	e8 9d f8 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100ab6:	c9                   	leave  
c0100ab7:	c3                   	ret    

c0100ab8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ab8:	55                   	push   %ebp
c0100ab9:	89 e5                	mov    %esp,%ebp
c0100abb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100abe:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ac7:	c9                   	leave  
c0100ac8:	c3                   	ret    

c0100ac9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100acf:	89 e8                	mov    %ebp,%eax
c0100ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();
c0100ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ada:	e8 d9 ff ff ff       	call   c0100ab8 <read_eip>
c0100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
c0100ae2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ae9:	e9 88 00 00 00       	jmp    c0100b76 <print_stackframe+0xad>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100af1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100afc:	c7 04 24 c8 be 10 c0 	movl   $0xc010bec8,(%esp)
c0100b03:	e8 4b f8 ff ff       	call   c0100353 <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	83 c0 08             	add    $0x8,%eax
c0100b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(b = 0; b < 4; b ++){
c0100b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b18:	eb 25                	jmp    c0100b3f <print_stackframe+0x76>
			cprintf("0x%08x ", args[b]);
c0100b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b27:	01 d0                	add    %edx,%eax
c0100b29:	8b 00                	mov    (%eax),%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 e4 be 10 c0 	movl   $0xc010bee4,(%esp)
c0100b36:	e8 18 f8 ff ff       	call   c0100353 <cprintf>

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		for(b = 0; b < 4; b ++){
c0100b3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b43:	7e d5                	jle    c0100b1a <print_stackframe+0x51>
			cprintf("0x%08x ", args[b]);
		}
		cprintf("\n");
c0100b45:	c7 04 24 ec be 10 c0 	movl   $0xc010beec,(%esp)
c0100b4c:	e8 02 f8 ff ff       	call   c0100353 <cprintf>
		print_debuginfo(eip - 1);
c0100b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b54:	83 e8 01             	sub    $0x1,%eax
c0100b57:	89 04 24             	mov    %eax,(%esp)
c0100b5a:	e8 b6 fe ff ff       	call   c0100a15 <print_debuginfo>
		eip = ((uint32_t *)ebp)[1];
c0100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b62:	83 c0 04             	add    $0x4,%eax
c0100b65:	8b 00                	mov    (%eax),%eax
c0100b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t *)ebp)[0];
c0100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6d:	8b 00                	mov    (%eax),%eax
c0100b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
c0100b72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b7a:	74 0a                	je     c0100b86 <print_stackframe+0xbd>
c0100b7c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b80:	0f 8e 68 ff ff ff    	jle    c0100aee <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = ((uint32_t *)ebp)[1];
		ebp = ((uint32_t *)ebp)[0];
	}
}
c0100b86:	c9                   	leave  
c0100b87:	c3                   	ret    

c0100b88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b88:	55                   	push   %ebp
c0100b89:	89 e5                	mov    %esp,%ebp
c0100b8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b95:	eb 0c                	jmp    c0100ba3 <parse+0x1b>
            *buf ++ = '\0';
c0100b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba6:	0f b6 00             	movzbl (%eax),%eax
c0100ba9:	84 c0                	test   %al,%al
c0100bab:	74 1d                	je     c0100bca <parse+0x42>
c0100bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb0:	0f b6 00             	movzbl (%eax),%eax
c0100bb3:	0f be c0             	movsbl %al,%eax
c0100bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bba:	c7 04 24 70 bf 10 c0 	movl   $0xc010bf70,(%esp)
c0100bc1:	e8 29 ae 00 00       	call   c010b9ef <strchr>
c0100bc6:	85 c0                	test   %eax,%eax
c0100bc8:	75 cd                	jne    c0100b97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcd:	0f b6 00             	movzbl (%eax),%eax
c0100bd0:	84 c0                	test   %al,%al
c0100bd2:	75 02                	jne    c0100bd6 <parse+0x4e>
            break;
c0100bd4:	eb 67                	jmp    c0100c3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bd6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bda:	75 14                	jne    c0100bf0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bdc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100be3:	00 
c0100be4:	c7 04 24 75 bf 10 c0 	movl   $0xc010bf75,(%esp)
c0100beb:	e8 63 f7 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf3:	8d 50 01             	lea    0x1(%eax),%edx
c0100bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c03:	01 c2                	add    %eax,%edx
c0100c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0a:	eb 04                	jmp    c0100c10 <parse+0x88>
            buf ++;
c0100c0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	0f b6 00             	movzbl (%eax),%eax
c0100c16:	84 c0                	test   %al,%al
c0100c18:	74 1d                	je     c0100c37 <parse+0xaf>
c0100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1d:	0f b6 00             	movzbl (%eax),%eax
c0100c20:	0f be c0             	movsbl %al,%eax
c0100c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c27:	c7 04 24 70 bf 10 c0 	movl   $0xc010bf70,(%esp)
c0100c2e:	e8 bc ad 00 00       	call   c010b9ef <strchr>
c0100c33:	85 c0                	test   %eax,%eax
c0100c35:	74 d5                	je     c0100c0c <parse+0x84>
            buf ++;
        }
    }
c0100c37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c38:	e9 66 ff ff ff       	jmp    c0100ba3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c40:	c9                   	leave  
c0100c41:	c3                   	ret    

c0100c42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c42:	55                   	push   %ebp
c0100c43:	89 e5                	mov    %esp,%ebp
c0100c45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c52:	89 04 24             	mov    %eax,(%esp)
c0100c55:	e8 2e ff ff ff       	call   c0100b88 <parse>
c0100c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c61:	75 0a                	jne    c0100c6d <runcmd+0x2b>
        return 0;
c0100c63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c68:	e9 85 00 00 00       	jmp    c0100cf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c74:	eb 5c                	jmp    c0100cd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7c:	89 d0                	mov    %edx,%eax
c0100c7e:	01 c0                	add    %eax,%eax
c0100c80:	01 d0                	add    %edx,%eax
c0100c82:	c1 e0 02             	shl    $0x2,%eax
c0100c85:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100c8a:	8b 00                	mov    (%eax),%eax
c0100c8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c90:	89 04 24             	mov    %eax,(%esp)
c0100c93:	e8 b8 ac 00 00       	call   c010b950 <strcmp>
c0100c98:	85 c0                	test   %eax,%eax
c0100c9a:	75 32                	jne    c0100cce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9f:	89 d0                	mov    %edx,%eax
c0100ca1:	01 c0                	add    %eax,%eax
c0100ca3:	01 d0                	add    %edx,%eax
c0100ca5:	c1 e0 02             	shl    $0x2,%eax
c0100ca8:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100cad:	8b 40 08             	mov    0x8(%eax),%eax
c0100cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100cb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100cb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100cc0:	83 c2 04             	add    $0x4,%edx
c0100cc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100cc7:	89 0c 24             	mov    %ecx,(%esp)
c0100cca:	ff d0                	call   *%eax
c0100ccc:	eb 24                	jmp    c0100cf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd5:	83 f8 02             	cmp    $0x2,%eax
c0100cd8:	76 9c                	jbe    c0100c76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce1:	c7 04 24 93 bf 10 c0 	movl   $0xc010bf93,(%esp)
c0100ce8:	e8 66 f6 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf2:	c9                   	leave  
c0100cf3:	c3                   	ret    

c0100cf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf4:	55                   	push   %ebp
c0100cf5:	89 e5                	mov    %esp,%ebp
c0100cf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cfa:	c7 04 24 ac bf 10 c0 	movl   $0xc010bfac,(%esp)
c0100d01:	e8 4d f6 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d06:	c7 04 24 d4 bf 10 c0 	movl   $0xc010bfd4,(%esp)
c0100d0d:	e8 41 f6 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d16:	74 0b                	je     c0100d23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 c8 16 00 00       	call   c01023eb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d23:	c7 04 24 f9 bf 10 c0 	movl   $0xc010bff9,(%esp)
c0100d2a:	e8 1b f5 ff ff       	call   c010024a <readline>
c0100d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d36:	74 18                	je     c0100d50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d42:	89 04 24             	mov    %eax,(%esp)
c0100d45:	e8 f8 fe ff ff       	call   c0100c42 <runcmd>
c0100d4a:	85 c0                	test   %eax,%eax
c0100d4c:	79 02                	jns    c0100d50 <kmonitor+0x5c>
                break;
c0100d4e:	eb 02                	jmp    c0100d52 <kmonitor+0x5e>
            }
        }
    }
c0100d50:	eb d1                	jmp    c0100d23 <kmonitor+0x2f>
}
c0100d52:	c9                   	leave  
c0100d53:	c3                   	ret    

c0100d54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d54:	55                   	push   %ebp
c0100d55:	89 e5                	mov    %esp,%ebp
c0100d57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d61:	eb 3f                	jmp    c0100da2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d66:	89 d0                	mov    %edx,%eax
c0100d68:	01 c0                	add    %eax,%eax
c0100d6a:	01 d0                	add    %edx,%eax
c0100d6c:	c1 e0 02             	shl    $0x2,%eax
c0100d6f:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7a:	89 d0                	mov    %edx,%eax
c0100d7c:	01 c0                	add    %eax,%eax
c0100d7e:	01 d0                	add    %edx,%eax
c0100d80:	c1 e0 02             	shl    $0x2,%eax
c0100d83:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d88:	8b 00                	mov    (%eax),%eax
c0100d8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d92:	c7 04 24 fd bf 10 c0 	movl   $0xc010bffd,(%esp)
c0100d99:	e8 b5 f5 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da5:	83 f8 02             	cmp    $0x2,%eax
c0100da8:	76 b9                	jbe    c0100d63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100daf:	c9                   	leave  
c0100db0:	c3                   	ret    

c0100db1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db1:	55                   	push   %ebp
c0100db2:	89 e5                	mov    %esp,%ebp
c0100db4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db7:	e8 c3 fb ff ff       	call   c010097f <print_kerninfo>
    return 0;
c0100dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc1:	c9                   	leave  
c0100dc2:	c3                   	ret    

c0100dc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dc3:	55                   	push   %ebp
c0100dc4:	89 e5                	mov    %esp,%ebp
c0100dc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc9:	e8 fb fc ff ff       	call   c0100ac9 <print_stackframe>
    return 0;
c0100dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd3:	c9                   	leave  
c0100dd4:	c3                   	ret    

c0100dd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100dd5:	55                   	push   %ebp
c0100dd6:	89 e5                	mov    %esp,%ebp
c0100dd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ddb:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
c0100de0:	85 c0                	test   %eax,%eax
c0100de2:	74 02                	je     c0100de6 <__panic+0x11>
        goto panic_dead;
c0100de4:	eb 48                	jmp    c0100e2e <__panic+0x59>
    }
    is_panic = 1;
c0100de6:	c7 05 60 c3 19 c0 01 	movl   $0x1,0xc019c360
c0100ded:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100df0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100df6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100df9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e04:	c7 04 24 06 c0 10 c0 	movl   $0xc010c006,(%esp)
c0100e0b:	e8 43 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e1a:	89 04 24             	mov    %eax,(%esp)
c0100e1d:	e8 fe f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e22:	c7 04 24 22 c0 10 c0 	movl   $0xc010c022,(%esp)
c0100e29:	e8 25 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100e2e:	e8 fa 11 00 00       	call   c010202d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e3a:	e8 b5 fe ff ff       	call   c0100cf4 <kmonitor>
    }
c0100e3f:	eb f2                	jmp    c0100e33 <__panic+0x5e>

c0100e41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e5b:	c7 04 24 24 c0 10 c0 	movl   $0xc010c024,(%esp)
c0100e62:	e8 ec f4 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e71:	89 04 24             	mov    %eax,(%esp)
c0100e74:	e8 a7 f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e79:	c7 04 24 22 c0 10 c0 	movl   $0xc010c022,(%esp)
c0100e80:	e8 ce f4 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e8a:	a1 60 c3 19 c0       	mov    0xc019c360,%eax
}
c0100e8f:	5d                   	pop    %ebp
c0100e90:	c3                   	ret    

c0100e91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e91:	55                   	push   %ebp
c0100e92:	89 e5                	mov    %esp,%ebp
c0100e94:	83 ec 28             	sub    $0x28,%esp
c0100e97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100e9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100ea5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ea9:	ee                   	out    %al,(%dx)
c0100eaa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100eb0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100eb4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ebc:	ee                   	out    %al,(%dx)
c0100ebd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ec3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100ec7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ecb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ecf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ed0:	c7 05 b4 ef 19 c0 00 	movl   $0x0,0xc019efb4
c0100ed7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100eda:	c7 04 24 42 c0 10 c0 	movl   $0xc010c042,(%esp)
c0100ee1:	e8 6d f4 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ee6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100eed:	e8 99 11 00 00       	call   c010208b <pic_enable>
}
c0100ef2:	c9                   	leave  
c0100ef3:	c3                   	ret    

c0100ef4 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100ef4:	55                   	push   %ebp
c0100ef5:	89 e5                	mov    %esp,%ebp
c0100ef7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100efa:	9c                   	pushf  
c0100efb:	58                   	pop    %eax
c0100efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100f02:	25 00 02 00 00       	and    $0x200,%eax
c0100f07:	85 c0                	test   %eax,%eax
c0100f09:	74 0c                	je     c0100f17 <__intr_save+0x23>
        intr_disable();
c0100f0b:	e8 1d 11 00 00       	call   c010202d <intr_disable>
        return 1;
c0100f10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f15:	eb 05                	jmp    c0100f1c <__intr_save+0x28>
    }
    return 0;
c0100f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f1c:	c9                   	leave  
c0100f1d:	c3                   	ret    

c0100f1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f1e:	55                   	push   %ebp
c0100f1f:	89 e5                	mov    %esp,%ebp
c0100f21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f28:	74 05                	je     c0100f2f <__intr_restore+0x11>
        intr_enable();
c0100f2a:	e8 f8 10 00 00       	call   c0102027 <intr_enable>
    }
}
c0100f2f:	c9                   	leave  
c0100f30:	c3                   	ret    

c0100f31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f31:	55                   	push   %ebp
c0100f32:	89 e5                	mov    %esp,%ebp
c0100f34:	83 ec 10             	sub    $0x10,%esp
c0100f37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f41:	89 c2                	mov    %eax,%edx
c0100f43:	ec                   	in     (%dx),%al
c0100f44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100f47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100f4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f51:	89 c2                	mov    %eax,%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100f5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100f67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100f6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f71:	89 c2                	mov    %eax,%edx
c0100f73:	ec                   	in     (%dx),%al
c0100f74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f77:	c9                   	leave  
c0100f78:	c3                   	ret    

c0100f79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f79:	55                   	push   %ebp
c0100f7a:	89 e5                	mov    %esp,%ebp
c0100f7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f89:	0f b7 00             	movzwl (%eax),%eax
c0100f8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f9b:	0f b7 00             	movzwl (%eax),%eax
c0100f9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100fa2:	74 12                	je     c0100fb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100fa4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100fab:	66 c7 05 86 c3 19 c0 	movw   $0x3b4,0xc019c386
c0100fb2:	b4 03 
c0100fb4:	eb 13                	jmp    c0100fc9 <cga_init+0x50>
    } else {
        *cp = was;
c0100fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fbd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fc0:	66 c7 05 86 c3 19 c0 	movw   $0x3d4,0xc019c386
c0100fc7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fc9:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100fd0:	0f b7 c0             	movzwl %ax,%eax
c0100fd3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100fd7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fdf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100fe4:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0100feb:	83 c0 01             	add    $0x1,%eax
c0100fee:	0f b7 c0             	movzwl %ax,%eax
c0100ff1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ff9:	89 c2                	mov    %eax,%edx
c0100ffb:	ec                   	in     (%dx),%al
c0100ffc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	c1 e0 08             	shl    $0x8,%eax
c0101009:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010100c:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101013:	0f b7 c0             	movzwl %ax,%eax
c0101016:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010101a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101022:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101026:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101027:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010102e:	83 c0 01             	add    $0x1,%eax
c0101031:	0f b7 c0             	movzwl %ax,%eax
c0101034:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101038:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c010103c:	89 c2                	mov    %eax,%edx
c010103e:	ec                   	in     (%dx),%al
c010103f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0101042:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101046:	0f b6 c0             	movzbl %al,%eax
c0101049:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c010104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010104f:	a3 80 c3 19 c0       	mov    %eax,0xc019c380
    crt_pos = pos;
c0101054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101057:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
}
c010105d:	c9                   	leave  
c010105e:	c3                   	ret    

c010105f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c010105f:	55                   	push   %ebp
c0101060:	89 e5                	mov    %esp,%ebp
c0101062:	83 ec 48             	sub    $0x48,%esp
c0101065:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c010106b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
c0101078:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c010107e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101082:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101086:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101091:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0101095:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101099:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01010a4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010ac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
c01010b1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010b7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010c3:	ee                   	out    %al,(%dx)
c01010c4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010ca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01010d6:	ee                   	out    %al,(%dx)
c01010d7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01010dd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c01010e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01010e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01010e9:	ee                   	out    %al,(%dx)
c01010ea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010f0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01010f4:	89 c2                	mov    %eax,%edx
c01010f6:	ec                   	in     (%dx),%al
c01010f7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c01010fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c01010fe:	3c ff                	cmp    $0xff,%al
c0101100:	0f 95 c0             	setne  %al
c0101103:	0f b6 c0             	movzbl %al,%eax
c0101106:	a3 88 c3 19 c0       	mov    %eax,0xc019c388
c010110b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101111:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101115:	89 c2                	mov    %eax,%edx
c0101117:	ec                   	in     (%dx),%al
c0101118:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010111b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101121:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101125:	89 c2                	mov    %eax,%edx
c0101127:	ec                   	in     (%dx),%al
c0101128:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010112b:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c0101130:	85 c0                	test   %eax,%eax
c0101132:	74 0c                	je     c0101140 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101134:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010113b:	e8 4b 0f 00 00       	call   c010208b <pic_enable>
    }
}
c0101140:	c9                   	leave  
c0101141:	c3                   	ret    

c0101142 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101142:	55                   	push   %ebp
c0101143:	89 e5                	mov    %esp,%ebp
c0101145:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010114f:	eb 09                	jmp    c010115a <lpt_putc_sub+0x18>
        delay();
c0101151:	e8 db fd ff ff       	call   c0100f31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010115a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101160:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101164:	89 c2                	mov    %eax,%edx
c0101166:	ec                   	in     (%dx),%al
c0101167:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010116a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010116e:	84 c0                	test   %al,%al
c0101170:	78 09                	js     c010117b <lpt_putc_sub+0x39>
c0101172:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101179:	7e d6                	jle    c0101151 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010117b:	8b 45 08             	mov    0x8(%ebp),%eax
c010117e:	0f b6 c0             	movzbl %al,%eax
c0101181:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101187:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010118a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010118e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101192:	ee                   	out    %al,(%dx)
c0101193:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101199:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010119d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a5:	ee                   	out    %al,(%dx)
c01011a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01011b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01011b9:	c9                   	leave  
c01011ba:	c3                   	ret    

c01011bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01011bb:	55                   	push   %ebp
c01011bc:	89 e5                	mov    %esp,%ebp
c01011be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01011c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011c5:	74 0d                	je     c01011d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01011c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ca:	89 04 24             	mov    %eax,(%esp)
c01011cd:	e8 70 ff ff ff       	call   c0101142 <lpt_putc_sub>
c01011d2:	eb 24                	jmp    c01011f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01011d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011db:	e8 62 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01011e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011e7:	e8 56 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011f3:	e8 4a ff ff ff       	call   c0101142 <lpt_putc_sub>
    }
}
c01011f8:	c9                   	leave  
c01011f9:	c3                   	ret    

c01011fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011fa:	55                   	push   %ebp
c01011fb:	89 e5                	mov    %esp,%ebp
c01011fd:	53                   	push   %ebx
c01011fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101201:	8b 45 08             	mov    0x8(%ebp),%eax
c0101204:	b0 00                	mov    $0x0,%al
c0101206:	85 c0                	test   %eax,%eax
c0101208:	75 07                	jne    c0101211 <cga_putc+0x17>
        c |= 0x0700;
c010120a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101211:	8b 45 08             	mov    0x8(%ebp),%eax
c0101214:	0f b6 c0             	movzbl %al,%eax
c0101217:	83 f8 0a             	cmp    $0xa,%eax
c010121a:	74 4c                	je     c0101268 <cga_putc+0x6e>
c010121c:	83 f8 0d             	cmp    $0xd,%eax
c010121f:	74 57                	je     c0101278 <cga_putc+0x7e>
c0101221:	83 f8 08             	cmp    $0x8,%eax
c0101224:	0f 85 88 00 00 00    	jne    c01012b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010122a:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101231:	66 85 c0             	test   %ax,%ax
c0101234:	74 30                	je     c0101266 <cga_putc+0x6c>
            crt_pos --;
c0101236:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010123d:	83 e8 01             	sub    $0x1,%eax
c0101240:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101246:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c010124b:	0f b7 15 84 c3 19 c0 	movzwl 0xc019c384,%edx
c0101252:	0f b7 d2             	movzwl %dx,%edx
c0101255:	01 d2                	add    %edx,%edx
c0101257:	01 c2                	add    %eax,%edx
c0101259:	8b 45 08             	mov    0x8(%ebp),%eax
c010125c:	b0 00                	mov    $0x0,%al
c010125e:	83 c8 20             	or     $0x20,%eax
c0101261:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101264:	eb 72                	jmp    c01012d8 <cga_putc+0xde>
c0101266:	eb 70                	jmp    c01012d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101268:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c010126f:	83 c0 50             	add    $0x50,%eax
c0101272:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101278:	0f b7 1d 84 c3 19 c0 	movzwl 0xc019c384,%ebx
c010127f:	0f b7 0d 84 c3 19 c0 	movzwl 0xc019c384,%ecx
c0101286:	0f b7 c1             	movzwl %cx,%eax
c0101289:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010128f:	c1 e8 10             	shr    $0x10,%eax
c0101292:	89 c2                	mov    %eax,%edx
c0101294:	66 c1 ea 06          	shr    $0x6,%dx
c0101298:	89 d0                	mov    %edx,%eax
c010129a:	c1 e0 02             	shl    $0x2,%eax
c010129d:	01 d0                	add    %edx,%eax
c010129f:	c1 e0 04             	shl    $0x4,%eax
c01012a2:	29 c1                	sub    %eax,%ecx
c01012a4:	89 ca                	mov    %ecx,%edx
c01012a6:	89 d8                	mov    %ebx,%eax
c01012a8:	29 d0                	sub    %edx,%eax
c01012aa:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
        break;
c01012b0:	eb 26                	jmp    c01012d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01012b2:	8b 0d 80 c3 19 c0    	mov    0xc019c380,%ecx
c01012b8:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012bf:	8d 50 01             	lea    0x1(%eax),%edx
c01012c2:	66 89 15 84 c3 19 c0 	mov    %dx,0xc019c384
c01012c9:	0f b7 c0             	movzwl %ax,%eax
c01012cc:	01 c0                	add    %eax,%eax
c01012ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01012d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012d8:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01012df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01012e3:	76 5b                	jbe    c0101340 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012e5:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012f0:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c01012f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012fc:	00 
c01012fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101301:	89 04 24             	mov    %eax,(%esp)
c0101304:	e8 e4 a8 00 00       	call   c010bbed <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101309:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101310:	eb 15                	jmp    c0101327 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101312:	a1 80 c3 19 c0       	mov    0xc019c380,%eax
c0101317:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010131a:	01 d2                	add    %edx,%edx
c010131c:	01 d0                	add    %edx,%eax
c010131e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101323:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101327:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010132e:	7e e2                	jle    c0101312 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101330:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101337:	83 e8 50             	sub    $0x50,%eax
c010133a:	66 a3 84 c3 19 c0    	mov    %ax,0xc019c384
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101340:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c0101347:	0f b7 c0             	movzwl %ax,%eax
c010134a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010134e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101352:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101356:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010135b:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c0101362:	66 c1 e8 08          	shr    $0x8,%ax
c0101366:	0f b6 c0             	movzbl %al,%eax
c0101369:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c0101370:	83 c2 01             	add    $0x1,%edx
c0101373:	0f b7 d2             	movzwl %dx,%edx
c0101376:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010137a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010137d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101381:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101385:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101386:	0f b7 05 86 c3 19 c0 	movzwl 0xc019c386,%eax
c010138d:	0f b7 c0             	movzwl %ax,%eax
c0101390:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101394:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101398:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010139c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01013a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01013a1:	0f b7 05 84 c3 19 c0 	movzwl 0xc019c384,%eax
c01013a8:	0f b6 c0             	movzbl %al,%eax
c01013ab:	0f b7 15 86 c3 19 c0 	movzwl 0xc019c386,%edx
c01013b2:	83 c2 01             	add    $0x1,%edx
c01013b5:	0f b7 d2             	movzwl %dx,%edx
c01013b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01013bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01013bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01013c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01013c7:	ee                   	out    %al,(%dx)
}
c01013c8:	83 c4 34             	add    $0x34,%esp
c01013cb:	5b                   	pop    %ebx
c01013cc:	5d                   	pop    %ebp
c01013cd:	c3                   	ret    

c01013ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013db:	eb 09                	jmp    c01013e6 <serial_putc_sub+0x18>
        delay();
c01013dd:	e8 4f fb ff ff       	call   c0100f31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013f0:	89 c2                	mov    %eax,%edx
c01013f2:	ec                   	in     (%dx),%al
c01013f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013fa:	0f b6 c0             	movzbl %al,%eax
c01013fd:	83 e0 20             	and    $0x20,%eax
c0101400:	85 c0                	test   %eax,%eax
c0101402:	75 09                	jne    c010140d <serial_putc_sub+0x3f>
c0101404:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010140b:	7e d0                	jle    c01013dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010140d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101410:	0f b6 c0             	movzbl %al,%eax
c0101413:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101419:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010141c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101420:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101424:	ee                   	out    %al,(%dx)
}
c0101425:	c9                   	leave  
c0101426:	c3                   	ret    

c0101427 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010142d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101431:	74 0d                	je     c0101440 <serial_putc+0x19>
        serial_putc_sub(c);
c0101433:	8b 45 08             	mov    0x8(%ebp),%eax
c0101436:	89 04 24             	mov    %eax,(%esp)
c0101439:	e8 90 ff ff ff       	call   c01013ce <serial_putc_sub>
c010143e:	eb 24                	jmp    c0101464 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101440:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101447:	e8 82 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub(' ');
c010144c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101453:	e8 76 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101458:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010145f:	e8 6a ff ff ff       	call   c01013ce <serial_putc_sub>
    }
}
c0101464:	c9                   	leave  
c0101465:	c3                   	ret    

c0101466 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101466:	55                   	push   %ebp
c0101467:	89 e5                	mov    %esp,%ebp
c0101469:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010146c:	eb 33                	jmp    c01014a1 <cons_intr+0x3b>
        if (c != 0) {
c010146e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101472:	74 2d                	je     c01014a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101474:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101479:	8d 50 01             	lea    0x1(%eax),%edx
c010147c:	89 15 a4 c5 19 c0    	mov    %edx,0xc019c5a4
c0101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101485:	88 90 a0 c3 19 c0    	mov    %dl,-0x3fe63c60(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010148b:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c0101490:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101495:	75 0a                	jne    c01014a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101497:	c7 05 a4 c5 19 c0 00 	movl   $0x0,0xc019c5a4
c010149e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01014a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01014a4:	ff d0                	call   *%eax
c01014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01014ad:	75 bf                	jne    c010146e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01014af:	c9                   	leave  
c01014b0:	c3                   	ret    

c01014b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01014b1:	55                   	push   %ebp
c01014b2:	89 e5                	mov    %esp,%ebp
c01014b4:	83 ec 10             	sub    $0x10,%esp
c01014b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014c1:	89 c2                	mov    %eax,%edx
c01014c3:	ec                   	in     (%dx),%al
c01014c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014cb:	0f b6 c0             	movzbl %al,%eax
c01014ce:	83 e0 01             	and    $0x1,%eax
c01014d1:	85 c0                	test   %eax,%eax
c01014d3:	75 07                	jne    c01014dc <serial_proc_data+0x2b>
        return -1;
c01014d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014da:	eb 2a                	jmp    c0101506 <serial_proc_data+0x55>
c01014dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014e6:	89 c2                	mov    %eax,%edx
c01014e8:	ec                   	in     (%dx),%al
c01014e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014f0:	0f b6 c0             	movzbl %al,%eax
c01014f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014fa:	75 07                	jne    c0101503 <serial_proc_data+0x52>
        c = '\b';
c01014fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101503:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101506:	c9                   	leave  
c0101507:	c3                   	ret    

c0101508 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101508:	55                   	push   %ebp
c0101509:	89 e5                	mov    %esp,%ebp
c010150b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010150e:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c0101513:	85 c0                	test   %eax,%eax
c0101515:	74 0c                	je     c0101523 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101517:	c7 04 24 b1 14 10 c0 	movl   $0xc01014b1,(%esp)
c010151e:	e8 43 ff ff ff       	call   c0101466 <cons_intr>
    }
}
c0101523:	c9                   	leave  
c0101524:	c3                   	ret    

c0101525 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101525:	55                   	push   %ebp
c0101526:	89 e5                	mov    %esp,%ebp
c0101528:	83 ec 38             	sub    $0x38,%esp
c010152b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101531:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101535:	89 c2                	mov    %eax,%edx
c0101537:	ec                   	in     (%dx),%al
c0101538:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010153b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	83 e0 01             	and    $0x1,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	75 0a                	jne    c0101553 <kbd_proc_data+0x2e>
        return -1;
c0101549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010154e:	e9 59 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
c0101553:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010155d:	89 c2                	mov    %eax,%edx
c010155f:	ec                   	in     (%dx),%al
c0101560:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101563:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101567:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010156a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010156e:	75 17                	jne    c0101587 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101570:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101575:	83 c8 40             	or     $0x40,%eax
c0101578:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c010157d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101582:	e9 25 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101587:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158b:	84 c0                	test   %al,%al
c010158d:	79 47                	jns    c01015d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010158f:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101594:	83 e0 40             	and    $0x40,%eax
c0101597:	85 c0                	test   %eax,%eax
c0101599:	75 09                	jne    c01015a4 <kbd_proc_data+0x7f>
c010159b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010159f:	83 e0 7f             	and    $0x7f,%eax
c01015a2:	eb 04                	jmp    c01015a8 <kbd_proc_data+0x83>
c01015a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015af:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015b6:	83 c8 40             	or     $0x40,%eax
c01015b9:	0f b6 c0             	movzbl %al,%eax
c01015bc:	f7 d0                	not    %eax
c01015be:	89 c2                	mov    %eax,%edx
c01015c0:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015c5:	21 d0                	and    %edx,%eax
c01015c7:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
        return 0;
c01015cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01015d1:	e9 d6 00 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015d6:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015db:	83 e0 40             	and    $0x40,%eax
c01015de:	85 c0                	test   %eax,%eax
c01015e0:	74 11                	je     c01015f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015e6:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c01015eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01015ee:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    }

    shift |= shiftcode[data];
c01015f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015f7:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c01015fe:	0f b6 d0             	movzbl %al,%edx
c0101601:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101606:	09 d0                	or     %edx,%eax
c0101608:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8
    shift ^= togglecode[data];
c010160d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101611:	0f b6 80 60 a1 12 c0 	movzbl -0x3fed5ea0(%eax),%eax
c0101618:	0f b6 d0             	movzbl %al,%edx
c010161b:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101620:	31 d0                	xor    %edx,%eax
c0101622:	a3 a8 c5 19 c0       	mov    %eax,0xc019c5a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101627:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010162c:	83 e0 03             	and    $0x3,%eax
c010162f:	8b 14 85 60 a5 12 c0 	mov    -0x3fed5aa0(,%eax,4),%edx
c0101636:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010163a:	01 d0                	add    %edx,%eax
c010163c:	0f b6 00             	movzbl (%eax),%eax
c010163f:	0f b6 c0             	movzbl %al,%eax
c0101642:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101645:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c010164a:	83 e0 08             	and    $0x8,%eax
c010164d:	85 c0                	test   %eax,%eax
c010164f:	74 22                	je     c0101673 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101651:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101655:	7e 0c                	jle    c0101663 <kbd_proc_data+0x13e>
c0101657:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010165b:	7f 06                	jg     c0101663 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010165d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101661:	eb 10                	jmp    c0101673 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101663:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101667:	7e 0a                	jle    c0101673 <kbd_proc_data+0x14e>
c0101669:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010166d:	7f 04                	jg     c0101673 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010166f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101673:	a1 a8 c5 19 c0       	mov    0xc019c5a8,%eax
c0101678:	f7 d0                	not    %eax
c010167a:	83 e0 06             	and    $0x6,%eax
c010167d:	85 c0                	test   %eax,%eax
c010167f:	75 28                	jne    c01016a9 <kbd_proc_data+0x184>
c0101681:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101688:	75 1f                	jne    c01016a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010168a:	c7 04 24 5d c0 10 c0 	movl   $0xc010c05d,(%esp)
c0101691:	e8 bd ec ff ff       	call   c0100353 <cprintf>
c0101696:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010169c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01016a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ac:	c9                   	leave  
c01016ad:	c3                   	ret    

c01016ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
c01016b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016b4:	c7 04 24 25 15 10 c0 	movl   $0xc0101525,(%esp)
c01016bb:	e8 a6 fd ff ff       	call   c0101466 <cons_intr>
}
c01016c0:	c9                   	leave  
c01016c1:	c3                   	ret    

c01016c2 <kbd_init>:

static void
kbd_init(void) {
c01016c2:	55                   	push   %ebp
c01016c3:	89 e5                	mov    %esp,%ebp
c01016c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016c8:	e8 e1 ff ff ff       	call   c01016ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01016cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016d4:	e8 b2 09 00 00       	call   c010208b <pic_enable>
}
c01016d9:	c9                   	leave  
c01016da:	c3                   	ret    

c01016db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016db:	55                   	push   %ebp
c01016dc:	89 e5                	mov    %esp,%ebp
c01016de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016e1:	e8 93 f8 ff ff       	call   c0100f79 <cga_init>
    serial_init();
c01016e6:	e8 74 f9 ff ff       	call   c010105f <serial_init>
    kbd_init();
c01016eb:	e8 d2 ff ff ff       	call   c01016c2 <kbd_init>
    if (!serial_exists) {
c01016f0:	a1 88 c3 19 c0       	mov    0xc019c388,%eax
c01016f5:	85 c0                	test   %eax,%eax
c01016f7:	75 0c                	jne    c0101705 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01016f9:	c7 04 24 69 c0 10 c0 	movl   $0xc010c069,(%esp)
c0101700:	e8 4e ec ff ff       	call   c0100353 <cprintf>
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010170d:	e8 e2 f7 ff ff       	call   c0100ef4 <__intr_save>
c0101712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101715:	8b 45 08             	mov    0x8(%ebp),%eax
c0101718:	89 04 24             	mov    %eax,(%esp)
c010171b:	e8 9b fa ff ff       	call   c01011bb <lpt_putc>
        cga_putc(c);
c0101720:	8b 45 08             	mov    0x8(%ebp),%eax
c0101723:	89 04 24             	mov    %eax,(%esp)
c0101726:	e8 cf fa ff ff       	call   c01011fa <cga_putc>
        serial_putc(c);
c010172b:	8b 45 08             	mov    0x8(%ebp),%eax
c010172e:	89 04 24             	mov    %eax,(%esp)
c0101731:	e8 f1 fc ff ff       	call   c0101427 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101739:	89 04 24             	mov    %eax,(%esp)
c010173c:	e8 dd f7 ff ff       	call   c0100f1e <__intr_restore>
}
c0101741:	c9                   	leave  
c0101742:	c3                   	ret    

c0101743 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
c0101746:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101750:	e8 9f f7 ff ff       	call   c0100ef4 <__intr_save>
c0101755:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101758:	e8 ab fd ff ff       	call   c0101508 <serial_intr>
        kbd_intr();
c010175d:	e8 4c ff ff ff       	call   c01016ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101762:	8b 15 a0 c5 19 c0    	mov    0xc019c5a0,%edx
c0101768:	a1 a4 c5 19 c0       	mov    0xc019c5a4,%eax
c010176d:	39 c2                	cmp    %eax,%edx
c010176f:	74 31                	je     c01017a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101771:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101776:	8d 50 01             	lea    0x1(%eax),%edx
c0101779:	89 15 a0 c5 19 c0    	mov    %edx,0xc019c5a0
c010177f:	0f b6 80 a0 c3 19 c0 	movzbl -0x3fe63c60(%eax),%eax
c0101786:	0f b6 c0             	movzbl %al,%eax
c0101789:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010178c:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0101791:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101796:	75 0a                	jne    c01017a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101798:	c7 05 a0 c5 19 c0 00 	movl   $0x0,0xc019c5a0
c010179f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017a5:	89 04 24             	mov    %eax,(%esp)
c01017a8:	e8 71 f7 ff ff       	call   c0100f1e <__intr_restore>
    return c;
c01017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017b0:	c9                   	leave  
c01017b1:	c3                   	ret    

c01017b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01017b2:	55                   	push   %ebp
c01017b3:	89 e5                	mov    %esp,%ebp
c01017b5:	83 ec 14             	sub    $0x14,%esp
c01017b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01017bf:	90                   	nop
c01017c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017c4:	83 c0 07             	add    $0x7,%eax
c01017c7:	0f b7 c0             	movzwl %ax,%eax
c01017ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01017d2:	89 c2                	mov    %eax,%edx
c01017d4:	ec                   	in     (%dx),%al
c01017d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01017d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017dc:	0f b6 c0             	movzbl %al,%eax
c01017df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e5:	25 80 00 00 00       	and    $0x80,%eax
c01017ea:	85 c0                	test   %eax,%eax
c01017ec:	75 d2                	jne    c01017c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01017ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01017f2:	74 11                	je     c0101805 <ide_wait_ready+0x53>
c01017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f7:	83 e0 21             	and    $0x21,%eax
c01017fa:	85 c0                	test   %eax,%eax
c01017fc:	74 07                	je     c0101805 <ide_wait_ready+0x53>
        return -1;
c01017fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101803:	eb 05                	jmp    c010180a <ide_wait_ready+0x58>
    }
    return 0;
c0101805:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010180a:	c9                   	leave  
c010180b:	c3                   	ret    

c010180c <ide_init>:

void
ide_init(void) {
c010180c:	55                   	push   %ebp
c010180d:	89 e5                	mov    %esp,%ebp
c010180f:	57                   	push   %edi
c0101810:	53                   	push   %ebx
c0101811:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101817:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010181d:	e9 d6 02 00 00       	jmp    c0101af8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101822:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101826:	c1 e0 03             	shl    $0x3,%eax
c0101829:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101830:	29 c2                	sub    %eax,%edx
c0101832:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101838:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010183b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010183f:	66 d1 e8             	shr    %ax
c0101842:	0f b7 c0             	movzwl %ax,%eax
c0101845:	0f b7 04 85 88 c0 10 	movzwl -0x3fef3f78(,%eax,4),%eax
c010184c:	c0 
c010184d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101851:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101855:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010185c:	00 
c010185d:	89 04 24             	mov    %eax,(%esp)
c0101860:	e8 4d ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101865:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101869:	83 e0 01             	and    $0x1,%eax
c010186c:	c1 e0 04             	shl    $0x4,%eax
c010186f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101872:	0f b6 c0             	movzbl %al,%eax
c0101875:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101879:	83 c2 06             	add    $0x6,%edx
c010187c:	0f b7 d2             	movzwl %dx,%edx
c010187f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101883:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101886:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010188a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010188e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010188f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010189a:	00 
c010189b:	89 04 24             	mov    %eax,(%esp)
c010189e:	e8 0f ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01018a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018a7:	83 c0 07             	add    $0x7,%eax
c01018aa:	0f b7 c0             	movzwl %ax,%eax
c01018ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01018b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01018b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01018be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018c9:	00 
c01018ca:	89 04 24             	mov    %eax,(%esp)
c01018cd:	e8 e0 fe ff ff       	call   c01017b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01018d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018d6:	83 c0 07             	add    $0x7,%eax
c01018d9:	0f b7 c0             	movzwl %ax,%eax
c01018dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01018e4:	89 c2                	mov    %eax,%edx
c01018e6:	ec                   	in     (%dx),%al
c01018e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01018ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018ee:	84 c0                	test   %al,%al
c01018f0:	0f 84 f7 01 00 00    	je     c0101aed <ide_init+0x2e1>
c01018f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101901:	00 
c0101902:	89 04 24             	mov    %eax,(%esp)
c0101905:	e8 a8 fe ff ff       	call   c01017b2 <ide_wait_ready>
c010190a:	85 c0                	test   %eax,%eax
c010190c:	0f 85 db 01 00 00    	jne    c0101aed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101912:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101916:	c1 e0 03             	shl    $0x3,%eax
c0101919:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101920:	29 c2                	sub    %eax,%edx
c0101922:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101928:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010192b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010192f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101932:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101938:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010193b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101942:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101945:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101948:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010194b:	89 cb                	mov    %ecx,%ebx
c010194d:	89 df                	mov    %ebx,%edi
c010194f:	89 c1                	mov    %eax,%ecx
c0101951:	fc                   	cld    
c0101952:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101954:	89 c8                	mov    %ecx,%eax
c0101956:	89 fb                	mov    %edi,%ebx
c0101958:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010195b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010195e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010196a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101970:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101973:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101976:	25 00 00 00 04       	and    $0x4000000,%eax
c010197b:	85 c0                	test   %eax,%eax
c010197d:	74 0e                	je     c010198d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010197f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101982:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101988:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010198b:	eb 09                	jmp    c0101996 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010198d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101990:	8b 40 78             	mov    0x78(%eax),%eax
c0101993:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101996:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010199a:	c1 e0 03             	shl    $0x3,%eax
c010199d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019a4:	29 c2                	sub    %eax,%edx
c01019a6:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01019b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b6:	c1 e0 03             	shl    $0x3,%eax
c01019b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c0:	29 c2                	sub    %eax,%edx
c01019c2:	81 c2 c0 c5 19 c0    	add    $0xc019c5c0,%edx
c01019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01019ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019d1:	83 c0 62             	add    $0x62,%eax
c01019d4:	0f b7 00             	movzwl (%eax),%eax
c01019d7:	0f b7 c0             	movzwl %ax,%eax
c01019da:	25 00 02 00 00       	and    $0x200,%eax
c01019df:	85 c0                	test   %eax,%eax
c01019e1:	75 24                	jne    c0101a07 <ide_init+0x1fb>
c01019e3:	c7 44 24 0c 90 c0 10 	movl   $0xc010c090,0xc(%esp)
c01019ea:	c0 
c01019eb:	c7 44 24 08 d3 c0 10 	movl   $0xc010c0d3,0x8(%esp)
c01019f2:	c0 
c01019f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019fa:	00 
c01019fb:	c7 04 24 e8 c0 10 c0 	movl   $0xc010c0e8,(%esp)
c0101a02:	e8 ce f3 ff ff       	call   c0100dd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101a07:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0b:	c1 e0 03             	shl    $0x3,%eax
c0101a0e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a15:	29 c2                	sub    %eax,%edx
c0101a17:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101a1d:	83 c0 0c             	add    $0xc,%eax
c0101a20:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a26:	83 c0 36             	add    $0x36,%eax
c0101a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101a2c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101a33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101a3a:	eb 34                	jmp    c0101a70 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a42:	01 c2                	add    %eax,%edx
c0101a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a47:	8d 48 01             	lea    0x1(%eax),%ecx
c0101a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101a4d:	01 c8                	add    %ecx,%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	88 02                	mov    %al,(%edx)
c0101a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a57:	8d 50 01             	lea    0x1(%eax),%edx
c0101a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a5d:	01 c2                	add    %eax,%edx
c0101a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a62:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101a65:	01 c8                	add    %ecx,%eax
c0101a67:	0f b6 00             	movzbl (%eax),%eax
c0101a6a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a6c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a73:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101a76:	72 c4                	jb     c0101a3c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a7e:	01 d0                	add    %edx,%eax
c0101a80:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a89:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a8c:	85 c0                	test   %eax,%eax
c0101a8e:	74 0f                	je     c0101a9f <ide_init+0x293>
c0101a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a96:	01 d0                	add    %edx,%eax
c0101a98:	0f b6 00             	movzbl (%eax),%eax
c0101a9b:	3c 20                	cmp    $0x20,%al
c0101a9d:	74 d9                	je     c0101a78 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a9f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101aa3:	c1 e0 03             	shl    $0x3,%eax
c0101aa6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aad:	29 c2                	sub    %eax,%edx
c0101aaf:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ab5:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101ab8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101abc:	c1 e0 03             	shl    $0x3,%eax
c0101abf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ac6:	29 c2                	sub    %eax,%edx
c0101ac8:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101ace:	8b 50 08             	mov    0x8(%eax),%edx
c0101ad1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ad5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101ad9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101add:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae1:	c7 04 24 fa c0 10 c0 	movl   $0xc010c0fa,(%esp)
c0101ae8:	e8 66 e8 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101aed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101af1:	83 c0 01             	add    $0x1,%eax
c0101af4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101af8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101afd:	0f 86 1f fd ff ff    	jbe    c0101822 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101b03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101b0a:	e8 7c 05 00 00       	call   c010208b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101b0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101b16:	e8 70 05 00 00       	call   c010208b <pic_enable>
}
c0101b1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101b21:	5b                   	pop    %ebx
c0101b22:	5f                   	pop    %edi
c0101b23:	5d                   	pop    %ebp
c0101b24:	c3                   	ret    

c0101b25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101b25:	55                   	push   %ebp
c0101b26:	89 e5                	mov    %esp,%ebp
c0101b28:	83 ec 04             	sub    $0x4,%esp
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101b32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101b37:	77 24                	ja     c0101b5d <ide_device_valid+0x38>
c0101b39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b3d:	c1 e0 03             	shl    $0x3,%eax
c0101b40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b47:	29 c2                	sub    %eax,%edx
c0101b49:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b4f:	0f b6 00             	movzbl (%eax),%eax
c0101b52:	84 c0                	test   %al,%al
c0101b54:	74 07                	je     c0101b5d <ide_device_valid+0x38>
c0101b56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b5b:	eb 05                	jmp    c0101b62 <ide_device_valid+0x3d>
c0101b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b62:	c9                   	leave  
c0101b63:	c3                   	ret    

c0101b64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b64:	55                   	push   %ebp
c0101b65:	89 e5                	mov    %esp,%ebp
c0101b67:	83 ec 08             	sub    $0x8,%esp
c0101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b75:	89 04 24             	mov    %eax,(%esp)
c0101b78:	e8 a8 ff ff ff       	call   c0101b25 <ide_device_valid>
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 1b                	je     c0101b9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b85:	c1 e0 03             	shl    $0x3,%eax
c0101b88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b8f:	29 c2                	sub    %eax,%edx
c0101b91:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101b97:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9a:	eb 05                	jmp    c0101ba1 <ide_device_size+0x3d>
    }
    return 0;
c0101b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ba1:	c9                   	leave  
c0101ba2:	c3                   	ret    

c0101ba3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ba3:	55                   	push   %ebp
c0101ba4:	89 e5                	mov    %esp,%ebp
c0101ba6:	57                   	push   %edi
c0101ba7:	53                   	push   %ebx
c0101ba8:	83 ec 50             	sub    $0x50,%esp
c0101bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101bb2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101bb9:	77 24                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bbb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101bc0:	77 1d                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bc2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bc6:	c1 e0 03             	shl    $0x3,%eax
c0101bc9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bd0:	29 c2                	sub    %eax,%edx
c0101bd2:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101bd8:	0f b6 00             	movzbl (%eax),%eax
c0101bdb:	84 c0                	test   %al,%al
c0101bdd:	75 24                	jne    c0101c03 <ide_read_secs+0x60>
c0101bdf:	c7 44 24 0c 18 c1 10 	movl   $0xc010c118,0xc(%esp)
c0101be6:	c0 
c0101be7:	c7 44 24 08 d3 c0 10 	movl   $0xc010c0d3,0x8(%esp)
c0101bee:	c0 
c0101bef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bf6:	00 
c0101bf7:	c7 04 24 e8 c0 10 c0 	movl   $0xc010c0e8,(%esp)
c0101bfe:	e8 d2 f1 ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101c03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c0a:	77 0f                	ja     c0101c1b <ide_read_secs+0x78>
c0101c0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c12:	01 d0                	add    %edx,%eax
c0101c14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101c19:	76 24                	jbe    c0101c3f <ide_read_secs+0x9c>
c0101c1b:	c7 44 24 0c 40 c1 10 	movl   $0xc010c140,0xc(%esp)
c0101c22:	c0 
c0101c23:	c7 44 24 08 d3 c0 10 	movl   $0xc010c0d3,0x8(%esp)
c0101c2a:	c0 
c0101c2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101c32:	00 
c0101c33:	c7 04 24 e8 c0 10 c0 	movl   $0xc010c0e8,(%esp)
c0101c3a:	e8 96 f1 ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101c3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c43:	66 d1 e8             	shr    %ax
c0101c46:	0f b7 c0             	movzwl %ax,%eax
c0101c49:	0f b7 04 85 88 c0 10 	movzwl -0x3fef3f78(,%eax,4),%eax
c0101c50:	c0 
c0101c51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101c55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c59:	66 d1 e8             	shr    %ax
c0101c5c:	0f b7 c0             	movzwl %ax,%eax
c0101c5f:	0f b7 04 85 8a c0 10 	movzwl -0x3fef3f76(,%eax,4),%eax
c0101c66:	c0 
c0101c67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101c6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c76:	00 
c0101c77:	89 04 24             	mov    %eax,(%esp)
c0101c7a:	e8 33 fb ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c83:	83 c0 02             	add    $0x2,%eax
c0101c86:	0f b7 c0             	movzwl %ax,%eax
c0101c89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101c8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101c95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c9d:	0f b6 c0             	movzbl %al,%eax
c0101ca0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ca4:	83 c2 02             	add    $0x2,%edx
c0101ca7:	0f b7 d2             	movzwl %dx,%edx
c0101caa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101cb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101cba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cbd:	0f b6 c0             	movzbl %al,%eax
c0101cc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cc4:	83 c2 03             	add    $0x3,%edx
c0101cc7:	0f b7 d2             	movzwl %dx,%edx
c0101cca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101cce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101cd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101cd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101cd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101cda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cdd:	c1 e8 08             	shr    $0x8,%eax
c0101ce0:	0f b6 c0             	movzbl %al,%eax
c0101ce3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ce7:	83 c2 04             	add    $0x4,%edx
c0101cea:	0f b7 d2             	movzwl %dx,%edx
c0101ced:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101cf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101cf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101cf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d00:	c1 e8 10             	shr    $0x10,%eax
c0101d03:	0f b6 c0             	movzbl %al,%eax
c0101d06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d0a:	83 c2 05             	add    $0x5,%edx
c0101d0d:	0f b7 d2             	movzwl %dx,%edx
c0101d10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101d20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d24:	83 e0 01             	and    $0x1,%eax
c0101d27:	c1 e0 04             	shl    $0x4,%eax
c0101d2a:	89 c2                	mov    %eax,%edx
c0101d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d2f:	c1 e8 18             	shr    $0x18,%eax
c0101d32:	83 e0 0f             	and    $0xf,%eax
c0101d35:	09 d0                	or     %edx,%eax
c0101d37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101d3a:	0f b6 c0             	movzbl %al,%eax
c0101d3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d41:	83 c2 06             	add    $0x6,%edx
c0101d44:	0f b7 d2             	movzwl %dx,%edx
c0101d47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d5b:	83 c0 07             	add    $0x7,%eax
c0101d5e:	0f b7 c0             	movzwl %ax,%eax
c0101d61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101d69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d79:	eb 5a                	jmp    c0101dd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d86:	00 
c0101d87:	89 04 24             	mov    %eax,(%esp)
c0101d8a:	e8 23 fa ff ff       	call   c01017b2 <ide_wait_ready>
c0101d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d96:	74 02                	je     c0101d9a <ide_read_secs+0x1f7>
            goto out;
c0101d98:	eb 41                	jmp    c0101ddb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101da1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101da7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101dae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101db1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101db4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101db7:	89 cb                	mov    %ecx,%ebx
c0101db9:	89 df                	mov    %ebx,%edi
c0101dbb:	89 c1                	mov    %eax,%ecx
c0101dbd:	fc                   	cld    
c0101dbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101dc0:	89 c8                	mov    %ecx,%eax
c0101dc2:	89 fb                	mov    %edi,%ebx
c0101dc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101dc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101dca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101dce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101dd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101dd9:	75 a0                	jne    c0101d7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dde:	83 c4 50             	add    $0x50,%esp
c0101de1:	5b                   	pop    %ebx
c0101de2:	5f                   	pop    %edi
c0101de3:	5d                   	pop    %ebp
c0101de4:	c3                   	ret    

c0101de5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101de5:	55                   	push   %ebp
c0101de6:	89 e5                	mov    %esp,%ebp
c0101de8:	56                   	push   %esi
c0101de9:	53                   	push   %ebx
c0101dea:	83 ec 50             	sub    $0x50,%esp
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101df4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101dfb:	77 24                	ja     c0101e21 <ide_write_secs+0x3c>
c0101dfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101e02:	77 1d                	ja     c0101e21 <ide_write_secs+0x3c>
c0101e04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e08:	c1 e0 03             	shl    $0x3,%eax
c0101e0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101e12:	29 c2                	sub    %eax,%edx
c0101e14:	8d 82 c0 c5 19 c0    	lea    -0x3fe63a40(%edx),%eax
c0101e1a:	0f b6 00             	movzbl (%eax),%eax
c0101e1d:	84 c0                	test   %al,%al
c0101e1f:	75 24                	jne    c0101e45 <ide_write_secs+0x60>
c0101e21:	c7 44 24 0c 18 c1 10 	movl   $0xc010c118,0xc(%esp)
c0101e28:	c0 
c0101e29:	c7 44 24 08 d3 c0 10 	movl   $0xc010c0d3,0x8(%esp)
c0101e30:	c0 
c0101e31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e38:	00 
c0101e39:	c7 04 24 e8 c0 10 c0 	movl   $0xc010c0e8,(%esp)
c0101e40:	e8 90 ef ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e4c:	77 0f                	ja     c0101e5d <ide_write_secs+0x78>
c0101e4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e54:	01 d0                	add    %edx,%eax
c0101e56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e5b:	76 24                	jbe    c0101e81 <ide_write_secs+0x9c>
c0101e5d:	c7 44 24 0c 40 c1 10 	movl   $0xc010c140,0xc(%esp)
c0101e64:	c0 
c0101e65:	c7 44 24 08 d3 c0 10 	movl   $0xc010c0d3,0x8(%esp)
c0101e6c:	c0 
c0101e6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e74:	00 
c0101e75:	c7 04 24 e8 c0 10 c0 	movl   $0xc010c0e8,(%esp)
c0101e7c:	e8 54 ef ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e85:	66 d1 e8             	shr    %ax
c0101e88:	0f b7 c0             	movzwl %ax,%eax
c0101e8b:	0f b7 04 85 88 c0 10 	movzwl -0x3fef3f78(,%eax,4),%eax
c0101e92:	c0 
c0101e93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e9b:	66 d1 e8             	shr    %ax
c0101e9e:	0f b7 c0             	movzwl %ax,%eax
c0101ea1:	0f b7 04 85 8a c0 10 	movzwl -0x3fef3f76(,%eax,4),%eax
c0101ea8:	c0 
c0101ea9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101ead:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101eb8:	00 
c0101eb9:	89 04 24             	mov    %eax,(%esp)
c0101ebc:	e8 f1 f8 ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ec1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ec5:	83 c0 02             	add    $0x2,%eax
c0101ec8:	0f b7 c0             	movzwl %ax,%eax
c0101ecb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ecf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ed3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ed7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101edb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101edc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101edf:	0f b6 c0             	movzbl %al,%eax
c0101ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ee6:	83 c2 02             	add    $0x2,%edx
c0101ee9:	0f b7 d2             	movzwl %dx,%edx
c0101eec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ef0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ef3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ef7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101efb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101efc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eff:	0f b6 c0             	movzbl %al,%eax
c0101f02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f06:	83 c2 03             	add    $0x3,%edx
c0101f09:	0f b7 d2             	movzwl %dx,%edx
c0101f0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101f10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101f13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f1f:	c1 e8 08             	shr    $0x8,%eax
c0101f22:	0f b6 c0             	movzbl %al,%eax
c0101f25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f29:	83 c2 04             	add    $0x4,%edx
c0101f2c:	0f b7 d2             	movzwl %dx,%edx
c0101f2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101f33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101f36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f42:	c1 e8 10             	shr    $0x10,%eax
c0101f45:	0f b6 c0             	movzbl %al,%eax
c0101f48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f4c:	83 c2 05             	add    $0x5,%edx
c0101f4f:	0f b7 d2             	movzwl %dx,%edx
c0101f52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f66:	83 e0 01             	and    $0x1,%eax
c0101f69:	c1 e0 04             	shl    $0x4,%eax
c0101f6c:	89 c2                	mov    %eax,%edx
c0101f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f71:	c1 e8 18             	shr    $0x18,%eax
c0101f74:	83 e0 0f             	and    $0xf,%eax
c0101f77:	09 d0                	or     %edx,%eax
c0101f79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f83:	83 c2 06             	add    $0x6,%edx
c0101f86:	0f b7 d2             	movzwl %dx,%edx
c0101f89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f9d:	83 c0 07             	add    $0x7,%eax
c0101fa0:	0f b7 c0             	movzwl %ax,%eax
c0101fa3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101fa7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101fab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101faf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fbb:	eb 5a                	jmp    c0102017 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101fbd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101fc8:	00 
c0101fc9:	89 04 24             	mov    %eax,(%esp)
c0101fcc:	e8 e1 f7 ff ff       	call   c01017b2 <ide_wait_ready>
c0101fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101fd8:	74 02                	je     c0101fdc <ide_write_secs+0x1f7>
            goto out;
c0101fda:	eb 41                	jmp    c010201d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101fdc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fe0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101fe3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fe6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fe9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ff0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ff3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ff6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ff9:	89 cb                	mov    %ecx,%ebx
c0101ffb:	89 de                	mov    %ebx,%esi
c0101ffd:	89 c1                	mov    %eax,%ecx
c0101fff:	fc                   	cld    
c0102000:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0102002:	89 c8                	mov    %ecx,%eax
c0102004:	89 f3                	mov    %esi,%ebx
c0102006:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0102009:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010200c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0102010:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0102017:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010201b:	75 a0                	jne    c0101fbd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c010201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102020:	83 c4 50             	add    $0x50,%esp
c0102023:	5b                   	pop    %ebx
c0102024:	5e                   	pop    %esi
c0102025:	5d                   	pop    %ebp
c0102026:	c3                   	ret    

c0102027 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102027:	55                   	push   %ebp
c0102028:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010202a:	fb                   	sti    
    sti();
}
c010202b:	5d                   	pop    %ebp
c010202c:	c3                   	ret    

c010202d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010202d:	55                   	push   %ebp
c010202e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102030:	fa                   	cli    
    cli();
}
c0102031:	5d                   	pop    %ebp
c0102032:	c3                   	ret    

c0102033 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0102033:	55                   	push   %ebp
c0102034:	89 e5                	mov    %esp,%ebp
c0102036:	83 ec 14             	sub    $0x14,%esp
c0102039:	8b 45 08             	mov    0x8(%ebp),%eax
c010203c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0102040:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102044:	66 a3 70 a5 12 c0    	mov    %ax,0xc012a570
    if (did_init) {
c010204a:	a1 a0 c6 19 c0       	mov    0xc019c6a0,%eax
c010204f:	85 c0                	test   %eax,%eax
c0102051:	74 36                	je     c0102089 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0102053:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102057:	0f b6 c0             	movzbl %al,%eax
c010205a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102060:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102063:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102067:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010206b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010206c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102070:	66 c1 e8 08          	shr    $0x8,%ax
c0102074:	0f b6 c0             	movzbl %al,%eax
c0102077:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010207d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102084:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102088:	ee                   	out    %al,(%dx)
    }
}
c0102089:	c9                   	leave  
c010208a:	c3                   	ret    

c010208b <pic_enable>:

void
pic_enable(unsigned int irq) {
c010208b:	55                   	push   %ebp
c010208c:	89 e5                	mov    %esp,%ebp
c010208e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102091:	8b 45 08             	mov    0x8(%ebp),%eax
c0102094:	ba 01 00 00 00       	mov    $0x1,%edx
c0102099:	89 c1                	mov    %eax,%ecx
c010209b:	d3 e2                	shl    %cl,%edx
c010209d:	89 d0                	mov    %edx,%eax
c010209f:	f7 d0                	not    %eax
c01020a1:	89 c2                	mov    %eax,%edx
c01020a3:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01020aa:	21 d0                	and    %edx,%eax
c01020ac:	0f b7 c0             	movzwl %ax,%eax
c01020af:	89 04 24             	mov    %eax,(%esp)
c01020b2:	e8 7c ff ff ff       	call   c0102033 <pic_setmask>
}
c01020b7:	c9                   	leave  
c01020b8:	c3                   	ret    

c01020b9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01020b9:	55                   	push   %ebp
c01020ba:	89 e5                	mov    %esp,%ebp
c01020bc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01020bf:	c7 05 a0 c6 19 c0 01 	movl   $0x1,0xc019c6a0
c01020c6:	00 00 00 
c01020c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01020cf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01020d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01020d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020db:	ee                   	out    %al,(%dx)
c01020dc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020e2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020ea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020ee:	ee                   	out    %al,(%dx)
c01020ef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020f5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102101:	ee                   	out    %al,(%dx)
c0102102:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102108:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010210c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102110:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102114:	ee                   	out    %al,(%dx)
c0102115:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010211b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010211f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102123:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102127:	ee                   	out    %al,(%dx)
c0102128:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010212e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102132:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102136:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010213a:	ee                   	out    %al,(%dx)
c010213b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102141:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102145:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102149:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010214d:	ee                   	out    %al,(%dx)
c010214e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102154:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102158:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010215c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102160:	ee                   	out    %al,(%dx)
c0102161:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102167:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010216b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010216f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102173:	ee                   	out    %al,(%dx)
c0102174:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010217a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010217e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102182:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102186:	ee                   	out    %al,(%dx)
c0102187:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010218d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102191:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102195:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102199:	ee                   	out    %al,(%dx)
c010219a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01021a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01021a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01021a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01021ac:	ee                   	out    %al,(%dx)
c01021ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01021b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01021b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01021bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01021bf:	ee                   	out    %al,(%dx)
c01021c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01021c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01021ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01021ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01021d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01021d3:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021de:	74 12                	je     c01021f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01021e0:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01021e7:	0f b7 c0             	movzwl %ax,%eax
c01021ea:	89 04 24             	mov    %eax,(%esp)
c01021ed:	e8 41 fe ff ff       	call   c0102033 <pic_setmask>
    }
}
c01021f2:	c9                   	leave  
c01021f3:	c3                   	ret    

c01021f4 <print_ticks>:
#include <sched.h>
#include <sync.h>

#define TICK_NUM 100

static void print_ticks() {
c01021f4:	55                   	push   %ebp
c01021f5:	89 e5                	mov    %esp,%ebp
c01021f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102201:	00 
c0102202:	c7 04 24 80 c1 10 c0 	movl   $0xc010c180,(%esp)
c0102209:	e8 45 e1 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010220e:	c7 04 24 8a c1 10 c0 	movl   $0xc010c18a,(%esp)
c0102215:	e8 39 e1 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c010221a:	c7 44 24 08 98 c1 10 	movl   $0xc010c198,0x8(%esp)
c0102221:	c0 
c0102222:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0102229:	00 
c010222a:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c0102231:	e8 9f eb ff ff       	call   c0100dd5 <__panic>

c0102236 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102236:	55                   	push   %ebp
c0102237:	89 e5                	mov    %esp,%ebp
c0102239:	83 ec 10             	sub    $0x10,%esp
 /*STEP 2 */
    extern uintptr_t __vectors[];
    int i;
   /////又改了！！1
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010223c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102243:	e9 c3 00 00 00       	jmp    c010230b <idt_init+0xd5>
	/*if(i == T_SYSCALL){
	    SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
	}
	else SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }*/
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102248:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010224b:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c0102252:	89 c2                	mov    %eax,%edx
c0102254:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102257:	66 89 14 c5 c0 c6 19 	mov    %dx,-0x3fe63940(,%eax,8)
c010225e:	c0 
c010225f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102262:	66 c7 04 c5 c2 c6 19 	movw   $0x8,-0x3fe6393e(,%eax,8)
c0102269:	c0 08 00 
c010226c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010226f:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c0102276:	c0 
c0102277:	83 e2 e0             	and    $0xffffffe0,%edx
c010227a:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102281:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102284:	0f b6 14 c5 c4 c6 19 	movzbl -0x3fe6393c(,%eax,8),%edx
c010228b:	c0 
c010228c:	83 e2 1f             	and    $0x1f,%edx
c010228f:	88 14 c5 c4 c6 19 c0 	mov    %dl,-0x3fe6393c(,%eax,8)
c0102296:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102299:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022a0:	c0 
c01022a1:	83 e2 f0             	and    $0xfffffff0,%edx
c01022a4:	83 ca 0e             	or     $0xe,%edx
c01022a7:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b1:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022b8:	c0 
c01022b9:	83 e2 ef             	and    $0xffffffef,%edx
c01022bc:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022c6:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022cd:	c0 
c01022ce:	83 e2 9f             	and    $0xffffff9f,%edx
c01022d1:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022db:	0f b6 14 c5 c5 c6 19 	movzbl -0x3fe6393b(,%eax,8),%edx
c01022e2:	c0 
c01022e3:	83 ca 80             	or     $0xffffff80,%edx
c01022e6:	88 14 c5 c5 c6 19 c0 	mov    %dl,-0x3fe6393b(,%eax,8)
c01022ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022f0:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01022f7:	c1 e8 10             	shr    $0x10,%eax
c01022fa:	89 c2                	mov    %eax,%edx
c01022fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ff:	66 89 14 c5 c6 c6 19 	mov    %dx,-0x3fe6393a(,%eax,8)
c0102306:	c0 
idt_init(void) {
 /*STEP 2 */
    extern uintptr_t __vectors[];
    int i;
   /////又改了！！1
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102307:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010230b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010230e:	3d ff 00 00 00       	cmp    $0xff,%eax
c0102313:	0f 86 2f ff ff ff    	jbe    c0102248 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    ///// SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
   ///都给我改！
   SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
c0102319:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c010231e:	66 a3 c0 ca 19 c0    	mov    %ax,0xc019cac0
c0102324:	66 c7 05 c2 ca 19 c0 	movw   $0x8,0xc019cac2
c010232b:	08 00 
c010232d:	0f b6 05 c4 ca 19 c0 	movzbl 0xc019cac4,%eax
c0102334:	83 e0 e0             	and    $0xffffffe0,%eax
c0102337:	a2 c4 ca 19 c0       	mov    %al,0xc019cac4
c010233c:	0f b6 05 c4 ca 19 c0 	movzbl 0xc019cac4,%eax
c0102343:	83 e0 1f             	and    $0x1f,%eax
c0102346:	a2 c4 ca 19 c0       	mov    %al,0xc019cac4
c010234b:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102352:	83 c8 0f             	or     $0xf,%eax
c0102355:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c010235a:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102361:	83 e0 ef             	and    $0xffffffef,%eax
c0102364:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102369:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c0102370:	83 c8 60             	or     $0x60,%eax
c0102373:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102378:	0f b6 05 c5 ca 19 c0 	movzbl 0xc019cac5,%eax
c010237f:	83 c8 80             	or     $0xffffff80,%eax
c0102382:	a2 c5 ca 19 c0       	mov    %al,0xc019cac5
c0102387:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c010238c:	c1 e8 10             	shr    $0x10,%eax
c010238f:	66 a3 c6 ca 19 c0    	mov    %ax,0xc019cac6
c0102395:	c7 45 f8 80 a5 12 c0 	movl   $0xc012a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010239c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010239f:	0f 01 18             	lidtl  (%eax)
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     /* LAB5 YOUR CODE */ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
}
c01023a2:	c9                   	leave  
c01023a3:	c3                   	ret    

c01023a4 <trapname>:

static const char *
trapname(int trapno) {
c01023a4:	55                   	push   %ebp
c01023a5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01023a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023aa:	83 f8 13             	cmp    $0x13,%eax
c01023ad:	77 0c                	ja     c01023bb <trapname+0x17>
        return excnames[trapno];
c01023af:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b2:	8b 04 85 20 c6 10 c0 	mov    -0x3fef39e0(,%eax,4),%eax
c01023b9:	eb 18                	jmp    c01023d3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01023bb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01023bf:	7e 0d                	jle    c01023ce <trapname+0x2a>
c01023c1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01023c5:	7f 07                	jg     c01023ce <trapname+0x2a>
        return "Hardware Interrupt";
c01023c7:	b8 bf c1 10 c0       	mov    $0xc010c1bf,%eax
c01023cc:	eb 05                	jmp    c01023d3 <trapname+0x2f>
    }
    return "(unknown trap)";
c01023ce:	b8 d2 c1 10 c0       	mov    $0xc010c1d2,%eax
}
c01023d3:	5d                   	pop    %ebp
c01023d4:	c3                   	ret    

c01023d5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01023d5:	55                   	push   %ebp
c01023d6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01023d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01023db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023df:	66 83 f8 08          	cmp    $0x8,%ax
c01023e3:	0f 94 c0             	sete   %al
c01023e6:	0f b6 c0             	movzbl %al,%eax
}
c01023e9:	5d                   	pop    %ebp
c01023ea:	c3                   	ret    

c01023eb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01023eb:	55                   	push   %ebp
c01023ec:	89 e5                	mov    %esp,%ebp
c01023ee:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01023f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f8:	c7 04 24 13 c2 10 c0 	movl   $0xc010c213,(%esp)
c01023ff:	e8 4f df ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c0102404:	8b 45 08             	mov    0x8(%ebp),%eax
c0102407:	89 04 24             	mov    %eax,(%esp)
c010240a:	e8 a1 01 00 00       	call   c01025b0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102416:	0f b7 c0             	movzwl %ax,%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 24 c2 10 c0 	movl   $0xc010c224,(%esp)
c0102424:	e8 2a df ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102429:	8b 45 08             	mov    0x8(%ebp),%eax
c010242c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102430:	0f b7 c0             	movzwl %ax,%eax
c0102433:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102437:	c7 04 24 37 c2 10 c0 	movl   $0xc010c237,(%esp)
c010243e:	e8 10 df ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102443:	8b 45 08             	mov    0x8(%ebp),%eax
c0102446:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010244a:	0f b7 c0             	movzwl %ax,%eax
c010244d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102451:	c7 04 24 4a c2 10 c0 	movl   $0xc010c24a,(%esp)
c0102458:	e8 f6 de ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010245d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102460:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102464:	0f b7 c0             	movzwl %ax,%eax
c0102467:	89 44 24 04          	mov    %eax,0x4(%esp)
c010246b:	c7 04 24 5d c2 10 c0 	movl   $0xc010c25d,(%esp)
c0102472:	e8 dc de ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102477:	8b 45 08             	mov    0x8(%ebp),%eax
c010247a:	8b 40 30             	mov    0x30(%eax),%eax
c010247d:	89 04 24             	mov    %eax,(%esp)
c0102480:	e8 1f ff ff ff       	call   c01023a4 <trapname>
c0102485:	8b 55 08             	mov    0x8(%ebp),%edx
c0102488:	8b 52 30             	mov    0x30(%edx),%edx
c010248b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010248f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102493:	c7 04 24 70 c2 10 c0 	movl   $0xc010c270,(%esp)
c010249a:	e8 b4 de ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010249f:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a2:	8b 40 34             	mov    0x34(%eax),%eax
c01024a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a9:	c7 04 24 82 c2 10 c0 	movl   $0xc010c282,(%esp)
c01024b0:	e8 9e de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01024b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b8:	8b 40 38             	mov    0x38(%eax),%eax
c01024bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024bf:	c7 04 24 91 c2 10 c0 	movl   $0xc010c291,(%esp)
c01024c6:	e8 88 de ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01024cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01024d2:	0f b7 c0             	movzwl %ax,%eax
c01024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d9:	c7 04 24 a0 c2 10 c0 	movl   $0xc010c2a0,(%esp)
c01024e0:	e8 6e de ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 40 40             	mov    0x40(%eax),%eax
c01024eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ef:	c7 04 24 b3 c2 10 c0 	movl   $0xc010c2b3,(%esp)
c01024f6:	e8 58 de ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102502:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102509:	eb 3e                	jmp    c0102549 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010250b:	8b 45 08             	mov    0x8(%ebp),%eax
c010250e:	8b 50 40             	mov    0x40(%eax),%edx
c0102511:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102514:	21 d0                	and    %edx,%eax
c0102516:	85 c0                	test   %eax,%eax
c0102518:	74 28                	je     c0102542 <print_trapframe+0x157>
c010251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010251d:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c0102524:	85 c0                	test   %eax,%eax
c0102526:	74 1a                	je     c0102542 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010252b:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c0102532:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102536:	c7 04 24 c2 c2 10 c0 	movl   $0xc010c2c2,(%esp)
c010253d:	e8 11 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102546:	d1 65 f0             	shll   -0x10(%ebp)
c0102549:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010254c:	83 f8 17             	cmp    $0x17,%eax
c010254f:	76 ba                	jbe    c010250b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102551:	8b 45 08             	mov    0x8(%ebp),%eax
c0102554:	8b 40 40             	mov    0x40(%eax),%eax
c0102557:	25 00 30 00 00       	and    $0x3000,%eax
c010255c:	c1 e8 0c             	shr    $0xc,%eax
c010255f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102563:	c7 04 24 c6 c2 10 c0 	movl   $0xc010c2c6,(%esp)
c010256a:	e8 e4 dd ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c010256f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102572:	89 04 24             	mov    %eax,(%esp)
c0102575:	e8 5b fe ff ff       	call   c01023d5 <trap_in_kernel>
c010257a:	85 c0                	test   %eax,%eax
c010257c:	75 30                	jne    c01025ae <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010257e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102581:	8b 40 44             	mov    0x44(%eax),%eax
c0102584:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102588:	c7 04 24 cf c2 10 c0 	movl   $0xc010c2cf,(%esp)
c010258f:	e8 bf dd ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102594:	8b 45 08             	mov    0x8(%ebp),%eax
c0102597:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010259b:	0f b7 c0             	movzwl %ax,%eax
c010259e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025a2:	c7 04 24 de c2 10 c0 	movl   $0xc010c2de,(%esp)
c01025a9:	e8 a5 dd ff ff       	call   c0100353 <cprintf>
    }
}
c01025ae:	c9                   	leave  
c01025af:	c3                   	ret    

c01025b0 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01025b0:	55                   	push   %ebp
c01025b1:	89 e5                	mov    %esp,%ebp
c01025b3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01025b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b9:	8b 00                	mov    (%eax),%eax
c01025bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025bf:	c7 04 24 f1 c2 10 c0 	movl   $0xc010c2f1,(%esp)
c01025c6:	e8 88 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01025cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ce:	8b 40 04             	mov    0x4(%eax),%eax
c01025d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025d5:	c7 04 24 00 c3 10 c0 	movl   $0xc010c300,(%esp)
c01025dc:	e8 72 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01025e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e4:	8b 40 08             	mov    0x8(%eax),%eax
c01025e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025eb:	c7 04 24 0f c3 10 c0 	movl   $0xc010c30f,(%esp)
c01025f2:	e8 5c dd ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01025f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025fa:	8b 40 0c             	mov    0xc(%eax),%eax
c01025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102601:	c7 04 24 1e c3 10 c0 	movl   $0xc010c31e,(%esp)
c0102608:	e8 46 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010260d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102610:	8b 40 10             	mov    0x10(%eax),%eax
c0102613:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102617:	c7 04 24 2d c3 10 c0 	movl   $0xc010c32d,(%esp)
c010261e:	e8 30 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102623:	8b 45 08             	mov    0x8(%ebp),%eax
c0102626:	8b 40 14             	mov    0x14(%eax),%eax
c0102629:	89 44 24 04          	mov    %eax,0x4(%esp)
c010262d:	c7 04 24 3c c3 10 c0 	movl   $0xc010c33c,(%esp)
c0102634:	e8 1a dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102639:	8b 45 08             	mov    0x8(%ebp),%eax
c010263c:	8b 40 18             	mov    0x18(%eax),%eax
c010263f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102643:	c7 04 24 4b c3 10 c0 	movl   $0xc010c34b,(%esp)
c010264a:	e8 04 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010264f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102652:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102655:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102659:	c7 04 24 5a c3 10 c0 	movl   $0xc010c35a,(%esp)
c0102660:	e8 ee dc ff ff       	call   c0100353 <cprintf>
}
c0102665:	c9                   	leave  
c0102666:	c3                   	ret    

c0102667 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102667:	55                   	push   %ebp
c0102668:	89 e5                	mov    %esp,%ebp
c010266a:	53                   	push   %ebx
c010266b:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010266e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102671:	8b 40 34             	mov    0x34(%eax),%eax
c0102674:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102677:	85 c0                	test   %eax,%eax
c0102679:	74 07                	je     c0102682 <print_pgfault+0x1b>
c010267b:	b9 69 c3 10 c0       	mov    $0xc010c369,%ecx
c0102680:	eb 05                	jmp    c0102687 <print_pgfault+0x20>
c0102682:	b9 7a c3 10 c0       	mov    $0xc010c37a,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102687:	8b 45 08             	mov    0x8(%ebp),%eax
c010268a:	8b 40 34             	mov    0x34(%eax),%eax
c010268d:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102690:	85 c0                	test   %eax,%eax
c0102692:	74 07                	je     c010269b <print_pgfault+0x34>
c0102694:	ba 57 00 00 00       	mov    $0x57,%edx
c0102699:	eb 05                	jmp    c01026a0 <print_pgfault+0x39>
c010269b:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01026a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01026a3:	8b 40 34             	mov    0x34(%eax),%eax
c01026a6:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01026a9:	85 c0                	test   %eax,%eax
c01026ab:	74 07                	je     c01026b4 <print_pgfault+0x4d>
c01026ad:	b8 55 00 00 00       	mov    $0x55,%eax
c01026b2:	eb 05                	jmp    c01026b9 <print_pgfault+0x52>
c01026b4:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01026b9:	0f 20 d3             	mov    %cr2,%ebx
c01026bc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01026bf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01026c2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01026c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01026ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01026ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01026d2:	c7 04 24 88 c3 10 c0 	movl   $0xc010c388,(%esp)
c01026d9:	e8 75 dc ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01026de:	83 c4 34             	add    $0x34,%esp
c01026e1:	5b                   	pop    %ebx
c01026e2:	5d                   	pop    %ebp
c01026e3:	c3                   	ret    

c01026e4 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01026e4:	55                   	push   %ebp
c01026e5:	89 e5                	mov    %esp,%ebp
c01026e7:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c01026ea:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c01026ef:	85 c0                	test   %eax,%eax
c01026f1:	74 0b                	je     c01026fe <pgfault_handler+0x1a>
            print_pgfault(tf);
c01026f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f6:	89 04 24             	mov    %eax,(%esp)
c01026f9:	e8 69 ff ff ff       	call   c0102667 <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c01026fe:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0102703:	85 c0                	test   %eax,%eax
c0102705:	74 3d                	je     c0102744 <pgfault_handler+0x60>
        assert(current == idleproc);
c0102707:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010270d:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c0102712:	39 c2                	cmp    %eax,%edx
c0102714:	74 24                	je     c010273a <pgfault_handler+0x56>
c0102716:	c7 44 24 0c ab c3 10 	movl   $0xc010c3ab,0xc(%esp)
c010271d:	c0 
c010271e:	c7 44 24 08 bf c3 10 	movl   $0xc010c3bf,0x8(%esp)
c0102725:	c0 
c0102726:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010272d:	00 
c010272e:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c0102735:	e8 9b e6 ff ff       	call   c0100dd5 <__panic>
        mm = check_mm_struct;
c010273a:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102742:	eb 46                	jmp    c010278a <pgfault_handler+0xa6>
    }
    else {
        if (current == NULL) {
c0102744:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102749:	85 c0                	test   %eax,%eax
c010274b:	75 32                	jne    c010277f <pgfault_handler+0x9b>
            print_trapframe(tf);
c010274d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102750:	89 04 24             	mov    %eax,(%esp)
c0102753:	e8 93 fc ff ff       	call   c01023eb <print_trapframe>
            print_pgfault(tf);
c0102758:	8b 45 08             	mov    0x8(%ebp),%eax
c010275b:	89 04 24             	mov    %eax,(%esp)
c010275e:	e8 04 ff ff ff       	call   c0102667 <print_pgfault>
            panic("unhandled page fault.\n");
c0102763:	c7 44 24 08 d4 c3 10 	movl   $0xc010c3d4,0x8(%esp)
c010276a:	c0 
c010276b:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0102772:	00 
c0102773:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c010277a:	e8 56 e6 ff ff       	call   c0100dd5 <__panic>
        }
        mm = current->mm;
c010277f:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102784:	8b 40 18             	mov    0x18(%eax),%eax
c0102787:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010278a:	0f 20 d0             	mov    %cr2,%eax
c010278d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr2;
c0102790:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c0102793:	89 c2                	mov    %eax,%edx
c0102795:	8b 45 08             	mov    0x8(%ebp),%eax
c0102798:	8b 40 34             	mov    0x34(%eax),%eax
c010279b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010279f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027a6:	89 04 24             	mov    %eax,(%esp)
c01027a9:	e8 1c 65 00 00       	call   c0108cca <do_pgfault>
}
c01027ae:	c9                   	leave  
c01027af:	c3                   	ret    

c01027b0 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01027b0:	55                   	push   %ebp
c01027b1:	89 e5                	mov    %esp,%ebp
c01027b3:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c01027b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c01027bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c0:	8b 40 30             	mov    0x30(%eax),%eax
c01027c3:	83 f8 2f             	cmp    $0x2f,%eax
c01027c6:	77 38                	ja     c0102800 <trap_dispatch+0x50>
c01027c8:	83 f8 2e             	cmp    $0x2e,%eax
c01027cb:	0f 83 fa 01 00 00    	jae    c01029cb <trap_dispatch+0x21b>
c01027d1:	83 f8 20             	cmp    $0x20,%eax
c01027d4:	0f 84 07 01 00 00    	je     c01028e1 <trap_dispatch+0x131>
c01027da:	83 f8 20             	cmp    $0x20,%eax
c01027dd:	77 0a                	ja     c01027e9 <trap_dispatch+0x39>
c01027df:	83 f8 0e             	cmp    $0xe,%eax
c01027e2:	74 3e                	je     c0102822 <trap_dispatch+0x72>
c01027e4:	e9 9a 01 00 00       	jmp    c0102983 <trap_dispatch+0x1d3>
c01027e9:	83 f8 21             	cmp    $0x21,%eax
c01027ec:	0f 84 4f 01 00 00    	je     c0102941 <trap_dispatch+0x191>
c01027f2:	83 f8 24             	cmp    $0x24,%eax
c01027f5:	0f 84 1d 01 00 00    	je     c0102918 <trap_dispatch+0x168>
c01027fb:	e9 83 01 00 00       	jmp    c0102983 <trap_dispatch+0x1d3>
c0102800:	83 f8 78             	cmp    $0x78,%eax
c0102803:	0f 82 7a 01 00 00    	jb     c0102983 <trap_dispatch+0x1d3>
c0102809:	83 f8 79             	cmp    $0x79,%eax
c010280c:	0f 86 55 01 00 00    	jbe    c0102967 <trap_dispatch+0x1b7>
c0102812:	3d 80 00 00 00       	cmp    $0x80,%eax
c0102817:	0f 84 ba 00 00 00    	je     c01028d7 <trap_dispatch+0x127>
c010281d:	e9 61 01 00 00       	jmp    c0102983 <trap_dispatch+0x1d3>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102822:	8b 45 08             	mov    0x8(%ebp),%eax
c0102825:	89 04 24             	mov    %eax,(%esp)
c0102828:	e8 b7 fe ff ff       	call   c01026e4 <pgfault_handler>
c010282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102834:	0f 84 98 00 00 00    	je     c01028d2 <trap_dispatch+0x122>
            print_trapframe(tf);
c010283a:	8b 45 08             	mov    0x8(%ebp),%eax
c010283d:	89 04 24             	mov    %eax,(%esp)
c0102840:	e8 a6 fb ff ff       	call   c01023eb <print_trapframe>
            if (current == NULL) {
c0102845:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010284a:	85 c0                	test   %eax,%eax
c010284c:	75 23                	jne    c0102871 <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c010284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102851:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102855:	c7 44 24 08 ec c3 10 	movl   $0xc010c3ec,0x8(%esp)
c010285c:	c0 
c010285d:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0102864:	00 
c0102865:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c010286c:	e8 64 e5 ff ff       	call   c0100dd5 <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c0102871:	8b 45 08             	mov    0x8(%ebp),%eax
c0102874:	89 04 24             	mov    %eax,(%esp)
c0102877:	e8 59 fb ff ff       	call   c01023d5 <trap_in_kernel>
c010287c:	85 c0                	test   %eax,%eax
c010287e:	74 23                	je     c01028a3 <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c0102880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102883:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102887:	c7 44 24 08 0c c4 10 	movl   $0xc010c40c,0x8(%esp)
c010288e:	c0 
c010288f:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0102896:	00 
c0102897:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c010289e:	e8 32 e5 ff ff       	call   c0100dd5 <__panic>
                }
                cprintf("killed by kernel.\n");
c01028a3:	c7 04 24 3a c4 10 c0 	movl   $0xc010c43a,(%esp)
c01028aa:	e8 a4 da ff ff       	call   c0100353 <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c01028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01028b6:	c7 44 24 08 50 c4 10 	movl   $0xc010c450,0x8(%esp)
c01028bd:	c0 
c01028be:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01028c5:	00 
c01028c6:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c01028cd:	e8 03 e5 ff ff       	call   c0100dd5 <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
c01028d2:	e9 f5 00 00 00       	jmp    c01029cc <trap_dispatch+0x21c>
    case T_SYSCALL:
        syscall();
c01028d7:	e8 5f 87 00 00       	call   c010b03b <syscall>
        break;
c01028dc:	e9 eb 00 00 00       	jmp    c01029cc <trap_dispatch+0x21c>
    case IRQ_OFFSET + IRQ_TIMER:
      /////新加的
	ticks++;
c01028e1:	a1 b4 ef 19 c0       	mov    0xc019efb4,%eax
c01028e6:	83 c0 01             	add    $0x1,%eax
c01028e9:	a3 b4 ef 19 c0       	mov    %eax,0xc019efb4
        if (ticks == TICK_NUM) {
c01028ee:	a1 b4 ef 19 c0       	mov    0xc019efb4,%eax
c01028f3:	83 f8 64             	cmp    $0x64,%eax
c01028f6:	75 1b                	jne    c0102913 <trap_dispatch+0x163>
            ticks = 0;
c01028f8:	c7 05 b4 ef 19 c0 00 	movl   $0x0,0xc019efb4
c01028ff:	00 00 00 
            current -> need_resched = 1;
c0102902:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102907:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
        /* LAB5 YOUR CODE */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
  
        break;
c010290e:	e9 b9 00 00 00       	jmp    c01029cc <trap_dispatch+0x21c>
c0102913:	e9 b4 00 00 00       	jmp    c01029cc <trap_dispatch+0x21c>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102918:	e8 26 ee ff ff       	call   c0101743 <cons_getc>
c010291d:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102920:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102924:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102928:	89 54 24 08          	mov    %edx,0x8(%esp)
c010292c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102930:	c7 04 24 79 c4 10 c0 	movl   $0xc010c479,(%esp)
c0102937:	e8 17 da ff ff       	call   c0100353 <cprintf>
        break;
c010293c:	e9 8b 00 00 00       	jmp    c01029cc <trap_dispatch+0x21c>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102941:	e8 fd ed ff ff       	call   c0101743 <cons_getc>
c0102946:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102949:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010294d:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102951:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102955:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102959:	c7 04 24 8b c4 10 c0 	movl   $0xc010c48b,(%esp)
c0102960:	e8 ee d9 ff ff       	call   c0100353 <cprintf>
        break;
c0102965:	eb 65                	jmp    c01029cc <trap_dispatch+0x21c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102967:	c7 44 24 08 9a c4 10 	movl   $0xc010c49a,0x8(%esp)
c010296e:	c0 
c010296f:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0102976:	00 
c0102977:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c010297e:	e8 52 e4 ff ff       	call   c0100dd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c0102983:	8b 45 08             	mov    0x8(%ebp),%eax
c0102986:	89 04 24             	mov    %eax,(%esp)
c0102989:	e8 5d fa ff ff       	call   c01023eb <print_trapframe>
        if (current != NULL) {
c010298e:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102993:	85 c0                	test   %eax,%eax
c0102995:	74 18                	je     c01029af <trap_dispatch+0x1ff>
            cprintf("unhandled trap.\n");
c0102997:	c7 04 24 aa c4 10 c0 	movl   $0xc010c4aa,(%esp)
c010299e:	e8 b0 d9 ff ff       	call   c0100353 <cprintf>
            do_exit(-E_KILLED);
c01029a3:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c01029aa:	e8 2f 74 00 00       	call   c0109dde <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c01029af:	c7 44 24 08 bb c4 10 	movl   $0xc010c4bb,0x8(%esp)
c01029b6:	c0 
c01029b7:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01029be:	00 
c01029bf:	c7 04 24 ae c1 10 c0 	movl   $0xc010c1ae,(%esp)
c01029c6:	e8 0a e4 ff ff       	call   c0100dd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c01029cb:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c01029cc:	c9                   	leave  
c01029cd:	c3                   	ret    

c01029ce <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01029ce:	55                   	push   %ebp
c01029cf:	89 e5                	mov    %esp,%ebp
c01029d1:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c01029d4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029d9:	85 c0                	test   %eax,%eax
c01029db:	75 0d                	jne    c01029ea <trap+0x1c>
        trap_dispatch(tf);
c01029dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e0:	89 04 24             	mov    %eax,(%esp)
c01029e3:	e8 c8 fd ff ff       	call   c01027b0 <trap_dispatch>
c01029e8:	eb 6c                	jmp    c0102a56 <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c01029ea:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029ef:	8b 40 3c             	mov    0x3c(%eax),%eax
c01029f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c01029f5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01029fa:	8b 55 08             	mov    0x8(%ebp),%edx
c01029fd:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c0102a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a03:	89 04 24             	mov    %eax,(%esp)
c0102a06:	e8 ca f9 ff ff       	call   c01023d5 <trap_in_kernel>
c0102a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c0102a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a11:	89 04 24             	mov    %eax,(%esp)
c0102a14:	e8 97 fd ff ff       	call   c01027b0 <trap_dispatch>
    
        current->tf = otf;
c0102a19:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102a21:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c0102a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102a28:	75 2c                	jne    c0102a56 <trap+0x88>
            if (current->flags & PF_EXITING) {
c0102a2a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a2f:	8b 40 44             	mov    0x44(%eax),%eax
c0102a32:	83 e0 01             	and    $0x1,%eax
c0102a35:	85 c0                	test   %eax,%eax
c0102a37:	74 0c                	je     c0102a45 <trap+0x77>
                do_exit(-E_KILLED);
c0102a39:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102a40:	e8 99 73 00 00       	call   c0109dde <do_exit>
            }
            if (current->need_resched) {
c0102a45:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0102a4a:	8b 40 10             	mov    0x10(%eax),%eax
c0102a4d:	85 c0                	test   %eax,%eax
c0102a4f:	74 05                	je     c0102a56 <trap+0x88>
                schedule();
c0102a51:	e8 ed 83 00 00       	call   c010ae43 <schedule>
            }
        }
    }
}
c0102a56:	c9                   	leave  
c0102a57:	c3                   	ret    

c0102a58 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102a58:	1e                   	push   %ds
    pushl %es
c0102a59:	06                   	push   %es
    pushl %fs
c0102a5a:	0f a0                	push   %fs
    pushl %gs
c0102a5c:	0f a8                	push   %gs
    pushal
c0102a5e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102a5f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102a64:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102a66:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102a68:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102a69:	e8 60 ff ff ff       	call   c01029ce <trap>

    # pop the pushed stack pointer
    popl %esp
c0102a6e:	5c                   	pop    %esp

c0102a6f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102a6f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102a70:	0f a9                	pop    %gs
    popl %fs
c0102a72:	0f a1                	pop    %fs
    popl %es
c0102a74:	07                   	pop    %es
    popl %ds
c0102a75:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102a76:	83 c4 08             	add    $0x8,%esp
    iret
c0102a79:	cf                   	iret   

c0102a7a <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102a7a:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102a7e:	e9 ec ff ff ff       	jmp    c0102a6f <__trapret>

c0102a83 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $0
c0102a85:	6a 00                	push   $0x0
  jmp __alltraps
c0102a87:	e9 cc ff ff ff       	jmp    c0102a58 <__alltraps>

c0102a8c <vector1>:
.globl vector1
vector1:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $1
c0102a8e:	6a 01                	push   $0x1
  jmp __alltraps
c0102a90:	e9 c3 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102a95 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $2
c0102a97:	6a 02                	push   $0x2
  jmp __alltraps
c0102a99:	e9 ba ff ff ff       	jmp    c0102a58 <__alltraps>

c0102a9e <vector3>:
.globl vector3
vector3:
  pushl $0
c0102a9e:	6a 00                	push   $0x0
  pushl $3
c0102aa0:	6a 03                	push   $0x3
  jmp __alltraps
c0102aa2:	e9 b1 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102aa7 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102aa7:	6a 00                	push   $0x0
  pushl $4
c0102aa9:	6a 04                	push   $0x4
  jmp __alltraps
c0102aab:	e9 a8 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ab0 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $5
c0102ab2:	6a 05                	push   $0x5
  jmp __alltraps
c0102ab4:	e9 9f ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ab9 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $6
c0102abb:	6a 06                	push   $0x6
  jmp __alltraps
c0102abd:	e9 96 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ac2 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102ac2:	6a 00                	push   $0x0
  pushl $7
c0102ac4:	6a 07                	push   $0x7
  jmp __alltraps
c0102ac6:	e9 8d ff ff ff       	jmp    c0102a58 <__alltraps>

c0102acb <vector8>:
.globl vector8
vector8:
  pushl $8
c0102acb:	6a 08                	push   $0x8
  jmp __alltraps
c0102acd:	e9 86 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ad2 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102ad2:	6a 09                	push   $0x9
  jmp __alltraps
c0102ad4:	e9 7f ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ad9 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102ad9:	6a 0a                	push   $0xa
  jmp __alltraps
c0102adb:	e9 78 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ae0 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102ae0:	6a 0b                	push   $0xb
  jmp __alltraps
c0102ae2:	e9 71 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102ae7 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102ae7:	6a 0c                	push   $0xc
  jmp __alltraps
c0102ae9:	e9 6a ff ff ff       	jmp    c0102a58 <__alltraps>

c0102aee <vector13>:
.globl vector13
vector13:
  pushl $13
c0102aee:	6a 0d                	push   $0xd
  jmp __alltraps
c0102af0:	e9 63 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102af5 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102af5:	6a 0e                	push   $0xe
  jmp __alltraps
c0102af7:	e9 5c ff ff ff       	jmp    c0102a58 <__alltraps>

c0102afc <vector15>:
.globl vector15
vector15:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $15
c0102afe:	6a 0f                	push   $0xf
  jmp __alltraps
c0102b00:	e9 53 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b05 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $16
c0102b07:	6a 10                	push   $0x10
  jmp __alltraps
c0102b09:	e9 4a ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b0e <vector17>:
.globl vector17
vector17:
  pushl $17
c0102b0e:	6a 11                	push   $0x11
  jmp __alltraps
c0102b10:	e9 43 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b15 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102b15:	6a 00                	push   $0x0
  pushl $18
c0102b17:	6a 12                	push   $0x12
  jmp __alltraps
c0102b19:	e9 3a ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b1e <vector19>:
.globl vector19
vector19:
  pushl $0
c0102b1e:	6a 00                	push   $0x0
  pushl $19
c0102b20:	6a 13                	push   $0x13
  jmp __alltraps
c0102b22:	e9 31 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b27 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102b27:	6a 00                	push   $0x0
  pushl $20
c0102b29:	6a 14                	push   $0x14
  jmp __alltraps
c0102b2b:	e9 28 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b30 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102b30:	6a 00                	push   $0x0
  pushl $21
c0102b32:	6a 15                	push   $0x15
  jmp __alltraps
c0102b34:	e9 1f ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b39 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102b39:	6a 00                	push   $0x0
  pushl $22
c0102b3b:	6a 16                	push   $0x16
  jmp __alltraps
c0102b3d:	e9 16 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b42 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102b42:	6a 00                	push   $0x0
  pushl $23
c0102b44:	6a 17                	push   $0x17
  jmp __alltraps
c0102b46:	e9 0d ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b4b <vector24>:
.globl vector24
vector24:
  pushl $0
c0102b4b:	6a 00                	push   $0x0
  pushl $24
c0102b4d:	6a 18                	push   $0x18
  jmp __alltraps
c0102b4f:	e9 04 ff ff ff       	jmp    c0102a58 <__alltraps>

c0102b54 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102b54:	6a 00                	push   $0x0
  pushl $25
c0102b56:	6a 19                	push   $0x19
  jmp __alltraps
c0102b58:	e9 fb fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b5d <vector26>:
.globl vector26
vector26:
  pushl $0
c0102b5d:	6a 00                	push   $0x0
  pushl $26
c0102b5f:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102b61:	e9 f2 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b66 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102b66:	6a 00                	push   $0x0
  pushl $27
c0102b68:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102b6a:	e9 e9 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b6f <vector28>:
.globl vector28
vector28:
  pushl $0
c0102b6f:	6a 00                	push   $0x0
  pushl $28
c0102b71:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102b73:	e9 e0 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b78 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102b78:	6a 00                	push   $0x0
  pushl $29
c0102b7a:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102b7c:	e9 d7 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b81 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102b81:	6a 00                	push   $0x0
  pushl $30
c0102b83:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102b85:	e9 ce fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b8a <vector31>:
.globl vector31
vector31:
  pushl $0
c0102b8a:	6a 00                	push   $0x0
  pushl $31
c0102b8c:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102b8e:	e9 c5 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b93 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102b93:	6a 00                	push   $0x0
  pushl $32
c0102b95:	6a 20                	push   $0x20
  jmp __alltraps
c0102b97:	e9 bc fe ff ff       	jmp    c0102a58 <__alltraps>

c0102b9c <vector33>:
.globl vector33
vector33:
  pushl $0
c0102b9c:	6a 00                	push   $0x0
  pushl $33
c0102b9e:	6a 21                	push   $0x21
  jmp __alltraps
c0102ba0:	e9 b3 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102ba5 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102ba5:	6a 00                	push   $0x0
  pushl $34
c0102ba7:	6a 22                	push   $0x22
  jmp __alltraps
c0102ba9:	e9 aa fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bae <vector35>:
.globl vector35
vector35:
  pushl $0
c0102bae:	6a 00                	push   $0x0
  pushl $35
c0102bb0:	6a 23                	push   $0x23
  jmp __alltraps
c0102bb2:	e9 a1 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bb7 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102bb7:	6a 00                	push   $0x0
  pushl $36
c0102bb9:	6a 24                	push   $0x24
  jmp __alltraps
c0102bbb:	e9 98 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bc0 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102bc0:	6a 00                	push   $0x0
  pushl $37
c0102bc2:	6a 25                	push   $0x25
  jmp __alltraps
c0102bc4:	e9 8f fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bc9 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102bc9:	6a 00                	push   $0x0
  pushl $38
c0102bcb:	6a 26                	push   $0x26
  jmp __alltraps
c0102bcd:	e9 86 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bd2 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102bd2:	6a 00                	push   $0x0
  pushl $39
c0102bd4:	6a 27                	push   $0x27
  jmp __alltraps
c0102bd6:	e9 7d fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bdb <vector40>:
.globl vector40
vector40:
  pushl $0
c0102bdb:	6a 00                	push   $0x0
  pushl $40
c0102bdd:	6a 28                	push   $0x28
  jmp __alltraps
c0102bdf:	e9 74 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102be4 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102be4:	6a 00                	push   $0x0
  pushl $41
c0102be6:	6a 29                	push   $0x29
  jmp __alltraps
c0102be8:	e9 6b fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bed <vector42>:
.globl vector42
vector42:
  pushl $0
c0102bed:	6a 00                	push   $0x0
  pushl $42
c0102bef:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102bf1:	e9 62 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bf6 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102bf6:	6a 00                	push   $0x0
  pushl $43
c0102bf8:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102bfa:	e9 59 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102bff <vector44>:
.globl vector44
vector44:
  pushl $0
c0102bff:	6a 00                	push   $0x0
  pushl $44
c0102c01:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102c03:	e9 50 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c08 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102c08:	6a 00                	push   $0x0
  pushl $45
c0102c0a:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102c0c:	e9 47 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c11 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102c11:	6a 00                	push   $0x0
  pushl $46
c0102c13:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102c15:	e9 3e fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c1a <vector47>:
.globl vector47
vector47:
  pushl $0
c0102c1a:	6a 00                	push   $0x0
  pushl $47
c0102c1c:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102c1e:	e9 35 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c23 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102c23:	6a 00                	push   $0x0
  pushl $48
c0102c25:	6a 30                	push   $0x30
  jmp __alltraps
c0102c27:	e9 2c fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c2c <vector49>:
.globl vector49
vector49:
  pushl $0
c0102c2c:	6a 00                	push   $0x0
  pushl $49
c0102c2e:	6a 31                	push   $0x31
  jmp __alltraps
c0102c30:	e9 23 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c35 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102c35:	6a 00                	push   $0x0
  pushl $50
c0102c37:	6a 32                	push   $0x32
  jmp __alltraps
c0102c39:	e9 1a fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c3e <vector51>:
.globl vector51
vector51:
  pushl $0
c0102c3e:	6a 00                	push   $0x0
  pushl $51
c0102c40:	6a 33                	push   $0x33
  jmp __alltraps
c0102c42:	e9 11 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c47 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102c47:	6a 00                	push   $0x0
  pushl $52
c0102c49:	6a 34                	push   $0x34
  jmp __alltraps
c0102c4b:	e9 08 fe ff ff       	jmp    c0102a58 <__alltraps>

c0102c50 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102c50:	6a 00                	push   $0x0
  pushl $53
c0102c52:	6a 35                	push   $0x35
  jmp __alltraps
c0102c54:	e9 ff fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c59 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102c59:	6a 00                	push   $0x0
  pushl $54
c0102c5b:	6a 36                	push   $0x36
  jmp __alltraps
c0102c5d:	e9 f6 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c62 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102c62:	6a 00                	push   $0x0
  pushl $55
c0102c64:	6a 37                	push   $0x37
  jmp __alltraps
c0102c66:	e9 ed fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c6b <vector56>:
.globl vector56
vector56:
  pushl $0
c0102c6b:	6a 00                	push   $0x0
  pushl $56
c0102c6d:	6a 38                	push   $0x38
  jmp __alltraps
c0102c6f:	e9 e4 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c74 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102c74:	6a 00                	push   $0x0
  pushl $57
c0102c76:	6a 39                	push   $0x39
  jmp __alltraps
c0102c78:	e9 db fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c7d <vector58>:
.globl vector58
vector58:
  pushl $0
c0102c7d:	6a 00                	push   $0x0
  pushl $58
c0102c7f:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102c81:	e9 d2 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c86 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102c86:	6a 00                	push   $0x0
  pushl $59
c0102c88:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102c8a:	e9 c9 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c8f <vector60>:
.globl vector60
vector60:
  pushl $0
c0102c8f:	6a 00                	push   $0x0
  pushl $60
c0102c91:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102c93:	e9 c0 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102c98 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102c98:	6a 00                	push   $0x0
  pushl $61
c0102c9a:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102c9c:	e9 b7 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102ca1 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102ca1:	6a 00                	push   $0x0
  pushl $62
c0102ca3:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102ca5:	e9 ae fd ff ff       	jmp    c0102a58 <__alltraps>

c0102caa <vector63>:
.globl vector63
vector63:
  pushl $0
c0102caa:	6a 00                	push   $0x0
  pushl $63
c0102cac:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102cae:	e9 a5 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cb3 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102cb3:	6a 00                	push   $0x0
  pushl $64
c0102cb5:	6a 40                	push   $0x40
  jmp __alltraps
c0102cb7:	e9 9c fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cbc <vector65>:
.globl vector65
vector65:
  pushl $0
c0102cbc:	6a 00                	push   $0x0
  pushl $65
c0102cbe:	6a 41                	push   $0x41
  jmp __alltraps
c0102cc0:	e9 93 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cc5 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102cc5:	6a 00                	push   $0x0
  pushl $66
c0102cc7:	6a 42                	push   $0x42
  jmp __alltraps
c0102cc9:	e9 8a fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cce <vector67>:
.globl vector67
vector67:
  pushl $0
c0102cce:	6a 00                	push   $0x0
  pushl $67
c0102cd0:	6a 43                	push   $0x43
  jmp __alltraps
c0102cd2:	e9 81 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cd7 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102cd7:	6a 00                	push   $0x0
  pushl $68
c0102cd9:	6a 44                	push   $0x44
  jmp __alltraps
c0102cdb:	e9 78 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102ce0 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102ce0:	6a 00                	push   $0x0
  pushl $69
c0102ce2:	6a 45                	push   $0x45
  jmp __alltraps
c0102ce4:	e9 6f fd ff ff       	jmp    c0102a58 <__alltraps>

c0102ce9 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102ce9:	6a 00                	push   $0x0
  pushl $70
c0102ceb:	6a 46                	push   $0x46
  jmp __alltraps
c0102ced:	e9 66 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cf2 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102cf2:	6a 00                	push   $0x0
  pushl $71
c0102cf4:	6a 47                	push   $0x47
  jmp __alltraps
c0102cf6:	e9 5d fd ff ff       	jmp    c0102a58 <__alltraps>

c0102cfb <vector72>:
.globl vector72
vector72:
  pushl $0
c0102cfb:	6a 00                	push   $0x0
  pushl $72
c0102cfd:	6a 48                	push   $0x48
  jmp __alltraps
c0102cff:	e9 54 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d04 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102d04:	6a 00                	push   $0x0
  pushl $73
c0102d06:	6a 49                	push   $0x49
  jmp __alltraps
c0102d08:	e9 4b fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d0d <vector74>:
.globl vector74
vector74:
  pushl $0
c0102d0d:	6a 00                	push   $0x0
  pushl $74
c0102d0f:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102d11:	e9 42 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d16 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102d16:	6a 00                	push   $0x0
  pushl $75
c0102d18:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102d1a:	e9 39 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d1f <vector76>:
.globl vector76
vector76:
  pushl $0
c0102d1f:	6a 00                	push   $0x0
  pushl $76
c0102d21:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102d23:	e9 30 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d28 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102d28:	6a 00                	push   $0x0
  pushl $77
c0102d2a:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102d2c:	e9 27 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d31 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102d31:	6a 00                	push   $0x0
  pushl $78
c0102d33:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102d35:	e9 1e fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d3a <vector79>:
.globl vector79
vector79:
  pushl $0
c0102d3a:	6a 00                	push   $0x0
  pushl $79
c0102d3c:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102d3e:	e9 15 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d43 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102d43:	6a 00                	push   $0x0
  pushl $80
c0102d45:	6a 50                	push   $0x50
  jmp __alltraps
c0102d47:	e9 0c fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d4c <vector81>:
.globl vector81
vector81:
  pushl $0
c0102d4c:	6a 00                	push   $0x0
  pushl $81
c0102d4e:	6a 51                	push   $0x51
  jmp __alltraps
c0102d50:	e9 03 fd ff ff       	jmp    c0102a58 <__alltraps>

c0102d55 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102d55:	6a 00                	push   $0x0
  pushl $82
c0102d57:	6a 52                	push   $0x52
  jmp __alltraps
c0102d59:	e9 fa fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d5e <vector83>:
.globl vector83
vector83:
  pushl $0
c0102d5e:	6a 00                	push   $0x0
  pushl $83
c0102d60:	6a 53                	push   $0x53
  jmp __alltraps
c0102d62:	e9 f1 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d67 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102d67:	6a 00                	push   $0x0
  pushl $84
c0102d69:	6a 54                	push   $0x54
  jmp __alltraps
c0102d6b:	e9 e8 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d70 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102d70:	6a 00                	push   $0x0
  pushl $85
c0102d72:	6a 55                	push   $0x55
  jmp __alltraps
c0102d74:	e9 df fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d79 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102d79:	6a 00                	push   $0x0
  pushl $86
c0102d7b:	6a 56                	push   $0x56
  jmp __alltraps
c0102d7d:	e9 d6 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d82 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102d82:	6a 00                	push   $0x0
  pushl $87
c0102d84:	6a 57                	push   $0x57
  jmp __alltraps
c0102d86:	e9 cd fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d8b <vector88>:
.globl vector88
vector88:
  pushl $0
c0102d8b:	6a 00                	push   $0x0
  pushl $88
c0102d8d:	6a 58                	push   $0x58
  jmp __alltraps
c0102d8f:	e9 c4 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d94 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102d94:	6a 00                	push   $0x0
  pushl $89
c0102d96:	6a 59                	push   $0x59
  jmp __alltraps
c0102d98:	e9 bb fc ff ff       	jmp    c0102a58 <__alltraps>

c0102d9d <vector90>:
.globl vector90
vector90:
  pushl $0
c0102d9d:	6a 00                	push   $0x0
  pushl $90
c0102d9f:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102da1:	e9 b2 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102da6 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102da6:	6a 00                	push   $0x0
  pushl $91
c0102da8:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102daa:	e9 a9 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102daf <vector92>:
.globl vector92
vector92:
  pushl $0
c0102daf:	6a 00                	push   $0x0
  pushl $92
c0102db1:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102db3:	e9 a0 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102db8 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102db8:	6a 00                	push   $0x0
  pushl $93
c0102dba:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102dbc:	e9 97 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102dc1 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102dc1:	6a 00                	push   $0x0
  pushl $94
c0102dc3:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102dc5:	e9 8e fc ff ff       	jmp    c0102a58 <__alltraps>

c0102dca <vector95>:
.globl vector95
vector95:
  pushl $0
c0102dca:	6a 00                	push   $0x0
  pushl $95
c0102dcc:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102dce:	e9 85 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102dd3 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102dd3:	6a 00                	push   $0x0
  pushl $96
c0102dd5:	6a 60                	push   $0x60
  jmp __alltraps
c0102dd7:	e9 7c fc ff ff       	jmp    c0102a58 <__alltraps>

c0102ddc <vector97>:
.globl vector97
vector97:
  pushl $0
c0102ddc:	6a 00                	push   $0x0
  pushl $97
c0102dde:	6a 61                	push   $0x61
  jmp __alltraps
c0102de0:	e9 73 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102de5 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102de5:	6a 00                	push   $0x0
  pushl $98
c0102de7:	6a 62                	push   $0x62
  jmp __alltraps
c0102de9:	e9 6a fc ff ff       	jmp    c0102a58 <__alltraps>

c0102dee <vector99>:
.globl vector99
vector99:
  pushl $0
c0102dee:	6a 00                	push   $0x0
  pushl $99
c0102df0:	6a 63                	push   $0x63
  jmp __alltraps
c0102df2:	e9 61 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102df7 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102df7:	6a 00                	push   $0x0
  pushl $100
c0102df9:	6a 64                	push   $0x64
  jmp __alltraps
c0102dfb:	e9 58 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e00 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102e00:	6a 00                	push   $0x0
  pushl $101
c0102e02:	6a 65                	push   $0x65
  jmp __alltraps
c0102e04:	e9 4f fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e09 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102e09:	6a 00                	push   $0x0
  pushl $102
c0102e0b:	6a 66                	push   $0x66
  jmp __alltraps
c0102e0d:	e9 46 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e12 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102e12:	6a 00                	push   $0x0
  pushl $103
c0102e14:	6a 67                	push   $0x67
  jmp __alltraps
c0102e16:	e9 3d fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e1b <vector104>:
.globl vector104
vector104:
  pushl $0
c0102e1b:	6a 00                	push   $0x0
  pushl $104
c0102e1d:	6a 68                	push   $0x68
  jmp __alltraps
c0102e1f:	e9 34 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e24 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102e24:	6a 00                	push   $0x0
  pushl $105
c0102e26:	6a 69                	push   $0x69
  jmp __alltraps
c0102e28:	e9 2b fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e2d <vector106>:
.globl vector106
vector106:
  pushl $0
c0102e2d:	6a 00                	push   $0x0
  pushl $106
c0102e2f:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102e31:	e9 22 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e36 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102e36:	6a 00                	push   $0x0
  pushl $107
c0102e38:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102e3a:	e9 19 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e3f <vector108>:
.globl vector108
vector108:
  pushl $0
c0102e3f:	6a 00                	push   $0x0
  pushl $108
c0102e41:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102e43:	e9 10 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e48 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102e48:	6a 00                	push   $0x0
  pushl $109
c0102e4a:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102e4c:	e9 07 fc ff ff       	jmp    c0102a58 <__alltraps>

c0102e51 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102e51:	6a 00                	push   $0x0
  pushl $110
c0102e53:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102e55:	e9 fe fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e5a <vector111>:
.globl vector111
vector111:
  pushl $0
c0102e5a:	6a 00                	push   $0x0
  pushl $111
c0102e5c:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102e5e:	e9 f5 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e63 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102e63:	6a 00                	push   $0x0
  pushl $112
c0102e65:	6a 70                	push   $0x70
  jmp __alltraps
c0102e67:	e9 ec fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e6c <vector113>:
.globl vector113
vector113:
  pushl $0
c0102e6c:	6a 00                	push   $0x0
  pushl $113
c0102e6e:	6a 71                	push   $0x71
  jmp __alltraps
c0102e70:	e9 e3 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e75 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102e75:	6a 00                	push   $0x0
  pushl $114
c0102e77:	6a 72                	push   $0x72
  jmp __alltraps
c0102e79:	e9 da fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e7e <vector115>:
.globl vector115
vector115:
  pushl $0
c0102e7e:	6a 00                	push   $0x0
  pushl $115
c0102e80:	6a 73                	push   $0x73
  jmp __alltraps
c0102e82:	e9 d1 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e87 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102e87:	6a 00                	push   $0x0
  pushl $116
c0102e89:	6a 74                	push   $0x74
  jmp __alltraps
c0102e8b:	e9 c8 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e90 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102e90:	6a 00                	push   $0x0
  pushl $117
c0102e92:	6a 75                	push   $0x75
  jmp __alltraps
c0102e94:	e9 bf fb ff ff       	jmp    c0102a58 <__alltraps>

c0102e99 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102e99:	6a 00                	push   $0x0
  pushl $118
c0102e9b:	6a 76                	push   $0x76
  jmp __alltraps
c0102e9d:	e9 b6 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ea2 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102ea2:	6a 00                	push   $0x0
  pushl $119
c0102ea4:	6a 77                	push   $0x77
  jmp __alltraps
c0102ea6:	e9 ad fb ff ff       	jmp    c0102a58 <__alltraps>

c0102eab <vector120>:
.globl vector120
vector120:
  pushl $0
c0102eab:	6a 00                	push   $0x0
  pushl $120
c0102ead:	6a 78                	push   $0x78
  jmp __alltraps
c0102eaf:	e9 a4 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102eb4 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102eb4:	6a 00                	push   $0x0
  pushl $121
c0102eb6:	6a 79                	push   $0x79
  jmp __alltraps
c0102eb8:	e9 9b fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ebd <vector122>:
.globl vector122
vector122:
  pushl $0
c0102ebd:	6a 00                	push   $0x0
  pushl $122
c0102ebf:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102ec1:	e9 92 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ec6 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102ec6:	6a 00                	push   $0x0
  pushl $123
c0102ec8:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102eca:	e9 89 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ecf <vector124>:
.globl vector124
vector124:
  pushl $0
c0102ecf:	6a 00                	push   $0x0
  pushl $124
c0102ed1:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102ed3:	e9 80 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ed8 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ed8:	6a 00                	push   $0x0
  pushl $125
c0102eda:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102edc:	e9 77 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ee1 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102ee1:	6a 00                	push   $0x0
  pushl $126
c0102ee3:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102ee5:	e9 6e fb ff ff       	jmp    c0102a58 <__alltraps>

c0102eea <vector127>:
.globl vector127
vector127:
  pushl $0
c0102eea:	6a 00                	push   $0x0
  pushl $127
c0102eec:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102eee:	e9 65 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102ef3 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102ef3:	6a 00                	push   $0x0
  pushl $128
c0102ef5:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102efa:	e9 59 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102eff <vector129>:
.globl vector129
vector129:
  pushl $0
c0102eff:	6a 00                	push   $0x0
  pushl $129
c0102f01:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102f06:	e9 4d fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f0b <vector130>:
.globl vector130
vector130:
  pushl $0
c0102f0b:	6a 00                	push   $0x0
  pushl $130
c0102f0d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102f12:	e9 41 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f17 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102f17:	6a 00                	push   $0x0
  pushl $131
c0102f19:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102f1e:	e9 35 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f23 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102f23:	6a 00                	push   $0x0
  pushl $132
c0102f25:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102f2a:	e9 29 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f2f <vector133>:
.globl vector133
vector133:
  pushl $0
c0102f2f:	6a 00                	push   $0x0
  pushl $133
c0102f31:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102f36:	e9 1d fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f3b <vector134>:
.globl vector134
vector134:
  pushl $0
c0102f3b:	6a 00                	push   $0x0
  pushl $134
c0102f3d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102f42:	e9 11 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f47 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102f47:	6a 00                	push   $0x0
  pushl $135
c0102f49:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102f4e:	e9 05 fb ff ff       	jmp    c0102a58 <__alltraps>

c0102f53 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102f53:	6a 00                	push   $0x0
  pushl $136
c0102f55:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102f5a:	e9 f9 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102f5f <vector137>:
.globl vector137
vector137:
  pushl $0
c0102f5f:	6a 00                	push   $0x0
  pushl $137
c0102f61:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102f66:	e9 ed fa ff ff       	jmp    c0102a58 <__alltraps>

c0102f6b <vector138>:
.globl vector138
vector138:
  pushl $0
c0102f6b:	6a 00                	push   $0x0
  pushl $138
c0102f6d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102f72:	e9 e1 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102f77 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102f77:	6a 00                	push   $0x0
  pushl $139
c0102f79:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102f7e:	e9 d5 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102f83 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102f83:	6a 00                	push   $0x0
  pushl $140
c0102f85:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102f8a:	e9 c9 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102f8f <vector141>:
.globl vector141
vector141:
  pushl $0
c0102f8f:	6a 00                	push   $0x0
  pushl $141
c0102f91:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102f96:	e9 bd fa ff ff       	jmp    c0102a58 <__alltraps>

c0102f9b <vector142>:
.globl vector142
vector142:
  pushl $0
c0102f9b:	6a 00                	push   $0x0
  pushl $142
c0102f9d:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102fa2:	e9 b1 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fa7 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102fa7:	6a 00                	push   $0x0
  pushl $143
c0102fa9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102fae:	e9 a5 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fb3 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102fb3:	6a 00                	push   $0x0
  pushl $144
c0102fb5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102fba:	e9 99 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fbf <vector145>:
.globl vector145
vector145:
  pushl $0
c0102fbf:	6a 00                	push   $0x0
  pushl $145
c0102fc1:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102fc6:	e9 8d fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fcb <vector146>:
.globl vector146
vector146:
  pushl $0
c0102fcb:	6a 00                	push   $0x0
  pushl $146
c0102fcd:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102fd2:	e9 81 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fd7 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102fd7:	6a 00                	push   $0x0
  pushl $147
c0102fd9:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102fde:	e9 75 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fe3 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102fe3:	6a 00                	push   $0x0
  pushl $148
c0102fe5:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102fea:	e9 69 fa ff ff       	jmp    c0102a58 <__alltraps>

c0102fef <vector149>:
.globl vector149
vector149:
  pushl $0
c0102fef:	6a 00                	push   $0x0
  pushl $149
c0102ff1:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102ff6:	e9 5d fa ff ff       	jmp    c0102a58 <__alltraps>

c0102ffb <vector150>:
.globl vector150
vector150:
  pushl $0
c0102ffb:	6a 00                	push   $0x0
  pushl $150
c0102ffd:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0103002:	e9 51 fa ff ff       	jmp    c0102a58 <__alltraps>

c0103007 <vector151>:
.globl vector151
vector151:
  pushl $0
c0103007:	6a 00                	push   $0x0
  pushl $151
c0103009:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010300e:	e9 45 fa ff ff       	jmp    c0102a58 <__alltraps>

c0103013 <vector152>:
.globl vector152
vector152:
  pushl $0
c0103013:	6a 00                	push   $0x0
  pushl $152
c0103015:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010301a:	e9 39 fa ff ff       	jmp    c0102a58 <__alltraps>

c010301f <vector153>:
.globl vector153
vector153:
  pushl $0
c010301f:	6a 00                	push   $0x0
  pushl $153
c0103021:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0103026:	e9 2d fa ff ff       	jmp    c0102a58 <__alltraps>

c010302b <vector154>:
.globl vector154
vector154:
  pushl $0
c010302b:	6a 00                	push   $0x0
  pushl $154
c010302d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0103032:	e9 21 fa ff ff       	jmp    c0102a58 <__alltraps>

c0103037 <vector155>:
.globl vector155
vector155:
  pushl $0
c0103037:	6a 00                	push   $0x0
  pushl $155
c0103039:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010303e:	e9 15 fa ff ff       	jmp    c0102a58 <__alltraps>

c0103043 <vector156>:
.globl vector156
vector156:
  pushl $0
c0103043:	6a 00                	push   $0x0
  pushl $156
c0103045:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010304a:	e9 09 fa ff ff       	jmp    c0102a58 <__alltraps>

c010304f <vector157>:
.globl vector157
vector157:
  pushl $0
c010304f:	6a 00                	push   $0x0
  pushl $157
c0103051:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0103056:	e9 fd f9 ff ff       	jmp    c0102a58 <__alltraps>

c010305b <vector158>:
.globl vector158
vector158:
  pushl $0
c010305b:	6a 00                	push   $0x0
  pushl $158
c010305d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0103062:	e9 f1 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103067 <vector159>:
.globl vector159
vector159:
  pushl $0
c0103067:	6a 00                	push   $0x0
  pushl $159
c0103069:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010306e:	e9 e5 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103073 <vector160>:
.globl vector160
vector160:
  pushl $0
c0103073:	6a 00                	push   $0x0
  pushl $160
c0103075:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010307a:	e9 d9 f9 ff ff       	jmp    c0102a58 <__alltraps>

c010307f <vector161>:
.globl vector161
vector161:
  pushl $0
c010307f:	6a 00                	push   $0x0
  pushl $161
c0103081:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0103086:	e9 cd f9 ff ff       	jmp    c0102a58 <__alltraps>

c010308b <vector162>:
.globl vector162
vector162:
  pushl $0
c010308b:	6a 00                	push   $0x0
  pushl $162
c010308d:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0103092:	e9 c1 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103097 <vector163>:
.globl vector163
vector163:
  pushl $0
c0103097:	6a 00                	push   $0x0
  pushl $163
c0103099:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010309e:	e9 b5 f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030a3 <vector164>:
.globl vector164
vector164:
  pushl $0
c01030a3:	6a 00                	push   $0x0
  pushl $164
c01030a5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01030aa:	e9 a9 f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030af <vector165>:
.globl vector165
vector165:
  pushl $0
c01030af:	6a 00                	push   $0x0
  pushl $165
c01030b1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01030b6:	e9 9d f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030bb <vector166>:
.globl vector166
vector166:
  pushl $0
c01030bb:	6a 00                	push   $0x0
  pushl $166
c01030bd:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01030c2:	e9 91 f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030c7 <vector167>:
.globl vector167
vector167:
  pushl $0
c01030c7:	6a 00                	push   $0x0
  pushl $167
c01030c9:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01030ce:	e9 85 f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030d3 <vector168>:
.globl vector168
vector168:
  pushl $0
c01030d3:	6a 00                	push   $0x0
  pushl $168
c01030d5:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01030da:	e9 79 f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030df <vector169>:
.globl vector169
vector169:
  pushl $0
c01030df:	6a 00                	push   $0x0
  pushl $169
c01030e1:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01030e6:	e9 6d f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030eb <vector170>:
.globl vector170
vector170:
  pushl $0
c01030eb:	6a 00                	push   $0x0
  pushl $170
c01030ed:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01030f2:	e9 61 f9 ff ff       	jmp    c0102a58 <__alltraps>

c01030f7 <vector171>:
.globl vector171
vector171:
  pushl $0
c01030f7:	6a 00                	push   $0x0
  pushl $171
c01030f9:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01030fe:	e9 55 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103103 <vector172>:
.globl vector172
vector172:
  pushl $0
c0103103:	6a 00                	push   $0x0
  pushl $172
c0103105:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010310a:	e9 49 f9 ff ff       	jmp    c0102a58 <__alltraps>

c010310f <vector173>:
.globl vector173
vector173:
  pushl $0
c010310f:	6a 00                	push   $0x0
  pushl $173
c0103111:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0103116:	e9 3d f9 ff ff       	jmp    c0102a58 <__alltraps>

c010311b <vector174>:
.globl vector174
vector174:
  pushl $0
c010311b:	6a 00                	push   $0x0
  pushl $174
c010311d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0103122:	e9 31 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103127 <vector175>:
.globl vector175
vector175:
  pushl $0
c0103127:	6a 00                	push   $0x0
  pushl $175
c0103129:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010312e:	e9 25 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103133 <vector176>:
.globl vector176
vector176:
  pushl $0
c0103133:	6a 00                	push   $0x0
  pushl $176
c0103135:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010313a:	e9 19 f9 ff ff       	jmp    c0102a58 <__alltraps>

c010313f <vector177>:
.globl vector177
vector177:
  pushl $0
c010313f:	6a 00                	push   $0x0
  pushl $177
c0103141:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0103146:	e9 0d f9 ff ff       	jmp    c0102a58 <__alltraps>

c010314b <vector178>:
.globl vector178
vector178:
  pushl $0
c010314b:	6a 00                	push   $0x0
  pushl $178
c010314d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0103152:	e9 01 f9 ff ff       	jmp    c0102a58 <__alltraps>

c0103157 <vector179>:
.globl vector179
vector179:
  pushl $0
c0103157:	6a 00                	push   $0x0
  pushl $179
c0103159:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010315e:	e9 f5 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103163 <vector180>:
.globl vector180
vector180:
  pushl $0
c0103163:	6a 00                	push   $0x0
  pushl $180
c0103165:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010316a:	e9 e9 f8 ff ff       	jmp    c0102a58 <__alltraps>

c010316f <vector181>:
.globl vector181
vector181:
  pushl $0
c010316f:	6a 00                	push   $0x0
  pushl $181
c0103171:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0103176:	e9 dd f8 ff ff       	jmp    c0102a58 <__alltraps>

c010317b <vector182>:
.globl vector182
vector182:
  pushl $0
c010317b:	6a 00                	push   $0x0
  pushl $182
c010317d:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103182:	e9 d1 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103187 <vector183>:
.globl vector183
vector183:
  pushl $0
c0103187:	6a 00                	push   $0x0
  pushl $183
c0103189:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010318e:	e9 c5 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103193 <vector184>:
.globl vector184
vector184:
  pushl $0
c0103193:	6a 00                	push   $0x0
  pushl $184
c0103195:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010319a:	e9 b9 f8 ff ff       	jmp    c0102a58 <__alltraps>

c010319f <vector185>:
.globl vector185
vector185:
  pushl $0
c010319f:	6a 00                	push   $0x0
  pushl $185
c01031a1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01031a6:	e9 ad f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031ab <vector186>:
.globl vector186
vector186:
  pushl $0
c01031ab:	6a 00                	push   $0x0
  pushl $186
c01031ad:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01031b2:	e9 a1 f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031b7 <vector187>:
.globl vector187
vector187:
  pushl $0
c01031b7:	6a 00                	push   $0x0
  pushl $187
c01031b9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01031be:	e9 95 f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031c3 <vector188>:
.globl vector188
vector188:
  pushl $0
c01031c3:	6a 00                	push   $0x0
  pushl $188
c01031c5:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01031ca:	e9 89 f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031cf <vector189>:
.globl vector189
vector189:
  pushl $0
c01031cf:	6a 00                	push   $0x0
  pushl $189
c01031d1:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01031d6:	e9 7d f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031db <vector190>:
.globl vector190
vector190:
  pushl $0
c01031db:	6a 00                	push   $0x0
  pushl $190
c01031dd:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01031e2:	e9 71 f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031e7 <vector191>:
.globl vector191
vector191:
  pushl $0
c01031e7:	6a 00                	push   $0x0
  pushl $191
c01031e9:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01031ee:	e9 65 f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031f3 <vector192>:
.globl vector192
vector192:
  pushl $0
c01031f3:	6a 00                	push   $0x0
  pushl $192
c01031f5:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01031fa:	e9 59 f8 ff ff       	jmp    c0102a58 <__alltraps>

c01031ff <vector193>:
.globl vector193
vector193:
  pushl $0
c01031ff:	6a 00                	push   $0x0
  pushl $193
c0103201:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0103206:	e9 4d f8 ff ff       	jmp    c0102a58 <__alltraps>

c010320b <vector194>:
.globl vector194
vector194:
  pushl $0
c010320b:	6a 00                	push   $0x0
  pushl $194
c010320d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103212:	e9 41 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103217 <vector195>:
.globl vector195
vector195:
  pushl $0
c0103217:	6a 00                	push   $0x0
  pushl $195
c0103219:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010321e:	e9 35 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103223 <vector196>:
.globl vector196
vector196:
  pushl $0
c0103223:	6a 00                	push   $0x0
  pushl $196
c0103225:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010322a:	e9 29 f8 ff ff       	jmp    c0102a58 <__alltraps>

c010322f <vector197>:
.globl vector197
vector197:
  pushl $0
c010322f:	6a 00                	push   $0x0
  pushl $197
c0103231:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103236:	e9 1d f8 ff ff       	jmp    c0102a58 <__alltraps>

c010323b <vector198>:
.globl vector198
vector198:
  pushl $0
c010323b:	6a 00                	push   $0x0
  pushl $198
c010323d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103242:	e9 11 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103247 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103247:	6a 00                	push   $0x0
  pushl $199
c0103249:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010324e:	e9 05 f8 ff ff       	jmp    c0102a58 <__alltraps>

c0103253 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103253:	6a 00                	push   $0x0
  pushl $200
c0103255:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010325a:	e9 f9 f7 ff ff       	jmp    c0102a58 <__alltraps>

c010325f <vector201>:
.globl vector201
vector201:
  pushl $0
c010325f:	6a 00                	push   $0x0
  pushl $201
c0103261:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0103266:	e9 ed f7 ff ff       	jmp    c0102a58 <__alltraps>

c010326b <vector202>:
.globl vector202
vector202:
  pushl $0
c010326b:	6a 00                	push   $0x0
  pushl $202
c010326d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103272:	e9 e1 f7 ff ff       	jmp    c0102a58 <__alltraps>

c0103277 <vector203>:
.globl vector203
vector203:
  pushl $0
c0103277:	6a 00                	push   $0x0
  pushl $203
c0103279:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010327e:	e9 d5 f7 ff ff       	jmp    c0102a58 <__alltraps>

c0103283 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103283:	6a 00                	push   $0x0
  pushl $204
c0103285:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010328a:	e9 c9 f7 ff ff       	jmp    c0102a58 <__alltraps>

c010328f <vector205>:
.globl vector205
vector205:
  pushl $0
c010328f:	6a 00                	push   $0x0
  pushl $205
c0103291:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0103296:	e9 bd f7 ff ff       	jmp    c0102a58 <__alltraps>

c010329b <vector206>:
.globl vector206
vector206:
  pushl $0
c010329b:	6a 00                	push   $0x0
  pushl $206
c010329d:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01032a2:	e9 b1 f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032a7 <vector207>:
.globl vector207
vector207:
  pushl $0
c01032a7:	6a 00                	push   $0x0
  pushl $207
c01032a9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01032ae:	e9 a5 f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032b3 <vector208>:
.globl vector208
vector208:
  pushl $0
c01032b3:	6a 00                	push   $0x0
  pushl $208
c01032b5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01032ba:	e9 99 f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032bf <vector209>:
.globl vector209
vector209:
  pushl $0
c01032bf:	6a 00                	push   $0x0
  pushl $209
c01032c1:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01032c6:	e9 8d f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032cb <vector210>:
.globl vector210
vector210:
  pushl $0
c01032cb:	6a 00                	push   $0x0
  pushl $210
c01032cd:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01032d2:	e9 81 f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032d7 <vector211>:
.globl vector211
vector211:
  pushl $0
c01032d7:	6a 00                	push   $0x0
  pushl $211
c01032d9:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01032de:	e9 75 f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032e3 <vector212>:
.globl vector212
vector212:
  pushl $0
c01032e3:	6a 00                	push   $0x0
  pushl $212
c01032e5:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01032ea:	e9 69 f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032ef <vector213>:
.globl vector213
vector213:
  pushl $0
c01032ef:	6a 00                	push   $0x0
  pushl $213
c01032f1:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01032f6:	e9 5d f7 ff ff       	jmp    c0102a58 <__alltraps>

c01032fb <vector214>:
.globl vector214
vector214:
  pushl $0
c01032fb:	6a 00                	push   $0x0
  pushl $214
c01032fd:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103302:	e9 51 f7 ff ff       	jmp    c0102a58 <__alltraps>

c0103307 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103307:	6a 00                	push   $0x0
  pushl $215
c0103309:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010330e:	e9 45 f7 ff ff       	jmp    c0102a58 <__alltraps>

c0103313 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103313:	6a 00                	push   $0x0
  pushl $216
c0103315:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010331a:	e9 39 f7 ff ff       	jmp    c0102a58 <__alltraps>

c010331f <vector217>:
.globl vector217
vector217:
  pushl $0
c010331f:	6a 00                	push   $0x0
  pushl $217
c0103321:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103326:	e9 2d f7 ff ff       	jmp    c0102a58 <__alltraps>

c010332b <vector218>:
.globl vector218
vector218:
  pushl $0
c010332b:	6a 00                	push   $0x0
  pushl $218
c010332d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103332:	e9 21 f7 ff ff       	jmp    c0102a58 <__alltraps>

c0103337 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103337:	6a 00                	push   $0x0
  pushl $219
c0103339:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010333e:	e9 15 f7 ff ff       	jmp    c0102a58 <__alltraps>

c0103343 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103343:	6a 00                	push   $0x0
  pushl $220
c0103345:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010334a:	e9 09 f7 ff ff       	jmp    c0102a58 <__alltraps>

c010334f <vector221>:
.globl vector221
vector221:
  pushl $0
c010334f:	6a 00                	push   $0x0
  pushl $221
c0103351:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103356:	e9 fd f6 ff ff       	jmp    c0102a58 <__alltraps>

c010335b <vector222>:
.globl vector222
vector222:
  pushl $0
c010335b:	6a 00                	push   $0x0
  pushl $222
c010335d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103362:	e9 f1 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103367 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103367:	6a 00                	push   $0x0
  pushl $223
c0103369:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010336e:	e9 e5 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103373 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103373:	6a 00                	push   $0x0
  pushl $224
c0103375:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010337a:	e9 d9 f6 ff ff       	jmp    c0102a58 <__alltraps>

c010337f <vector225>:
.globl vector225
vector225:
  pushl $0
c010337f:	6a 00                	push   $0x0
  pushl $225
c0103381:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103386:	e9 cd f6 ff ff       	jmp    c0102a58 <__alltraps>

c010338b <vector226>:
.globl vector226
vector226:
  pushl $0
c010338b:	6a 00                	push   $0x0
  pushl $226
c010338d:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103392:	e9 c1 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103397 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103397:	6a 00                	push   $0x0
  pushl $227
c0103399:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010339e:	e9 b5 f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033a3 <vector228>:
.globl vector228
vector228:
  pushl $0
c01033a3:	6a 00                	push   $0x0
  pushl $228
c01033a5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01033aa:	e9 a9 f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033af <vector229>:
.globl vector229
vector229:
  pushl $0
c01033af:	6a 00                	push   $0x0
  pushl $229
c01033b1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01033b6:	e9 9d f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033bb <vector230>:
.globl vector230
vector230:
  pushl $0
c01033bb:	6a 00                	push   $0x0
  pushl $230
c01033bd:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01033c2:	e9 91 f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033c7 <vector231>:
.globl vector231
vector231:
  pushl $0
c01033c7:	6a 00                	push   $0x0
  pushl $231
c01033c9:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01033ce:	e9 85 f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033d3 <vector232>:
.globl vector232
vector232:
  pushl $0
c01033d3:	6a 00                	push   $0x0
  pushl $232
c01033d5:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01033da:	e9 79 f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033df <vector233>:
.globl vector233
vector233:
  pushl $0
c01033df:	6a 00                	push   $0x0
  pushl $233
c01033e1:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01033e6:	e9 6d f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033eb <vector234>:
.globl vector234
vector234:
  pushl $0
c01033eb:	6a 00                	push   $0x0
  pushl $234
c01033ed:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01033f2:	e9 61 f6 ff ff       	jmp    c0102a58 <__alltraps>

c01033f7 <vector235>:
.globl vector235
vector235:
  pushl $0
c01033f7:	6a 00                	push   $0x0
  pushl $235
c01033f9:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01033fe:	e9 55 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103403 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103403:	6a 00                	push   $0x0
  pushl $236
c0103405:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010340a:	e9 49 f6 ff ff       	jmp    c0102a58 <__alltraps>

c010340f <vector237>:
.globl vector237
vector237:
  pushl $0
c010340f:	6a 00                	push   $0x0
  pushl $237
c0103411:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103416:	e9 3d f6 ff ff       	jmp    c0102a58 <__alltraps>

c010341b <vector238>:
.globl vector238
vector238:
  pushl $0
c010341b:	6a 00                	push   $0x0
  pushl $238
c010341d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103422:	e9 31 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103427 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103427:	6a 00                	push   $0x0
  pushl $239
c0103429:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010342e:	e9 25 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103433 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103433:	6a 00                	push   $0x0
  pushl $240
c0103435:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010343a:	e9 19 f6 ff ff       	jmp    c0102a58 <__alltraps>

c010343f <vector241>:
.globl vector241
vector241:
  pushl $0
c010343f:	6a 00                	push   $0x0
  pushl $241
c0103441:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103446:	e9 0d f6 ff ff       	jmp    c0102a58 <__alltraps>

c010344b <vector242>:
.globl vector242
vector242:
  pushl $0
c010344b:	6a 00                	push   $0x0
  pushl $242
c010344d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103452:	e9 01 f6 ff ff       	jmp    c0102a58 <__alltraps>

c0103457 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103457:	6a 00                	push   $0x0
  pushl $243
c0103459:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010345e:	e9 f5 f5 ff ff       	jmp    c0102a58 <__alltraps>

c0103463 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103463:	6a 00                	push   $0x0
  pushl $244
c0103465:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010346a:	e9 e9 f5 ff ff       	jmp    c0102a58 <__alltraps>

c010346f <vector245>:
.globl vector245
vector245:
  pushl $0
c010346f:	6a 00                	push   $0x0
  pushl $245
c0103471:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103476:	e9 dd f5 ff ff       	jmp    c0102a58 <__alltraps>

c010347b <vector246>:
.globl vector246
vector246:
  pushl $0
c010347b:	6a 00                	push   $0x0
  pushl $246
c010347d:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103482:	e9 d1 f5 ff ff       	jmp    c0102a58 <__alltraps>

c0103487 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103487:	6a 00                	push   $0x0
  pushl $247
c0103489:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010348e:	e9 c5 f5 ff ff       	jmp    c0102a58 <__alltraps>

c0103493 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103493:	6a 00                	push   $0x0
  pushl $248
c0103495:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010349a:	e9 b9 f5 ff ff       	jmp    c0102a58 <__alltraps>

c010349f <vector249>:
.globl vector249
vector249:
  pushl $0
c010349f:	6a 00                	push   $0x0
  pushl $249
c01034a1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01034a6:	e9 ad f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034ab <vector250>:
.globl vector250
vector250:
  pushl $0
c01034ab:	6a 00                	push   $0x0
  pushl $250
c01034ad:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01034b2:	e9 a1 f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034b7 <vector251>:
.globl vector251
vector251:
  pushl $0
c01034b7:	6a 00                	push   $0x0
  pushl $251
c01034b9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01034be:	e9 95 f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034c3 <vector252>:
.globl vector252
vector252:
  pushl $0
c01034c3:	6a 00                	push   $0x0
  pushl $252
c01034c5:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01034ca:	e9 89 f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034cf <vector253>:
.globl vector253
vector253:
  pushl $0
c01034cf:	6a 00                	push   $0x0
  pushl $253
c01034d1:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01034d6:	e9 7d f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034db <vector254>:
.globl vector254
vector254:
  pushl $0
c01034db:	6a 00                	push   $0x0
  pushl $254
c01034dd:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01034e2:	e9 71 f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034e7 <vector255>:
.globl vector255
vector255:
  pushl $0
c01034e7:	6a 00                	push   $0x0
  pushl $255
c01034e9:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01034ee:	e9 65 f5 ff ff       	jmp    c0102a58 <__alltraps>

c01034f3 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01034f3:	55                   	push   %ebp
c01034f4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01034f6:	8b 55 08             	mov    0x8(%ebp),%edx
c01034f9:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01034fe:	29 c2                	sub    %eax,%edx
c0103500:	89 d0                	mov    %edx,%eax
c0103502:	c1 f8 05             	sar    $0x5,%eax
}
c0103505:	5d                   	pop    %ebp
c0103506:	c3                   	ret    

c0103507 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103507:	55                   	push   %ebp
c0103508:	89 e5                	mov    %esp,%ebp
c010350a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010350d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103510:	89 04 24             	mov    %eax,(%esp)
c0103513:	e8 db ff ff ff       	call   c01034f3 <page2ppn>
c0103518:	c1 e0 0c             	shl    $0xc,%eax
}
c010351b:	c9                   	leave  
c010351c:	c3                   	ret    

c010351d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010351d:	55                   	push   %ebp
c010351e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103520:	8b 45 08             	mov    0x8(%ebp),%eax
c0103523:	8b 00                	mov    (%eax),%eax
}
c0103525:	5d                   	pop    %ebp
c0103526:	c3                   	ret    

c0103527 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103527:	55                   	push   %ebp
c0103528:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010352a:	8b 45 08             	mov    0x8(%ebp),%eax
c010352d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103530:	89 10                	mov    %edx,(%eax)
}
c0103532:	5d                   	pop    %ebp
c0103533:	c3                   	ret    

c0103534 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103534:	55                   	push   %ebp
c0103535:	89 e5                	mov    %esp,%ebp
c0103537:	83 ec 10             	sub    $0x10,%esp
c010353a:	c7 45 fc b8 ef 19 c0 	movl   $0xc019efb8,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103541:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103544:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103547:	89 50 04             	mov    %edx,0x4(%eax)
c010354a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010354d:	8b 50 04             	mov    0x4(%eax),%edx
c0103550:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103553:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103555:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c010355c:	00 00 00 
}
c010355f:	c9                   	leave  
c0103560:	c3                   	ret    

c0103561 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103561:	55                   	push   %ebp
c0103562:	89 e5                	mov    %esp,%ebp
c0103564:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103567:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010356b:	75 24                	jne    c0103591 <default_init_memmap+0x30>
c010356d:	c7 44 24 0c 70 c6 10 	movl   $0xc010c670,0xc(%esp)
c0103574:	c0 
c0103575:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c010357c:	c0 
c010357d:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103584:	00 
c0103585:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c010358c:	e8 44 d8 ff ff       	call   c0100dd5 <__panic>
    struct Page *p = base;
c0103591:	8b 45 08             	mov    0x8(%ebp),%eax
c0103594:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103597:	eb 7d                	jmp    c0103616 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103599:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359c:	83 c0 04             	add    $0x4,%eax
c010359f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01035a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01035af:	0f a3 10             	bt     %edx,(%eax)
c01035b2:	19 c0                	sbb    %eax,%eax
c01035b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01035b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01035bb:	0f 95 c0             	setne  %al
c01035be:	0f b6 c0             	movzbl %al,%eax
c01035c1:	85 c0                	test   %eax,%eax
c01035c3:	75 24                	jne    c01035e9 <default_init_memmap+0x88>
c01035c5:	c7 44 24 0c a1 c6 10 	movl   $0xc010c6a1,0xc(%esp)
c01035cc:	c0 
c01035cd:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01035d4:	c0 
c01035d5:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01035dc:	00 
c01035dd:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01035e4:	e8 ec d7 ff ff       	call   c0100dd5 <__panic>
        p->flags = p->property = 0;
c01035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01035f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f6:	8b 50 08             	mov    0x8(%eax),%edx
c01035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fc:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01035ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103606:	00 
c0103607:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010360a:	89 04 24             	mov    %eax,(%esp)
c010360d:	e8 15 ff ff ff       	call   c0103527 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103612:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103616:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103619:	c1 e0 05             	shl    $0x5,%eax
c010361c:	89 c2                	mov    %eax,%edx
c010361e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103621:	01 d0                	add    %edx,%eax
c0103623:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103626:	0f 85 6d ff ff ff    	jne    c0103599 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010362c:	8b 45 08             	mov    0x8(%ebp),%eax
c010362f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103632:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103635:	8b 45 08             	mov    0x8(%ebp),%eax
c0103638:	83 c0 04             	add    $0x4,%eax
c010363b:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103642:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103645:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103648:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010364b:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010364e:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103654:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103657:	01 d0                	add    %edx,%eax
c0103659:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
    list_add(&free_list, &(base->page_link));
c010365e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103661:	83 c0 0c             	add    $0xc,%eax
c0103664:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
c010366b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010366e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103671:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103674:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103677:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010367a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010367d:	8b 40 04             	mov    0x4(%eax),%eax
c0103680:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103683:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103686:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103689:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010368c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010368f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103692:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103695:	89 10                	mov    %edx,(%eax)
c0103697:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010369a:	8b 10                	mov    (%eax),%edx
c010369c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010369f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01036a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01036a5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01036a8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01036ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01036ae:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01036b1:	89 10                	mov    %edx,(%eax)
}
c01036b3:	c9                   	leave  
c01036b4:	c3                   	ret    

c01036b5 <default_alloc_pages>:
    return page;
}
*/

static struct Page *
default_alloc_pages(size_t n) {
c01036b5:	55                   	push   %ebp
c01036b6:	89 e5                	mov    %esp,%ebp
c01036b8:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01036bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01036bf:	75 24                	jne    c01036e5 <default_alloc_pages+0x30>
c01036c1:	c7 44 24 0c 70 c6 10 	movl   $0xc010c670,0xc(%esp)
c01036c8:	c0 
c01036c9:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01036d0:	c0 
c01036d1:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c01036d8:	00 
c01036d9:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01036e0:	e8 f0 d6 ff ff       	call   c0100dd5 <__panic>
    if (n > nr_free) {
c01036e5:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01036ea:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036ed:	73 0a                	jae    c01036f9 <default_alloc_pages+0x44>
        return NULL;
c01036ef:	b8 00 00 00 00       	mov    $0x0,%eax
c01036f4:	e9 36 01 00 00       	jmp    c010382f <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c01036f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103700:	c7 45 f0 b8 ef 19 c0 	movl   $0xc019efb8,-0x10(%ebp)
 
// Step1：找到第一个长度大于等于n的块
    while ((le = list_next(le)) != &free_list) {
c0103707:	eb 1c                	jmp    c0103725 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0103709:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010370c:	83 e8 0c             	sub    $0xc,%eax
c010370f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103712:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103715:	8b 40 08             	mov    0x8(%eax),%eax
c0103718:	3b 45 08             	cmp    0x8(%ebp),%eax
c010371b:	72 08                	jb     c0103725 <default_alloc_pages+0x70>
            page = p;
c010371d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103720:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103723:	eb 18                	jmp    c010373d <default_alloc_pages+0x88>
c0103725:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010372b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010372e:	8b 40 04             	mov    0x4(%eax),%eax
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
 
// Step1：找到第一个长度大于等于n的块
    while ((le = list_next(le)) != &free_list) {
c0103731:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103734:	81 7d f0 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x10(%ebp)
c010373b:	75 cc                	jne    c0103709 <default_alloc_pages+0x54>
    }
 
// Step2：如果可以找到长度大于等于n的块，则
// (1) 如果长度大于n，在从这个块中取走长度为n的存储空间，并将剩下的存储空间插入到列表中
// (2) 删除原来的块
    if (page != NULL) {
c010373d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103741:	0f 84 e5 00 00 00    	je     c010382c <default_alloc_pages+0x177>
        if (page->property > n) {
c0103747:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010374a:	8b 40 08             	mov    0x8(%eax),%eax
c010374d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103750:	0f 86 85 00 00 00    	jbe    c01037db <default_alloc_pages+0x126>
            struct Page *p = page + n;
c0103756:	8b 45 08             	mov    0x8(%ebp),%eax
c0103759:	c1 e0 05             	shl    $0x5,%eax
c010375c:	89 c2                	mov    %eax,%edx
c010375e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103761:	01 d0                	add    %edx,%eax
c0103763:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0103766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103769:	8b 40 08             	mov    0x8(%eax),%eax
c010376c:	2b 45 08             	sub    0x8(%ebp),%eax
c010376f:	89 c2                	mov    %eax,%edx
c0103771:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103774:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0103777:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010377a:	83 c0 04             	add    $0x4,%eax
c010377d:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103784:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103787:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010378a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010378d:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0103790:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103793:	83 c0 0c             	add    $0xc,%eax
c0103796:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103799:	83 c2 0c             	add    $0xc,%edx
c010379c:	89 55 d8             	mov    %edx,-0x28(%ebp)
c010379f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01037a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037a5:	8b 40 04             	mov    0x4(%eax),%eax
c01037a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01037ab:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01037ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01037b1:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01037b4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01037b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037ba:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01037bd:	89 10                	mov    %edx,(%eax)
c01037bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037c2:	8b 10                	mov    (%eax),%edx
c01037c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01037c7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01037ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01037cd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01037d0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01037d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01037d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01037d9:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037de:	83 c0 0c             	add    $0xc,%eax
c01037e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01037e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01037e7:	8b 40 04             	mov    0x4(%eax),%eax
c01037ea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01037ed:	8b 12                	mov    (%edx),%edx
c01037ef:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01037f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01037f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01037f8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01037fb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103801:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103804:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0103806:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010380b:	2b 45 08             	sub    0x8(%ebp),%eax
c010380e:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
        ClearPageProperty(page);
c0103813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103816:	83 c0 04             	add    $0x4,%eax
c0103819:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103820:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103823:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103826:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103829:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010382c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010382f:	c9                   	leave  
c0103830:	c3                   	ret    

c0103831 <default_free_pages>:
    nr_free += n;
    list_add(&free_list, &(base->page_link));
}*/

static void
default_free_pages(struct Page *base, size_t n) {
c0103831:	55                   	push   %ebp
c0103832:	89 e5                	mov    %esp,%ebp
c0103834:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010383a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010383e:	75 24                	jne    c0103864 <default_free_pages+0x33>
c0103840:	c7 44 24 0c 70 c6 10 	movl   $0xc010c670,0xc(%esp)
c0103847:	c0 
c0103848:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c010384f:	c0 
c0103850:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103857:	00 
c0103858:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c010385f:	e8 71 d5 ff ff       	call   c0100dd5 <__panic>
    struct Page *p = base;
c0103864:	8b 45 08             	mov    0x8(%ebp),%eax
c0103867:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
// 检查每个block中的各个page property是否合法
    for (; p != base + n; p ++) {
c010386a:	e9 9d 00 00 00       	jmp    c010390c <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c010386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103872:	83 c0 04             	add    $0x4,%eax
c0103875:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010387c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010387f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103882:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103885:	0f a3 10             	bt     %edx,(%eax)
c0103888:	19 c0                	sbb    %eax,%eax
c010388a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c010388d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103891:	0f 95 c0             	setne  %al
c0103894:	0f b6 c0             	movzbl %al,%eax
c0103897:	85 c0                	test   %eax,%eax
c0103899:	75 2c                	jne    c01038c7 <default_free_pages+0x96>
c010389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010389e:	83 c0 04             	add    $0x4,%eax
c01038a1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c01038a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01038ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01038b1:	0f a3 10             	bt     %edx,(%eax)
c01038b4:	19 c0                	sbb    %eax,%eax
c01038b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c01038b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01038bd:	0f 95 c0             	setne  %al
c01038c0:	0f b6 c0             	movzbl %al,%eax
c01038c3:	85 c0                	test   %eax,%eax
c01038c5:	74 24                	je     c01038eb <default_free_pages+0xba>
c01038c7:	c7 44 24 0c b4 c6 10 	movl   $0xc010c6b4,0xc(%esp)
c01038ce:	c0 
c01038cf:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01038d6:	c0 
c01038d7:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01038de:	00 
c01038df:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01038e6:	e8 ea d4 ff ff       	call   c0100dd5 <__panic>
        p->flags = 0;
c01038eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01038f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01038fc:	00 
c01038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103900:	89 04 24             	mov    %eax,(%esp)
c0103903:	e8 1f fc ff ff       	call   c0103527 <set_page_ref>
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
 
// 检查每个block中的各个page property是否合法
    for (; p != base + n; p ++) {
c0103908:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010390c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010390f:	c1 e0 05             	shl    $0x5,%eax
c0103912:	89 c2                	mov    %eax,%edx
c0103914:	8b 45 08             	mov    0x8(%ebp),%eax
c0103917:	01 d0                	add    %edx,%eax
c0103919:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010391c:	0f 85 4d ff ff ff    	jne    c010386f <default_free_pages+0x3e>
        p->flags = 0;
        set_page_ref(p, 0);
    }
 
// 设置好释放空间的长度和page property
    base->property = n;
c0103922:	8b 45 08             	mov    0x8(%ebp),%eax
c0103925:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103928:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010392b:	8b 45 08             	mov    0x8(%ebp),%eax
c010392e:	83 c0 04             	add    $0x4,%eax
c0103931:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103938:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010393b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010393e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103941:	0f ab 10             	bts    %edx,(%eax)
c0103944:	c7 45 c4 b8 ef 19 c0 	movl   $0xc019efb8,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010394b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010394e:	8b 40 04             	mov    0x4(%eax),%eax
 
// Step1：找到插入链表的位置（链表已按照地址从大到小排序）
    list_entry_t *le = list_next(&free_list);
c0103951:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *prev = &free_list;
c0103954:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while (le != &free_list) {
c010395b:	eb 28                	jmp    c0103985 <default_free_pages+0x154>
        p = le2page(le, page_link);
c010395d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103960:	83 e8 0c             	sub    $0xc,%eax
c0103963:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base < p) {
c0103966:	8b 45 08             	mov    0x8(%ebp),%eax
c0103969:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010396c:	73 02                	jae    c0103970 <default_free_pages+0x13f>
            break;
c010396e:	eb 1e                	jmp    c010398e <default_free_pages+0x15d>
        }
        prev = le;
c0103970:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103973:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103976:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103979:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010397c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010397f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103982:	89 45 f0             	mov    %eax,-0x10(%ebp)
    SetPageProperty(base);
 
// Step1：找到插入链表的位置（链表已按照地址从大到小排序）
    list_entry_t *le = list_next(&free_list);
    list_entry_t *prev = &free_list;
    while (le != &free_list) {
c0103985:	81 7d f0 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x10(%ebp)
c010398c:	75 cf                	jne    c010395d <default_free_pages+0x12c>
        prev = le;
        le = list_next(le);
    }
 
// Step2：检查是否可以和链表的前一项中的空间合并
    p = le2page(prev, page_link);
c010398e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103991:	83 e8 0c             	sub    $0xc,%eax
c0103994:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (prev != &free_list && p + p -> property == base) {
c0103997:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c010399e:	74 44                	je     c01039e4 <default_free_pages+0x1b3>
c01039a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a3:	8b 40 08             	mov    0x8(%eax),%eax
c01039a6:	c1 e0 05             	shl    $0x5,%eax
c01039a9:	89 c2                	mov    %eax,%edx
c01039ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ae:	01 d0                	add    %edx,%eax
c01039b0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01039b3:	75 2f                	jne    c01039e4 <default_free_pages+0x1b3>
        p -> property += base -> property;
c01039b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b8:	8b 50 08             	mov    0x8(%eax),%edx
c01039bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01039be:	8b 40 08             	mov    0x8(%eax),%eax
c01039c1:	01 c2                	add    %eax,%edx
c01039c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c6:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(base);
c01039c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cc:	83 c0 04             	add    $0x4,%eax
c01039cf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01039d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01039d9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01039dc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01039df:	0f b3 10             	btr    %edx,(%eax)
c01039e2:	eb 4e                	jmp    c0103a32 <default_free_pages+0x201>
    } else {
        list_add_after(prev, &(base -> page_link));
c01039e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e7:	8d 50 0c             	lea    0xc(%eax),%edx
c01039ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039ed:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01039f0:	89 55 b0             	mov    %edx,-0x50(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01039f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01039f6:	8b 40 04             	mov    0x4(%eax),%eax
c01039f9:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01039fc:	89 55 ac             	mov    %edx,-0x54(%ebp)
c01039ff:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103a02:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0103a05:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103a08:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103a0b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103a0e:	89 10                	mov    %edx,(%eax)
c0103a10:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103a13:	8b 10                	mov    (%eax),%edx
c0103a15:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103a18:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103a1b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103a1e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103a21:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103a24:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103a27:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103a2a:	89 10                	mov    %edx,(%eax)
        p = base;
c0103a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
 
// Step3：检查是否可以和链表的后一项中的空间合并
    struct Page *nextp = le2page(le, page_link);
c0103a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a35:	83 e8 0c             	sub    $0xc,%eax
c0103a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (le != &free_list && p + p -> property == nextp) {
c0103a3b:	81 7d f0 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x10(%ebp)
c0103a42:	74 6a                	je     c0103aae <default_free_pages+0x27d>
c0103a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a47:	8b 40 08             	mov    0x8(%eax),%eax
c0103a4a:	c1 e0 05             	shl    $0x5,%eax
c0103a4d:	89 c2                	mov    %eax,%edx
c0103a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a52:	01 d0                	add    %edx,%eax
c0103a54:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103a57:	75 55                	jne    c0103aae <default_free_pages+0x27d>
        p -> property += nextp -> property;
c0103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5c:	8b 50 08             	mov    0x8(%eax),%edx
c0103a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a62:	8b 40 08             	mov    0x8(%eax),%eax
c0103a65:	01 c2                	add    %eax,%edx
c0103a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6a:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(nextp);
c0103a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a70:	83 c0 04             	add    $0x4,%eax
c0103a73:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103a7a:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0103a7d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103a80:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103a83:	0f b3 10             	btr    %edx,(%eax)
c0103a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a89:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103a8c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103a8f:	8b 40 04             	mov    0x4(%eax),%eax
c0103a92:	8b 55 98             	mov    -0x68(%ebp),%edx
c0103a95:	8b 12                	mov    (%edx),%edx
c0103a97:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0103a9a:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103a9d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103aa0:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103aa3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103aa6:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103aa9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103aac:	89 10                	mov    %edx,(%eax)
        list_del(le);
    }
 
    nr_free += n;
c0103aae:	8b 15 c0 ef 19 c0    	mov    0xc019efc0,%edx
c0103ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ab7:	01 d0                	add    %edx,%eax
c0103ab9:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
}
c0103abe:	c9                   	leave  
c0103abf:	c3                   	ret    

c0103ac0 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103ac0:	55                   	push   %ebp
c0103ac1:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103ac3:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
}
c0103ac8:	5d                   	pop    %ebp
c0103ac9:	c3                   	ret    

c0103aca <basic_check>:

static void
basic_check(void) {
c0103aca:	55                   	push   %ebp
c0103acb:	89 e5                	mov    %esp,%ebp
c0103acd:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103ad0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103add:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ae0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aea:	e8 dc 15 00 00       	call   c01050cb <alloc_pages>
c0103aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103af2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103af6:	75 24                	jne    c0103b1c <basic_check+0x52>
c0103af8:	c7 44 24 0c d9 c6 10 	movl   $0xc010c6d9,0xc(%esp)
c0103aff:	c0 
c0103b00:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103b07:	c0 
c0103b08:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103b0f:	00 
c0103b10:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103b17:	e8 b9 d2 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b23:	e8 a3 15 00 00       	call   c01050cb <alloc_pages>
c0103b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b2f:	75 24                	jne    c0103b55 <basic_check+0x8b>
c0103b31:	c7 44 24 0c f5 c6 10 	movl   $0xc010c6f5,0xc(%esp)
c0103b38:	c0 
c0103b39:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103b40:	c0 
c0103b41:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103b48:	00 
c0103b49:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103b50:	e8 80 d2 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b5c:	e8 6a 15 00 00       	call   c01050cb <alloc_pages>
c0103b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b68:	75 24                	jne    c0103b8e <basic_check+0xc4>
c0103b6a:	c7 44 24 0c 11 c7 10 	movl   $0xc010c711,0xc(%esp)
c0103b71:	c0 
c0103b72:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103b79:	c0 
c0103b7a:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103b81:	00 
c0103b82:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103b89:	e8 47 d2 ff ff       	call   c0100dd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b91:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103b94:	74 10                	je     c0103ba6 <basic_check+0xdc>
c0103b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b99:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103b9c:	74 08                	je     c0103ba6 <basic_check+0xdc>
c0103b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ba1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103ba4:	75 24                	jne    c0103bca <basic_check+0x100>
c0103ba6:	c7 44 24 0c 30 c7 10 	movl   $0xc010c730,0xc(%esp)
c0103bad:	c0 
c0103bae:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103bb5:	c0 
c0103bb6:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103bbd:	00 
c0103bbe:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103bc5:	e8 0b d2 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bcd:	89 04 24             	mov    %eax,(%esp)
c0103bd0:	e8 48 f9 ff ff       	call   c010351d <page_ref>
c0103bd5:	85 c0                	test   %eax,%eax
c0103bd7:	75 1e                	jne    c0103bf7 <basic_check+0x12d>
c0103bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bdc:	89 04 24             	mov    %eax,(%esp)
c0103bdf:	e8 39 f9 ff ff       	call   c010351d <page_ref>
c0103be4:	85 c0                	test   %eax,%eax
c0103be6:	75 0f                	jne    c0103bf7 <basic_check+0x12d>
c0103be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103beb:	89 04 24             	mov    %eax,(%esp)
c0103bee:	e8 2a f9 ff ff       	call   c010351d <page_ref>
c0103bf3:	85 c0                	test   %eax,%eax
c0103bf5:	74 24                	je     c0103c1b <basic_check+0x151>
c0103bf7:	c7 44 24 0c 54 c7 10 	movl   $0xc010c754,0xc(%esp)
c0103bfe:	c0 
c0103bff:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103c06:	c0 
c0103c07:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103c0e:	00 
c0103c0f:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103c16:	e8 ba d1 ff ff       	call   c0100dd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c1e:	89 04 24             	mov    %eax,(%esp)
c0103c21:	e8 e1 f8 ff ff       	call   c0103507 <page2pa>
c0103c26:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103c2c:	c1 e2 0c             	shl    $0xc,%edx
c0103c2f:	39 d0                	cmp    %edx,%eax
c0103c31:	72 24                	jb     c0103c57 <basic_check+0x18d>
c0103c33:	c7 44 24 0c 90 c7 10 	movl   $0xc010c790,0xc(%esp)
c0103c3a:	c0 
c0103c3b:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103c42:	c0 
c0103c43:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103c4a:	00 
c0103c4b:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103c52:	e8 7e d1 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c5a:	89 04 24             	mov    %eax,(%esp)
c0103c5d:	e8 a5 f8 ff ff       	call   c0103507 <page2pa>
c0103c62:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103c68:	c1 e2 0c             	shl    $0xc,%edx
c0103c6b:	39 d0                	cmp    %edx,%eax
c0103c6d:	72 24                	jb     c0103c93 <basic_check+0x1c9>
c0103c6f:	c7 44 24 0c ad c7 10 	movl   $0xc010c7ad,0xc(%esp)
c0103c76:	c0 
c0103c77:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103c7e:	c0 
c0103c7f:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103c86:	00 
c0103c87:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103c8e:	e8 42 d1 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c96:	89 04 24             	mov    %eax,(%esp)
c0103c99:	e8 69 f8 ff ff       	call   c0103507 <page2pa>
c0103c9e:	8b 15 e0 ce 19 c0    	mov    0xc019cee0,%edx
c0103ca4:	c1 e2 0c             	shl    $0xc,%edx
c0103ca7:	39 d0                	cmp    %edx,%eax
c0103ca9:	72 24                	jb     c0103ccf <basic_check+0x205>
c0103cab:	c7 44 24 0c ca c7 10 	movl   $0xc010c7ca,0xc(%esp)
c0103cb2:	c0 
c0103cb3:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103cba:	c0 
c0103cbb:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0103cc2:	00 
c0103cc3:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103cca:	e8 06 d1 ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103ccf:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c0103cd4:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0103cda:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103cdd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103ce0:	c7 45 e0 b8 ef 19 c0 	movl   $0xc019efb8,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ce7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ced:	89 50 04             	mov    %edx,0x4(%eax)
c0103cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cf3:	8b 50 04             	mov    0x4(%eax),%edx
c0103cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cf9:	89 10                	mov    %edx,(%eax)
c0103cfb:	c7 45 dc b8 ef 19 c0 	movl   $0xc019efb8,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103d02:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d05:	8b 40 04             	mov    0x4(%eax),%eax
c0103d08:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d0b:	0f 94 c0             	sete   %al
c0103d0e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103d11:	85 c0                	test   %eax,%eax
c0103d13:	75 24                	jne    c0103d39 <basic_check+0x26f>
c0103d15:	c7 44 24 0c e7 c7 10 	movl   $0xc010c7e7,0xc(%esp)
c0103d1c:	c0 
c0103d1d:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103d24:	c0 
c0103d25:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103d2c:	00 
c0103d2d:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103d34:	e8 9c d0 ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103d39:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103d3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103d41:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0103d48:	00 00 00 

    assert(alloc_page() == NULL);
c0103d4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d52:	e8 74 13 00 00       	call   c01050cb <alloc_pages>
c0103d57:	85 c0                	test   %eax,%eax
c0103d59:	74 24                	je     c0103d7f <basic_check+0x2b5>
c0103d5b:	c7 44 24 0c fe c7 10 	movl   $0xc010c7fe,0xc(%esp)
c0103d62:	c0 
c0103d63:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103d6a:	c0 
c0103d6b:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103d72:	00 
c0103d73:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103d7a:	e8 56 d0 ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103d7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d86:	00 
c0103d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d8a:	89 04 24             	mov    %eax,(%esp)
c0103d8d:	e8 a4 13 00 00       	call   c0105136 <free_pages>
    free_page(p1);
c0103d92:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d99:	00 
c0103d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d9d:	89 04 24             	mov    %eax,(%esp)
c0103da0:	e8 91 13 00 00       	call   c0105136 <free_pages>
    free_page(p2);
c0103da5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dac:	00 
c0103dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103db0:	89 04 24             	mov    %eax,(%esp)
c0103db3:	e8 7e 13 00 00       	call   c0105136 <free_pages>
    assert(nr_free == 3);
c0103db8:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103dbd:	83 f8 03             	cmp    $0x3,%eax
c0103dc0:	74 24                	je     c0103de6 <basic_check+0x31c>
c0103dc2:	c7 44 24 0c 13 c8 10 	movl   $0xc010c813,0xc(%esp)
c0103dc9:	c0 
c0103dca:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103dd1:	c0 
c0103dd2:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103dd9:	00 
c0103dda:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103de1:	e8 ef cf ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103de6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ded:	e8 d9 12 00 00       	call   c01050cb <alloc_pages>
c0103df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103df5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103df9:	75 24                	jne    c0103e1f <basic_check+0x355>
c0103dfb:	c7 44 24 0c d9 c6 10 	movl   $0xc010c6d9,0xc(%esp)
c0103e02:	c0 
c0103e03:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103e0a:	c0 
c0103e0b:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0103e12:	00 
c0103e13:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103e1a:	e8 b6 cf ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103e1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e26:	e8 a0 12 00 00       	call   c01050cb <alloc_pages>
c0103e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103e32:	75 24                	jne    c0103e58 <basic_check+0x38e>
c0103e34:	c7 44 24 0c f5 c6 10 	movl   $0xc010c6f5,0xc(%esp)
c0103e3b:	c0 
c0103e3c:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103e43:	c0 
c0103e44:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103e4b:	00 
c0103e4c:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103e53:	e8 7d cf ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103e58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e5f:	e8 67 12 00 00       	call   c01050cb <alloc_pages>
c0103e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103e6b:	75 24                	jne    c0103e91 <basic_check+0x3c7>
c0103e6d:	c7 44 24 0c 11 c7 10 	movl   $0xc010c711,0xc(%esp)
c0103e74:	c0 
c0103e75:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103e7c:	c0 
c0103e7d:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103e84:	00 
c0103e85:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103e8c:	e8 44 cf ff ff       	call   c0100dd5 <__panic>

    assert(alloc_page() == NULL);
c0103e91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e98:	e8 2e 12 00 00       	call   c01050cb <alloc_pages>
c0103e9d:	85 c0                	test   %eax,%eax
c0103e9f:	74 24                	je     c0103ec5 <basic_check+0x3fb>
c0103ea1:	c7 44 24 0c fe c7 10 	movl   $0xc010c7fe,0xc(%esp)
c0103ea8:	c0 
c0103ea9:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103eb0:	c0 
c0103eb1:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103eb8:	00 
c0103eb9:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103ec0:	e8 10 cf ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103ec5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ecc:	00 
c0103ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ed0:	89 04 24             	mov    %eax,(%esp)
c0103ed3:	e8 5e 12 00 00       	call   c0105136 <free_pages>
c0103ed8:	c7 45 d8 b8 ef 19 c0 	movl   $0xc019efb8,-0x28(%ebp)
c0103edf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ee2:	8b 40 04             	mov    0x4(%eax),%eax
c0103ee5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103ee8:	0f 94 c0             	sete   %al
c0103eeb:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103eee:	85 c0                	test   %eax,%eax
c0103ef0:	74 24                	je     c0103f16 <basic_check+0x44c>
c0103ef2:	c7 44 24 0c 20 c8 10 	movl   $0xc010c820,0xc(%esp)
c0103ef9:	c0 
c0103efa:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103f01:	c0 
c0103f02:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103f09:	00 
c0103f0a:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103f11:	e8 bf ce ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103f16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f1d:	e8 a9 11 00 00       	call   c01050cb <alloc_pages>
c0103f22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103f2b:	74 24                	je     c0103f51 <basic_check+0x487>
c0103f2d:	c7 44 24 0c 38 c8 10 	movl   $0xc010c838,0xc(%esp)
c0103f34:	c0 
c0103f35:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103f3c:	c0 
c0103f3d:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0103f44:	00 
c0103f45:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103f4c:	e8 84 ce ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0103f51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f58:	e8 6e 11 00 00       	call   c01050cb <alloc_pages>
c0103f5d:	85 c0                	test   %eax,%eax
c0103f5f:	74 24                	je     c0103f85 <basic_check+0x4bb>
c0103f61:	c7 44 24 0c fe c7 10 	movl   $0xc010c7fe,0xc(%esp)
c0103f68:	c0 
c0103f69:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103f70:	c0 
c0103f71:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103f78:	00 
c0103f79:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103f80:	e8 50 ce ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c0103f85:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0103f8a:	85 c0                	test   %eax,%eax
c0103f8c:	74 24                	je     c0103fb2 <basic_check+0x4e8>
c0103f8e:	c7 44 24 0c 51 c8 10 	movl   $0xc010c851,0xc(%esp)
c0103f95:	c0 
c0103f96:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0103f9d:	c0 
c0103f9e:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103fa5:	00 
c0103fa6:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0103fad:	e8 23 ce ff ff       	call   c0100dd5 <__panic>
    free_list = free_list_store;
c0103fb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fb5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fb8:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c0103fbd:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    nr_free = nr_free_store;
c0103fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fc6:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_page(p);
c0103fcb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fd2:	00 
c0103fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd6:	89 04 24             	mov    %eax,(%esp)
c0103fd9:	e8 58 11 00 00       	call   c0105136 <free_pages>
    free_page(p1);
c0103fde:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fe5:	00 
c0103fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fe9:	89 04 24             	mov    %eax,(%esp)
c0103fec:	e8 45 11 00 00       	call   c0105136 <free_pages>
    free_page(p2);
c0103ff1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ff8:	00 
c0103ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ffc:	89 04 24             	mov    %eax,(%esp)
c0103fff:	e8 32 11 00 00       	call   c0105136 <free_pages>
}
c0104004:	c9                   	leave  
c0104005:	c3                   	ret    

c0104006 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104006:	55                   	push   %ebp
c0104007:	89 e5                	mov    %esp,%ebp
c0104009:	53                   	push   %ebx
c010400a:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0104010:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104017:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010401e:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104025:	eb 6b                	jmp    c0104092 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0104027:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010402a:	83 e8 0c             	sub    $0xc,%eax
c010402d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0104030:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104033:	83 c0 04             	add    $0x4,%eax
c0104036:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010403d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104040:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104043:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104046:	0f a3 10             	bt     %edx,(%eax)
c0104049:	19 c0                	sbb    %eax,%eax
c010404b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010404e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104052:	0f 95 c0             	setne  %al
c0104055:	0f b6 c0             	movzbl %al,%eax
c0104058:	85 c0                	test   %eax,%eax
c010405a:	75 24                	jne    c0104080 <default_check+0x7a>
c010405c:	c7 44 24 0c 5e c8 10 	movl   $0xc010c85e,0xc(%esp)
c0104063:	c0 
c0104064:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c010406b:	c0 
c010406c:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c0104073:	00 
c0104074:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c010407b:	e8 55 cd ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c0104080:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104084:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104087:	8b 50 08             	mov    0x8(%eax),%edx
c010408a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010408d:	01 d0                	add    %edx,%eax
c010408f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104092:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104095:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104098:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010409b:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010409e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01040a1:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c01040a8:	0f 85 79 ff ff ff    	jne    c0104027 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01040ae:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01040b1:	e8 b2 10 00 00       	call   c0105168 <nr_free_pages>
c01040b6:	39 c3                	cmp    %eax,%ebx
c01040b8:	74 24                	je     c01040de <default_check+0xd8>
c01040ba:	c7 44 24 0c 6e c8 10 	movl   $0xc010c86e,0xc(%esp)
c01040c1:	c0 
c01040c2:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01040c9:	c0 
c01040ca:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01040d1:	00 
c01040d2:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01040d9:	e8 f7 cc ff ff       	call   c0100dd5 <__panic>

    basic_check();
c01040de:	e8 e7 f9 ff ff       	call   c0103aca <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01040e3:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01040ea:	e8 dc 0f 00 00       	call   c01050cb <alloc_pages>
c01040ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01040f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040f6:	75 24                	jne    c010411c <default_check+0x116>
c01040f8:	c7 44 24 0c 87 c8 10 	movl   $0xc010c887,0xc(%esp)
c01040ff:	c0 
c0104100:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104107:	c0 
c0104108:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c010410f:	00 
c0104110:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104117:	e8 b9 cc ff ff       	call   c0100dd5 <__panic>
    assert(!PageProperty(p0));
c010411c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010411f:	83 c0 04             	add    $0x4,%eax
c0104122:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104129:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010412c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010412f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104132:	0f a3 10             	bt     %edx,(%eax)
c0104135:	19 c0                	sbb    %eax,%eax
c0104137:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010413a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010413e:	0f 95 c0             	setne  %al
c0104141:	0f b6 c0             	movzbl %al,%eax
c0104144:	85 c0                	test   %eax,%eax
c0104146:	74 24                	je     c010416c <default_check+0x166>
c0104148:	c7 44 24 0c 92 c8 10 	movl   $0xc010c892,0xc(%esp)
c010414f:	c0 
c0104150:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104157:	c0 
c0104158:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c010415f:	00 
c0104160:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104167:	e8 69 cc ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c010416c:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c0104171:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0104177:	89 45 80             	mov    %eax,-0x80(%ebp)
c010417a:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010417d:	c7 45 b4 b8 ef 19 c0 	movl   $0xc019efb8,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104184:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104187:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010418a:	89 50 04             	mov    %edx,0x4(%eax)
c010418d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104190:	8b 50 04             	mov    0x4(%eax),%edx
c0104193:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104196:	89 10                	mov    %edx,(%eax)
c0104198:	c7 45 b0 b8 ef 19 c0 	movl   $0xc019efb8,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010419f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01041a2:	8b 40 04             	mov    0x4(%eax),%eax
c01041a5:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01041a8:	0f 94 c0             	sete   %al
c01041ab:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01041ae:	85 c0                	test   %eax,%eax
c01041b0:	75 24                	jne    c01041d6 <default_check+0x1d0>
c01041b2:	c7 44 24 0c e7 c7 10 	movl   $0xc010c7e7,0xc(%esp)
c01041b9:	c0 
c01041ba:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01041c1:	c0 
c01041c2:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01041c9:	00 
c01041ca:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01041d1:	e8 ff cb ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c01041d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041dd:	e8 e9 0e 00 00       	call   c01050cb <alloc_pages>
c01041e2:	85 c0                	test   %eax,%eax
c01041e4:	74 24                	je     c010420a <default_check+0x204>
c01041e6:	c7 44 24 0c fe c7 10 	movl   $0xc010c7fe,0xc(%esp)
c01041ed:	c0 
c01041ee:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01041f5:	c0 
c01041f6:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01041fd:	00 
c01041fe:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104205:	e8 cb cb ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c010420a:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010420f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104212:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c0104219:	00 00 00 

    free_pages(p0 + 2, 3);
c010421c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010421f:	83 c0 40             	add    $0x40,%eax
c0104222:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104229:	00 
c010422a:	89 04 24             	mov    %eax,(%esp)
c010422d:	e8 04 0f 00 00       	call   c0105136 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104232:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104239:	e8 8d 0e 00 00       	call   c01050cb <alloc_pages>
c010423e:	85 c0                	test   %eax,%eax
c0104240:	74 24                	je     c0104266 <default_check+0x260>
c0104242:	c7 44 24 0c a4 c8 10 	movl   $0xc010c8a4,0xc(%esp)
c0104249:	c0 
c010424a:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104251:	c0 
c0104252:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0104259:	00 
c010425a:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104261:	e8 6f cb ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104269:	83 c0 40             	add    $0x40,%eax
c010426c:	83 c0 04             	add    $0x4,%eax
c010426f:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104276:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104279:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010427c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010427f:	0f a3 10             	bt     %edx,(%eax)
c0104282:	19 c0                	sbb    %eax,%eax
c0104284:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104287:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010428b:	0f 95 c0             	setne  %al
c010428e:	0f b6 c0             	movzbl %al,%eax
c0104291:	85 c0                	test   %eax,%eax
c0104293:	74 0e                	je     c01042a3 <default_check+0x29d>
c0104295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104298:	83 c0 40             	add    $0x40,%eax
c010429b:	8b 40 08             	mov    0x8(%eax),%eax
c010429e:	83 f8 03             	cmp    $0x3,%eax
c01042a1:	74 24                	je     c01042c7 <default_check+0x2c1>
c01042a3:	c7 44 24 0c bc c8 10 	movl   $0xc010c8bc,0xc(%esp)
c01042aa:	c0 
c01042ab:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01042b2:	c0 
c01042b3:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c01042ba:	00 
c01042bb:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01042c2:	e8 0e cb ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01042c7:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01042ce:	e8 f8 0d 00 00       	call   c01050cb <alloc_pages>
c01042d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01042d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01042da:	75 24                	jne    c0104300 <default_check+0x2fa>
c01042dc:	c7 44 24 0c e8 c8 10 	movl   $0xc010c8e8,0xc(%esp)
c01042e3:	c0 
c01042e4:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01042eb:	c0 
c01042ec:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01042f3:	00 
c01042f4:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01042fb:	e8 d5 ca ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0104300:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104307:	e8 bf 0d 00 00       	call   c01050cb <alloc_pages>
c010430c:	85 c0                	test   %eax,%eax
c010430e:	74 24                	je     c0104334 <default_check+0x32e>
c0104310:	c7 44 24 0c fe c7 10 	movl   $0xc010c7fe,0xc(%esp)
c0104317:	c0 
c0104318:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c010431f:	c0 
c0104320:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c0104327:	00 
c0104328:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c010432f:	e8 a1 ca ff ff       	call   c0100dd5 <__panic>
    assert(p0 + 2 == p1);
c0104334:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104337:	83 c0 40             	add    $0x40,%eax
c010433a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010433d:	74 24                	je     c0104363 <default_check+0x35d>
c010433f:	c7 44 24 0c 06 c9 10 	movl   $0xc010c906,0xc(%esp)
c0104346:	c0 
c0104347:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c010434e:	c0 
c010434f:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104356:	00 
c0104357:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c010435e:	e8 72 ca ff ff       	call   c0100dd5 <__panic>

    p2 = p0 + 1;
c0104363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104366:	83 c0 20             	add    $0x20,%eax
c0104369:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010436c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104373:	00 
c0104374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104377:	89 04 24             	mov    %eax,(%esp)
c010437a:	e8 b7 0d 00 00       	call   c0105136 <free_pages>
    free_pages(p1, 3);
c010437f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104386:	00 
c0104387:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010438a:	89 04 24             	mov    %eax,(%esp)
c010438d:	e8 a4 0d 00 00       	call   c0105136 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104395:	83 c0 04             	add    $0x4,%eax
c0104398:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010439f:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043a2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01043a5:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01043a8:	0f a3 10             	bt     %edx,(%eax)
c01043ab:	19 c0                	sbb    %eax,%eax
c01043ad:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01043b0:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01043b4:	0f 95 c0             	setne  %al
c01043b7:	0f b6 c0             	movzbl %al,%eax
c01043ba:	85 c0                	test   %eax,%eax
c01043bc:	74 0b                	je     c01043c9 <default_check+0x3c3>
c01043be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043c1:	8b 40 08             	mov    0x8(%eax),%eax
c01043c4:	83 f8 01             	cmp    $0x1,%eax
c01043c7:	74 24                	je     c01043ed <default_check+0x3e7>
c01043c9:	c7 44 24 0c 14 c9 10 	movl   $0xc010c914,0xc(%esp)
c01043d0:	c0 
c01043d1:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01043d8:	c0 
c01043d9:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c01043e0:	00 
c01043e1:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01043e8:	e8 e8 c9 ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01043ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043f0:	83 c0 04             	add    $0x4,%eax
c01043f3:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01043fa:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043fd:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104400:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104403:	0f a3 10             	bt     %edx,(%eax)
c0104406:	19 c0                	sbb    %eax,%eax
c0104408:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010440b:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010440f:	0f 95 c0             	setne  %al
c0104412:	0f b6 c0             	movzbl %al,%eax
c0104415:	85 c0                	test   %eax,%eax
c0104417:	74 0b                	je     c0104424 <default_check+0x41e>
c0104419:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010441c:	8b 40 08             	mov    0x8(%eax),%eax
c010441f:	83 f8 03             	cmp    $0x3,%eax
c0104422:	74 24                	je     c0104448 <default_check+0x442>
c0104424:	c7 44 24 0c 3c c9 10 	movl   $0xc010c93c,0xc(%esp)
c010442b:	c0 
c010442c:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104433:	c0 
c0104434:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
c010443b:	00 
c010443c:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104443:	e8 8d c9 ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104448:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010444f:	e8 77 0c 00 00       	call   c01050cb <alloc_pages>
c0104454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104457:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010445a:	83 e8 20             	sub    $0x20,%eax
c010445d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104460:	74 24                	je     c0104486 <default_check+0x480>
c0104462:	c7 44 24 0c 62 c9 10 	movl   $0xc010c962,0xc(%esp)
c0104469:	c0 
c010446a:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104471:	c0 
c0104472:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104479:	00 
c010447a:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104481:	e8 4f c9 ff ff       	call   c0100dd5 <__panic>
    free_page(p0);
c0104486:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010448d:	00 
c010448e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104491:	89 04 24             	mov    %eax,(%esp)
c0104494:	e8 9d 0c 00 00       	call   c0105136 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104499:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01044a0:	e8 26 0c 00 00       	call   c01050cb <alloc_pages>
c01044a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044ab:	83 c0 20             	add    $0x20,%eax
c01044ae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044b1:	74 24                	je     c01044d7 <default_check+0x4d1>
c01044b3:	c7 44 24 0c 80 c9 10 	movl   $0xc010c980,0xc(%esp)
c01044ba:	c0 
c01044bb:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c01044c2:	c0 
c01044c3:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c01044ca:	00 
c01044cb:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c01044d2:	e8 fe c8 ff ff       	call   c0100dd5 <__panic>

    free_pages(p0, 2);
c01044d7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01044de:	00 
c01044df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044e2:	89 04 24             	mov    %eax,(%esp)
c01044e5:	e8 4c 0c 00 00       	call   c0105136 <free_pages>
    free_page(p2);
c01044ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044f1:	00 
c01044f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044f5:	89 04 24             	mov    %eax,(%esp)
c01044f8:	e8 39 0c 00 00       	call   c0105136 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01044fd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104504:	e8 c2 0b 00 00       	call   c01050cb <alloc_pages>
c0104509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010450c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104510:	75 24                	jne    c0104536 <default_check+0x530>
c0104512:	c7 44 24 0c a0 c9 10 	movl   $0xc010c9a0,0xc(%esp)
c0104519:	c0 
c010451a:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104521:	c0 
c0104522:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c0104529:	00 
c010452a:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104531:	e8 9f c8 ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0104536:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010453d:	e8 89 0b 00 00       	call   c01050cb <alloc_pages>
c0104542:	85 c0                	test   %eax,%eax
c0104544:	74 24                	je     c010456a <default_check+0x564>
c0104546:	c7 44 24 0c fe c7 10 	movl   $0xc010c7fe,0xc(%esp)
c010454d:	c0 
c010454e:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104555:	c0 
c0104556:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
c010455d:	00 
c010455e:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104565:	e8 6b c8 ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c010456a:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c010456f:	85 c0                	test   %eax,%eax
c0104571:	74 24                	je     c0104597 <default_check+0x591>
c0104573:	c7 44 24 0c 51 c8 10 	movl   $0xc010c851,0xc(%esp)
c010457a:	c0 
c010457b:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104582:	c0 
c0104583:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c010458a:	00 
c010458b:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104592:	e8 3e c8 ff ff       	call   c0100dd5 <__panic>
    nr_free = nr_free_store;
c0104597:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010459a:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0

    free_list = free_list_store;
c010459f:	8b 45 80             	mov    -0x80(%ebp),%eax
c01045a2:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01045a5:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c01045aa:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc
    free_pages(p0, 5);
c01045b0:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01045b7:	00 
c01045b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045bb:	89 04 24             	mov    %eax,(%esp)
c01045be:	e8 73 0b 00 00       	call   c0105136 <free_pages>

    le = &free_list;
c01045c3:	c7 45 ec b8 ef 19 c0 	movl   $0xc019efb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01045ca:	eb 1d                	jmp    c01045e9 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01045cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045cf:	83 e8 0c             	sub    $0xc,%eax
c01045d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01045d5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01045d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01045df:	8b 40 08             	mov    0x8(%eax),%eax
c01045e2:	29 c2                	sub    %eax,%edx
c01045e4:	89 d0                	mov    %edx,%eax
c01045e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045ec:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01045ef:	8b 45 88             	mov    -0x78(%ebp),%eax
c01045f2:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01045f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01045f8:	81 7d ec b8 ef 19 c0 	cmpl   $0xc019efb8,-0x14(%ebp)
c01045ff:	75 cb                	jne    c01045cc <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104605:	74 24                	je     c010462b <default_check+0x625>
c0104607:	c7 44 24 0c be c9 10 	movl   $0xc010c9be,0xc(%esp)
c010460e:	c0 
c010460f:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104616:	c0 
c0104617:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c010461e:	00 
c010461f:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104626:	e8 aa c7 ff ff       	call   c0100dd5 <__panic>
    assert(total == 0);
c010462b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010462f:	74 24                	je     c0104655 <default_check+0x64f>
c0104631:	c7 44 24 0c c9 c9 10 	movl   $0xc010c9c9,0xc(%esp)
c0104638:	c0 
c0104639:	c7 44 24 08 76 c6 10 	movl   $0xc010c676,0x8(%esp)
c0104640:	c0 
c0104641:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
c0104648:	00 
c0104649:	c7 04 24 8b c6 10 c0 	movl   $0xc010c68b,(%esp)
c0104650:	e8 80 c7 ff ff       	call   c0100dd5 <__panic>
}
c0104655:	81 c4 94 00 00 00    	add    $0x94,%esp
c010465b:	5b                   	pop    %ebx
c010465c:	5d                   	pop    %ebp
c010465d:	c3                   	ret    

c010465e <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010465e:	55                   	push   %ebp
c010465f:	89 e5                	mov    %esp,%ebp
c0104661:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104664:	9c                   	pushf  
c0104665:	58                   	pop    %eax
c0104666:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010466c:	25 00 02 00 00       	and    $0x200,%eax
c0104671:	85 c0                	test   %eax,%eax
c0104673:	74 0c                	je     c0104681 <__intr_save+0x23>
        intr_disable();
c0104675:	e8 b3 d9 ff ff       	call   c010202d <intr_disable>
        return 1;
c010467a:	b8 01 00 00 00       	mov    $0x1,%eax
c010467f:	eb 05                	jmp    c0104686 <__intr_save+0x28>
    }
    return 0;
c0104681:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104686:	c9                   	leave  
c0104687:	c3                   	ret    

c0104688 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104688:	55                   	push   %ebp
c0104689:	89 e5                	mov    %esp,%ebp
c010468b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010468e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104692:	74 05                	je     c0104699 <__intr_restore+0x11>
        intr_enable();
c0104694:	e8 8e d9 ff ff       	call   c0102027 <intr_enable>
    }
}
c0104699:	c9                   	leave  
c010469a:	c3                   	ret    

c010469b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010469b:	55                   	push   %ebp
c010469c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010469e:	8b 55 08             	mov    0x8(%ebp),%edx
c01046a1:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01046a6:	29 c2                	sub    %eax,%edx
c01046a8:	89 d0                	mov    %edx,%eax
c01046aa:	c1 f8 05             	sar    $0x5,%eax
}
c01046ad:	5d                   	pop    %ebp
c01046ae:	c3                   	ret    

c01046af <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01046af:	55                   	push   %ebp
c01046b0:	89 e5                	mov    %esp,%ebp
c01046b2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01046b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b8:	89 04 24             	mov    %eax,(%esp)
c01046bb:	e8 db ff ff ff       	call   c010469b <page2ppn>
c01046c0:	c1 e0 0c             	shl    $0xc,%eax
}
c01046c3:	c9                   	leave  
c01046c4:	c3                   	ret    

c01046c5 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01046c5:	55                   	push   %ebp
c01046c6:	89 e5                	mov    %esp,%ebp
c01046c8:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01046cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ce:	c1 e8 0c             	shr    $0xc,%eax
c01046d1:	89 c2                	mov    %eax,%edx
c01046d3:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01046d8:	39 c2                	cmp    %eax,%edx
c01046da:	72 1c                	jb     c01046f8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01046dc:	c7 44 24 08 04 ca 10 	movl   $0xc010ca04,0x8(%esp)
c01046e3:	c0 
c01046e4:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01046eb:	00 
c01046ec:	c7 04 24 23 ca 10 c0 	movl   $0xc010ca23,(%esp)
c01046f3:	e8 dd c6 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c01046f8:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01046fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0104700:	c1 ea 0c             	shr    $0xc,%edx
c0104703:	c1 e2 05             	shl    $0x5,%edx
c0104706:	01 d0                	add    %edx,%eax
}
c0104708:	c9                   	leave  
c0104709:	c3                   	ret    

c010470a <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010470a:	55                   	push   %ebp
c010470b:	89 e5                	mov    %esp,%ebp
c010470d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104710:	8b 45 08             	mov    0x8(%ebp),%eax
c0104713:	89 04 24             	mov    %eax,(%esp)
c0104716:	e8 94 ff ff ff       	call   c01046af <page2pa>
c010471b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010471e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104721:	c1 e8 0c             	shr    $0xc,%eax
c0104724:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104727:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010472c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010472f:	72 23                	jb     c0104754 <page2kva+0x4a>
c0104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104734:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104738:	c7 44 24 08 34 ca 10 	movl   $0xc010ca34,0x8(%esp)
c010473f:	c0 
c0104740:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104747:	00 
c0104748:	c7 04 24 23 ca 10 c0 	movl   $0xc010ca23,(%esp)
c010474f:	e8 81 c6 ff ff       	call   c0100dd5 <__panic>
c0104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104757:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010475c:	c9                   	leave  
c010475d:	c3                   	ret    

c010475e <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010475e:	55                   	push   %ebp
c010475f:	89 e5                	mov    %esp,%ebp
c0104761:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104764:	8b 45 08             	mov    0x8(%ebp),%eax
c0104767:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010476a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104771:	77 23                	ja     c0104796 <kva2page+0x38>
c0104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104776:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010477a:	c7 44 24 08 58 ca 10 	movl   $0xc010ca58,0x8(%esp)
c0104781:	c0 
c0104782:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0104789:	00 
c010478a:	c7 04 24 23 ca 10 c0 	movl   $0xc010ca23,(%esp)
c0104791:	e8 3f c6 ff ff       	call   c0100dd5 <__panic>
c0104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104799:	05 00 00 00 40       	add    $0x40000000,%eax
c010479e:	89 04 24             	mov    %eax,(%esp)
c01047a1:	e8 1f ff ff ff       	call   c01046c5 <pa2page>
}
c01047a6:	c9                   	leave  
c01047a7:	c3                   	ret    

c01047a8 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c01047a8:	55                   	push   %ebp
c01047a9:	89 e5                	mov    %esp,%ebp
c01047ab:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c01047ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047b1:	ba 01 00 00 00       	mov    $0x1,%edx
c01047b6:	89 c1                	mov    %eax,%ecx
c01047b8:	d3 e2                	shl    %cl,%edx
c01047ba:	89 d0                	mov    %edx,%eax
c01047bc:	89 04 24             	mov    %eax,(%esp)
c01047bf:	e8 07 09 00 00       	call   c01050cb <alloc_pages>
c01047c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c01047c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047cb:	75 07                	jne    c01047d4 <__slob_get_free_pages+0x2c>
    return NULL;
c01047cd:	b8 00 00 00 00       	mov    $0x0,%eax
c01047d2:	eb 0b                	jmp    c01047df <__slob_get_free_pages+0x37>
  return page2kva(page);
c01047d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d7:	89 04 24             	mov    %eax,(%esp)
c01047da:	e8 2b ff ff ff       	call   c010470a <page2kva>
}
c01047df:	c9                   	leave  
c01047e0:	c3                   	ret    

c01047e1 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c01047e1:	55                   	push   %ebp
c01047e2:	89 e5                	mov    %esp,%ebp
c01047e4:	53                   	push   %ebx
c01047e5:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c01047e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047eb:	ba 01 00 00 00       	mov    $0x1,%edx
c01047f0:	89 c1                	mov    %eax,%ecx
c01047f2:	d3 e2                	shl    %cl,%edx
c01047f4:	89 d0                	mov    %edx,%eax
c01047f6:	89 c3                	mov    %eax,%ebx
c01047f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047fb:	89 04 24             	mov    %eax,(%esp)
c01047fe:	e8 5b ff ff ff       	call   c010475e <kva2page>
c0104803:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104807:	89 04 24             	mov    %eax,(%esp)
c010480a:	e8 27 09 00 00       	call   c0105136 <free_pages>
}
c010480f:	83 c4 14             	add    $0x14,%esp
c0104812:	5b                   	pop    %ebx
c0104813:	5d                   	pop    %ebp
c0104814:	c3                   	ret    

c0104815 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104815:	55                   	push   %ebp
c0104816:	89 e5                	mov    %esp,%ebp
c0104818:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c010481b:	8b 45 08             	mov    0x8(%ebp),%eax
c010481e:	83 c0 08             	add    $0x8,%eax
c0104821:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104826:	76 24                	jbe    c010484c <slob_alloc+0x37>
c0104828:	c7 44 24 0c 7c ca 10 	movl   $0xc010ca7c,0xc(%esp)
c010482f:	c0 
c0104830:	c7 44 24 08 9b ca 10 	movl   $0xc010ca9b,0x8(%esp)
c0104837:	c0 
c0104838:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010483f:	00 
c0104840:	c7 04 24 b0 ca 10 c0 	movl   $0xc010cab0,(%esp)
c0104847:	e8 89 c5 ff ff       	call   c0100dd5 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c010484c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104853:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010485a:	8b 45 08             	mov    0x8(%ebp),%eax
c010485d:	83 c0 07             	add    $0x7,%eax
c0104860:	c1 e8 03             	shr    $0x3,%eax
c0104863:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104866:	e8 f3 fd ff ff       	call   c010465e <__intr_save>
c010486b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c010486e:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104876:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104879:	8b 40 04             	mov    0x4(%eax),%eax
c010487c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c010487f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104883:	74 25                	je     c01048aa <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104885:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104888:	8b 45 10             	mov    0x10(%ebp),%eax
c010488b:	01 d0                	add    %edx,%eax
c010488d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104890:	8b 45 10             	mov    0x10(%ebp),%eax
c0104893:	f7 d8                	neg    %eax
c0104895:	21 d0                	and    %edx,%eax
c0104897:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c010489a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010489d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048a0:	29 c2                	sub    %eax,%edx
c01048a2:	89 d0                	mov    %edx,%eax
c01048a4:	c1 f8 03             	sar    $0x3,%eax
c01048a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c01048aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ad:	8b 00                	mov    (%eax),%eax
c01048af:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01048b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01048b5:	01 ca                	add    %ecx,%edx
c01048b7:	39 d0                	cmp    %edx,%eax
c01048b9:	0f 8c aa 00 00 00    	jl     c0104969 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c01048bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01048c3:	74 38                	je     c01048fd <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c01048c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c8:	8b 00                	mov    (%eax),%eax
c01048ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
c01048cd:	89 c2                	mov    %eax,%edx
c01048cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048d2:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c01048d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d7:	8b 50 04             	mov    0x4(%eax),%edx
c01048da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048dd:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c01048e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01048e6:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c01048e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01048ef:	89 10                	mov    %edx,(%eax)
				prev = cur;
c01048f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01048f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01048fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104900:	8b 00                	mov    (%eax),%eax
c0104902:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104905:	75 0e                	jne    c0104915 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104907:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010490a:	8b 50 04             	mov    0x4(%eax),%edx
c010490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104910:	89 50 04             	mov    %edx,0x4(%eax)
c0104913:	eb 3c                	jmp    c0104951 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104915:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104918:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010491f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104922:	01 c2                	add    %eax,%edx
c0104924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104927:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c010492a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010492d:	8b 40 04             	mov    0x4(%eax),%eax
c0104930:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104933:	8b 12                	mov    (%edx),%edx
c0104935:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104938:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c010493a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010493d:	8b 40 04             	mov    0x4(%eax),%eax
c0104940:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104943:	8b 52 04             	mov    0x4(%edx),%edx
c0104946:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104949:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010494c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010494f:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104954:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010495c:	89 04 24             	mov    %eax,(%esp)
c010495f:	e8 24 fd ff ff       	call   c0104688 <__intr_restore>
			return cur;
c0104964:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104967:	eb 7f                	jmp    c01049e8 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104969:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c010496e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104971:	75 61                	jne    c01049d4 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104976:	89 04 24             	mov    %eax,(%esp)
c0104979:	e8 0a fd ff ff       	call   c0104688 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c010497e:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104985:	75 07                	jne    c010498e <slob_alloc+0x179>
				return 0;
c0104987:	b8 00 00 00 00       	mov    $0x0,%eax
c010498c:	eb 5a                	jmp    c01049e8 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010498e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104995:	00 
c0104996:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104999:	89 04 24             	mov    %eax,(%esp)
c010499c:	e8 07 fe ff ff       	call   c01047a8 <__slob_get_free_pages>
c01049a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c01049a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049a8:	75 07                	jne    c01049b1 <slob_alloc+0x19c>
				return 0;
c01049aa:	b8 00 00 00 00       	mov    $0x0,%eax
c01049af:	eb 37                	jmp    c01049e8 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c01049b1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049b8:	00 
c01049b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049bc:	89 04 24             	mov    %eax,(%esp)
c01049bf:	e8 26 00 00 00       	call   c01049ea <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c01049c4:	e8 95 fc ff ff       	call   c010465e <__intr_save>
c01049c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c01049cc:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01049d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01049d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049dd:	8b 40 04             	mov    0x4(%eax),%eax
c01049e0:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c01049e3:	e9 97 fe ff ff       	jmp    c010487f <slob_alloc+0x6a>
}
c01049e8:	c9                   	leave  
c01049e9:	c3                   	ret    

c01049ea <slob_free>:

static void slob_free(void *block, int size)
{
c01049ea:	55                   	push   %ebp
c01049eb:	89 e5                	mov    %esp,%ebp
c01049ed:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c01049f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01049f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049fa:	75 05                	jne    c0104a01 <slob_free+0x17>
		return;
c01049fc:	e9 ff 00 00 00       	jmp    c0104b00 <slob_free+0x116>

	if (size)
c0104a01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104a05:	74 10                	je     c0104a17 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104a07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a0a:	83 c0 07             	add    $0x7,%eax
c0104a0d:	c1 e8 03             	shr    $0x3,%eax
c0104a10:	89 c2                	mov    %eax,%edx
c0104a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a15:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104a17:	e8 42 fc ff ff       	call   c010465e <__intr_save>
c0104a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104a1f:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a27:	eb 27                	jmp    c0104a50 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a2c:	8b 40 04             	mov    0x4(%eax),%eax
c0104a2f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a32:	77 13                	ja     c0104a47 <slob_free+0x5d>
c0104a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a37:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a3a:	77 27                	ja     c0104a63 <slob_free+0x79>
c0104a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a3f:	8b 40 04             	mov    0x4(%eax),%eax
c0104a42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a45:	77 1c                	ja     c0104a63 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a4a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a56:	76 d1                	jbe    c0104a29 <slob_free+0x3f>
c0104a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a5b:	8b 40 04             	mov    0x4(%eax),%eax
c0104a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104a61:	76 c6                	jbe    c0104a29 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a66:	8b 00                	mov    (%eax),%eax
c0104a68:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a72:	01 c2                	add    %eax,%edx
c0104a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a77:	8b 40 04             	mov    0x4(%eax),%eax
c0104a7a:	39 c2                	cmp    %eax,%edx
c0104a7c:	75 25                	jne    c0104aa3 <slob_free+0xb9>
		b->units += cur->next->units;
c0104a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a81:	8b 10                	mov    (%eax),%edx
c0104a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a86:	8b 40 04             	mov    0x4(%eax),%eax
c0104a89:	8b 00                	mov    (%eax),%eax
c0104a8b:	01 c2                	add    %eax,%edx
c0104a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a90:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a95:	8b 40 04             	mov    0x4(%eax),%eax
c0104a98:	8b 50 04             	mov    0x4(%eax),%edx
c0104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a9e:	89 50 04             	mov    %edx,0x4(%eax)
c0104aa1:	eb 0c                	jmp    c0104aaf <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa6:	8b 50 04             	mov    0x4(%eax),%edx
c0104aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aac:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab2:	8b 00                	mov    (%eax),%eax
c0104ab4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104abe:	01 d0                	add    %edx,%eax
c0104ac0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ac3:	75 1f                	jne    c0104ae4 <slob_free+0xfa>
		cur->units += b->units;
c0104ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac8:	8b 10                	mov    (%eax),%edx
c0104aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104acd:	8b 00                	mov    (%eax),%eax
c0104acf:	01 c2                	add    %eax,%edx
c0104ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad4:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad9:	8b 50 04             	mov    0x4(%eax),%edx
c0104adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104adf:	89 50 04             	mov    %edx,0x4(%eax)
c0104ae2:	eb 09                	jmp    c0104aed <slob_free+0x103>
	} else
		cur->next = b;
c0104ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104aea:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104af0:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104af8:	89 04 24             	mov    %eax,(%esp)
c0104afb:	e8 88 fb ff ff       	call   c0104688 <__intr_restore>
}
c0104b00:	c9                   	leave  
c0104b01:	c3                   	ret    

c0104b02 <slob_init>:



void
slob_init(void) {
c0104b02:	55                   	push   %ebp
c0104b03:	89 e5                	mov    %esp,%ebp
c0104b05:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104b08:	c7 04 24 c2 ca 10 c0 	movl   $0xc010cac2,(%esp)
c0104b0f:	e8 3f b8 ff ff       	call   c0100353 <cprintf>
}
c0104b14:	c9                   	leave  
c0104b15:	c3                   	ret    

c0104b16 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104b16:	55                   	push   %ebp
c0104b17:	89 e5                	mov    %esp,%ebp
c0104b19:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104b1c:	e8 e1 ff ff ff       	call   c0104b02 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104b21:	c7 04 24 d6 ca 10 c0 	movl   $0xc010cad6,(%esp)
c0104b28:	e8 26 b8 ff ff       	call   c0100353 <cprintf>
}
c0104b2d:	c9                   	leave  
c0104b2e:	c3                   	ret    

c0104b2f <slob_allocated>:

size_t
slob_allocated(void) {
c0104b2f:	55                   	push   %ebp
c0104b30:	89 e5                	mov    %esp,%ebp
  return 0;
c0104b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b37:	5d                   	pop    %ebp
c0104b38:	c3                   	ret    

c0104b39 <kallocated>:

size_t
kallocated(void) {
c0104b39:	55                   	push   %ebp
c0104b3a:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104b3c:	e8 ee ff ff ff       	call   c0104b2f <slob_allocated>
}
c0104b41:	5d                   	pop    %ebp
c0104b42:	c3                   	ret    

c0104b43 <find_order>:

static int find_order(int size)
{
c0104b43:	55                   	push   %ebp
c0104b44:	89 e5                	mov    %esp,%ebp
c0104b46:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104b49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104b50:	eb 07                	jmp    c0104b59 <find_order+0x16>
		order++;
c0104b52:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104b56:	d1 7d 08             	sarl   0x8(%ebp)
c0104b59:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104b60:	7f f0                	jg     c0104b52 <find_order+0xf>
		order++;
	return order;
c0104b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104b65:	c9                   	leave  
c0104b66:	c3                   	ret    

c0104b67 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104b67:	55                   	push   %ebp
c0104b68:	89 e5                	mov    %esp,%ebp
c0104b6a:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104b6d:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104b74:	77 38                	ja     c0104bae <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104b76:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b79:	8d 50 08             	lea    0x8(%eax),%edx
c0104b7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b83:	00 
c0104b84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b8b:	89 14 24             	mov    %edx,(%esp)
c0104b8e:	e8 82 fc ff ff       	call   c0104815 <slob_alloc>
c0104b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b9a:	74 08                	je     c0104ba4 <__kmalloc+0x3d>
c0104b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b9f:	83 c0 08             	add    $0x8,%eax
c0104ba2:	eb 05                	jmp    c0104ba9 <__kmalloc+0x42>
c0104ba4:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ba9:	e9 a6 00 00 00       	jmp    c0104c54 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104bae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bb5:	00 
c0104bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104bbd:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104bc4:	e8 4c fc ff ff       	call   c0104815 <slob_alloc>
c0104bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104bcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104bd0:	75 07                	jne    c0104bd9 <__kmalloc+0x72>
		return 0;
c0104bd2:	b8 00 00 00 00       	mov    $0x0,%eax
c0104bd7:	eb 7b                	jmp    c0104c54 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bdc:	89 04 24             	mov    %eax,(%esp)
c0104bdf:	e8 5f ff ff ff       	call   c0104b43 <find_order>
c0104be4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104be7:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bec:	8b 00                	mov    (%eax),%eax
c0104bee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bf5:	89 04 24             	mov    %eax,(%esp)
c0104bf8:	e8 ab fb ff ff       	call   c01047a8 <__slob_get_free_pages>
c0104bfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c00:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c0104c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c06:	8b 40 04             	mov    0x4(%eax),%eax
c0104c09:	85 c0                	test   %eax,%eax
c0104c0b:	74 2f                	je     c0104c3c <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104c0d:	e8 4c fa ff ff       	call   c010465e <__intr_save>
c0104c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104c15:	8b 15 c4 ce 19 c0    	mov    0xc019cec4,%edx
c0104c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c1e:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c24:	a3 c4 ce 19 c0       	mov    %eax,0xc019cec4
		spin_unlock_irqrestore(&block_lock, flags);
c0104c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c2c:	89 04 24             	mov    %eax,(%esp)
c0104c2f:	e8 54 fa ff ff       	call   c0104688 <__intr_restore>
		return bb->pages;
c0104c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c37:	8b 40 04             	mov    0x4(%eax),%eax
c0104c3a:	eb 18                	jmp    c0104c54 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104c3c:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104c43:	00 
c0104c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c47:	89 04 24             	mov    %eax,(%esp)
c0104c4a:	e8 9b fd ff ff       	call   c01049ea <slob_free>
	return 0;
c0104c4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104c54:	c9                   	leave  
c0104c55:	c3                   	ret    

c0104c56 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104c56:	55                   	push   %ebp
c0104c57:	89 e5                	mov    %esp,%ebp
c0104c59:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104c5c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c63:	00 
c0104c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c67:	89 04 24             	mov    %eax,(%esp)
c0104c6a:	e8 f8 fe ff ff       	call   c0104b67 <__kmalloc>
}
c0104c6f:	c9                   	leave  
c0104c70:	c3                   	ret    

c0104c71 <kfree>:


void kfree(void *block)
{
c0104c71:	55                   	push   %ebp
c0104c72:	89 e5                	mov    %esp,%ebp
c0104c74:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104c77:	c7 45 f0 c4 ce 19 c0 	movl   $0xc019cec4,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104c7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104c82:	75 05                	jne    c0104c89 <kfree+0x18>
		return;
c0104c84:	e9 a2 00 00 00       	jmp    c0104d2b <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c8c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c91:	85 c0                	test   %eax,%eax
c0104c93:	75 7f                	jne    c0104d14 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104c95:	e8 c4 f9 ff ff       	call   c010465e <__intr_save>
c0104c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104c9d:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ca5:	eb 5c                	jmp    c0104d03 <kfree+0x92>
			if (bb->pages == block) {
c0104ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104caa:	8b 40 04             	mov    0x4(%eax),%eax
c0104cad:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104cb0:	75 3f                	jne    c0104cf1 <kfree+0x80>
				*last = bb->next;
c0104cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cb5:	8b 50 08             	mov    0x8(%eax),%edx
c0104cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cbb:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cc0:	89 04 24             	mov    %eax,(%esp)
c0104cc3:	e8 c0 f9 ff ff       	call   c0104688 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ccb:	8b 10                	mov    (%eax),%edx
c0104ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cd0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cd4:	89 04 24             	mov    %eax,(%esp)
c0104cd7:	e8 05 fb ff ff       	call   c01047e1 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104cdc:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104ce3:	00 
c0104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce7:	89 04 24             	mov    %eax,(%esp)
c0104cea:	e8 fb fc ff ff       	call   c01049ea <slob_free>
				return;
c0104cef:	eb 3a                	jmp    c0104d2b <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf4:	83 c0 08             	add    $0x8,%eax
c0104cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cfd:	8b 40 08             	mov    0x8(%eax),%eax
c0104d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d07:	75 9e                	jne    c0104ca7 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d0c:	89 04 24             	mov    %eax,(%esp)
c0104d0f:	e8 74 f9 ff ff       	call   c0104688 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d17:	83 e8 08             	sub    $0x8,%eax
c0104d1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d21:	00 
c0104d22:	89 04 24             	mov    %eax,(%esp)
c0104d25:	e8 c0 fc ff ff       	call   c01049ea <slob_free>
	return;
c0104d2a:	90                   	nop
}
c0104d2b:	c9                   	leave  
c0104d2c:	c3                   	ret    

c0104d2d <ksize>:


unsigned int ksize(const void *block)
{
c0104d2d:	55                   	push   %ebp
c0104d2e:	89 e5                	mov    %esp,%ebp
c0104d30:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104d33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104d37:	75 07                	jne    c0104d40 <ksize+0x13>
		return 0;
c0104d39:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d3e:	eb 6b                	jmp    c0104dab <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104d40:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d43:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104d48:	85 c0                	test   %eax,%eax
c0104d4a:	75 54                	jne    c0104da0 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104d4c:	e8 0d f9 ff ff       	call   c010465e <__intr_save>
c0104d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104d54:	a1 c4 ce 19 c0       	mov    0xc019cec4,%eax
c0104d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d5c:	eb 31                	jmp    c0104d8f <ksize+0x62>
			if (bb->pages == block) {
c0104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d61:	8b 40 04             	mov    0x4(%eax),%eax
c0104d64:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104d67:	75 1d                	jne    c0104d86 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d6c:	89 04 24             	mov    %eax,(%esp)
c0104d6f:	e8 14 f9 ff ff       	call   c0104688 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d77:	8b 00                	mov    (%eax),%eax
c0104d79:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104d7e:	89 c1                	mov    %eax,%ecx
c0104d80:	d3 e2                	shl    %cl,%edx
c0104d82:	89 d0                	mov    %edx,%eax
c0104d84:	eb 25                	jmp    c0104dab <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d89:	8b 40 08             	mov    0x8(%eax),%eax
c0104d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d93:	75 c9                	jne    c0104d5e <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d98:	89 04 24             	mov    %eax,(%esp)
c0104d9b:	e8 e8 f8 ff ff       	call   c0104688 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104da3:	83 e8 08             	sub    $0x8,%eax
c0104da6:	8b 00                	mov    (%eax),%eax
c0104da8:	c1 e0 03             	shl    $0x3,%eax
}
c0104dab:	c9                   	leave  
c0104dac:	c3                   	ret    

c0104dad <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104dad:	55                   	push   %ebp
c0104dae:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104db0:	8b 55 08             	mov    0x8(%ebp),%edx
c0104db3:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104db8:	29 c2                	sub    %eax,%edx
c0104dba:	89 d0                	mov    %edx,%eax
c0104dbc:	c1 f8 05             	sar    $0x5,%eax
}
c0104dbf:	5d                   	pop    %ebp
c0104dc0:	c3                   	ret    

c0104dc1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104dc1:	55                   	push   %ebp
c0104dc2:	89 e5                	mov    %esp,%ebp
c0104dc4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dca:	89 04 24             	mov    %eax,(%esp)
c0104dcd:	e8 db ff ff ff       	call   c0104dad <page2ppn>
c0104dd2:	c1 e0 0c             	shl    $0xc,%eax
}
c0104dd5:	c9                   	leave  
c0104dd6:	c3                   	ret    

c0104dd7 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104dd7:	55                   	push   %ebp
c0104dd8:	89 e5                	mov    %esp,%ebp
c0104dda:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104de0:	c1 e8 0c             	shr    $0xc,%eax
c0104de3:	89 c2                	mov    %eax,%edx
c0104de5:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104dea:	39 c2                	cmp    %eax,%edx
c0104dec:	72 1c                	jb     c0104e0a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104dee:	c7 44 24 08 f4 ca 10 	movl   $0xc010caf4,0x8(%esp)
c0104df5:	c0 
c0104df6:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104dfd:	00 
c0104dfe:	c7 04 24 13 cb 10 c0 	movl   $0xc010cb13,(%esp)
c0104e05:	e8 cb bf ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104e0a:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0104e0f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e12:	c1 ea 0c             	shr    $0xc,%edx
c0104e15:	c1 e2 05             	shl    $0x5,%edx
c0104e18:	01 d0                	add    %edx,%eax
}
c0104e1a:	c9                   	leave  
c0104e1b:	c3                   	ret    

c0104e1c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104e1c:	55                   	push   %ebp
c0104e1d:	89 e5                	mov    %esp,%ebp
c0104e1f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104e22:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e25:	89 04 24             	mov    %eax,(%esp)
c0104e28:	e8 94 ff ff ff       	call   c0104dc1 <page2pa>
c0104e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e33:	c1 e8 0c             	shr    $0xc,%eax
c0104e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e39:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0104e3e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104e41:	72 23                	jb     c0104e66 <page2kva+0x4a>
c0104e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e46:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e4a:	c7 44 24 08 24 cb 10 	movl   $0xc010cb24,0x8(%esp)
c0104e51:	c0 
c0104e52:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104e59:	00 
c0104e5a:	c7 04 24 13 cb 10 c0 	movl   $0xc010cb13,(%esp)
c0104e61:	e8 6f bf ff ff       	call   c0100dd5 <__panic>
c0104e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e69:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104e6e:	c9                   	leave  
c0104e6f:	c3                   	ret    

c0104e70 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104e70:	55                   	push   %ebp
c0104e71:	89 e5                	mov    %esp,%ebp
c0104e73:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e79:	83 e0 01             	and    $0x1,%eax
c0104e7c:	85 c0                	test   %eax,%eax
c0104e7e:	75 1c                	jne    c0104e9c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104e80:	c7 44 24 08 48 cb 10 	movl   $0xc010cb48,0x8(%esp)
c0104e87:	c0 
c0104e88:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104e8f:	00 
c0104e90:	c7 04 24 13 cb 10 c0 	movl   $0xc010cb13,(%esp)
c0104e97:	e8 39 bf ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104e9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ea4:	89 04 24             	mov    %eax,(%esp)
c0104ea7:	e8 2b ff ff ff       	call   c0104dd7 <pa2page>
}
c0104eac:	c9                   	leave  
c0104ead:	c3                   	ret    

c0104eae <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104eae:	55                   	push   %ebp
c0104eaf:	89 e5                	mov    %esp,%ebp
c0104eb1:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104eb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ebc:	89 04 24             	mov    %eax,(%esp)
c0104ebf:	e8 13 ff ff ff       	call   c0104dd7 <pa2page>
}
c0104ec4:	c9                   	leave  
c0104ec5:	c3                   	ret    

c0104ec6 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104ec6:	55                   	push   %ebp
c0104ec7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104ec9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ecc:	8b 00                	mov    (%eax),%eax
}
c0104ece:	5d                   	pop    %ebp
c0104ecf:	c3                   	ret    

c0104ed0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104ed0:	55                   	push   %ebp
c0104ed1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104ed3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ed9:	89 10                	mov    %edx,(%eax)
}
c0104edb:	5d                   	pop    %ebp
c0104edc:	c3                   	ret    

c0104edd <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104edd:	55                   	push   %ebp
c0104ede:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ee3:	8b 00                	mov    (%eax),%eax
c0104ee5:	8d 50 01             	lea    0x1(%eax),%edx
c0104ee8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eeb:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ef0:	8b 00                	mov    (%eax),%eax
}
c0104ef2:	5d                   	pop    %ebp
c0104ef3:	c3                   	ret    

c0104ef4 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104ef4:	55                   	push   %ebp
c0104ef5:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104ef7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104efa:	8b 00                	mov    (%eax),%eax
c0104efc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f02:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104f04:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f07:	8b 00                	mov    (%eax),%eax
}
c0104f09:	5d                   	pop    %ebp
c0104f0a:	c3                   	ret    

c0104f0b <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104f0b:	55                   	push   %ebp
c0104f0c:	89 e5                	mov    %esp,%ebp
c0104f0e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104f11:	9c                   	pushf  
c0104f12:	58                   	pop    %eax
c0104f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104f19:	25 00 02 00 00       	and    $0x200,%eax
c0104f1e:	85 c0                	test   %eax,%eax
c0104f20:	74 0c                	je     c0104f2e <__intr_save+0x23>
        intr_disable();
c0104f22:	e8 06 d1 ff ff       	call   c010202d <intr_disable>
        return 1;
c0104f27:	b8 01 00 00 00       	mov    $0x1,%eax
c0104f2c:	eb 05                	jmp    c0104f33 <__intr_save+0x28>
    }
    return 0;
c0104f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f33:	c9                   	leave  
c0104f34:	c3                   	ret    

c0104f35 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104f35:	55                   	push   %ebp
c0104f36:	89 e5                	mov    %esp,%ebp
c0104f38:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104f3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104f3f:	74 05                	je     c0104f46 <__intr_restore+0x11>
        intr_enable();
c0104f41:	e8 e1 d0 ff ff       	call   c0102027 <intr_enable>
    }
}
c0104f46:	c9                   	leave  
c0104f47:	c3                   	ret    

c0104f48 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104f48:	55                   	push   %ebp
c0104f49:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104f4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f4e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104f51:	b8 23 00 00 00       	mov    $0x23,%eax
c0104f56:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104f58:	b8 23 00 00 00       	mov    $0x23,%eax
c0104f5d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104f5f:	b8 10 00 00 00       	mov    $0x10,%eax
c0104f64:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104f66:	b8 10 00 00 00       	mov    $0x10,%eax
c0104f6b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104f6d:	b8 10 00 00 00       	mov    $0x10,%eax
c0104f72:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104f74:	ea 7b 4f 10 c0 08 00 	ljmp   $0x8,$0xc0104f7b
}
c0104f7b:	5d                   	pop    %ebp
c0104f7c:	c3                   	ret    

c0104f7d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104f7d:	55                   	push   %ebp
c0104f7e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104f80:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f83:	a3 04 cf 19 c0       	mov    %eax,0xc019cf04
}
c0104f88:	5d                   	pop    %ebp
c0104f89:	c3                   	ret    

c0104f8a <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104f8a:	55                   	push   %ebp
c0104f8b:	89 e5                	mov    %esp,%ebp
c0104f8d:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104f90:	b8 00 a0 12 c0       	mov    $0xc012a000,%eax
c0104f95:	89 04 24             	mov    %eax,(%esp)
c0104f98:	e8 e0 ff ff ff       	call   c0104f7d <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104f9d:	66 c7 05 08 cf 19 c0 	movw   $0x10,0xc019cf08
c0104fa4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104fa6:	66 c7 05 48 aa 12 c0 	movw   $0x68,0xc012aa48
c0104fad:	68 00 
c0104faf:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104fb4:	66 a3 4a aa 12 c0    	mov    %ax,0xc012aa4a
c0104fba:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0104fbf:	c1 e8 10             	shr    $0x10,%eax
c0104fc2:	a2 4c aa 12 c0       	mov    %al,0xc012aa4c
c0104fc7:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104fce:	83 e0 f0             	and    $0xfffffff0,%eax
c0104fd1:	83 c8 09             	or     $0x9,%eax
c0104fd4:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104fd9:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104fe0:	83 e0 ef             	and    $0xffffffef,%eax
c0104fe3:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104fe8:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104fef:	83 e0 9f             	and    $0xffffff9f,%eax
c0104ff2:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0104ff7:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0104ffe:	83 c8 80             	or     $0xffffff80,%eax
c0105001:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c0105006:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c010500d:	83 e0 f0             	and    $0xfffffff0,%eax
c0105010:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0105015:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c010501c:	83 e0 ef             	and    $0xffffffef,%eax
c010501f:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0105024:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c010502b:	83 e0 df             	and    $0xffffffdf,%eax
c010502e:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0105033:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c010503a:	83 c8 40             	or     $0x40,%eax
c010503d:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0105042:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0105049:	83 e0 7f             	and    $0x7f,%eax
c010504c:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c0105051:	b8 00 cf 19 c0       	mov    $0xc019cf00,%eax
c0105056:	c1 e8 18             	shr    $0x18,%eax
c0105059:	a2 4f aa 12 c0       	mov    %al,0xc012aa4f

    // reload all segment registers
    lgdt(&gdt_pd);
c010505e:	c7 04 24 50 aa 12 c0 	movl   $0xc012aa50,(%esp)
c0105065:	e8 de fe ff ff       	call   c0104f48 <lgdt>
c010506a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0105070:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0105074:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0105077:	c9                   	leave  
c0105078:	c3                   	ret    

c0105079 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0105079:	55                   	push   %ebp
c010507a:	89 e5                	mov    %esp,%ebp
c010507c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c010507f:	c7 05 c4 ef 19 c0 e8 	movl   $0xc010c9e8,0xc019efc4
c0105086:	c9 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0105089:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010508e:	8b 00                	mov    (%eax),%eax
c0105090:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105094:	c7 04 24 74 cb 10 c0 	movl   $0xc010cb74,(%esp)
c010509b:	e8 b3 b2 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c01050a0:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050a5:	8b 40 04             	mov    0x4(%eax),%eax
c01050a8:	ff d0                	call   *%eax
}
c01050aa:	c9                   	leave  
c01050ab:	c3                   	ret    

c01050ac <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01050ac:	55                   	push   %ebp
c01050ad:	89 e5                	mov    %esp,%ebp
c01050af:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c01050b2:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050b7:	8b 40 08             	mov    0x8(%eax),%eax
c01050ba:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050bd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050c1:	8b 55 08             	mov    0x8(%ebp),%edx
c01050c4:	89 14 24             	mov    %edx,(%esp)
c01050c7:	ff d0                	call   *%eax
}
c01050c9:	c9                   	leave  
c01050ca:	c3                   	ret    

c01050cb <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01050cb:	55                   	push   %ebp
c01050cc:	89 e5                	mov    %esp,%ebp
c01050ce:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01050d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c01050d8:	e8 2e fe ff ff       	call   c0104f0b <__intr_save>
c01050dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c01050e0:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c01050e5:	8b 40 0c             	mov    0xc(%eax),%eax
c01050e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01050eb:	89 14 24             	mov    %edx,(%esp)
c01050ee:	ff d0                	call   *%eax
c01050f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01050f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050f6:	89 04 24             	mov    %eax,(%esp)
c01050f9:	e8 37 fe ff ff       	call   c0104f35 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01050fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105102:	75 2d                	jne    c0105131 <alloc_pages+0x66>
c0105104:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0105108:	77 27                	ja     c0105131 <alloc_pages+0x66>
c010510a:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c010510f:	85 c0                	test   %eax,%eax
c0105111:	74 1e                	je     c0105131 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0105113:	8b 55 08             	mov    0x8(%ebp),%edx
c0105116:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010511b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105122:	00 
c0105123:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105127:	89 04 24             	mov    %eax,(%esp)
c010512a:	e8 8e 1d 00 00       	call   c0106ebd <swap_out>
    }
c010512f:	eb a7                	jmp    c01050d8 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0105131:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105134:	c9                   	leave  
c0105135:	c3                   	ret    

c0105136 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0105136:	55                   	push   %ebp
c0105137:	89 e5                	mov    %esp,%ebp
c0105139:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010513c:	e8 ca fd ff ff       	call   c0104f0b <__intr_save>
c0105141:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0105144:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0105149:	8b 40 10             	mov    0x10(%eax),%eax
c010514c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010514f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105153:	8b 55 08             	mov    0x8(%ebp),%edx
c0105156:	89 14 24             	mov    %edx,(%esp)
c0105159:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c010515b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010515e:	89 04 24             	mov    %eax,(%esp)
c0105161:	e8 cf fd ff ff       	call   c0104f35 <__intr_restore>
}
c0105166:	c9                   	leave  
c0105167:	c3                   	ret    

c0105168 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0105168:	55                   	push   %ebp
c0105169:	89 e5                	mov    %esp,%ebp
c010516b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010516e:	e8 98 fd ff ff       	call   c0104f0b <__intr_save>
c0105173:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0105176:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c010517b:	8b 40 14             	mov    0x14(%eax),%eax
c010517e:	ff d0                	call   *%eax
c0105180:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0105183:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105186:	89 04 24             	mov    %eax,(%esp)
c0105189:	e8 a7 fd ff ff       	call   c0104f35 <__intr_restore>
    return ret;
c010518e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0105191:	c9                   	leave  
c0105192:	c3                   	ret    

c0105193 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0105193:	55                   	push   %ebp
c0105194:	89 e5                	mov    %esp,%ebp
c0105196:	57                   	push   %edi
c0105197:	56                   	push   %esi
c0105198:	53                   	push   %ebx
c0105199:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010519f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01051a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01051ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01051b4:	c7 04 24 8b cb 10 c0 	movl   $0xc010cb8b,(%esp)
c01051bb:	e8 93 b1 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01051c0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01051c7:	e9 15 01 00 00       	jmp    c01052e1 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01051cc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051cf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051d2:	89 d0                	mov    %edx,%eax
c01051d4:	c1 e0 02             	shl    $0x2,%eax
c01051d7:	01 d0                	add    %edx,%eax
c01051d9:	c1 e0 02             	shl    $0x2,%eax
c01051dc:	01 c8                	add    %ecx,%eax
c01051de:	8b 50 08             	mov    0x8(%eax),%edx
c01051e1:	8b 40 04             	mov    0x4(%eax),%eax
c01051e4:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01051e7:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01051ea:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051f0:	89 d0                	mov    %edx,%eax
c01051f2:	c1 e0 02             	shl    $0x2,%eax
c01051f5:	01 d0                	add    %edx,%eax
c01051f7:	c1 e0 02             	shl    $0x2,%eax
c01051fa:	01 c8                	add    %ecx,%eax
c01051fc:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051ff:	8b 58 10             	mov    0x10(%eax),%ebx
c0105202:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105205:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105208:	01 c8                	add    %ecx,%eax
c010520a:	11 da                	adc    %ebx,%edx
c010520c:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010520f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105212:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105215:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105218:	89 d0                	mov    %edx,%eax
c010521a:	c1 e0 02             	shl    $0x2,%eax
c010521d:	01 d0                	add    %edx,%eax
c010521f:	c1 e0 02             	shl    $0x2,%eax
c0105222:	01 c8                	add    %ecx,%eax
c0105224:	83 c0 14             	add    $0x14,%eax
c0105227:	8b 00                	mov    (%eax),%eax
c0105229:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010522f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105232:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105235:	83 c0 ff             	add    $0xffffffff,%eax
c0105238:	83 d2 ff             	adc    $0xffffffff,%edx
c010523b:	89 c6                	mov    %eax,%esi
c010523d:	89 d7                	mov    %edx,%edi
c010523f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105242:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105245:	89 d0                	mov    %edx,%eax
c0105247:	c1 e0 02             	shl    $0x2,%eax
c010524a:	01 d0                	add    %edx,%eax
c010524c:	c1 e0 02             	shl    $0x2,%eax
c010524f:	01 c8                	add    %ecx,%eax
c0105251:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105254:	8b 58 10             	mov    0x10(%eax),%ebx
c0105257:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010525d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0105261:	89 74 24 14          	mov    %esi,0x14(%esp)
c0105265:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0105269:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010526c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010526f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105273:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105277:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010527b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010527f:	c7 04 24 98 cb 10 c0 	movl   $0xc010cb98,(%esp)
c0105286:	e8 c8 b0 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010528b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010528e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105291:	89 d0                	mov    %edx,%eax
c0105293:	c1 e0 02             	shl    $0x2,%eax
c0105296:	01 d0                	add    %edx,%eax
c0105298:	c1 e0 02             	shl    $0x2,%eax
c010529b:	01 c8                	add    %ecx,%eax
c010529d:	83 c0 14             	add    $0x14,%eax
c01052a0:	8b 00                	mov    (%eax),%eax
c01052a2:	83 f8 01             	cmp    $0x1,%eax
c01052a5:	75 36                	jne    c01052dd <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01052a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052ad:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01052b0:	77 2b                	ja     c01052dd <page_init+0x14a>
c01052b2:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01052b5:	72 05                	jb     c01052bc <page_init+0x129>
c01052b7:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01052ba:	73 21                	jae    c01052dd <page_init+0x14a>
c01052bc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01052c0:	77 1b                	ja     c01052dd <page_init+0x14a>
c01052c2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01052c6:	72 09                	jb     c01052d1 <page_init+0x13e>
c01052c8:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01052cf:	77 0c                	ja     c01052dd <page_init+0x14a>
                maxpa = end;
c01052d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01052d4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01052d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01052dd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01052e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01052e4:	8b 00                	mov    (%eax),%eax
c01052e6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01052e9:	0f 8f dd fe ff ff    	jg     c01051cc <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01052ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052f3:	72 1d                	jb     c0105312 <page_init+0x17f>
c01052f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052f9:	77 09                	ja     c0105304 <page_init+0x171>
c01052fb:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0105302:	76 0e                	jbe    c0105312 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0105304:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010530b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0105312:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105318:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010531c:	c1 ea 0c             	shr    $0xc,%edx
c010531f:	a3 e0 ce 19 c0       	mov    %eax,0xc019cee0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0105324:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010532b:	b8 b8 f0 19 c0       	mov    $0xc019f0b8,%eax
c0105330:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105333:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105336:	01 d0                	add    %edx,%eax
c0105338:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010533b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010533e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105343:	f7 75 ac             	divl   -0x54(%ebp)
c0105346:	89 d0                	mov    %edx,%eax
c0105348:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010534b:	29 c2                	sub    %eax,%edx
c010534d:	89 d0                	mov    %edx,%eax
c010534f:	a3 cc ef 19 c0       	mov    %eax,0xc019efcc

    for (i = 0; i < npage; i ++) {
c0105354:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010535b:	eb 27                	jmp    c0105384 <page_init+0x1f1>
        SetPageReserved(pages + i);
c010535d:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0105362:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105365:	c1 e2 05             	shl    $0x5,%edx
c0105368:	01 d0                	add    %edx,%eax
c010536a:	83 c0 04             	add    $0x4,%eax
c010536d:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0105374:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105377:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010537a:	8b 55 90             	mov    -0x70(%ebp),%edx
c010537d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105380:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105384:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105387:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010538c:	39 c2                	cmp    %eax,%edx
c010538e:	72 cd                	jb     c010535d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105390:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105395:	c1 e0 05             	shl    $0x5,%eax
c0105398:	89 c2                	mov    %eax,%edx
c010539a:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c010539f:	01 d0                	add    %edx,%eax
c01053a1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01053a4:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01053ab:	77 23                	ja     c01053d0 <page_init+0x23d>
c01053ad:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01053b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053b4:	c7 44 24 08 c8 cb 10 	movl   $0xc010cbc8,0x8(%esp)
c01053bb:	c0 
c01053bc:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01053c3:	00 
c01053c4:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01053cb:	e8 05 ba ff ff       	call   c0100dd5 <__panic>
c01053d0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01053d3:	05 00 00 00 40       	add    $0x40000000,%eax
c01053d8:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01053db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01053e2:	e9 74 01 00 00       	jmp    c010555b <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01053e7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01053ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053ed:	89 d0                	mov    %edx,%eax
c01053ef:	c1 e0 02             	shl    $0x2,%eax
c01053f2:	01 d0                	add    %edx,%eax
c01053f4:	c1 e0 02             	shl    $0x2,%eax
c01053f7:	01 c8                	add    %ecx,%eax
c01053f9:	8b 50 08             	mov    0x8(%eax),%edx
c01053fc:	8b 40 04             	mov    0x4(%eax),%eax
c01053ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105402:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105405:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105408:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010540b:	89 d0                	mov    %edx,%eax
c010540d:	c1 e0 02             	shl    $0x2,%eax
c0105410:	01 d0                	add    %edx,%eax
c0105412:	c1 e0 02             	shl    $0x2,%eax
c0105415:	01 c8                	add    %ecx,%eax
c0105417:	8b 48 0c             	mov    0xc(%eax),%ecx
c010541a:	8b 58 10             	mov    0x10(%eax),%ebx
c010541d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105420:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105423:	01 c8                	add    %ecx,%eax
c0105425:	11 da                	adc    %ebx,%edx
c0105427:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010542a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010542d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105430:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105433:	89 d0                	mov    %edx,%eax
c0105435:	c1 e0 02             	shl    $0x2,%eax
c0105438:	01 d0                	add    %edx,%eax
c010543a:	c1 e0 02             	shl    $0x2,%eax
c010543d:	01 c8                	add    %ecx,%eax
c010543f:	83 c0 14             	add    $0x14,%eax
c0105442:	8b 00                	mov    (%eax),%eax
c0105444:	83 f8 01             	cmp    $0x1,%eax
c0105447:	0f 85 0a 01 00 00    	jne    c0105557 <page_init+0x3c4>
            if (begin < freemem) {
c010544d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105450:	ba 00 00 00 00       	mov    $0x0,%edx
c0105455:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105458:	72 17                	jb     c0105471 <page_init+0x2de>
c010545a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010545d:	77 05                	ja     c0105464 <page_init+0x2d1>
c010545f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105462:	76 0d                	jbe    c0105471 <page_init+0x2de>
                begin = freemem;
c0105464:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105467:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010546a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105471:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105475:	72 1d                	jb     c0105494 <page_init+0x301>
c0105477:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010547b:	77 09                	ja     c0105486 <page_init+0x2f3>
c010547d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0105484:	76 0e                	jbe    c0105494 <page_init+0x301>
                end = KMEMSIZE;
c0105486:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010548d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0105494:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010549a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010549d:	0f 87 b4 00 00 00    	ja     c0105557 <page_init+0x3c4>
c01054a3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01054a6:	72 09                	jb     c01054b1 <page_init+0x31e>
c01054a8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01054ab:	0f 83 a6 00 00 00    	jae    c0105557 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c01054b1:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01054b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01054bb:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01054be:	01 d0                	add    %edx,%eax
c01054c0:	83 e8 01             	sub    $0x1,%eax
c01054c3:	89 45 98             	mov    %eax,-0x68(%ebp)
c01054c6:	8b 45 98             	mov    -0x68(%ebp),%eax
c01054c9:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ce:	f7 75 9c             	divl   -0x64(%ebp)
c01054d1:	89 d0                	mov    %edx,%eax
c01054d3:	8b 55 98             	mov    -0x68(%ebp),%edx
c01054d6:	29 c2                	sub    %eax,%edx
c01054d8:	89 d0                	mov    %edx,%eax
c01054da:	ba 00 00 00 00       	mov    $0x0,%edx
c01054df:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01054e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01054e8:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01054eb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01054ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01054f3:	89 c7                	mov    %eax,%edi
c01054f5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01054fb:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01054fe:	89 d0                	mov    %edx,%eax
c0105500:	83 e0 00             	and    $0x0,%eax
c0105503:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105506:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105509:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010550c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010550f:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105512:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105518:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010551b:	77 3a                	ja     c0105557 <page_init+0x3c4>
c010551d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105520:	72 05                	jb     c0105527 <page_init+0x394>
c0105522:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105525:	73 30                	jae    c0105557 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105527:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010552a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010552d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105530:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105533:	29 c8                	sub    %ecx,%eax
c0105535:	19 da                	sbb    %ebx,%edx
c0105537:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010553b:	c1 ea 0c             	shr    $0xc,%edx
c010553e:	89 c3                	mov    %eax,%ebx
c0105540:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105543:	89 04 24             	mov    %eax,(%esp)
c0105546:	e8 8c f8 ff ff       	call   c0104dd7 <pa2page>
c010554b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010554f:	89 04 24             	mov    %eax,(%esp)
c0105552:	e8 55 fb ff ff       	call   c01050ac <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0105557:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010555b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010555e:	8b 00                	mov    (%eax),%eax
c0105560:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105563:	0f 8f 7e fe ff ff    	jg     c01053e7 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0105569:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010556f:	5b                   	pop    %ebx
c0105570:	5e                   	pop    %esi
c0105571:	5f                   	pop    %edi
c0105572:	5d                   	pop    %ebp
c0105573:	c3                   	ret    

c0105574 <enable_paging>:

static void
enable_paging(void) {
c0105574:	55                   	push   %ebp
c0105575:	89 e5                	mov    %esp,%ebp
c0105577:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010557a:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c010557f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105582:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105585:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0105588:	0f 20 c0             	mov    %cr0,%eax
c010558b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010558e:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105591:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0105594:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010559b:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010559f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01055a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a8:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01055ab:	c9                   	leave  
c01055ac:	c3                   	ret    

c01055ad <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01055ad:	55                   	push   %ebp
c01055ae:	89 e5                	mov    %esp,%ebp
c01055b0:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01055b3:	8b 45 14             	mov    0x14(%ebp),%eax
c01055b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055b9:	31 d0                	xor    %edx,%eax
c01055bb:	25 ff 0f 00 00       	and    $0xfff,%eax
c01055c0:	85 c0                	test   %eax,%eax
c01055c2:	74 24                	je     c01055e8 <boot_map_segment+0x3b>
c01055c4:	c7 44 24 0c fa cb 10 	movl   $0xc010cbfa,0xc(%esp)
c01055cb:	c0 
c01055cc:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01055d3:	c0 
c01055d4:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01055db:	00 
c01055dc:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01055e3:	e8 ed b7 ff ff       	call   c0100dd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01055e8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01055ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01055f7:	89 c2                	mov    %eax,%edx
c01055f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01055fc:	01 c2                	add    %eax,%edx
c01055fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105601:	01 d0                	add    %edx,%eax
c0105603:	83 e8 01             	sub    $0x1,%eax
c0105606:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105609:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010560c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105611:	f7 75 f0             	divl   -0x10(%ebp)
c0105614:	89 d0                	mov    %edx,%eax
c0105616:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105619:	29 c2                	sub    %eax,%edx
c010561b:	89 d0                	mov    %edx,%eax
c010561d:	c1 e8 0c             	shr    $0xc,%eax
c0105620:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105626:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105629:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010562c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105631:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105634:	8b 45 14             	mov    0x14(%ebp),%eax
c0105637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010563a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010563d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105642:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105645:	eb 6b                	jmp    c01056b2 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105647:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010564e:	00 
c010564f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105652:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105656:	8b 45 08             	mov    0x8(%ebp),%eax
c0105659:	89 04 24             	mov    %eax,(%esp)
c010565c:	e8 d1 01 00 00       	call   c0105832 <get_pte>
c0105661:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105664:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105668:	75 24                	jne    c010568e <boot_map_segment+0xe1>
c010566a:	c7 44 24 0c 26 cc 10 	movl   $0xc010cc26,0xc(%esp)
c0105671:	c0 
c0105672:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105679:	c0 
c010567a:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105681:	00 
c0105682:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105689:	e8 47 b7 ff ff       	call   c0100dd5 <__panic>
        *ptep = pa | PTE_P | perm;
c010568e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105691:	8b 55 14             	mov    0x14(%ebp),%edx
c0105694:	09 d0                	or     %edx,%eax
c0105696:	83 c8 01             	or     $0x1,%eax
c0105699:	89 c2                	mov    %eax,%edx
c010569b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010569e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01056a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01056a4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01056ab:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01056b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056b6:	75 8f                	jne    c0105647 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01056b8:	c9                   	leave  
c01056b9:	c3                   	ret    

c01056ba <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01056ba:	55                   	push   %ebp
c01056bb:	89 e5                	mov    %esp,%ebp
c01056bd:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01056c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056c7:	e8 ff f9 ff ff       	call   c01050cb <alloc_pages>
c01056cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01056cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056d3:	75 1c                	jne    c01056f1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01056d5:	c7 44 24 08 33 cc 10 	movl   $0xc010cc33,0x8(%esp)
c01056dc:	c0 
c01056dd:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01056e4:	00 
c01056e5:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01056ec:	e8 e4 b6 ff ff       	call   c0100dd5 <__panic>
    }
    return page2kva(p);
c01056f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f4:	89 04 24             	mov    %eax,(%esp)
c01056f7:	e8 20 f7 ff ff       	call   c0104e1c <page2kva>
}
c01056fc:	c9                   	leave  
c01056fd:	c3                   	ret    

c01056fe <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01056fe:	55                   	push   %ebp
c01056ff:	89 e5                	mov    %esp,%ebp
c0105701:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105704:	e8 70 f9 ff ff       	call   c0105079 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105709:	e8 85 fa ff ff       	call   c0105193 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010570e:	e8 62 09 00 00       	call   c0106075 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105713:	e8 a2 ff ff ff       	call   c01056ba <boot_alloc_page>
c0105718:	a3 e4 ce 19 c0       	mov    %eax,0xc019cee4
    memset(boot_pgdir, 0, PGSIZE);
c010571d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105722:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105729:	00 
c010572a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105731:	00 
c0105732:	89 04 24             	mov    %eax,(%esp)
c0105735:	e8 74 64 00 00       	call   c010bbae <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010573a:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010573f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105742:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105749:	77 23                	ja     c010576e <pmm_init+0x70>
c010574b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010574e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105752:	c7 44 24 08 c8 cb 10 	movl   $0xc010cbc8,0x8(%esp)
c0105759:	c0 
c010575a:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105761:	00 
c0105762:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105769:	e8 67 b6 ff ff       	call   c0100dd5 <__panic>
c010576e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105771:	05 00 00 00 40       	add    $0x40000000,%eax
c0105776:	a3 c8 ef 19 c0       	mov    %eax,0xc019efc8

    check_pgdir();
c010577b:	e8 13 09 00 00       	call   c0106093 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105780:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105785:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010578b:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0105790:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105793:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010579a:	77 23                	ja     c01057bf <pmm_init+0xc1>
c010579c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010579f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057a3:	c7 44 24 08 c8 cb 10 	movl   $0xc010cbc8,0x8(%esp)
c01057aa:	c0 
c01057ab:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01057b2:	00 
c01057b3:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01057ba:	e8 16 b6 ff ff       	call   c0100dd5 <__panic>
c01057bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057c2:	05 00 00 00 40       	add    $0x40000000,%eax
c01057c7:	83 c8 03             	or     $0x3,%eax
c01057ca:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01057cc:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01057d1:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01057d8:	00 
c01057d9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01057e0:	00 
c01057e1:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01057e8:	38 
c01057e9:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01057f0:	c0 
c01057f1:	89 04 24             	mov    %eax,(%esp)
c01057f4:	e8 b4 fd ff ff       	call   c01055ad <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01057f9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01057fe:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c0105804:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010580a:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010580c:	e8 63 fd ff ff       	call   c0105574 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105811:	e8 74 f7 ff ff       	call   c0104f8a <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105816:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010581b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105821:	e8 08 0f 00 00       	call   c010672e <check_boot_pgdir>

    print_pgdir();
c0105826:	e8 95 13 00 00       	call   c0106bc0 <print_pgdir>
    
    kmalloc_init();
c010582b:	e8 e6 f2 ff ff       	call   c0104b16 <kmalloc_init>

}
c0105830:	c9                   	leave  
c0105831:	c3                   	ret    

c0105832 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105832:	55                   	push   %ebp
c0105833:	89 e5                	mov    %esp,%ebp
c0105835:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    //typedef uintptr_t pde_t;
    pde_t *pdep = &pgdir[PDX(la)];  // (1)获取页表
c0105838:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583b:	c1 e8 16             	shr    $0x16,%eax
c010583e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105845:	8b 45 08             	mov    0x8(%ebp),%eax
c0105848:	01 d0                	add    %edx,%eax
c010584a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))             // (2)假设页目录项不存在
c010584d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105850:	8b 00                	mov    (%eax),%eax
c0105852:	83 e0 01             	and    $0x1,%eax
c0105855:	85 c0                	test   %eax,%eax
c0105857:	0f 85 af 00 00 00    	jne    c010590c <get_pte+0xda>
    {      
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) // (3) check if creating is needed, then alloc page for page table
c010585d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105861:	74 15                	je     c0105878 <get_pte+0x46>
c0105863:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010586a:	e8 5c f8 ff ff       	call   c01050cb <alloc_pages>
c010586f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105876:	75 0a                	jne    c0105882 <get_pte+0x50>
        {    //假如不需要分配或是分配失败
            return NULL;
c0105878:	b8 00 00 00 00       	mov    $0x0,%eax
c010587d:	e9 e6 00 00 00       	jmp    c0105968 <get_pte+0x136>
        }
        set_page_ref(page, 1);                      // (4)设置被引用1次
c0105882:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105889:	00 
c010588a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010588d:	89 04 24             	mov    %eax,(%esp)
c0105890:	e8 3b f6 ff ff       	call   c0104ed0 <set_page_ref>
        uintptr_t pa = page2pa(page);                  // (5)得到该页物理地址
c0105895:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105898:	89 04 24             	mov    %eax,(%esp)
c010589b:	e8 21 f5 ff ff       	call   c0104dc1 <page2pa>
c01058a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                  // (6)物理地址转虚拟地址，并初始化
c01058a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058ac:	c1 e8 0c             	shr    $0xc,%eax
c01058af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058b2:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01058b7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01058ba:	72 23                	jb     c01058df <get_pte+0xad>
c01058bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058c3:	c7 44 24 08 24 cb 10 	movl   $0xc010cb24,0x8(%esp)
c01058ca:	c0 
c01058cb:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
c01058d2:	00 
c01058d3:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01058da:	e8 f6 b4 ff ff       	call   c0100dd5 <__panic>
c01058df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058e2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01058e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01058ee:	00 
c01058ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01058f6:	00 
c01058f7:	89 04 24             	mov    %eax,(%esp)
c01058fa:	e8 af 62 00 00       	call   c010bbae <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;            // (7)设置可读，可写，存在位
c01058ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105902:	83 c8 07             	or     $0x7,%eax
c0105905:	89 c2                	mov    %eax,%edx
c0105907:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010590a:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];     // (8) return page table entry
c010590c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010590f:	8b 00                	mov    (%eax),%eax
c0105911:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105916:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105919:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010591c:	c1 e8 0c             	shr    $0xc,%eax
c010591f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105922:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0105927:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010592a:	72 23                	jb     c010594f <get_pte+0x11d>
c010592c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010592f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105933:	c7 44 24 08 24 cb 10 	movl   $0xc010cb24,0x8(%esp)
c010593a:	c0 
c010593b:	c7 44 24 04 9d 01 00 	movl   $0x19d,0x4(%esp)
c0105942:	00 
c0105943:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010594a:	e8 86 b4 ff ff       	call   c0100dd5 <__panic>
c010594f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105952:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105957:	8b 55 0c             	mov    0xc(%ebp),%edx
c010595a:	c1 ea 0c             	shr    $0xc,%edx
c010595d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105963:	c1 e2 02             	shl    $0x2,%edx
c0105966:	01 d0                	add    %edx,%eax
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址，再转成虚拟地址
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址
}
c0105968:	c9                   	leave  
c0105969:	c3                   	ret    

c010596a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010596a:	55                   	push   %ebp
c010596b:	89 e5                	mov    %esp,%ebp
c010596d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105970:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105977:	00 
c0105978:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010597f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105982:	89 04 24             	mov    %eax,(%esp)
c0105985:	e8 a8 fe ff ff       	call   c0105832 <get_pte>
c010598a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010598d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105991:	74 08                	je     c010599b <get_page+0x31>
        *ptep_store = ptep;
c0105993:	8b 45 10             	mov    0x10(%ebp),%eax
c0105996:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105999:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010599b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010599f:	74 1b                	je     c01059bc <get_page+0x52>
c01059a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059a4:	8b 00                	mov    (%eax),%eax
c01059a6:	83 e0 01             	and    $0x1,%eax
c01059a9:	85 c0                	test   %eax,%eax
c01059ab:	74 0f                	je     c01059bc <get_page+0x52>
        return pa2page(*ptep);
c01059ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059b0:	8b 00                	mov    (%eax),%eax
c01059b2:	89 04 24             	mov    %eax,(%esp)
c01059b5:	e8 1d f4 ff ff       	call   c0104dd7 <pa2page>
c01059ba:	eb 05                	jmp    c01059c1 <get_page+0x57>
    }
    return NULL;
c01059bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059c1:	c9                   	leave  
c01059c2:	c3                   	ret    

c01059c3 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01059c3:	55                   	push   %ebp
c01059c4:	89 e5                	mov    %esp,%ebp
c01059c6:	83 ec 28             	sub    $0x28,%esp
                                  //(6) flush tlb
    }
#endif

//(1) check if this page table entry is present
    if (*ptep & PTE_P) { 
c01059c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01059cc:	8b 00                	mov    (%eax),%eax
c01059ce:	83 e0 01             	and    $0x1,%eax
c01059d1:	85 c0                	test   %eax,%eax
c01059d3:	74 52                	je     c0105a27 <page_remove_pte+0x64>
//(2) find corresponding page to pte
        struct Page *page = pte2page(*ptep); 
c01059d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01059d8:	8b 00                	mov    (%eax),%eax
c01059da:	89 04 24             	mov    %eax,(%esp)
c01059dd:	e8 8e f4 ff ff       	call   c0104e70 <pte2page>
c01059e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//(3) decrease page reference
        page_ref_dec(page);
c01059e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059e8:	89 04 24             	mov    %eax,(%esp)
c01059eb:	e8 04 f5 ff ff       	call   c0104ef4 <page_ref_dec>
//(4) and free this page when page reference reachs 0
        if (page -> ref == 0) {
c01059f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059f3:	8b 00                	mov    (%eax),%eax
c01059f5:	85 c0                	test   %eax,%eax
c01059f7:	75 13                	jne    c0105a0c <page_remove_pte+0x49>
            free_page(page);
c01059f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a00:	00 
c0105a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a04:	89 04 24             	mov    %eax,(%esp)
c0105a07:	e8 2a f7 ff ff       	call   c0105136 <free_pages>
        }
//(5) clear second page table entry
        *ptep = 0;
c0105a0c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
//(6) flush tlb
        tlb_invalidate(pgdir, la);
c0105a15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1f:	89 04 24             	mov    %eax,(%esp)
c0105a22:	e8 1d 05 00 00       	call   c0105f44 <tlb_invalidate>
    }
}
c0105a27:	c9                   	leave  
c0105a28:	c3                   	ret    

c0105a29 <unmap_range>:

void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105a29:	55                   	push   %ebp
c0105a2a:	89 e5                	mov    %esp,%ebp
c0105a2c:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a32:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105a37:	85 c0                	test   %eax,%eax
c0105a39:	75 0c                	jne    c0105a47 <unmap_range+0x1e>
c0105a3b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a3e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105a43:	85 c0                	test   %eax,%eax
c0105a45:	74 24                	je     c0105a6b <unmap_range+0x42>
c0105a47:	c7 44 24 0c 4c cc 10 	movl   $0xc010cc4c,0xc(%esp)
c0105a4e:	c0 
c0105a4f:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105a56:	c0 
c0105a57:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c0105a5e:	00 
c0105a5f:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105a66:	e8 6a b3 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105a6b:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105a72:	76 11                	jbe    c0105a85 <unmap_range+0x5c>
c0105a74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a77:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105a7a:	73 09                	jae    c0105a85 <unmap_range+0x5c>
c0105a7c:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105a83:	76 24                	jbe    c0105aa9 <unmap_range+0x80>
c0105a85:	c7 44 24 0c 75 cc 10 	movl   $0xc010cc75,0xc(%esp)
c0105a8c:	c0 
c0105a8d:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105a94:	c0 
c0105a95:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0105a9c:	00 
c0105a9d:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105aa4:	e8 2c b3 ff ff       	call   c0100dd5 <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c0105aa9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ab0:	00 
c0105ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abb:	89 04 24             	mov    %eax,(%esp)
c0105abe:	e8 6f fd ff ff       	call   c0105832 <get_pte>
c0105ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105aca:	75 18                	jne    c0105ae4 <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105acc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acf:	05 00 00 40 00       	add    $0x400000,%eax
c0105ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ada:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105adf:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c0105ae2:	eb 29                	jmp    c0105b0d <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c0105ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae7:	8b 00                	mov    (%eax),%eax
c0105ae9:	85 c0                	test   %eax,%eax
c0105aeb:	74 19                	je     c0105b06 <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c0105aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105af4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105afe:	89 04 24             	mov    %eax,(%esp)
c0105b01:	e8 bd fe ff ff       	call   c01059c3 <page_remove_pte>
        }
        start += PGSIZE;
c0105b06:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b11:	74 08                	je     c0105b1b <unmap_range+0xf2>
c0105b13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b16:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105b19:	72 8e                	jb     c0105aa9 <unmap_range+0x80>
}
c0105b1b:	c9                   	leave  
c0105b1c:	c3                   	ret    

c0105b1d <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105b1d:	55                   	push   %ebp
c0105b1e:	89 e5                	mov    %esp,%ebp
c0105b20:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105b23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b26:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105b2b:	85 c0                	test   %eax,%eax
c0105b2d:	75 0c                	jne    c0105b3b <exit_range+0x1e>
c0105b2f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b32:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105b37:	85 c0                	test   %eax,%eax
c0105b39:	74 24                	je     c0105b5f <exit_range+0x42>
c0105b3b:	c7 44 24 0c 4c cc 10 	movl   $0xc010cc4c,0xc(%esp)
c0105b42:	c0 
c0105b43:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105b4a:	c0 
c0105b4b:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0105b52:	00 
c0105b53:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105b5a:	e8 76 b2 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105b5f:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105b66:	76 11                	jbe    c0105b79 <exit_range+0x5c>
c0105b68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6b:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105b6e:	73 09                	jae    c0105b79 <exit_range+0x5c>
c0105b70:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105b77:	76 24                	jbe    c0105b9d <exit_range+0x80>
c0105b79:	c7 44 24 0c 75 cc 10 	movl   $0xc010cc75,0xc(%esp)
c0105b80:	c0 
c0105b81:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105b88:	c0 
c0105b89:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0105b90:	00 
c0105b91:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105b98:	e8 38 b2 ff ff       	call   c0100dd5 <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c0105b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ba6:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105bab:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c0105bae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb1:	c1 e8 16             	shr    $0x16,%eax
c0105bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc4:	01 d0                	add    %edx,%eax
c0105bc6:	8b 00                	mov    (%eax),%eax
c0105bc8:	83 e0 01             	and    $0x1,%eax
c0105bcb:	85 c0                	test   %eax,%eax
c0105bcd:	74 3e                	je     c0105c0d <exit_range+0xf0>
            free_page(pde2page(pgdir[pde_idx]));
c0105bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdc:	01 d0                	add    %edx,%eax
c0105bde:	8b 00                	mov    (%eax),%eax
c0105be0:	89 04 24             	mov    %eax,(%esp)
c0105be3:	e8 c6 f2 ff ff       	call   c0104eae <pde2page>
c0105be8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105bef:	00 
c0105bf0:	89 04 24             	mov    %eax,(%esp)
c0105bf3:	e8 3e f5 ff ff       	call   c0105136 <free_pages>
            pgdir[pde_idx] = 0;
c0105bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c05:	01 d0                	add    %edx,%eax
c0105c07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c0105c0d:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c18:	74 08                	je     c0105c22 <exit_range+0x105>
c0105c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c1d:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c20:	72 8c                	jb     c0105bae <exit_range+0x91>
}
c0105c22:	c9                   	leave  
c0105c23:	c3                   	ret    

c0105c24 <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c0105c24:	55                   	push   %ebp
c0105c25:	89 e5                	mov    %esp,%ebp
c0105c27:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105c2a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c2d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105c32:	85 c0                	test   %eax,%eax
c0105c34:	75 0c                	jne    c0105c42 <copy_range+0x1e>
c0105c36:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c39:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105c3e:	85 c0                	test   %eax,%eax
c0105c40:	74 24                	je     c0105c66 <copy_range+0x42>
c0105c42:	c7 44 24 0c 4c cc 10 	movl   $0xc010cc4c,0xc(%esp)
c0105c49:	c0 
c0105c4a:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105c51:	c0 
c0105c52:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0105c59:	00 
c0105c5a:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105c61:	e8 6f b1 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105c66:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c0105c6d:	76 11                	jbe    c0105c80 <copy_range+0x5c>
c0105c6f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c72:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105c75:	73 09                	jae    c0105c80 <copy_range+0x5c>
c0105c77:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c0105c7e:	76 24                	jbe    c0105ca4 <copy_range+0x80>
c0105c80:	c7 44 24 0c 75 cc 10 	movl   $0xc010cc75,0xc(%esp)
c0105c87:	c0 
c0105c88:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105c8f:	c0 
c0105c90:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0105c97:	00 
c0105c98:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105c9f:	e8 31 b1 ff ff       	call   c0100dd5 <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c0105ca4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105cab:	00 
c0105cac:	8b 45 10             	mov    0x10(%ebp),%eax
c0105caf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb6:	89 04 24             	mov    %eax,(%esp)
c0105cb9:	e8 74 fb ff ff       	call   c0105832 <get_pte>
c0105cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105cc5:	75 1b                	jne    c0105ce2 <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105cc7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cca:	05 00 00 40 00       	add    $0x400000,%eax
c0105ccf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cd5:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105cda:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105cdd:	e9 4c 01 00 00       	jmp    c0105e2e <copy_range+0x20a>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ce5:	8b 00                	mov    (%eax),%eax
c0105ce7:	83 e0 01             	and    $0x1,%eax
c0105cea:	85 c0                	test   %eax,%eax
c0105cec:	0f 84 35 01 00 00    	je     c0105e27 <copy_range+0x203>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105cf2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105cf9:	00 
c0105cfa:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d04:	89 04 24             	mov    %eax,(%esp)
c0105d07:	e8 26 fb ff ff       	call   c0105832 <get_pte>
c0105d0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105d13:	75 0a                	jne    c0105d1f <copy_range+0xfb>
                return -E_NO_MEM;
c0105d15:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105d1a:	e9 26 01 00 00       	jmp    c0105e45 <copy_range+0x221>
            }
        uint32_t perm = (*ptep & PTE_USER);
c0105d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d22:	8b 00                	mov    (%eax),%eax
c0105d24:	83 e0 07             	and    $0x7,%eax
c0105d27:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d2d:	8b 00                	mov    (%eax),%eax
c0105d2f:	89 04 24             	mov    %eax,(%esp)
c0105d32:	e8 39 f1 ff ff       	call   c0104e70 <pte2page>
c0105d37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105d3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105d41:	e8 85 f3 ff ff       	call   c01050cb <alloc_pages>
c0105d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105d4d:	75 24                	jne    c0105d73 <copy_range+0x14f>
c0105d4f:	c7 44 24 0c 8d cc 10 	movl   $0xc010cc8d,0xc(%esp)
c0105d56:	c0 
c0105d57:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105d5e:	c0 
c0105d5f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0105d66:	00 
c0105d67:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105d6e:	e8 62 b0 ff ff       	call   c0100dd5 <__panic>
        assert(npage!=NULL);
c0105d73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105d77:	75 24                	jne    c0105d9d <copy_range+0x179>
c0105d79:	c7 44 24 0c 98 cc 10 	movl   $0xc010cc98,0xc(%esp)
c0105d80:	c0 
c0105d81:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105d88:	c0 
c0105d89:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0105d90:	00 
c0105d91:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105d98:	e8 38 b0 ff ff       	call   c0100dd5 <__panic>
        int ret=0;
c0105d9d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of npage with the linear addr start
         */


        uint32_t src_kvaddr = page2kva(page);
c0105da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105da7:	89 04 24             	mov    %eax,(%esp)
c0105daa:	e8 6d f0 ff ff       	call   c0104e1c <page2kva>
c0105daf:	89 45 d8             	mov    %eax,-0x28(%ebp)
        uint32_t dst_kvaddr = page2kva(npage);
c0105db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105db5:	89 04 24             	mov    %eax,(%esp)
c0105db8:	e8 5f f0 ff ff       	call   c0104e1c <page2kva>
c0105dbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
c0105dc0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105dc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105dc6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105dcd:	00 
c0105dce:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dd2:	89 04 24             	mov    %eax,(%esp)
c0105dd5:	e8 b6 5e 00 00       	call   c010bc90 <memcpy>

        ret = page_insert(to, npage, start, perm);	
c0105dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ddd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105de1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105de4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105deb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105def:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df2:	89 04 24             	mov    %eax,(%esp)
c0105df5:	e8 91 00 00 00       	call   c0105e8b <page_insert>
c0105dfa:	89 45 dc             	mov    %eax,-0x24(%ebp)

        assert(ret == 0);
c0105dfd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105e01:	74 24                	je     c0105e27 <copy_range+0x203>
c0105e03:	c7 44 24 0c a4 cc 10 	movl   $0xc010cca4,0xc(%esp)
c0105e0a:	c0 
c0105e0b:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0105e12:	c0 
c0105e13:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105e1a:	00 
c0105e1b:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105e22:	e8 ae af ff ff       	call   c0100dd5 <__panic>
        }
        start += PGSIZE;
c0105e27:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105e2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e32:	74 0c                	je     c0105e40 <copy_range+0x21c>
c0105e34:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e37:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105e3a:	0f 82 64 fe ff ff    	jb     c0105ca4 <copy_range+0x80>
    return 0;
c0105e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e45:	c9                   	leave  
c0105e46:	c3                   	ret    

c0105e47 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105e47:	55                   	push   %ebp
c0105e48:	89 e5                	mov    %esp,%ebp
c0105e4a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105e4d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e54:	00 
c0105e55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5f:	89 04 24             	mov    %eax,(%esp)
c0105e62:	e8 cb f9 ff ff       	call   c0105832 <get_pte>
c0105e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e6e:	74 19                	je     c0105e89 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e73:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e81:	89 04 24             	mov    %eax,(%esp)
c0105e84:	e8 3a fb ff ff       	call   c01059c3 <page_remove_pte>
    }
}
c0105e89:	c9                   	leave  
c0105e8a:	c3                   	ret    

c0105e8b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105e8b:	55                   	push   %ebp
c0105e8c:	89 e5                	mov    %esp,%ebp
c0105e8e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105e91:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105e98:	00 
c0105e99:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea3:	89 04 24             	mov    %eax,(%esp)
c0105ea6:	e8 87 f9 ff ff       	call   c0105832 <get_pte>
c0105eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105eb2:	75 0a                	jne    c0105ebe <page_insert+0x33>
        return -E_NO_MEM;
c0105eb4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105eb9:	e9 84 00 00 00       	jmp    c0105f42 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ec1:	89 04 24             	mov    %eax,(%esp)
c0105ec4:	e8 14 f0 ff ff       	call   c0104edd <page_ref_inc>
    if (*ptep & PTE_P) {
c0105ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ecc:	8b 00                	mov    (%eax),%eax
c0105ece:	83 e0 01             	and    $0x1,%eax
c0105ed1:	85 c0                	test   %eax,%eax
c0105ed3:	74 3e                	je     c0105f13 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ed8:	8b 00                	mov    (%eax),%eax
c0105eda:	89 04 24             	mov    %eax,(%esp)
c0105edd:	e8 8e ef ff ff       	call   c0104e70 <pte2page>
c0105ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105eeb:	75 0d                	jne    c0105efa <page_insert+0x6f>
            page_ref_dec(page);
c0105eed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef0:	89 04 24             	mov    %eax,(%esp)
c0105ef3:	e8 fc ef ff ff       	call   c0104ef4 <page_ref_dec>
c0105ef8:	eb 19                	jmp    c0105f13 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105efd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f01:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0b:	89 04 24             	mov    %eax,(%esp)
c0105f0e:	e8 b0 fa ff ff       	call   c01059c3 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105f13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f16:	89 04 24             	mov    %eax,(%esp)
c0105f19:	e8 a3 ee ff ff       	call   c0104dc1 <page2pa>
c0105f1e:	0b 45 14             	or     0x14(%ebp),%eax
c0105f21:	83 c8 01             	or     $0x1,%eax
c0105f24:	89 c2                	mov    %eax,%edx
c0105f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f29:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105f2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f35:	89 04 24             	mov    %eax,(%esp)
c0105f38:	e8 07 00 00 00       	call   c0105f44 <tlb_invalidate>
    return 0;
c0105f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f42:	c9                   	leave  
c0105f43:	c3                   	ret    

c0105f44 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105f44:	55                   	push   %ebp
c0105f45:	89 e5                	mov    %esp,%ebp
c0105f47:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105f4a:	0f 20 d8             	mov    %cr3,%eax
c0105f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105f53:	89 c2                	mov    %eax,%edx
c0105f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f5b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105f62:	77 23                	ja     c0105f87 <tlb_invalidate+0x43>
c0105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f67:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f6b:	c7 44 24 08 c8 cb 10 	movl   $0xc010cbc8,0x8(%esp)
c0105f72:	c0 
c0105f73:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c0105f7a:	00 
c0105f7b:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0105f82:	e8 4e ae ff ff       	call   c0100dd5 <__panic>
c0105f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f8a:	05 00 00 00 40       	add    $0x40000000,%eax
c0105f8f:	39 c2                	cmp    %eax,%edx
c0105f91:	75 0c                	jne    c0105f9f <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105f93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f96:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f9c:	0f 01 38             	invlpg (%eax)
    }
}
c0105f9f:	c9                   	leave  
c0105fa0:	c3                   	ret    

c0105fa1 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105fa1:	55                   	push   %ebp
c0105fa2:	89 e5                	mov    %esp,%ebp
c0105fa4:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105fa7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105fae:	e8 18 f1 ff ff       	call   c01050cb <alloc_pages>
c0105fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105fba:	0f 84 b0 00 00 00    	je     c0106070 <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fca:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd8:	89 04 24             	mov    %eax,(%esp)
c0105fdb:	e8 ab fe ff ff       	call   c0105e8b <page_insert>
c0105fe0:	85 c0                	test   %eax,%eax
c0105fe2:	74 1a                	je     c0105ffe <pgdir_alloc_page+0x5d>
            free_page(page);
c0105fe4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105feb:	00 
c0105fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fef:	89 04 24             	mov    %eax,(%esp)
c0105ff2:	e8 3f f1 ff ff       	call   c0105136 <free_pages>
            return NULL;
c0105ff7:	b8 00 00 00 00       	mov    $0x0,%eax
c0105ffc:	eb 75                	jmp    c0106073 <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0105ffe:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0106003:	85 c0                	test   %eax,%eax
c0106005:	74 69                	je     c0106070 <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c0106007:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c010600c:	85 c0                	test   %eax,%eax
c010600e:	74 60                	je     c0106070 <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0106010:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0106015:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010601c:	00 
c010601d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106020:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106024:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106027:	89 54 24 04          	mov    %edx,0x4(%esp)
c010602b:	89 04 24             	mov    %eax,(%esp)
c010602e:	e8 3e 0e 00 00       	call   c0106e71 <swap_map_swappable>
                page->pra_vaddr=la;
c0106033:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106036:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106039:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c010603c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010603f:	89 04 24             	mov    %eax,(%esp)
c0106042:	e8 7f ee ff ff       	call   c0104ec6 <page_ref>
c0106047:	83 f8 01             	cmp    $0x1,%eax
c010604a:	74 24                	je     c0106070 <pgdir_alloc_page+0xcf>
c010604c:	c7 44 24 0c ad cc 10 	movl   $0xc010ccad,0xc(%esp)
c0106053:	c0 
c0106054:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010605b:	c0 
c010605c:	c7 44 24 04 7c 02 00 	movl   $0x27c,0x4(%esp)
c0106063:	00 
c0106064:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010606b:	e8 65 ad ff ff       	call   c0100dd5 <__panic>
            }
        }

    }

    return page;
c0106070:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106073:	c9                   	leave  
c0106074:	c3                   	ret    

c0106075 <check_alloc_page>:

static void
check_alloc_page(void) {
c0106075:	55                   	push   %ebp
c0106076:	89 e5                	mov    %esp,%ebp
c0106078:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010607b:	a1 c4 ef 19 c0       	mov    0xc019efc4,%eax
c0106080:	8b 40 18             	mov    0x18(%eax),%eax
c0106083:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0106085:	c7 04 24 c4 cc 10 c0 	movl   $0xc010ccc4,(%esp)
c010608c:	e8 c2 a2 ff ff       	call   c0100353 <cprintf>
}
c0106091:	c9                   	leave  
c0106092:	c3                   	ret    

c0106093 <check_pgdir>:

static void
check_pgdir(void) {
c0106093:	55                   	push   %ebp
c0106094:	89 e5                	mov    %esp,%ebp
c0106096:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0106099:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c010609e:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01060a3:	76 24                	jbe    c01060c9 <check_pgdir+0x36>
c01060a5:	c7 44 24 0c e3 cc 10 	movl   $0xc010cce3,0xc(%esp)
c01060ac:	c0 
c01060ad:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01060b4:	c0 
c01060b5:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c01060bc:	00 
c01060bd:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01060c4:	e8 0c ad ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01060c9:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01060ce:	85 c0                	test   %eax,%eax
c01060d0:	74 0e                	je     c01060e0 <check_pgdir+0x4d>
c01060d2:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01060d7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01060dc:	85 c0                	test   %eax,%eax
c01060de:	74 24                	je     c0106104 <check_pgdir+0x71>
c01060e0:	c7 44 24 0c 00 cd 10 	movl   $0xc010cd00,0xc(%esp)
c01060e7:	c0 
c01060e8:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01060ef:	c0 
c01060f0:	c7 44 24 04 95 02 00 	movl   $0x295,0x4(%esp)
c01060f7:	00 
c01060f8:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01060ff:	e8 d1 ac ff ff       	call   c0100dd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0106104:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106109:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106110:	00 
c0106111:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106118:	00 
c0106119:	89 04 24             	mov    %eax,(%esp)
c010611c:	e8 49 f8 ff ff       	call   c010596a <get_page>
c0106121:	85 c0                	test   %eax,%eax
c0106123:	74 24                	je     c0106149 <check_pgdir+0xb6>
c0106125:	c7 44 24 0c 38 cd 10 	movl   $0xc010cd38,0xc(%esp)
c010612c:	c0 
c010612d:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106134:	c0 
c0106135:	c7 44 24 04 96 02 00 	movl   $0x296,0x4(%esp)
c010613c:	00 
c010613d:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106144:	e8 8c ac ff ff       	call   c0100dd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0106149:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106150:	e8 76 ef ff ff       	call   c01050cb <alloc_pages>
c0106155:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0106158:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010615d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106164:	00 
c0106165:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010616c:	00 
c010616d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106170:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106174:	89 04 24             	mov    %eax,(%esp)
c0106177:	e8 0f fd ff ff       	call   c0105e8b <page_insert>
c010617c:	85 c0                	test   %eax,%eax
c010617e:	74 24                	je     c01061a4 <check_pgdir+0x111>
c0106180:	c7 44 24 0c 60 cd 10 	movl   $0xc010cd60,0xc(%esp)
c0106187:	c0 
c0106188:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010618f:	c0 
c0106190:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c0106197:	00 
c0106198:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010619f:	e8 31 ac ff ff       	call   c0100dd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01061a4:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01061a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01061b0:	00 
c01061b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01061b8:	00 
c01061b9:	89 04 24             	mov    %eax,(%esp)
c01061bc:	e8 71 f6 ff ff       	call   c0105832 <get_pte>
c01061c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01061c8:	75 24                	jne    c01061ee <check_pgdir+0x15b>
c01061ca:	c7 44 24 0c 8c cd 10 	movl   $0xc010cd8c,0xc(%esp)
c01061d1:	c0 
c01061d2:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01061d9:	c0 
c01061da:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c01061e1:	00 
c01061e2:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01061e9:	e8 e7 ab ff ff       	call   c0100dd5 <__panic>
    assert(pa2page(*ptep) == p1);
c01061ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061f1:	8b 00                	mov    (%eax),%eax
c01061f3:	89 04 24             	mov    %eax,(%esp)
c01061f6:	e8 dc eb ff ff       	call   c0104dd7 <pa2page>
c01061fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01061fe:	74 24                	je     c0106224 <check_pgdir+0x191>
c0106200:	c7 44 24 0c b9 cd 10 	movl   $0xc010cdb9,0xc(%esp)
c0106207:	c0 
c0106208:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010620f:	c0 
c0106210:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c0106217:	00 
c0106218:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010621f:	e8 b1 ab ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 1);
c0106224:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106227:	89 04 24             	mov    %eax,(%esp)
c010622a:	e8 97 ec ff ff       	call   c0104ec6 <page_ref>
c010622f:	83 f8 01             	cmp    $0x1,%eax
c0106232:	74 24                	je     c0106258 <check_pgdir+0x1c5>
c0106234:	c7 44 24 0c ce cd 10 	movl   $0xc010cdce,0xc(%esp)
c010623b:	c0 
c010623c:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106243:	c0 
c0106244:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c010624b:	00 
c010624c:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106253:	e8 7d ab ff ff       	call   c0100dd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0106258:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010625d:	8b 00                	mov    (%eax),%eax
c010625f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106264:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106267:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010626a:	c1 e8 0c             	shr    $0xc,%eax
c010626d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106270:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106275:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106278:	72 23                	jb     c010629d <check_pgdir+0x20a>
c010627a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010627d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106281:	c7 44 24 08 24 cb 10 	movl   $0xc010cb24,0x8(%esp)
c0106288:	c0 
c0106289:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
c0106290:	00 
c0106291:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106298:	e8 38 ab ff ff       	call   c0100dd5 <__panic>
c010629d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062a0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01062a5:	83 c0 04             	add    $0x4,%eax
c01062a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01062ab:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01062b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062b7:	00 
c01062b8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01062bf:	00 
c01062c0:	89 04 24             	mov    %eax,(%esp)
c01062c3:	e8 6a f5 ff ff       	call   c0105832 <get_pte>
c01062c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01062cb:	74 24                	je     c01062f1 <check_pgdir+0x25e>
c01062cd:	c7 44 24 0c e0 cd 10 	movl   $0xc010cde0,0xc(%esp)
c01062d4:	c0 
c01062d5:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01062dc:	c0 
c01062dd:	c7 44 24 04 a2 02 00 	movl   $0x2a2,0x4(%esp)
c01062e4:	00 
c01062e5:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01062ec:	e8 e4 aa ff ff       	call   c0100dd5 <__panic>

    p2 = alloc_page();
c01062f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062f8:	e8 ce ed ff ff       	call   c01050cb <alloc_pages>
c01062fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0106300:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106305:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010630c:	00 
c010630d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0106314:	00 
c0106315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106318:	89 54 24 04          	mov    %edx,0x4(%esp)
c010631c:	89 04 24             	mov    %eax,(%esp)
c010631f:	e8 67 fb ff ff       	call   c0105e8b <page_insert>
c0106324:	85 c0                	test   %eax,%eax
c0106326:	74 24                	je     c010634c <check_pgdir+0x2b9>
c0106328:	c7 44 24 0c 08 ce 10 	movl   $0xc010ce08,0xc(%esp)
c010632f:	c0 
c0106330:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106337:	c0 
c0106338:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c010633f:	00 
c0106340:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106347:	e8 89 aa ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010634c:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106351:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106358:	00 
c0106359:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106360:	00 
c0106361:	89 04 24             	mov    %eax,(%esp)
c0106364:	e8 c9 f4 ff ff       	call   c0105832 <get_pte>
c0106369:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010636c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106370:	75 24                	jne    c0106396 <check_pgdir+0x303>
c0106372:	c7 44 24 0c 40 ce 10 	movl   $0xc010ce40,0xc(%esp)
c0106379:	c0 
c010637a:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106381:	c0 
c0106382:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c0106389:	00 
c010638a:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106391:	e8 3f aa ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_U);
c0106396:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106399:	8b 00                	mov    (%eax),%eax
c010639b:	83 e0 04             	and    $0x4,%eax
c010639e:	85 c0                	test   %eax,%eax
c01063a0:	75 24                	jne    c01063c6 <check_pgdir+0x333>
c01063a2:	c7 44 24 0c 70 ce 10 	movl   $0xc010ce70,0xc(%esp)
c01063a9:	c0 
c01063aa:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01063b1:	c0 
c01063b2:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c01063b9:	00 
c01063ba:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01063c1:	e8 0f aa ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_W);
c01063c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063c9:	8b 00                	mov    (%eax),%eax
c01063cb:	83 e0 02             	and    $0x2,%eax
c01063ce:	85 c0                	test   %eax,%eax
c01063d0:	75 24                	jne    c01063f6 <check_pgdir+0x363>
c01063d2:	c7 44 24 0c 7e ce 10 	movl   $0xc010ce7e,0xc(%esp)
c01063d9:	c0 
c01063da:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01063e1:	c0 
c01063e2:	c7 44 24 04 a8 02 00 	movl   $0x2a8,0x4(%esp)
c01063e9:	00 
c01063ea:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01063f1:	e8 df a9 ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01063f6:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01063fb:	8b 00                	mov    (%eax),%eax
c01063fd:	83 e0 04             	and    $0x4,%eax
c0106400:	85 c0                	test   %eax,%eax
c0106402:	75 24                	jne    c0106428 <check_pgdir+0x395>
c0106404:	c7 44 24 0c 8c ce 10 	movl   $0xc010ce8c,0xc(%esp)
c010640b:	c0 
c010640c:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106413:	c0 
c0106414:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c010641b:	00 
c010641c:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106423:	e8 ad a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 1);
c0106428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010642b:	89 04 24             	mov    %eax,(%esp)
c010642e:	e8 93 ea ff ff       	call   c0104ec6 <page_ref>
c0106433:	83 f8 01             	cmp    $0x1,%eax
c0106436:	74 24                	je     c010645c <check_pgdir+0x3c9>
c0106438:	c7 44 24 0c a2 ce 10 	movl   $0xc010cea2,0xc(%esp)
c010643f:	c0 
c0106440:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106447:	c0 
c0106448:	c7 44 24 04 aa 02 00 	movl   $0x2aa,0x4(%esp)
c010644f:	00 
c0106450:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106457:	e8 79 a9 ff ff       	call   c0100dd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010645c:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106461:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106468:	00 
c0106469:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0106470:	00 
c0106471:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106474:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106478:	89 04 24             	mov    %eax,(%esp)
c010647b:	e8 0b fa ff ff       	call   c0105e8b <page_insert>
c0106480:	85 c0                	test   %eax,%eax
c0106482:	74 24                	je     c01064a8 <check_pgdir+0x415>
c0106484:	c7 44 24 0c b4 ce 10 	movl   $0xc010ceb4,0xc(%esp)
c010648b:	c0 
c010648c:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106493:	c0 
c0106494:	c7 44 24 04 ac 02 00 	movl   $0x2ac,0x4(%esp)
c010649b:	00 
c010649c:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01064a3:	e8 2d a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 2);
c01064a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01064ab:	89 04 24             	mov    %eax,(%esp)
c01064ae:	e8 13 ea ff ff       	call   c0104ec6 <page_ref>
c01064b3:	83 f8 02             	cmp    $0x2,%eax
c01064b6:	74 24                	je     c01064dc <check_pgdir+0x449>
c01064b8:	c7 44 24 0c e0 ce 10 	movl   $0xc010cee0,0xc(%esp)
c01064bf:	c0 
c01064c0:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01064c7:	c0 
c01064c8:	c7 44 24 04 ad 02 00 	movl   $0x2ad,0x4(%esp)
c01064cf:	00 
c01064d0:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01064d7:	e8 f9 a8 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c01064dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064df:	89 04 24             	mov    %eax,(%esp)
c01064e2:	e8 df e9 ff ff       	call   c0104ec6 <page_ref>
c01064e7:	85 c0                	test   %eax,%eax
c01064e9:	74 24                	je     c010650f <check_pgdir+0x47c>
c01064eb:	c7 44 24 0c f2 ce 10 	movl   $0xc010cef2,0xc(%esp)
c01064f2:	c0 
c01064f3:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01064fa:	c0 
c01064fb:	c7 44 24 04 ae 02 00 	movl   $0x2ae,0x4(%esp)
c0106502:	00 
c0106503:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010650a:	e8 c6 a8 ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010650f:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106514:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010651b:	00 
c010651c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106523:	00 
c0106524:	89 04 24             	mov    %eax,(%esp)
c0106527:	e8 06 f3 ff ff       	call   c0105832 <get_pte>
c010652c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010652f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106533:	75 24                	jne    c0106559 <check_pgdir+0x4c6>
c0106535:	c7 44 24 0c 40 ce 10 	movl   $0xc010ce40,0xc(%esp)
c010653c:	c0 
c010653d:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106544:	c0 
c0106545:	c7 44 24 04 af 02 00 	movl   $0x2af,0x4(%esp)
c010654c:	00 
c010654d:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106554:	e8 7c a8 ff ff       	call   c0100dd5 <__panic>
    assert(pa2page(*ptep) == p1);
c0106559:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010655c:	8b 00                	mov    (%eax),%eax
c010655e:	89 04 24             	mov    %eax,(%esp)
c0106561:	e8 71 e8 ff ff       	call   c0104dd7 <pa2page>
c0106566:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106569:	74 24                	je     c010658f <check_pgdir+0x4fc>
c010656b:	c7 44 24 0c b9 cd 10 	movl   $0xc010cdb9,0xc(%esp)
c0106572:	c0 
c0106573:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010657a:	c0 
c010657b:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
c0106582:	00 
c0106583:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010658a:	e8 46 a8 ff ff       	call   c0100dd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c010658f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106592:	8b 00                	mov    (%eax),%eax
c0106594:	83 e0 04             	and    $0x4,%eax
c0106597:	85 c0                	test   %eax,%eax
c0106599:	74 24                	je     c01065bf <check_pgdir+0x52c>
c010659b:	c7 44 24 0c 04 cf 10 	movl   $0xc010cf04,0xc(%esp)
c01065a2:	c0 
c01065a3:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01065aa:	c0 
c01065ab:	c7 44 24 04 b1 02 00 	movl   $0x2b1,0x4(%esp)
c01065b2:	00 
c01065b3:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01065ba:	e8 16 a8 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c01065bf:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01065c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01065cb:	00 
c01065cc:	89 04 24             	mov    %eax,(%esp)
c01065cf:	e8 73 f8 ff ff       	call   c0105e47 <page_remove>
    assert(page_ref(p1) == 1);
c01065d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065d7:	89 04 24             	mov    %eax,(%esp)
c01065da:	e8 e7 e8 ff ff       	call   c0104ec6 <page_ref>
c01065df:	83 f8 01             	cmp    $0x1,%eax
c01065e2:	74 24                	je     c0106608 <check_pgdir+0x575>
c01065e4:	c7 44 24 0c ce cd 10 	movl   $0xc010cdce,0xc(%esp)
c01065eb:	c0 
c01065ec:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01065f3:	c0 
c01065f4:	c7 44 24 04 b4 02 00 	movl   $0x2b4,0x4(%esp)
c01065fb:	00 
c01065fc:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106603:	e8 cd a7 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c0106608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010660b:	89 04 24             	mov    %eax,(%esp)
c010660e:	e8 b3 e8 ff ff       	call   c0104ec6 <page_ref>
c0106613:	85 c0                	test   %eax,%eax
c0106615:	74 24                	je     c010663b <check_pgdir+0x5a8>
c0106617:	c7 44 24 0c f2 ce 10 	movl   $0xc010cef2,0xc(%esp)
c010661e:	c0 
c010661f:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106626:	c0 
c0106627:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c010662e:	00 
c010662f:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106636:	e8 9a a7 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010663b:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106640:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106647:	00 
c0106648:	89 04 24             	mov    %eax,(%esp)
c010664b:	e8 f7 f7 ff ff       	call   c0105e47 <page_remove>
    assert(page_ref(p1) == 0);
c0106650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106653:	89 04 24             	mov    %eax,(%esp)
c0106656:	e8 6b e8 ff ff       	call   c0104ec6 <page_ref>
c010665b:	85 c0                	test   %eax,%eax
c010665d:	74 24                	je     c0106683 <check_pgdir+0x5f0>
c010665f:	c7 44 24 0c 19 cf 10 	movl   $0xc010cf19,0xc(%esp)
c0106666:	c0 
c0106667:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010666e:	c0 
c010666f:	c7 44 24 04 b8 02 00 	movl   $0x2b8,0x4(%esp)
c0106676:	00 
c0106677:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010667e:	e8 52 a7 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c0106683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106686:	89 04 24             	mov    %eax,(%esp)
c0106689:	e8 38 e8 ff ff       	call   c0104ec6 <page_ref>
c010668e:	85 c0                	test   %eax,%eax
c0106690:	74 24                	je     c01066b6 <check_pgdir+0x623>
c0106692:	c7 44 24 0c f2 ce 10 	movl   $0xc010cef2,0xc(%esp)
c0106699:	c0 
c010669a:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01066a1:	c0 
c01066a2:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c01066a9:	00 
c01066aa:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01066b1:	e8 1f a7 ff ff       	call   c0100dd5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01066b6:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01066bb:	8b 00                	mov    (%eax),%eax
c01066bd:	89 04 24             	mov    %eax,(%esp)
c01066c0:	e8 12 e7 ff ff       	call   c0104dd7 <pa2page>
c01066c5:	89 04 24             	mov    %eax,(%esp)
c01066c8:	e8 f9 e7 ff ff       	call   c0104ec6 <page_ref>
c01066cd:	83 f8 01             	cmp    $0x1,%eax
c01066d0:	74 24                	je     c01066f6 <check_pgdir+0x663>
c01066d2:	c7 44 24 0c 2c cf 10 	movl   $0xc010cf2c,0xc(%esp)
c01066d9:	c0 
c01066da:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01066e1:	c0 
c01066e2:	c7 44 24 04 bb 02 00 	movl   $0x2bb,0x4(%esp)
c01066e9:	00 
c01066ea:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01066f1:	e8 df a6 ff ff       	call   c0100dd5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c01066f6:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01066fb:	8b 00                	mov    (%eax),%eax
c01066fd:	89 04 24             	mov    %eax,(%esp)
c0106700:	e8 d2 e6 ff ff       	call   c0104dd7 <pa2page>
c0106705:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010670c:	00 
c010670d:	89 04 24             	mov    %eax,(%esp)
c0106710:	e8 21 ea ff ff       	call   c0105136 <free_pages>
    boot_pgdir[0] = 0;
c0106715:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010671a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0106720:	c7 04 24 52 cf 10 c0 	movl   $0xc010cf52,(%esp)
c0106727:	e8 27 9c ff ff       	call   c0100353 <cprintf>
}
c010672c:	c9                   	leave  
c010672d:	c3                   	ret    

c010672e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010672e:	55                   	push   %ebp
c010672f:	89 e5                	mov    %esp,%ebp
c0106731:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106734:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010673b:	e9 ca 00 00 00       	jmp    c010680a <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0106740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106743:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106746:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106749:	c1 e8 0c             	shr    $0xc,%eax
c010674c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010674f:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106754:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106757:	72 23                	jb     c010677c <check_boot_pgdir+0x4e>
c0106759:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010675c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106760:	c7 44 24 08 24 cb 10 	movl   $0xc010cb24,0x8(%esp)
c0106767:	c0 
c0106768:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c010676f:	00 
c0106770:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106777:	e8 59 a6 ff ff       	call   c0100dd5 <__panic>
c010677c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010677f:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106784:	89 c2                	mov    %eax,%edx
c0106786:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010678b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106792:	00 
c0106793:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106797:	89 04 24             	mov    %eax,(%esp)
c010679a:	e8 93 f0 ff ff       	call   c0105832 <get_pte>
c010679f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01067a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01067a6:	75 24                	jne    c01067cc <check_boot_pgdir+0x9e>
c01067a8:	c7 44 24 0c 6c cf 10 	movl   $0xc010cf6c,0xc(%esp)
c01067af:	c0 
c01067b0:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01067b7:	c0 
c01067b8:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c01067bf:	00 
c01067c0:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01067c7:	e8 09 a6 ff ff       	call   c0100dd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01067cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067cf:	8b 00                	mov    (%eax),%eax
c01067d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01067d6:	89 c2                	mov    %eax,%edx
c01067d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067db:	39 c2                	cmp    %eax,%edx
c01067dd:	74 24                	je     c0106803 <check_boot_pgdir+0xd5>
c01067df:	c7 44 24 0c a9 cf 10 	movl   $0xc010cfa9,0xc(%esp)
c01067e6:	c0 
c01067e7:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01067ee:	c0 
c01067ef:	c7 44 24 04 c8 02 00 	movl   $0x2c8,0x4(%esp)
c01067f6:	00 
c01067f7:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01067fe:	e8 d2 a5 ff ff       	call   c0100dd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106803:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010680a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010680d:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106812:	39 c2                	cmp    %eax,%edx
c0106814:	0f 82 26 ff ff ff    	jb     c0106740 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010681a:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c010681f:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106824:	8b 00                	mov    (%eax),%eax
c0106826:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010682b:	89 c2                	mov    %eax,%edx
c010682d:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106835:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010683c:	77 23                	ja     c0106861 <check_boot_pgdir+0x133>
c010683e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106841:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106845:	c7 44 24 08 c8 cb 10 	movl   $0xc010cbc8,0x8(%esp)
c010684c:	c0 
c010684d:	c7 44 24 04 cb 02 00 	movl   $0x2cb,0x4(%esp)
c0106854:	00 
c0106855:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010685c:	e8 74 a5 ff ff       	call   c0100dd5 <__panic>
c0106861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106864:	05 00 00 00 40       	add    $0x40000000,%eax
c0106869:	39 c2                	cmp    %eax,%edx
c010686b:	74 24                	je     c0106891 <check_boot_pgdir+0x163>
c010686d:	c7 44 24 0c c0 cf 10 	movl   $0xc010cfc0,0xc(%esp)
c0106874:	c0 
c0106875:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010687c:	c0 
c010687d:	c7 44 24 04 cb 02 00 	movl   $0x2cb,0x4(%esp)
c0106884:	00 
c0106885:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010688c:	e8 44 a5 ff ff       	call   c0100dd5 <__panic>

    assert(boot_pgdir[0] == 0);
c0106891:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106896:	8b 00                	mov    (%eax),%eax
c0106898:	85 c0                	test   %eax,%eax
c010689a:	74 24                	je     c01068c0 <check_boot_pgdir+0x192>
c010689c:	c7 44 24 0c f4 cf 10 	movl   $0xc010cff4,0xc(%esp)
c01068a3:	c0 
c01068a4:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01068ab:	c0 
c01068ac:	c7 44 24 04 cd 02 00 	movl   $0x2cd,0x4(%esp)
c01068b3:	00 
c01068b4:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01068bb:	e8 15 a5 ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    p = alloc_page();
c01068c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01068c7:	e8 ff e7 ff ff       	call   c01050cb <alloc_pages>
c01068cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01068cf:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c01068d4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01068db:	00 
c01068dc:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01068e3:	00 
c01068e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01068e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068eb:	89 04 24             	mov    %eax,(%esp)
c01068ee:	e8 98 f5 ff ff       	call   c0105e8b <page_insert>
c01068f3:	85 c0                	test   %eax,%eax
c01068f5:	74 24                	je     c010691b <check_boot_pgdir+0x1ed>
c01068f7:	c7 44 24 0c 08 d0 10 	movl   $0xc010d008,0xc(%esp)
c01068fe:	c0 
c01068ff:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106906:	c0 
c0106907:	c7 44 24 04 d1 02 00 	movl   $0x2d1,0x4(%esp)
c010690e:	00 
c010690f:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106916:	e8 ba a4 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 1);
c010691b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010691e:	89 04 24             	mov    %eax,(%esp)
c0106921:	e8 a0 e5 ff ff       	call   c0104ec6 <page_ref>
c0106926:	83 f8 01             	cmp    $0x1,%eax
c0106929:	74 24                	je     c010694f <check_boot_pgdir+0x221>
c010692b:	c7 44 24 0c 36 d0 10 	movl   $0xc010d036,0xc(%esp)
c0106932:	c0 
c0106933:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c010693a:	c0 
c010693b:	c7 44 24 04 d2 02 00 	movl   $0x2d2,0x4(%esp)
c0106942:	00 
c0106943:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c010694a:	e8 86 a4 ff ff       	call   c0100dd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010694f:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106954:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010695b:	00 
c010695c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0106963:	00 
c0106964:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106967:	89 54 24 04          	mov    %edx,0x4(%esp)
c010696b:	89 04 24             	mov    %eax,(%esp)
c010696e:	e8 18 f5 ff ff       	call   c0105e8b <page_insert>
c0106973:	85 c0                	test   %eax,%eax
c0106975:	74 24                	je     c010699b <check_boot_pgdir+0x26d>
c0106977:	c7 44 24 0c 48 d0 10 	movl   $0xc010d048,0xc(%esp)
c010697e:	c0 
c010697f:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106986:	c0 
c0106987:	c7 44 24 04 d3 02 00 	movl   $0x2d3,0x4(%esp)
c010698e:	00 
c010698f:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106996:	e8 3a a4 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 2);
c010699b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010699e:	89 04 24             	mov    %eax,(%esp)
c01069a1:	e8 20 e5 ff ff       	call   c0104ec6 <page_ref>
c01069a6:	83 f8 02             	cmp    $0x2,%eax
c01069a9:	74 24                	je     c01069cf <check_boot_pgdir+0x2a1>
c01069ab:	c7 44 24 0c 7f d0 10 	movl   $0xc010d07f,0xc(%esp)
c01069b2:	c0 
c01069b3:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c01069ba:	c0 
c01069bb:	c7 44 24 04 d4 02 00 	movl   $0x2d4,0x4(%esp)
c01069c2:	00 
c01069c3:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c01069ca:	e8 06 a4 ff ff       	call   c0100dd5 <__panic>

    const char *str = "ucore: Hello world!!";
c01069cf:	c7 45 dc 90 d0 10 c0 	movl   $0xc010d090,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01069d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069dd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01069e4:	e8 ee 4e 00 00       	call   c010b8d7 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01069e9:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01069f0:	00 
c01069f1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01069f8:	e8 53 4f 00 00       	call   c010b950 <strcmp>
c01069fd:	85 c0                	test   %eax,%eax
c01069ff:	74 24                	je     c0106a25 <check_boot_pgdir+0x2f7>
c0106a01:	c7 44 24 0c a8 d0 10 	movl   $0xc010d0a8,0xc(%esp)
c0106a08:	c0 
c0106a09:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106a10:	c0 
c0106a11:	c7 44 24 04 d8 02 00 	movl   $0x2d8,0x4(%esp)
c0106a18:	00 
c0106a19:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106a20:	e8 b0 a3 ff ff       	call   c0100dd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106a28:	89 04 24             	mov    %eax,(%esp)
c0106a2b:	e8 ec e3 ff ff       	call   c0104e1c <page2kva>
c0106a30:	05 00 01 00 00       	add    $0x100,%eax
c0106a35:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106a38:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106a3f:	e8 3b 4e 00 00       	call   c010b87f <strlen>
c0106a44:	85 c0                	test   %eax,%eax
c0106a46:	74 24                	je     c0106a6c <check_boot_pgdir+0x33e>
c0106a48:	c7 44 24 0c e0 d0 10 	movl   $0xc010d0e0,0xc(%esp)
c0106a4f:	c0 
c0106a50:	c7 44 24 08 11 cc 10 	movl   $0xc010cc11,0x8(%esp)
c0106a57:	c0 
c0106a58:	c7 44 24 04 db 02 00 	movl   $0x2db,0x4(%esp)
c0106a5f:	00 
c0106a60:	c7 04 24 ec cb 10 c0 	movl   $0xc010cbec,(%esp)
c0106a67:	e8 69 a3 ff ff       	call   c0100dd5 <__panic>

    free_page(p);
c0106a6c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a73:	00 
c0106a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106a77:	89 04 24             	mov    %eax,(%esp)
c0106a7a:	e8 b7 e6 ff ff       	call   c0105136 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0106a7f:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106a84:	8b 00                	mov    (%eax),%eax
c0106a86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106a8b:	89 04 24             	mov    %eax,(%esp)
c0106a8e:	e8 44 e3 ff ff       	call   c0104dd7 <pa2page>
c0106a93:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a9a:	00 
c0106a9b:	89 04 24             	mov    %eax,(%esp)
c0106a9e:	e8 93 e6 ff ff       	call   c0105136 <free_pages>
    boot_pgdir[0] = 0;
c0106aa3:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0106aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106aae:	c7 04 24 04 d1 10 c0 	movl   $0xc010d104,(%esp)
c0106ab5:	e8 99 98 ff ff       	call   c0100353 <cprintf>
}
c0106aba:	c9                   	leave  
c0106abb:	c3                   	ret    

c0106abc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106abc:	55                   	push   %ebp
c0106abd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ac2:	83 e0 04             	and    $0x4,%eax
c0106ac5:	85 c0                	test   %eax,%eax
c0106ac7:	74 07                	je     c0106ad0 <perm2str+0x14>
c0106ac9:	b8 75 00 00 00       	mov    $0x75,%eax
c0106ace:	eb 05                	jmp    c0106ad5 <perm2str+0x19>
c0106ad0:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106ad5:	a2 68 cf 19 c0       	mov    %al,0xc019cf68
    str[1] = 'r';
c0106ada:	c6 05 69 cf 19 c0 72 	movb   $0x72,0xc019cf69
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ae4:	83 e0 02             	and    $0x2,%eax
c0106ae7:	85 c0                	test   %eax,%eax
c0106ae9:	74 07                	je     c0106af2 <perm2str+0x36>
c0106aeb:	b8 77 00 00 00       	mov    $0x77,%eax
c0106af0:	eb 05                	jmp    c0106af7 <perm2str+0x3b>
c0106af2:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106af7:	a2 6a cf 19 c0       	mov    %al,0xc019cf6a
    str[3] = '\0';
c0106afc:	c6 05 6b cf 19 c0 00 	movb   $0x0,0xc019cf6b
    return str;
c0106b03:	b8 68 cf 19 c0       	mov    $0xc019cf68,%eax
}
c0106b08:	5d                   	pop    %ebp
c0106b09:	c3                   	ret    

c0106b0a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106b0a:	55                   	push   %ebp
c0106b0b:	89 e5                	mov    %esp,%ebp
c0106b0d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106b10:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b13:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106b16:	72 0a                	jb     c0106b22 <get_pgtable_items+0x18>
        return 0;
c0106b18:	b8 00 00 00 00       	mov    $0x0,%eax
c0106b1d:	e9 9c 00 00 00       	jmp    c0106bbe <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106b22:	eb 04                	jmp    c0106b28 <get_pgtable_items+0x1e>
        start ++;
c0106b24:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106b28:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106b2e:	73 18                	jae    c0106b48 <get_pgtable_items+0x3e>
c0106b30:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106b3a:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b3d:	01 d0                	add    %edx,%eax
c0106b3f:	8b 00                	mov    (%eax),%eax
c0106b41:	83 e0 01             	and    $0x1,%eax
c0106b44:	85 c0                	test   %eax,%eax
c0106b46:	74 dc                	je     c0106b24 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106b48:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106b4e:	73 69                	jae    c0106bb9 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106b50:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106b54:	74 08                	je     c0106b5e <get_pgtable_items+0x54>
            *left_store = start;
c0106b56:	8b 45 18             	mov    0x18(%ebp),%eax
c0106b59:	8b 55 10             	mov    0x10(%ebp),%edx
c0106b5c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106b5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b61:	8d 50 01             	lea    0x1(%eax),%edx
c0106b64:	89 55 10             	mov    %edx,0x10(%ebp)
c0106b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106b6e:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b71:	01 d0                	add    %edx,%eax
c0106b73:	8b 00                	mov    (%eax),%eax
c0106b75:	83 e0 07             	and    $0x7,%eax
c0106b78:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106b7b:	eb 04                	jmp    c0106b81 <get_pgtable_items+0x77>
            start ++;
c0106b7d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106b81:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b84:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106b87:	73 1d                	jae    c0106ba6 <get_pgtable_items+0x9c>
c0106b89:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106b93:	8b 45 14             	mov    0x14(%ebp),%eax
c0106b96:	01 d0                	add    %edx,%eax
c0106b98:	8b 00                	mov    (%eax),%eax
c0106b9a:	83 e0 07             	and    $0x7,%eax
c0106b9d:	89 c2                	mov    %eax,%edx
c0106b9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106ba2:	39 c2                	cmp    %eax,%edx
c0106ba4:	74 d7                	je     c0106b7d <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106ba6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106baa:	74 08                	je     c0106bb4 <get_pgtable_items+0xaa>
            *right_store = start;
c0106bac:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106baf:	8b 55 10             	mov    0x10(%ebp),%edx
c0106bb2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106bb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bb7:	eb 05                	jmp    c0106bbe <get_pgtable_items+0xb4>
    }
    return 0;
c0106bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106bbe:	c9                   	leave  
c0106bbf:	c3                   	ret    

c0106bc0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106bc0:	55                   	push   %ebp
c0106bc1:	89 e5                	mov    %esp,%ebp
c0106bc3:	57                   	push   %edi
c0106bc4:	56                   	push   %esi
c0106bc5:	53                   	push   %ebx
c0106bc6:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106bc9:	c7 04 24 24 d1 10 c0 	movl   $0xc010d124,(%esp)
c0106bd0:	e8 7e 97 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c0106bd5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106bdc:	e9 fa 00 00 00       	jmp    c0106cdb <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106be4:	89 04 24             	mov    %eax,(%esp)
c0106be7:	e8 d0 fe ff ff       	call   c0106abc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106bec:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106bef:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106bf2:	29 d1                	sub    %edx,%ecx
c0106bf4:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106bf6:	89 d6                	mov    %edx,%esi
c0106bf8:	c1 e6 16             	shl    $0x16,%esi
c0106bfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106bfe:	89 d3                	mov    %edx,%ebx
c0106c00:	c1 e3 16             	shl    $0x16,%ebx
c0106c03:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c06:	89 d1                	mov    %edx,%ecx
c0106c08:	c1 e1 16             	shl    $0x16,%ecx
c0106c0b:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106c0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c11:	29 d7                	sub    %edx,%edi
c0106c13:	89 fa                	mov    %edi,%edx
c0106c15:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106c19:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106c1d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106c21:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106c25:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c29:	c7 04 24 55 d1 10 c0 	movl   $0xc010d155,(%esp)
c0106c30:	e8 1e 97 ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c38:	c1 e0 0a             	shl    $0xa,%eax
c0106c3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106c3e:	eb 54                	jmp    c0106c94 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c43:	89 04 24             	mov    %eax,(%esp)
c0106c46:	e8 71 fe ff ff       	call   c0106abc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106c4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106c4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106c51:	29 d1                	sub    %edx,%ecx
c0106c53:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106c55:	89 d6                	mov    %edx,%esi
c0106c57:	c1 e6 0c             	shl    $0xc,%esi
c0106c5a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106c5d:	89 d3                	mov    %edx,%ebx
c0106c5f:	c1 e3 0c             	shl    $0xc,%ebx
c0106c62:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106c65:	c1 e2 0c             	shl    $0xc,%edx
c0106c68:	89 d1                	mov    %edx,%ecx
c0106c6a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106c6d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106c70:	29 d7                	sub    %edx,%edi
c0106c72:	89 fa                	mov    %edi,%edx
c0106c74:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106c78:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106c7c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106c80:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106c84:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c88:	c7 04 24 74 d1 10 c0 	movl   $0xc010d174,(%esp)
c0106c8f:	e8 bf 96 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106c94:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106c99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c9c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106c9f:	89 ce                	mov    %ecx,%esi
c0106ca1:	c1 e6 0a             	shl    $0xa,%esi
c0106ca4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106ca7:	89 cb                	mov    %ecx,%ebx
c0106ca9:	c1 e3 0a             	shl    $0xa,%ebx
c0106cac:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106caf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106cb3:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106cb6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106cba:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106cc2:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106cc6:	89 1c 24             	mov    %ebx,(%esp)
c0106cc9:	e8 3c fe ff ff       	call   c0106b0a <get_pgtable_items>
c0106cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106cd5:	0f 85 65 ff ff ff    	jne    c0106c40 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106cdb:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106ce0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106ce3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106ce6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106cea:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106ced:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106cf1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106cf9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106d00:	00 
c0106d01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106d08:	e8 fd fd ff ff       	call   c0106b0a <get_pgtable_items>
c0106d0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106d10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106d14:	0f 85 c7 fe ff ff    	jne    c0106be1 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106d1a:	c7 04 24 98 d1 10 c0 	movl   $0xc010d198,(%esp)
c0106d21:	e8 2d 96 ff ff       	call   c0100353 <cprintf>
}
c0106d26:	83 c4 4c             	add    $0x4c,%esp
c0106d29:	5b                   	pop    %ebx
c0106d2a:	5e                   	pop    %esi
c0106d2b:	5f                   	pop    %edi
c0106d2c:	5d                   	pop    %ebp
c0106d2d:	c3                   	ret    

c0106d2e <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106d2e:	55                   	push   %ebp
c0106d2f:	89 e5                	mov    %esp,%ebp
c0106d31:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d37:	c1 e8 0c             	shr    $0xc,%eax
c0106d3a:	89 c2                	mov    %eax,%edx
c0106d3c:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0106d41:	39 c2                	cmp    %eax,%edx
c0106d43:	72 1c                	jb     c0106d61 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106d45:	c7 44 24 08 cc d1 10 	movl   $0xc010d1cc,0x8(%esp)
c0106d4c:	c0 
c0106d4d:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106d54:	00 
c0106d55:	c7 04 24 eb d1 10 c0 	movl   $0xc010d1eb,(%esp)
c0106d5c:	e8 74 a0 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0106d61:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0106d66:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d69:	c1 ea 0c             	shr    $0xc,%edx
c0106d6c:	c1 e2 05             	shl    $0x5,%edx
c0106d6f:	01 d0                	add    %edx,%eax
}
c0106d71:	c9                   	leave  
c0106d72:	c3                   	ret    

c0106d73 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106d73:	55                   	push   %ebp
c0106d74:	89 e5                	mov    %esp,%ebp
c0106d76:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106d79:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d7c:	83 e0 01             	and    $0x1,%eax
c0106d7f:	85 c0                	test   %eax,%eax
c0106d81:	75 1c                	jne    c0106d9f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106d83:	c7 44 24 08 fc d1 10 	movl   $0xc010d1fc,0x8(%esp)
c0106d8a:	c0 
c0106d8b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106d92:	00 
c0106d93:	c7 04 24 eb d1 10 c0 	movl   $0xc010d1eb,(%esp)
c0106d9a:	e8 36 a0 ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106d9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106da2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106da7:	89 04 24             	mov    %eax,(%esp)
c0106daa:	e8 7f ff ff ff       	call   c0106d2e <pa2page>
}
c0106daf:	c9                   	leave  
c0106db0:	c3                   	ret    

c0106db1 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106db1:	55                   	push   %ebp
c0106db2:	89 e5                	mov    %esp,%ebp
c0106db4:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106db7:	e8 8b 22 00 00       	call   c0109047 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106dbc:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106dc1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106dc6:	76 0c                	jbe    c0106dd4 <swap_init+0x23>
c0106dc8:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106dcd:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106dd2:	76 25                	jbe    c0106df9 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106dd4:	a1 7c f0 19 c0       	mov    0xc019f07c,%eax
c0106dd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106ddd:	c7 44 24 08 1d d2 10 	movl   $0xc010d21d,0x8(%esp)
c0106de4:	c0 
c0106de5:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106dec:	00 
c0106ded:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0106df4:	e8 dc 9f ff ff       	call   c0100dd5 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106df9:	c7 05 74 cf 19 c0 60 	movl   $0xc012aa60,0xc019cf74
c0106e00:	aa 12 c0 
     int r = sm->init();
c0106e03:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e08:	8b 40 04             	mov    0x4(%eax),%eax
c0106e0b:	ff d0                	call   *%eax
c0106e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106e10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e14:	75 26                	jne    c0106e3c <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106e16:	c7 05 6c cf 19 c0 01 	movl   $0x1,0xc019cf6c
c0106e1d:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106e20:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e25:	8b 00                	mov    (%eax),%eax
c0106e27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106e2b:	c7 04 24 47 d2 10 c0 	movl   $0xc010d247,(%esp)
c0106e32:	e8 1c 95 ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106e37:	e8 a4 04 00 00       	call   c01072e0 <check_swap>
     }

     return r;
c0106e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106e3f:	c9                   	leave  
c0106e40:	c3                   	ret    

c0106e41 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106e41:	55                   	push   %ebp
c0106e42:	89 e5                	mov    %esp,%ebp
c0106e44:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106e47:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e4c:	8b 40 08             	mov    0x8(%eax),%eax
c0106e4f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e52:	89 14 24             	mov    %edx,(%esp)
c0106e55:	ff d0                	call   *%eax
}
c0106e57:	c9                   	leave  
c0106e58:	c3                   	ret    

c0106e59 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106e59:	55                   	push   %ebp
c0106e5a:	89 e5                	mov    %esp,%ebp
c0106e5c:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106e5f:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e64:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e67:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e6a:	89 14 24             	mov    %edx,(%esp)
c0106e6d:	ff d0                	call   *%eax
}
c0106e6f:	c9                   	leave  
c0106e70:	c3                   	ret    

c0106e71 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106e71:	55                   	push   %ebp
c0106e72:	89 e5                	mov    %esp,%ebp
c0106e74:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106e77:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106e7c:	8b 40 10             	mov    0x10(%eax),%eax
c0106e7f:	8b 55 14             	mov    0x14(%ebp),%edx
c0106e82:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106e86:	8b 55 10             	mov    0x10(%ebp),%edx
c0106e89:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e90:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e94:	8b 55 08             	mov    0x8(%ebp),%edx
c0106e97:	89 14 24             	mov    %edx,(%esp)
c0106e9a:	ff d0                	call   *%eax
}
c0106e9c:	c9                   	leave  
c0106e9d:	c3                   	ret    

c0106e9e <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106e9e:	55                   	push   %ebp
c0106e9f:	89 e5                	mov    %esp,%ebp
c0106ea1:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106ea4:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106ea9:	8b 40 14             	mov    0x14(%eax),%eax
c0106eac:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106eaf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106eb3:	8b 55 08             	mov    0x8(%ebp),%edx
c0106eb6:	89 14 24             	mov    %edx,(%esp)
c0106eb9:	ff d0                	call   *%eax
}
c0106ebb:	c9                   	leave  
c0106ebc:	c3                   	ret    

c0106ebd <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106ebd:	55                   	push   %ebp
c0106ebe:	89 e5                	mov    %esp,%ebp
c0106ec0:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106ec3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106eca:	e9 5a 01 00 00       	jmp    c0107029 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106ecf:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106ed4:	8b 40 18             	mov    0x18(%eax),%eax
c0106ed7:	8b 55 10             	mov    0x10(%ebp),%edx
c0106eda:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106ede:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106ee1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ee5:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ee8:	89 14 24             	mov    %edx,(%esp)
c0106eeb:	ff d0                	call   *%eax
c0106eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106ef4:	74 18                	je     c0106f0e <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106efd:	c7 04 24 5c d2 10 c0 	movl   $0xc010d25c,(%esp)
c0106f04:	e8 4a 94 ff ff       	call   c0100353 <cprintf>
c0106f09:	e9 27 01 00 00       	jmp    c0107035 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f11:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106f17:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f1a:	8b 40 0c             	mov    0xc(%eax),%eax
c0106f1d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106f24:	00 
c0106f25:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f28:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106f2c:	89 04 24             	mov    %eax,(%esp)
c0106f2f:	e8 fe e8 ff ff       	call   c0105832 <get_pte>
c0106f34:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106f3a:	8b 00                	mov    (%eax),%eax
c0106f3c:	83 e0 01             	and    $0x1,%eax
c0106f3f:	85 c0                	test   %eax,%eax
c0106f41:	75 24                	jne    c0106f67 <swap_out+0xaa>
c0106f43:	c7 44 24 0c 89 d2 10 	movl   $0xc010d289,0xc(%esp)
c0106f4a:	c0 
c0106f4b:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0106f52:	c0 
c0106f53:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106f5a:	00 
c0106f5b:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0106f62:	e8 6e 9e ff ff       	call   c0100dd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f6d:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106f70:	c1 ea 0c             	shr    $0xc,%edx
c0106f73:	83 c2 01             	add    $0x1,%edx
c0106f76:	c1 e2 08             	shl    $0x8,%edx
c0106f79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f7d:	89 14 24             	mov    %edx,(%esp)
c0106f80:	e8 7c 21 00 00       	call   c0109101 <swapfs_write>
c0106f85:	85 c0                	test   %eax,%eax
c0106f87:	74 34                	je     c0106fbd <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106f89:	c7 04 24 b3 d2 10 c0 	movl   $0xc010d2b3,(%esp)
c0106f90:	e8 be 93 ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106f95:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c0106f9a:	8b 40 10             	mov    0x10(%eax),%eax
c0106f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106fa0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106fa7:	00 
c0106fa8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106fac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106faf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106fb3:	8b 55 08             	mov    0x8(%ebp),%edx
c0106fb6:	89 14 24             	mov    %edx,(%esp)
c0106fb9:	ff d0                	call   *%eax
c0106fbb:	eb 68                	jmp    c0107025 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fc0:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106fc3:	c1 e8 0c             	shr    $0xc,%eax
c0106fc6:	83 c0 01             	add    $0x1,%eax
c0106fc9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fd0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106fdb:	c7 04 24 cc d2 10 c0 	movl   $0xc010d2cc,(%esp)
c0106fe2:	e8 6c 93 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fea:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106fed:	c1 e8 0c             	shr    $0xc,%eax
c0106ff0:	83 c0 01             	add    $0x1,%eax
c0106ff3:	c1 e0 08             	shl    $0x8,%eax
c0106ff6:	89 c2                	mov    %eax,%edx
c0106ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ffb:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107000:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107007:	00 
c0107008:	89 04 24             	mov    %eax,(%esp)
c010700b:	e8 26 e1 ff ff       	call   c0105136 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0107010:	8b 45 08             	mov    0x8(%ebp),%eax
c0107013:	8b 40 0c             	mov    0xc(%eax),%eax
c0107016:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107019:	89 54 24 04          	mov    %edx,0x4(%esp)
c010701d:	89 04 24             	mov    %eax,(%esp)
c0107020:	e8 1f ef ff ff       	call   c0105f44 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0107025:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107029:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010702c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010702f:	0f 85 9a fe ff ff    	jne    c0106ecf <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0107035:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107038:	c9                   	leave  
c0107039:	c3                   	ret    

c010703a <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c010703a:	55                   	push   %ebp
c010703b:	89 e5                	mov    %esp,%ebp
c010703d:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0107040:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107047:	e8 7f e0 ff ff       	call   c01050cb <alloc_pages>
c010704c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c010704f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107053:	75 24                	jne    c0107079 <swap_in+0x3f>
c0107055:	c7 44 24 0c 0c d3 10 	movl   $0xc010d30c,0xc(%esp)
c010705c:	c0 
c010705d:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107064:	c0 
c0107065:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c010706c:	00 
c010706d:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107074:	e8 5c 9d ff ff       	call   c0100dd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0107079:	8b 45 08             	mov    0x8(%ebp),%eax
c010707c:	8b 40 0c             	mov    0xc(%eax),%eax
c010707f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107086:	00 
c0107087:	8b 55 0c             	mov    0xc(%ebp),%edx
c010708a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010708e:	89 04 24             	mov    %eax,(%esp)
c0107091:	e8 9c e7 ff ff       	call   c0105832 <get_pte>
c0107096:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0107099:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010709c:	8b 00                	mov    (%eax),%eax
c010709e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01070a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01070a5:	89 04 24             	mov    %eax,(%esp)
c01070a8:	e8 e2 1f 00 00       	call   c010908f <swapfs_read>
c01070ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01070b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01070b4:	74 2a                	je     c01070e0 <swap_in+0xa6>
     {
        assert(r!=0);
c01070b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01070ba:	75 24                	jne    c01070e0 <swap_in+0xa6>
c01070bc:	c7 44 24 0c 19 d3 10 	movl   $0xc010d319,0xc(%esp)
c01070c3:	c0 
c01070c4:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01070cb:	c0 
c01070cc:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c01070d3:	00 
c01070d4:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01070db:	e8 f5 9c ff ff       	call   c0100dd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01070e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070e3:	8b 00                	mov    (%eax),%eax
c01070e5:	c1 e8 08             	shr    $0x8,%eax
c01070e8:	89 c2                	mov    %eax,%edx
c01070ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01070f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01070f5:	c7 04 24 20 d3 10 c0 	movl   $0xc010d320,(%esp)
c01070fc:	e8 52 92 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0107101:	8b 45 10             	mov    0x10(%ebp),%eax
c0107104:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107107:	89 10                	mov    %edx,(%eax)
     return 0;
c0107109:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010710e:	c9                   	leave  
c010710f:	c3                   	ret    

c0107110 <check_content_set>:



static inline void
check_content_set(void)
{
c0107110:	55                   	push   %ebp
c0107111:	89 e5                	mov    %esp,%ebp
c0107113:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0107116:	b8 00 10 00 00       	mov    $0x1000,%eax
c010711b:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010711e:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107123:	83 f8 01             	cmp    $0x1,%eax
c0107126:	74 24                	je     c010714c <check_content_set+0x3c>
c0107128:	c7 44 24 0c 5e d3 10 	movl   $0xc010d35e,0xc(%esp)
c010712f:	c0 
c0107130:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107137:	c0 
c0107138:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010713f:	00 
c0107140:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107147:	e8 89 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c010714c:	b8 10 10 00 00       	mov    $0x1010,%eax
c0107151:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0107154:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107159:	83 f8 01             	cmp    $0x1,%eax
c010715c:	74 24                	je     c0107182 <check_content_set+0x72>
c010715e:	c7 44 24 0c 5e d3 10 	movl   $0xc010d35e,0xc(%esp)
c0107165:	c0 
c0107166:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c010716d:	c0 
c010716e:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0107175:	00 
c0107176:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c010717d:	e8 53 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0107182:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107187:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010718a:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c010718f:	83 f8 02             	cmp    $0x2,%eax
c0107192:	74 24                	je     c01071b8 <check_content_set+0xa8>
c0107194:	c7 44 24 0c 6d d3 10 	movl   $0xc010d36d,0xc(%esp)
c010719b:	c0 
c010719c:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01071a3:	c0 
c01071a4:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01071ab:	00 
c01071ac:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01071b3:	e8 1d 9c ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c01071b8:	b8 10 20 00 00       	mov    $0x2010,%eax
c01071bd:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01071c0:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01071c5:	83 f8 02             	cmp    $0x2,%eax
c01071c8:	74 24                	je     c01071ee <check_content_set+0xde>
c01071ca:	c7 44 24 0c 6d d3 10 	movl   $0xc010d36d,0xc(%esp)
c01071d1:	c0 
c01071d2:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01071d9:	c0 
c01071da:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01071e1:	00 
c01071e2:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01071e9:	e8 e7 9b ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01071ee:	b8 00 30 00 00       	mov    $0x3000,%eax
c01071f3:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01071f6:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c01071fb:	83 f8 03             	cmp    $0x3,%eax
c01071fe:	74 24                	je     c0107224 <check_content_set+0x114>
c0107200:	c7 44 24 0c 7c d3 10 	movl   $0xc010d37c,0xc(%esp)
c0107207:	c0 
c0107208:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c010720f:	c0 
c0107210:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0107217:	00 
c0107218:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c010721f:	e8 b1 9b ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0107224:	b8 10 30 00 00       	mov    $0x3010,%eax
c0107229:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010722c:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107231:	83 f8 03             	cmp    $0x3,%eax
c0107234:	74 24                	je     c010725a <check_content_set+0x14a>
c0107236:	c7 44 24 0c 7c d3 10 	movl   $0xc010d37c,0xc(%esp)
c010723d:	c0 
c010723e:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107245:	c0 
c0107246:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010724d:	00 
c010724e:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107255:	e8 7b 9b ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010725a:	b8 00 40 00 00       	mov    $0x4000,%eax
c010725f:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0107262:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107267:	83 f8 04             	cmp    $0x4,%eax
c010726a:	74 24                	je     c0107290 <check_content_set+0x180>
c010726c:	c7 44 24 0c 8b d3 10 	movl   $0xc010d38b,0xc(%esp)
c0107273:	c0 
c0107274:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c010727b:	c0 
c010727c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0107283:	00 
c0107284:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c010728b:	e8 45 9b ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0107290:	b8 10 40 00 00       	mov    $0x4010,%eax
c0107295:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0107298:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c010729d:	83 f8 04             	cmp    $0x4,%eax
c01072a0:	74 24                	je     c01072c6 <check_content_set+0x1b6>
c01072a2:	c7 44 24 0c 8b d3 10 	movl   $0xc010d38b,0xc(%esp)
c01072a9:	c0 
c01072aa:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01072b1:	c0 
c01072b2:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01072b9:	00 
c01072ba:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01072c1:	e8 0f 9b ff ff       	call   c0100dd5 <__panic>
}
c01072c6:	c9                   	leave  
c01072c7:	c3                   	ret    

c01072c8 <check_content_access>:

static inline int
check_content_access(void)
{
c01072c8:	55                   	push   %ebp
c01072c9:	89 e5                	mov    %esp,%ebp
c01072cb:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c01072ce:	a1 74 cf 19 c0       	mov    0xc019cf74,%eax
c01072d3:	8b 40 1c             	mov    0x1c(%eax),%eax
c01072d6:	ff d0                	call   *%eax
c01072d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01072db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01072de:	c9                   	leave  
c01072df:	c3                   	ret    

c01072e0 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01072e0:	55                   	push   %ebp
c01072e1:	89 e5                	mov    %esp,%ebp
c01072e3:	53                   	push   %ebx
c01072e4:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01072e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01072ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01072f5:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01072fc:	eb 6b                	jmp    c0107369 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01072fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107301:	83 e8 0c             	sub    $0xc,%eax
c0107304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0107307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010730a:	83 c0 04             	add    $0x4,%eax
c010730d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0107314:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107317:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010731a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010731d:	0f a3 10             	bt     %edx,(%eax)
c0107320:	19 c0                	sbb    %eax,%eax
c0107322:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0107325:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107329:	0f 95 c0             	setne  %al
c010732c:	0f b6 c0             	movzbl %al,%eax
c010732f:	85 c0                	test   %eax,%eax
c0107331:	75 24                	jne    c0107357 <check_swap+0x77>
c0107333:	c7 44 24 0c 9a d3 10 	movl   $0xc010d39a,0xc(%esp)
c010733a:	c0 
c010733b:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107342:	c0 
c0107343:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010734a:	00 
c010734b:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107352:	e8 7e 9a ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c0107357:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010735b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010735e:	8b 50 08             	mov    0x8(%eax),%edx
c0107361:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107364:	01 d0                	add    %edx,%eax
c0107366:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107369:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010736c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010736f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107372:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107375:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107378:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c010737f:	0f 85 79 ff ff ff    	jne    c01072fe <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0107385:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0107388:	e8 db dd ff ff       	call   c0105168 <nr_free_pages>
c010738d:	39 c3                	cmp    %eax,%ebx
c010738f:	74 24                	je     c01073b5 <check_swap+0xd5>
c0107391:	c7 44 24 0c aa d3 10 	movl   $0xc010d3aa,0xc(%esp)
c0107398:	c0 
c0107399:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01073a0:	c0 
c01073a1:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01073a8:	00 
c01073a9:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01073b0:	e8 20 9a ff ff       	call   c0100dd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c01073b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073b8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01073bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073c3:	c7 04 24 c4 d3 10 c0 	movl   $0xc010d3c4,(%esp)
c01073ca:	e8 84 8f ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c01073cf:	e8 52 0a 00 00       	call   c0107e26 <mm_create>
c01073d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c01073d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01073db:	75 24                	jne    c0107401 <check_swap+0x121>
c01073dd:	c7 44 24 0c ea d3 10 	movl   $0xc010d3ea,0xc(%esp)
c01073e4:	c0 
c01073e5:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01073ec:	c0 
c01073ed:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01073f4:	00 
c01073f5:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01073fc:	e8 d4 99 ff ff       	call   c0100dd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0107401:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0107406:	85 c0                	test   %eax,%eax
c0107408:	74 24                	je     c010742e <check_swap+0x14e>
c010740a:	c7 44 24 0c f5 d3 10 	movl   $0xc010d3f5,0xc(%esp)
c0107411:	c0 
c0107412:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107419:	c0 
c010741a:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107421:	00 
c0107422:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107429:	e8 a7 99 ff ff       	call   c0100dd5 <__panic>

     check_mm_struct = mm;
c010742e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107431:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107436:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c010743c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010743f:	89 50 0c             	mov    %edx,0xc(%eax)
c0107442:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107445:	8b 40 0c             	mov    0xc(%eax),%eax
c0107448:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c010744b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010744e:	8b 00                	mov    (%eax),%eax
c0107450:	85 c0                	test   %eax,%eax
c0107452:	74 24                	je     c0107478 <check_swap+0x198>
c0107454:	c7 44 24 0c 0d d4 10 	movl   $0xc010d40d,0xc(%esp)
c010745b:	c0 
c010745c:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107463:	c0 
c0107464:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c010746b:	00 
c010746c:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107473:	e8 5d 99 ff ff       	call   c0100dd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0107478:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c010747f:	00 
c0107480:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0107487:	00 
c0107488:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c010748f:	e8 2b 0a 00 00       	call   c0107ebf <vma_create>
c0107494:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0107497:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010749b:	75 24                	jne    c01074c1 <check_swap+0x1e1>
c010749d:	c7 44 24 0c 1b d4 10 	movl   $0xc010d41b,0xc(%esp)
c01074a4:	c0 
c01074a5:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01074ac:	c0 
c01074ad:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01074b4:	00 
c01074b5:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01074bc:	e8 14 99 ff ff       	call   c0100dd5 <__panic>

     insert_vma_struct(mm, vma);
c01074c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01074c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074cb:	89 04 24             	mov    %eax,(%esp)
c01074ce:	e8 7c 0b 00 00       	call   c010804f <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01074d3:	c7 04 24 28 d4 10 c0 	movl   $0xc010d428,(%esp)
c01074da:	e8 74 8e ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c01074df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01074e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074e9:	8b 40 0c             	mov    0xc(%eax),%eax
c01074ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01074f3:	00 
c01074f4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01074fb:	00 
c01074fc:	89 04 24             	mov    %eax,(%esp)
c01074ff:	e8 2e e3 ff ff       	call   c0105832 <get_pte>
c0107504:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0107507:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010750b:	75 24                	jne    c0107531 <check_swap+0x251>
c010750d:	c7 44 24 0c 5c d4 10 	movl   $0xc010d45c,0xc(%esp)
c0107514:	c0 
c0107515:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c010751c:	c0 
c010751d:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107524:	00 
c0107525:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c010752c:	e8 a4 98 ff ff       	call   c0100dd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0107531:	c7 04 24 70 d4 10 c0 	movl   $0xc010d470,(%esp)
c0107538:	e8 16 8e ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010753d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107544:	e9 a3 00 00 00       	jmp    c01075ec <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0107549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107550:	e8 76 db ff ff       	call   c01050cb <alloc_pages>
c0107555:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107558:	89 04 95 e0 ef 19 c0 	mov    %eax,-0x3fe61020(,%edx,4)
          assert(check_rp[i] != NULL );
c010755f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107562:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c0107569:	85 c0                	test   %eax,%eax
c010756b:	75 24                	jne    c0107591 <check_swap+0x2b1>
c010756d:	c7 44 24 0c 94 d4 10 	movl   $0xc010d494,0xc(%esp)
c0107574:	c0 
c0107575:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c010757c:	c0 
c010757d:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0107584:	00 
c0107585:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c010758c:	e8 44 98 ff ff       	call   c0100dd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c0107591:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107594:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c010759b:	83 c0 04             	add    $0x4,%eax
c010759e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01075a5:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01075a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01075ab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01075ae:	0f a3 10             	bt     %edx,(%eax)
c01075b1:	19 c0                	sbb    %eax,%eax
c01075b3:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c01075b6:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01075ba:	0f 95 c0             	setne  %al
c01075bd:	0f b6 c0             	movzbl %al,%eax
c01075c0:	85 c0                	test   %eax,%eax
c01075c2:	74 24                	je     c01075e8 <check_swap+0x308>
c01075c4:	c7 44 24 0c a8 d4 10 	movl   $0xc010d4a8,0xc(%esp)
c01075cb:	c0 
c01075cc:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01075d3:	c0 
c01075d4:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01075db:	00 
c01075dc:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01075e3:	e8 ed 97 ff ff       	call   c0100dd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075e8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01075ec:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01075f0:	0f 8e 53 ff ff ff    	jle    c0107549 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01075f6:	a1 b8 ef 19 c0       	mov    0xc019efb8,%eax
c01075fb:	8b 15 bc ef 19 c0    	mov    0xc019efbc,%edx
c0107601:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107604:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0107607:	c7 45 a8 b8 ef 19 c0 	movl   $0xc019efb8,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010760e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107611:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0107614:	89 50 04             	mov    %edx,0x4(%eax)
c0107617:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010761a:	8b 50 04             	mov    0x4(%eax),%edx
c010761d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107620:	89 10                	mov    %edx,(%eax)
c0107622:	c7 45 a4 b8 ef 19 c0 	movl   $0xc019efb8,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0107629:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010762c:	8b 40 04             	mov    0x4(%eax),%eax
c010762f:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0107632:	0f 94 c0             	sete   %al
c0107635:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0107638:	85 c0                	test   %eax,%eax
c010763a:	75 24                	jne    c0107660 <check_swap+0x380>
c010763c:	c7 44 24 0c c3 d4 10 	movl   $0xc010d4c3,0xc(%esp)
c0107643:	c0 
c0107644:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c010764b:	c0 
c010764c:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0107653:	00 
c0107654:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c010765b:	e8 75 97 ff ff       	call   c0100dd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0107660:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c0107665:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0107668:	c7 05 c0 ef 19 c0 00 	movl   $0x0,0xc019efc0
c010766f:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107672:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107679:	eb 1e                	jmp    c0107699 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c010767b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010767e:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c0107685:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010768c:	00 
c010768d:	89 04 24             	mov    %eax,(%esp)
c0107690:	e8 a1 da ff ff       	call   c0105136 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107695:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107699:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010769d:	7e dc                	jle    c010767b <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c010769f:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01076a4:	83 f8 04             	cmp    $0x4,%eax
c01076a7:	74 24                	je     c01076cd <check_swap+0x3ed>
c01076a9:	c7 44 24 0c dc d4 10 	movl   $0xc010d4dc,0xc(%esp)
c01076b0:	c0 
c01076b1:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01076b8:	c0 
c01076b9:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01076c0:	00 
c01076c1:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01076c8:	e8 08 97 ff ff       	call   c0100dd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01076cd:	c7 04 24 00 d5 10 c0 	movl   $0xc010d500,(%esp)
c01076d4:	e8 7a 8c ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01076d9:	c7 05 78 cf 19 c0 00 	movl   $0x0,0xc019cf78
c01076e0:	00 00 00 
     
     check_content_set();
c01076e3:	e8 28 fa ff ff       	call   c0107110 <check_content_set>
     assert( nr_free == 0);         
c01076e8:	a1 c0 ef 19 c0       	mov    0xc019efc0,%eax
c01076ed:	85 c0                	test   %eax,%eax
c01076ef:	74 24                	je     c0107715 <check_swap+0x435>
c01076f1:	c7 44 24 0c 27 d5 10 	movl   $0xc010d527,0xc(%esp)
c01076f8:	c0 
c01076f9:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107700:	c0 
c0107701:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0107708:	00 
c0107709:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107710:	e8 c0 96 ff ff       	call   c0100dd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0107715:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010771c:	eb 26                	jmp    c0107744 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c010771e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107721:	c7 04 85 00 f0 19 c0 	movl   $0xffffffff,-0x3fe61000(,%eax,4)
c0107728:	ff ff ff ff 
c010772c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010772f:	8b 14 85 00 f0 19 c0 	mov    -0x3fe61000(,%eax,4),%edx
c0107736:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107739:	89 14 85 40 f0 19 c0 	mov    %edx,-0x3fe60fc0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0107740:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107744:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0107748:	7e d4                	jle    c010771e <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010774a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107751:	e9 eb 00 00 00       	jmp    c0107841 <check_swap+0x561>
         check_ptep[i]=0;
c0107756:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107759:	c7 04 85 94 f0 19 c0 	movl   $0x0,-0x3fe60f6c(,%eax,4)
c0107760:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0107764:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107767:	83 c0 01             	add    $0x1,%eax
c010776a:	c1 e0 0c             	shl    $0xc,%eax
c010776d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107774:	00 
c0107775:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107779:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010777c:	89 04 24             	mov    %eax,(%esp)
c010777f:	e8 ae e0 ff ff       	call   c0105832 <get_pte>
c0107784:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107787:	89 04 95 94 f0 19 c0 	mov    %eax,-0x3fe60f6c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c010778e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107791:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107798:	85 c0                	test   %eax,%eax
c010779a:	75 24                	jne    c01077c0 <check_swap+0x4e0>
c010779c:	c7 44 24 0c 34 d5 10 	movl   $0xc010d534,0xc(%esp)
c01077a3:	c0 
c01077a4:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01077ab:	c0 
c01077ac:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01077b3:	00 
c01077b4:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c01077bb:	e8 15 96 ff ff       	call   c0100dd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01077c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077c3:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c01077ca:	8b 00                	mov    (%eax),%eax
c01077cc:	89 04 24             	mov    %eax,(%esp)
c01077cf:	e8 9f f5 ff ff       	call   c0106d73 <pte2page>
c01077d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01077d7:	8b 14 95 e0 ef 19 c0 	mov    -0x3fe61020(,%edx,4),%edx
c01077de:	39 d0                	cmp    %edx,%eax
c01077e0:	74 24                	je     c0107806 <check_swap+0x526>
c01077e2:	c7 44 24 0c 4c d5 10 	movl   $0xc010d54c,0xc(%esp)
c01077e9:	c0 
c01077ea:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c01077f1:	c0 
c01077f2:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01077f9:	00 
c01077fa:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107801:	e8 cf 95 ff ff       	call   c0100dd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107806:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107809:	8b 04 85 94 f0 19 c0 	mov    -0x3fe60f6c(,%eax,4),%eax
c0107810:	8b 00                	mov    (%eax),%eax
c0107812:	83 e0 01             	and    $0x1,%eax
c0107815:	85 c0                	test   %eax,%eax
c0107817:	75 24                	jne    c010783d <check_swap+0x55d>
c0107819:	c7 44 24 0c 74 d5 10 	movl   $0xc010d574,0xc(%esp)
c0107820:	c0 
c0107821:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107828:	c0 
c0107829:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0107830:	00 
c0107831:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107838:	e8 98 95 ff ff       	call   c0100dd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010783d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107841:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107845:	0f 8e 0b ff ff ff    	jle    c0107756 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c010784b:	c7 04 24 90 d5 10 c0 	movl   $0xc010d590,(%esp)
c0107852:	e8 fc 8a ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0107857:	e8 6c fa ff ff       	call   c01072c8 <check_content_access>
c010785c:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c010785f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107863:	74 24                	je     c0107889 <check_swap+0x5a9>
c0107865:	c7 44 24 0c b6 d5 10 	movl   $0xc010d5b6,0xc(%esp)
c010786c:	c0 
c010786d:	c7 44 24 08 9e d2 10 	movl   $0xc010d29e,0x8(%esp)
c0107874:	c0 
c0107875:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010787c:	00 
c010787d:	c7 04 24 38 d2 10 c0 	movl   $0xc010d238,(%esp)
c0107884:	e8 4c 95 ff ff       	call   c0100dd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107889:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107890:	eb 1e                	jmp    c01078b0 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0107892:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107895:	8b 04 85 e0 ef 19 c0 	mov    -0x3fe61020(,%eax,4),%eax
c010789c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01078a3:	00 
c01078a4:	89 04 24             	mov    %eax,(%esp)
c01078a7:	e8 8a d8 ff ff       	call   c0105136 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01078ac:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01078b0:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01078b4:	7e dc                	jle    c0107892 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pa2page(pgdir[0]));
c01078b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01078b9:	8b 00                	mov    (%eax),%eax
c01078bb:	89 04 24             	mov    %eax,(%esp)
c01078be:	e8 6b f4 ff ff       	call   c0106d2e <pa2page>
c01078c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01078ca:	00 
c01078cb:	89 04 24             	mov    %eax,(%esp)
c01078ce:	e8 63 d8 ff ff       	call   c0105136 <free_pages>
     pgdir[0] = 0;
c01078d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01078d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c01078dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01078df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c01078e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01078e9:	89 04 24             	mov    %eax,(%esp)
c01078ec:	e8 8e 08 00 00       	call   c010817f <mm_destroy>
     check_mm_struct = NULL;
c01078f1:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c01078f8:	00 00 00 
     
     nr_free = nr_free_store;
c01078fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01078fe:	a3 c0 ef 19 c0       	mov    %eax,0xc019efc0
     free_list = free_list_store;
c0107903:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107906:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107909:	a3 b8 ef 19 c0       	mov    %eax,0xc019efb8
c010790e:	89 15 bc ef 19 c0    	mov    %edx,0xc019efbc

     
     le = &free_list;
c0107914:	c7 45 e8 b8 ef 19 c0 	movl   $0xc019efb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010791b:	eb 1d                	jmp    c010793a <check_swap+0x65a>
         struct Page *p = le2page(le, page_link);
c010791d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107920:	83 e8 0c             	sub    $0xc,%eax
c0107923:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107926:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010792a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010792d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107930:	8b 40 08             	mov    0x8(%eax),%eax
c0107933:	29 c2                	sub    %eax,%edx
c0107935:	89 d0                	mov    %edx,%eax
c0107937:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010793a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010793d:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107940:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107943:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107946:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107949:	81 7d e8 b8 ef 19 c0 	cmpl   $0xc019efb8,-0x18(%ebp)
c0107950:	75 cb                	jne    c010791d <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107952:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107955:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107959:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010795c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107960:	c7 04 24 bd d5 10 c0 	movl   $0xc010d5bd,(%esp)
c0107967:	e8 e7 89 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010796c:	c7 04 24 d7 d5 10 c0 	movl   $0xc010d5d7,(%esp)
c0107973:	e8 db 89 ff ff       	call   c0100353 <cprintf>
}
c0107978:	83 c4 74             	add    $0x74,%esp
c010797b:	5b                   	pop    %ebx
c010797c:	5d                   	pop    %ebp
c010797d:	c3                   	ret    

c010797e <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010797e:	55                   	push   %ebp
c010797f:	89 e5                	mov    %esp,%ebp
c0107981:	83 ec 10             	sub    $0x10,%esp
c0107984:	c7 45 fc a4 f0 19 c0 	movl   $0xc019f0a4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010798b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010798e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107991:	89 50 04             	mov    %edx,0x4(%eax)
c0107994:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107997:	8b 50 04             	mov    0x4(%eax),%edx
c010799a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010799d:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010799f:	8b 45 08             	mov    0x8(%ebp),%eax
c01079a2:	c7 40 14 a4 f0 19 c0 	movl   $0xc019f0a4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01079a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01079ae:	c9                   	leave  
c01079af:	c3                   	ret    

c01079b0 <_fifo_map_swappable>:
 *                            then set the addr of addr of this page to ptr_page.
 */

static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01079b0:	55                   	push   %ebp
c01079b1:	89 e5                	mov    %esp,%ebp
c01079b3:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01079b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01079b9:	8b 40 14             	mov    0x14(%eax),%eax
c01079bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01079bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01079c2:	83 c0 14             	add    $0x14,%eax
c01079c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01079c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01079cc:	74 06                	je     c01079d4 <_fifo_map_swappable+0x24>
c01079ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01079d2:	75 24                	jne    c01079f8 <_fifo_map_swappable+0x48>
c01079d4:	c7 44 24 0c f0 d5 10 	movl   $0xc010d5f0,0xc(%esp)
c01079db:	c0 
c01079dc:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c01079e3:	c0 
c01079e4:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
c01079eb:	00 
c01079ec:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c01079f3:	e8 dd 93 ff ff       	call   c0100dd5 <__panic>
c01079f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01079fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a01:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a13:	8b 40 04             	mov    0x4(%eax),%eax
c0107a16:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107a19:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a1f:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107a22:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107a25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107a28:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107a2b:	89 10                	mov    %edx,(%eax)
c0107a2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107a30:	8b 10                	mov    (%eax),%edx
c0107a32:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107a35:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107a38:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107a3e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107a41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a44:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107a47:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);  /////
    return 0;
c0107a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107a4e:	c9                   	leave  
c0107a4f:	c3                   	ret    

c0107a50 <_fifo_swap_out_victim>:
}*/


static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107a50:	55                   	push   %ebp
c0107a51:	89 e5                	mov    %esp,%ebp
c0107a53:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a59:	8b 40 14             	mov    0x14(%eax),%eax
c0107a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107a5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107a63:	75 24                	jne    c0107a89 <_fifo_swap_out_victim+0x39>
c0107a65:	c7 44 24 0c 37 d6 10 	movl   $0xc010d637,0xc(%esp)
c0107a6c:	c0 
c0107a6d:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107a74:	c0 
c0107a75:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0107a7c:	00 
c0107a7d:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107a84:	e8 4c 93 ff ff       	call   c0100dd5 <__panic>
     assert(in_tick==0);
c0107a89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107a8d:	74 24                	je     c0107ab3 <_fifo_swap_out_victim+0x63>
c0107a8f:	c7 44 24 0c 44 d6 10 	movl   $0xc010d644,0xc(%esp)
c0107a96:	c0 
c0107a97:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107a9e:	c0 
c0107a9f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107aa6:	00 
c0107aa7:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107aae:	e8 22 93 ff ff       	call   c0100dd5 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page

     list_entry_t *le = head->prev;
c0107ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ab6:	8b 00                	mov    (%eax),%eax
c0107ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(le, pra_page_link);
c0107abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107abe:	83 e8 14             	sub    $0x14,%eax
c0107ac1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ac7:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107aca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107acd:	8b 40 04             	mov    0x4(%eax),%eax
c0107ad0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107ad3:	8b 12                	mov    (%edx),%edx
c0107ad5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ade:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107ae1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107aea:	89 10                	mov    %edx,(%eax)
     list_del(le);
     *ptr_page = page;
c0107aec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107af2:	89 10                	mov    %edx,(%eax)

     return 0;
c0107af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107af9:	c9                   	leave  
c0107afa:	c3                   	ret    

c0107afb <_fifo_check_swap>:



static int
_fifo_check_swap(void) {
c0107afb:	55                   	push   %ebp
c0107afc:	89 e5                	mov    %esp,%ebp
c0107afe:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107b01:	c7 04 24 50 d6 10 c0 	movl   $0xc010d650,(%esp)
c0107b08:	e8 46 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107b0d:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107b12:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107b15:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b1a:	83 f8 04             	cmp    $0x4,%eax
c0107b1d:	74 24                	je     c0107b43 <_fifo_check_swap+0x48>
c0107b1f:	c7 44 24 0c 76 d6 10 	movl   $0xc010d676,0xc(%esp)
c0107b26:	c0 
c0107b27:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107b2e:	c0 
c0107b2f:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0107b36:	00 
c0107b37:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107b3e:	e8 92 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107b43:	c7 04 24 88 d6 10 c0 	movl   $0xc010d688,(%esp)
c0107b4a:	e8 04 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107b4f:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107b54:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107b57:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b5c:	83 f8 04             	cmp    $0x4,%eax
c0107b5f:	74 24                	je     c0107b85 <_fifo_check_swap+0x8a>
c0107b61:	c7 44 24 0c 76 d6 10 	movl   $0xc010d676,0xc(%esp)
c0107b68:	c0 
c0107b69:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107b70:	c0 
c0107b71:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0107b78:	00 
c0107b79:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107b80:	e8 50 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107b85:	c7 04 24 b0 d6 10 c0 	movl   $0xc010d6b0,(%esp)
c0107b8c:	e8 c2 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107b91:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107b96:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107b99:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107b9e:	83 f8 04             	cmp    $0x4,%eax
c0107ba1:	74 24                	je     c0107bc7 <_fifo_check_swap+0xcc>
c0107ba3:	c7 44 24 0c 76 d6 10 	movl   $0xc010d676,0xc(%esp)
c0107baa:	c0 
c0107bab:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107bb2:	c0 
c0107bb3:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0107bba:	00 
c0107bbb:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107bc2:	e8 0e 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107bc7:	c7 04 24 d8 d6 10 c0 	movl   $0xc010d6d8,(%esp)
c0107bce:	e8 80 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107bd3:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107bd8:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107bdb:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107be0:	83 f8 04             	cmp    $0x4,%eax
c0107be3:	74 24                	je     c0107c09 <_fifo_check_swap+0x10e>
c0107be5:	c7 44 24 0c 76 d6 10 	movl   $0xc010d676,0xc(%esp)
c0107bec:	c0 
c0107bed:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107bf4:	c0 
c0107bf5:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0107bfc:	00 
c0107bfd:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107c04:	e8 cc 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107c09:	c7 04 24 00 d7 10 c0 	movl   $0xc010d700,(%esp)
c0107c10:	e8 3e 87 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107c15:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107c1a:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107c1d:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c22:	83 f8 05             	cmp    $0x5,%eax
c0107c25:	74 24                	je     c0107c4b <_fifo_check_swap+0x150>
c0107c27:	c7 44 24 0c 26 d7 10 	movl   $0xc010d726,0xc(%esp)
c0107c2e:	c0 
c0107c2f:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107c36:	c0 
c0107c37:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
c0107c3e:	00 
c0107c3f:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107c46:	e8 8a 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107c4b:	c7 04 24 d8 d6 10 c0 	movl   $0xc010d6d8,(%esp)
c0107c52:	e8 fc 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107c57:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107c5c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107c5f:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107c64:	83 f8 05             	cmp    $0x5,%eax
c0107c67:	74 24                	je     c0107c8d <_fifo_check_swap+0x192>
c0107c69:	c7 44 24 0c 26 d7 10 	movl   $0xc010d726,0xc(%esp)
c0107c70:	c0 
c0107c71:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107c78:	c0 
c0107c79:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
c0107c80:	00 
c0107c81:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107c88:	e8 48 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107c8d:	c7 04 24 88 d6 10 c0 	movl   $0xc010d688,(%esp)
c0107c94:	e8 ba 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107c99:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107c9e:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107ca1:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107ca6:	83 f8 06             	cmp    $0x6,%eax
c0107ca9:	74 24                	je     c0107ccf <_fifo_check_swap+0x1d4>
c0107cab:	c7 44 24 0c 35 d7 10 	movl   $0xc010d735,0xc(%esp)
c0107cb2:	c0 
c0107cb3:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107cba:	c0 
c0107cbb:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
c0107cc2:	00 
c0107cc3:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107cca:	e8 06 91 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107ccf:	c7 04 24 d8 d6 10 c0 	movl   $0xc010d6d8,(%esp)
c0107cd6:	e8 78 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107cdb:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107ce0:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107ce3:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107ce8:	83 f8 07             	cmp    $0x7,%eax
c0107ceb:	74 24                	je     c0107d11 <_fifo_check_swap+0x216>
c0107ced:	c7 44 24 0c 44 d7 10 	movl   $0xc010d744,0xc(%esp)
c0107cf4:	c0 
c0107cf5:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107cfc:	c0 
c0107cfd:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
c0107d04:	00 
c0107d05:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107d0c:	e8 c4 90 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107d11:	c7 04 24 50 d6 10 c0 	movl   $0xc010d650,(%esp)
c0107d18:	e8 36 86 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107d1d:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107d22:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107d25:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107d2a:	83 f8 08             	cmp    $0x8,%eax
c0107d2d:	74 24                	je     c0107d53 <_fifo_check_swap+0x258>
c0107d2f:	c7 44 24 0c 53 d7 10 	movl   $0xc010d753,0xc(%esp)
c0107d36:	c0 
c0107d37:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107d3e:	c0 
c0107d3f:	c7 44 24 04 8d 00 00 	movl   $0x8d,0x4(%esp)
c0107d46:	00 
c0107d47:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107d4e:	e8 82 90 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107d53:	c7 04 24 b0 d6 10 c0 	movl   $0xc010d6b0,(%esp)
c0107d5a:	e8 f4 85 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107d5f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107d64:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107d67:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0107d6c:	83 f8 09             	cmp    $0x9,%eax
c0107d6f:	74 24                	je     c0107d95 <_fifo_check_swap+0x29a>
c0107d71:	c7 44 24 0c 62 d7 10 	movl   $0xc010d762,0xc(%esp)
c0107d78:	c0 
c0107d79:	c7 44 24 08 0e d6 10 	movl   $0xc010d60e,0x8(%esp)
c0107d80:	c0 
c0107d81:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0107d88:	00 
c0107d89:	c7 04 24 23 d6 10 c0 	movl   $0xc010d623,(%esp)
c0107d90:	e8 40 90 ff ff       	call   c0100dd5 <__panic>
    return 0;
c0107d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d9a:	c9                   	leave  
c0107d9b:	c3                   	ret    

c0107d9c <_fifo_init>:


static int
_fifo_init(void)
{
c0107d9c:	55                   	push   %ebp
c0107d9d:	89 e5                	mov    %esp,%ebp
    return 0;
c0107d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107da4:	5d                   	pop    %ebp
c0107da5:	c3                   	ret    

c0107da6 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107da6:	55                   	push   %ebp
c0107da7:	89 e5                	mov    %esp,%ebp
    return 0;
c0107da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107dae:	5d                   	pop    %ebp
c0107daf:	c3                   	ret    

c0107db0 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107db0:	55                   	push   %ebp
c0107db1:	89 e5                	mov    %esp,%ebp
c0107db3:	b8 00 00 00 00       	mov    $0x0,%eax
c0107db8:	5d                   	pop    %ebp
c0107db9:	c3                   	ret    

c0107dba <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107dba:	55                   	push   %ebp
c0107dbb:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107dc6:	5d                   	pop    %ebp
c0107dc7:	c3                   	ret    

c0107dc8 <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107dc8:	55                   	push   %ebp
c0107dc9:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dce:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107dd1:	5d                   	pop    %ebp
c0107dd2:	c3                   	ret    

c0107dd3 <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107dd3:	55                   	push   %ebp
c0107dd4:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107ddc:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107ddf:	5d                   	pop    %ebp
c0107de0:	c3                   	ret    

c0107de1 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107de1:	55                   	push   %ebp
c0107de2:	89 e5                	mov    %esp,%ebp
c0107de4:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107de7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dea:	c1 e8 0c             	shr    $0xc,%eax
c0107ded:	89 c2                	mov    %eax,%edx
c0107def:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0107df4:	39 c2                	cmp    %eax,%edx
c0107df6:	72 1c                	jb     c0107e14 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107df8:	c7 44 24 08 84 d7 10 	movl   $0xc010d784,0x8(%esp)
c0107dff:	c0 
c0107e00:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107e07:	00 
c0107e08:	c7 04 24 a3 d7 10 c0 	movl   $0xc010d7a3,(%esp)
c0107e0f:	e8 c1 8f ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0107e14:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0107e19:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e1c:	c1 ea 0c             	shr    $0xc,%edx
c0107e1f:	c1 e2 05             	shl    $0x5,%edx
c0107e22:	01 d0                	add    %edx,%eax
}
c0107e24:	c9                   	leave  
c0107e25:	c3                   	ret    

c0107e26 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107e26:	55                   	push   %ebp
c0107e27:	89 e5                	mov    %esp,%ebp
c0107e29:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107e2c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107e33:	e8 1e ce ff ff       	call   c0104c56 <kmalloc>
c0107e38:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e3f:	74 79                	je     c0107eba <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0107e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107e4d:	89 50 04             	mov    %edx,0x4(%eax)
c0107e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e53:	8b 50 04             	mov    0x4(%eax),%edx
c0107e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e59:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e68:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e72:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107e79:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0107e7e:	85 c0                	test   %eax,%eax
c0107e80:	74 0d                	je     c0107e8f <mm_create+0x69>
c0107e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e85:	89 04 24             	mov    %eax,(%esp)
c0107e88:	e8 b4 ef ff ff       	call   c0106e41 <swap_init_mm>
c0107e8d:	eb 0a                	jmp    c0107e99 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e92:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c0107e99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107ea0:	00 
c0107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ea4:	89 04 24             	mov    %eax,(%esp)
c0107ea7:	e8 27 ff ff ff       	call   c0107dd3 <set_mm_count>
        lock_init(&(mm->mm_lock));
c0107eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107eaf:	83 c0 1c             	add    $0x1c,%eax
c0107eb2:	89 04 24             	mov    %eax,(%esp)
c0107eb5:	e8 00 ff ff ff       	call   c0107dba <lock_init>
    }    
    return mm;
c0107eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107ebd:	c9                   	leave  
c0107ebe:	c3                   	ret    

c0107ebf <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107ebf:	55                   	push   %ebp
c0107ec0:	89 e5                	mov    %esp,%ebp
c0107ec2:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107ec5:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107ecc:	e8 85 cd ff ff       	call   c0104c56 <kmalloc>
c0107ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ed8:	74 1b                	je     c0107ef5 <vma_create+0x36>
        vma->vm_start = vm_start;
c0107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107edd:	8b 55 08             	mov    0x8(%ebp),%edx
c0107ee0:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107ee9:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107eef:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ef2:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107ef8:	c9                   	leave  
c0107ef9:	c3                   	ret    

c0107efa <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107efa:	55                   	push   %ebp
c0107efb:	89 e5                	mov    %esp,%ebp
c0107efd:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107f00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107f07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107f0b:	0f 84 95 00 00 00    	je     c0107fa6 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107f11:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f14:	8b 40 08             	mov    0x8(%eax),%eax
c0107f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107f1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107f1e:	74 16                	je     c0107f36 <find_vma+0x3c>
c0107f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107f23:	8b 40 04             	mov    0x4(%eax),%eax
c0107f26:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107f29:	77 0b                	ja     c0107f36 <find_vma+0x3c>
c0107f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107f2e:	8b 40 08             	mov    0x8(%eax),%eax
c0107f31:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107f34:	77 61                	ja     c0107f97 <find_vma+0x9d>
                bool found = 0;
c0107f36:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107f3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107f49:	eb 28                	jmp    c0107f73 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f4e:	83 e8 10             	sub    $0x10,%eax
c0107f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107f57:	8b 40 04             	mov    0x4(%eax),%eax
c0107f5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107f5d:	77 14                	ja     c0107f73 <find_vma+0x79>
c0107f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107f62:	8b 40 08             	mov    0x8(%eax),%eax
c0107f65:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107f68:	76 09                	jbe    c0107f73 <find_vma+0x79>
                        found = 1;
c0107f6a:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107f71:	eb 17                	jmp    c0107f8a <find_vma+0x90>
c0107f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f7c:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107f88:	75 c1                	jne    c0107f4b <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107f8a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107f8e:	75 07                	jne    c0107f97 <find_vma+0x9d>
                    vma = NULL;
c0107f90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107f97:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107f9b:	74 09                	je     c0107fa6 <find_vma+0xac>
            mm->mmap_cache = vma;
c0107f9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107fa3:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107fa9:	c9                   	leave  
c0107faa:	c3                   	ret    

c0107fab <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107fab:	55                   	push   %ebp
c0107fac:	89 e5                	mov    %esp,%ebp
c0107fae:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107fb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fb4:	8b 50 04             	mov    0x4(%eax),%edx
c0107fb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fba:	8b 40 08             	mov    0x8(%eax),%eax
c0107fbd:	39 c2                	cmp    %eax,%edx
c0107fbf:	72 24                	jb     c0107fe5 <check_vma_overlap+0x3a>
c0107fc1:	c7 44 24 0c b1 d7 10 	movl   $0xc010d7b1,0xc(%esp)
c0107fc8:	c0 
c0107fc9:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0107fd0:	c0 
c0107fd1:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107fd8:	00 
c0107fd9:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0107fe0:	e8 f0 8d ff ff       	call   c0100dd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107fe5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe8:	8b 50 08             	mov    0x8(%eax),%edx
c0107feb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fee:	8b 40 04             	mov    0x4(%eax),%eax
c0107ff1:	39 c2                	cmp    %eax,%edx
c0107ff3:	76 24                	jbe    c0108019 <check_vma_overlap+0x6e>
c0107ff5:	c7 44 24 0c f4 d7 10 	movl   $0xc010d7f4,0xc(%esp)
c0107ffc:	c0 
c0107ffd:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108004:	c0 
c0108005:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c010800c:	00 
c010800d:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108014:	e8 bc 8d ff ff       	call   c0100dd5 <__panic>
    assert(next->vm_start < next->vm_end);
c0108019:	8b 45 0c             	mov    0xc(%ebp),%eax
c010801c:	8b 50 04             	mov    0x4(%eax),%edx
c010801f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108022:	8b 40 08             	mov    0x8(%eax),%eax
c0108025:	39 c2                	cmp    %eax,%edx
c0108027:	72 24                	jb     c010804d <check_vma_overlap+0xa2>
c0108029:	c7 44 24 0c 13 d8 10 	movl   $0xc010d813,0xc(%esp)
c0108030:	c0 
c0108031:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108038:	c0 
c0108039:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0108040:	00 
c0108041:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108048:	e8 88 8d ff ff       	call   c0100dd5 <__panic>
}
c010804d:	c9                   	leave  
c010804e:	c3                   	ret    

c010804f <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010804f:	55                   	push   %ebp
c0108050:	89 e5                	mov    %esp,%ebp
c0108052:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0108055:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108058:	8b 50 04             	mov    0x4(%eax),%edx
c010805b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010805e:	8b 40 08             	mov    0x8(%eax),%eax
c0108061:	39 c2                	cmp    %eax,%edx
c0108063:	72 24                	jb     c0108089 <insert_vma_struct+0x3a>
c0108065:	c7 44 24 0c 31 d8 10 	movl   $0xc010d831,0xc(%esp)
c010806c:	c0 
c010806d:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108074:	c0 
c0108075:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c010807c:	00 
c010807d:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108084:	e8 4c 8d ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0108089:	8b 45 08             	mov    0x8(%ebp),%eax
c010808c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010808f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108092:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0108095:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108098:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010809b:	eb 21                	jmp    c01080be <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010809d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080a0:	83 e8 10             	sub    $0x10,%eax
c01080a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01080a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080a9:	8b 50 04             	mov    0x4(%eax),%edx
c01080ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080af:	8b 40 04             	mov    0x4(%eax),%eax
c01080b2:	39 c2                	cmp    %eax,%edx
c01080b4:	76 02                	jbe    c01080b8 <insert_vma_struct+0x69>
                break;
c01080b6:	eb 1d                	jmp    c01080d5 <insert_vma_struct+0x86>
            }
            le_prev = le;
c01080b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01080be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01080c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01080c7:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c01080ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080d3:	75 c8                	jne    c010809d <insert_vma_struct+0x4e>
c01080d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01080db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080de:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01080e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01080e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080ea:	74 15                	je     c0108101 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01080ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080ef:	8d 50 f0             	lea    -0x10(%eax),%edx
c01080f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080f9:	89 14 24             	mov    %edx,(%esp)
c01080fc:	e8 aa fe ff ff       	call   c0107fab <check_vma_overlap>
    }
    if (le_next != list) {
c0108101:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108104:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108107:	74 15                	je     c010811e <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0108109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010810c:	83 e8 10             	sub    $0x10,%eax
c010810f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108113:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108116:	89 04 24             	mov    %eax,(%esp)
c0108119:	e8 8d fe ff ff       	call   c0107fab <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010811e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108121:	8b 55 08             	mov    0x8(%ebp),%edx
c0108124:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0108126:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108129:	8d 50 10             	lea    0x10(%eax),%edx
c010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010812f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108132:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108135:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108138:	8b 40 04             	mov    0x4(%eax),%eax
c010813b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010813e:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0108141:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108144:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0108147:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010814a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010814d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108150:	89 10                	mov    %edx,(%eax)
c0108152:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108155:	8b 10                	mov    (%eax),%edx
c0108157:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010815a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010815d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108160:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0108163:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108166:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108169:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010816c:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010816e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108171:	8b 40 10             	mov    0x10(%eax),%eax
c0108174:	8d 50 01             	lea    0x1(%eax),%edx
c0108177:	8b 45 08             	mov    0x8(%ebp),%eax
c010817a:	89 50 10             	mov    %edx,0x10(%eax)
}
c010817d:	c9                   	leave  
c010817e:	c3                   	ret    

c010817f <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010817f:	55                   	push   %ebp
c0108180:	89 e5                	mov    %esp,%ebp
c0108182:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c0108185:	8b 45 08             	mov    0x8(%ebp),%eax
c0108188:	89 04 24             	mov    %eax,(%esp)
c010818b:	e8 38 fc ff ff       	call   c0107dc8 <mm_count>
c0108190:	85 c0                	test   %eax,%eax
c0108192:	74 24                	je     c01081b8 <mm_destroy+0x39>
c0108194:	c7 44 24 0c 4d d8 10 	movl   $0xc010d84d,0xc(%esp)
c010819b:	c0 
c010819c:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c01081a3:	c0 
c01081a4:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01081ab:	00 
c01081ac:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c01081b3:	e8 1d 8c ff ff       	call   c0100dd5 <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c01081b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01081bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c01081be:	eb 36                	jmp    c01081f6 <mm_destroy+0x77>
c01081c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01081c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081c9:	8b 40 04             	mov    0x4(%eax),%eax
c01081cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01081cf:	8b 12                	mov    (%edx),%edx
c01081d1:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01081d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01081d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01081dd:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01081e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01081e6:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c01081e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01081eb:	83 e8 10             	sub    $0x10,%eax
c01081ee:	89 04 24             	mov    %eax,(%esp)
c01081f1:	e8 7b ca ff ff       	call   c0104c71 <kfree>
c01081f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01081fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01081ff:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0108202:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108205:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108208:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010820b:	75 b3                	jne    c01081c0 <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c010820d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108210:	89 04 24             	mov    %eax,(%esp)
c0108213:	e8 59 ca ff ff       	call   c0104c71 <kfree>
    mm=NULL;
c0108218:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c010821f:	c9                   	leave  
c0108220:	c3                   	ret    

c0108221 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c0108221:	55                   	push   %ebp
c0108222:	89 e5                	mov    %esp,%ebp
c0108224:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c0108227:	8b 45 0c             	mov    0xc(%ebp),%eax
c010822a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010822d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108230:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108235:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108238:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c010823f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108242:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108245:	01 c2                	add    %eax,%edx
c0108247:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010824a:	01 d0                	add    %edx,%eax
c010824c:	83 e8 01             	sub    $0x1,%eax
c010824f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108255:	ba 00 00 00 00       	mov    $0x0,%edx
c010825a:	f7 75 e8             	divl   -0x18(%ebp)
c010825d:	89 d0                	mov    %edx,%eax
c010825f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108262:	29 c2                	sub    %eax,%edx
c0108264:	89 d0                	mov    %edx,%eax
c0108266:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c0108269:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c0108270:	76 11                	jbe    c0108283 <mm_map+0x62>
c0108272:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108275:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108278:	73 09                	jae    c0108283 <mm_map+0x62>
c010827a:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c0108281:	76 0a                	jbe    c010828d <mm_map+0x6c>
        return -E_INVAL;
c0108283:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108288:	e9 ae 00 00 00       	jmp    c010833b <mm_map+0x11a>
    }

    assert(mm != NULL);
c010828d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108291:	75 24                	jne    c01082b7 <mm_map+0x96>
c0108293:	c7 44 24 0c 5f d8 10 	movl   $0xc010d85f,0xc(%esp)
c010829a:	c0 
c010829b:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c01082a2:	c0 
c01082a3:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c01082aa:	00 
c01082ab:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c01082b2:	e8 1e 8b ff ff       	call   c0100dd5 <__panic>

    int ret = -E_INVAL;
c01082b7:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c01082be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c8:	89 04 24             	mov    %eax,(%esp)
c01082cb:	e8 2a fc ff ff       	call   c0107efa <find_vma>
c01082d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01082d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01082d7:	74 0d                	je     c01082e6 <mm_map+0xc5>
c01082d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082dc:	8b 40 04             	mov    0x4(%eax),%eax
c01082df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01082e2:	73 02                	jae    c01082e6 <mm_map+0xc5>
        goto out;
c01082e4:	eb 52                	jmp    c0108338 <mm_map+0x117>
    }
    ret = -E_NO_MEM;
c01082e6:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c01082ed:	8b 45 14             	mov    0x14(%ebp),%eax
c01082f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01082fe:	89 04 24             	mov    %eax,(%esp)
c0108301:	e8 b9 fb ff ff       	call   c0107ebf <vma_create>
c0108306:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108309:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010830d:	75 02                	jne    c0108311 <mm_map+0xf0>
        goto out;
c010830f:	eb 27                	jmp    c0108338 <mm_map+0x117>
    }
    insert_vma_struct(mm, vma);
c0108311:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108314:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108318:	8b 45 08             	mov    0x8(%ebp),%eax
c010831b:	89 04 24             	mov    %eax,(%esp)
c010831e:	e8 2c fd ff ff       	call   c010804f <insert_vma_struct>
    if (vma_store != NULL) {
c0108323:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0108327:	74 08                	je     c0108331 <mm_map+0x110>
        *vma_store = vma;
c0108329:	8b 45 18             	mov    0x18(%ebp),%eax
c010832c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010832f:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c0108331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

out:
    return ret;
c0108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010833b:	c9                   	leave  
c010833c:	c3                   	ret    

c010833d <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c010833d:	55                   	push   %ebp
c010833e:	89 e5                	mov    %esp,%ebp
c0108340:	56                   	push   %esi
c0108341:	53                   	push   %ebx
c0108342:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c0108345:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108349:	74 06                	je     c0108351 <dup_mmap+0x14>
c010834b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010834f:	75 24                	jne    c0108375 <dup_mmap+0x38>
c0108351:	c7 44 24 0c 6a d8 10 	movl   $0xc010d86a,0xc(%esp)
c0108358:	c0 
c0108359:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108360:	c0 
c0108361:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0108368:	00 
c0108369:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108370:	e8 60 8a ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c0108375:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108378:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010837b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010837e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c0108381:	e9 92 00 00 00       	jmp    c0108418 <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c0108386:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108389:	83 e8 10             	sub    $0x10,%eax
c010838c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c010838f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108392:	8b 48 0c             	mov    0xc(%eax),%ecx
c0108395:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108398:	8b 50 08             	mov    0x8(%eax),%edx
c010839b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010839e:	8b 40 04             	mov    0x4(%eax),%eax
c01083a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01083a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083a9:	89 04 24             	mov    %eax,(%esp)
c01083ac:	e8 0e fb ff ff       	call   c0107ebf <vma_create>
c01083b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c01083b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01083b8:	75 07                	jne    c01083c1 <dup_mmap+0x84>
            return -E_NO_MEM;
c01083ba:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01083bf:	eb 76                	jmp    c0108437 <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c01083c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01083c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01083cb:	89 04 24             	mov    %eax,(%esp)
c01083ce:	e8 7c fc ff ff       	call   c010804f <insert_vma_struct>

        bool share = 0;
c01083d3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c01083da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083dd:	8b 58 08             	mov    0x8(%eax),%ebx
c01083e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083e3:	8b 48 04             	mov    0x4(%eax),%ecx
c01083e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083e9:	8b 50 0c             	mov    0xc(%eax),%edx
c01083ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ef:	8b 40 0c             	mov    0xc(%eax),%eax
c01083f2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c01083f5:	89 74 24 10          	mov    %esi,0x10(%esp)
c01083f9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01083fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108401:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108405:	89 04 24             	mov    %eax,(%esp)
c0108408:	e8 17 d8 ff ff       	call   c0105c24 <copy_range>
c010840d:	85 c0                	test   %eax,%eax
c010840f:	74 07                	je     c0108418 <dup_mmap+0xdb>
            return -E_NO_MEM;
c0108411:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108416:	eb 1f                	jmp    c0108437 <dup_mmap+0xfa>
c0108418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010841b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010841e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108421:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c0108423:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108426:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108429:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010842c:	0f 85 54 ff ff ff    	jne    c0108386 <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c0108432:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108437:	83 c4 40             	add    $0x40,%esp
c010843a:	5b                   	pop    %ebx
c010843b:	5e                   	pop    %esi
c010843c:	5d                   	pop    %ebp
c010843d:	c3                   	ret    

c010843e <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c010843e:	55                   	push   %ebp
c010843f:	89 e5                	mov    %esp,%ebp
c0108441:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c0108444:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108448:	74 0f                	je     c0108459 <exit_mmap+0x1b>
c010844a:	8b 45 08             	mov    0x8(%ebp),%eax
c010844d:	89 04 24             	mov    %eax,(%esp)
c0108450:	e8 73 f9 ff ff       	call   c0107dc8 <mm_count>
c0108455:	85 c0                	test   %eax,%eax
c0108457:	74 24                	je     c010847d <exit_mmap+0x3f>
c0108459:	c7 44 24 0c 88 d8 10 	movl   $0xc010d888,0xc(%esp)
c0108460:	c0 
c0108461:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108468:	c0 
c0108469:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0108470:	00 
c0108471:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108478:	e8 58 89 ff ff       	call   c0100dd5 <__panic>
    pde_t *pgdir = mm->pgdir;
c010847d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108480:	8b 40 0c             	mov    0xc(%eax),%eax
c0108483:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c0108486:	8b 45 08             	mov    0x8(%ebp),%eax
c0108489:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010848c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010848f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c0108492:	eb 28                	jmp    c01084bc <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c0108494:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108497:	83 e8 10             	sub    $0x10,%eax
c010849a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c010849d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084a0:	8b 50 08             	mov    0x8(%eax),%edx
c01084a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084a6:	8b 40 04             	mov    0x4(%eax),%eax
c01084a9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01084ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084b4:	89 04 24             	mov    %eax,(%esp)
c01084b7:	e8 6d d5 ff ff       	call   c0105a29 <unmap_range>
c01084bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01084c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084c5:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c01084c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01084d1:	75 c1                	jne    c0108494 <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01084d3:	eb 28                	jmp    c01084fd <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c01084d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084d8:	83 e8 10             	sub    $0x10,%eax
c01084db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c01084de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01084e1:	8b 50 08             	mov    0x8(%eax),%edx
c01084e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01084e7:	8b 40 04             	mov    0x4(%eax),%eax
c01084ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01084ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084f5:	89 04 24             	mov    %eax,(%esp)
c01084f8:	e8 20 d6 ff ff       	call   c0105b1d <exit_range>
c01084fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108500:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108503:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108506:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c0108509:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010850c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010850f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108512:	75 c1                	jne    c01084d5 <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c0108514:	c9                   	leave  
c0108515:	c3                   	ret    

c0108516 <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c0108516:	55                   	push   %ebp
c0108517:	89 e5                	mov    %esp,%ebp
c0108519:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c010851c:	8b 45 10             	mov    0x10(%ebp),%eax
c010851f:	8b 55 18             	mov    0x18(%ebp),%edx
c0108522:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108526:	8b 55 14             	mov    0x14(%ebp),%edx
c0108529:	89 54 24 08          	mov    %edx,0x8(%esp)
c010852d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108531:	8b 45 08             	mov    0x8(%ebp),%eax
c0108534:	89 04 24             	mov    %eax,(%esp)
c0108537:	e8 6a 09 00 00       	call   c0108ea6 <user_mem_check>
c010853c:	85 c0                	test   %eax,%eax
c010853e:	75 07                	jne    c0108547 <copy_from_user+0x31>
        return 0;
c0108540:	b8 00 00 00 00       	mov    $0x0,%eax
c0108545:	eb 1e                	jmp    c0108565 <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c0108547:	8b 45 14             	mov    0x14(%ebp),%eax
c010854a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010854e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108551:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108558:	89 04 24             	mov    %eax,(%esp)
c010855b:	e8 30 37 00 00       	call   c010bc90 <memcpy>
    return 1;
c0108560:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108565:	c9                   	leave  
c0108566:	c3                   	ret    

c0108567 <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c0108567:	55                   	push   %ebp
c0108568:	89 e5                	mov    %esp,%ebp
c010856a:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c010856d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108570:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108577:	00 
c0108578:	8b 55 14             	mov    0x14(%ebp),%edx
c010857b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010857f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108583:	8b 45 08             	mov    0x8(%ebp),%eax
c0108586:	89 04 24             	mov    %eax,(%esp)
c0108589:	e8 18 09 00 00       	call   c0108ea6 <user_mem_check>
c010858e:	85 c0                	test   %eax,%eax
c0108590:	75 07                	jne    c0108599 <copy_to_user+0x32>
        return 0;
c0108592:	b8 00 00 00 00       	mov    $0x0,%eax
c0108597:	eb 1e                	jmp    c01085b7 <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c0108599:	8b 45 14             	mov    0x14(%ebp),%eax
c010859c:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01085a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085aa:	89 04 24             	mov    %eax,(%esp)
c01085ad:	e8 de 36 00 00       	call   c010bc90 <memcpy>
    return 1;
c01085b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01085b7:	c9                   	leave  
c01085b8:	c3                   	ret    

c01085b9 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01085b9:	55                   	push   %ebp
c01085ba:	89 e5                	mov    %esp,%ebp
c01085bc:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01085bf:	e8 02 00 00 00       	call   c01085c6 <check_vmm>
}
c01085c4:	c9                   	leave  
c01085c5:	c3                   	ret    

c01085c6 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01085c6:	55                   	push   %ebp
c01085c7:	89 e5                	mov    %esp,%ebp
c01085c9:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01085cc:	e8 97 cb ff ff       	call   c0105168 <nr_free_pages>
c01085d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01085d4:	e8 13 00 00 00       	call   c01085ec <check_vma_struct>
    check_pgfault();
c01085d9:	e8 a7 04 00 00       	call   c0108a85 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c01085de:	c7 04 24 a8 d8 10 c0 	movl   $0xc010d8a8,(%esp)
c01085e5:	e8 69 7d ff ff       	call   c0100353 <cprintf>
}
c01085ea:	c9                   	leave  
c01085eb:	c3                   	ret    

c01085ec <check_vma_struct>:

static void
check_vma_struct(void) {
c01085ec:	55                   	push   %ebp
c01085ed:	89 e5                	mov    %esp,%ebp
c01085ef:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01085f2:	e8 71 cb ff ff       	call   c0105168 <nr_free_pages>
c01085f7:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01085fa:	e8 27 f8 ff ff       	call   c0107e26 <mm_create>
c01085ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0108602:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108606:	75 24                	jne    c010862c <check_vma_struct+0x40>
c0108608:	c7 44 24 0c 5f d8 10 	movl   $0xc010d85f,0xc(%esp)
c010860f:	c0 
c0108610:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108617:	c0 
c0108618:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010861f:	00 
c0108620:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108627:	e8 a9 87 ff ff       	call   c0100dd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c010862c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0108633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108636:	89 d0                	mov    %edx,%eax
c0108638:	c1 e0 02             	shl    $0x2,%eax
c010863b:	01 d0                	add    %edx,%eax
c010863d:	01 c0                	add    %eax,%eax
c010863f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0108642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108645:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108648:	eb 70                	jmp    c01086ba <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010864a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010864d:	89 d0                	mov    %edx,%eax
c010864f:	c1 e0 02             	shl    $0x2,%eax
c0108652:	01 d0                	add    %edx,%eax
c0108654:	83 c0 02             	add    $0x2,%eax
c0108657:	89 c1                	mov    %eax,%ecx
c0108659:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010865c:	89 d0                	mov    %edx,%eax
c010865e:	c1 e0 02             	shl    $0x2,%eax
c0108661:	01 d0                	add    %edx,%eax
c0108663:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010866a:	00 
c010866b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010866f:	89 04 24             	mov    %eax,(%esp)
c0108672:	e8 48 f8 ff ff       	call   c0107ebf <vma_create>
c0108677:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c010867a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010867e:	75 24                	jne    c01086a4 <check_vma_struct+0xb8>
c0108680:	c7 44 24 0c c0 d8 10 	movl   $0xc010d8c0,0xc(%esp)
c0108687:	c0 
c0108688:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c010868f:	c0 
c0108690:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0108697:	00 
c0108698:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c010869f:	e8 31 87 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c01086a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01086a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086ae:	89 04 24             	mov    %eax,(%esp)
c01086b1:	e8 99 f9 ff ff       	call   c010804f <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01086b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01086ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01086be:	7f 8a                	jg     c010864a <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01086c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01086c3:	83 c0 01             	add    $0x1,%eax
c01086c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086c9:	eb 70                	jmp    c010873b <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01086cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086ce:	89 d0                	mov    %edx,%eax
c01086d0:	c1 e0 02             	shl    $0x2,%eax
c01086d3:	01 d0                	add    %edx,%eax
c01086d5:	83 c0 02             	add    $0x2,%eax
c01086d8:	89 c1                	mov    %eax,%ecx
c01086da:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086dd:	89 d0                	mov    %edx,%eax
c01086df:	c1 e0 02             	shl    $0x2,%eax
c01086e2:	01 d0                	add    %edx,%eax
c01086e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01086eb:	00 
c01086ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01086f0:	89 04 24             	mov    %eax,(%esp)
c01086f3:	e8 c7 f7 ff ff       	call   c0107ebf <vma_create>
c01086f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01086fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01086ff:	75 24                	jne    c0108725 <check_vma_struct+0x139>
c0108701:	c7 44 24 0c c0 d8 10 	movl   $0xc010d8c0,0xc(%esp)
c0108708:	c0 
c0108709:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108710:	c0 
c0108711:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0108718:	00 
c0108719:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108720:	e8 b0 86 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c0108725:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108728:	89 44 24 04          	mov    %eax,0x4(%esp)
c010872c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010872f:	89 04 24             	mov    %eax,(%esp)
c0108732:	e8 18 f9 ff ff       	call   c010804f <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108737:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010873b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010873e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108741:	7e 88                	jle    c01086cb <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0108743:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108746:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0108749:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010874c:	8b 40 04             	mov    0x4(%eax),%eax
c010874f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0108752:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0108759:	e9 97 00 00 00       	jmp    c01087f5 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c010875e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108761:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108764:	75 24                	jne    c010878a <check_vma_struct+0x19e>
c0108766:	c7 44 24 0c cc d8 10 	movl   $0xc010d8cc,0xc(%esp)
c010876d:	c0 
c010876e:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108775:	c0 
c0108776:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c010877d:	00 
c010877e:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108785:	e8 4b 86 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c010878a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010878d:	83 e8 10             	sub    $0x10,%eax
c0108790:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0108793:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108796:	8b 48 04             	mov    0x4(%eax),%ecx
c0108799:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010879c:	89 d0                	mov    %edx,%eax
c010879e:	c1 e0 02             	shl    $0x2,%eax
c01087a1:	01 d0                	add    %edx,%eax
c01087a3:	39 c1                	cmp    %eax,%ecx
c01087a5:	75 17                	jne    c01087be <check_vma_struct+0x1d2>
c01087a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01087aa:	8b 48 08             	mov    0x8(%eax),%ecx
c01087ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01087b0:	89 d0                	mov    %edx,%eax
c01087b2:	c1 e0 02             	shl    $0x2,%eax
c01087b5:	01 d0                	add    %edx,%eax
c01087b7:	83 c0 02             	add    $0x2,%eax
c01087ba:	39 c1                	cmp    %eax,%ecx
c01087bc:	74 24                	je     c01087e2 <check_vma_struct+0x1f6>
c01087be:	c7 44 24 0c e4 d8 10 	movl   $0xc010d8e4,0xc(%esp)
c01087c5:	c0 
c01087c6:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c01087cd:	c0 
c01087ce:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01087d5:	00 
c01087d6:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c01087dd:	e8 f3 85 ff ff       	call   c0100dd5 <__panic>
c01087e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087e5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01087e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01087eb:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01087ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01087f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01087f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087f8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01087fb:	0f 8e 5d ff ff ff    	jle    c010875e <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108801:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0108808:	e9 cd 01 00 00       	jmp    c01089da <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c010880d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108810:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108814:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108817:	89 04 24             	mov    %eax,(%esp)
c010881a:	e8 db f6 ff ff       	call   c0107efa <find_vma>
c010881f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0108822:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0108826:	75 24                	jne    c010884c <check_vma_struct+0x260>
c0108828:	c7 44 24 0c 19 d9 10 	movl   $0xc010d919,0xc(%esp)
c010882f:	c0 
c0108830:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108837:	c0 
c0108838:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010883f:	00 
c0108840:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108847:	e8 89 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c010884c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010884f:	83 c0 01             	add    $0x1,%eax
c0108852:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108856:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108859:	89 04 24             	mov    %eax,(%esp)
c010885c:	e8 99 f6 ff ff       	call   c0107efa <find_vma>
c0108861:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0108864:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0108868:	75 24                	jne    c010888e <check_vma_struct+0x2a2>
c010886a:	c7 44 24 0c 26 d9 10 	movl   $0xc010d926,0xc(%esp)
c0108871:	c0 
c0108872:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108879:	c0 
c010887a:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0108881:	00 
c0108882:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108889:	e8 47 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c010888e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108891:	83 c0 02             	add    $0x2,%eax
c0108894:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108898:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010889b:	89 04 24             	mov    %eax,(%esp)
c010889e:	e8 57 f6 ff ff       	call   c0107efa <find_vma>
c01088a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c01088a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01088aa:	74 24                	je     c01088d0 <check_vma_struct+0x2e4>
c01088ac:	c7 44 24 0c 33 d9 10 	movl   $0xc010d933,0xc(%esp)
c01088b3:	c0 
c01088b4:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c01088bb:	c0 
c01088bc:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01088c3:	00 
c01088c4:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c01088cb:	e8 05 85 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01088d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088d3:	83 c0 03             	add    $0x3,%eax
c01088d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088da:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088dd:	89 04 24             	mov    %eax,(%esp)
c01088e0:	e8 15 f6 ff ff       	call   c0107efa <find_vma>
c01088e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01088e8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01088ec:	74 24                	je     c0108912 <check_vma_struct+0x326>
c01088ee:	c7 44 24 0c 40 d9 10 	movl   $0xc010d940,0xc(%esp)
c01088f5:	c0 
c01088f6:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c01088fd:	c0 
c01088fe:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0108905:	00 
c0108906:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c010890d:	e8 c3 84 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0108912:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108915:	83 c0 04             	add    $0x4,%eax
c0108918:	89 44 24 04          	mov    %eax,0x4(%esp)
c010891c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010891f:	89 04 24             	mov    %eax,(%esp)
c0108922:	e8 d3 f5 ff ff       	call   c0107efa <find_vma>
c0108927:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010892a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010892e:	74 24                	je     c0108954 <check_vma_struct+0x368>
c0108930:	c7 44 24 0c 4d d9 10 	movl   $0xc010d94d,0xc(%esp)
c0108937:	c0 
c0108938:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c010893f:	c0 
c0108940:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0108947:	00 
c0108948:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c010894f:	e8 81 84 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0108954:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108957:	8b 50 04             	mov    0x4(%eax),%edx
c010895a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010895d:	39 c2                	cmp    %eax,%edx
c010895f:	75 10                	jne    c0108971 <check_vma_struct+0x385>
c0108961:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108964:	8b 50 08             	mov    0x8(%eax),%edx
c0108967:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010896a:	83 c0 02             	add    $0x2,%eax
c010896d:	39 c2                	cmp    %eax,%edx
c010896f:	74 24                	je     c0108995 <check_vma_struct+0x3a9>
c0108971:	c7 44 24 0c 5c d9 10 	movl   $0xc010d95c,0xc(%esp)
c0108978:	c0 
c0108979:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108980:	c0 
c0108981:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0108988:	00 
c0108989:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108990:	e8 40 84 ff ff       	call   c0100dd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108995:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108998:	8b 50 04             	mov    0x4(%eax),%edx
c010899b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010899e:	39 c2                	cmp    %eax,%edx
c01089a0:	75 10                	jne    c01089b2 <check_vma_struct+0x3c6>
c01089a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01089a5:	8b 50 08             	mov    0x8(%eax),%edx
c01089a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089ab:	83 c0 02             	add    $0x2,%eax
c01089ae:	39 c2                	cmp    %eax,%edx
c01089b0:	74 24                	je     c01089d6 <check_vma_struct+0x3ea>
c01089b2:	c7 44 24 0c 8c d9 10 	movl   $0xc010d98c,0xc(%esp)
c01089b9:	c0 
c01089ba:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c01089c1:	c0 
c01089c2:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01089c9:	00 
c01089ca:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c01089d1:	e8 ff 83 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01089d6:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01089da:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01089dd:	89 d0                	mov    %edx,%eax
c01089df:	c1 e0 02             	shl    $0x2,%eax
c01089e2:	01 d0                	add    %edx,%eax
c01089e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01089e7:	0f 8d 20 fe ff ff    	jge    c010880d <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01089ed:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01089f4:	eb 70                	jmp    c0108a66 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01089f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a00:	89 04 24             	mov    %eax,(%esp)
c0108a03:	e8 f2 f4 ff ff       	call   c0107efa <find_vma>
c0108a08:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0108a0b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108a0f:	74 27                	je     c0108a38 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0108a11:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108a14:	8b 50 08             	mov    0x8(%eax),%edx
c0108a17:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108a1a:	8b 40 04             	mov    0x4(%eax),%eax
c0108a1d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108a21:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a2c:	c7 04 24 bc d9 10 c0 	movl   $0xc010d9bc,(%esp)
c0108a33:	e8 1b 79 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0108a38:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108a3c:	74 24                	je     c0108a62 <check_vma_struct+0x476>
c0108a3e:	c7 44 24 0c e1 d9 10 	movl   $0xc010d9e1,0xc(%esp)
c0108a45:	c0 
c0108a46:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108a4d:	c0 
c0108a4e:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0108a55:	00 
c0108a56:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108a5d:	e8 73 83 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0108a62:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108a6a:	79 8a                	jns    c01089f6 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0108a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a6f:	89 04 24             	mov    %eax,(%esp)
c0108a72:	e8 08 f7 ff ff       	call   c010817f <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108a77:	c7 04 24 f8 d9 10 c0 	movl   $0xc010d9f8,(%esp)
c0108a7e:	e8 d0 78 ff ff       	call   c0100353 <cprintf>
}
c0108a83:	c9                   	leave  
c0108a84:	c3                   	ret    

c0108a85 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0108a85:	55                   	push   %ebp
c0108a86:	89 e5                	mov    %esp,%ebp
c0108a88:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108a8b:	e8 d8 c6 ff ff       	call   c0105168 <nr_free_pages>
c0108a90:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108a93:	e8 8e f3 ff ff       	call   c0107e26 <mm_create>
c0108a98:	a3 ac f0 19 c0       	mov    %eax,0xc019f0ac
    assert(check_mm_struct != NULL);
c0108a9d:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108aa2:	85 c0                	test   %eax,%eax
c0108aa4:	75 24                	jne    c0108aca <check_pgfault+0x45>
c0108aa6:	c7 44 24 0c 17 da 10 	movl   $0xc010da17,0xc(%esp)
c0108aad:	c0 
c0108aae:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108ab5:	c0 
c0108ab6:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0108abd:	00 
c0108abe:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108ac5:	e8 0b 83 ff ff       	call   c0100dd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108aca:	a1 ac f0 19 c0       	mov    0xc019f0ac,%eax
c0108acf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108ad2:	8b 15 e4 ce 19 c0    	mov    0xc019cee4,%edx
c0108ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108adb:	89 50 0c             	mov    %edx,0xc(%eax)
c0108ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108ae1:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ae4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108aea:	8b 00                	mov    (%eax),%eax
c0108aec:	85 c0                	test   %eax,%eax
c0108aee:	74 24                	je     c0108b14 <check_pgfault+0x8f>
c0108af0:	c7 44 24 0c 2f da 10 	movl   $0xc010da2f,0xc(%esp)
c0108af7:	c0 
c0108af8:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108aff:	c0 
c0108b00:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0108b07:	00 
c0108b08:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108b0f:	e8 c1 82 ff ff       	call   c0100dd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108b14:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0108b1b:	00 
c0108b1c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108b23:	00 
c0108b24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108b2b:	e8 8f f3 ff ff       	call   c0107ebf <vma_create>
c0108b30:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0108b33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108b37:	75 24                	jne    c0108b5d <check_pgfault+0xd8>
c0108b39:	c7 44 24 0c c0 d8 10 	movl   $0xc010d8c0,0xc(%esp)
c0108b40:	c0 
c0108b41:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108b48:	c0 
c0108b49:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0108b50:	00 
c0108b51:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108b58:	e8 78 82 ff ff       	call   c0100dd5 <__panic>

    insert_vma_struct(mm, vma);
c0108b5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b67:	89 04 24             	mov    %eax,(%esp)
c0108b6a:	e8 e0 f4 ff ff       	call   c010804f <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108b6f:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108b76:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b80:	89 04 24             	mov    %eax,(%esp)
c0108b83:	e8 72 f3 ff ff       	call   c0107efa <find_vma>
c0108b88:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108b8b:	74 24                	je     c0108bb1 <check_pgfault+0x12c>
c0108b8d:	c7 44 24 0c 3d da 10 	movl   $0xc010da3d,0xc(%esp)
c0108b94:	c0 
c0108b95:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108b9c:	c0 
c0108b9d:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0108ba4:	00 
c0108ba5:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108bac:	e8 24 82 ff ff       	call   c0100dd5 <__panic>

    int i, sum = 0;
c0108bb1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108bbf:	eb 17                	jmp    c0108bd8 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108bc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108bc7:	01 d0                	add    %edx,%eax
c0108bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108bcc:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bd1:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108bd4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108bd8:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108bdc:	7e e3                	jle    c0108bc1 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108bde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108be5:	eb 15                	jmp    c0108bfc <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108bea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108bed:	01 d0                	add    %edx,%eax
c0108bef:	0f b6 00             	movzbl (%eax),%eax
c0108bf2:	0f be c0             	movsbl %al,%eax
c0108bf5:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108bf8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108bfc:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108c00:	7e e5                	jle    c0108be7 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108c02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108c06:	74 24                	je     c0108c2c <check_pgfault+0x1a7>
c0108c08:	c7 44 24 0c 57 da 10 	movl   $0xc010da57,0xc(%esp)
c0108c0f:	c0 
c0108c10:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108c17:	c0 
c0108c18:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c0108c1f:	00 
c0108c20:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108c27:	e8 a9 81 ff ff       	call   c0100dd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108c2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108c32:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c41:	89 04 24             	mov    %eax,(%esp)
c0108c44:	e8 fe d1 ff ff       	call   c0105e47 <page_remove>
    free_page(pa2page(pgdir[0]));
c0108c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c4c:	8b 00                	mov    (%eax),%eax
c0108c4e:	89 04 24             	mov    %eax,(%esp)
c0108c51:	e8 8b f1 ff ff       	call   c0107de1 <pa2page>
c0108c56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108c5d:	00 
c0108c5e:	89 04 24             	mov    %eax,(%esp)
c0108c61:	e8 d0 c4 ff ff       	call   c0105136 <free_pages>
    pgdir[0] = 0;
c0108c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c7c:	89 04 24             	mov    %eax,(%esp)
c0108c7f:	e8 fb f4 ff ff       	call   c010817f <mm_destroy>
    check_mm_struct = NULL;
c0108c84:	c7 05 ac f0 19 c0 00 	movl   $0x0,0xc019f0ac
c0108c8b:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108c8e:	e8 d5 c4 ff ff       	call   c0105168 <nr_free_pages>
c0108c93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108c96:	74 24                	je     c0108cbc <check_pgfault+0x237>
c0108c98:	c7 44 24 0c 60 da 10 	movl   $0xc010da60,0xc(%esp)
c0108c9f:	c0 
c0108ca0:	c7 44 24 08 cf d7 10 	movl   $0xc010d7cf,0x8(%esp)
c0108ca7:	c0 
c0108ca8:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108caf:	00 
c0108cb0:	c7 04 24 e4 d7 10 c0 	movl   $0xc010d7e4,(%esp)
c0108cb7:	e8 19 81 ff ff       	call   c0100dd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108cbc:	c7 04 24 87 da 10 c0 	movl   $0xc010da87,(%esp)
c0108cc3:	e8 8b 76 ff ff       	call   c0100353 <cprintf>
}
c0108cc8:	c9                   	leave  
c0108cc9:	c3                   	ret    

c0108cca <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108cca:	55                   	push   %ebp
c0108ccb:	89 e5                	mov    %esp,%ebp
c0108ccd:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108cd0:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108cd7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ce1:	89 04 24             	mov    %eax,(%esp)
c0108ce4:	e8 11 f2 ff ff       	call   c0107efa <find_vma>
c0108ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108cec:	a1 78 cf 19 c0       	mov    0xc019cf78,%eax
c0108cf1:	83 c0 01             	add    $0x1,%eax
c0108cf4:	a3 78 cf 19 c0       	mov    %eax,0xc019cf78
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108cfd:	74 0b                	je     c0108d0a <do_pgfault+0x40>
c0108cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d02:	8b 40 04             	mov    0x4(%eax),%eax
c0108d05:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108d08:	76 18                	jbe    c0108d22 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108d0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d11:	c7 04 24 a4 da 10 c0 	movl   $0xc010daa4,(%esp)
c0108d18:	e8 36 76 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108d1d:	e9 7f 01 00 00       	jmp    c0108ea1 <do_pgfault+0x1d7>
    }
    //check the error_code
    switch (error_code & 3) {
c0108d22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d25:	83 e0 03             	and    $0x3,%eax
c0108d28:	85 c0                	test   %eax,%eax
c0108d2a:	74 36                	je     c0108d62 <do_pgfault+0x98>
c0108d2c:	83 f8 01             	cmp    $0x1,%eax
c0108d2f:	74 20                	je     c0108d51 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d34:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d37:	83 e0 02             	and    $0x2,%eax
c0108d3a:	85 c0                	test   %eax,%eax
c0108d3c:	75 11                	jne    c0108d4f <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108d3e:	c7 04 24 d4 da 10 c0 	movl   $0xc010dad4,(%esp)
c0108d45:	e8 09 76 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108d4a:	e9 52 01 00 00       	jmp    c0108ea1 <do_pgfault+0x1d7>
        }
        break;
c0108d4f:	eb 2f                	jmp    c0108d80 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108d51:	c7 04 24 34 db 10 c0 	movl   $0xc010db34,(%esp)
c0108d58:	e8 f6 75 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108d5d:	e9 3f 01 00 00       	jmp    c0108ea1 <do_pgfault+0x1d7>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d65:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d68:	83 e0 05             	and    $0x5,%eax
c0108d6b:	85 c0                	test   %eax,%eax
c0108d6d:	75 11                	jne    c0108d80 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108d6f:	c7 04 24 6c db 10 c0 	movl   $0xc010db6c,(%esp)
c0108d76:	e8 d8 75 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108d7b:	e9 21 01 00 00       	jmp    c0108ea1 <do_pgfault+0x1d7>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108d80:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d8a:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d8d:	83 e0 02             	and    $0x2,%eax
c0108d90:	85 c0                	test   %eax,%eax
c0108d92:	74 04                	je     c0108d98 <do_pgfault+0xce>
        perm |= PTE_W;
c0108d94:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108d98:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108da1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108da6:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108da9:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108db0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            goto failed;
        }
   }
#endif

ptep = get_pte(mm->pgdir, addr, 1); // 根据引发缺页异常的地址 去找到 地址所对应的 PTE 如果找不到 则创建一页表
c0108db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dba:	8b 40 0c             	mov    0xc(%eax),%eax
c0108dbd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108dc4:	00 
c0108dc5:	8b 55 10             	mov    0x10(%ebp),%edx
c0108dc8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108dcc:	89 04 24             	mov    %eax,(%esp)
c0108dcf:	e8 5e ca ff ff       	call   c0105832 <get_pte>
c0108dd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) { // PTE 所指向的 物理页表地址 若不存在 则分配一物理页并将逻辑地址和物理地址作映射 (就是让 PTE 指向 物理页帧)
c0108dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108dda:	8b 00                	mov    (%eax),%eax
c0108ddc:	85 c0                	test   %eax,%eax
c0108dde:	75 29                	jne    c0108e09 <do_pgfault+0x13f>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0108de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108de3:	8b 40 0c             	mov    0xc(%eax),%eax
c0108de6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108de9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108ded:	8b 55 10             	mov    0x10(%ebp),%edx
c0108df0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108df4:	89 04 24             	mov    %eax,(%esp)
c0108df7:	e8 a5 d1 ff ff       	call   c0105fa1 <pgdir_alloc_page>
c0108dfc:	85 c0                	test   %eax,%eax
c0108dfe:	0f 85 96 00 00 00    	jne    c0108e9a <do_pgfault+0x1d0>
            goto failed;
c0108e04:	e9 98 00 00 00       	jmp    c0108ea1 <do_pgfault+0x1d7>
        }
    } 
    else { // 如果 PTE 存在 说明此时 P 位为 0 该页被换出到外存中 需要将其换入内存
        if(swap_init_ok) { // 是否可以换入页面
c0108e09:	a1 6c cf 19 c0       	mov    0xc019cf6c,%eax
c0108e0e:	85 c0                	test   %eax,%eax
c0108e10:	0f 84 84 00 00 00    	je     c0108e9a <do_pgfault+0x1d0>
            struct Page *page = NULL;
c0108e16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page); // 根据 PTE 找到 换出那页所在的硬盘地址 并将其从外存中换入
c0108e1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108e20:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e24:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e2e:	89 04 24             	mov    %eax,(%esp)
c0108e31:	e8 04 e2 ff ff       	call   c010703a <swap_in>
c0108e36:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0108e39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108e3d:	74 0e                	je     c0108e4d <do_pgfault+0x183>
                cprintf("swap_in in do_pgfault failed\n");
c0108e3f:	c7 04 24 cf db 10 c0 	movl   $0xc010dbcf,(%esp)
c0108e46:	e8 08 75 ff ff       	call   c0100353 <cprintf>
c0108e4b:	eb 54                	jmp    c0108ea1 <do_pgfault+0x1d7>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm); // 建立虚拟地址和物理地址之间的对应关系(更新 PTE 因为 已经被换入到内存中了)
c0108e4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108e50:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e53:	8b 40 0c             	mov    0xc(%eax),%eax
c0108e56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108e59:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108e5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108e60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108e64:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108e68:	89 04 24             	mov    %eax,(%esp)
c0108e6b:	e8 1b d0 ff ff       	call   c0105e8b <page_insert>
            swap_map_swappable(mm, addr, page, 0); // 使这一页可以置换
c0108e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108e73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0108e7a:	00 
c0108e7b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e7f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e86:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e89:	89 04 24             	mov    %eax,(%esp)
c0108e8c:	e8 e0 df ff ff       	call   c0106e71 <swap_map_swappable>
            page->pra_vaddr = addr; // 设置 这一页的虚拟地址
c0108e91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108e94:	8b 55 10             	mov    0x10(%ebp),%edx
c0108e97:	89 50 1c             	mov    %edx,0x1c(%eax)
        }
    }

   ret = 0;
c0108e9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108ea4:	c9                   	leave  
c0108ea5:	c3                   	ret    

c0108ea6 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c0108ea6:	55                   	push   %ebp
c0108ea7:	89 e5                	mov    %esp,%ebp
c0108ea9:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0108eac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108eb0:	0f 84 e0 00 00 00    	je     c0108f96 <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c0108eb6:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0108ebd:	76 1c                	jbe    c0108edb <user_mem_check+0x35>
c0108ebf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ec5:	01 d0                	add    %edx,%eax
c0108ec7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108eca:	76 0f                	jbe    c0108edb <user_mem_check+0x35>
c0108ecc:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ed2:	01 d0                	add    %edx,%eax
c0108ed4:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c0108ed9:	76 0a                	jbe    c0108ee5 <user_mem_check+0x3f>
            return 0;
c0108edb:	b8 00 00 00 00       	mov    $0x0,%eax
c0108ee0:	e9 e2 00 00 00       	jmp    c0108fc7 <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c0108ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108eeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0108eee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ef1:	01 d0                	add    %edx,%eax
c0108ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c0108ef6:	e9 88 00 00 00       	jmp    c0108f83 <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c0108efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108efe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f02:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f05:	89 04 24             	mov    %eax,(%esp)
c0108f08:	e8 ed ef ff ff       	call   c0107efa <find_vma>
c0108f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108f14:	74 0b                	je     c0108f21 <user_mem_check+0x7b>
c0108f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f19:	8b 40 04             	mov    0x4(%eax),%eax
c0108f1c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108f1f:	76 0a                	jbe    c0108f2b <user_mem_check+0x85>
                return 0;
c0108f21:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f26:	e9 9c 00 00 00       	jmp    c0108fc7 <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c0108f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f2e:	8b 50 0c             	mov    0xc(%eax),%edx
c0108f31:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108f35:	74 07                	je     c0108f3e <user_mem_check+0x98>
c0108f37:	b8 02 00 00 00       	mov    $0x2,%eax
c0108f3c:	eb 05                	jmp    c0108f43 <user_mem_check+0x9d>
c0108f3e:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f43:	21 d0                	and    %edx,%eax
c0108f45:	85 c0                	test   %eax,%eax
c0108f47:	75 07                	jne    c0108f50 <user_mem_check+0xaa>
                return 0;
c0108f49:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f4e:	eb 77                	jmp    c0108fc7 <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c0108f50:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108f54:	74 24                	je     c0108f7a <user_mem_check+0xd4>
c0108f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f59:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f5c:	83 e0 08             	and    $0x8,%eax
c0108f5f:	85 c0                	test   %eax,%eax
c0108f61:	74 17                	je     c0108f7a <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c0108f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f66:	8b 40 04             	mov    0x4(%eax),%eax
c0108f69:	05 00 10 00 00       	add    $0x1000,%eax
c0108f6e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108f71:	76 07                	jbe    c0108f7a <user_mem_check+0xd4>
                    return 0;
c0108f73:	b8 00 00 00 00       	mov    $0x0,%eax
c0108f78:	eb 4d                	jmp    c0108fc7 <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c0108f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108f7d:	8b 40 08             	mov    0x8(%eax),%eax
c0108f80:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c0108f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108f86:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108f89:	0f 82 6c ff ff ff    	jb     c0108efb <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c0108f8f:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f94:	eb 31                	jmp    c0108fc7 <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c0108f96:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c0108f9d:	76 23                	jbe    c0108fc2 <user_mem_check+0x11c>
c0108f9f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108fa5:	01 d0                	add    %edx,%eax
c0108fa7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108faa:	76 16                	jbe    c0108fc2 <user_mem_check+0x11c>
c0108fac:	8b 45 10             	mov    0x10(%ebp),%eax
c0108faf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108fb2:	01 d0                	add    %edx,%eax
c0108fb4:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c0108fb9:	77 07                	ja     c0108fc2 <user_mem_check+0x11c>
c0108fbb:	b8 01 00 00 00       	mov    $0x1,%eax
c0108fc0:	eb 05                	jmp    c0108fc7 <user_mem_check+0x121>
c0108fc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108fc7:	c9                   	leave  
c0108fc8:	c3                   	ret    

c0108fc9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108fc9:	55                   	push   %ebp
c0108fca:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108fcc:	8b 55 08             	mov    0x8(%ebp),%edx
c0108fcf:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0108fd4:	29 c2                	sub    %eax,%edx
c0108fd6:	89 d0                	mov    %edx,%eax
c0108fd8:	c1 f8 05             	sar    $0x5,%eax
}
c0108fdb:	5d                   	pop    %ebp
c0108fdc:	c3                   	ret    

c0108fdd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108fdd:	55                   	push   %ebp
c0108fde:	89 e5                	mov    %esp,%ebp
c0108fe0:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108fe3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fe6:	89 04 24             	mov    %eax,(%esp)
c0108fe9:	e8 db ff ff ff       	call   c0108fc9 <page2ppn>
c0108fee:	c1 e0 0c             	shl    $0xc,%eax
}
c0108ff1:	c9                   	leave  
c0108ff2:	c3                   	ret    

c0108ff3 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108ff3:	55                   	push   %ebp
c0108ff4:	89 e5                	mov    %esp,%ebp
c0108ff6:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108ff9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ffc:	89 04 24             	mov    %eax,(%esp)
c0108fff:	e8 d9 ff ff ff       	call   c0108fdd <page2pa>
c0109004:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109007:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010900a:	c1 e8 0c             	shr    $0xc,%eax
c010900d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109010:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0109015:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109018:	72 23                	jb     c010903d <page2kva+0x4a>
c010901a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010901d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109021:	c7 44 24 08 f0 db 10 	movl   $0xc010dbf0,0x8(%esp)
c0109028:	c0 
c0109029:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0109030:	00 
c0109031:	c7 04 24 13 dc 10 c0 	movl   $0xc010dc13,(%esp)
c0109038:	e8 98 7d ff ff       	call   c0100dd5 <__panic>
c010903d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109040:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0109045:	c9                   	leave  
c0109046:	c3                   	ret    

c0109047 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0109047:	55                   	push   %ebp
c0109048:	89 e5                	mov    %esp,%ebp
c010904a:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010904d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109054:	e8 cc 8a ff ff       	call   c0101b25 <ide_device_valid>
c0109059:	85 c0                	test   %eax,%eax
c010905b:	75 1c                	jne    c0109079 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c010905d:	c7 44 24 08 21 dc 10 	movl   $0xc010dc21,0x8(%esp)
c0109064:	c0 
c0109065:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c010906c:	00 
c010906d:	c7 04 24 3b dc 10 c0 	movl   $0xc010dc3b,(%esp)
c0109074:	e8 5c 7d ff ff       	call   c0100dd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0109079:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109080:	e8 df 8a ff ff       	call   c0101b64 <ide_device_size>
c0109085:	c1 e8 03             	shr    $0x3,%eax
c0109088:	a3 7c f0 19 c0       	mov    %eax,0xc019f07c
}
c010908d:	c9                   	leave  
c010908e:	c3                   	ret    

c010908f <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c010908f:	55                   	push   %ebp
c0109090:	89 e5                	mov    %esp,%ebp
c0109092:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0109095:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109098:	89 04 24             	mov    %eax,(%esp)
c010909b:	e8 53 ff ff ff       	call   c0108ff3 <page2kva>
c01090a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01090a3:	c1 ea 08             	shr    $0x8,%edx
c01090a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01090a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01090ad:	74 0b                	je     c01090ba <swapfs_read+0x2b>
c01090af:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c01090b5:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01090b8:	72 23                	jb     c01090dd <swapfs_read+0x4e>
c01090ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01090bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01090c1:	c7 44 24 08 4c dc 10 	movl   $0xc010dc4c,0x8(%esp)
c01090c8:	c0 
c01090c9:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01090d0:	00 
c01090d1:	c7 04 24 3b dc 10 c0 	movl   $0xc010dc3b,(%esp)
c01090d8:	e8 f8 7c ff ff       	call   c0100dd5 <__panic>
c01090dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090e0:	c1 e2 03             	shl    $0x3,%edx
c01090e3:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01090ea:	00 
c01090eb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01090ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01090f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01090fa:	e8 a4 8a ff ff       	call   c0101ba3 <ide_read_secs>
}
c01090ff:	c9                   	leave  
c0109100:	c3                   	ret    

c0109101 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0109101:	55                   	push   %ebp
c0109102:	89 e5                	mov    %esp,%ebp
c0109104:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0109107:	8b 45 0c             	mov    0xc(%ebp),%eax
c010910a:	89 04 24             	mov    %eax,(%esp)
c010910d:	e8 e1 fe ff ff       	call   c0108ff3 <page2kva>
c0109112:	8b 55 08             	mov    0x8(%ebp),%edx
c0109115:	c1 ea 08             	shr    $0x8,%edx
c0109118:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010911b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010911f:	74 0b                	je     c010912c <swapfs_write+0x2b>
c0109121:	8b 15 7c f0 19 c0    	mov    0xc019f07c,%edx
c0109127:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010912a:	72 23                	jb     c010914f <swapfs_write+0x4e>
c010912c:	8b 45 08             	mov    0x8(%ebp),%eax
c010912f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109133:	c7 44 24 08 4c dc 10 	movl   $0xc010dc4c,0x8(%esp)
c010913a:	c0 
c010913b:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0109142:	00 
c0109143:	c7 04 24 3b dc 10 c0 	movl   $0xc010dc3b,(%esp)
c010914a:	e8 86 7c ff ff       	call   c0100dd5 <__panic>
c010914f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109152:	c1 e2 03             	shl    $0x3,%edx
c0109155:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010915c:	00 
c010915d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109161:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010916c:	e8 74 8c ff ff       	call   c0101de5 <ide_write_secs>
}
c0109171:	c9                   	leave  
c0109172:	c3                   	ret    

c0109173 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0109173:	52                   	push   %edx
    call *%ebx              # call fn
c0109174:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0109176:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0109177:	e8 62 0c 00 00       	call   c0109dde <do_exit>

c010917c <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c010917c:	55                   	push   %ebp
c010917d:	89 e5                	mov    %esp,%ebp
c010917f:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0109182:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109185:	8b 45 08             	mov    0x8(%ebp),%eax
c0109188:	0f ab 02             	bts    %eax,(%edx)
c010918b:	19 c0                	sbb    %eax,%eax
c010918d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0109190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109194:	0f 95 c0             	setne  %al
c0109197:	0f b6 c0             	movzbl %al,%eax
}
c010919a:	c9                   	leave  
c010919b:	c3                   	ret    

c010919c <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c010919c:	55                   	push   %ebp
c010919d:	89 e5                	mov    %esp,%ebp
c010919f:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c01091a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01091a8:	0f b3 02             	btr    %eax,(%edx)
c01091ab:	19 c0                	sbb    %eax,%eax
c01091ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c01091b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01091b4:	0f 95 c0             	setne  %al
c01091b7:	0f b6 c0             	movzbl %al,%eax
}
c01091ba:	c9                   	leave  
c01091bb:	c3                   	ret    

c01091bc <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01091bc:	55                   	push   %ebp
c01091bd:	89 e5                	mov    %esp,%ebp
c01091bf:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01091c2:	9c                   	pushf  
c01091c3:	58                   	pop    %eax
c01091c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01091c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01091ca:	25 00 02 00 00       	and    $0x200,%eax
c01091cf:	85 c0                	test   %eax,%eax
c01091d1:	74 0c                	je     c01091df <__intr_save+0x23>
        intr_disable();
c01091d3:	e8 55 8e ff ff       	call   c010202d <intr_disable>
        return 1;
c01091d8:	b8 01 00 00 00       	mov    $0x1,%eax
c01091dd:	eb 05                	jmp    c01091e4 <__intr_save+0x28>
    }
    return 0;
c01091df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01091e4:	c9                   	leave  
c01091e5:	c3                   	ret    

c01091e6 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01091e6:	55                   	push   %ebp
c01091e7:	89 e5                	mov    %esp,%ebp
c01091e9:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01091ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01091f0:	74 05                	je     c01091f7 <__intr_restore+0x11>
        intr_enable();
c01091f2:	e8 30 8e ff ff       	call   c0102027 <intr_enable>
    }
}
c01091f7:	c9                   	leave  
c01091f8:	c3                   	ret    

c01091f9 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c01091f9:	55                   	push   %ebp
c01091fa:	89 e5                	mov    %esp,%ebp
c01091fc:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c01091ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0109202:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109206:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010920d:	e8 6a ff ff ff       	call   c010917c <test_and_set_bit>
c0109212:	85 c0                	test   %eax,%eax
c0109214:	0f 94 c0             	sete   %al
c0109217:	0f b6 c0             	movzbl %al,%eax
}
c010921a:	c9                   	leave  
c010921b:	c3                   	ret    

c010921c <lock>:

static inline void
lock(lock_t *lock) {
c010921c:	55                   	push   %ebp
c010921d:	89 e5                	mov    %esp,%ebp
c010921f:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c0109222:	eb 05                	jmp    c0109229 <lock+0xd>
        schedule();
c0109224:	e8 1a 1c 00 00       	call   c010ae43 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c0109229:	8b 45 08             	mov    0x8(%ebp),%eax
c010922c:	89 04 24             	mov    %eax,(%esp)
c010922f:	e8 c5 ff ff ff       	call   c01091f9 <try_lock>
c0109234:	85 c0                	test   %eax,%eax
c0109236:	74 ec                	je     c0109224 <lock+0x8>
        schedule();
    }
}
c0109238:	c9                   	leave  
c0109239:	c3                   	ret    

c010923a <unlock>:

static inline void
unlock(lock_t *lock) {
c010923a:	55                   	push   %ebp
c010923b:	89 e5                	mov    %esp,%ebp
c010923d:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c0109240:	8b 45 08             	mov    0x8(%ebp),%eax
c0109243:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010924e:	e8 49 ff ff ff       	call   c010919c <test_and_clear_bit>
c0109253:	85 c0                	test   %eax,%eax
c0109255:	75 1c                	jne    c0109273 <unlock+0x39>
        panic("Unlock failed.\n");
c0109257:	c7 44 24 08 6c dc 10 	movl   $0xc010dc6c,0x8(%esp)
c010925e:	c0 
c010925f:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c0109266:	00 
c0109267:	c7 04 24 7c dc 10 c0 	movl   $0xc010dc7c,(%esp)
c010926e:	e8 62 7b ff ff       	call   c0100dd5 <__panic>
    }
}
c0109273:	c9                   	leave  
c0109274:	c3                   	ret    

c0109275 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0109275:	55                   	push   %ebp
c0109276:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0109278:	8b 55 08             	mov    0x8(%ebp),%edx
c010927b:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c0109280:	29 c2                	sub    %eax,%edx
c0109282:	89 d0                	mov    %edx,%eax
c0109284:	c1 f8 05             	sar    $0x5,%eax
}
c0109287:	5d                   	pop    %ebp
c0109288:	c3                   	ret    

c0109289 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0109289:	55                   	push   %ebp
c010928a:	89 e5                	mov    %esp,%ebp
c010928c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010928f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109292:	89 04 24             	mov    %eax,(%esp)
c0109295:	e8 db ff ff ff       	call   c0109275 <page2ppn>
c010929a:	c1 e0 0c             	shl    $0xc,%eax
}
c010929d:	c9                   	leave  
c010929e:	c3                   	ret    

c010929f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010929f:	55                   	push   %ebp
c01092a0:	89 e5                	mov    %esp,%ebp
c01092a2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01092a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01092a8:	c1 e8 0c             	shr    $0xc,%eax
c01092ab:	89 c2                	mov    %eax,%edx
c01092ad:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c01092b2:	39 c2                	cmp    %eax,%edx
c01092b4:	72 1c                	jb     c01092d2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01092b6:	c7 44 24 08 90 dc 10 	movl   $0xc010dc90,0x8(%esp)
c01092bd:	c0 
c01092be:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01092c5:	00 
c01092c6:	c7 04 24 af dc 10 c0 	movl   $0xc010dcaf,(%esp)
c01092cd:	e8 03 7b ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c01092d2:	a1 cc ef 19 c0       	mov    0xc019efcc,%eax
c01092d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01092da:	c1 ea 0c             	shr    $0xc,%edx
c01092dd:	c1 e2 05             	shl    $0x5,%edx
c01092e0:	01 d0                	add    %edx,%eax
}
c01092e2:	c9                   	leave  
c01092e3:	c3                   	ret    

c01092e4 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01092e4:	55                   	push   %ebp
c01092e5:	89 e5                	mov    %esp,%ebp
c01092e7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01092ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01092ed:	89 04 24             	mov    %eax,(%esp)
c01092f0:	e8 94 ff ff ff       	call   c0109289 <page2pa>
c01092f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092fb:	c1 e8 0c             	shr    $0xc,%eax
c01092fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109301:	a1 e0 ce 19 c0       	mov    0xc019cee0,%eax
c0109306:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109309:	72 23                	jb     c010932e <page2kva+0x4a>
c010930b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010930e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109312:	c7 44 24 08 c0 dc 10 	movl   $0xc010dcc0,0x8(%esp)
c0109319:	c0 
c010931a:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0109321:	00 
c0109322:	c7 04 24 af dc 10 c0 	movl   $0xc010dcaf,(%esp)
c0109329:	e8 a7 7a ff ff       	call   c0100dd5 <__panic>
c010932e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109331:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0109336:	c9                   	leave  
c0109337:	c3                   	ret    

c0109338 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0109338:	55                   	push   %ebp
c0109339:	89 e5                	mov    %esp,%ebp
c010933b:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010933e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109341:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109344:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010934b:	77 23                	ja     c0109370 <kva2page+0x38>
c010934d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109350:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109354:	c7 44 24 08 e4 dc 10 	movl   $0xc010dce4,0x8(%esp)
c010935b:	c0 
c010935c:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0109363:	00 
c0109364:	c7 04 24 af dc 10 c0 	movl   $0xc010dcaf,(%esp)
c010936b:	e8 65 7a ff ff       	call   c0100dd5 <__panic>
c0109370:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109373:	05 00 00 00 40       	add    $0x40000000,%eax
c0109378:	89 04 24             	mov    %eax,(%esp)
c010937b:	e8 1f ff ff ff       	call   c010929f <pa2page>
}
c0109380:	c9                   	leave  
c0109381:	c3                   	ret    

c0109382 <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c0109382:	55                   	push   %ebp
c0109383:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c0109385:	8b 45 08             	mov    0x8(%ebp),%eax
c0109388:	8b 40 18             	mov    0x18(%eax),%eax
c010938b:	8d 50 01             	lea    0x1(%eax),%edx
c010938e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109391:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c0109394:	8b 45 08             	mov    0x8(%ebp),%eax
c0109397:	8b 40 18             	mov    0x18(%eax),%eax
}
c010939a:	5d                   	pop    %ebp
c010939b:	c3                   	ret    

c010939c <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c010939c:	55                   	push   %ebp
c010939d:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c010939f:	8b 45 08             	mov    0x8(%ebp),%eax
c01093a2:	8b 40 18             	mov    0x18(%eax),%eax
c01093a5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01093a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01093ab:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01093ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b1:	8b 40 18             	mov    0x18(%eax),%eax
}
c01093b4:	5d                   	pop    %ebp
c01093b5:	c3                   	ret    

c01093b6 <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c01093b6:	55                   	push   %ebp
c01093b7:	89 e5                	mov    %esp,%ebp
c01093b9:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01093bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01093c0:	74 0e                	je     c01093d0 <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c01093c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01093c5:	83 c0 1c             	add    $0x1c,%eax
c01093c8:	89 04 24             	mov    %eax,(%esp)
c01093cb:	e8 4c fe ff ff       	call   c010921c <lock>
    }
}
c01093d0:	c9                   	leave  
c01093d1:	c3                   	ret    

c01093d2 <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c01093d2:	55                   	push   %ebp
c01093d3:	89 e5                	mov    %esp,%ebp
c01093d5:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01093d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01093dc:	74 0e                	je     c01093ec <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c01093de:	8b 45 08             	mov    0x8(%ebp),%eax
c01093e1:	83 c0 1c             	add    $0x1c,%eax
c01093e4:	89 04 24             	mov    %eax,(%esp)
c01093e7:	e8 4e fe ff ff       	call   c010923a <unlock>
    }
}
c01093ec:	c9                   	leave  
c01093ed:	c3                   	ret    

c01093ee <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01093ee:	55                   	push   %ebp
c01093ef:	89 e5                	mov    %esp,%ebp
c01093f1:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01093f4:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
c01093fb:	e8 56 b8 ff ff       	call   c0104c56 <kmalloc>
c0109400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0109403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109407:	0f 84 c3 00 00 00    	je     c01094d0 <alloc_proc+0xe2>
     * below fields(add in LAB5) in proc_struct need to be initialized	
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
	 */
  
    	proc->state = PROC_UNINIT;  // 正在创建和初始化状态中
c010940d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	proc->pid = -1;  //未初始化的进程id为-1
c0109416:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109419:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    	proc->runs = 0;  // 还没有运行过
c0109420:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109423:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    	proc->kstack = 0;  // 初始化内核堆栈似乎是在do_fork()中进行的？
c010942a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010942d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    	proc->need_resched = 0;  // 初始化为不需要调度
c0109434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109437:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    	proc->parent = NULL;
c010943e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109441:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    	proc->mm = NULL;  // 之后也不会分配，因为都是内核态线程，所以直接使用内核的mm
c0109448:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010944b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    	memset(&(proc->context), 0, sizeof(struct context));  
c0109452:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109455:	83 c0 1c             	add    $0x1c,%eax
c0109458:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c010945f:	00 
c0109460:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109467:	00 
c0109468:	89 04 24             	mov    %eax,(%esp)
c010946b:	e8 3e 27 00 00       	call   c010bbae <memset>
    	// proc->tf = kmalloc(sizeof(struct trapframe));  // tf似乎不需要在此处设置
    	proc->cr3 = boot_cr3;  // 内核态线程不需要分配新的页表地址；这对于正确执行是必需的
c0109470:	8b 15 c8 ef 19 c0    	mov    0xc019efc8,%edx
c0109476:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109479:	89 50 40             	mov    %edx,0x40(%eax)
    	proc->flags = 0;  //标志位置为0
c010947c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010947f:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    	memset(proc->name, 0, PROC_NAME_LEN);  //将进程名清零，不过不是必需的
c0109486:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109489:	83 c0 48             	add    $0x48,%eax
c010948c:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109493:	00 
c0109494:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010949b:	00 
c010949c:	89 04 24             	mov    %eax,(%esp)
c010949f:	e8 0a 27 00 00       	call   c010bbae <memset>
    	proc -> wait_state = 0;
c01094a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094a7:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
        proc -> cptr = proc -> yptr = proc -> optr = NULL;
c01094ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094b1:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
c01094b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094bb:	8b 50 78             	mov    0x78(%eax),%edx
c01094be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094c1:	89 50 74             	mov    %edx,0x74(%eax)
c01094c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094c7:	8b 50 74             	mov    0x74(%eax),%edx
c01094ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094cd:	89 50 70             	mov    %edx,0x70(%eax)
    }
    return proc;
c01094d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01094d3:	c9                   	leave  
c01094d4:	c3                   	ret    

c01094d5 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01094d5:	55                   	push   %ebp
c01094d6:	89 e5                	mov    %esp,%ebp
c01094d8:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01094db:	8b 45 08             	mov    0x8(%ebp),%eax
c01094de:	83 c0 48             	add    $0x48,%eax
c01094e1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01094e8:	00 
c01094e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01094f0:	00 
c01094f1:	89 04 24             	mov    %eax,(%esp)
c01094f4:	e8 b5 26 00 00       	call   c010bbae <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01094f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01094fc:	8d 50 48             	lea    0x48(%eax),%edx
c01094ff:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109506:	00 
c0109507:	8b 45 0c             	mov    0xc(%ebp),%eax
c010950a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010950e:	89 14 24             	mov    %edx,(%esp)
c0109511:	e8 7a 27 00 00       	call   c010bc90 <memcpy>
}
c0109516:	c9                   	leave  
c0109517:	c3                   	ret    

c0109518 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0109518:	55                   	push   %ebp
c0109519:	89 e5                	mov    %esp,%ebp
c010951b:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c010951e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109525:	00 
c0109526:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010952d:	00 
c010952e:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c0109535:	e8 74 26 00 00       	call   c010bbae <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010953a:	8b 45 08             	mov    0x8(%ebp),%eax
c010953d:	83 c0 48             	add    $0x48,%eax
c0109540:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109547:	00 
c0109548:	89 44 24 04          	mov    %eax,0x4(%esp)
c010954c:	c7 04 24 a4 ef 19 c0 	movl   $0xc019efa4,(%esp)
c0109553:	e8 38 27 00 00       	call   c010bc90 <memcpy>
}
c0109558:	c9                   	leave  
c0109559:	c3                   	ret    

c010955a <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c010955a:	55                   	push   %ebp
c010955b:	89 e5                	mov    %esp,%ebp
c010955d:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c0109560:	8b 45 08             	mov    0x8(%ebp),%eax
c0109563:	83 c0 58             	add    $0x58,%eax
c0109566:	c7 45 fc b0 f0 19 c0 	movl   $0xc019f0b0,-0x4(%ebp)
c010956d:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0109570:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109573:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109576:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109579:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010957c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010957f:	8b 40 04             	mov    0x4(%eax),%eax
c0109582:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109585:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109588:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010958b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010958e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109594:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109597:	89 10                	mov    %edx,(%eax)
c0109599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010959c:	8b 10                	mov    (%eax),%edx
c010959e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01095a1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01095a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01095aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01095ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01095b3:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c01095b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b8:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c01095bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c2:	8b 40 14             	mov    0x14(%eax),%eax
c01095c5:	8b 50 70             	mov    0x70(%eax),%edx
c01095c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01095cb:	89 50 78             	mov    %edx,0x78(%eax)
c01095ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01095d1:	8b 40 78             	mov    0x78(%eax),%eax
c01095d4:	85 c0                	test   %eax,%eax
c01095d6:	74 0c                	je     c01095e4 <set_links+0x8a>
        proc->optr->yptr = proc;
c01095d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01095db:	8b 40 78             	mov    0x78(%eax),%eax
c01095de:	8b 55 08             	mov    0x8(%ebp),%edx
c01095e1:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c01095e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e7:	8b 40 14             	mov    0x14(%eax),%eax
c01095ea:	8b 55 08             	mov    0x8(%ebp),%edx
c01095ed:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c01095f0:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c01095f5:	83 c0 01             	add    $0x1,%eax
c01095f8:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c01095fd:	c9                   	leave  
c01095fe:	c3                   	ret    

c01095ff <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c01095ff:	55                   	push   %ebp
c0109600:	89 e5                	mov    %esp,%ebp
c0109602:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c0109605:	8b 45 08             	mov    0x8(%ebp),%eax
c0109608:	83 c0 58             	add    $0x58,%eax
c010960b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010960e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109611:	8b 40 04             	mov    0x4(%eax),%eax
c0109614:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109617:	8b 12                	mov    (%edx),%edx
c0109619:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010961c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010961f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109622:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109625:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109628:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010962b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010962e:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c0109630:	8b 45 08             	mov    0x8(%ebp),%eax
c0109633:	8b 40 78             	mov    0x78(%eax),%eax
c0109636:	85 c0                	test   %eax,%eax
c0109638:	74 0f                	je     c0109649 <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c010963a:	8b 45 08             	mov    0x8(%ebp),%eax
c010963d:	8b 40 78             	mov    0x78(%eax),%eax
c0109640:	8b 55 08             	mov    0x8(%ebp),%edx
c0109643:	8b 52 74             	mov    0x74(%edx),%edx
c0109646:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c0109649:	8b 45 08             	mov    0x8(%ebp),%eax
c010964c:	8b 40 74             	mov    0x74(%eax),%eax
c010964f:	85 c0                	test   %eax,%eax
c0109651:	74 11                	je     c0109664 <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c0109653:	8b 45 08             	mov    0x8(%ebp),%eax
c0109656:	8b 40 74             	mov    0x74(%eax),%eax
c0109659:	8b 55 08             	mov    0x8(%ebp),%edx
c010965c:	8b 52 78             	mov    0x78(%edx),%edx
c010965f:	89 50 78             	mov    %edx,0x78(%eax)
c0109662:	eb 0f                	jmp    c0109673 <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c0109664:	8b 45 08             	mov    0x8(%ebp),%eax
c0109667:	8b 40 14             	mov    0x14(%eax),%eax
c010966a:	8b 55 08             	mov    0x8(%ebp),%edx
c010966d:	8b 52 78             	mov    0x78(%edx),%edx
c0109670:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c0109673:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109678:	83 e8 01             	sub    $0x1,%eax
c010967b:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0
}
c0109680:	c9                   	leave  
c0109681:	c3                   	ret    

c0109682 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0109682:	55                   	push   %ebp
c0109683:	89 e5                	mov    %esp,%ebp
c0109685:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0109688:	c7 45 f8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c010968f:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109694:	83 c0 01             	add    $0x1,%eax
c0109697:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c010969c:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096a1:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01096a6:	7e 0c                	jle    c01096b4 <get_pid+0x32>
        last_pid = 1;
c01096a8:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c01096af:	00 00 00 
        goto inside;
c01096b2:	eb 13                	jmp    c01096c7 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01096b4:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c01096ba:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c01096bf:	39 c2                	cmp    %eax,%edx
c01096c1:	0f 8c ac 00 00 00    	jl     c0109773 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01096c7:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c01096ce:	20 00 00 
    repeat:
        le = list;
c01096d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01096d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01096d7:	eb 7f                	jmp    c0109758 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01096d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01096dc:	83 e8 58             	sub    $0x58,%eax
c01096df:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01096e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096e5:	8b 50 04             	mov    0x4(%eax),%edx
c01096e8:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096ed:	39 c2                	cmp    %eax,%edx
c01096ef:	75 3e                	jne    c010972f <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c01096f1:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01096f6:	83 c0 01             	add    $0x1,%eax
c01096f9:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c01096fe:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c0109704:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c0109709:	39 c2                	cmp    %eax,%edx
c010970b:	7c 4b                	jl     c0109758 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c010970d:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109712:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109717:	7e 0a                	jle    c0109723 <get_pid+0xa1>
                        last_pid = 1;
c0109719:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c0109720:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0109723:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c010972a:	20 00 00 
                    goto repeat;
c010972d:	eb a2                	jmp    c01096d1 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c010972f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109732:	8b 50 04             	mov    0x4(%eax),%edx
c0109735:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010973a:	39 c2                	cmp    %eax,%edx
c010973c:	7e 1a                	jle    c0109758 <get_pid+0xd6>
c010973e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109741:	8b 50 04             	mov    0x4(%eax),%edx
c0109744:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c0109749:	39 c2                	cmp    %eax,%edx
c010974b:	7d 0b                	jge    c0109758 <get_pid+0xd6>
                next_safe = proc->pid;
c010974d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109750:	8b 40 04             	mov    0x4(%eax),%eax
c0109753:	a3 84 aa 12 c0       	mov    %eax,0xc012aa84
c0109758:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010975b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010975e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109761:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0109764:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0109767:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010976a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010976d:	0f 85 66 ff ff ff    	jne    c01096d9 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0109773:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
}
c0109778:	c9                   	leave  
c0109779:	c3                   	ret    

c010977a <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c010977a:	55                   	push   %ebp
c010977b:	89 e5                	mov    %esp,%ebp
c010977d:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0109780:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109785:	39 45 08             	cmp    %eax,0x8(%ebp)
c0109788:	74 63                	je     c01097ed <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c010978a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010978f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109792:	8b 45 08             	mov    0x8(%ebp),%eax
c0109795:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0109798:	e8 1f fa ff ff       	call   c01091bc <__intr_save>
c010979d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01097a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01097a3:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88
            load_esp0(next->kstack + KSTACKSIZE);
c01097a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097ab:	8b 40 0c             	mov    0xc(%eax),%eax
c01097ae:	05 00 20 00 00       	add    $0x2000,%eax
c01097b3:	89 04 24             	mov    %eax,(%esp)
c01097b6:	e8 c2 b7 ff ff       	call   c0104f7d <load_esp0>
            lcr3(next->cr3);
c01097bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097be:	8b 40 40             	mov    0x40(%eax),%eax
c01097c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01097c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097c7:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01097ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097cd:	8d 50 1c             	lea    0x1c(%eax),%edx
c01097d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01097d3:	83 c0 1c             	add    $0x1c,%eax
c01097d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01097da:	89 04 24             	mov    %eax,(%esp)
c01097dd:	e8 69 15 00 00       	call   c010ad4b <switch_to>
        }
        local_intr_restore(intr_flag);
c01097e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097e5:	89 04 24             	mov    %eax,(%esp)
c01097e8:	e8 f9 f9 ff ff       	call   c01091e6 <__intr_restore>
    }
}
c01097ed:	c9                   	leave  
c01097ee:	c3                   	ret    

c01097ef <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c01097ef:	55                   	push   %ebp
c01097f0:	89 e5                	mov    %esp,%ebp
c01097f2:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c01097f5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c01097fa:	8b 40 3c             	mov    0x3c(%eax),%eax
c01097fd:	89 04 24             	mov    %eax,(%esp)
c0109800:	e8 75 92 ff ff       	call   c0102a7a <forkrets>
}
c0109805:	c9                   	leave  
c0109806:	c3                   	ret    

c0109807 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0109807:	55                   	push   %ebp
c0109808:	89 e5                	mov    %esp,%ebp
c010980a:	53                   	push   %ebx
c010980b:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c010980e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109811:	8d 58 60             	lea    0x60(%eax),%ebx
c0109814:	8b 45 08             	mov    0x8(%ebp),%eax
c0109817:	8b 40 04             	mov    0x4(%eax),%eax
c010981a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109821:	00 
c0109822:	89 04 24             	mov    %eax,(%esp)
c0109825:	e8 d7 18 00 00       	call   c010b101 <hash32>
c010982a:	c1 e0 03             	shl    $0x3,%eax
c010982d:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c0109832:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109835:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0109838:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010983b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010983e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109841:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0109844:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109847:	8b 40 04             	mov    0x4(%eax),%eax
c010984a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010984d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109850:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109853:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0109856:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109859:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010985c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010985f:	89 10                	mov    %edx,(%eax)
c0109861:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109864:	8b 10                	mov    (%eax),%edx
c0109866:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109869:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010986c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010986f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0109872:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0109875:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109878:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010987b:	89 10                	mov    %edx,(%eax)
}
c010987d:	83 c4 34             	add    $0x34,%esp
c0109880:	5b                   	pop    %ebx
c0109881:	5d                   	pop    %ebp
c0109882:	c3                   	ret    

c0109883 <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c0109883:	55                   	push   %ebp
c0109884:	89 e5                	mov    %esp,%ebp
c0109886:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c0109889:	8b 45 08             	mov    0x8(%ebp),%eax
c010988c:	83 c0 60             	add    $0x60,%eax
c010988f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109892:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109895:	8b 40 04             	mov    0x4(%eax),%eax
c0109898:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010989b:	8b 12                	mov    (%edx),%edx
c010989d:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01098a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01098a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01098a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098a9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01098ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098af:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01098b2:	89 10                	mov    %edx,(%eax)
}
c01098b4:	c9                   	leave  
c01098b5:	c3                   	ret    

c01098b6 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c01098b6:	55                   	push   %ebp
c01098b7:	89 e5                	mov    %esp,%ebp
c01098b9:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c01098bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01098c0:	7e 5f                	jle    c0109921 <find_proc+0x6b>
c01098c2:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c01098c9:	7f 56                	jg     c0109921 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c01098cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01098ce:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01098d5:	00 
c01098d6:	89 04 24             	mov    %eax,(%esp)
c01098d9:	e8 23 18 00 00       	call   c010b101 <hash32>
c01098de:	c1 e0 03             	shl    $0x3,%eax
c01098e1:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c01098e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01098e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c01098ef:	eb 19                	jmp    c010990a <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c01098f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098f4:	83 e8 60             	sub    $0x60,%eax
c01098f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c01098fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01098fd:	8b 40 04             	mov    0x4(%eax),%eax
c0109900:	3b 45 08             	cmp    0x8(%ebp),%eax
c0109903:	75 05                	jne    c010990a <find_proc+0x54>
                return proc;
c0109905:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109908:	eb 1c                	jmp    c0109926 <find_proc+0x70>
c010990a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010990d:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109910:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109913:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0109916:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109919:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010991c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010991f:	75 d0                	jne    c01098f1 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0109921:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109926:	c9                   	leave  
c0109927:	c3                   	ret    

c0109928 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0109928:	55                   	push   %ebp
c0109929:	89 e5                	mov    %esp,%ebp
c010992b:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c010992e:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0109935:	00 
c0109936:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010993d:	00 
c010993e:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109941:	89 04 24             	mov    %eax,(%esp)
c0109944:	e8 65 22 00 00       	call   c010bbae <memset>
    tf.tf_cs = KERNEL_CS;
c0109949:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c010994f:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0109955:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0109959:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c010995d:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0109961:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0109965:	8b 45 08             	mov    0x8(%ebp),%eax
c0109968:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c010996b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010996e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0109971:	b8 73 91 10 c0       	mov    $0xc0109173,%eax
c0109976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0109979:	8b 45 10             	mov    0x10(%ebp),%eax
c010997c:	80 cc 01             	or     $0x1,%ah
c010997f:	89 c2                	mov    %eax,%edx
c0109981:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109984:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109988:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010998f:	00 
c0109990:	89 14 24             	mov    %edx,(%esp)
c0109993:	e8 25 03 00 00       	call   c0109cbd <do_fork>
}
c0109998:	c9                   	leave  
c0109999:	c3                   	ret    

c010999a <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c010999a:	55                   	push   %ebp
c010999b:	89 e5                	mov    %esp,%ebp
c010999d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c01099a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01099a7:	e8 1f b7 ff ff       	call   c01050cb <alloc_pages>
c01099ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01099af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01099b3:	74 1a                	je     c01099cf <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c01099b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01099b8:	89 04 24             	mov    %eax,(%esp)
c01099bb:	e8 24 f9 ff ff       	call   c01092e4 <page2kva>
c01099c0:	89 c2                	mov    %eax,%edx
c01099c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c5:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c01099c8:	b8 00 00 00 00       	mov    $0x0,%eax
c01099cd:	eb 05                	jmp    c01099d4 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c01099cf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c01099d4:	c9                   	leave  
c01099d5:	c3                   	ret    

c01099d6 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c01099d6:	55                   	push   %ebp
c01099d7:	89 e5                	mov    %esp,%ebp
c01099d9:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c01099dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01099df:	8b 40 0c             	mov    0xc(%eax),%eax
c01099e2:	89 04 24             	mov    %eax,(%esp)
c01099e5:	e8 4e f9 ff ff       	call   c0109338 <kva2page>
c01099ea:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01099f1:	00 
c01099f2:	89 04 24             	mov    %eax,(%esp)
c01099f5:	e8 3c b7 ff ff       	call   c0105136 <free_pages>
}
c01099fa:	c9                   	leave  
c01099fb:	c3                   	ret    

c01099fc <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c01099fc:	55                   	push   %ebp
c01099fd:	89 e5                	mov    %esp,%ebp
c01099ff:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c0109a02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109a09:	e8 bd b6 ff ff       	call   c01050cb <alloc_pages>
c0109a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109a15:	75 0a                	jne    c0109a21 <setup_pgdir+0x25>
        return -E_NO_MEM;
c0109a17:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0109a1c:	e9 80 00 00 00       	jmp    c0109aa1 <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c0109a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109a24:	89 04 24             	mov    %eax,(%esp)
c0109a27:	e8 b8 f8 ff ff       	call   c01092e4 <page2kva>
c0109a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c0109a2f:	a1 e4 ce 19 c0       	mov    0xc019cee4,%eax
c0109a34:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0109a3b:	00 
c0109a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a43:	89 04 24             	mov    %eax,(%esp)
c0109a46:	e8 45 22 00 00       	call   c010bc90 <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c0109a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a4e:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0109a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a5a:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c0109a61:	77 23                	ja     c0109a86 <setup_pgdir+0x8a>
c0109a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109a6a:	c7 44 24 08 e4 dc 10 	movl   $0xc010dce4,0x8(%esp)
c0109a71:	c0 
c0109a72:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0109a79:	00 
c0109a7a:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109a81:	e8 4f 73 ff ff       	call   c0100dd5 <__panic>
c0109a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a89:	05 00 00 00 40       	add    $0x40000000,%eax
c0109a8e:	83 c8 03             	or     $0x3,%eax
c0109a91:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c0109a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a96:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109a99:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c0109a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109aa1:	c9                   	leave  
c0109aa2:	c3                   	ret    

c0109aa3 <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c0109aa3:	55                   	push   %ebp
c0109aa4:	89 e5                	mov    %esp,%ebp
c0109aa6:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c0109aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aac:	8b 40 0c             	mov    0xc(%eax),%eax
c0109aaf:	89 04 24             	mov    %eax,(%esp)
c0109ab2:	e8 81 f8 ff ff       	call   c0109338 <kva2page>
c0109ab7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109abe:	00 
c0109abf:	89 04 24             	mov    %eax,(%esp)
c0109ac2:	e8 6f b6 ff ff       	call   c0105136 <free_pages>
}
c0109ac7:	c9                   	leave  
c0109ac8:	c3                   	ret    

c0109ac9 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0109ac9:	55                   	push   %ebp
c0109aca:	89 e5                	mov    %esp,%ebp
c0109acc:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c0109acf:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ad4:	8b 40 18             	mov    0x18(%eax),%eax
c0109ad7:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c0109ada:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109ade:	75 0a                	jne    c0109aea <copy_mm+0x21>
        return 0;
c0109ae0:	b8 00 00 00 00       	mov    $0x0,%eax
c0109ae5:	e9 f9 00 00 00       	jmp    c0109be3 <copy_mm+0x11a>
    }
    if (clone_flags & CLONE_VM) {
c0109aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aed:	25 00 01 00 00       	and    $0x100,%eax
c0109af2:	85 c0                	test   %eax,%eax
c0109af4:	74 08                	je     c0109afe <copy_mm+0x35>
        mm = oldmm;
c0109af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c0109afc:	eb 78                	jmp    c0109b76 <copy_mm+0xad>
    }

    int ret = -E_NO_MEM;
c0109afe:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c0109b05:	e8 1c e3 ff ff       	call   c0107e26 <mm_create>
c0109b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109b11:	75 05                	jne    c0109b18 <copy_mm+0x4f>
        goto bad_mm;
c0109b13:	e9 c8 00 00 00       	jmp    c0109be0 <copy_mm+0x117>
    }
    if (setup_pgdir(mm) != 0) {
c0109b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b1b:	89 04 24             	mov    %eax,(%esp)
c0109b1e:	e8 d9 fe ff ff       	call   c01099fc <setup_pgdir>
c0109b23:	85 c0                	test   %eax,%eax
c0109b25:	74 05                	je     c0109b2c <copy_mm+0x63>
        goto bad_pgdir_cleanup_mm;
c0109b27:	e9 a9 00 00 00       	jmp    c0109bd5 <copy_mm+0x10c>
    }

    lock_mm(oldmm);
c0109b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b2f:	89 04 24             	mov    %eax,(%esp)
c0109b32:	e8 7f f8 ff ff       	call   c01093b6 <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b41:	89 04 24             	mov    %eax,(%esp)
c0109b44:	e8 f4 e7 ff ff       	call   c010833d <dup_mmap>
c0109b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c0109b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b4f:	89 04 24             	mov    %eax,(%esp)
c0109b52:	e8 7b f8 ff ff       	call   c01093d2 <unlock_mm>

    if (ret != 0) {
c0109b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109b5b:	74 19                	je     c0109b76 <copy_mm+0xad>
        goto bad_dup_cleanup_mmap;
c0109b5d:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c0109b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b61:	89 04 24             	mov    %eax,(%esp)
c0109b64:	e8 d5 e8 ff ff       	call   c010843e <exit_mmap>
    put_pgdir(mm);
c0109b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b6c:	89 04 24             	mov    %eax,(%esp)
c0109b6f:	e8 2f ff ff ff       	call   c0109aa3 <put_pgdir>
c0109b74:	eb 5f                	jmp    c0109bd5 <copy_mm+0x10c>
    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c0109b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b79:	89 04 24             	mov    %eax,(%esp)
c0109b7c:	e8 01 f8 ff ff       	call   c0109382 <mm_count_inc>
    proc->mm = mm;
c0109b81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109b87:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c0109b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b8d:	8b 40 0c             	mov    0xc(%eax),%eax
c0109b90:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b93:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c0109b9a:	77 23                	ja     c0109bbf <copy_mm+0xf6>
c0109b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109ba3:	c7 44 24 08 e4 dc 10 	movl   $0xc010dce4,0x8(%esp)
c0109baa:	c0 
c0109bab:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
c0109bb2:	00 
c0109bb3:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109bba:	e8 16 72 ff ff       	call   c0100dd5 <__panic>
c0109bbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bc2:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0109bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bcb:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c0109bce:	b8 00 00 00 00       	mov    $0x0,%eax
c0109bd3:	eb 0e                	jmp    c0109be3 <copy_mm+0x11a>
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c0109bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bd8:	89 04 24             	mov    %eax,(%esp)
c0109bdb:	e8 9f e5 ff ff       	call   c010817f <mm_destroy>
bad_mm:
    return ret;
c0109be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0109be3:	c9                   	leave  
c0109be4:	c3                   	ret    

c0109be5 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0109be5:	55                   	push   %ebp
c0109be6:	89 e5                	mov    %esp,%ebp
c0109be8:	57                   	push   %edi
c0109be9:	56                   	push   %esi
c0109bea:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0109beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bee:	8b 40 0c             	mov    0xc(%eax),%eax
c0109bf1:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0109bf6:	89 c2                	mov    %eax,%edx
c0109bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bfb:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0109bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c01:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c04:	8b 55 10             	mov    0x10(%ebp),%edx
c0109c07:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0109c0c:	89 c1                	mov    %eax,%ecx
c0109c0e:	83 e1 01             	and    $0x1,%ecx
c0109c11:	85 c9                	test   %ecx,%ecx
c0109c13:	74 0e                	je     c0109c23 <copy_thread+0x3e>
c0109c15:	0f b6 0a             	movzbl (%edx),%ecx
c0109c18:	88 08                	mov    %cl,(%eax)
c0109c1a:	83 c0 01             	add    $0x1,%eax
c0109c1d:	83 c2 01             	add    $0x1,%edx
c0109c20:	83 eb 01             	sub    $0x1,%ebx
c0109c23:	89 c1                	mov    %eax,%ecx
c0109c25:	83 e1 02             	and    $0x2,%ecx
c0109c28:	85 c9                	test   %ecx,%ecx
c0109c2a:	74 0f                	je     c0109c3b <copy_thread+0x56>
c0109c2c:	0f b7 0a             	movzwl (%edx),%ecx
c0109c2f:	66 89 08             	mov    %cx,(%eax)
c0109c32:	83 c0 02             	add    $0x2,%eax
c0109c35:	83 c2 02             	add    $0x2,%edx
c0109c38:	83 eb 02             	sub    $0x2,%ebx
c0109c3b:	89 d9                	mov    %ebx,%ecx
c0109c3d:	c1 e9 02             	shr    $0x2,%ecx
c0109c40:	89 c7                	mov    %eax,%edi
c0109c42:	89 d6                	mov    %edx,%esi
c0109c44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c46:	89 f2                	mov    %esi,%edx
c0109c48:	89 f8                	mov    %edi,%eax
c0109c4a:	b9 00 00 00 00       	mov    $0x0,%ecx
c0109c4f:	89 de                	mov    %ebx,%esi
c0109c51:	83 e6 02             	and    $0x2,%esi
c0109c54:	85 f6                	test   %esi,%esi
c0109c56:	74 0b                	je     c0109c63 <copy_thread+0x7e>
c0109c58:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0109c5c:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0109c60:	83 c1 02             	add    $0x2,%ecx
c0109c63:	83 e3 01             	and    $0x1,%ebx
c0109c66:	85 db                	test   %ebx,%ebx
c0109c68:	74 07                	je     c0109c71 <copy_thread+0x8c>
c0109c6a:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0109c6e:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0109c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c74:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c77:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0109c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c81:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c84:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109c87:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0109c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c8d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109c90:	8b 55 08             	mov    0x8(%ebp),%edx
c0109c93:	8b 52 3c             	mov    0x3c(%edx),%edx
c0109c96:	8b 52 40             	mov    0x40(%edx),%edx
c0109c99:	80 ce 02             	or     $0x2,%dh
c0109c9c:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0109c9f:	ba ef 97 10 c0       	mov    $0xc01097ef,%edx
c0109ca4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ca7:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0109caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cad:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109cb0:	89 c2                	mov    %eax,%edx
c0109cb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cb5:	89 50 20             	mov    %edx,0x20(%eax)
}
c0109cb8:	5b                   	pop    %ebx
c0109cb9:	5e                   	pop    %esi
c0109cba:	5f                   	pop    %edi
c0109cbb:	5d                   	pop    %ebp
c0109cbc:	c3                   	ret    

c0109cbd <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0109cbd:	55                   	push   %ebp
c0109cbe:	89 e5                	mov    %esp,%ebp
c0109cc0:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c0109cc3:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0109cca:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c0109ccf:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0109cd4:	7e 05                	jle    c0109cdb <do_fork+0x1e>
        goto fork_out;
c0109cd6:	e9 ef 00 00 00       	jmp    c0109dca <do_fork+0x10d>
    }
    ret = -E_NO_MEM;
c0109cdb:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid

    proc = alloc_proc();
c0109ce2:	e8 07 f7 ff ff       	call   c01093ee <alloc_proc>
c0109ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (proc == NULL) {  
c0109cea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109cee:	75 05                	jne    c0109cf5 <do_fork+0x38>
    	goto fork_out;
c0109cf0:	e9 d5 00 00 00       	jmp    c0109dca <do_fork+0x10d>
    }

    proc->parent = current; 
c0109cf5:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cfe:	89 50 14             	mov    %edx,0x14(%eax)
    assert(current->wait_state == 0);
c0109d01:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109d06:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109d09:	85 c0                	test   %eax,%eax
c0109d0b:	74 24                	je     c0109d31 <do_fork+0x74>
c0109d0d:	c7 44 24 0c 1c dd 10 	movl   $0xc010dd1c,0xc(%esp)
c0109d14:	c0 
c0109d15:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c0109d1c:	c0 
c0109d1d:	c7 44 24 04 a5 01 00 	movl   $0x1a5,0x4(%esp)
c0109d24:	00 
c0109d25:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109d2c:	e8 a4 70 ff ff       	call   c0100dd5 <__panic>

    if (setup_kstack(proc) != 0) {  
c0109d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d34:	89 04 24             	mov    %eax,(%esp)
c0109d37:	e8 5e fc ff ff       	call   c010999a <setup_kstack>
c0109d3c:	85 c0                	test   %eax,%eax
c0109d3e:	74 05                	je     c0109d45 <do_fork+0x88>
    	goto bad_fork_cleanup_proc;
c0109d40:	e9 8a 00 00 00       	jmp    c0109dcf <do_fork+0x112>
    }
    if (copy_mm(clone_flags, proc) != 0) {  
c0109d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d4f:	89 04 24             	mov    %eax,(%esp)
c0109d52:	e8 72 fd ff ff       	call   c0109ac9 <copy_mm>
c0109d57:	85 c0                	test   %eax,%eax
c0109d59:	74 0e                	je     c0109d69 <do_fork+0xac>
    	goto bad_fork_cleanup_kstack;
c0109d5b:	90                   	nop
	
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0109d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d5f:	89 04 24             	mov    %eax,(%esp)
c0109d62:	e8 6f fc ff ff       	call   c01099d6 <put_kstack>
c0109d67:	eb 66                	jmp    c0109dcf <do_fork+0x112>
    	goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0) {  
    	goto bad_fork_cleanup_kstack;
    }
    copy_thread(proc, stack, tf);
c0109d69:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109d70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d7a:	89 04 24             	mov    %eax,(%esp)
c0109d7d:	e8 63 fe ff ff       	call   c0109be5 <copy_thread>
    bool intr_flag;
	local_intr_save(intr_flag);
c0109d82:	e8 35 f4 ff ff       	call   c01091bc <__intr_save>
c0109d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
	{
    		proc->pid = get_pid();
c0109d8a:	e8 f3 f8 ff ff       	call   c0109682 <get_pid>
c0109d8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109d92:	89 42 04             	mov    %eax,0x4(%edx)
		hash_proc(proc);
c0109d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109d98:	89 04 24             	mov    %eax,(%esp)
c0109d9b:	e8 67 fa ff ff       	call   c0109807 <hash_proc>
        	//nr_process++;  
		//list_add_before(&proc_list, &proc->list_link);
		set_links(proc);
c0109da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109da3:	89 04 24             	mov    %eax,(%esp)
c0109da6:	e8 af f7 ff ff       	call   c010955a <set_links>
	}
	local_intr_restore(intr_flag);
c0109dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109dae:	89 04 24             	mov    %eax,(%esp)
c0109db1:	e8 30 f4 ff ff       	call   c01091e6 <__intr_restore>
    wakeup_proc(proc);
c0109db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109db9:	89 04 24             	mov    %eax,(%esp)
c0109dbc:	e8 fe 0f 00 00       	call   c010adbf <wakeup_proc>
    ret = proc->pid;
c0109dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dc4:	8b 40 04             	mov    0x4(%eax),%eax
c0109dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
	*    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
    */
	
fork_out:
    return ret;
c0109dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dcd:	eb 0d                	jmp    c0109ddc <do_fork+0x11f>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0109dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109dd2:	89 04 24             	mov    %eax,(%esp)
c0109dd5:	e8 97 ae ff ff       	call   c0104c71 <kfree>
    goto fork_out;
c0109dda:	eb ee                	jmp    c0109dca <do_fork+0x10d>
}
c0109ddc:	c9                   	leave  
c0109ddd:	c3                   	ret    

c0109dde <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0109dde:	55                   	push   %ebp
c0109ddf:	89 e5                	mov    %esp,%ebp
c0109de1:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c0109de4:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109dea:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c0109def:	39 c2                	cmp    %eax,%edx
c0109df1:	75 1c                	jne    c0109e0f <do_exit+0x31>
        panic("idleproc exit.\n");
c0109df3:	c7 44 24 08 4a dd 10 	movl   $0xc010dd4a,0x8(%esp)
c0109dfa:	c0 
c0109dfb:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
c0109e02:	00 
c0109e03:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109e0a:	e8 c6 6f ff ff       	call   c0100dd5 <__panic>
    }
    if (current == initproc) {
c0109e0f:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c0109e15:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109e1a:	39 c2                	cmp    %eax,%edx
c0109e1c:	75 1c                	jne    c0109e3a <do_exit+0x5c>
        panic("initproc exit.\n");
c0109e1e:	c7 44 24 08 5a dd 10 	movl   $0xc010dd5a,0x8(%esp)
c0109e25:	c0 
c0109e26:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c0109e2d:	00 
c0109e2e:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109e35:	e8 9b 6f ff ff       	call   c0100dd5 <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c0109e3a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e3f:	8b 40 18             	mov    0x18(%eax),%eax
c0109e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c0109e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109e49:	74 4a                	je     c0109e95 <do_exit+0xb7>
        lcr3(boot_cr3);
c0109e4b:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c0109e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109e56:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c0109e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e5c:	89 04 24             	mov    %eax,(%esp)
c0109e5f:	e8 38 f5 ff ff       	call   c010939c <mm_count_dec>
c0109e64:	85 c0                	test   %eax,%eax
c0109e66:	75 21                	jne    c0109e89 <do_exit+0xab>
            exit_mmap(mm);
c0109e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e6b:	89 04 24             	mov    %eax,(%esp)
c0109e6e:	e8 cb e5 ff ff       	call   c010843e <exit_mmap>
            put_pgdir(mm);
c0109e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e76:	89 04 24             	mov    %eax,(%esp)
c0109e79:	e8 25 fc ff ff       	call   c0109aa3 <put_pgdir>
            mm_destroy(mm);
c0109e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e81:	89 04 24             	mov    %eax,(%esp)
c0109e84:	e8 f6 e2 ff ff       	call   c010817f <mm_destroy>
        }
        current->mm = NULL;
c0109e89:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e8e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c0109e95:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109e9a:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c0109ea0:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ea5:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ea8:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c0109eab:	e8 0c f3 ff ff       	call   c01091bc <__intr_save>
c0109eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c0109eb3:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109eb8:	8b 40 14             	mov    0x14(%eax),%eax
c0109ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c0109ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ec1:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109ec4:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109ec9:	75 10                	jne    c0109edb <do_exit+0xfd>
            wakeup_proc(proc);
c0109ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ece:	89 04 24             	mov    %eax,(%esp)
c0109ed1:	e8 e9 0e 00 00       	call   c010adbf <wakeup_proc>
        }
        while (current->cptr != NULL) {
c0109ed6:	e9 8b 00 00 00       	jmp    c0109f66 <do_exit+0x188>
c0109edb:	e9 86 00 00 00       	jmp    c0109f66 <do_exit+0x188>
            proc = current->cptr;
c0109ee0:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ee5:	8b 40 70             	mov    0x70(%eax),%eax
c0109ee8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c0109eeb:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109ef0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109ef3:	8b 52 78             	mov    0x78(%edx),%edx
c0109ef6:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c0109ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109efc:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c0109f03:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f08:	8b 50 70             	mov    0x70(%eax),%edx
c0109f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f0e:	89 50 78             	mov    %edx,0x78(%eax)
c0109f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f14:	8b 40 78             	mov    0x78(%eax),%eax
c0109f17:	85 c0                	test   %eax,%eax
c0109f19:	74 0e                	je     c0109f29 <do_exit+0x14b>
                initproc->cptr->yptr = proc;
c0109f1b:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f20:	8b 40 70             	mov    0x70(%eax),%eax
c0109f23:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109f26:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c0109f29:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c0109f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f32:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c0109f35:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109f3d:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c0109f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f43:	8b 00                	mov    (%eax),%eax
c0109f45:	83 f8 03             	cmp    $0x3,%eax
c0109f48:	75 1c                	jne    c0109f66 <do_exit+0x188>
                if (initproc->wait_state == WT_CHILD) {
c0109f4a:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f4f:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109f52:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109f57:	75 0d                	jne    c0109f66 <do_exit+0x188>
                    wakeup_proc(initproc);
c0109f59:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c0109f5e:	89 04 24             	mov    %eax,(%esp)
c0109f61:	e8 59 0e 00 00       	call   c010adbf <wakeup_proc>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c0109f66:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f6b:	8b 40 70             	mov    0x70(%eax),%eax
c0109f6e:	85 c0                	test   %eax,%eax
c0109f70:	0f 85 6a ff ff ff    	jne    c0109ee0 <do_exit+0x102>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c0109f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f79:	89 04 24             	mov    %eax,(%esp)
c0109f7c:	e8 65 f2 ff ff       	call   c01091e6 <__intr_restore>
    
    schedule();
c0109f81:	e8 bd 0e 00 00       	call   c010ae43 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c0109f86:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109f8b:	8b 40 04             	mov    0x4(%eax),%eax
c0109f8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109f92:	c7 44 24 08 6c dd 10 	movl   $0xc010dd6c,0x8(%esp)
c0109f99:	c0 
c0109f9a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0109fa1:	00 
c0109fa2:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109fa9:	e8 27 6e ff ff       	call   c0100dd5 <__panic>

c0109fae <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c0109fae:	55                   	push   %ebp
c0109faf:	89 e5                	mov    %esp,%ebp
c0109fb1:	83 ec 78             	sub    $0x78,%esp
    if (current->mm != NULL) {
c0109fb4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c0109fb9:	8b 40 18             	mov    0x18(%eax),%eax
c0109fbc:	85 c0                	test   %eax,%eax
c0109fbe:	74 1c                	je     c0109fdc <load_icode+0x2e>
        panic("load_icode: current->mm must be empty.\n");
c0109fc0:	c7 44 24 08 8c dd 10 	movl   $0xc010dd8c,0x8(%esp)
c0109fc7:	c0 
c0109fc8:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0109fcf:	00 
c0109fd0:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c0109fd7:	e8 f9 6d ff ff       	call   c0100dd5 <__panic>
    }

    int ret = -E_NO_MEM;
c0109fdc:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
c0109fe3:	e8 3e de ff ff       	call   c0107e26 <mm_create>
c0109fe8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109feb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0109fef:	75 06                	jne    c0109ff7 <load_icode+0x49>
        goto bad_mm;
c0109ff1:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c0109ff2:	e9 ef 05 00 00       	jmp    c010a5e6 <load_icode+0x638>
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
c0109ff7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109ffa:	89 04 24             	mov    %eax,(%esp)
c0109ffd:	e8 fa f9 ff ff       	call   c01099fc <setup_pgdir>
c010a002:	85 c0                	test   %eax,%eax
c010a004:	74 05                	je     c010a00b <load_icode+0x5d>
        goto bad_pgdir_cleanup_mm;
c010a006:	e9 f6 05 00 00       	jmp    c010a601 <load_icode+0x653>
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c010a00b:	8b 45 08             	mov    0x8(%ebp),%eax
c010a00e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c010a011:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a014:	8b 50 1c             	mov    0x1c(%eax),%edx
c010a017:	8b 45 08             	mov    0x8(%ebp),%eax
c010a01a:	01 d0                	add    %edx,%eax
c010a01c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c010a01f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a022:	8b 00                	mov    (%eax),%eax
c010a024:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c010a029:	74 0c                	je     c010a037 <load_icode+0x89>
        ret = -E_INVAL_ELF;
c010a02b:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c010a032:	e9 bf 05 00 00       	jmp    c010a5f6 <load_icode+0x648>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c010a037:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a03a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010a03e:	0f b7 c0             	movzwl %ax,%eax
c010a041:	c1 e0 05             	shl    $0x5,%eax
c010a044:	89 c2                	mov    %eax,%edx
c010a046:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a049:	01 d0                	add    %edx,%eax
c010a04b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c010a04e:	e9 13 03 00 00       	jmp    c010a366 <load_icode+0x3b8>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c010a053:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a056:	8b 00                	mov    (%eax),%eax
c010a058:	83 f8 01             	cmp    $0x1,%eax
c010a05b:	74 05                	je     c010a062 <load_icode+0xb4>
            continue ;
c010a05d:	e9 00 03 00 00       	jmp    c010a362 <load_icode+0x3b4>
        }
        if (ph->p_filesz > ph->p_memsz) {
c010a062:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a065:	8b 50 10             	mov    0x10(%eax),%edx
c010a068:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a06b:	8b 40 14             	mov    0x14(%eax),%eax
c010a06e:	39 c2                	cmp    %eax,%edx
c010a070:	76 0c                	jbe    c010a07e <load_icode+0xd0>
            ret = -E_INVAL_ELF;
c010a072:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c010a079:	e9 6d 05 00 00       	jmp    c010a5eb <load_icode+0x63d>
        }
        if (ph->p_filesz == 0) {
c010a07e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a081:	8b 40 10             	mov    0x10(%eax),%eax
c010a084:	85 c0                	test   %eax,%eax
c010a086:	75 05                	jne    c010a08d <load_icode+0xdf>
            continue ;
c010a088:	e9 d5 02 00 00       	jmp    c010a362 <load_icode+0x3b4>
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
c010a08d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010a094:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
c010a09b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a09e:	8b 40 18             	mov    0x18(%eax),%eax
c010a0a1:	83 e0 01             	and    $0x1,%eax
c010a0a4:	85 c0                	test   %eax,%eax
c010a0a6:	74 04                	je     c010a0ac <load_icode+0xfe>
c010a0a8:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
c010a0ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0af:	8b 40 18             	mov    0x18(%eax),%eax
c010a0b2:	83 e0 02             	and    $0x2,%eax
c010a0b5:	85 c0                	test   %eax,%eax
c010a0b7:	74 04                	je     c010a0bd <load_icode+0x10f>
c010a0b9:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
c010a0bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0c0:	8b 40 18             	mov    0x18(%eax),%eax
c010a0c3:	83 e0 04             	and    $0x4,%eax
c010a0c6:	85 c0                	test   %eax,%eax
c010a0c8:	74 04                	je     c010a0ce <load_icode+0x120>
c010a0ca:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c010a0ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a0d1:	83 e0 02             	and    $0x2,%eax
c010a0d4:	85 c0                	test   %eax,%eax
c010a0d6:	74 04                	je     c010a0dc <load_icode+0x12e>
c010a0d8:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c010a0dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0df:	8b 50 14             	mov    0x14(%eax),%edx
c010a0e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0e5:	8b 40 08             	mov    0x8(%eax),%eax
c010a0e8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a0ef:	00 
c010a0f0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010a0f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010a0f7:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a0fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a0ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a102:	89 04 24             	mov    %eax,(%esp)
c010a105:	e8 17 e1 ff ff       	call   c0108221 <mm_map>
c010a10a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a10d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a111:	74 05                	je     c010a118 <load_icode+0x16a>
            goto bad_cleanup_mmap;
c010a113:	e9 d3 04 00 00       	jmp    c010a5eb <load_icode+0x63d>
        }
        unsigned char *from = binary + ph->p_offset;
c010a118:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a11b:	8b 50 04             	mov    0x4(%eax),%edx
c010a11e:	8b 45 08             	mov    0x8(%ebp),%eax
c010a121:	01 d0                	add    %edx,%eax
c010a123:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c010a126:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a129:	8b 40 08             	mov    0x8(%eax),%eax
c010a12c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a12f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a132:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010a135:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010a138:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010a13d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c010a140:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c010a147:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a14a:	8b 50 08             	mov    0x8(%eax),%edx
c010a14d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a150:	8b 40 10             	mov    0x10(%eax),%eax
c010a153:	01 d0                	add    %edx,%eax
c010a155:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a158:	e9 90 00 00 00       	jmp    c010a1ed <load_icode+0x23f>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a15d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a160:	8b 40 0c             	mov    0xc(%eax),%eax
c010a163:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a166:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a16a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a16d:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a171:	89 04 24             	mov    %eax,(%esp)
c010a174:	e8 28 be ff ff       	call   c0105fa1 <pgdir_alloc_page>
c010a179:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a17c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a180:	75 05                	jne    c010a187 <load_icode+0x1d9>
                goto bad_cleanup_mmap;
c010a182:	e9 64 04 00 00       	jmp    c010a5eb <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a187:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a18a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a18d:	29 c2                	sub    %eax,%edx
c010a18f:	89 d0                	mov    %edx,%eax
c010a191:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a194:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a199:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a19c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a19f:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a1a6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a1a9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a1ac:	73 0d                	jae    c010a1bb <load_icode+0x20d>
                size -= la - end;
c010a1ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a1b1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a1b4:	29 c2                	sub    %eax,%edx
c010a1b6:	89 d0                	mov    %edx,%eax
c010a1b8:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c010a1bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a1be:	89 04 24             	mov    %eax,(%esp)
c010a1c1:	e8 1e f1 ff ff       	call   c01092e4 <page2kva>
c010a1c6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a1c9:	01 c2                	add    %eax,%edx
c010a1cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a1ce:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a1d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010a1d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a1d9:	89 14 24             	mov    %edx,(%esp)
c010a1dc:	e8 af 1a 00 00       	call   c010bc90 <memcpy>
            start += size, from += size;
c010a1e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a1e4:	01 45 d8             	add    %eax,-0x28(%ebp)
c010a1e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a1ea:	01 45 e0             	add    %eax,-0x20(%ebp)
        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a1ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a1f0:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a1f3:	0f 82 64 ff ff ff    	jb     c010a15d <load_icode+0x1af>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c010a1f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a1fc:	8b 50 08             	mov    0x8(%eax),%edx
c010a1ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a202:	8b 40 14             	mov    0x14(%eax),%eax
c010a205:	01 d0                	add    %edx,%eax
c010a207:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c010a20a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a20d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a210:	0f 83 b0 00 00 00    	jae    c010a2c6 <load_icode+0x318>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c010a216:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a219:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a21c:	75 05                	jne    c010a223 <load_icode+0x275>
                continue ;
c010a21e:	e9 3f 01 00 00       	jmp    c010a362 <load_icode+0x3b4>
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c010a223:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a226:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a229:	29 c2                	sub    %eax,%edx
c010a22b:	89 d0                	mov    %edx,%eax
c010a22d:	05 00 10 00 00       	add    $0x1000,%eax
c010a232:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a235:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a23a:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a23d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c010a240:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a243:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a246:	73 0d                	jae    c010a255 <load_icode+0x2a7>
                size -= la - end;
c010a248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a24b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a24e:	29 c2                	sub    %eax,%edx
c010a250:	89 d0                	mov    %edx,%eax
c010a252:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a255:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a258:	89 04 24             	mov    %eax,(%esp)
c010a25b:	e8 84 f0 ff ff       	call   c01092e4 <page2kva>
c010a260:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a263:	01 c2                	add    %eax,%edx
c010a265:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a268:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a26c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a273:	00 
c010a274:	89 14 24             	mov    %edx,(%esp)
c010a277:	e8 32 19 00 00       	call   c010bbae <memset>
            start += size;
c010a27c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a27f:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c010a282:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a285:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a288:	73 08                	jae    c010a292 <load_icode+0x2e4>
c010a28a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a28d:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a290:	74 34                	je     c010a2c6 <load_icode+0x318>
c010a292:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a295:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a298:	72 08                	jb     c010a2a2 <load_icode+0x2f4>
c010a29a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a29d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a2a0:	74 24                	je     c010a2c6 <load_icode+0x318>
c010a2a2:	c7 44 24 0c b4 dd 10 	movl   $0xc010ddb4,0xc(%esp)
c010a2a9:	c0 
c010a2aa:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010a2b1:	c0 
c010a2b2:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c010a2b9:	00 
c010a2ba:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a2c1:	e8 0f 6b ff ff       	call   c0100dd5 <__panic>
        }
        while (start < end) {
c010a2c6:	e9 8b 00 00 00       	jmp    c010a356 <load_icode+0x3a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a2cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a2ce:	8b 40 0c             	mov    0xc(%eax),%eax
c010a2d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a2d4:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a2d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a2db:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a2df:	89 04 24             	mov    %eax,(%esp)
c010a2e2:	e8 ba bc ff ff       	call   c0105fa1 <pgdir_alloc_page>
c010a2e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a2ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a2ee:	75 05                	jne    c010a2f5 <load_icode+0x347>
                goto bad_cleanup_mmap;
c010a2f0:	e9 f6 02 00 00       	jmp    c010a5eb <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a2f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a2f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a2fb:	29 c2                	sub    %eax,%edx
c010a2fd:	89 d0                	mov    %edx,%eax
c010a2ff:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a302:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a307:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a30a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a30d:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a314:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a317:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a31a:	73 0d                	jae    c010a329 <load_icode+0x37b>
                size -= la - end;
c010a31c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a31f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a322:	29 c2                	sub    %eax,%edx
c010a324:	89 d0                	mov    %edx,%eax
c010a326:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a329:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a32c:	89 04 24             	mov    %eax,(%esp)
c010a32f:	e8 b0 ef ff ff       	call   c01092e4 <page2kva>
c010a334:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a337:	01 c2                	add    %eax,%edx
c010a339:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a33c:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a340:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a347:	00 
c010a348:	89 14 24             	mov    %edx,(%esp)
c010a34b:	e8 5e 18 00 00       	call   c010bbae <memset>
            start += size;
c010a350:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a353:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a356:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a359:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a35c:	0f 82 69 ff ff ff    	jb     c010a2cb <load_icode+0x31d>
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a362:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a366:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a369:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a36c:	0f 82 e1 fc ff ff    	jb     c010a053 <load_icode+0xa5>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a372:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a379:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a380:	00 
c010a381:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a384:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a388:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a38f:	00 
c010a390:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a397:	af 
c010a398:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a39b:	89 04 24             	mov    %eax,(%esp)
c010a39e:	e8 7e de ff ff       	call   c0108221 <mm_map>
c010a3a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a3a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a3aa:	74 05                	je     c010a3b1 <load_icode+0x403>
        goto bad_cleanup_mmap;
c010a3ac:	e9 3a 02 00 00       	jmp    c010a5eb <load_icode+0x63d>
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a3b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a3b4:	8b 40 0c             	mov    0xc(%eax),%eax
c010a3b7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a3be:	00 
c010a3bf:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a3c6:	af 
c010a3c7:	89 04 24             	mov    %eax,(%esp)
c010a3ca:	e8 d2 bb ff ff       	call   c0105fa1 <pgdir_alloc_page>
c010a3cf:	85 c0                	test   %eax,%eax
c010a3d1:	75 24                	jne    c010a3f7 <load_icode+0x449>
c010a3d3:	c7 44 24 0c f0 dd 10 	movl   $0xc010ddf0,0xc(%esp)
c010a3da:	c0 
c010a3db:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010a3e2:	c0 
c010a3e3:	c7 44 24 04 72 02 00 	movl   $0x272,0x4(%esp)
c010a3ea:	00 
c010a3eb:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a3f2:	e8 de 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a3f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a3fa:	8b 40 0c             	mov    0xc(%eax),%eax
c010a3fd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a404:	00 
c010a405:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a40c:	af 
c010a40d:	89 04 24             	mov    %eax,(%esp)
c010a410:	e8 8c bb ff ff       	call   c0105fa1 <pgdir_alloc_page>
c010a415:	85 c0                	test   %eax,%eax
c010a417:	75 24                	jne    c010a43d <load_icode+0x48f>
c010a419:	c7 44 24 0c 34 de 10 	movl   $0xc010de34,0xc(%esp)
c010a420:	c0 
c010a421:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010a428:	c0 
c010a429:	c7 44 24 04 73 02 00 	movl   $0x273,0x4(%esp)
c010a430:	00 
c010a431:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a438:	e8 98 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a43d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a440:	8b 40 0c             	mov    0xc(%eax),%eax
c010a443:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a44a:	00 
c010a44b:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a452:	af 
c010a453:	89 04 24             	mov    %eax,(%esp)
c010a456:	e8 46 bb ff ff       	call   c0105fa1 <pgdir_alloc_page>
c010a45b:	85 c0                	test   %eax,%eax
c010a45d:	75 24                	jne    c010a483 <load_icode+0x4d5>
c010a45f:	c7 44 24 0c 78 de 10 	movl   $0xc010de78,0xc(%esp)
c010a466:	c0 
c010a467:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010a46e:	c0 
c010a46f:	c7 44 24 04 74 02 00 	movl   $0x274,0x4(%esp)
c010a476:	00 
c010a477:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a47e:	e8 52 69 ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a483:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a486:	8b 40 0c             	mov    0xc(%eax),%eax
c010a489:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a490:	00 
c010a491:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a498:	af 
c010a499:	89 04 24             	mov    %eax,(%esp)
c010a49c:	e8 00 bb ff ff       	call   c0105fa1 <pgdir_alloc_page>
c010a4a1:	85 c0                	test   %eax,%eax
c010a4a3:	75 24                	jne    c010a4c9 <load_icode+0x51b>
c010a4a5:	c7 44 24 0c bc de 10 	movl   $0xc010debc,0xc(%esp)
c010a4ac:	c0 
c010a4ad:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010a4b4:	c0 
c010a4b5:	c7 44 24 04 75 02 00 	movl   $0x275,0x4(%esp)
c010a4bc:	00 
c010a4bd:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a4c4:	e8 0c 69 ff ff       	call   c0100dd5 <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a4c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a4cc:	89 04 24             	mov    %eax,(%esp)
c010a4cf:	e8 ae ee ff ff       	call   c0109382 <mm_count_inc>
    current->mm = mm;
c010a4d4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a4d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a4dc:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a4df:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a4e4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a4e7:	8b 52 0c             	mov    0xc(%edx),%edx
c010a4ea:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a4ed:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a4f4:	77 23                	ja     c010a519 <load_icode+0x56b>
c010a4f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a4f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a4fd:	c7 44 24 08 e4 dc 10 	movl   $0xc010dce4,0x8(%esp)
c010a504:	c0 
c010a505:	c7 44 24 04 7a 02 00 	movl   $0x27a,0x4(%esp)
c010a50c:	00 
c010a50d:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a514:	e8 bc 68 ff ff       	call   c0100dd5 <__panic>
c010a519:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a51c:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a522:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a525:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a528:	8b 40 0c             	mov    0xc(%eax),%eax
c010a52b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a52e:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a535:	77 23                	ja     c010a55a <load_icode+0x5ac>
c010a537:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a53a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a53e:	c7 44 24 08 e4 dc 10 	movl   $0xc010dce4,0x8(%esp)
c010a545:	c0 
c010a546:	c7 44 24 04 7b 02 00 	movl   $0x27b,0x4(%esp)
c010a54d:	00 
c010a54e:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a555:	e8 7b 68 ff ff       	call   c0100dd5 <__panic>
c010a55a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a55d:	05 00 00 00 40       	add    $0x40000000,%eax
c010a562:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a565:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a568:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
c010a56b:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a570:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a573:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a576:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a57d:	00 
c010a57e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a585:	00 
c010a586:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a589:	89 04 24             	mov    %eax,(%esp)
c010a58c:	e8 1d 16 00 00       	call   c010bbae <memset>
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */

    tf->tf_cs = USER_CS;
c010a591:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a594:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a59a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a59d:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a5a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5a6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a5aa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5ad:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a5b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5b4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a5b8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5bb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a5bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5c2:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;
c010a5c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a5cc:	8b 50 18             	mov    0x18(%eax),%edx
c010a5cf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5d2:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;
c010a5d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a5d8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)

    ret = 0;
c010a5df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a5e9:	eb 23                	jmp    c010a60e <load_icode+0x660>
bad_cleanup_mmap:
    exit_mmap(mm);
c010a5eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a5ee:	89 04 24             	mov    %eax,(%esp)
c010a5f1:	e8 48 de ff ff       	call   c010843e <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a5f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a5f9:	89 04 24             	mov    %eax,(%esp)
c010a5fc:	e8 a2 f4 ff ff       	call   c0109aa3 <put_pgdir>
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a601:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a604:	89 04 24             	mov    %eax,(%esp)
c010a607:	e8 73 db ff ff       	call   c010817f <mm_destroy>
bad_mm:
    goto out;
c010a60c:	eb d8                	jmp    c010a5e6 <load_icode+0x638>
}
c010a60e:	c9                   	leave  
c010a60f:	c3                   	ret    

c010a610 <do_execve>:

// do_execve - call exit_mmap(mm)&pug_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a610:	55                   	push   %ebp
c010a611:	89 e5                	mov    %esp,%ebp
c010a613:	83 ec 38             	sub    $0x38,%esp
    struct mm_struct *mm = current->mm;
c010a616:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a61b:	8b 40 18             	mov    0x18(%eax),%eax
c010a61e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a621:	8b 45 08             	mov    0x8(%ebp),%eax
c010a624:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a62b:	00 
c010a62c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a62f:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a633:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a637:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a63a:	89 04 24             	mov    %eax,(%esp)
c010a63d:	e8 64 e8 ff ff       	call   c0108ea6 <user_mem_check>
c010a642:	85 c0                	test   %eax,%eax
c010a644:	75 0a                	jne    c010a650 <do_execve+0x40>
        return -E_INVAL;
c010a646:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a64b:	e9 f4 00 00 00       	jmp    c010a744 <do_execve+0x134>
    }
    if (len > PROC_NAME_LEN) {
c010a650:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a654:	76 07                	jbe    c010a65d <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a656:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a65d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a664:	00 
c010a665:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a66c:	00 
c010a66d:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a670:	89 04 24             	mov    %eax,(%esp)
c010a673:	e8 36 15 00 00       	call   c010bbae <memset>
    memcpy(local_name, name, len);
c010a678:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a67b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a67f:	8b 45 08             	mov    0x8(%ebp),%eax
c010a682:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a686:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a689:	89 04 24             	mov    %eax,(%esp)
c010a68c:	e8 ff 15 00 00       	call   c010bc90 <memcpy>

    if (mm != NULL) {
c010a691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a695:	74 4a                	je     c010a6e1 <do_execve+0xd1>
        lcr3(boot_cr3);
c010a697:	a1 c8 ef 19 c0       	mov    0xc019efc8,%eax
c010a69c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a69f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a6a2:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a6a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6a8:	89 04 24             	mov    %eax,(%esp)
c010a6ab:	e8 ec ec ff ff       	call   c010939c <mm_count_dec>
c010a6b0:	85 c0                	test   %eax,%eax
c010a6b2:	75 21                	jne    c010a6d5 <do_execve+0xc5>
            exit_mmap(mm);
c010a6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6b7:	89 04 24             	mov    %eax,(%esp)
c010a6ba:	e8 7f dd ff ff       	call   c010843e <exit_mmap>
            put_pgdir(mm);
c010a6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6c2:	89 04 24             	mov    %eax,(%esp)
c010a6c5:	e8 d9 f3 ff ff       	call   c0109aa3 <put_pgdir>
            mm_destroy(mm);
c010a6ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a6cd:	89 04 24             	mov    %eax,(%esp)
c010a6d0:	e8 aa da ff ff       	call   c010817f <mm_destroy>
        }
        current->mm = NULL;
c010a6d5:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a6da:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
c010a6e1:	8b 45 14             	mov    0x14(%ebp),%eax
c010a6e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a6e8:	8b 45 10             	mov    0x10(%ebp),%eax
c010a6eb:	89 04 24             	mov    %eax,(%esp)
c010a6ee:	e8 bb f8 ff ff       	call   c0109fae <load_icode>
c010a6f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a6f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a6fa:	74 2f                	je     c010a72b <do_execve+0x11b>
        goto execve_exit;
c010a6fc:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a6fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a700:	89 04 24             	mov    %eax,(%esp)
c010a703:	e8 d6 f6 ff ff       	call   c0109dde <do_exit>
    panic("already exit: %e.\n", ret);
c010a708:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a70b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a70f:	c7 44 24 08 ff de 10 	movl   $0xc010deff,0x8(%esp)
c010a716:	c0 
c010a717:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c010a71e:	00 
c010a71f:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a726:	e8 aa 66 ff ff       	call   c0100dd5 <__panic>
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a72b:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a730:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a733:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a737:	89 04 24             	mov    %eax,(%esp)
c010a73a:	e8 96 ed ff ff       	call   c01094d5 <set_proc_name>
    return 0;
c010a73f:	b8 00 00 00 00       	mov    $0x0,%eax

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
c010a744:	c9                   	leave  
c010a745:	c3                   	ret    

c010a746 <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a746:	55                   	push   %ebp
c010a747:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a749:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a74e:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a755:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a75a:	5d                   	pop    %ebp
c010a75b:	c3                   	ret    

c010a75c <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a75c:	55                   	push   %ebp
c010a75d:	89 e5                	mov    %esp,%ebp
c010a75f:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a762:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a767:	8b 40 18             	mov    0x18(%eax),%eax
c010a76a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a76d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a771:	74 30                	je     c010a7a3 <do_wait+0x47>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a773:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a776:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a77d:	00 
c010a77e:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a785:	00 
c010a786:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a78a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a78d:	89 04 24             	mov    %eax,(%esp)
c010a790:	e8 11 e7 ff ff       	call   c0108ea6 <user_mem_check>
c010a795:	85 c0                	test   %eax,%eax
c010a797:	75 0a                	jne    c010a7a3 <do_wait+0x47>
            return -E_INVAL;
c010a799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a79e:	e9 4b 01 00 00       	jmp    c010a8ee <do_wait+0x192>
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a7a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a7aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a7ae:	74 39                	je     c010a7e9 <do_wait+0x8d>
        proc = find_proc(pid);
c010a7b0:	8b 45 08             	mov    0x8(%ebp),%eax
c010a7b3:	89 04 24             	mov    %eax,(%esp)
c010a7b6:	e8 fb f0 ff ff       	call   c01098b6 <find_proc>
c010a7bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010a7be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a7c2:	74 54                	je     c010a818 <do_wait+0xbc>
c010a7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a7c7:	8b 50 14             	mov    0x14(%eax),%edx
c010a7ca:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a7cf:	39 c2                	cmp    %eax,%edx
c010a7d1:	75 45                	jne    c010a818 <do_wait+0xbc>
            haskid = 1;
c010a7d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a7dd:	8b 00                	mov    (%eax),%eax
c010a7df:	83 f8 03             	cmp    $0x3,%eax
c010a7e2:	75 34                	jne    c010a818 <do_wait+0xbc>
                goto found;
c010a7e4:	e9 80 00 00 00       	jmp    c010a869 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
c010a7e9:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a7ee:	8b 40 70             	mov    0x70(%eax),%eax
c010a7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010a7f4:	eb 1c                	jmp    c010a812 <do_wait+0xb6>
            haskid = 1;
c010a7f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a800:	8b 00                	mov    (%eax),%eax
c010a802:	83 f8 03             	cmp    $0x3,%eax
c010a805:	75 02                	jne    c010a809 <do_wait+0xad>
                goto found;
c010a807:	eb 60                	jmp    c010a869 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010a809:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a80c:	8b 40 78             	mov    0x78(%eax),%eax
c010a80f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a816:	75 de                	jne    c010a7f6 <do_wait+0x9a>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010a818:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a81c:	74 41                	je     c010a85f <do_wait+0x103>
        current->state = PROC_SLEEPING;
c010a81e:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a823:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010a829:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a82e:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010a835:	e8 09 06 00 00       	call   c010ae43 <schedule>
        if (current->flags & PF_EXITING) {
c010a83a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a83f:	8b 40 44             	mov    0x44(%eax),%eax
c010a842:	83 e0 01             	and    $0x1,%eax
c010a845:	85 c0                	test   %eax,%eax
c010a847:	74 11                	je     c010a85a <do_wait+0xfe>
            do_exit(-E_KILLED);
c010a849:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010a850:	e8 89 f5 ff ff       	call   c0109dde <do_exit>
        }
        goto repeat;
c010a855:	e9 49 ff ff ff       	jmp    c010a7a3 <do_wait+0x47>
c010a85a:	e9 44 ff ff ff       	jmp    c010a7a3 <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010a85f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010a864:	e9 85 00 00 00       	jmp    c010a8ee <do_wait+0x192>

found:
    if (proc == idleproc || proc == initproc) {
c010a869:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010a86e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a871:	74 0a                	je     c010a87d <do_wait+0x121>
c010a873:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010a878:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a87b:	75 1c                	jne    c010a899 <do_wait+0x13d>
        panic("wait idleproc or initproc.\n");
c010a87d:	c7 44 24 08 12 df 10 	movl   $0xc010df12,0x8(%esp)
c010a884:	c0 
c010a885:	c7 44 24 04 f8 02 00 	movl   $0x2f8,0x4(%esp)
c010a88c:	00 
c010a88d:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a894:	e8 3c 65 ff ff       	call   c0100dd5 <__panic>
    }
    if (code_store != NULL) {
c010a899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a89d:	74 0b                	je     c010a8aa <do_wait+0x14e>
        *code_store = proc->exit_code;
c010a89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8a2:	8b 50 68             	mov    0x68(%eax),%edx
c010a8a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a8a8:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010a8aa:	e8 0d e9 ff ff       	call   c01091bc <__intr_save>
c010a8af:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010a8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8b5:	89 04 24             	mov    %eax,(%esp)
c010a8b8:	e8 c6 ef ff ff       	call   c0109883 <unhash_proc>
        remove_links(proc);
c010a8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8c0:	89 04 24             	mov    %eax,(%esp)
c010a8c3:	e8 37 ed ff ff       	call   c01095ff <remove_links>
    }
    local_intr_restore(intr_flag);
c010a8c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a8cb:	89 04 24             	mov    %eax,(%esp)
c010a8ce:	e8 13 e9 ff ff       	call   c01091e6 <__intr_restore>
    put_kstack(proc);
c010a8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8d6:	89 04 24             	mov    %eax,(%esp)
c010a8d9:	e8 f8 f0 ff ff       	call   c01099d6 <put_kstack>
    kfree(proc);
c010a8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8e1:	89 04 24             	mov    %eax,(%esp)
c010a8e4:	e8 88 a3 ff ff       	call   c0104c71 <kfree>
    return 0;
c010a8e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a8ee:	c9                   	leave  
c010a8ef:	c3                   	ret    

c010a8f0 <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010a8f0:	55                   	push   %ebp
c010a8f1:	89 e5                	mov    %esp,%ebp
c010a8f3:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010a8f6:	8b 45 08             	mov    0x8(%ebp),%eax
c010a8f9:	89 04 24             	mov    %eax,(%esp)
c010a8fc:	e8 b5 ef ff ff       	call   c01098b6 <find_proc>
c010a901:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a908:	74 41                	je     c010a94b <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010a90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a90d:	8b 40 44             	mov    0x44(%eax),%eax
c010a910:	83 e0 01             	and    $0x1,%eax
c010a913:	85 c0                	test   %eax,%eax
c010a915:	75 2d                	jne    c010a944 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010a917:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a91a:	8b 40 44             	mov    0x44(%eax),%eax
c010a91d:	83 c8 01             	or     $0x1,%eax
c010a920:	89 c2                	mov    %eax,%edx
c010a922:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a925:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010a928:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a92b:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a92e:	85 c0                	test   %eax,%eax
c010a930:	79 0b                	jns    c010a93d <do_kill+0x4d>
                wakeup_proc(proc);
c010a932:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a935:	89 04 24             	mov    %eax,(%esp)
c010a938:	e8 82 04 00 00       	call   c010adbf <wakeup_proc>
            }
            return 0;
c010a93d:	b8 00 00 00 00       	mov    $0x0,%eax
c010a942:	eb 0c                	jmp    c010a950 <do_kill+0x60>
        }
        return -E_KILLED;
c010a944:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010a949:	eb 05                	jmp    c010a950 <do_kill+0x60>
    }
    return -E_INVAL;
c010a94b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010a950:	c9                   	leave  
c010a951:	c3                   	ret    

c010a952 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010a952:	55                   	push   %ebp
c010a953:	89 e5                	mov    %esp,%ebp
c010a955:	57                   	push   %edi
c010a956:	56                   	push   %esi
c010a957:	53                   	push   %ebx
c010a958:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010a95b:	8b 45 08             	mov    0x8(%ebp),%eax
c010a95e:	89 04 24             	mov    %eax,(%esp)
c010a961:	e8 19 0f 00 00       	call   c010b87f <strlen>
c010a966:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010a969:	b8 04 00 00 00       	mov    $0x4,%eax
c010a96e:	8b 55 08             	mov    0x8(%ebp),%edx
c010a971:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010a974:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010a977:	8b 75 10             	mov    0x10(%ebp),%esi
c010a97a:	89 f7                	mov    %esi,%edi
c010a97c:	cd 80                	int    $0x80
c010a97e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010a981:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010a984:	83 c4 2c             	add    $0x2c,%esp
c010a987:	5b                   	pop    %ebx
c010a988:	5e                   	pop    %esi
c010a989:	5f                   	pop    %edi
c010a98a:	5d                   	pop    %ebp
c010a98b:	c3                   	ret    

c010a98c <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010a98c:	55                   	push   %ebp
c010a98d:	89 e5                	mov    %esp,%ebp
c010a98f:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
c010a992:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010a997:	8b 40 04             	mov    0x4(%eax),%eax
c010a99a:	c7 44 24 08 2e df 10 	movl   $0xc010df2e,0x8(%esp)
c010a9a1:	c0 
c010a9a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a9a6:	c7 04 24 38 df 10 c0 	movl   $0xc010df38,(%esp)
c010a9ad:	e8 a1 59 ff ff       	call   c0100353 <cprintf>
c010a9b2:	b8 e2 78 00 00       	mov    $0x78e2,%eax
c010a9b7:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a9bb:	c7 44 24 04 79 f8 15 	movl   $0xc015f879,0x4(%esp)
c010a9c2:	c0 
c010a9c3:	c7 04 24 2e df 10 c0 	movl   $0xc010df2e,(%esp)
c010a9ca:	e8 83 ff ff ff       	call   c010a952 <kernel_execve>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
c010a9cf:	c7 44 24 08 5f df 10 	movl   $0xc010df5f,0x8(%esp)
c010a9d6:	c0 
c010a9d7:	c7 44 24 04 41 03 00 	movl   $0x341,0x4(%esp)
c010a9de:	00 
c010a9df:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010a9e6:	e8 ea 63 ff ff       	call   c0100dd5 <__panic>

c010a9eb <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010a9eb:	55                   	push   %ebp
c010a9ec:	89 e5                	mov    %esp,%ebp
c010a9ee:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010a9f1:	e8 72 a7 ff ff       	call   c0105168 <nr_free_pages>
c010a9f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010a9f9:	e8 3b a1 ff ff       	call   c0104b39 <kallocated>
c010a9fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010aa01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010aa08:	00 
c010aa09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010aa10:	00 
c010aa11:	c7 04 24 8c a9 10 c0 	movl   $0xc010a98c,(%esp)
c010aa18:	e8 0b ef ff ff       	call   c0109928 <kernel_thread>
c010aa1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010aa20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010aa24:	7f 1c                	jg     c010aa42 <init_main+0x57>
        panic("create user_main failed.\n");
c010aa26:	c7 44 24 08 79 df 10 	movl   $0xc010df79,0x8(%esp)
c010aa2d:	c0 
c010aa2e:	c7 44 24 04 4c 03 00 	movl   $0x34c,0x4(%esp)
c010aa35:	00 
c010aa36:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010aa3d:	e8 93 63 ff ff       	call   c0100dd5 <__panic>
    }

    while (do_wait(0, NULL) == 0) {
c010aa42:	eb 05                	jmp    c010aa49 <init_main+0x5e>
        schedule();
c010aa44:	e8 fa 03 00 00       	call   c010ae43 <schedule>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010aa49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010aa50:	00 
c010aa51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010aa58:	e8 ff fc ff ff       	call   c010a75c <do_wait>
c010aa5d:	85 c0                	test   %eax,%eax
c010aa5f:	74 e3                	je     c010aa44 <init_main+0x59>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010aa61:	c7 04 24 94 df 10 c0 	movl   $0xc010df94,(%esp)
c010aa68:	e8 e6 58 ff ff       	call   c0100353 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010aa6d:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aa72:	8b 40 70             	mov    0x70(%eax),%eax
c010aa75:	85 c0                	test   %eax,%eax
c010aa77:	75 18                	jne    c010aa91 <init_main+0xa6>
c010aa79:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aa7e:	8b 40 74             	mov    0x74(%eax),%eax
c010aa81:	85 c0                	test   %eax,%eax
c010aa83:	75 0c                	jne    c010aa91 <init_main+0xa6>
c010aa85:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010aa8a:	8b 40 78             	mov    0x78(%eax),%eax
c010aa8d:	85 c0                	test   %eax,%eax
c010aa8f:	74 24                	je     c010aab5 <init_main+0xca>
c010aa91:	c7 44 24 0c b8 df 10 	movl   $0xc010dfb8,0xc(%esp)
c010aa98:	c0 
c010aa99:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010aaa0:	c0 
c010aaa1:	c7 44 24 04 54 03 00 	movl   $0x354,0x4(%esp)
c010aaa8:	00 
c010aaa9:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010aab0:	e8 20 63 ff ff       	call   c0100dd5 <__panic>
    assert(nr_process == 2);
c010aab5:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010aaba:	83 f8 02             	cmp    $0x2,%eax
c010aabd:	74 24                	je     c010aae3 <init_main+0xf8>
c010aabf:	c7 44 24 0c 03 e0 10 	movl   $0xc010e003,0xc(%esp)
c010aac6:	c0 
c010aac7:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010aace:	c0 
c010aacf:	c7 44 24 04 55 03 00 	movl   $0x355,0x4(%esp)
c010aad6:	00 
c010aad7:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010aade:	e8 f2 62 ff ff       	call   c0100dd5 <__panic>
c010aae3:	c7 45 e8 b0 f0 19 c0 	movl   $0xc019f0b0,-0x18(%ebp)
c010aaea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010aaed:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010aaf0:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010aaf6:	83 c2 58             	add    $0x58,%edx
c010aaf9:	39 d0                	cmp    %edx,%eax
c010aafb:	74 24                	je     c010ab21 <init_main+0x136>
c010aafd:	c7 44 24 0c 14 e0 10 	movl   $0xc010e014,0xc(%esp)
c010ab04:	c0 
c010ab05:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010ab0c:	c0 
c010ab0d:	c7 44 24 04 56 03 00 	movl   $0x356,0x4(%esp)
c010ab14:	00 
c010ab15:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010ab1c:	e8 b4 62 ff ff       	call   c0100dd5 <__panic>
c010ab21:	c7 45 e4 b0 f0 19 c0 	movl   $0xc019f0b0,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010ab28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ab2b:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010ab2d:	8b 15 84 cf 19 c0    	mov    0xc019cf84,%edx
c010ab33:	83 c2 58             	add    $0x58,%edx
c010ab36:	39 d0                	cmp    %edx,%eax
c010ab38:	74 24                	je     c010ab5e <init_main+0x173>
c010ab3a:	c7 44 24 0c 44 e0 10 	movl   $0xc010e044,0xc(%esp)
c010ab41:	c0 
c010ab42:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010ab49:	c0 
c010ab4a:	c7 44 24 04 57 03 00 	movl   $0x357,0x4(%esp)
c010ab51:	00 
c010ab52:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010ab59:	e8 77 62 ff ff       	call   c0100dd5 <__panic>

    cprintf("init check memory pass.\n");
c010ab5e:	c7 04 24 74 e0 10 c0 	movl   $0xc010e074,(%esp)
c010ab65:	e8 e9 57 ff ff       	call   c0100353 <cprintf>
    return 0;
c010ab6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ab6f:	c9                   	leave  
c010ab70:	c3                   	ret    

c010ab71 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010ab71:	55                   	push   %ebp
c010ab72:	89 e5                	mov    %esp,%ebp
c010ab74:	83 ec 28             	sub    $0x28,%esp
c010ab77:	c7 45 ec b0 f0 19 c0 	movl   $0xc019f0b0,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010ab7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ab81:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010ab84:	89 50 04             	mov    %edx,0x4(%eax)
c010ab87:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ab8a:	8b 50 04             	mov    0x4(%eax),%edx
c010ab8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ab90:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010ab92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010ab99:	eb 26                	jmp    c010abc1 <proc_init+0x50>
        list_init(hash_list + i);
c010ab9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab9e:	c1 e0 03             	shl    $0x3,%eax
c010aba1:	05 a0 cf 19 c0       	add    $0xc019cfa0,%eax
c010aba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010aba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abac:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010abaf:	89 50 04             	mov    %edx,0x4(%eax)
c010abb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abb5:	8b 50 04             	mov    0x4(%eax),%edx
c010abb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abbb:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010abbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010abc1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010abc8:	7e d1                	jle    c010ab9b <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010abca:	e8 1f e8 ff ff       	call   c01093ee <alloc_proc>
c010abcf:	a3 80 cf 19 c0       	mov    %eax,0xc019cf80
c010abd4:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010abd9:	85 c0                	test   %eax,%eax
c010abdb:	75 1c                	jne    c010abf9 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010abdd:	c7 44 24 08 8d e0 10 	movl   $0xc010e08d,0x8(%esp)
c010abe4:	c0 
c010abe5:	c7 44 24 04 69 03 00 	movl   $0x369,0x4(%esp)
c010abec:	00 
c010abed:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010abf4:	e8 dc 61 ff ff       	call   c0100dd5 <__panic>
    }

    idleproc->pid = 0;
c010abf9:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010abfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010ac05:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac0a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010ac10:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac15:	ba 00 80 12 c0       	mov    $0xc0128000,%edx
c010ac1a:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010ac1d:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac22:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010ac29:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac2e:	c7 44 24 04 a5 e0 10 	movl   $0xc010e0a5,0x4(%esp)
c010ac35:	c0 
c010ac36:	89 04 24             	mov    %eax,(%esp)
c010ac39:	e8 97 e8 ff ff       	call   c01094d5 <set_proc_name>
    nr_process ++;
c010ac3e:	a1 a0 ef 19 c0       	mov    0xc019efa0,%eax
c010ac43:	83 c0 01             	add    $0x1,%eax
c010ac46:	a3 a0 ef 19 c0       	mov    %eax,0xc019efa0

    current = idleproc;
c010ac4b:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ac50:	a3 88 cf 19 c0       	mov    %eax,0xc019cf88

    int pid = kernel_thread(init_main, NULL, 0);
c010ac55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010ac5c:	00 
c010ac5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ac64:	00 
c010ac65:	c7 04 24 eb a9 10 c0 	movl   $0xc010a9eb,(%esp)
c010ac6c:	e8 b7 ec ff ff       	call   c0109928 <kernel_thread>
c010ac71:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010ac74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010ac78:	7f 1c                	jg     c010ac96 <proc_init+0x125>
        panic("create init_main failed.\n");
c010ac7a:	c7 44 24 08 aa e0 10 	movl   $0xc010e0aa,0x8(%esp)
c010ac81:	c0 
c010ac82:	c7 44 24 04 77 03 00 	movl   $0x377,0x4(%esp)
c010ac89:	00 
c010ac8a:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010ac91:	e8 3f 61 ff ff       	call   c0100dd5 <__panic>
    }

    initproc = find_proc(pid);
c010ac96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac99:	89 04 24             	mov    %eax,(%esp)
c010ac9c:	e8 15 ec ff ff       	call   c01098b6 <find_proc>
c010aca1:	a3 84 cf 19 c0       	mov    %eax,0xc019cf84
    set_proc_name(initproc, "init");
c010aca6:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010acab:	c7 44 24 04 c4 e0 10 	movl   $0xc010e0c4,0x4(%esp)
c010acb2:	c0 
c010acb3:	89 04 24             	mov    %eax,(%esp)
c010acb6:	e8 1a e8 ff ff       	call   c01094d5 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010acbb:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010acc0:	85 c0                	test   %eax,%eax
c010acc2:	74 0c                	je     c010acd0 <proc_init+0x15f>
c010acc4:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010acc9:	8b 40 04             	mov    0x4(%eax),%eax
c010accc:	85 c0                	test   %eax,%eax
c010acce:	74 24                	je     c010acf4 <proc_init+0x183>
c010acd0:	c7 44 24 0c cc e0 10 	movl   $0xc010e0cc,0xc(%esp)
c010acd7:	c0 
c010acd8:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010acdf:	c0 
c010ace0:	c7 44 24 04 7d 03 00 	movl   $0x37d,0x4(%esp)
c010ace7:	00 
c010ace8:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010acef:	e8 e1 60 ff ff       	call   c0100dd5 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010acf4:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010acf9:	85 c0                	test   %eax,%eax
c010acfb:	74 0d                	je     c010ad0a <proc_init+0x199>
c010acfd:	a1 84 cf 19 c0       	mov    0xc019cf84,%eax
c010ad02:	8b 40 04             	mov    0x4(%eax),%eax
c010ad05:	83 f8 01             	cmp    $0x1,%eax
c010ad08:	74 24                	je     c010ad2e <proc_init+0x1bd>
c010ad0a:	c7 44 24 0c f4 e0 10 	movl   $0xc010e0f4,0xc(%esp)
c010ad11:	c0 
c010ad12:	c7 44 24 08 35 dd 10 	movl   $0xc010dd35,0x8(%esp)
c010ad19:	c0 
c010ad1a:	c7 44 24 04 7e 03 00 	movl   $0x37e,0x4(%esp)
c010ad21:	00 
c010ad22:	c7 04 24 08 dd 10 c0 	movl   $0xc010dd08,(%esp)
c010ad29:	e8 a7 60 ff ff       	call   c0100dd5 <__panic>
}
c010ad2e:	c9                   	leave  
c010ad2f:	c3                   	ret    

c010ad30 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010ad30:	55                   	push   %ebp
c010ad31:	89 e5                	mov    %esp,%ebp
c010ad33:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010ad36:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010ad3b:	8b 40 10             	mov    0x10(%eax),%eax
c010ad3e:	85 c0                	test   %eax,%eax
c010ad40:	74 07                	je     c010ad49 <cpu_idle+0x19>
            schedule();
c010ad42:	e8 fc 00 00 00       	call   c010ae43 <schedule>
        }
    }
c010ad47:	eb ed                	jmp    c010ad36 <cpu_idle+0x6>
c010ad49:	eb eb                	jmp    c010ad36 <cpu_idle+0x6>

c010ad4b <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010ad4b:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010ad4f:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010ad51:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010ad54:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010ad57:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010ad5a:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010ad5d:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010ad60:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010ad63:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010ad66:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010ad6a:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010ad6d:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010ad70:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010ad73:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010ad76:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010ad79:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010ad7c:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010ad7f:	ff 30                	pushl  (%eax)

    ret
c010ad81:	c3                   	ret    

c010ad82 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010ad82:	55                   	push   %ebp
c010ad83:	89 e5                	mov    %esp,%ebp
c010ad85:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010ad88:	9c                   	pushf  
c010ad89:	58                   	pop    %eax
c010ad8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010ad8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010ad90:	25 00 02 00 00       	and    $0x200,%eax
c010ad95:	85 c0                	test   %eax,%eax
c010ad97:	74 0c                	je     c010ada5 <__intr_save+0x23>
        intr_disable();
c010ad99:	e8 8f 72 ff ff       	call   c010202d <intr_disable>
        return 1;
c010ad9e:	b8 01 00 00 00       	mov    $0x1,%eax
c010ada3:	eb 05                	jmp    c010adaa <__intr_save+0x28>
    }
    return 0;
c010ada5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010adaa:	c9                   	leave  
c010adab:	c3                   	ret    

c010adac <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010adac:	55                   	push   %ebp
c010adad:	89 e5                	mov    %esp,%ebp
c010adaf:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010adb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010adb6:	74 05                	je     c010adbd <__intr_restore+0x11>
        intr_enable();
c010adb8:	e8 6a 72 ff ff       	call   c0102027 <intr_enable>
    }
}
c010adbd:	c9                   	leave  
c010adbe:	c3                   	ret    

c010adbf <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010adbf:	55                   	push   %ebp
c010adc0:	89 e5                	mov    %esp,%ebp
c010adc2:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010adc5:	8b 45 08             	mov    0x8(%ebp),%eax
c010adc8:	8b 00                	mov    (%eax),%eax
c010adca:	83 f8 03             	cmp    $0x3,%eax
c010adcd:	75 24                	jne    c010adf3 <wakeup_proc+0x34>
c010adcf:	c7 44 24 0c 1b e1 10 	movl   $0xc010e11b,0xc(%esp)
c010add6:	c0 
c010add7:	c7 44 24 08 36 e1 10 	movl   $0xc010e136,0x8(%esp)
c010adde:	c0 
c010addf:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c010ade6:	00 
c010ade7:	c7 04 24 4b e1 10 c0 	movl   $0xc010e14b,(%esp)
c010adee:	e8 e2 5f ff ff       	call   c0100dd5 <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010adf3:	e8 8a ff ff ff       	call   c010ad82 <__intr_save>
c010adf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010adfb:	8b 45 08             	mov    0x8(%ebp),%eax
c010adfe:	8b 00                	mov    (%eax),%eax
c010ae00:	83 f8 02             	cmp    $0x2,%eax
c010ae03:	74 15                	je     c010ae1a <wakeup_proc+0x5b>
            proc->state = PROC_RUNNABLE;
c010ae05:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae08:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010ae0e:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae11:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
c010ae18:	eb 1c                	jmp    c010ae36 <wakeup_proc+0x77>
        }
        else {
            warn("wakeup runnable process.\n");
c010ae1a:	c7 44 24 08 61 e1 10 	movl   $0xc010e161,0x8(%esp)
c010ae21:	c0 
c010ae22:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010ae29:	00 
c010ae2a:	c7 04 24 4b e1 10 c0 	movl   $0xc010e14b,(%esp)
c010ae31:	e8 0b 60 ff ff       	call   c0100e41 <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010ae36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae39:	89 04 24             	mov    %eax,(%esp)
c010ae3c:	e8 6b ff ff ff       	call   c010adac <__intr_restore>
}
c010ae41:	c9                   	leave  
c010ae42:	c3                   	ret    

c010ae43 <schedule>:

void
schedule(void) {
c010ae43:	55                   	push   %ebp
c010ae44:	89 e5                	mov    %esp,%ebp
c010ae46:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010ae49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010ae50:	e8 2d ff ff ff       	call   c010ad82 <__intr_save>
c010ae55:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010ae58:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010ae5d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010ae64:	8b 15 88 cf 19 c0    	mov    0xc019cf88,%edx
c010ae6a:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010ae6f:	39 c2                	cmp    %eax,%edx
c010ae71:	74 0a                	je     c010ae7d <schedule+0x3a>
c010ae73:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010ae78:	83 c0 58             	add    $0x58,%eax
c010ae7b:	eb 05                	jmp    c010ae82 <schedule+0x3f>
c010ae7d:	b8 b0 f0 19 c0       	mov    $0xc019f0b0,%eax
c010ae82:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010ae85:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ae88:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ae8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010ae91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ae94:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010ae97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ae9a:	81 7d f4 b0 f0 19 c0 	cmpl   $0xc019f0b0,-0xc(%ebp)
c010aea1:	74 15                	je     c010aeb8 <schedule+0x75>
                next = le2proc(le, list_link);
c010aea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aea6:	83 e8 58             	sub    $0x58,%eax
c010aea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010aeac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aeaf:	8b 00                	mov    (%eax),%eax
c010aeb1:	83 f8 02             	cmp    $0x2,%eax
c010aeb4:	75 02                	jne    c010aeb8 <schedule+0x75>
                    break;
c010aeb6:	eb 08                	jmp    c010aec0 <schedule+0x7d>
                }
            }
        } while (le != last);
c010aeb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aebb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010aebe:	75 cb                	jne    c010ae8b <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010aec0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aec4:	74 0a                	je     c010aed0 <schedule+0x8d>
c010aec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aec9:	8b 00                	mov    (%eax),%eax
c010aecb:	83 f8 02             	cmp    $0x2,%eax
c010aece:	74 08                	je     c010aed8 <schedule+0x95>
            next = idleproc;
c010aed0:	a1 80 cf 19 c0       	mov    0xc019cf80,%eax
c010aed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010aed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aedb:	8b 40 08             	mov    0x8(%eax),%eax
c010aede:	8d 50 01             	lea    0x1(%eax),%edx
c010aee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aee4:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010aee7:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010aeec:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010aeef:	74 0b                	je     c010aefc <schedule+0xb9>
            proc_run(next);
c010aef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aef4:	89 04 24             	mov    %eax,(%esp)
c010aef7:	e8 7e e8 ff ff       	call   c010977a <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010aefc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010aeff:	89 04 24             	mov    %eax,(%esp)
c010af02:	e8 a5 fe ff ff       	call   c010adac <__intr_restore>
}
c010af07:	c9                   	leave  
c010af08:	c3                   	ret    

c010af09 <sys_exit>:
#include <stdio.h>
#include <pmm.h>
#include <assert.h>

static int
sys_exit(uint32_t arg[]) {
c010af09:	55                   	push   %ebp
c010af0a:	89 e5                	mov    %esp,%ebp
c010af0c:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010af0f:	8b 45 08             	mov    0x8(%ebp),%eax
c010af12:	8b 00                	mov    (%eax),%eax
c010af14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010af17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af1a:	89 04 24             	mov    %eax,(%esp)
c010af1d:	e8 bc ee ff ff       	call   c0109dde <do_exit>
}
c010af22:	c9                   	leave  
c010af23:	c3                   	ret    

c010af24 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010af24:	55                   	push   %ebp
c010af25:	89 e5                	mov    %esp,%ebp
c010af27:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010af2a:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010af2f:	8b 40 3c             	mov    0x3c(%eax),%eax
c010af32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010af35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af38:	8b 40 44             	mov    0x44(%eax),%eax
c010af3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010af3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af41:	89 44 24 08          	mov    %eax,0x8(%esp)
c010af45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af48:	89 44 24 04          	mov    %eax,0x4(%esp)
c010af4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010af53:	e8 65 ed ff ff       	call   c0109cbd <do_fork>
}
c010af58:	c9                   	leave  
c010af59:	c3                   	ret    

c010af5a <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010af5a:	55                   	push   %ebp
c010af5b:	89 e5                	mov    %esp,%ebp
c010af5d:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010af60:	8b 45 08             	mov    0x8(%ebp),%eax
c010af63:	8b 00                	mov    (%eax),%eax
c010af65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010af68:	8b 45 08             	mov    0x8(%ebp),%eax
c010af6b:	83 c0 04             	add    $0x4,%eax
c010af6e:	8b 00                	mov    (%eax),%eax
c010af70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010af73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010af76:	89 44 24 04          	mov    %eax,0x4(%esp)
c010af7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af7d:	89 04 24             	mov    %eax,(%esp)
c010af80:	e8 d7 f7 ff ff       	call   c010a75c <do_wait>
}
c010af85:	c9                   	leave  
c010af86:	c3                   	ret    

c010af87 <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010af87:	55                   	push   %ebp
c010af88:	89 e5                	mov    %esp,%ebp
c010af8a:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010af8d:	8b 45 08             	mov    0x8(%ebp),%eax
c010af90:	8b 00                	mov    (%eax),%eax
c010af92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010af95:	8b 45 08             	mov    0x8(%ebp),%eax
c010af98:	8b 40 04             	mov    0x4(%eax),%eax
c010af9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010af9e:	8b 45 08             	mov    0x8(%ebp),%eax
c010afa1:	83 c0 08             	add    $0x8,%eax
c010afa4:	8b 00                	mov    (%eax),%eax
c010afa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010afa9:	8b 45 08             	mov    0x8(%ebp),%eax
c010afac:	8b 40 0c             	mov    0xc(%eax),%eax
c010afaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010afb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010afb5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010afb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010afbc:	89 44 24 08          	mov    %eax,0x8(%esp)
c010afc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010afc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010afc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010afca:	89 04 24             	mov    %eax,(%esp)
c010afcd:	e8 3e f6 ff ff       	call   c010a610 <do_execve>
}
c010afd2:	c9                   	leave  
c010afd3:	c3                   	ret    

c010afd4 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010afd4:	55                   	push   %ebp
c010afd5:	89 e5                	mov    %esp,%ebp
c010afd7:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010afda:	e8 67 f7 ff ff       	call   c010a746 <do_yield>
}
c010afdf:	c9                   	leave  
c010afe0:	c3                   	ret    

c010afe1 <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010afe1:	55                   	push   %ebp
c010afe2:	89 e5                	mov    %esp,%ebp
c010afe4:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010afe7:	8b 45 08             	mov    0x8(%ebp),%eax
c010afea:	8b 00                	mov    (%eax),%eax
c010afec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010afef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aff2:	89 04 24             	mov    %eax,(%esp)
c010aff5:	e8 f6 f8 ff ff       	call   c010a8f0 <do_kill>
}
c010affa:	c9                   	leave  
c010affb:	c3                   	ret    

c010affc <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010affc:	55                   	push   %ebp
c010affd:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010afff:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b004:	8b 40 04             	mov    0x4(%eax),%eax
}
c010b007:	5d                   	pop    %ebp
c010b008:	c3                   	ret    

c010b009 <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010b009:	55                   	push   %ebp
c010b00a:	89 e5                	mov    %esp,%ebp
c010b00c:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010b00f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b012:	8b 00                	mov    (%eax),%eax
c010b014:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010b017:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b01a:	89 04 24             	mov    %eax,(%esp)
c010b01d:	e8 57 53 ff ff       	call   c0100379 <cputchar>
    return 0;
c010b022:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b027:	c9                   	leave  
c010b028:	c3                   	ret    

c010b029 <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010b029:	55                   	push   %ebp
c010b02a:	89 e5                	mov    %esp,%ebp
c010b02c:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010b02f:	e8 8c bb ff ff       	call   c0106bc0 <print_pgdir>
    return 0;
c010b034:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b039:	c9                   	leave  
c010b03a:	c3                   	ret    

c010b03b <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010b03b:	55                   	push   %ebp
c010b03c:	89 e5                	mov    %esp,%ebp
c010b03e:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010b041:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b046:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b049:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010b04c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b04f:	8b 40 1c             	mov    0x1c(%eax),%eax
c010b052:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010b055:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b059:	78 5e                	js     c010b0b9 <syscall+0x7e>
c010b05b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b05e:	83 f8 1f             	cmp    $0x1f,%eax
c010b061:	77 56                	ja     c010b0b9 <syscall+0x7e>
        if (syscalls[num] != NULL) {
c010b063:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b066:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b06d:	85 c0                	test   %eax,%eax
c010b06f:	74 48                	je     c010b0b9 <syscall+0x7e>
            arg[0] = tf->tf_regs.reg_edx;
c010b071:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b074:	8b 40 14             	mov    0x14(%eax),%eax
c010b077:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010b07a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b07d:	8b 40 18             	mov    0x18(%eax),%eax
c010b080:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010b083:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b086:	8b 40 10             	mov    0x10(%eax),%eax
c010b089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010b08c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b08f:	8b 00                	mov    (%eax),%eax
c010b091:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010b094:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b097:	8b 40 04             	mov    0x4(%eax),%eax
c010b09a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010b09d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0a0:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b0a7:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010b0aa:	89 14 24             	mov    %edx,(%esp)
c010b0ad:	ff d0                	call   *%eax
c010b0af:	89 c2                	mov    %eax,%edx
c010b0b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0b4:	89 50 1c             	mov    %edx,0x1c(%eax)
            return ;
c010b0b7:	eb 46                	jmp    c010b0ff <syscall+0xc4>
        }
    }
    print_trapframe(tf);
c010b0b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0bc:	89 04 24             	mov    %eax,(%esp)
c010b0bf:	e8 27 73 ff ff       	call   c01023eb <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010b0c4:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b0c9:	8d 50 48             	lea    0x48(%eax),%edx
c010b0cc:	a1 88 cf 19 c0       	mov    0xc019cf88,%eax
c010b0d1:	8b 40 04             	mov    0x4(%eax),%eax
c010b0d4:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b0d8:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b0dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b0e3:	c7 44 24 08 7c e1 10 	movl   $0xc010e17c,0x8(%esp)
c010b0ea:	c0 
c010b0eb:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010b0f2:	00 
c010b0f3:	c7 04 24 a8 e1 10 c0 	movl   $0xc010e1a8,(%esp)
c010b0fa:	e8 d6 5c ff ff       	call   c0100dd5 <__panic>
            num, current->pid, current->name);
}
c010b0ff:	c9                   	leave  
c010b100:	c3                   	ret    

c010b101 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010b101:	55                   	push   %ebp
c010b102:	89 e5                	mov    %esp,%ebp
c010b104:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010b107:	8b 45 08             	mov    0x8(%ebp),%eax
c010b10a:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010b110:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c010b113:	b8 20 00 00 00       	mov    $0x20,%eax
c010b118:	2b 45 0c             	sub    0xc(%ebp),%eax
c010b11b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010b11e:	89 c1                	mov    %eax,%ecx
c010b120:	d3 ea                	shr    %cl,%edx
c010b122:	89 d0                	mov    %edx,%eax
}
c010b124:	c9                   	leave  
c010b125:	c3                   	ret    

c010b126 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010b126:	55                   	push   %ebp
c010b127:	89 e5                	mov    %esp,%ebp
c010b129:	83 ec 58             	sub    $0x58,%esp
c010b12c:	8b 45 10             	mov    0x10(%ebp),%eax
c010b12f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010b132:	8b 45 14             	mov    0x14(%ebp),%eax
c010b135:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010b138:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010b13b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010b13e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b141:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010b144:	8b 45 18             	mov    0x18(%ebp),%eax
c010b147:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b14a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b14d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b150:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b153:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010b156:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b159:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b15c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b160:	74 1c                	je     c010b17e <printnum+0x58>
c010b162:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b165:	ba 00 00 00 00       	mov    $0x0,%edx
c010b16a:	f7 75 e4             	divl   -0x1c(%ebp)
c010b16d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010b170:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b173:	ba 00 00 00 00       	mov    $0x0,%edx
c010b178:	f7 75 e4             	divl   -0x1c(%ebp)
c010b17b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b17e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b181:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b184:	f7 75 e4             	divl   -0x1c(%ebp)
c010b187:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b18a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010b18d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b190:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b193:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b196:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b199:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b19c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010b19f:	8b 45 18             	mov    0x18(%ebp),%eax
c010b1a2:	ba 00 00 00 00       	mov    $0x0,%edx
c010b1a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b1aa:	77 56                	ja     c010b202 <printnum+0xdc>
c010b1ac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b1af:	72 05                	jb     c010b1b6 <printnum+0x90>
c010b1b1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010b1b4:	77 4c                	ja     c010b202 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010b1b6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010b1b9:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b1bc:	8b 45 20             	mov    0x20(%ebp),%eax
c010b1bf:	89 44 24 18          	mov    %eax,0x18(%esp)
c010b1c3:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b1c7:	8b 45 18             	mov    0x18(%ebp),%eax
c010b1ca:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b1ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b1d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b1d4:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b1d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b1dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b1df:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b1e3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1e6:	89 04 24             	mov    %eax,(%esp)
c010b1e9:	e8 38 ff ff ff       	call   c010b126 <printnum>
c010b1ee:	eb 1c                	jmp    c010b20c <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010b1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b1f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b1f7:	8b 45 20             	mov    0x20(%ebp),%eax
c010b1fa:	89 04 24             	mov    %eax,(%esp)
c010b1fd:	8b 45 08             	mov    0x8(%ebp),%eax
c010b200:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010b202:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010b206:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010b20a:	7f e4                	jg     c010b1f0 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010b20c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b20f:	05 c4 e2 10 c0       	add    $0xc010e2c4,%eax
c010b214:	0f b6 00             	movzbl (%eax),%eax
c010b217:	0f be c0             	movsbl %al,%eax
c010b21a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b21d:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b221:	89 04 24             	mov    %eax,(%esp)
c010b224:	8b 45 08             	mov    0x8(%ebp),%eax
c010b227:	ff d0                	call   *%eax
}
c010b229:	c9                   	leave  
c010b22a:	c3                   	ret    

c010b22b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010b22b:	55                   	push   %ebp
c010b22c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b22e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b232:	7e 14                	jle    c010b248 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010b234:	8b 45 08             	mov    0x8(%ebp),%eax
c010b237:	8b 00                	mov    (%eax),%eax
c010b239:	8d 48 08             	lea    0x8(%eax),%ecx
c010b23c:	8b 55 08             	mov    0x8(%ebp),%edx
c010b23f:	89 0a                	mov    %ecx,(%edx)
c010b241:	8b 50 04             	mov    0x4(%eax),%edx
c010b244:	8b 00                	mov    (%eax),%eax
c010b246:	eb 30                	jmp    c010b278 <getuint+0x4d>
    }
    else if (lflag) {
c010b248:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b24c:	74 16                	je     c010b264 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010b24e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b251:	8b 00                	mov    (%eax),%eax
c010b253:	8d 48 04             	lea    0x4(%eax),%ecx
c010b256:	8b 55 08             	mov    0x8(%ebp),%edx
c010b259:	89 0a                	mov    %ecx,(%edx)
c010b25b:	8b 00                	mov    (%eax),%eax
c010b25d:	ba 00 00 00 00       	mov    $0x0,%edx
c010b262:	eb 14                	jmp    c010b278 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010b264:	8b 45 08             	mov    0x8(%ebp),%eax
c010b267:	8b 00                	mov    (%eax),%eax
c010b269:	8d 48 04             	lea    0x4(%eax),%ecx
c010b26c:	8b 55 08             	mov    0x8(%ebp),%edx
c010b26f:	89 0a                	mov    %ecx,(%edx)
c010b271:	8b 00                	mov    (%eax),%eax
c010b273:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010b278:	5d                   	pop    %ebp
c010b279:	c3                   	ret    

c010b27a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010b27a:	55                   	push   %ebp
c010b27b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b27d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b281:	7e 14                	jle    c010b297 <getint+0x1d>
        return va_arg(*ap, long long);
c010b283:	8b 45 08             	mov    0x8(%ebp),%eax
c010b286:	8b 00                	mov    (%eax),%eax
c010b288:	8d 48 08             	lea    0x8(%eax),%ecx
c010b28b:	8b 55 08             	mov    0x8(%ebp),%edx
c010b28e:	89 0a                	mov    %ecx,(%edx)
c010b290:	8b 50 04             	mov    0x4(%eax),%edx
c010b293:	8b 00                	mov    (%eax),%eax
c010b295:	eb 28                	jmp    c010b2bf <getint+0x45>
    }
    else if (lflag) {
c010b297:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b29b:	74 12                	je     c010b2af <getint+0x35>
        return va_arg(*ap, long);
c010b29d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2a0:	8b 00                	mov    (%eax),%eax
c010b2a2:	8d 48 04             	lea    0x4(%eax),%ecx
c010b2a5:	8b 55 08             	mov    0x8(%ebp),%edx
c010b2a8:	89 0a                	mov    %ecx,(%edx)
c010b2aa:	8b 00                	mov    (%eax),%eax
c010b2ac:	99                   	cltd   
c010b2ad:	eb 10                	jmp    c010b2bf <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010b2af:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2b2:	8b 00                	mov    (%eax),%eax
c010b2b4:	8d 48 04             	lea    0x4(%eax),%ecx
c010b2b7:	8b 55 08             	mov    0x8(%ebp),%edx
c010b2ba:	89 0a                	mov    %ecx,(%edx)
c010b2bc:	8b 00                	mov    (%eax),%eax
c010b2be:	99                   	cltd   
    }
}
c010b2bf:	5d                   	pop    %ebp
c010b2c0:	c3                   	ret    

c010b2c1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b2c1:	55                   	push   %ebp
c010b2c2:	89 e5                	mov    %esp,%ebp
c010b2c4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b2c7:	8d 45 14             	lea    0x14(%ebp),%eax
c010b2ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010b2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b2d4:	8b 45 10             	mov    0x10(%ebp),%eax
c010b2d7:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b2db:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b2de:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b2e2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2e5:	89 04 24             	mov    %eax,(%esp)
c010b2e8:	e8 02 00 00 00       	call   c010b2ef <vprintfmt>
    va_end(ap);
}
c010b2ed:	c9                   	leave  
c010b2ee:	c3                   	ret    

c010b2ef <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b2ef:	55                   	push   %ebp
c010b2f0:	89 e5                	mov    %esp,%ebp
c010b2f2:	56                   	push   %esi
c010b2f3:	53                   	push   %ebx
c010b2f4:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b2f7:	eb 18                	jmp    c010b311 <vprintfmt+0x22>
            if (ch == '\0') {
c010b2f9:	85 db                	test   %ebx,%ebx
c010b2fb:	75 05                	jne    c010b302 <vprintfmt+0x13>
                return;
c010b2fd:	e9 d1 03 00 00       	jmp    c010b6d3 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010b302:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b305:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b309:	89 1c 24             	mov    %ebx,(%esp)
c010b30c:	8b 45 08             	mov    0x8(%ebp),%eax
c010b30f:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b311:	8b 45 10             	mov    0x10(%ebp),%eax
c010b314:	8d 50 01             	lea    0x1(%eax),%edx
c010b317:	89 55 10             	mov    %edx,0x10(%ebp)
c010b31a:	0f b6 00             	movzbl (%eax),%eax
c010b31d:	0f b6 d8             	movzbl %al,%ebx
c010b320:	83 fb 25             	cmp    $0x25,%ebx
c010b323:	75 d4                	jne    c010b2f9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b325:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b329:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b333:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b336:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b33d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b340:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b343:	8b 45 10             	mov    0x10(%ebp),%eax
c010b346:	8d 50 01             	lea    0x1(%eax),%edx
c010b349:	89 55 10             	mov    %edx,0x10(%ebp)
c010b34c:	0f b6 00             	movzbl (%eax),%eax
c010b34f:	0f b6 d8             	movzbl %al,%ebx
c010b352:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010b355:	83 f8 55             	cmp    $0x55,%eax
c010b358:	0f 87 44 03 00 00    	ja     c010b6a2 <vprintfmt+0x3b3>
c010b35e:	8b 04 85 e8 e2 10 c0 	mov    -0x3fef1d18(,%eax,4),%eax
c010b365:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b367:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b36b:	eb d6                	jmp    c010b343 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b36d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b371:	eb d0                	jmp    c010b343 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b373:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b37a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b37d:	89 d0                	mov    %edx,%eax
c010b37f:	c1 e0 02             	shl    $0x2,%eax
c010b382:	01 d0                	add    %edx,%eax
c010b384:	01 c0                	add    %eax,%eax
c010b386:	01 d8                	add    %ebx,%eax
c010b388:	83 e8 30             	sub    $0x30,%eax
c010b38b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b38e:	8b 45 10             	mov    0x10(%ebp),%eax
c010b391:	0f b6 00             	movzbl (%eax),%eax
c010b394:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b397:	83 fb 2f             	cmp    $0x2f,%ebx
c010b39a:	7e 0b                	jle    c010b3a7 <vprintfmt+0xb8>
c010b39c:	83 fb 39             	cmp    $0x39,%ebx
c010b39f:	7f 06                	jg     c010b3a7 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b3a1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b3a5:	eb d3                	jmp    c010b37a <vprintfmt+0x8b>
            goto process_precision;
c010b3a7:	eb 33                	jmp    c010b3dc <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010b3a9:	8b 45 14             	mov    0x14(%ebp),%eax
c010b3ac:	8d 50 04             	lea    0x4(%eax),%edx
c010b3af:	89 55 14             	mov    %edx,0x14(%ebp)
c010b3b2:	8b 00                	mov    (%eax),%eax
c010b3b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b3b7:	eb 23                	jmp    c010b3dc <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010b3b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b3bd:	79 0c                	jns    c010b3cb <vprintfmt+0xdc>
                width = 0;
c010b3bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b3c6:	e9 78 ff ff ff       	jmp    c010b343 <vprintfmt+0x54>
c010b3cb:	e9 73 ff ff ff       	jmp    c010b343 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010b3d0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b3d7:	e9 67 ff ff ff       	jmp    c010b343 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010b3dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b3e0:	79 12                	jns    c010b3f4 <vprintfmt+0x105>
                width = precision, precision = -1;
c010b3e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b3e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b3e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b3ef:	e9 4f ff ff ff       	jmp    c010b343 <vprintfmt+0x54>
c010b3f4:	e9 4a ff ff ff       	jmp    c010b343 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b3f9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b3fd:	e9 41 ff ff ff       	jmp    c010b343 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b402:	8b 45 14             	mov    0x14(%ebp),%eax
c010b405:	8d 50 04             	lea    0x4(%eax),%edx
c010b408:	89 55 14             	mov    %edx,0x14(%ebp)
c010b40b:	8b 00                	mov    (%eax),%eax
c010b40d:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b410:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b414:	89 04 24             	mov    %eax,(%esp)
c010b417:	8b 45 08             	mov    0x8(%ebp),%eax
c010b41a:	ff d0                	call   *%eax
            break;
c010b41c:	e9 ac 02 00 00       	jmp    c010b6cd <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b421:	8b 45 14             	mov    0x14(%ebp),%eax
c010b424:	8d 50 04             	lea    0x4(%eax),%edx
c010b427:	89 55 14             	mov    %edx,0x14(%ebp)
c010b42a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b42c:	85 db                	test   %ebx,%ebx
c010b42e:	79 02                	jns    c010b432 <vprintfmt+0x143>
                err = -err;
c010b430:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b432:	83 fb 18             	cmp    $0x18,%ebx
c010b435:	7f 0b                	jg     c010b442 <vprintfmt+0x153>
c010b437:	8b 34 9d 60 e2 10 c0 	mov    -0x3fef1da0(,%ebx,4),%esi
c010b43e:	85 f6                	test   %esi,%esi
c010b440:	75 23                	jne    c010b465 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010b442:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b446:	c7 44 24 08 d5 e2 10 	movl   $0xc010e2d5,0x8(%esp)
c010b44d:	c0 
c010b44e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b451:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b455:	8b 45 08             	mov    0x8(%ebp),%eax
c010b458:	89 04 24             	mov    %eax,(%esp)
c010b45b:	e8 61 fe ff ff       	call   c010b2c1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b460:	e9 68 02 00 00       	jmp    c010b6cd <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b465:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b469:	c7 44 24 08 de e2 10 	movl   $0xc010e2de,0x8(%esp)
c010b470:	c0 
c010b471:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b474:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b478:	8b 45 08             	mov    0x8(%ebp),%eax
c010b47b:	89 04 24             	mov    %eax,(%esp)
c010b47e:	e8 3e fe ff ff       	call   c010b2c1 <printfmt>
            }
            break;
c010b483:	e9 45 02 00 00       	jmp    c010b6cd <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b488:	8b 45 14             	mov    0x14(%ebp),%eax
c010b48b:	8d 50 04             	lea    0x4(%eax),%edx
c010b48e:	89 55 14             	mov    %edx,0x14(%ebp)
c010b491:	8b 30                	mov    (%eax),%esi
c010b493:	85 f6                	test   %esi,%esi
c010b495:	75 05                	jne    c010b49c <vprintfmt+0x1ad>
                p = "(null)";
c010b497:	be e1 e2 10 c0       	mov    $0xc010e2e1,%esi
            }
            if (width > 0 && padc != '-') {
c010b49c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b4a0:	7e 3e                	jle    c010b4e0 <vprintfmt+0x1f1>
c010b4a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b4a6:	74 38                	je     c010b4e0 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b4a8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b4ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b4ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4b2:	89 34 24             	mov    %esi,(%esp)
c010b4b5:	e8 ed 03 00 00       	call   c010b8a7 <strnlen>
c010b4ba:	29 c3                	sub    %eax,%ebx
c010b4bc:	89 d8                	mov    %ebx,%eax
c010b4be:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b4c1:	eb 17                	jmp    c010b4da <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010b4c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b4c7:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b4ca:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b4ce:	89 04 24             	mov    %eax,(%esp)
c010b4d1:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4d4:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b4d6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b4da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b4de:	7f e3                	jg     c010b4c3 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b4e0:	eb 38                	jmp    c010b51a <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b4e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b4e6:	74 1f                	je     c010b507 <vprintfmt+0x218>
c010b4e8:	83 fb 1f             	cmp    $0x1f,%ebx
c010b4eb:	7e 05                	jle    c010b4f2 <vprintfmt+0x203>
c010b4ed:	83 fb 7e             	cmp    $0x7e,%ebx
c010b4f0:	7e 15                	jle    c010b507 <vprintfmt+0x218>
                    putch('?', putdat);
c010b4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b4f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4f9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b500:	8b 45 08             	mov    0x8(%ebp),%eax
c010b503:	ff d0                	call   *%eax
c010b505:	eb 0f                	jmp    c010b516 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010b507:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b50a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b50e:	89 1c 24             	mov    %ebx,(%esp)
c010b511:	8b 45 08             	mov    0x8(%ebp),%eax
c010b514:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b516:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b51a:	89 f0                	mov    %esi,%eax
c010b51c:	8d 70 01             	lea    0x1(%eax),%esi
c010b51f:	0f b6 00             	movzbl (%eax),%eax
c010b522:	0f be d8             	movsbl %al,%ebx
c010b525:	85 db                	test   %ebx,%ebx
c010b527:	74 10                	je     c010b539 <vprintfmt+0x24a>
c010b529:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b52d:	78 b3                	js     c010b4e2 <vprintfmt+0x1f3>
c010b52f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b533:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b537:	79 a9                	jns    c010b4e2 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b539:	eb 17                	jmp    c010b552 <vprintfmt+0x263>
                putch(' ', putdat);
c010b53b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b53e:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b542:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b549:	8b 45 08             	mov    0x8(%ebp),%eax
c010b54c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b54e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b552:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b556:	7f e3                	jg     c010b53b <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010b558:	e9 70 01 00 00       	jmp    c010b6cd <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b55d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b560:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b564:	8d 45 14             	lea    0x14(%ebp),%eax
c010b567:	89 04 24             	mov    %eax,(%esp)
c010b56a:	e8 0b fd ff ff       	call   c010b27a <getint>
c010b56f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b572:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b575:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b578:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b57b:	85 d2                	test   %edx,%edx
c010b57d:	79 26                	jns    c010b5a5 <vprintfmt+0x2b6>
                putch('-', putdat);
c010b57f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b582:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b586:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b58d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b590:	ff d0                	call   *%eax
                num = -(long long)num;
c010b592:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b595:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b598:	f7 d8                	neg    %eax
c010b59a:	83 d2 00             	adc    $0x0,%edx
c010b59d:	f7 da                	neg    %edx
c010b59f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b5a5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b5ac:	e9 a8 00 00 00       	jmp    c010b659 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b5b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b5b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5b8:	8d 45 14             	lea    0x14(%ebp),%eax
c010b5bb:	89 04 24             	mov    %eax,(%esp)
c010b5be:	e8 68 fc ff ff       	call   c010b22b <getuint>
c010b5c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b5c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b5d0:	e9 84 00 00 00       	jmp    c010b659 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b5d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b5d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5dc:	8d 45 14             	lea    0x14(%ebp),%eax
c010b5df:	89 04 24             	mov    %eax,(%esp)
c010b5e2:	e8 44 fc ff ff       	call   c010b22b <getuint>
c010b5e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b5ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b5ed:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b5f4:	eb 63                	jmp    c010b659 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010b5f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5fd:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b604:	8b 45 08             	mov    0x8(%ebp),%eax
c010b607:	ff d0                	call   *%eax
            putch('x', putdat);
c010b609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b60c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b610:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b617:	8b 45 08             	mov    0x8(%ebp),%eax
c010b61a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b61c:	8b 45 14             	mov    0x14(%ebp),%eax
c010b61f:	8d 50 04             	lea    0x4(%eax),%edx
c010b622:	89 55 14             	mov    %edx,0x14(%ebp)
c010b625:	8b 00                	mov    (%eax),%eax
c010b627:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b62a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b631:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b638:	eb 1f                	jmp    c010b659 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b63a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b63d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b641:	8d 45 14             	lea    0x14(%ebp),%eax
c010b644:	89 04 24             	mov    %eax,(%esp)
c010b647:	e8 df fb ff ff       	call   c010b22b <getuint>
c010b64c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b64f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b652:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b659:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b65d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b660:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b664:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b667:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b66b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b66f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b672:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b675:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b679:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b67d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b680:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b684:	8b 45 08             	mov    0x8(%ebp),%eax
c010b687:	89 04 24             	mov    %eax,(%esp)
c010b68a:	e8 97 fa ff ff       	call   c010b126 <printnum>
            break;
c010b68f:	eb 3c                	jmp    c010b6cd <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b691:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b694:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b698:	89 1c 24             	mov    %ebx,(%esp)
c010b69b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b69e:	ff d0                	call   *%eax
            break;
c010b6a0:	eb 2b                	jmp    c010b6cd <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b6a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6a9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b6b0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6b3:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b6b5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b6b9:	eb 04                	jmp    c010b6bf <vprintfmt+0x3d0>
c010b6bb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b6bf:	8b 45 10             	mov    0x10(%ebp),%eax
c010b6c2:	83 e8 01             	sub    $0x1,%eax
c010b6c5:	0f b6 00             	movzbl (%eax),%eax
c010b6c8:	3c 25                	cmp    $0x25,%al
c010b6ca:	75 ef                	jne    c010b6bb <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010b6cc:	90                   	nop
        }
    }
c010b6cd:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b6ce:	e9 3e fc ff ff       	jmp    c010b311 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b6d3:	83 c4 40             	add    $0x40,%esp
c010b6d6:	5b                   	pop    %ebx
c010b6d7:	5e                   	pop    %esi
c010b6d8:	5d                   	pop    %ebp
c010b6d9:	c3                   	ret    

c010b6da <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b6da:	55                   	push   %ebp
c010b6db:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b6dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6e0:	8b 40 08             	mov    0x8(%eax),%eax
c010b6e3:	8d 50 01             	lea    0x1(%eax),%edx
c010b6e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6e9:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b6ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6ef:	8b 10                	mov    (%eax),%edx
c010b6f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6f4:	8b 40 04             	mov    0x4(%eax),%eax
c010b6f7:	39 c2                	cmp    %eax,%edx
c010b6f9:	73 12                	jae    c010b70d <sprintputch+0x33>
        *b->buf ++ = ch;
c010b6fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6fe:	8b 00                	mov    (%eax),%eax
c010b700:	8d 48 01             	lea    0x1(%eax),%ecx
c010b703:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b706:	89 0a                	mov    %ecx,(%edx)
c010b708:	8b 55 08             	mov    0x8(%ebp),%edx
c010b70b:	88 10                	mov    %dl,(%eax)
    }
}
c010b70d:	5d                   	pop    %ebp
c010b70e:	c3                   	ret    

c010b70f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b70f:	55                   	push   %ebp
c010b710:	89 e5                	mov    %esp,%ebp
c010b712:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b715:	8d 45 14             	lea    0x14(%ebp),%eax
c010b718:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010b71b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b71e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b722:	8b 45 10             	mov    0x10(%ebp),%eax
c010b725:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b729:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b72c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b730:	8b 45 08             	mov    0x8(%ebp),%eax
c010b733:	89 04 24             	mov    %eax,(%esp)
c010b736:	e8 08 00 00 00       	call   c010b743 <vsnprintf>
c010b73b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b741:	c9                   	leave  
c010b742:	c3                   	ret    

c010b743 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b743:	55                   	push   %ebp
c010b744:	89 e5                	mov    %esp,%ebp
c010b746:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b749:	8b 45 08             	mov    0x8(%ebp),%eax
c010b74c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b74f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b752:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b755:	8b 45 08             	mov    0x8(%ebp),%eax
c010b758:	01 d0                	add    %edx,%eax
c010b75a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b75d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010b764:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b768:	74 0a                	je     c010b774 <vsnprintf+0x31>
c010b76a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b770:	39 c2                	cmp    %eax,%edx
c010b772:	76 07                	jbe    c010b77b <vsnprintf+0x38>
        return -E_INVAL;
c010b774:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010b779:	eb 2a                	jmp    c010b7a5 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010b77b:	8b 45 14             	mov    0x14(%ebp),%eax
c010b77e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b782:	8b 45 10             	mov    0x10(%ebp),%eax
c010b785:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b789:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010b78c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b790:	c7 04 24 da b6 10 c0 	movl   $0xc010b6da,(%esp)
c010b797:	e8 53 fb ff ff       	call   c010b2ef <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010b79c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b79f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010b7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b7a5:	c9                   	leave  
c010b7a6:	c3                   	ret    

c010b7a7 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010b7a7:	55                   	push   %ebp
c010b7a8:	89 e5                	mov    %esp,%ebp
c010b7aa:	57                   	push   %edi
c010b7ab:	56                   	push   %esi
c010b7ac:	53                   	push   %ebx
c010b7ad:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010b7b0:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b7b5:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b7bb:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010b7c1:	6b f0 05             	imul   $0x5,%eax,%esi
c010b7c4:	01 f7                	add    %esi,%edi
c010b7c6:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010b7cb:	f7 e6                	mul    %esi
c010b7cd:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010b7d0:	89 f2                	mov    %esi,%edx
c010b7d2:	83 c0 0b             	add    $0xb,%eax
c010b7d5:	83 d2 00             	adc    $0x0,%edx
c010b7d8:	89 c7                	mov    %eax,%edi
c010b7da:	83 e7 ff             	and    $0xffffffff,%edi
c010b7dd:	89 f9                	mov    %edi,%ecx
c010b7df:	0f b7 da             	movzwl %dx,%ebx
c010b7e2:	89 0d 20 ab 12 c0    	mov    %ecx,0xc012ab20
c010b7e8:	89 1d 24 ab 12 c0    	mov    %ebx,0xc012ab24
    unsigned long long result = (next >> 12);
c010b7ee:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010b7f3:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010b7f9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010b7fd:	c1 ea 0c             	shr    $0xc,%edx
c010b800:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b803:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010b806:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010b80d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b813:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b816:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b819:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b81c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b81f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b823:	74 1c                	je     c010b841 <rand+0x9a>
c010b825:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b828:	ba 00 00 00 00       	mov    $0x0,%edx
c010b82d:	f7 75 dc             	divl   -0x24(%ebp)
c010b830:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b833:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b836:	ba 00 00 00 00       	mov    $0x0,%edx
c010b83b:	f7 75 dc             	divl   -0x24(%ebp)
c010b83e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b841:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b844:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b847:	f7 75 dc             	divl   -0x24(%ebp)
c010b84a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b84d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010b850:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b853:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b856:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b859:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010b85c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010b85f:	83 c4 24             	add    $0x24,%esp
c010b862:	5b                   	pop    %ebx
c010b863:	5e                   	pop    %esi
c010b864:	5f                   	pop    %edi
c010b865:	5d                   	pop    %ebp
c010b866:	c3                   	ret    

c010b867 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010b867:	55                   	push   %ebp
c010b868:	89 e5                	mov    %esp,%ebp
    next = seed;
c010b86a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b86d:	ba 00 00 00 00       	mov    $0x0,%edx
c010b872:	a3 20 ab 12 c0       	mov    %eax,0xc012ab20
c010b877:	89 15 24 ab 12 c0    	mov    %edx,0xc012ab24
}
c010b87d:	5d                   	pop    %ebp
c010b87e:	c3                   	ret    

c010b87f <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010b87f:	55                   	push   %ebp
c010b880:	89 e5                	mov    %esp,%ebp
c010b882:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010b88c:	eb 04                	jmp    c010b892 <strlen+0x13>
        cnt ++;
c010b88e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010b892:	8b 45 08             	mov    0x8(%ebp),%eax
c010b895:	8d 50 01             	lea    0x1(%eax),%edx
c010b898:	89 55 08             	mov    %edx,0x8(%ebp)
c010b89b:	0f b6 00             	movzbl (%eax),%eax
c010b89e:	84 c0                	test   %al,%al
c010b8a0:	75 ec                	jne    c010b88e <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010b8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b8a5:	c9                   	leave  
c010b8a6:	c3                   	ret    

c010b8a7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010b8a7:	55                   	push   %ebp
c010b8a8:	89 e5                	mov    %esp,%ebp
c010b8aa:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b8ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010b8b4:	eb 04                	jmp    c010b8ba <strnlen+0x13>
        cnt ++;
c010b8b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010b8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b8bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010b8c0:	73 10                	jae    c010b8d2 <strnlen+0x2b>
c010b8c2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8c5:	8d 50 01             	lea    0x1(%eax),%edx
c010b8c8:	89 55 08             	mov    %edx,0x8(%ebp)
c010b8cb:	0f b6 00             	movzbl (%eax),%eax
c010b8ce:	84 c0                	test   %al,%al
c010b8d0:	75 e4                	jne    c010b8b6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010b8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b8d5:	c9                   	leave  
c010b8d6:	c3                   	ret    

c010b8d7 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010b8d7:	55                   	push   %ebp
c010b8d8:	89 e5                	mov    %esp,%ebp
c010b8da:	57                   	push   %edi
c010b8db:	56                   	push   %esi
c010b8dc:	83 ec 20             	sub    $0x20,%esp
c010b8df:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b8e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010b8eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b8f1:	89 d1                	mov    %edx,%ecx
c010b8f3:	89 c2                	mov    %eax,%edx
c010b8f5:	89 ce                	mov    %ecx,%esi
c010b8f7:	89 d7                	mov    %edx,%edi
c010b8f9:	ac                   	lods   %ds:(%esi),%al
c010b8fa:	aa                   	stos   %al,%es:(%edi)
c010b8fb:	84 c0                	test   %al,%al
c010b8fd:	75 fa                	jne    c010b8f9 <strcpy+0x22>
c010b8ff:	89 fa                	mov    %edi,%edx
c010b901:	89 f1                	mov    %esi,%ecx
c010b903:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010b906:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010b90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010b90f:	83 c4 20             	add    $0x20,%esp
c010b912:	5e                   	pop    %esi
c010b913:	5f                   	pop    %edi
c010b914:	5d                   	pop    %ebp
c010b915:	c3                   	ret    

c010b916 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010b916:	55                   	push   %ebp
c010b917:	89 e5                	mov    %esp,%ebp
c010b919:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010b91c:	8b 45 08             	mov    0x8(%ebp),%eax
c010b91f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010b922:	eb 21                	jmp    c010b945 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010b924:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b927:	0f b6 10             	movzbl (%eax),%edx
c010b92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b92d:	88 10                	mov    %dl,(%eax)
c010b92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b932:	0f b6 00             	movzbl (%eax),%eax
c010b935:	84 c0                	test   %al,%al
c010b937:	74 04                	je     c010b93d <strncpy+0x27>
            src ++;
c010b939:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010b93d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010b941:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010b945:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b949:	75 d9                	jne    c010b924 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010b94b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010b94e:	c9                   	leave  
c010b94f:	c3                   	ret    

c010b950 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010b950:	55                   	push   %ebp
c010b951:	89 e5                	mov    %esp,%ebp
c010b953:	57                   	push   %edi
c010b954:	56                   	push   %esi
c010b955:	83 ec 20             	sub    $0x20,%esp
c010b958:	8b 45 08             	mov    0x8(%ebp),%eax
c010b95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b95e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b961:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010b964:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b967:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b96a:	89 d1                	mov    %edx,%ecx
c010b96c:	89 c2                	mov    %eax,%edx
c010b96e:	89 ce                	mov    %ecx,%esi
c010b970:	89 d7                	mov    %edx,%edi
c010b972:	ac                   	lods   %ds:(%esi),%al
c010b973:	ae                   	scas   %es:(%edi),%al
c010b974:	75 08                	jne    c010b97e <strcmp+0x2e>
c010b976:	84 c0                	test   %al,%al
c010b978:	75 f8                	jne    c010b972 <strcmp+0x22>
c010b97a:	31 c0                	xor    %eax,%eax
c010b97c:	eb 04                	jmp    c010b982 <strcmp+0x32>
c010b97e:	19 c0                	sbb    %eax,%eax
c010b980:	0c 01                	or     $0x1,%al
c010b982:	89 fa                	mov    %edi,%edx
c010b984:	89 f1                	mov    %esi,%ecx
c010b986:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b989:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010b98c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010b98f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010b992:	83 c4 20             	add    $0x20,%esp
c010b995:	5e                   	pop    %esi
c010b996:	5f                   	pop    %edi
c010b997:	5d                   	pop    %ebp
c010b998:	c3                   	ret    

c010b999 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010b999:	55                   	push   %ebp
c010b99a:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b99c:	eb 0c                	jmp    c010b9aa <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010b99e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b9a2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b9a6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b9aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b9ae:	74 1a                	je     c010b9ca <strncmp+0x31>
c010b9b0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9b3:	0f b6 00             	movzbl (%eax),%eax
c010b9b6:	84 c0                	test   %al,%al
c010b9b8:	74 10                	je     c010b9ca <strncmp+0x31>
c010b9ba:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9bd:	0f b6 10             	movzbl (%eax),%edx
c010b9c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9c3:	0f b6 00             	movzbl (%eax),%eax
c010b9c6:	38 c2                	cmp    %al,%dl
c010b9c8:	74 d4                	je     c010b99e <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010b9ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b9ce:	74 18                	je     c010b9e8 <strncmp+0x4f>
c010b9d0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9d3:	0f b6 00             	movzbl (%eax),%eax
c010b9d6:	0f b6 d0             	movzbl %al,%edx
c010b9d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9dc:	0f b6 00             	movzbl (%eax),%eax
c010b9df:	0f b6 c0             	movzbl %al,%eax
c010b9e2:	29 c2                	sub    %eax,%edx
c010b9e4:	89 d0                	mov    %edx,%eax
c010b9e6:	eb 05                	jmp    c010b9ed <strncmp+0x54>
c010b9e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b9ed:	5d                   	pop    %ebp
c010b9ee:	c3                   	ret    

c010b9ef <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010b9ef:	55                   	push   %ebp
c010b9f0:	89 e5                	mov    %esp,%ebp
c010b9f2:	83 ec 04             	sub    $0x4,%esp
c010b9f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9f8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010b9fb:	eb 14                	jmp    c010ba11 <strchr+0x22>
        if (*s == c) {
c010b9fd:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba00:	0f b6 00             	movzbl (%eax),%eax
c010ba03:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010ba06:	75 05                	jne    c010ba0d <strchr+0x1e>
            return (char *)s;
c010ba08:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba0b:	eb 13                	jmp    c010ba20 <strchr+0x31>
        }
        s ++;
c010ba0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010ba11:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba14:	0f b6 00             	movzbl (%eax),%eax
c010ba17:	84 c0                	test   %al,%al
c010ba19:	75 e2                	jne    c010b9fd <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010ba1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ba20:	c9                   	leave  
c010ba21:	c3                   	ret    

c010ba22 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010ba22:	55                   	push   %ebp
c010ba23:	89 e5                	mov    %esp,%ebp
c010ba25:	83 ec 04             	sub    $0x4,%esp
c010ba28:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba2b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010ba2e:	eb 11                	jmp    c010ba41 <strfind+0x1f>
        if (*s == c) {
c010ba30:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba33:	0f b6 00             	movzbl (%eax),%eax
c010ba36:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010ba39:	75 02                	jne    c010ba3d <strfind+0x1b>
            break;
c010ba3b:	eb 0e                	jmp    c010ba4b <strfind+0x29>
        }
        s ++;
c010ba3d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010ba41:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba44:	0f b6 00             	movzbl (%eax),%eax
c010ba47:	84 c0                	test   %al,%al
c010ba49:	75 e5                	jne    c010ba30 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010ba4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010ba4e:	c9                   	leave  
c010ba4f:	c3                   	ret    

c010ba50 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010ba50:	55                   	push   %ebp
c010ba51:	89 e5                	mov    %esp,%ebp
c010ba53:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010ba56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010ba5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010ba64:	eb 04                	jmp    c010ba6a <strtol+0x1a>
        s ++;
c010ba66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010ba6a:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba6d:	0f b6 00             	movzbl (%eax),%eax
c010ba70:	3c 20                	cmp    $0x20,%al
c010ba72:	74 f2                	je     c010ba66 <strtol+0x16>
c010ba74:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba77:	0f b6 00             	movzbl (%eax),%eax
c010ba7a:	3c 09                	cmp    $0x9,%al
c010ba7c:	74 e8                	je     c010ba66 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010ba7e:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba81:	0f b6 00             	movzbl (%eax),%eax
c010ba84:	3c 2b                	cmp    $0x2b,%al
c010ba86:	75 06                	jne    c010ba8e <strtol+0x3e>
        s ++;
c010ba88:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010ba8c:	eb 15                	jmp    c010baa3 <strtol+0x53>
    }
    else if (*s == '-') {
c010ba8e:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba91:	0f b6 00             	movzbl (%eax),%eax
c010ba94:	3c 2d                	cmp    $0x2d,%al
c010ba96:	75 0b                	jne    c010baa3 <strtol+0x53>
        s ++, neg = 1;
c010ba98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010ba9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010baa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010baa7:	74 06                	je     c010baaf <strtol+0x5f>
c010baa9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010baad:	75 24                	jne    c010bad3 <strtol+0x83>
c010baaf:	8b 45 08             	mov    0x8(%ebp),%eax
c010bab2:	0f b6 00             	movzbl (%eax),%eax
c010bab5:	3c 30                	cmp    $0x30,%al
c010bab7:	75 1a                	jne    c010bad3 <strtol+0x83>
c010bab9:	8b 45 08             	mov    0x8(%ebp),%eax
c010babc:	83 c0 01             	add    $0x1,%eax
c010babf:	0f b6 00             	movzbl (%eax),%eax
c010bac2:	3c 78                	cmp    $0x78,%al
c010bac4:	75 0d                	jne    c010bad3 <strtol+0x83>
        s += 2, base = 16;
c010bac6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010baca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010bad1:	eb 2a                	jmp    c010bafd <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010bad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bad7:	75 17                	jne    c010baf0 <strtol+0xa0>
c010bad9:	8b 45 08             	mov    0x8(%ebp),%eax
c010badc:	0f b6 00             	movzbl (%eax),%eax
c010badf:	3c 30                	cmp    $0x30,%al
c010bae1:	75 0d                	jne    c010baf0 <strtol+0xa0>
        s ++, base = 8;
c010bae3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bae7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010baee:	eb 0d                	jmp    c010bafd <strtol+0xad>
    }
    else if (base == 0) {
c010baf0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010baf4:	75 07                	jne    c010bafd <strtol+0xad>
        base = 10;
c010baf6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010bafd:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb00:	0f b6 00             	movzbl (%eax),%eax
c010bb03:	3c 2f                	cmp    $0x2f,%al
c010bb05:	7e 1b                	jle    c010bb22 <strtol+0xd2>
c010bb07:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb0a:	0f b6 00             	movzbl (%eax),%eax
c010bb0d:	3c 39                	cmp    $0x39,%al
c010bb0f:	7f 11                	jg     c010bb22 <strtol+0xd2>
            dig = *s - '0';
c010bb11:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb14:	0f b6 00             	movzbl (%eax),%eax
c010bb17:	0f be c0             	movsbl %al,%eax
c010bb1a:	83 e8 30             	sub    $0x30,%eax
c010bb1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bb20:	eb 48                	jmp    c010bb6a <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010bb22:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb25:	0f b6 00             	movzbl (%eax),%eax
c010bb28:	3c 60                	cmp    $0x60,%al
c010bb2a:	7e 1b                	jle    c010bb47 <strtol+0xf7>
c010bb2c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb2f:	0f b6 00             	movzbl (%eax),%eax
c010bb32:	3c 7a                	cmp    $0x7a,%al
c010bb34:	7f 11                	jg     c010bb47 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010bb36:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb39:	0f b6 00             	movzbl (%eax),%eax
c010bb3c:	0f be c0             	movsbl %al,%eax
c010bb3f:	83 e8 57             	sub    $0x57,%eax
c010bb42:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bb45:	eb 23                	jmp    c010bb6a <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010bb47:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb4a:	0f b6 00             	movzbl (%eax),%eax
c010bb4d:	3c 40                	cmp    $0x40,%al
c010bb4f:	7e 3d                	jle    c010bb8e <strtol+0x13e>
c010bb51:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb54:	0f b6 00             	movzbl (%eax),%eax
c010bb57:	3c 5a                	cmp    $0x5a,%al
c010bb59:	7f 33                	jg     c010bb8e <strtol+0x13e>
            dig = *s - 'A' + 10;
c010bb5b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb5e:	0f b6 00             	movzbl (%eax),%eax
c010bb61:	0f be c0             	movsbl %al,%eax
c010bb64:	83 e8 37             	sub    $0x37,%eax
c010bb67:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010bb6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bb6d:	3b 45 10             	cmp    0x10(%ebp),%eax
c010bb70:	7c 02                	jl     c010bb74 <strtol+0x124>
            break;
c010bb72:	eb 1a                	jmp    c010bb8e <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010bb74:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bb78:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bb7b:	0f af 45 10          	imul   0x10(%ebp),%eax
c010bb7f:	89 c2                	mov    %eax,%edx
c010bb81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bb84:	01 d0                	add    %edx,%eax
c010bb86:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010bb89:	e9 6f ff ff ff       	jmp    c010bafd <strtol+0xad>

    if (endptr) {
c010bb8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010bb92:	74 08                	je     c010bb9c <strtol+0x14c>
        *endptr = (char *) s;
c010bb94:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb97:	8b 55 08             	mov    0x8(%ebp),%edx
c010bb9a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010bb9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010bba0:	74 07                	je     c010bba9 <strtol+0x159>
c010bba2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bba5:	f7 d8                	neg    %eax
c010bba7:	eb 03                	jmp    c010bbac <strtol+0x15c>
c010bba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010bbac:	c9                   	leave  
c010bbad:	c3                   	ret    

c010bbae <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010bbae:	55                   	push   %ebp
c010bbaf:	89 e5                	mov    %esp,%ebp
c010bbb1:	57                   	push   %edi
c010bbb2:	83 ec 24             	sub    $0x24,%esp
c010bbb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbb8:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010bbbb:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010bbbf:	8b 55 08             	mov    0x8(%ebp),%edx
c010bbc2:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010bbc5:	88 45 f7             	mov    %al,-0x9(%ebp)
c010bbc8:	8b 45 10             	mov    0x10(%ebp),%eax
c010bbcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010bbce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010bbd1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010bbd5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010bbd8:	89 d7                	mov    %edx,%edi
c010bbda:	f3 aa                	rep stos %al,%es:(%edi)
c010bbdc:	89 fa                	mov    %edi,%edx
c010bbde:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010bbe1:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010bbe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010bbe7:	83 c4 24             	add    $0x24,%esp
c010bbea:	5f                   	pop    %edi
c010bbeb:	5d                   	pop    %ebp
c010bbec:	c3                   	ret    

c010bbed <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010bbed:	55                   	push   %ebp
c010bbee:	89 e5                	mov    %esp,%ebp
c010bbf0:	57                   	push   %edi
c010bbf1:	56                   	push   %esi
c010bbf2:	53                   	push   %ebx
c010bbf3:	83 ec 30             	sub    $0x30,%esp
c010bbf6:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bbfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bc02:	8b 45 10             	mov    0x10(%ebp),%eax
c010bc05:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010bc08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010bc0e:	73 42                	jae    c010bc52 <memmove+0x65>
c010bc10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010bc16:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bc19:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010bc1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bc22:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010bc25:	c1 e8 02             	shr    $0x2,%eax
c010bc28:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bc2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010bc2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010bc30:	89 d7                	mov    %edx,%edi
c010bc32:	89 c6                	mov    %eax,%esi
c010bc34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bc36:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010bc39:	83 e1 03             	and    $0x3,%ecx
c010bc3c:	74 02                	je     c010bc40 <memmove+0x53>
c010bc3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bc40:	89 f0                	mov    %esi,%eax
c010bc42:	89 fa                	mov    %edi,%edx
c010bc44:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010bc47:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010bc4a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bc4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010bc50:	eb 36                	jmp    c010bc88 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010bc52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc55:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bc58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bc5b:	01 c2                	add    %eax,%edx
c010bc5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc60:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010bc63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bc66:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010bc69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bc6c:	89 c1                	mov    %eax,%ecx
c010bc6e:	89 d8                	mov    %ebx,%eax
c010bc70:	89 d6                	mov    %edx,%esi
c010bc72:	89 c7                	mov    %eax,%edi
c010bc74:	fd                   	std    
c010bc75:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bc77:	fc                   	cld    
c010bc78:	89 f8                	mov    %edi,%eax
c010bc7a:	89 f2                	mov    %esi,%edx
c010bc7c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010bc7f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010bc82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010bc85:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010bc88:	83 c4 30             	add    $0x30,%esp
c010bc8b:	5b                   	pop    %ebx
c010bc8c:	5e                   	pop    %esi
c010bc8d:	5f                   	pop    %edi
c010bc8e:	5d                   	pop    %ebp
c010bc8f:	c3                   	ret    

c010bc90 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010bc90:	55                   	push   %ebp
c010bc91:	89 e5                	mov    %esp,%ebp
c010bc93:	57                   	push   %edi
c010bc94:	56                   	push   %esi
c010bc95:	83 ec 20             	sub    $0x20,%esp
c010bc98:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bc9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bca4:	8b 45 10             	mov    0x10(%ebp),%eax
c010bca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bcaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bcad:	c1 e8 02             	shr    $0x2,%eax
c010bcb0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bcb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010bcb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bcb8:	89 d7                	mov    %edx,%edi
c010bcba:	89 c6                	mov    %eax,%esi
c010bcbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bcbe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010bcc1:	83 e1 03             	and    $0x3,%ecx
c010bcc4:	74 02                	je     c010bcc8 <memcpy+0x38>
c010bcc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bcc8:	89 f0                	mov    %esi,%eax
c010bcca:	89 fa                	mov    %edi,%edx
c010bccc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010bccf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010bcd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bcd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010bcd8:	83 c4 20             	add    $0x20,%esp
c010bcdb:	5e                   	pop    %esi
c010bcdc:	5f                   	pop    %edi
c010bcdd:	5d                   	pop    %ebp
c010bcde:	c3                   	ret    

c010bcdf <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010bcdf:	55                   	push   %ebp
c010bce0:	89 e5                	mov    %esp,%ebp
c010bce2:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010bce5:	8b 45 08             	mov    0x8(%ebp),%eax
c010bce8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010bceb:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bcee:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010bcf1:	eb 30                	jmp    c010bd23 <memcmp+0x44>
        if (*s1 != *s2) {
c010bcf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bcf6:	0f b6 10             	movzbl (%eax),%edx
c010bcf9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bcfc:	0f b6 00             	movzbl (%eax),%eax
c010bcff:	38 c2                	cmp    %al,%dl
c010bd01:	74 18                	je     c010bd1b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bd03:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bd06:	0f b6 00             	movzbl (%eax),%eax
c010bd09:	0f b6 d0             	movzbl %al,%edx
c010bd0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bd0f:	0f b6 00             	movzbl (%eax),%eax
c010bd12:	0f b6 c0             	movzbl %al,%eax
c010bd15:	29 c2                	sub    %eax,%edx
c010bd17:	89 d0                	mov    %edx,%eax
c010bd19:	eb 1a                	jmp    c010bd35 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010bd1b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010bd1f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010bd23:	8b 45 10             	mov    0x10(%ebp),%eax
c010bd26:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bd29:	89 55 10             	mov    %edx,0x10(%ebp)
c010bd2c:	85 c0                	test   %eax,%eax
c010bd2e:	75 c3                	jne    c010bcf3 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010bd30:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bd35:	c9                   	leave  
c010bd36:	c3                   	ret    
