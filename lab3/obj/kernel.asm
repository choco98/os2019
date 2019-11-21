
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 10 12 00       	mov    $0x121000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 10 12 c0       	mov    %eax,0xc0121000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 30 41 12 c0       	mov    $0xc0124130,%edx
c0100041:	b8 00 30 12 c0       	mov    $0xc0123000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 30 12 c0 	movl   $0xc0123000,(%esp)
c010005d:	e8 19 8a 00 00       	call   c0108a7b <memset>

    cons_init();                // init the console
c0100062:	e8 91 15 00 00       	call   c01015f8 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 20 8c 10 c0 	movl   $0xc0108c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 3c 8c 10 c0 	movl   $0xc0108c3c,(%esp)
c010007c:	e8 d6 02 00 00       	call   c0100357 <cprintf>

    print_kerninfo();
c0100081:	e8 05 08 00 00       	call   c010088b <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 67 4c 00 00       	call   c0104cf7 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 41 1f 00 00       	call   c0101fd6 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 93 20 00 00       	call   c010212d <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 61 74 00 00       	call   c0107500 <vmm_init>

    ide_init();                 // init ide devices
c010009f:	e8 85 16 00 00       	call   c0101729 <ide_init>
    swap_init();                // init swap
c01000a4:	e8 c0 5f 00 00       	call   c0106069 <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 00 0d 00 00       	call   c0100dae <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 91 1e 00 00       	call   c0101f44 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000b3:	eb fe                	jmp    c01000b3 <kern_init+0x7d>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 f8 0b 00 00       	call   c0100ccf <mon_backtrace>
}
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	53                   	push   %ebx
c01000dd:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e6:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f8:	89 04 24             	mov    %eax,(%esp)
c01000fb:	e8 b5 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	55                   	push   %ebp
c0100107:	89 e5                	mov    %esp,%ebp
c0100109:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010c:	8b 45 10             	mov    0x10(%ebp),%eax
c010010f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100113:	8b 45 08             	mov    0x8(%ebp),%eax
c0100116:	89 04 24             	mov    %eax,(%esp)
c0100119:	e8 bb ff ff ff       	call   c01000d9 <grade_backtrace1>
}
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	55                   	push   %ebp
c0100121:	89 e5                	mov    %esp,%ebp
c0100123:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100126:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100132:	ff 
c0100133:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013e:	e8 c3 ff ff ff       	call   c0100106 <grade_backtrace0>
}
c0100143:	c9                   	leave  
c0100144:	c3                   	ret    

c0100145 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100145:	55                   	push   %ebp
c0100146:	89 e5                	mov    %esp,%ebp
c0100148:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100151:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100154:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100157:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015b:	0f b7 c0             	movzwl %ax,%eax
c010015e:	83 e0 03             	and    $0x3,%eax
c0100161:	89 c2                	mov    %eax,%edx
c0100163:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100168:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100170:	c7 04 24 41 8c 10 c0 	movl   $0xc0108c41,(%esp)
c0100177:	e8 db 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100180:	0f b7 d0             	movzwl %ax,%edx
c0100183:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 4f 8c 10 c0 	movl   $0xc0108c4f,(%esp)
c0100197:	e8 bb 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	0f b7 d0             	movzwl %ax,%edx
c01001a3:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b0:	c7 04 24 5d 8c 10 c0 	movl   $0xc0108c5d,(%esp)
c01001b7:	e8 9b 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c0:	0f b7 d0             	movzwl %ax,%edx
c01001c3:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001c8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d0:	c7 04 24 6b 8c 10 c0 	movl   $0xc0108c6b,(%esp)
c01001d7:	e8 7b 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e0:	0f b7 d0             	movzwl %ax,%edx
c01001e3:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001e8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f0:	c7 04 24 79 8c 10 c0 	movl   $0xc0108c79,(%esp)
c01001f7:	e8 5b 01 00 00       	call   c0100357 <cprintf>
    round ++;
c01001fc:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100201:	83 c0 01             	add    $0x1,%eax
c0100204:	a3 00 30 12 c0       	mov    %eax,0xc0123000
}
c0100209:	c9                   	leave  
c010020a:	c3                   	ret    

c010020b <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020e:	5d                   	pop    %ebp
c010020f:	c3                   	ret    

c0100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
c0100218:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021b:	e8 25 ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100220:	c7 04 24 88 8c 10 c0 	movl   $0xc0108c88,(%esp)
c0100227:	e8 2b 01 00 00       	call   c0100357 <cprintf>
    lab1_switch_to_user();
c010022c:	e8 da ff ff ff       	call   c010020b <lab1_switch_to_user>
    lab1_print_cur_status();
c0100231:	e8 0f ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100236:	c7 04 24 a8 8c 10 c0 	movl   $0xc0108ca8,(%esp)
c010023d:	e8 15 01 00 00       	call   c0100357 <cprintf>
    lab1_switch_to_kernel();
c0100242:	e8 c9 ff ff ff       	call   c0100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100247:	e8 f9 fe ff ff       	call   c0100145 <lab1_print_cur_status>
}
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100258:	74 13                	je     c010026d <readline+0x1f>
        cprintf("%s", prompt);
c010025a:	8b 45 08             	mov    0x8(%ebp),%eax
c010025d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100261:	c7 04 24 c7 8c 10 c0 	movl   $0xc0108cc7,(%esp)
c0100268:	e8 ea 00 00 00       	call   c0100357 <cprintf>
    }
    int i = 0, c;
c010026d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100274:	e8 66 01 00 00       	call   c01003df <getchar>
c0100279:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010027c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100280:	79 07                	jns    c0100289 <readline+0x3b>
            return NULL;
c0100282:	b8 00 00 00 00       	mov    $0x0,%eax
c0100287:	eb 79                	jmp    c0100302 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100289:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010028d:	7e 28                	jle    c01002b7 <readline+0x69>
c010028f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100296:	7f 1f                	jg     c01002b7 <readline+0x69>
            cputchar(c);
c0100298:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029b:	89 04 24             	mov    %eax,(%esp)
c010029e:	e8 da 00 00 00       	call   c010037d <cputchar>
            buf[i ++] = c;
c01002a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a6:	8d 50 01             	lea    0x1(%eax),%edx
c01002a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002af:	88 90 20 30 12 c0    	mov    %dl,-0x3fedcfe0(%eax)
c01002b5:	eb 46                	jmp    c01002fd <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002bb:	75 17                	jne    c01002d4 <readline+0x86>
c01002bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c1:	7e 11                	jle    c01002d4 <readline+0x86>
            cputchar(c);
c01002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c6:	89 04 24             	mov    %eax,(%esp)
c01002c9:	e8 af 00 00 00       	call   c010037d <cputchar>
            i --;
c01002ce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002d2:	eb 29                	jmp    c01002fd <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d8:	74 06                	je     c01002e0 <readline+0x92>
c01002da:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002de:	75 1d                	jne    c01002fd <readline+0xaf>
            cputchar(c);
c01002e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e3:	89 04 24             	mov    %eax,(%esp)
c01002e6:	e8 92 00 00 00       	call   c010037d <cputchar>
            buf[i] = '\0';
c01002eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ee:	05 20 30 12 c0       	add    $0xc0123020,%eax
c01002f3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f6:	b8 20 30 12 c0       	mov    $0xc0123020,%eax
c01002fb:	eb 05                	jmp    c0100302 <readline+0xb4>
        }
    }
c01002fd:	e9 72 ff ff ff       	jmp    c0100274 <readline+0x26>
}
c0100302:	c9                   	leave  
c0100303:	c3                   	ret    

c0100304 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100304:	55                   	push   %ebp
c0100305:	89 e5                	mov    %esp,%ebp
c0100307:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030a:	8b 45 08             	mov    0x8(%ebp),%eax
c010030d:	89 04 24             	mov    %eax,(%esp)
c0100310:	e8 0f 13 00 00       	call   c0101624 <cons_putc>
    (*cnt) ++;
c0100315:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100318:	8b 00                	mov    (%eax),%eax
c010031a:	8d 50 01             	lea    0x1(%eax),%edx
c010031d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100320:	89 10                	mov    %edx,(%eax)
}
c0100322:	c9                   	leave  
c0100323:	c3                   	ret    

c0100324 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100324:	55                   	push   %ebp
c0100325:	89 e5                	mov    %esp,%ebp
c0100327:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100331:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100334:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100338:	8b 45 08             	mov    0x8(%ebp),%eax
c010033b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100342:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100346:	c7 04 24 04 03 10 c0 	movl   $0xc0100304,(%esp)
c010034d:	e8 6a 7e 00 00       	call   c01081bc <vprintfmt>
    return cnt;
c0100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100355:	c9                   	leave  
c0100356:	c3                   	ret    

c0100357 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100357:	55                   	push   %ebp
c0100358:	89 e5                	mov    %esp,%ebp
c010035a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100360:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100363:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010036a:	8b 45 08             	mov    0x8(%ebp),%eax
c010036d:	89 04 24             	mov    %eax,(%esp)
c0100370:	e8 af ff ff ff       	call   c0100324 <vcprintf>
c0100375:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100378:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037b:	c9                   	leave  
c010037c:	c3                   	ret    

c010037d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037d:	55                   	push   %ebp
c010037e:	89 e5                	mov    %esp,%ebp
c0100380:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100383:	8b 45 08             	mov    0x8(%ebp),%eax
c0100386:	89 04 24             	mov    %eax,(%esp)
c0100389:	e8 96 12 00 00       	call   c0101624 <cons_putc>
}
c010038e:	c9                   	leave  
c010038f:	c3                   	ret    

c0100390 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100390:	55                   	push   %ebp
c0100391:	89 e5                	mov    %esp,%ebp
c0100393:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010039d:	eb 13                	jmp    c01003b2 <cputs+0x22>
        cputch(c, &cnt);
c010039f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a3:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003aa:	89 04 24             	mov    %eax,(%esp)
c01003ad:	e8 52 ff ff ff       	call   c0100304 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b5:	8d 50 01             	lea    0x1(%eax),%edx
c01003b8:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bb:	0f b6 00             	movzbl (%eax),%eax
c01003be:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c1:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c5:	75 d8                	jne    c010039f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ce:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d5:	e8 2a ff ff ff       	call   c0100304 <cputch>
    return cnt;
c01003da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003dd:	c9                   	leave  
c01003de:	c3                   	ret    

c01003df <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003df:	55                   	push   %ebp
c01003e0:	89 e5                	mov    %esp,%ebp
c01003e2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e5:	e8 76 12 00 00       	call   c0101660 <cons_getc>
c01003ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f1:	74 f2                	je     c01003e5 <getchar+0x6>
        /* do nothing */;
    return c;
c01003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f6:	c9                   	leave  
c01003f7:	c3                   	ret    

c01003f8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f8:	55                   	push   %ebp
c01003f9:	89 e5                	mov    %esp,%ebp
c01003fb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100401:	8b 00                	mov    (%eax),%eax
c0100403:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100406:	8b 45 10             	mov    0x10(%ebp),%eax
c0100409:	8b 00                	mov    (%eax),%eax
c010040b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100415:	e9 d2 00 00 00       	jmp    c01004ec <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010041a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010041d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100420:	01 d0                	add    %edx,%eax
c0100422:	89 c2                	mov    %eax,%edx
c0100424:	c1 ea 1f             	shr    $0x1f,%edx
c0100427:	01 d0                	add    %edx,%eax
c0100429:	d1 f8                	sar    %eax
c010042b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100431:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100434:	eb 04                	jmp    c010043a <stab_binsearch+0x42>
            m --;
c0100436:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010043d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100440:	7c 1f                	jl     c0100461 <stab_binsearch+0x69>
c0100442:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100445:	89 d0                	mov    %edx,%eax
c0100447:	01 c0                	add    %eax,%eax
c0100449:	01 d0                	add    %edx,%eax
c010044b:	c1 e0 02             	shl    $0x2,%eax
c010044e:	89 c2                	mov    %eax,%edx
c0100450:	8b 45 08             	mov    0x8(%ebp),%eax
c0100453:	01 d0                	add    %edx,%eax
c0100455:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100459:	0f b6 c0             	movzbl %al,%eax
c010045c:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045f:	75 d5                	jne    c0100436 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100461:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100464:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100467:	7d 0b                	jge    c0100474 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100469:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010046c:	83 c0 01             	add    $0x1,%eax
c010046f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100472:	eb 78                	jmp    c01004ec <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100474:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010047b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047e:	89 d0                	mov    %edx,%eax
c0100480:	01 c0                	add    %eax,%eax
c0100482:	01 d0                	add    %edx,%eax
c0100484:	c1 e0 02             	shl    $0x2,%eax
c0100487:	89 c2                	mov    %eax,%edx
c0100489:	8b 45 08             	mov    0x8(%ebp),%eax
c010048c:	01 d0                	add    %edx,%eax
c010048e:	8b 40 08             	mov    0x8(%eax),%eax
c0100491:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100494:	73 13                	jae    c01004a9 <stab_binsearch+0xb1>
            *region_left = m;
c0100496:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a1:	83 c0 01             	add    $0x1,%eax
c01004a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a7:	eb 43                	jmp    c01004ec <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ac:	89 d0                	mov    %edx,%eax
c01004ae:	01 c0                	add    %eax,%eax
c01004b0:	01 d0                	add    %edx,%eax
c01004b2:	c1 e0 02             	shl    $0x2,%eax
c01004b5:	89 c2                	mov    %eax,%edx
c01004b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ba:	01 d0                	add    %edx,%eax
c01004bc:	8b 40 08             	mov    0x8(%eax),%eax
c01004bf:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004c2:	76 16                	jbe    c01004da <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01004cd:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d2:	83 e8 01             	sub    $0x1,%eax
c01004d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d8:	eb 12                	jmp    c01004ec <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e0:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f2:	0f 8e 22 ff ff ff    	jle    c010041a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fc:	75 0f                	jne    c010050d <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100506:	8b 45 10             	mov    0x10(%ebp),%eax
c0100509:	89 10                	mov    %edx,(%eax)
c010050b:	eb 3f                	jmp    c010054c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c010050d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100510:	8b 00                	mov    (%eax),%eax
c0100512:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100515:	eb 04                	jmp    c010051b <stab_binsearch+0x123>
c0100517:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100523:	7d 1f                	jge    c0100544 <stab_binsearch+0x14c>
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 d0                	mov    %edx,%eax
c010052a:	01 c0                	add    %eax,%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	c1 e0 02             	shl    $0x2,%eax
c0100531:	89 c2                	mov    %eax,%edx
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	01 d0                	add    %edx,%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100542:	75 d3                	jne    c0100517 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
    }
}
c010054c:	c9                   	leave  
c010054d:	c3                   	ret    

c010054e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054e:	55                   	push   %ebp
c010054f:	89 e5                	mov    %esp,%ebp
c0100551:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100554:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100557:	c7 00 cc 8c 10 c0    	movl   $0xc0108ccc,(%eax)
    info->eip_line = 0;
c010055d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100560:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100567:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056a:	c7 40 08 cc 8c 10 c0 	movl   $0xc0108ccc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100571:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100574:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057e:	8b 55 08             	mov    0x8(%ebp),%edx
c0100581:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100587:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010058e:	c7 45 f4 84 ab 10 c0 	movl   $0xc010ab84,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100595:	c7 45 f0 b4 98 11 c0 	movl   $0xc01198b4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059c:	c7 45 ec b5 98 11 c0 	movl   $0xc01198b5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a3:	c7 45 e8 74 d1 11 c0 	movl   $0xc011d174,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b0:	76 0d                	jbe    c01005bf <debuginfo_eip+0x71>
c01005b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b5:	83 e8 01             	sub    $0x1,%eax
c01005b8:	0f b6 00             	movzbl (%eax),%eax
c01005bb:	84 c0                	test   %al,%al
c01005bd:	74 0a                	je     c01005c9 <debuginfo_eip+0x7b>
        return -1;
c01005bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c4:	e9 c0 02 00 00       	jmp    c0100889 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d6:	29 c2                	sub    %eax,%edx
c01005d8:	89 d0                	mov    %edx,%eax
c01005da:	c1 f8 02             	sar    $0x2,%eax
c01005dd:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e3:	83 e8 01             	sub    $0x1,%eax
c01005e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005f0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f7:	00 
c01005f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100602:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100609:	89 04 24             	mov    %eax,(%esp)
c010060c:	e8 e7 fd ff ff       	call   c01003f8 <stab_binsearch>
    if (lfile == 0)
c0100611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100614:	85 c0                	test   %eax,%eax
c0100616:	75 0a                	jne    c0100622 <debuginfo_eip+0xd4>
        return -1;
c0100618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010061d:	e9 67 02 00 00       	jmp    c0100889 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100625:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100628:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100631:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100635:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010063c:	00 
c010063d:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100640:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100644:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100647:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064e:	89 04 24             	mov    %eax,(%esp)
c0100651:	e8 a2 fd ff ff       	call   c01003f8 <stab_binsearch>

    if (lfun <= rfun) {
c0100656:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100659:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010065c:	39 c2                	cmp    %eax,%edx
c010065e:	7f 7c                	jg     c01006dc <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100660:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100663:	89 c2                	mov    %eax,%edx
c0100665:	89 d0                	mov    %edx,%eax
c0100667:	01 c0                	add    %eax,%eax
c0100669:	01 d0                	add    %edx,%eax
c010066b:	c1 e0 02             	shl    $0x2,%eax
c010066e:	89 c2                	mov    %eax,%edx
c0100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	8b 10                	mov    (%eax),%edx
c0100677:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010067a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010067d:	29 c1                	sub    %eax,%ecx
c010067f:	89 c8                	mov    %ecx,%eax
c0100681:	39 c2                	cmp    %eax,%edx
c0100683:	73 22                	jae    c01006a7 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100685:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100688:	89 c2                	mov    %eax,%edx
c010068a:	89 d0                	mov    %edx,%eax
c010068c:	01 c0                	add    %eax,%eax
c010068e:	01 d0                	add    %edx,%eax
c0100690:	c1 e0 02             	shl    $0x2,%eax
c0100693:	89 c2                	mov    %eax,%edx
c0100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100698:	01 d0                	add    %edx,%eax
c010069a:	8b 10                	mov    (%eax),%edx
c010069c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069f:	01 c2                	add    %eax,%edx
c01006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a4:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006aa:	89 c2                	mov    %eax,%edx
c01006ac:	89 d0                	mov    %edx,%eax
c01006ae:	01 c0                	add    %eax,%eax
c01006b0:	01 d0                	add    %edx,%eax
c01006b2:	c1 e0 02             	shl    $0x2,%eax
c01006b5:	89 c2                	mov    %eax,%edx
c01006b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ba:	01 d0                	add    %edx,%eax
c01006bc:	8b 50 08             	mov    0x8(%eax),%edx
c01006bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c2:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c8:	8b 40 10             	mov    0x10(%eax),%eax
c01006cb:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006da:	eb 15                	jmp    c01006f1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006df:	8b 55 08             	mov    0x8(%ebp),%edx
c01006e2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f4:	8b 40 08             	mov    0x8(%eax),%eax
c01006f7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fe:	00 
c01006ff:	89 04 24             	mov    %eax,(%esp)
c0100702:	e8 e8 81 00 00       	call   c01088ef <strfind>
c0100707:	89 c2                	mov    %eax,%edx
c0100709:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070c:	8b 40 08             	mov    0x8(%eax),%eax
c010070f:	29 c2                	sub    %eax,%edx
c0100711:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100714:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100717:	8b 45 08             	mov    0x8(%ebp),%eax
c010071a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071e:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100725:	00 
c0100726:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100729:	89 44 24 08          	mov    %eax,0x8(%esp)
c010072d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100730:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100737:	89 04 24             	mov    %eax,(%esp)
c010073a:	e8 b9 fc ff ff       	call   c01003f8 <stab_binsearch>
    if (lline <= rline) {
c010073f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100742:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100745:	39 c2                	cmp    %eax,%edx
c0100747:	7f 24                	jg     c010076d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100749:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074c:	89 c2                	mov    %eax,%edx
c010074e:	89 d0                	mov    %edx,%eax
c0100750:	01 c0                	add    %eax,%eax
c0100752:	01 d0                	add    %edx,%eax
c0100754:	c1 e0 02             	shl    $0x2,%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100762:	0f b7 d0             	movzwl %ax,%edx
c0100765:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100768:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010076b:	eb 13                	jmp    c0100780 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010076d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100772:	e9 12 01 00 00       	jmp    c0100889 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100777:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077a:	83 e8 01             	sub    $0x1,%eax
c010077d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100780:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100786:	39 c2                	cmp    %eax,%edx
c0100788:	7c 56                	jl     c01007e0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010078a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078d:	89 c2                	mov    %eax,%edx
c010078f:	89 d0                	mov    %edx,%eax
c0100791:	01 c0                	add    %eax,%eax
c0100793:	01 d0                	add    %edx,%eax
c0100795:	c1 e0 02             	shl    $0x2,%eax
c0100798:	89 c2                	mov    %eax,%edx
c010079a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079d:	01 d0                	add    %edx,%eax
c010079f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a3:	3c 84                	cmp    $0x84,%al
c01007a5:	74 39                	je     c01007e0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007aa:	89 c2                	mov    %eax,%edx
c01007ac:	89 d0                	mov    %edx,%eax
c01007ae:	01 c0                	add    %eax,%eax
c01007b0:	01 d0                	add    %edx,%eax
c01007b2:	c1 e0 02             	shl    $0x2,%eax
c01007b5:	89 c2                	mov    %eax,%edx
c01007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ba:	01 d0                	add    %edx,%eax
c01007bc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007c0:	3c 64                	cmp    $0x64,%al
c01007c2:	75 b3                	jne    c0100777 <debuginfo_eip+0x229>
c01007c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c7:	89 c2                	mov    %eax,%edx
c01007c9:	89 d0                	mov    %edx,%eax
c01007cb:	01 c0                	add    %eax,%eax
c01007cd:	01 d0                	add    %edx,%eax
c01007cf:	c1 e0 02             	shl    $0x2,%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d7:	01 d0                	add    %edx,%eax
c01007d9:	8b 40 08             	mov    0x8(%eax),%eax
c01007dc:	85 c0                	test   %eax,%eax
c01007de:	74 97                	je     c0100777 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e6:	39 c2                	cmp    %eax,%edx
c01007e8:	7c 46                	jl     c0100830 <debuginfo_eip+0x2e2>
c01007ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ed:	89 c2                	mov    %eax,%edx
c01007ef:	89 d0                	mov    %edx,%eax
c01007f1:	01 c0                	add    %eax,%eax
c01007f3:	01 d0                	add    %edx,%eax
c01007f5:	c1 e0 02             	shl    $0x2,%eax
c01007f8:	89 c2                	mov    %eax,%edx
c01007fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	8b 10                	mov    (%eax),%edx
c0100801:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100804:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100807:	29 c1                	sub    %eax,%ecx
c0100809:	89 c8                	mov    %ecx,%eax
c010080b:	39 c2                	cmp    %eax,%edx
c010080d:	73 21                	jae    c0100830 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100812:	89 c2                	mov    %eax,%edx
c0100814:	89 d0                	mov    %edx,%eax
c0100816:	01 c0                	add    %eax,%eax
c0100818:	01 d0                	add    %edx,%eax
c010081a:	c1 e0 02             	shl    $0x2,%eax
c010081d:	89 c2                	mov    %eax,%edx
c010081f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100822:	01 d0                	add    %edx,%eax
c0100824:	8b 10                	mov    (%eax),%edx
c0100826:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100829:	01 c2                	add    %eax,%edx
c010082b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100830:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100833:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100836:	39 c2                	cmp    %eax,%edx
c0100838:	7d 4a                	jge    c0100884 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010083a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010083d:	83 c0 01             	add    $0x1,%eax
c0100840:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100843:	eb 18                	jmp    c010085d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100845:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100848:	8b 40 14             	mov    0x14(%eax),%eax
c010084b:	8d 50 01             	lea    0x1(%eax),%edx
c010084e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100851:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100857:	83 c0 01             	add    $0x1,%eax
c010085a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100860:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100863:	39 c2                	cmp    %eax,%edx
c0100865:	7d 1d                	jge    c0100884 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100867:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	89 d0                	mov    %edx,%eax
c010086e:	01 c0                	add    %eax,%eax
c0100870:	01 d0                	add    %edx,%eax
c0100872:	c1 e0 02             	shl    $0x2,%eax
c0100875:	89 c2                	mov    %eax,%edx
c0100877:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087a:	01 d0                	add    %edx,%eax
c010087c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100880:	3c a0                	cmp    $0xa0,%al
c0100882:	74 c1                	je     c0100845 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100884:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100889:	c9                   	leave  
c010088a:	c3                   	ret    

c010088b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010088b:	55                   	push   %ebp
c010088c:	89 e5                	mov    %esp,%ebp
c010088e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100891:	c7 04 24 d6 8c 10 c0 	movl   $0xc0108cd6,(%esp)
c0100898:	e8 ba fa ff ff       	call   c0100357 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010089d:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01008a4:	c0 
c01008a5:	c7 04 24 ef 8c 10 c0 	movl   $0xc0108cef,(%esp)
c01008ac:	e8 a6 fa ff ff       	call   c0100357 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008b1:	c7 44 24 04 04 8c 10 	movl   $0xc0108c04,0x4(%esp)
c01008b8:	c0 
c01008b9:	c7 04 24 07 8d 10 c0 	movl   $0xc0108d07,(%esp)
c01008c0:	e8 92 fa ff ff       	call   c0100357 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c5:	c7 44 24 04 00 30 12 	movl   $0xc0123000,0x4(%esp)
c01008cc:	c0 
c01008cd:	c7 04 24 1f 8d 10 c0 	movl   $0xc0108d1f,(%esp)
c01008d4:	e8 7e fa ff ff       	call   c0100357 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d9:	c7 44 24 04 30 41 12 	movl   $0xc0124130,0x4(%esp)
c01008e0:	c0 
c01008e1:	c7 04 24 37 8d 10 c0 	movl   $0xc0108d37,(%esp)
c01008e8:	e8 6a fa ff ff       	call   c0100357 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008ed:	b8 30 41 12 c0       	mov    $0xc0124130,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008fd:	29 c2                	sub    %eax,%edx
c01008ff:	89 d0                	mov    %edx,%eax
c0100901:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100907:	85 c0                	test   %eax,%eax
c0100909:	0f 48 c2             	cmovs  %edx,%eax
c010090c:	c1 f8 0a             	sar    $0xa,%eax
c010090f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100913:	c7 04 24 50 8d 10 c0 	movl   $0xc0108d50,(%esp)
c010091a:	e8 38 fa ff ff       	call   c0100357 <cprintf>
}
c010091f:	c9                   	leave  
c0100920:	c3                   	ret    

c0100921 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100921:	55                   	push   %ebp
c0100922:	89 e5                	mov    %esp,%ebp
c0100924:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010092a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010092d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 04 24             	mov    %eax,(%esp)
c0100937:	e8 12 fc ff ff       	call   c010054e <debuginfo_eip>
c010093c:	85 c0                	test   %eax,%eax
c010093e:	74 15                	je     c0100955 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100940:	8b 45 08             	mov    0x8(%ebp),%eax
c0100943:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100947:	c7 04 24 7a 8d 10 c0 	movl   $0xc0108d7a,(%esp)
c010094e:	e8 04 fa ff ff       	call   c0100357 <cprintf>
c0100953:	eb 6d                	jmp    c01009c2 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100955:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010095c:	eb 1c                	jmp    c010097a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	0f b6 00             	movzbl (%eax),%eax
c0100969:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100972:	01 ca                	add    %ecx,%edx
c0100974:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100976:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010097a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010097d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100980:	7f dc                	jg     c010095e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100982:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100988:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010098b:	01 d0                	add    %edx,%eax
c010098d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100990:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100993:	8b 55 08             	mov    0x8(%ebp),%edx
c0100996:	89 d1                	mov    %edx,%ecx
c0100998:	29 c1                	sub    %eax,%ecx
c010099a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010099d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01009a0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009aa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009ae:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b6:	c7 04 24 96 8d 10 c0 	movl   $0xc0108d96,(%esp)
c01009bd:	e8 95 f9 ff ff       	call   c0100357 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c2:	c9                   	leave  
c01009c3:	c3                   	ret    

c01009c4 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c4:	55                   	push   %ebp
c01009c5:	89 e5                	mov    %esp,%ebp
c01009c7:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009ca:	8b 45 04             	mov    0x4(%ebp),%eax
c01009cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009d3:	c9                   	leave  
c01009d4:	c3                   	ret    

c01009d5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d5:	55                   	push   %ebp
c01009d6:	89 e5                	mov    %esp,%ebp
c01009d8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009db:	89 e8                	mov    %ebp,%eax
c01009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();
c01009e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e6:	e8 d9 ff ff ff       	call   c01009c4 <read_eip>
c01009eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
c01009ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f5:	e9 88 00 00 00       	jmp    c0100a82 <print_stackframe+0xad>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a08:	c7 04 24 a8 8d 10 c0 	movl   $0xc0108da8,(%esp)
c0100a0f:	e8 43 f9 ff ff       	call   c0100357 <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a17:	83 c0 08             	add    $0x8,%eax
c0100a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(b = 0; b < 4; b ++){
c0100a1d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a24:	eb 25                	jmp    c0100a4b <print_stackframe+0x76>
			cprintf("0x%08x ", args[b]);
c0100a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a33:	01 d0                	add    %edx,%eax
c0100a35:	8b 00                	mov    (%eax),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 c4 8d 10 c0 	movl   $0xc0108dc4,(%esp)
c0100a42:	e8 10 f9 ff ff       	call   c0100357 <cprintf>

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		for(b = 0; b < 4; b ++){
c0100a47:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a4b:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4f:	7e d5                	jle    c0100a26 <print_stackframe+0x51>
			cprintf("0x%08x ", args[b]);
		}
		cprintf("\n");
c0100a51:	c7 04 24 cc 8d 10 c0 	movl   $0xc0108dcc,(%esp)
c0100a58:	e8 fa f8 ff ff       	call   c0100357 <cprintf>
		print_debuginfo(eip - 1);
c0100a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a60:	83 e8 01             	sub    $0x1,%eax
c0100a63:	89 04 24             	mov    %eax,(%esp)
c0100a66:	e8 b6 fe ff ff       	call   c0100921 <print_debuginfo>
		eip = ((uint32_t *)ebp)[1];
c0100a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6e:	83 c0 04             	add    $0x4,%eax
c0100a71:	8b 00                	mov    (%eax),%eax
c0100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t *)ebp)[0];
c0100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a79:	8b 00                	mov    (%eax),%eax
c0100a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
c0100a7e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a86:	74 0a                	je     c0100a92 <print_stackframe+0xbd>
c0100a88:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a8c:	0f 8e 68 ff ff ff    	jle    c01009fa <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = ((uint32_t *)ebp)[1];
		ebp = ((uint32_t *)ebp)[0];
	}
}
c0100a92:	c9                   	leave  
c0100a93:	c3                   	ret    

c0100a94 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a94:	55                   	push   %ebp
c0100a95:	89 e5                	mov    %esp,%ebp
c0100a97:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa1:	eb 0c                	jmp    c0100aaf <parse+0x1b>
            *buf ++ = '\0';
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa9:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aac:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	0f b6 00             	movzbl (%eax),%eax
c0100ab5:	84 c0                	test   %al,%al
c0100ab7:	74 1d                	je     c0100ad6 <parse+0x42>
c0100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abc:	0f b6 00             	movzbl (%eax),%eax
c0100abf:	0f be c0             	movsbl %al,%eax
c0100ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac6:	c7 04 24 50 8e 10 c0 	movl   $0xc0108e50,(%esp)
c0100acd:	e8 ea 7d 00 00       	call   c01088bc <strchr>
c0100ad2:	85 c0                	test   %eax,%eax
c0100ad4:	75 cd                	jne    c0100aa3 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad9:	0f b6 00             	movzbl (%eax),%eax
c0100adc:	84 c0                	test   %al,%al
c0100ade:	75 02                	jne    c0100ae2 <parse+0x4e>
            break;
c0100ae0:	eb 67                	jmp    c0100b49 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ae2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae6:	75 14                	jne    c0100afc <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae8:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aef:	00 
c0100af0:	c7 04 24 55 8e 10 c0 	movl   $0xc0108e55,(%esp)
c0100af7:	e8 5b f8 ff ff       	call   c0100357 <cprintf>
        }
        argv[argc ++] = buf;
c0100afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aff:	8d 50 01             	lea    0x1(%eax),%edx
c0100b02:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0f:	01 c2                	add    %eax,%edx
c0100b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b14:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b16:	eb 04                	jmp    c0100b1c <parse+0x88>
            buf ++;
c0100b18:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1f:	0f b6 00             	movzbl (%eax),%eax
c0100b22:	84 c0                	test   %al,%al
c0100b24:	74 1d                	je     c0100b43 <parse+0xaf>
c0100b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b29:	0f b6 00             	movzbl (%eax),%eax
c0100b2c:	0f be c0             	movsbl %al,%eax
c0100b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b33:	c7 04 24 50 8e 10 c0 	movl   $0xc0108e50,(%esp)
c0100b3a:	e8 7d 7d 00 00       	call   c01088bc <strchr>
c0100b3f:	85 c0                	test   %eax,%eax
c0100b41:	74 d5                	je     c0100b18 <parse+0x84>
            buf ++;
        }
    }
c0100b43:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b44:	e9 66 ff ff ff       	jmp    c0100aaf <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b4c:	c9                   	leave  
c0100b4d:	c3                   	ret    

c0100b4e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4e:	55                   	push   %ebp
c0100b4f:	89 e5                	mov    %esp,%ebp
c0100b51:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b54:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5e:	89 04 24             	mov    %eax,(%esp)
c0100b61:	e8 2e ff ff ff       	call   c0100a94 <parse>
c0100b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b6d:	75 0a                	jne    c0100b79 <runcmd+0x2b>
        return 0;
c0100b6f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b74:	e9 85 00 00 00       	jmp    c0100bfe <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b80:	eb 5c                	jmp    c0100bde <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b82:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b88:	89 d0                	mov    %edx,%eax
c0100b8a:	01 c0                	add    %eax,%eax
c0100b8c:	01 d0                	add    %edx,%eax
c0100b8e:	c1 e0 02             	shl    $0x2,%eax
c0100b91:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100b96:	8b 00                	mov    (%eax),%eax
c0100b98:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b9c:	89 04 24             	mov    %eax,(%esp)
c0100b9f:	e8 79 7c 00 00       	call   c010881d <strcmp>
c0100ba4:	85 c0                	test   %eax,%eax
c0100ba6:	75 32                	jne    c0100bda <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bab:	89 d0                	mov    %edx,%eax
c0100bad:	01 c0                	add    %eax,%eax
c0100baf:	01 d0                	add    %edx,%eax
c0100bb1:	c1 e0 02             	shl    $0x2,%eax
c0100bb4:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100bb9:	8b 40 08             	mov    0x8(%eax),%eax
c0100bbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbf:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc9:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bcc:	83 c2 04             	add    $0x4,%edx
c0100bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bd3:	89 0c 24             	mov    %ecx,(%esp)
c0100bd6:	ff d0                	call   *%eax
c0100bd8:	eb 24                	jmp    c0100bfe <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bda:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be1:	83 f8 02             	cmp    $0x2,%eax
c0100be4:	76 9c                	jbe    c0100b82 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bed:	c7 04 24 73 8e 10 c0 	movl   $0xc0108e73,(%esp)
c0100bf4:	e8 5e f7 ff ff       	call   c0100357 <cprintf>
    return 0;
c0100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfe:	c9                   	leave  
c0100bff:	c3                   	ret    

c0100c00 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c00:	55                   	push   %ebp
c0100c01:	89 e5                	mov    %esp,%ebp
c0100c03:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c06:	c7 04 24 8c 8e 10 c0 	movl   $0xc0108e8c,(%esp)
c0100c0d:	e8 45 f7 ff ff       	call   c0100357 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c12:	c7 04 24 b4 8e 10 c0 	movl   $0xc0108eb4,(%esp)
c0100c19:	e8 39 f7 ff ff       	call   c0100357 <cprintf>

    if (tf != NULL) {
c0100c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c22:	74 0b                	je     c0100c2f <kmonitor+0x2f>
        print_trapframe(tf);
c0100c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c27:	89 04 24             	mov    %eax,(%esp)
c0100c2a:	e8 b5 16 00 00       	call   c01022e4 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2f:	c7 04 24 d9 8e 10 c0 	movl   $0xc0108ed9,(%esp)
c0100c36:	e8 13 f6 ff ff       	call   c010024e <readline>
c0100c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c42:	74 18                	je     c0100c5c <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4e:	89 04 24             	mov    %eax,(%esp)
c0100c51:	e8 f8 fe ff ff       	call   c0100b4e <runcmd>
c0100c56:	85 c0                	test   %eax,%eax
c0100c58:	79 02                	jns    c0100c5c <kmonitor+0x5c>
                break;
c0100c5a:	eb 02                	jmp    c0100c5e <kmonitor+0x5e>
            }
        }
    }
c0100c5c:	eb d1                	jmp    c0100c2f <kmonitor+0x2f>
}
c0100c5e:	c9                   	leave  
c0100c5f:	c3                   	ret    

c0100c60 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c60:	55                   	push   %ebp
c0100c61:	89 e5                	mov    %esp,%ebp
c0100c63:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c6d:	eb 3f                	jmp    c0100cae <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c80:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c86:	89 d0                	mov    %edx,%eax
c0100c88:	01 c0                	add    %eax,%eax
c0100c8a:	01 d0                	add    %edx,%eax
c0100c8c:	c1 e0 02             	shl    $0x2,%eax
c0100c8f:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c94:	8b 00                	mov    (%eax),%eax
c0100c96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9e:	c7 04 24 dd 8e 10 c0 	movl   $0xc0108edd,(%esp)
c0100ca5:	e8 ad f6 ff ff       	call   c0100357 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100caa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb1:	83 f8 02             	cmp    $0x2,%eax
c0100cb4:	76 b9                	jbe    c0100c6f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbb:	c9                   	leave  
c0100cbc:	c3                   	ret    

c0100cbd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cbd:	55                   	push   %ebp
c0100cbe:	89 e5                	mov    %esp,%ebp
c0100cc0:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cc3:	e8 c3 fb ff ff       	call   c010088b <print_kerninfo>
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd5:	e8 fb fc ff ff       	call   c01009d5 <print_stackframe>
    return 0;
c0100cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdf:	c9                   	leave  
c0100ce0:	c3                   	ret    

c0100ce1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ce1:	55                   	push   %ebp
c0100ce2:	89 e5                	mov    %esp,%ebp
c0100ce4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce7:	a1 20 34 12 c0       	mov    0xc0123420,%eax
c0100cec:	85 c0                	test   %eax,%eax
c0100cee:	74 02                	je     c0100cf2 <__panic+0x11>
        goto panic_dead;
c0100cf0:	eb 59                	jmp    c0100d4b <__panic+0x6a>
    }
    is_panic = 1;
c0100cf2:	c7 05 20 34 12 c0 01 	movl   $0x1,0xc0123420
c0100cf9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cfc:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d05:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d10:	c7 04 24 e6 8e 10 c0 	movl   $0xc0108ee6,(%esp)
c0100d17:	e8 3b f6 ff ff       	call   c0100357 <cprintf>
    vcprintf(fmt, ap);
c0100d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d23:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d26:	89 04 24             	mov    %eax,(%esp)
c0100d29:	e8 f6 f5 ff ff       	call   c0100324 <vcprintf>
    cprintf("\n");
c0100d2e:	c7 04 24 02 8f 10 c0 	movl   $0xc0108f02,(%esp)
c0100d35:	e8 1d f6 ff ff       	call   c0100357 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d3a:	c7 04 24 04 8f 10 c0 	movl   $0xc0108f04,(%esp)
c0100d41:	e8 11 f6 ff ff       	call   c0100357 <cprintf>
    print_stackframe();
c0100d46:	e8 8a fc ff ff       	call   c01009d5 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d4b:	e8 fa 11 00 00       	call   c0101f4a <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d57:	e8 a4 fe ff ff       	call   c0100c00 <kmonitor>
    }
c0100d5c:	eb f2                	jmp    c0100d50 <__panic+0x6f>

c0100d5e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d5e:	55                   	push   %ebp
c0100d5f:	89 e5                	mov    %esp,%ebp
c0100d61:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d64:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d6d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d78:	c7 04 24 16 8f 10 c0 	movl   $0xc0108f16,(%esp)
c0100d7f:	e8 d3 f5 ff ff       	call   c0100357 <cprintf>
    vcprintf(fmt, ap);
c0100d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d8e:	89 04 24             	mov    %eax,(%esp)
c0100d91:	e8 8e f5 ff ff       	call   c0100324 <vcprintf>
    cprintf("\n");
c0100d96:	c7 04 24 02 8f 10 c0 	movl   $0xc0108f02,(%esp)
c0100d9d:	e8 b5 f5 ff ff       	call   c0100357 <cprintf>
    va_end(ap);
}
c0100da2:	c9                   	leave  
c0100da3:	c3                   	ret    

c0100da4 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100da4:	55                   	push   %ebp
c0100da5:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100da7:	a1 20 34 12 c0       	mov    0xc0123420,%eax
}
c0100dac:	5d                   	pop    %ebp
c0100dad:	c3                   	ret    

c0100dae <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	83 ec 28             	sub    $0x28,%esp
c0100db4:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100dba:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dbe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dc2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dc6:	ee                   	out    %al,(%dx)
c0100dc7:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dcd:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dd1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd9:	ee                   	out    %al,(%dx)
c0100dda:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100de0:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100de4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100de8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dec:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ded:	c7 05 3c 40 12 c0 00 	movl   $0x0,0xc012403c
c0100df4:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df7:	c7 04 24 34 8f 10 c0 	movl   $0xc0108f34,(%esp)
c0100dfe:	e8 54 f5 ff ff       	call   c0100357 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e0a:	e8 99 11 00 00       	call   c0101fa8 <pic_enable>
}
c0100e0f:	c9                   	leave  
c0100e10:	c3                   	ret    

c0100e11 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e11:	55                   	push   %ebp
c0100e12:	89 e5                	mov    %esp,%ebp
c0100e14:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e17:	9c                   	pushf  
c0100e18:	58                   	pop    %eax
c0100e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e1f:	25 00 02 00 00       	and    $0x200,%eax
c0100e24:	85 c0                	test   %eax,%eax
c0100e26:	74 0c                	je     c0100e34 <__intr_save+0x23>
        intr_disable();
c0100e28:	e8 1d 11 00 00       	call   c0101f4a <intr_disable>
        return 1;
c0100e2d:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e32:	eb 05                	jmp    c0100e39 <__intr_save+0x28>
    }
    return 0;
c0100e34:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e39:	c9                   	leave  
c0100e3a:	c3                   	ret    

c0100e3b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e3b:	55                   	push   %ebp
c0100e3c:	89 e5                	mov    %esp,%ebp
c0100e3e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e45:	74 05                	je     c0100e4c <__intr_restore+0x11>
        intr_enable();
c0100e47:	e8 f8 10 00 00       	call   c0101f44 <intr_enable>
    }
}
c0100e4c:	c9                   	leave  
c0100e4d:	c3                   	ret    

c0100e4e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e4e:	55                   	push   %ebp
c0100e4f:	89 e5                	mov    %esp,%ebp
c0100e51:	83 ec 10             	sub    $0x10,%esp
c0100e54:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e5a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5e:	89 c2                	mov    %eax,%edx
c0100e60:	ec                   	in     (%dx),%al
c0100e61:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e64:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e6a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e6e:	89 c2                	mov    %eax,%edx
c0100e70:	ec                   	in     (%dx),%al
c0100e71:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e74:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e7a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e7e:	89 c2                	mov    %eax,%edx
c0100e80:	ec                   	in     (%dx),%al
c0100e81:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e84:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e8a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e8e:	89 c2                	mov    %eax,%edx
c0100e90:	ec                   	in     (%dx),%al
c0100e91:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e94:	c9                   	leave  
c0100e95:	c3                   	ret    

c0100e96 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e96:	55                   	push   %ebp
c0100e97:	89 e5                	mov    %esp,%ebp
c0100e99:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e9c:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea6:	0f b7 00             	movzwl (%eax),%eax
c0100ea9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb0:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb8:	0f b7 00             	movzwl (%eax),%eax
c0100ebb:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ebf:	74 12                	je     c0100ed3 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec1:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ec8:	66 c7 05 46 34 12 c0 	movw   $0x3b4,0xc0123446
c0100ecf:	b4 03 
c0100ed1:	eb 13                	jmp    c0100ee6 <cga_init+0x50>
    } else {
        *cp = was;
c0100ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eda:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edd:	66 c7 05 46 34 12 c0 	movw   $0x3d4,0xc0123446
c0100ee4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee6:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100eed:	0f b7 c0             	movzwl %ax,%eax
c0100ef0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ef4:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100efc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f00:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f01:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f08:	83 c0 01             	add    $0x1,%eax
c0100f0b:	0f b7 c0             	movzwl %ax,%eax
c0100f0e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f12:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f16:	89 c2                	mov    %eax,%edx
c0100f18:	ec                   	in     (%dx),%al
c0100f19:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f1c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f20:	0f b6 c0             	movzbl %al,%eax
c0100f23:	c1 e0 08             	shl    $0x8,%eax
c0100f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f29:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f30:	0f b7 c0             	movzwl %ax,%eax
c0100f33:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f37:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f3b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f43:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f44:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f4b:	83 c0 01             	add    $0x1,%eax
c0100f4e:	0f b7 c0             	movzwl %ax,%eax
c0100f51:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f55:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f59:	89 c2                	mov    %eax,%edx
c0100f5b:	ec                   	in     (%dx),%al
c0100f5c:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f5f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f63:	0f b6 c0             	movzbl %al,%eax
c0100f66:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f6c:	a3 40 34 12 c0       	mov    %eax,0xc0123440
    crt_pos = pos;
c0100f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f74:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
}
c0100f7a:	c9                   	leave  
c0100f7b:	c3                   	ret    

c0100f7c <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f7c:	55                   	push   %ebp
c0100f7d:	89 e5                	mov    %esp,%ebp
c0100f7f:	83 ec 48             	sub    $0x48,%esp
c0100f82:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f88:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f90:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
c0100f95:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f9b:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f9f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fa3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fa7:	ee                   	out    %al,(%dx)
c0100fa8:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fae:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fb2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fb6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fba:	ee                   	out    %al,(%dx)
c0100fbb:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc1:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fc5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fcd:	ee                   	out    %al,(%dx)
c0100fce:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fd4:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fe0:	ee                   	out    %al,(%dx)
c0100fe1:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fe7:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100feb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fef:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff3:	ee                   	out    %al,(%dx)
c0100ff4:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ffa:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ffe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101002:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101006:	ee                   	out    %al,(%dx)
c0101007:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100d:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101011:	89 c2                	mov    %eax,%edx
c0101013:	ec                   	in     (%dx),%al
c0101014:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101017:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010101b:	3c ff                	cmp    $0xff,%al
c010101d:	0f 95 c0             	setne  %al
c0101020:	0f b6 c0             	movzbl %al,%eax
c0101023:	a3 48 34 12 c0       	mov    %eax,0xc0123448
c0101028:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010102e:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101032:	89 c2                	mov    %eax,%edx
c0101034:	ec                   	in     (%dx),%al
c0101035:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101038:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010103e:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101042:	89 c2                	mov    %eax,%edx
c0101044:	ec                   	in     (%dx),%al
c0101045:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101048:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c010104d:	85 c0                	test   %eax,%eax
c010104f:	74 0c                	je     c010105d <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101051:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101058:	e8 4b 0f 00 00       	call   c0101fa8 <pic_enable>
    }
}
c010105d:	c9                   	leave  
c010105e:	c3                   	ret    

c010105f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010105f:	55                   	push   %ebp
c0101060:	89 e5                	mov    %esp,%ebp
c0101062:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101065:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010106c:	eb 09                	jmp    c0101077 <lpt_putc_sub+0x18>
        delay();
c010106e:	e8 db fd ff ff       	call   c0100e4e <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101073:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101077:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010107d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101081:	89 c2                	mov    %eax,%edx
c0101083:	ec                   	in     (%dx),%al
c0101084:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101087:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010108b:	84 c0                	test   %al,%al
c010108d:	78 09                	js     c0101098 <lpt_putc_sub+0x39>
c010108f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101096:	7e d6                	jle    c010106e <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101098:	8b 45 08             	mov    0x8(%ebp),%eax
c010109b:	0f b6 c0             	movzbl %al,%eax
c010109e:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010a4:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010a7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010ab:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010af:	ee                   	out    %al,(%dx)
c01010b0:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010b6:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010ba:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010be:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010c2:	ee                   	out    %al,(%dx)
c01010c3:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010c9:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010cd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010d1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d5:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010d6:	c9                   	leave  
c01010d7:	c3                   	ret    

c01010d8 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010d8:	55                   	push   %ebp
c01010d9:	89 e5                	mov    %esp,%ebp
c01010db:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010de:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010e2:	74 0d                	je     c01010f1 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e7:	89 04 24             	mov    %eax,(%esp)
c01010ea:	e8 70 ff ff ff       	call   c010105f <lpt_putc_sub>
c01010ef:	eb 24                	jmp    c0101115 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f8:	e8 62 ff ff ff       	call   c010105f <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010fd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101104:	e8 56 ff ff ff       	call   c010105f <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101109:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101110:	e8 4a ff ff ff       	call   c010105f <lpt_putc_sub>
    }
}
c0101115:	c9                   	leave  
c0101116:	c3                   	ret    

c0101117 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101117:	55                   	push   %ebp
c0101118:	89 e5                	mov    %esp,%ebp
c010111a:	53                   	push   %ebx
c010111b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010111e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101121:	b0 00                	mov    $0x0,%al
c0101123:	85 c0                	test   %eax,%eax
c0101125:	75 07                	jne    c010112e <cga_putc+0x17>
        c |= 0x0700;
c0101127:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010112e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101131:	0f b6 c0             	movzbl %al,%eax
c0101134:	83 f8 0a             	cmp    $0xa,%eax
c0101137:	74 4c                	je     c0101185 <cga_putc+0x6e>
c0101139:	83 f8 0d             	cmp    $0xd,%eax
c010113c:	74 57                	je     c0101195 <cga_putc+0x7e>
c010113e:	83 f8 08             	cmp    $0x8,%eax
c0101141:	0f 85 88 00 00 00    	jne    c01011cf <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101147:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010114e:	66 85 c0             	test   %ax,%ax
c0101151:	74 30                	je     c0101183 <cga_putc+0x6c>
            crt_pos --;
c0101153:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010115a:	83 e8 01             	sub    $0x1,%eax
c010115d:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101163:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101168:	0f b7 15 44 34 12 c0 	movzwl 0xc0123444,%edx
c010116f:	0f b7 d2             	movzwl %dx,%edx
c0101172:	01 d2                	add    %edx,%edx
c0101174:	01 c2                	add    %eax,%edx
c0101176:	8b 45 08             	mov    0x8(%ebp),%eax
c0101179:	b0 00                	mov    $0x0,%al
c010117b:	83 c8 20             	or     $0x20,%eax
c010117e:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101181:	eb 72                	jmp    c01011f5 <cga_putc+0xde>
c0101183:	eb 70                	jmp    c01011f5 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101185:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010118c:	83 c0 50             	add    $0x50,%eax
c010118f:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101195:	0f b7 1d 44 34 12 c0 	movzwl 0xc0123444,%ebx
c010119c:	0f b7 0d 44 34 12 c0 	movzwl 0xc0123444,%ecx
c01011a3:	0f b7 c1             	movzwl %cx,%eax
c01011a6:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011ac:	c1 e8 10             	shr    $0x10,%eax
c01011af:	89 c2                	mov    %eax,%edx
c01011b1:	66 c1 ea 06          	shr    $0x6,%dx
c01011b5:	89 d0                	mov    %edx,%eax
c01011b7:	c1 e0 02             	shl    $0x2,%eax
c01011ba:	01 d0                	add    %edx,%eax
c01011bc:	c1 e0 04             	shl    $0x4,%eax
c01011bf:	29 c1                	sub    %eax,%ecx
c01011c1:	89 ca                	mov    %ecx,%edx
c01011c3:	89 d8                	mov    %ebx,%eax
c01011c5:	29 d0                	sub    %edx,%eax
c01011c7:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
        break;
c01011cd:	eb 26                	jmp    c01011f5 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011cf:	8b 0d 40 34 12 c0    	mov    0xc0123440,%ecx
c01011d5:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011dc:	8d 50 01             	lea    0x1(%eax),%edx
c01011df:	66 89 15 44 34 12 c0 	mov    %dx,0xc0123444
c01011e6:	0f b7 c0             	movzwl %ax,%eax
c01011e9:	01 c0                	add    %eax,%eax
c01011eb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f1:	66 89 02             	mov    %ax,(%edx)
        break;
c01011f4:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f5:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011fc:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101200:	76 5b                	jbe    c010125d <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101202:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101207:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010120d:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101212:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101219:	00 
c010121a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010121e:	89 04 24             	mov    %eax,(%esp)
c0101221:	e8 94 78 00 00       	call   c0108aba <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101226:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010122d:	eb 15                	jmp    c0101244 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010122f:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101234:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101237:	01 d2                	add    %edx,%edx
c0101239:	01 d0                	add    %edx,%eax
c010123b:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101240:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101244:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010124b:	7e e2                	jle    c010122f <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010124d:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101254:	83 e8 50             	sub    $0x50,%eax
c0101257:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010125d:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0101264:	0f b7 c0             	movzwl %ax,%eax
c0101267:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010126b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010126f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101273:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101277:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101278:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010127f:	66 c1 e8 08          	shr    $0x8,%ax
c0101283:	0f b6 c0             	movzbl %al,%eax
c0101286:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c010128d:	83 c2 01             	add    $0x1,%edx
c0101290:	0f b7 d2             	movzwl %dx,%edx
c0101293:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101297:	88 45 ed             	mov    %al,-0x13(%ebp)
c010129a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010129e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a3:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c01012aa:	0f b7 c0             	movzwl %ax,%eax
c01012ad:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012b1:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012be:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01012c5:	0f b6 c0             	movzbl %al,%eax
c01012c8:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c01012cf:	83 c2 01             	add    $0x1,%edx
c01012d2:	0f b7 d2             	movzwl %dx,%edx
c01012d5:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012d9:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012dc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012e0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e4:	ee                   	out    %al,(%dx)
}
c01012e5:	83 c4 34             	add    $0x34,%esp
c01012e8:	5b                   	pop    %ebx
c01012e9:	5d                   	pop    %ebp
c01012ea:	c3                   	ret    

c01012eb <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012eb:	55                   	push   %ebp
c01012ec:	89 e5                	mov    %esp,%ebp
c01012ee:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f8:	eb 09                	jmp    c0101303 <serial_putc_sub+0x18>
        delay();
c01012fa:	e8 4f fb ff ff       	call   c0100e4e <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101303:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101309:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010130d:	89 c2                	mov    %eax,%edx
c010130f:	ec                   	in     (%dx),%al
c0101310:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101313:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101317:	0f b6 c0             	movzbl %al,%eax
c010131a:	83 e0 20             	and    $0x20,%eax
c010131d:	85 c0                	test   %eax,%eax
c010131f:	75 09                	jne    c010132a <serial_putc_sub+0x3f>
c0101321:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101328:	7e d0                	jle    c01012fa <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010132a:	8b 45 08             	mov    0x8(%ebp),%eax
c010132d:	0f b6 c0             	movzbl %al,%eax
c0101330:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101336:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101339:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010133d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101341:	ee                   	out    %al,(%dx)
}
c0101342:	c9                   	leave  
c0101343:	c3                   	ret    

c0101344 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101344:	55                   	push   %ebp
c0101345:	89 e5                	mov    %esp,%ebp
c0101347:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010134a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010134e:	74 0d                	je     c010135d <serial_putc+0x19>
        serial_putc_sub(c);
c0101350:	8b 45 08             	mov    0x8(%ebp),%eax
c0101353:	89 04 24             	mov    %eax,(%esp)
c0101356:	e8 90 ff ff ff       	call   c01012eb <serial_putc_sub>
c010135b:	eb 24                	jmp    c0101381 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010135d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101364:	e8 82 ff ff ff       	call   c01012eb <serial_putc_sub>
        serial_putc_sub(' ');
c0101369:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101370:	e8 76 ff ff ff       	call   c01012eb <serial_putc_sub>
        serial_putc_sub('\b');
c0101375:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010137c:	e8 6a ff ff ff       	call   c01012eb <serial_putc_sub>
    }
}
c0101381:	c9                   	leave  
c0101382:	c3                   	ret    

c0101383 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101383:	55                   	push   %ebp
c0101384:	89 e5                	mov    %esp,%ebp
c0101386:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101389:	eb 33                	jmp    c01013be <cons_intr+0x3b>
        if (c != 0) {
c010138b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010138f:	74 2d                	je     c01013be <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101391:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101396:	8d 50 01             	lea    0x1(%eax),%edx
c0101399:	89 15 64 36 12 c0    	mov    %edx,0xc0123664
c010139f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013a2:	88 90 60 34 12 c0    	mov    %dl,-0x3fedcba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a8:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c01013ad:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013b2:	75 0a                	jne    c01013be <cons_intr+0x3b>
                cons.wpos = 0;
c01013b4:	c7 05 64 36 12 c0 00 	movl   $0x0,0xc0123664
c01013bb:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013be:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c1:	ff d0                	call   *%eax
c01013c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ca:	75 bf                	jne    c010138b <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013cc:	c9                   	leave  
c01013cd:	c3                   	ret    

c01013ce <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 10             	sub    $0x10,%esp
c01013d4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013da:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013de:	89 c2                	mov    %eax,%edx
c01013e0:	ec                   	in     (%dx),%al
c01013e1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013e4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e8:	0f b6 c0             	movzbl %al,%eax
c01013eb:	83 e0 01             	and    $0x1,%eax
c01013ee:	85 c0                	test   %eax,%eax
c01013f0:	75 07                	jne    c01013f9 <serial_proc_data+0x2b>
        return -1;
c01013f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f7:	eb 2a                	jmp    c0101423 <serial_proc_data+0x55>
c01013f9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ff:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101403:	89 c2                	mov    %eax,%edx
c0101405:	ec                   	in     (%dx),%al
c0101406:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101409:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010140d:	0f b6 c0             	movzbl %al,%eax
c0101410:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101413:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101417:	75 07                	jne    c0101420 <serial_proc_data+0x52>
        c = '\b';
c0101419:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101423:	c9                   	leave  
c0101424:	c3                   	ret    

c0101425 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101425:	55                   	push   %ebp
c0101426:	89 e5                	mov    %esp,%ebp
c0101428:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010142b:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c0101430:	85 c0                	test   %eax,%eax
c0101432:	74 0c                	je     c0101440 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101434:	c7 04 24 ce 13 10 c0 	movl   $0xc01013ce,(%esp)
c010143b:	e8 43 ff ff ff       	call   c0101383 <cons_intr>
    }
}
c0101440:	c9                   	leave  
c0101441:	c3                   	ret    

c0101442 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101442:	55                   	push   %ebp
c0101443:	89 e5                	mov    %esp,%ebp
c0101445:	83 ec 38             	sub    $0x38,%esp
c0101448:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101452:	89 c2                	mov    %eax,%edx
c0101454:	ec                   	in     (%dx),%al
c0101455:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101458:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010145c:	0f b6 c0             	movzbl %al,%eax
c010145f:	83 e0 01             	and    $0x1,%eax
c0101462:	85 c0                	test   %eax,%eax
c0101464:	75 0a                	jne    c0101470 <kbd_proc_data+0x2e>
        return -1;
c0101466:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010146b:	e9 59 01 00 00       	jmp    c01015c9 <kbd_proc_data+0x187>
c0101470:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101476:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010147a:	89 c2                	mov    %eax,%edx
c010147c:	ec                   	in     (%dx),%al
c010147d:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101480:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101484:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101487:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010148b:	75 17                	jne    c01014a4 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010148d:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101492:	83 c8 40             	or     $0x40,%eax
c0101495:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c010149a:	b8 00 00 00 00       	mov    $0x0,%eax
c010149f:	e9 25 01 00 00       	jmp    c01015c9 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	84 c0                	test   %al,%al
c01014aa:	79 47                	jns    c01014f3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014ac:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01014b1:	83 e0 40             	and    $0x40,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	75 09                	jne    c01014c1 <kbd_proc_data+0x7f>
c01014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014bc:	83 e0 7f             	and    $0x7f,%eax
c01014bf:	eb 04                	jmp    c01014c5 <kbd_proc_data+0x83>
c01014c1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c5:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014cc:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c01014d3:	83 c8 40             	or     $0x40,%eax
c01014d6:	0f b6 c0             	movzbl %al,%eax
c01014d9:	f7 d0                	not    %eax
c01014db:	89 c2                	mov    %eax,%edx
c01014dd:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01014e2:	21 d0                	and    %edx,%eax
c01014e4:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c01014e9:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ee:	e9 d6 00 00 00       	jmp    c01015c9 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014f3:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01014f8:	83 e0 40             	and    $0x40,%eax
c01014fb:	85 c0                	test   %eax,%eax
c01014fd:	74 11                	je     c0101510 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ff:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101503:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101508:	83 e0 bf             	and    $0xffffffbf,%eax
c010150b:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    }

    shift |= shiftcode[data];
c0101510:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101514:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c010151b:	0f b6 d0             	movzbl %al,%edx
c010151e:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101523:	09 d0                	or     %edx,%eax
c0101525:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    shift ^= togglecode[data];
c010152a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152e:	0f b6 80 40 01 12 c0 	movzbl -0x3fedfec0(%eax),%eax
c0101535:	0f b6 d0             	movzbl %al,%edx
c0101538:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c010153d:	31 d0                	xor    %edx,%eax
c010153f:	a3 68 36 12 c0       	mov    %eax,0xc0123668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101544:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101549:	83 e0 03             	and    $0x3,%eax
c010154c:	8b 14 85 40 05 12 c0 	mov    -0x3fedfac0(,%eax,4),%edx
c0101553:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101557:	01 d0                	add    %edx,%eax
c0101559:	0f b6 00             	movzbl (%eax),%eax
c010155c:	0f b6 c0             	movzbl %al,%eax
c010155f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101562:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101567:	83 e0 08             	and    $0x8,%eax
c010156a:	85 c0                	test   %eax,%eax
c010156c:	74 22                	je     c0101590 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010156e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101572:	7e 0c                	jle    c0101580 <kbd_proc_data+0x13e>
c0101574:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101578:	7f 06                	jg     c0101580 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010157a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010157e:	eb 10                	jmp    c0101590 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101580:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101584:	7e 0a                	jle    c0101590 <kbd_proc_data+0x14e>
c0101586:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010158a:	7f 04                	jg     c0101590 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010158c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101590:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101595:	f7 d0                	not    %eax
c0101597:	83 e0 06             	and    $0x6,%eax
c010159a:	85 c0                	test   %eax,%eax
c010159c:	75 28                	jne    c01015c6 <kbd_proc_data+0x184>
c010159e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a5:	75 1f                	jne    c01015c6 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015a7:	c7 04 24 4f 8f 10 c0 	movl   $0xc0108f4f,(%esp)
c01015ae:	e8 a4 ed ff ff       	call   c0100357 <cprintf>
c01015b3:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b9:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015bd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015c1:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015c5:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c9:	c9                   	leave  
c01015ca:	c3                   	ret    

c01015cb <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015cb:	55                   	push   %ebp
c01015cc:	89 e5                	mov    %esp,%ebp
c01015ce:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015d1:	c7 04 24 42 14 10 c0 	movl   $0xc0101442,(%esp)
c01015d8:	e8 a6 fd ff ff       	call   c0101383 <cons_intr>
}
c01015dd:	c9                   	leave  
c01015de:	c3                   	ret    

c01015df <kbd_init>:

static void
kbd_init(void) {
c01015df:	55                   	push   %ebp
c01015e0:	89 e5                	mov    %esp,%ebp
c01015e2:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015e5:	e8 e1 ff ff ff       	call   c01015cb <kbd_intr>
    pic_enable(IRQ_KBD);
c01015ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015f1:	e8 b2 09 00 00       	call   c0101fa8 <pic_enable>
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015fe:	e8 93 f8 ff ff       	call   c0100e96 <cga_init>
    serial_init();
c0101603:	e8 74 f9 ff ff       	call   c0100f7c <serial_init>
    kbd_init();
c0101608:	e8 d2 ff ff ff       	call   c01015df <kbd_init>
    if (!serial_exists) {
c010160d:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c0101612:	85 c0                	test   %eax,%eax
c0101614:	75 0c                	jne    c0101622 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101616:	c7 04 24 5b 8f 10 c0 	movl   $0xc0108f5b,(%esp)
c010161d:	e8 35 ed ff ff       	call   c0100357 <cprintf>
    }
}
c0101622:	c9                   	leave  
c0101623:	c3                   	ret    

c0101624 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101624:	55                   	push   %ebp
c0101625:	89 e5                	mov    %esp,%ebp
c0101627:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010162a:	e8 e2 f7 ff ff       	call   c0100e11 <__intr_save>
c010162f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 9b fa ff ff       	call   c01010d8 <lpt_putc>
        cga_putc(c);
c010163d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 cf fa ff ff       	call   c0101117 <cga_putc>
        serial_putc(c);
c0101648:	8b 45 08             	mov    0x8(%ebp),%eax
c010164b:	89 04 24             	mov    %eax,(%esp)
c010164e:	e8 f1 fc ff ff       	call   c0101344 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101656:	89 04 24             	mov    %eax,(%esp)
c0101659:	e8 dd f7 ff ff       	call   c0100e3b <__intr_restore>
}
c010165e:	c9                   	leave  
c010165f:	c3                   	ret    

c0101660 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101660:	55                   	push   %ebp
c0101661:	89 e5                	mov    %esp,%ebp
c0101663:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101666:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010166d:	e8 9f f7 ff ff       	call   c0100e11 <__intr_save>
c0101672:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101675:	e8 ab fd ff ff       	call   c0101425 <serial_intr>
        kbd_intr();
c010167a:	e8 4c ff ff ff       	call   c01015cb <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167f:	8b 15 60 36 12 c0    	mov    0xc0123660,%edx
c0101685:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c010168a:	39 c2                	cmp    %eax,%edx
c010168c:	74 31                	je     c01016bf <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168e:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c0101693:	8d 50 01             	lea    0x1(%eax),%edx
c0101696:	89 15 60 36 12 c0    	mov    %edx,0xc0123660
c010169c:	0f b6 80 60 34 12 c0 	movzbl -0x3fedcba0(%eax),%eax
c01016a3:	0f b6 c0             	movzbl %al,%eax
c01016a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a9:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c01016ae:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016b3:	75 0a                	jne    c01016bf <cons_getc+0x5f>
                cons.rpos = 0;
c01016b5:	c7 05 60 36 12 c0 00 	movl   $0x0,0xc0123660
c01016bc:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016c2:	89 04 24             	mov    %eax,(%esp)
c01016c5:	e8 71 f7 ff ff       	call   c0100e3b <__intr_restore>
    return c;
c01016ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016cd:	c9                   	leave  
c01016ce:	c3                   	ret    

c01016cf <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016cf:	55                   	push   %ebp
c01016d0:	89 e5                	mov    %esp,%ebp
c01016d2:	83 ec 14             	sub    $0x14,%esp
c01016d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016dc:	90                   	nop
c01016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e1:	83 c0 07             	add    $0x7,%eax
c01016e4:	0f b7 c0             	movzwl %ax,%eax
c01016e7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016eb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016ef:	89 c2                	mov    %eax,%edx
c01016f1:	ec                   	in     (%dx),%al
c01016f2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016f5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016f9:	0f b6 c0             	movzbl %al,%eax
c01016fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101702:	25 80 00 00 00       	and    $0x80,%eax
c0101707:	85 c0                	test   %eax,%eax
c0101709:	75 d2                	jne    c01016dd <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c010170b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010170f:	74 11                	je     c0101722 <ide_wait_ready+0x53>
c0101711:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101714:	83 e0 21             	and    $0x21,%eax
c0101717:	85 c0                	test   %eax,%eax
c0101719:	74 07                	je     c0101722 <ide_wait_ready+0x53>
        return -1;
c010171b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101720:	eb 05                	jmp    c0101727 <ide_wait_ready+0x58>
    }
    return 0;
c0101722:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101727:	c9                   	leave  
c0101728:	c3                   	ret    

c0101729 <ide_init>:

void
ide_init(void) {
c0101729:	55                   	push   %ebp
c010172a:	89 e5                	mov    %esp,%ebp
c010172c:	57                   	push   %edi
c010172d:	53                   	push   %ebx
c010172e:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101734:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010173a:	e9 d6 02 00 00       	jmp    c0101a15 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010173f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101743:	c1 e0 03             	shl    $0x3,%eax
c0101746:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010174d:	29 c2                	sub    %eax,%edx
c010174f:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101755:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101758:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010175c:	66 d1 e8             	shr    %ax
c010175f:	0f b7 c0             	movzwl %ax,%eax
c0101762:	0f b7 04 85 7c 8f 10 	movzwl -0x3fef7084(,%eax,4),%eax
c0101769:	c0 
c010176a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c010176e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101772:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101779:	00 
c010177a:	89 04 24             	mov    %eax,(%esp)
c010177d:	e8 4d ff ff ff       	call   c01016cf <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101782:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101786:	83 e0 01             	and    $0x1,%eax
c0101789:	c1 e0 04             	shl    $0x4,%eax
c010178c:	83 c8 e0             	or     $0xffffffe0,%eax
c010178f:	0f b6 c0             	movzbl %al,%eax
c0101792:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101796:	83 c2 06             	add    $0x6,%edx
c0101799:	0f b7 d2             	movzwl %dx,%edx
c010179c:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c01017a0:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017a7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017ab:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017ac:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017b7:	00 
c01017b8:	89 04 24             	mov    %eax,(%esp)
c01017bb:	e8 0f ff ff ff       	call   c01016cf <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017c0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c4:	83 c0 07             	add    $0x7,%eax
c01017c7:	0f b7 c0             	movzwl %ax,%eax
c01017ca:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017ce:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017d2:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017d6:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017da:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017db:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017e6:	00 
c01017e7:	89 04 24             	mov    %eax,(%esp)
c01017ea:	e8 e0 fe ff ff       	call   c01016cf <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017ef:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017f3:	83 c0 07             	add    $0x7,%eax
c01017f6:	0f b7 c0             	movzwl %ax,%eax
c01017f9:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017fd:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0101801:	89 c2                	mov    %eax,%edx
c0101803:	ec                   	in     (%dx),%al
c0101804:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0101807:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010180b:	84 c0                	test   %al,%al
c010180d:	0f 84 f7 01 00 00    	je     c0101a0a <ide_init+0x2e1>
c0101813:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101817:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010181e:	00 
c010181f:	89 04 24             	mov    %eax,(%esp)
c0101822:	e8 a8 fe ff ff       	call   c01016cf <ide_wait_ready>
c0101827:	85 c0                	test   %eax,%eax
c0101829:	0f 85 db 01 00 00    	jne    c0101a0a <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010182f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101833:	c1 e0 03             	shl    $0x3,%eax
c0101836:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010183d:	29 c2                	sub    %eax,%edx
c010183f:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101845:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101848:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010184c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010184f:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101855:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101858:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010185f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101862:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101865:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101868:	89 cb                	mov    %ecx,%ebx
c010186a:	89 df                	mov    %ebx,%edi
c010186c:	89 c1                	mov    %eax,%ecx
c010186e:	fc                   	cld    
c010186f:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101871:	89 c8                	mov    %ecx,%eax
c0101873:	89 fb                	mov    %edi,%ebx
c0101875:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101878:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010187b:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101887:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010188d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101890:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101893:	25 00 00 00 04       	and    $0x4000000,%eax
c0101898:	85 c0                	test   %eax,%eax
c010189a:	74 0e                	je     c01018aa <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010189c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010189f:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c01018a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01018a8:	eb 09                	jmp    c01018b3 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c01018aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ad:	8b 40 78             	mov    0x78(%eax),%eax
c01018b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c01018b3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b7:	c1 e0 03             	shl    $0x3,%eax
c01018ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c1:	29 c2                	sub    %eax,%edx
c01018c3:	81 c2 80 36 12 c0    	add    $0xc0123680,%edx
c01018c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018cc:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018cf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018d3:	c1 e0 03             	shl    $0x3,%eax
c01018d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018dd:	29 c2                	sub    %eax,%edx
c01018df:	81 c2 80 36 12 c0    	add    $0xc0123680,%edx
c01018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018e8:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018ee:	83 c0 62             	add    $0x62,%eax
c01018f1:	0f b7 00             	movzwl (%eax),%eax
c01018f4:	0f b7 c0             	movzwl %ax,%eax
c01018f7:	25 00 02 00 00       	and    $0x200,%eax
c01018fc:	85 c0                	test   %eax,%eax
c01018fe:	75 24                	jne    c0101924 <ide_init+0x1fb>
c0101900:	c7 44 24 0c 84 8f 10 	movl   $0xc0108f84,0xc(%esp)
c0101907:	c0 
c0101908:	c7 44 24 08 c7 8f 10 	movl   $0xc0108fc7,0x8(%esp)
c010190f:	c0 
c0101910:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101917:	00 
c0101918:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c010191f:	e8 bd f3 ff ff       	call   c0100ce1 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101924:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101928:	c1 e0 03             	shl    $0x3,%eax
c010192b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101932:	29 c2                	sub    %eax,%edx
c0101934:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c010193a:	83 c0 0c             	add    $0xc,%eax
c010193d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101943:	83 c0 36             	add    $0x36,%eax
c0101946:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101949:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101950:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101957:	eb 34                	jmp    c010198d <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101959:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010195f:	01 c2                	add    %eax,%edx
c0101961:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101964:	8d 48 01             	lea    0x1(%eax),%ecx
c0101967:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010196a:	01 c8                	add    %ecx,%eax
c010196c:	0f b6 00             	movzbl (%eax),%eax
c010196f:	88 02                	mov    %al,(%edx)
c0101971:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101974:	8d 50 01             	lea    0x1(%eax),%edx
c0101977:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010197a:	01 c2                	add    %eax,%edx
c010197c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101982:	01 c8                	add    %ecx,%eax
c0101984:	0f b6 00             	movzbl (%eax),%eax
c0101987:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101989:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010198d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101990:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101993:	72 c4                	jb     c0101959 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101998:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199b:	01 d0                	add    %edx,%eax
c010199d:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c01019a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019a3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01019a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01019a9:	85 c0                	test   %eax,%eax
c01019ab:	74 0f                	je     c01019bc <ide_init+0x293>
c01019ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01019b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01019b3:	01 d0                	add    %edx,%eax
c01019b5:	0f b6 00             	movzbl (%eax),%eax
c01019b8:	3c 20                	cmp    $0x20,%al
c01019ba:	74 d9                	je     c0101995 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019bc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c0:	c1 e0 03             	shl    $0x3,%eax
c01019c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ca:	29 c2                	sub    %eax,%edx
c01019cc:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c01019d2:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019d5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d9:	c1 e0 03             	shl    $0x3,%eax
c01019dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019e3:	29 c2                	sub    %eax,%edx
c01019e5:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c01019eb:	8b 50 08             	mov    0x8(%eax),%edx
c01019ee:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019f6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fe:	c7 04 24 ee 8f 10 c0 	movl   $0xc0108fee,(%esp)
c0101a05:	e8 4d e9 ff ff       	call   c0100357 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101a0a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0e:	83 c0 01             	add    $0x1,%eax
c0101a11:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a15:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a1a:	0f 86 1f fd ff ff    	jbe    c010173f <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a20:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a27:	e8 7c 05 00 00       	call   c0101fa8 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a2c:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a33:	e8 70 05 00 00       	call   c0101fa8 <pic_enable>
}
c0101a38:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a3e:	5b                   	pop    %ebx
c0101a3f:	5f                   	pop    %edi
c0101a40:	5d                   	pop    %ebp
c0101a41:	c3                   	ret    

c0101a42 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a42:	55                   	push   %ebp
c0101a43:	89 e5                	mov    %esp,%ebp
c0101a45:	83 ec 04             	sub    $0x4,%esp
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a4f:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a54:	77 24                	ja     c0101a7a <ide_device_valid+0x38>
c0101a56:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a5a:	c1 e0 03             	shl    $0x3,%eax
c0101a5d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a64:	29 c2                	sub    %eax,%edx
c0101a66:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101a6c:	0f b6 00             	movzbl (%eax),%eax
c0101a6f:	84 c0                	test   %al,%al
c0101a71:	74 07                	je     c0101a7a <ide_device_valid+0x38>
c0101a73:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a78:	eb 05                	jmp    c0101a7f <ide_device_valid+0x3d>
c0101a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a7f:	c9                   	leave  
c0101a80:	c3                   	ret    

c0101a81 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a81:	55                   	push   %ebp
c0101a82:	89 e5                	mov    %esp,%ebp
c0101a84:	83 ec 08             	sub    $0x8,%esp
c0101a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a8e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a92:	89 04 24             	mov    %eax,(%esp)
c0101a95:	e8 a8 ff ff ff       	call   c0101a42 <ide_device_valid>
c0101a9a:	85 c0                	test   %eax,%eax
c0101a9c:	74 1b                	je     c0101ab9 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a9e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aa2:	c1 e0 03             	shl    $0x3,%eax
c0101aa5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aac:	29 c2                	sub    %eax,%edx
c0101aae:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101ab4:	8b 40 08             	mov    0x8(%eax),%eax
c0101ab7:	eb 05                	jmp    c0101abe <ide_device_size+0x3d>
    }
    return 0;
c0101ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101abe:	c9                   	leave  
c0101abf:	c3                   	ret    

c0101ac0 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ac0:	55                   	push   %ebp
c0101ac1:	89 e5                	mov    %esp,%ebp
c0101ac3:	57                   	push   %edi
c0101ac4:	53                   	push   %ebx
c0101ac5:	83 ec 50             	sub    $0x50,%esp
c0101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acb:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101acf:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ad6:	77 24                	ja     c0101afc <ide_read_secs+0x3c>
c0101ad8:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101add:	77 1d                	ja     c0101afc <ide_read_secs+0x3c>
c0101adf:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ae3:	c1 e0 03             	shl    $0x3,%eax
c0101ae6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aed:	29 c2                	sub    %eax,%edx
c0101aef:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101af5:	0f b6 00             	movzbl (%eax),%eax
c0101af8:	84 c0                	test   %al,%al
c0101afa:	75 24                	jne    c0101b20 <ide_read_secs+0x60>
c0101afc:	c7 44 24 0c 0c 90 10 	movl   $0xc010900c,0xc(%esp)
c0101b03:	c0 
c0101b04:	c7 44 24 08 c7 8f 10 	movl   $0xc0108fc7,0x8(%esp)
c0101b0b:	c0 
c0101b0c:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101b13:	00 
c0101b14:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c0101b1b:	e8 c1 f1 ff ff       	call   c0100ce1 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b20:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b27:	77 0f                	ja     c0101b38 <ide_read_secs+0x78>
c0101b29:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b2f:	01 d0                	add    %edx,%eax
c0101b31:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b36:	76 24                	jbe    c0101b5c <ide_read_secs+0x9c>
c0101b38:	c7 44 24 0c 34 90 10 	movl   $0xc0109034,0xc(%esp)
c0101b3f:	c0 
c0101b40:	c7 44 24 08 c7 8f 10 	movl   $0xc0108fc7,0x8(%esp)
c0101b47:	c0 
c0101b48:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b4f:	00 
c0101b50:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c0101b57:	e8 85 f1 ff ff       	call   c0100ce1 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b60:	66 d1 e8             	shr    %ax
c0101b63:	0f b7 c0             	movzwl %ax,%eax
c0101b66:	0f b7 04 85 7c 8f 10 	movzwl -0x3fef7084(,%eax,4),%eax
c0101b6d:	c0 
c0101b6e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b72:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b76:	66 d1 e8             	shr    %ax
c0101b79:	0f b7 c0             	movzwl %ax,%eax
c0101b7c:	0f b7 04 85 7e 8f 10 	movzwl -0x3fef7082(,%eax,4),%eax
c0101b83:	c0 
c0101b84:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b88:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b93:	00 
c0101b94:	89 04 24             	mov    %eax,(%esp)
c0101b97:	e8 33 fb ff ff       	call   c01016cf <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b9c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ba0:	83 c0 02             	add    $0x2,%eax
c0101ba3:	0f b7 c0             	movzwl %ax,%eax
c0101ba6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101baa:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bae:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101bb2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101bb6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101bb7:	8b 45 14             	mov    0x14(%ebp),%eax
c0101bba:	0f b6 c0             	movzbl %al,%eax
c0101bbd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc1:	83 c2 02             	add    $0x2,%edx
c0101bc4:	0f b7 d2             	movzwl %dx,%edx
c0101bc7:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bcb:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bce:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bd2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bd6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bda:	0f b6 c0             	movzbl %al,%eax
c0101bdd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be1:	83 c2 03             	add    $0x3,%edx
c0101be4:	0f b7 d2             	movzwl %dx,%edx
c0101be7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101beb:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bf2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bf6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bfa:	c1 e8 08             	shr    $0x8,%eax
c0101bfd:	0f b6 c0             	movzbl %al,%eax
c0101c00:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c04:	83 c2 04             	add    $0x4,%edx
c0101c07:	0f b7 d2             	movzwl %dx,%edx
c0101c0a:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101c0e:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101c11:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c15:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c19:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c1d:	c1 e8 10             	shr    $0x10,%eax
c0101c20:	0f b6 c0             	movzbl %al,%eax
c0101c23:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c27:	83 c2 05             	add    $0x5,%edx
c0101c2a:	0f b7 d2             	movzwl %dx,%edx
c0101c2d:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c31:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c34:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c38:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c3c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c3d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c41:	83 e0 01             	and    $0x1,%eax
c0101c44:	c1 e0 04             	shl    $0x4,%eax
c0101c47:	89 c2                	mov    %eax,%edx
c0101c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c4c:	c1 e8 18             	shr    $0x18,%eax
c0101c4f:	83 e0 0f             	and    $0xf,%eax
c0101c52:	09 d0                	or     %edx,%eax
c0101c54:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c57:	0f b6 c0             	movzbl %al,%eax
c0101c5a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c5e:	83 c2 06             	add    $0x6,%edx
c0101c61:	0f b7 d2             	movzwl %dx,%edx
c0101c64:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c68:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c6b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c6f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c73:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c74:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c78:	83 c0 07             	add    $0x7,%eax
c0101c7b:	0f b7 c0             	movzwl %ax,%eax
c0101c7e:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c82:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c86:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c8a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c8e:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c96:	eb 5a                	jmp    c0101cf2 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c98:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ca3:	00 
c0101ca4:	89 04 24             	mov    %eax,(%esp)
c0101ca7:	e8 23 fa ff ff       	call   c01016cf <ide_wait_ready>
c0101cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101caf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101cb3:	74 02                	je     c0101cb7 <ide_read_secs+0x1f7>
            goto out;
c0101cb5:	eb 41                	jmp    c0101cf8 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101cb7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cbb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101cbe:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cc1:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cc4:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101ccb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cce:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cd4:	89 cb                	mov    %ecx,%ebx
c0101cd6:	89 df                	mov    %ebx,%edi
c0101cd8:	89 c1                	mov    %eax,%ecx
c0101cda:	fc                   	cld    
c0101cdb:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cdd:	89 c8                	mov    %ecx,%eax
c0101cdf:	89 fb                	mov    %edi,%ebx
c0101ce1:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ce4:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101ce7:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101ceb:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cf2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cf6:	75 a0                	jne    c0101c98 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cfb:	83 c4 50             	add    $0x50,%esp
c0101cfe:	5b                   	pop    %ebx
c0101cff:	5f                   	pop    %edi
c0101d00:	5d                   	pop    %ebp
c0101d01:	c3                   	ret    

c0101d02 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d02:	55                   	push   %ebp
c0101d03:	89 e5                	mov    %esp,%ebp
c0101d05:	56                   	push   %esi
c0101d06:	53                   	push   %ebx
c0101d07:	83 ec 50             	sub    $0x50,%esp
c0101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0d:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101d11:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d18:	77 24                	ja     c0101d3e <ide_write_secs+0x3c>
c0101d1a:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d1f:	77 1d                	ja     c0101d3e <ide_write_secs+0x3c>
c0101d21:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d25:	c1 e0 03             	shl    $0x3,%eax
c0101d28:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d2f:	29 c2                	sub    %eax,%edx
c0101d31:	8d 82 80 36 12 c0    	lea    -0x3fedc980(%edx),%eax
c0101d37:	0f b6 00             	movzbl (%eax),%eax
c0101d3a:	84 c0                	test   %al,%al
c0101d3c:	75 24                	jne    c0101d62 <ide_write_secs+0x60>
c0101d3e:	c7 44 24 0c 0c 90 10 	movl   $0xc010900c,0xc(%esp)
c0101d45:	c0 
c0101d46:	c7 44 24 08 c7 8f 10 	movl   $0xc0108fc7,0x8(%esp)
c0101d4d:	c0 
c0101d4e:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d55:	00 
c0101d56:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c0101d5d:	e8 7f ef ff ff       	call   c0100ce1 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d62:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d69:	77 0f                	ja     c0101d7a <ide_write_secs+0x78>
c0101d6b:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d71:	01 d0                	add    %edx,%eax
c0101d73:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d78:	76 24                	jbe    c0101d9e <ide_write_secs+0x9c>
c0101d7a:	c7 44 24 0c 34 90 10 	movl   $0xc0109034,0xc(%esp)
c0101d81:	c0 
c0101d82:	c7 44 24 08 c7 8f 10 	movl   $0xc0108fc7,0x8(%esp)
c0101d89:	c0 
c0101d8a:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d91:	00 
c0101d92:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c0101d99:	e8 43 ef ff ff       	call   c0100ce1 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d9e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da2:	66 d1 e8             	shr    %ax
c0101da5:	0f b7 c0             	movzwl %ax,%eax
c0101da8:	0f b7 04 85 7c 8f 10 	movzwl -0x3fef7084(,%eax,4),%eax
c0101daf:	c0 
c0101db0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101db4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101db8:	66 d1 e8             	shr    %ax
c0101dbb:	0f b7 c0             	movzwl %ax,%eax
c0101dbe:	0f b7 04 85 7e 8f 10 	movzwl -0x3fef7082(,%eax,4),%eax
c0101dc5:	c0 
c0101dc6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dca:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101dce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dd5:	00 
c0101dd6:	89 04 24             	mov    %eax,(%esp)
c0101dd9:	e8 f1 f8 ff ff       	call   c01016cf <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dde:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101de2:	83 c0 02             	add    $0x2,%eax
c0101de5:	0f b7 c0             	movzwl %ax,%eax
c0101de8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dec:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101df0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101df4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101df8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101df9:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dfc:	0f b6 c0             	movzbl %al,%eax
c0101dff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e03:	83 c2 02             	add    $0x2,%edx
c0101e06:	0f b7 d2             	movzwl %dx,%edx
c0101e09:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101e0d:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101e10:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101e14:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e18:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1c:	0f b6 c0             	movzbl %al,%eax
c0101e1f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e23:	83 c2 03             	add    $0x3,%edx
c0101e26:	0f b7 d2             	movzwl %dx,%edx
c0101e29:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e2d:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e30:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e34:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e38:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e3c:	c1 e8 08             	shr    $0x8,%eax
c0101e3f:	0f b6 c0             	movzbl %al,%eax
c0101e42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e46:	83 c2 04             	add    $0x4,%edx
c0101e49:	0f b7 d2             	movzwl %dx,%edx
c0101e4c:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e50:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e53:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e57:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e5b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e5f:	c1 e8 10             	shr    $0x10,%eax
c0101e62:	0f b6 c0             	movzbl %al,%eax
c0101e65:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e69:	83 c2 05             	add    $0x5,%edx
c0101e6c:	0f b7 d2             	movzwl %dx,%edx
c0101e6f:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e73:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e76:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e7a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e7e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e7f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e83:	83 e0 01             	and    $0x1,%eax
c0101e86:	c1 e0 04             	shl    $0x4,%eax
c0101e89:	89 c2                	mov    %eax,%edx
c0101e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e8e:	c1 e8 18             	shr    $0x18,%eax
c0101e91:	83 e0 0f             	and    $0xf,%eax
c0101e94:	09 d0                	or     %edx,%eax
c0101e96:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e99:	0f b6 c0             	movzbl %al,%eax
c0101e9c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ea0:	83 c2 06             	add    $0x6,%edx
c0101ea3:	0f b7 d2             	movzwl %dx,%edx
c0101ea6:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101eaa:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101ead:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101eb1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101eb5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101eb6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eba:	83 c0 07             	add    $0x7,%eax
c0101ebd:	0f b7 c0             	movzwl %ax,%eax
c0101ec0:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ec4:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101ec8:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101ecc:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ed0:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ed1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ed8:	eb 5a                	jmp    c0101f34 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101eda:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ede:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ee5:	00 
c0101ee6:	89 04 24             	mov    %eax,(%esp)
c0101ee9:	e8 e1 f7 ff ff       	call   c01016cf <ide_wait_ready>
c0101eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ef5:	74 02                	je     c0101ef9 <ide_write_secs+0x1f7>
            goto out;
c0101ef7:	eb 41                	jmp    c0101f3a <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ef9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101efd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f00:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f03:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f06:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101f0d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101f10:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101f13:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f16:	89 cb                	mov    %ecx,%ebx
c0101f18:	89 de                	mov    %ebx,%esi
c0101f1a:	89 c1                	mov    %eax,%ecx
c0101f1c:	fc                   	cld    
c0101f1d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f1f:	89 c8                	mov    %ecx,%eax
c0101f21:	89 f3                	mov    %esi,%ebx
c0101f23:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f26:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f29:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f2d:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f34:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f38:	75 a0                	jne    c0101eda <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f3d:	83 c4 50             	add    $0x50,%esp
c0101f40:	5b                   	pop    %ebx
c0101f41:	5e                   	pop    %esi
c0101f42:	5d                   	pop    %ebp
c0101f43:	c3                   	ret    

c0101f44 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f44:	55                   	push   %ebp
c0101f45:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f47:	fb                   	sti    
    sti();
}
c0101f48:	5d                   	pop    %ebp
c0101f49:	c3                   	ret    

c0101f4a <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f4a:	55                   	push   %ebp
c0101f4b:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f4d:	fa                   	cli    
    cli();
}
c0101f4e:	5d                   	pop    %ebp
c0101f4f:	c3                   	ret    

c0101f50 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f50:	55                   	push   %ebp
c0101f51:	89 e5                	mov    %esp,%ebp
c0101f53:	83 ec 14             	sub    $0x14,%esp
c0101f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f59:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f5d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f61:	66 a3 50 05 12 c0    	mov    %ax,0xc0120550
    if (did_init) {
c0101f67:	a1 60 37 12 c0       	mov    0xc0123760,%eax
c0101f6c:	85 c0                	test   %eax,%eax
c0101f6e:	74 36                	je     c0101fa6 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f70:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f74:	0f b6 c0             	movzbl %al,%eax
c0101f77:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f7d:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f80:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f84:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f88:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f89:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f8d:	66 c1 e8 08          	shr    $0x8,%ax
c0101f91:	0f b6 c0             	movzbl %al,%eax
c0101f94:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f9a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f9d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fa1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fa5:	ee                   	out    %al,(%dx)
    }
}
c0101fa6:	c9                   	leave  
c0101fa7:	c3                   	ret    

c0101fa8 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101fa8:	55                   	push   %ebp
c0101fa9:	89 e5                	mov    %esp,%ebp
c0101fab:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb1:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fb6:	89 c1                	mov    %eax,%ecx
c0101fb8:	d3 e2                	shl    %cl,%edx
c0101fba:	89 d0                	mov    %edx,%eax
c0101fbc:	f7 d0                	not    %eax
c0101fbe:	89 c2                	mov    %eax,%edx
c0101fc0:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0101fc7:	21 d0                	and    %edx,%eax
c0101fc9:	0f b7 c0             	movzwl %ax,%eax
c0101fcc:	89 04 24             	mov    %eax,(%esp)
c0101fcf:	e8 7c ff ff ff       	call   c0101f50 <pic_setmask>
}
c0101fd4:	c9                   	leave  
c0101fd5:	c3                   	ret    

c0101fd6 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fd6:	55                   	push   %ebp
c0101fd7:	89 e5                	mov    %esp,%ebp
c0101fd9:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fdc:	c7 05 60 37 12 c0 01 	movl   $0x1,0xc0123760
c0101fe3:	00 00 00 
c0101fe6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fec:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101ff0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101ff4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101ff8:	ee                   	out    %al,(%dx)
c0101ff9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fff:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0102003:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102007:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010200b:	ee                   	out    %al,(%dx)
c010200c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102012:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102016:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010201a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010201e:	ee                   	out    %al,(%dx)
c010201f:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102025:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102029:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010202d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102031:	ee                   	out    %al,(%dx)
c0102032:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102038:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010203c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102040:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102044:	ee                   	out    %al,(%dx)
c0102045:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010204b:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010204f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102053:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102057:	ee                   	out    %al,(%dx)
c0102058:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010205e:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102062:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102066:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010206a:	ee                   	out    %al,(%dx)
c010206b:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102071:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102075:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102079:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010207d:	ee                   	out    %al,(%dx)
c010207e:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102084:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102088:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010208c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102090:	ee                   	out    %al,(%dx)
c0102091:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102097:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010209b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010209f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01020a3:	ee                   	out    %al,(%dx)
c01020a4:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01020aa:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01020ae:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01020b2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020b6:	ee                   	out    %al,(%dx)
c01020b7:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020bd:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020c1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020c5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020c9:	ee                   	out    %al,(%dx)
c01020ca:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020d0:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020d4:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020d8:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020dc:	ee                   	out    %al,(%dx)
c01020dd:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020e3:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020e7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020eb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020ef:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020f0:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c01020f7:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020fb:	74 12                	je     c010210f <pic_init+0x139>
        pic_setmask(irq_mask);
c01020fd:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0102104:	0f b7 c0             	movzwl %ax,%eax
c0102107:	89 04 24             	mov    %eax,(%esp)
c010210a:	e8 41 fe ff ff       	call   c0101f50 <pic_setmask>
    }
}
c010210f:	c9                   	leave  
c0102110:	c3                   	ret    

c0102111 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102111:	55                   	push   %ebp
c0102112:	89 e5                	mov    %esp,%ebp
c0102114:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102117:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010211e:	00 
c010211f:	c7 04 24 80 90 10 c0 	movl   $0xc0109080,(%esp)
c0102126:	e8 2c e2 ff ff       	call   c0100357 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010212b:	c9                   	leave  
c010212c:	c3                   	ret    

c010212d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010212d:	55                   	push   %ebp
c010212e:	89 e5                	mov    %esp,%ebp
c0102130:	83 ec 10             	sub    $0x10,%esp
     /* LAB1 17343027 : STEP 2 */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
c0102133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010213a:	e9 c3 00 00 00       	jmp    c0102202 <idt_init+0xd5>
	/*if(i == T_SYSCALL){
	    SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
	}
	else SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }*/
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010213f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102142:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c0102149:	89 c2                	mov    %eax,%edx
c010214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214e:	66 89 14 c5 80 37 12 	mov    %dx,-0x3fedc880(,%eax,8)
c0102155:	c0 
c0102156:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102159:	66 c7 04 c5 82 37 12 	movw   $0x8,-0x3fedc87e(,%eax,8)
c0102160:	c0 08 00 
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b6 14 c5 84 37 12 	movzbl -0x3fedc87c(,%eax,8),%edx
c010216d:	c0 
c010216e:	83 e2 e0             	and    $0xffffffe0,%edx
c0102171:	88 14 c5 84 37 12 c0 	mov    %dl,-0x3fedc87c(,%eax,8)
c0102178:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217b:	0f b6 14 c5 84 37 12 	movzbl -0x3fedc87c(,%eax,8),%edx
c0102182:	c0 
c0102183:	83 e2 1f             	and    $0x1f,%edx
c0102186:	88 14 c5 84 37 12 c0 	mov    %dl,-0x3fedc87c(,%eax,8)
c010218d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102190:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c0102197:	c0 
c0102198:	83 e2 f0             	and    $0xfffffff0,%edx
c010219b:	83 ca 0e             	or     $0xe,%edx
c010219e:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 e2 ef             	and    $0xffffffef,%edx
c01021b3:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 e2 9f             	and    $0xffffff9f,%edx
c01021c8:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	0f b6 14 c5 85 37 12 	movzbl -0x3fedc87b(,%eax,8),%edx
c01021d9:	c0 
c01021da:	83 ca 80             	or     $0xffffff80,%edx
c01021dd:	88 14 c5 85 37 12 c0 	mov    %dl,-0x3fedc87b(,%eax,8)
c01021e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e7:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c01021ee:	c1 e8 10             	shr    $0x10,%eax
c01021f1:	89 c2                	mov    %eax,%edx
c01021f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f6:	66 89 14 c5 86 37 12 	mov    %dx,-0x3fedc87a(,%eax,8)
c01021fd:	c0 
void
idt_init(void) {
     /* LAB1 17343027 : STEP 2 */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
c01021fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102202:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102209:	0f 8e 30 ff ff ff    	jle    c010213f <idt_init+0x12>
	else SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }*/
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010220f:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c0102214:	66 a3 48 3b 12 c0    	mov    %ax,0xc0123b48
c010221a:	66 c7 05 4a 3b 12 c0 	movw   $0x8,0xc0123b4a
c0102221:	08 00 
c0102223:	0f b6 05 4c 3b 12 c0 	movzbl 0xc0123b4c,%eax
c010222a:	83 e0 e0             	and    $0xffffffe0,%eax
c010222d:	a2 4c 3b 12 c0       	mov    %al,0xc0123b4c
c0102232:	0f b6 05 4c 3b 12 c0 	movzbl 0xc0123b4c,%eax
c0102239:	83 e0 1f             	and    $0x1f,%eax
c010223c:	a2 4c 3b 12 c0       	mov    %al,0xc0123b4c
c0102241:	0f b6 05 4d 3b 12 c0 	movzbl 0xc0123b4d,%eax
c0102248:	83 e0 f0             	and    $0xfffffff0,%eax
c010224b:	83 c8 0e             	or     $0xe,%eax
c010224e:	a2 4d 3b 12 c0       	mov    %al,0xc0123b4d
c0102253:	0f b6 05 4d 3b 12 c0 	movzbl 0xc0123b4d,%eax
c010225a:	83 e0 ef             	and    $0xffffffef,%eax
c010225d:	a2 4d 3b 12 c0       	mov    %al,0xc0123b4d
c0102262:	0f b6 05 4d 3b 12 c0 	movzbl 0xc0123b4d,%eax
c0102269:	83 c8 60             	or     $0x60,%eax
c010226c:	a2 4d 3b 12 c0       	mov    %al,0xc0123b4d
c0102271:	0f b6 05 4d 3b 12 c0 	movzbl 0xc0123b4d,%eax
c0102278:	83 c8 80             	or     $0xffffff80,%eax
c010227b:	a2 4d 3b 12 c0       	mov    %al,0xc0123b4d
c0102280:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c0102285:	c1 e8 10             	shr    $0x10,%eax
c0102288:	66 a3 4e 3b 12 c0    	mov    %ax,0xc0123b4e
c010228e:	c7 45 f8 60 05 12 c0 	movl   $0xc0120560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102295:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102298:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c010229b:	c9                   	leave  
c010229c:	c3                   	ret    

c010229d <trapname>:

static const char *
trapname(int trapno) {
c010229d:	55                   	push   %ebp
c010229e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01022a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a3:	83 f8 13             	cmp    $0x13,%eax
c01022a6:	77 0c                	ja     c01022b4 <trapname+0x17>
        return excnames[trapno];
c01022a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ab:	8b 04 85 60 94 10 c0 	mov    -0x3fef6ba0(,%eax,4),%eax
c01022b2:	eb 18                	jmp    c01022cc <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01022b4:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022b8:	7e 0d                	jle    c01022c7 <trapname+0x2a>
c01022ba:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022be:	7f 07                	jg     c01022c7 <trapname+0x2a>
        return "Hardware Interrupt";
c01022c0:	b8 8a 90 10 c0       	mov    $0xc010908a,%eax
c01022c5:	eb 05                	jmp    c01022cc <trapname+0x2f>
    }
    return "(unknown trap)";
c01022c7:	b8 9d 90 10 c0       	mov    $0xc010909d,%eax
}
c01022cc:	5d                   	pop    %ebp
c01022cd:	c3                   	ret    

c01022ce <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022ce:	55                   	push   %ebp
c01022cf:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022d8:	66 83 f8 08          	cmp    $0x8,%ax
c01022dc:	0f 94 c0             	sete   %al
c01022df:	0f b6 c0             	movzbl %al,%eax
}
c01022e2:	5d                   	pop    %ebp
c01022e3:	c3                   	ret    

c01022e4 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022e4:	55                   	push   %ebp
c01022e5:	89 e5                	mov    %esp,%ebp
c01022e7:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01022ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022f1:	c7 04 24 de 90 10 c0 	movl   $0xc01090de,(%esp)
c01022f8:	e8 5a e0 ff ff       	call   c0100357 <cprintf>
    print_regs(&tf->tf_regs);
c01022fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102300:	89 04 24             	mov    %eax,(%esp)
c0102303:	e8 a1 01 00 00       	call   c01024a9 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102308:	8b 45 08             	mov    0x8(%ebp),%eax
c010230b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010230f:	0f b7 c0             	movzwl %ax,%eax
c0102312:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102316:	c7 04 24 ef 90 10 c0 	movl   $0xc01090ef,(%esp)
c010231d:	e8 35 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102322:	8b 45 08             	mov    0x8(%ebp),%eax
c0102325:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102329:	0f b7 c0             	movzwl %ax,%eax
c010232c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102330:	c7 04 24 02 91 10 c0 	movl   $0xc0109102,(%esp)
c0102337:	e8 1b e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010233c:	8b 45 08             	mov    0x8(%ebp),%eax
c010233f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102343:	0f b7 c0             	movzwl %ax,%eax
c0102346:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234a:	c7 04 24 15 91 10 c0 	movl   $0xc0109115,(%esp)
c0102351:	e8 01 e0 ff ff       	call   c0100357 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102356:	8b 45 08             	mov    0x8(%ebp),%eax
c0102359:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010235d:	0f b7 c0             	movzwl %ax,%eax
c0102360:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102364:	c7 04 24 28 91 10 c0 	movl   $0xc0109128,(%esp)
c010236b:	e8 e7 df ff ff       	call   c0100357 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102370:	8b 45 08             	mov    0x8(%ebp),%eax
c0102373:	8b 40 30             	mov    0x30(%eax),%eax
c0102376:	89 04 24             	mov    %eax,(%esp)
c0102379:	e8 1f ff ff ff       	call   c010229d <trapname>
c010237e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102381:	8b 52 30             	mov    0x30(%edx),%edx
c0102384:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102388:	89 54 24 04          	mov    %edx,0x4(%esp)
c010238c:	c7 04 24 3b 91 10 c0 	movl   $0xc010913b,(%esp)
c0102393:	e8 bf df ff ff       	call   c0100357 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102398:	8b 45 08             	mov    0x8(%ebp),%eax
c010239b:	8b 40 34             	mov    0x34(%eax),%eax
c010239e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a2:	c7 04 24 4d 91 10 c0 	movl   $0xc010914d,(%esp)
c01023a9:	e8 a9 df ff ff       	call   c0100357 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01023ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b1:	8b 40 38             	mov    0x38(%eax),%eax
c01023b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b8:	c7 04 24 5c 91 10 c0 	movl   $0xc010915c,(%esp)
c01023bf:	e8 93 df ff ff       	call   c0100357 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023cb:	0f b7 c0             	movzwl %ax,%eax
c01023ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d2:	c7 04 24 6b 91 10 c0 	movl   $0xc010916b,(%esp)
c01023d9:	e8 79 df ff ff       	call   c0100357 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023de:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e1:	8b 40 40             	mov    0x40(%eax),%eax
c01023e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e8:	c7 04 24 7e 91 10 c0 	movl   $0xc010917e,(%esp)
c01023ef:	e8 63 df ff ff       	call   c0100357 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023fb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102402:	eb 3e                	jmp    c0102442 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102404:	8b 45 08             	mov    0x8(%ebp),%eax
c0102407:	8b 50 40             	mov    0x40(%eax),%edx
c010240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010240d:	21 d0                	and    %edx,%eax
c010240f:	85 c0                	test   %eax,%eax
c0102411:	74 28                	je     c010243b <print_trapframe+0x157>
c0102413:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102416:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c010241d:	85 c0                	test   %eax,%eax
c010241f:	74 1a                	je     c010243b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102421:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102424:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c010242b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010242f:	c7 04 24 8d 91 10 c0 	movl   $0xc010918d,(%esp)
c0102436:	e8 1c df ff ff       	call   c0100357 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010243b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010243f:	d1 65 f0             	shll   -0x10(%ebp)
c0102442:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102445:	83 f8 17             	cmp    $0x17,%eax
c0102448:	76 ba                	jbe    c0102404 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010244a:	8b 45 08             	mov    0x8(%ebp),%eax
c010244d:	8b 40 40             	mov    0x40(%eax),%eax
c0102450:	25 00 30 00 00       	and    $0x3000,%eax
c0102455:	c1 e8 0c             	shr    $0xc,%eax
c0102458:	89 44 24 04          	mov    %eax,0x4(%esp)
c010245c:	c7 04 24 91 91 10 c0 	movl   $0xc0109191,(%esp)
c0102463:	e8 ef de ff ff       	call   c0100357 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102468:	8b 45 08             	mov    0x8(%ebp),%eax
c010246b:	89 04 24             	mov    %eax,(%esp)
c010246e:	e8 5b fe ff ff       	call   c01022ce <trap_in_kernel>
c0102473:	85 c0                	test   %eax,%eax
c0102475:	75 30                	jne    c01024a7 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102477:	8b 45 08             	mov    0x8(%ebp),%eax
c010247a:	8b 40 44             	mov    0x44(%eax),%eax
c010247d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102481:	c7 04 24 9a 91 10 c0 	movl   $0xc010919a,(%esp)
c0102488:	e8 ca de ff ff       	call   c0100357 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010248d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102490:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102494:	0f b7 c0             	movzwl %ax,%eax
c0102497:	89 44 24 04          	mov    %eax,0x4(%esp)
c010249b:	c7 04 24 a9 91 10 c0 	movl   $0xc01091a9,(%esp)
c01024a2:	e8 b0 de ff ff       	call   c0100357 <cprintf>
    }
}
c01024a7:	c9                   	leave  
c01024a8:	c3                   	ret    

c01024a9 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01024a9:	55                   	push   %ebp
c01024aa:	89 e5                	mov    %esp,%ebp
c01024ac:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01024af:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b2:	8b 00                	mov    (%eax),%eax
c01024b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b8:	c7 04 24 bc 91 10 c0 	movl   $0xc01091bc,(%esp)
c01024bf:	e8 93 de ff ff       	call   c0100357 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c7:	8b 40 04             	mov    0x4(%eax),%eax
c01024ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ce:	c7 04 24 cb 91 10 c0 	movl   $0xc01091cb,(%esp)
c01024d5:	e8 7d de ff ff       	call   c0100357 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024da:	8b 45 08             	mov    0x8(%ebp),%eax
c01024dd:	8b 40 08             	mov    0x8(%eax),%eax
c01024e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e4:	c7 04 24 da 91 10 c0 	movl   $0xc01091da,(%esp)
c01024eb:	e8 67 de ff ff       	call   c0100357 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f3:	8b 40 0c             	mov    0xc(%eax),%eax
c01024f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fa:	c7 04 24 e9 91 10 c0 	movl   $0xc01091e9,(%esp)
c0102501:	e8 51 de ff ff       	call   c0100357 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102506:	8b 45 08             	mov    0x8(%ebp),%eax
c0102509:	8b 40 10             	mov    0x10(%eax),%eax
c010250c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102510:	c7 04 24 f8 91 10 c0 	movl   $0xc01091f8,(%esp)
c0102517:	e8 3b de ff ff       	call   c0100357 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010251c:	8b 45 08             	mov    0x8(%ebp),%eax
c010251f:	8b 40 14             	mov    0x14(%eax),%eax
c0102522:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102526:	c7 04 24 07 92 10 c0 	movl   $0xc0109207,(%esp)
c010252d:	e8 25 de ff ff       	call   c0100357 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102532:	8b 45 08             	mov    0x8(%ebp),%eax
c0102535:	8b 40 18             	mov    0x18(%eax),%eax
c0102538:	89 44 24 04          	mov    %eax,0x4(%esp)
c010253c:	c7 04 24 16 92 10 c0 	movl   $0xc0109216,(%esp)
c0102543:	e8 0f de ff ff       	call   c0100357 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102548:	8b 45 08             	mov    0x8(%ebp),%eax
c010254b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010254e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102552:	c7 04 24 25 92 10 c0 	movl   $0xc0109225,(%esp)
c0102559:	e8 f9 dd ff ff       	call   c0100357 <cprintf>
}
c010255e:	c9                   	leave  
c010255f:	c3                   	ret    

c0102560 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102560:	55                   	push   %ebp
c0102561:	89 e5                	mov    %esp,%ebp
c0102563:	53                   	push   %ebx
c0102564:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102567:	8b 45 08             	mov    0x8(%ebp),%eax
c010256a:	8b 40 34             	mov    0x34(%eax),%eax
c010256d:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102570:	85 c0                	test   %eax,%eax
c0102572:	74 07                	je     c010257b <print_pgfault+0x1b>
c0102574:	b9 34 92 10 c0       	mov    $0xc0109234,%ecx
c0102579:	eb 05                	jmp    c0102580 <print_pgfault+0x20>
c010257b:	b9 45 92 10 c0       	mov    $0xc0109245,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102580:	8b 45 08             	mov    0x8(%ebp),%eax
c0102583:	8b 40 34             	mov    0x34(%eax),%eax
c0102586:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102589:	85 c0                	test   %eax,%eax
c010258b:	74 07                	je     c0102594 <print_pgfault+0x34>
c010258d:	ba 57 00 00 00       	mov    $0x57,%edx
c0102592:	eb 05                	jmp    c0102599 <print_pgfault+0x39>
c0102594:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102599:	8b 45 08             	mov    0x8(%ebp),%eax
c010259c:	8b 40 34             	mov    0x34(%eax),%eax
c010259f:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025a2:	85 c0                	test   %eax,%eax
c01025a4:	74 07                	je     c01025ad <print_pgfault+0x4d>
c01025a6:	b8 55 00 00 00       	mov    $0x55,%eax
c01025ab:	eb 05                	jmp    c01025b2 <print_pgfault+0x52>
c01025ad:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025b2:	0f 20 d3             	mov    %cr2,%ebx
c01025b5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01025b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025bb:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025bf:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025c3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01025c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01025cb:	c7 04 24 54 92 10 c0 	movl   $0xc0109254,(%esp)
c01025d2:	e8 80 dd ff ff       	call   c0100357 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025d7:	83 c4 34             	add    $0x34,%esp
c01025da:	5b                   	pop    %ebx
c01025db:	5d                   	pop    %ebp
c01025dc:	c3                   	ret    

c01025dd <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025dd:	55                   	push   %ebp
c01025de:	89 e5                	mov    %esp,%ebp
c01025e0:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e6:	89 04 24             	mov    %eax,(%esp)
c01025e9:	e8 72 ff ff ff       	call   c0102560 <print_pgfault>
    if (check_mm_struct != NULL) {
c01025ee:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c01025f3:	85 c0                	test   %eax,%eax
c01025f5:	74 28                	je     c010261f <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025f7:	0f 20 d0             	mov    %cr2,%eax
c01025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102600:	89 c1                	mov    %eax,%ecx
c0102602:	8b 45 08             	mov    0x8(%ebp),%eax
c0102605:	8b 50 34             	mov    0x34(%eax),%edx
c0102608:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c010260d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102611:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102615:	89 04 24             	mov    %eax,(%esp)
c0102618:	e8 50 56 00 00       	call   c0107c6d <do_pgfault>
c010261d:	eb 1c                	jmp    c010263b <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c010261f:	c7 44 24 08 77 92 10 	movl   $0xc0109277,0x8(%esp)
c0102626:	c0 
c0102627:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c010262e:	00 
c010262f:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c0102636:	e8 a6 e6 ff ff       	call   c0100ce1 <__panic>
}
c010263b:	c9                   	leave  
c010263c:	c3                   	ret    

c010263d <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010263d:	55                   	push   %ebp
c010263e:	89 e5                	mov    %esp,%ebp
c0102640:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102643:	8b 45 08             	mov    0x8(%ebp),%eax
c0102646:	8b 40 30             	mov    0x30(%eax),%eax
c0102649:	83 f8 24             	cmp    $0x24,%eax
c010264c:	0f 84 8b 00 00 00    	je     c01026dd <trap_dispatch+0xa0>
c0102652:	83 f8 24             	cmp    $0x24,%eax
c0102655:	77 1c                	ja     c0102673 <trap_dispatch+0x36>
c0102657:	83 f8 20             	cmp    $0x20,%eax
c010265a:	0f 84 1d 01 00 00    	je     c010277d <trap_dispatch+0x140>
c0102660:	83 f8 21             	cmp    $0x21,%eax
c0102663:	0f 84 9a 00 00 00    	je     c0102703 <trap_dispatch+0xc6>
c0102669:	83 f8 0e             	cmp    $0xe,%eax
c010266c:	74 28                	je     c0102696 <trap_dispatch+0x59>
c010266e:	e9 d2 00 00 00       	jmp    c0102745 <trap_dispatch+0x108>
c0102673:	83 f8 2e             	cmp    $0x2e,%eax
c0102676:	0f 82 c9 00 00 00    	jb     c0102745 <trap_dispatch+0x108>
c010267c:	83 f8 2f             	cmp    $0x2f,%eax
c010267f:	0f 86 fb 00 00 00    	jbe    c0102780 <trap_dispatch+0x143>
c0102685:	83 e8 78             	sub    $0x78,%eax
c0102688:	83 f8 01             	cmp    $0x1,%eax
c010268b:	0f 87 b4 00 00 00    	ja     c0102745 <trap_dispatch+0x108>
c0102691:	e9 93 00 00 00       	jmp    c0102729 <trap_dispatch+0xec>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102696:	8b 45 08             	mov    0x8(%ebp),%eax
c0102699:	89 04 24             	mov    %eax,(%esp)
c010269c:	e8 3c ff ff ff       	call   c01025dd <pgfault_handler>
c01026a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01026a8:	74 2e                	je     c01026d8 <trap_dispatch+0x9b>
            print_trapframe(tf);
c01026aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ad:	89 04 24             	mov    %eax,(%esp)
c01026b0:	e8 2f fc ff ff       	call   c01022e4 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026bc:	c7 44 24 08 9f 92 10 	movl   $0xc010929f,0x8(%esp)
c01026c3:	c0 
c01026c4:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01026cb:	00 
c01026cc:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c01026d3:	e8 09 e6 ff ff       	call   c0100ce1 <__panic>
        }
        break;
c01026d8:	e9 a4 00 00 00       	jmp    c0102781 <trap_dispatch+0x144>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026dd:	e8 7e ef ff ff       	call   c0101660 <cons_getc>
c01026e2:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026e5:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026e9:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026ed:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026f5:	c7 04 24 ba 92 10 c0 	movl   $0xc01092ba,(%esp)
c01026fc:	e8 56 dc ff ff       	call   c0100357 <cprintf>
        break;
c0102701:	eb 7e                	jmp    c0102781 <trap_dispatch+0x144>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102703:	e8 58 ef ff ff       	call   c0101660 <cons_getc>
c0102708:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c010270b:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010270f:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102713:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102717:	89 44 24 04          	mov    %eax,0x4(%esp)
c010271b:	c7 04 24 cc 92 10 c0 	movl   $0xc01092cc,(%esp)
c0102722:	e8 30 dc ff ff       	call   c0100357 <cprintf>
        break;
c0102727:	eb 58                	jmp    c0102781 <trap_dispatch+0x144>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102729:	c7 44 24 08 db 92 10 	movl   $0xc01092db,0x8(%esp)
c0102730:	c0 
c0102731:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0102738:	00 
c0102739:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c0102740:	e8 9c e5 ff ff       	call   c0100ce1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102745:	8b 45 08             	mov    0x8(%ebp),%eax
c0102748:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010274c:	0f b7 c0             	movzwl %ax,%eax
c010274f:	83 e0 03             	and    $0x3,%eax
c0102752:	85 c0                	test   %eax,%eax
c0102754:	75 2b                	jne    c0102781 <trap_dispatch+0x144>
            print_trapframe(tf);
c0102756:	8b 45 08             	mov    0x8(%ebp),%eax
c0102759:	89 04 24             	mov    %eax,(%esp)
c010275c:	e8 83 fb ff ff       	call   c01022e4 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102761:	c7 44 24 08 eb 92 10 	movl   $0xc01092eb,0x8(%esp)
c0102768:	c0 
c0102769:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0102770:	00 
c0102771:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c0102778:	e8 64 e5 ff ff       	call   c0100ce1 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c010277d:	90                   	nop
c010277e:	eb 01                	jmp    c0102781 <trap_dispatch+0x144>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102780:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102781:	c9                   	leave  
c0102782:	c3                   	ret    

c0102783 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102783:	55                   	push   %ebp
c0102784:	89 e5                	mov    %esp,%ebp
c0102786:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102789:	8b 45 08             	mov    0x8(%ebp),%eax
c010278c:	89 04 24             	mov    %eax,(%esp)
c010278f:	e8 a9 fe ff ff       	call   c010263d <trap_dispatch>
}
c0102794:	c9                   	leave  
c0102795:	c3                   	ret    

c0102796 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102796:	1e                   	push   %ds
    pushl %es
c0102797:	06                   	push   %es
    pushl %fs
c0102798:	0f a0                	push   %fs
    pushl %gs
c010279a:	0f a8                	push   %gs
    pushal
c010279c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010279d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01027a2:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01027a4:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01027a6:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01027a7:	e8 d7 ff ff ff       	call   c0102783 <trap>

    # pop the pushed stack pointer
    popl %esp
c01027ac:	5c                   	pop    %esp

c01027ad <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01027ad:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01027ae:	0f a9                	pop    %gs
    popl %fs
c01027b0:	0f a1                	pop    %fs
    popl %es
c01027b2:	07                   	pop    %es
    popl %ds
c01027b3:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01027b4:	83 c4 08             	add    $0x8,%esp
    iret
c01027b7:	cf                   	iret   

c01027b8 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $0
c01027ba:	6a 00                	push   $0x0
  jmp __alltraps
c01027bc:	e9 d5 ff ff ff       	jmp    c0102796 <__alltraps>

c01027c1 <vector1>:
.globl vector1
vector1:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $1
c01027c3:	6a 01                	push   $0x1
  jmp __alltraps
c01027c5:	e9 cc ff ff ff       	jmp    c0102796 <__alltraps>

c01027ca <vector2>:
.globl vector2
vector2:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $2
c01027cc:	6a 02                	push   $0x2
  jmp __alltraps
c01027ce:	e9 c3 ff ff ff       	jmp    c0102796 <__alltraps>

c01027d3 <vector3>:
.globl vector3
vector3:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $3
c01027d5:	6a 03                	push   $0x3
  jmp __alltraps
c01027d7:	e9 ba ff ff ff       	jmp    c0102796 <__alltraps>

c01027dc <vector4>:
.globl vector4
vector4:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $4
c01027de:	6a 04                	push   $0x4
  jmp __alltraps
c01027e0:	e9 b1 ff ff ff       	jmp    c0102796 <__alltraps>

c01027e5 <vector5>:
.globl vector5
vector5:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $5
c01027e7:	6a 05                	push   $0x5
  jmp __alltraps
c01027e9:	e9 a8 ff ff ff       	jmp    c0102796 <__alltraps>

c01027ee <vector6>:
.globl vector6
vector6:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $6
c01027f0:	6a 06                	push   $0x6
  jmp __alltraps
c01027f2:	e9 9f ff ff ff       	jmp    c0102796 <__alltraps>

c01027f7 <vector7>:
.globl vector7
vector7:
  pushl $0
c01027f7:	6a 00                	push   $0x0
  pushl $7
c01027f9:	6a 07                	push   $0x7
  jmp __alltraps
c01027fb:	e9 96 ff ff ff       	jmp    c0102796 <__alltraps>

c0102800 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102800:	6a 08                	push   $0x8
  jmp __alltraps
c0102802:	e9 8f ff ff ff       	jmp    c0102796 <__alltraps>

c0102807 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $9
c0102809:	6a 09                	push   $0x9
  jmp __alltraps
c010280b:	e9 86 ff ff ff       	jmp    c0102796 <__alltraps>

c0102810 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102810:	6a 0a                	push   $0xa
  jmp __alltraps
c0102812:	e9 7f ff ff ff       	jmp    c0102796 <__alltraps>

c0102817 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102817:	6a 0b                	push   $0xb
  jmp __alltraps
c0102819:	e9 78 ff ff ff       	jmp    c0102796 <__alltraps>

c010281e <vector12>:
.globl vector12
vector12:
  pushl $12
c010281e:	6a 0c                	push   $0xc
  jmp __alltraps
c0102820:	e9 71 ff ff ff       	jmp    c0102796 <__alltraps>

c0102825 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102825:	6a 0d                	push   $0xd
  jmp __alltraps
c0102827:	e9 6a ff ff ff       	jmp    c0102796 <__alltraps>

c010282c <vector14>:
.globl vector14
vector14:
  pushl $14
c010282c:	6a 0e                	push   $0xe
  jmp __alltraps
c010282e:	e9 63 ff ff ff       	jmp    c0102796 <__alltraps>

c0102833 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $15
c0102835:	6a 0f                	push   $0xf
  jmp __alltraps
c0102837:	e9 5a ff ff ff       	jmp    c0102796 <__alltraps>

c010283c <vector16>:
.globl vector16
vector16:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $16
c010283e:	6a 10                	push   $0x10
  jmp __alltraps
c0102840:	e9 51 ff ff ff       	jmp    c0102796 <__alltraps>

c0102845 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102845:	6a 11                	push   $0x11
  jmp __alltraps
c0102847:	e9 4a ff ff ff       	jmp    c0102796 <__alltraps>

c010284c <vector18>:
.globl vector18
vector18:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $18
c010284e:	6a 12                	push   $0x12
  jmp __alltraps
c0102850:	e9 41 ff ff ff       	jmp    c0102796 <__alltraps>

c0102855 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $19
c0102857:	6a 13                	push   $0x13
  jmp __alltraps
c0102859:	e9 38 ff ff ff       	jmp    c0102796 <__alltraps>

c010285e <vector20>:
.globl vector20
vector20:
  pushl $0
c010285e:	6a 00                	push   $0x0
  pushl $20
c0102860:	6a 14                	push   $0x14
  jmp __alltraps
c0102862:	e9 2f ff ff ff       	jmp    c0102796 <__alltraps>

c0102867 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $21
c0102869:	6a 15                	push   $0x15
  jmp __alltraps
c010286b:	e9 26 ff ff ff       	jmp    c0102796 <__alltraps>

c0102870 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $22
c0102872:	6a 16                	push   $0x16
  jmp __alltraps
c0102874:	e9 1d ff ff ff       	jmp    c0102796 <__alltraps>

c0102879 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $23
c010287b:	6a 17                	push   $0x17
  jmp __alltraps
c010287d:	e9 14 ff ff ff       	jmp    c0102796 <__alltraps>

c0102882 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102882:	6a 00                	push   $0x0
  pushl $24
c0102884:	6a 18                	push   $0x18
  jmp __alltraps
c0102886:	e9 0b ff ff ff       	jmp    c0102796 <__alltraps>

c010288b <vector25>:
.globl vector25
vector25:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $25
c010288d:	6a 19                	push   $0x19
  jmp __alltraps
c010288f:	e9 02 ff ff ff       	jmp    c0102796 <__alltraps>

c0102894 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $26
c0102896:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102898:	e9 f9 fe ff ff       	jmp    c0102796 <__alltraps>

c010289d <vector27>:
.globl vector27
vector27:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $27
c010289f:	6a 1b                	push   $0x1b
  jmp __alltraps
c01028a1:	e9 f0 fe ff ff       	jmp    c0102796 <__alltraps>

c01028a6 <vector28>:
.globl vector28
vector28:
  pushl $0
c01028a6:	6a 00                	push   $0x0
  pushl $28
c01028a8:	6a 1c                	push   $0x1c
  jmp __alltraps
c01028aa:	e9 e7 fe ff ff       	jmp    c0102796 <__alltraps>

c01028af <vector29>:
.globl vector29
vector29:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $29
c01028b1:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028b3:	e9 de fe ff ff       	jmp    c0102796 <__alltraps>

c01028b8 <vector30>:
.globl vector30
vector30:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $30
c01028ba:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028bc:	e9 d5 fe ff ff       	jmp    c0102796 <__alltraps>

c01028c1 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $31
c01028c3:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028c5:	e9 cc fe ff ff       	jmp    c0102796 <__alltraps>

c01028ca <vector32>:
.globl vector32
vector32:
  pushl $0
c01028ca:	6a 00                	push   $0x0
  pushl $32
c01028cc:	6a 20                	push   $0x20
  jmp __alltraps
c01028ce:	e9 c3 fe ff ff       	jmp    c0102796 <__alltraps>

c01028d3 <vector33>:
.globl vector33
vector33:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $33
c01028d5:	6a 21                	push   $0x21
  jmp __alltraps
c01028d7:	e9 ba fe ff ff       	jmp    c0102796 <__alltraps>

c01028dc <vector34>:
.globl vector34
vector34:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $34
c01028de:	6a 22                	push   $0x22
  jmp __alltraps
c01028e0:	e9 b1 fe ff ff       	jmp    c0102796 <__alltraps>

c01028e5 <vector35>:
.globl vector35
vector35:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $35
c01028e7:	6a 23                	push   $0x23
  jmp __alltraps
c01028e9:	e9 a8 fe ff ff       	jmp    c0102796 <__alltraps>

c01028ee <vector36>:
.globl vector36
vector36:
  pushl $0
c01028ee:	6a 00                	push   $0x0
  pushl $36
c01028f0:	6a 24                	push   $0x24
  jmp __alltraps
c01028f2:	e9 9f fe ff ff       	jmp    c0102796 <__alltraps>

c01028f7 <vector37>:
.globl vector37
vector37:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $37
c01028f9:	6a 25                	push   $0x25
  jmp __alltraps
c01028fb:	e9 96 fe ff ff       	jmp    c0102796 <__alltraps>

c0102900 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $38
c0102902:	6a 26                	push   $0x26
  jmp __alltraps
c0102904:	e9 8d fe ff ff       	jmp    c0102796 <__alltraps>

c0102909 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $39
c010290b:	6a 27                	push   $0x27
  jmp __alltraps
c010290d:	e9 84 fe ff ff       	jmp    c0102796 <__alltraps>

c0102912 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102912:	6a 00                	push   $0x0
  pushl $40
c0102914:	6a 28                	push   $0x28
  jmp __alltraps
c0102916:	e9 7b fe ff ff       	jmp    c0102796 <__alltraps>

c010291b <vector41>:
.globl vector41
vector41:
  pushl $0
c010291b:	6a 00                	push   $0x0
  pushl $41
c010291d:	6a 29                	push   $0x29
  jmp __alltraps
c010291f:	e9 72 fe ff ff       	jmp    c0102796 <__alltraps>

c0102924 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $42
c0102926:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102928:	e9 69 fe ff ff       	jmp    c0102796 <__alltraps>

c010292d <vector43>:
.globl vector43
vector43:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $43
c010292f:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102931:	e9 60 fe ff ff       	jmp    c0102796 <__alltraps>

c0102936 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102936:	6a 00                	push   $0x0
  pushl $44
c0102938:	6a 2c                	push   $0x2c
  jmp __alltraps
c010293a:	e9 57 fe ff ff       	jmp    c0102796 <__alltraps>

c010293f <vector45>:
.globl vector45
vector45:
  pushl $0
c010293f:	6a 00                	push   $0x0
  pushl $45
c0102941:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102943:	e9 4e fe ff ff       	jmp    c0102796 <__alltraps>

c0102948 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $46
c010294a:	6a 2e                	push   $0x2e
  jmp __alltraps
c010294c:	e9 45 fe ff ff       	jmp    c0102796 <__alltraps>

c0102951 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $47
c0102953:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102955:	e9 3c fe ff ff       	jmp    c0102796 <__alltraps>

c010295a <vector48>:
.globl vector48
vector48:
  pushl $0
c010295a:	6a 00                	push   $0x0
  pushl $48
c010295c:	6a 30                	push   $0x30
  jmp __alltraps
c010295e:	e9 33 fe ff ff       	jmp    c0102796 <__alltraps>

c0102963 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102963:	6a 00                	push   $0x0
  pushl $49
c0102965:	6a 31                	push   $0x31
  jmp __alltraps
c0102967:	e9 2a fe ff ff       	jmp    c0102796 <__alltraps>

c010296c <vector50>:
.globl vector50
vector50:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $50
c010296e:	6a 32                	push   $0x32
  jmp __alltraps
c0102970:	e9 21 fe ff ff       	jmp    c0102796 <__alltraps>

c0102975 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $51
c0102977:	6a 33                	push   $0x33
  jmp __alltraps
c0102979:	e9 18 fe ff ff       	jmp    c0102796 <__alltraps>

c010297e <vector52>:
.globl vector52
vector52:
  pushl $0
c010297e:	6a 00                	push   $0x0
  pushl $52
c0102980:	6a 34                	push   $0x34
  jmp __alltraps
c0102982:	e9 0f fe ff ff       	jmp    c0102796 <__alltraps>

c0102987 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102987:	6a 00                	push   $0x0
  pushl $53
c0102989:	6a 35                	push   $0x35
  jmp __alltraps
c010298b:	e9 06 fe ff ff       	jmp    c0102796 <__alltraps>

c0102990 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $54
c0102992:	6a 36                	push   $0x36
  jmp __alltraps
c0102994:	e9 fd fd ff ff       	jmp    c0102796 <__alltraps>

c0102999 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $55
c010299b:	6a 37                	push   $0x37
  jmp __alltraps
c010299d:	e9 f4 fd ff ff       	jmp    c0102796 <__alltraps>

c01029a2 <vector56>:
.globl vector56
vector56:
  pushl $0
c01029a2:	6a 00                	push   $0x0
  pushl $56
c01029a4:	6a 38                	push   $0x38
  jmp __alltraps
c01029a6:	e9 eb fd ff ff       	jmp    c0102796 <__alltraps>

c01029ab <vector57>:
.globl vector57
vector57:
  pushl $0
c01029ab:	6a 00                	push   $0x0
  pushl $57
c01029ad:	6a 39                	push   $0x39
  jmp __alltraps
c01029af:	e9 e2 fd ff ff       	jmp    c0102796 <__alltraps>

c01029b4 <vector58>:
.globl vector58
vector58:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $58
c01029b6:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029b8:	e9 d9 fd ff ff       	jmp    c0102796 <__alltraps>

c01029bd <vector59>:
.globl vector59
vector59:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $59
c01029bf:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029c1:	e9 d0 fd ff ff       	jmp    c0102796 <__alltraps>

c01029c6 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029c6:	6a 00                	push   $0x0
  pushl $60
c01029c8:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029ca:	e9 c7 fd ff ff       	jmp    c0102796 <__alltraps>

c01029cf <vector61>:
.globl vector61
vector61:
  pushl $0
c01029cf:	6a 00                	push   $0x0
  pushl $61
c01029d1:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029d3:	e9 be fd ff ff       	jmp    c0102796 <__alltraps>

c01029d8 <vector62>:
.globl vector62
vector62:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $62
c01029da:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029dc:	e9 b5 fd ff ff       	jmp    c0102796 <__alltraps>

c01029e1 <vector63>:
.globl vector63
vector63:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $63
c01029e3:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029e5:	e9 ac fd ff ff       	jmp    c0102796 <__alltraps>

c01029ea <vector64>:
.globl vector64
vector64:
  pushl $0
c01029ea:	6a 00                	push   $0x0
  pushl $64
c01029ec:	6a 40                	push   $0x40
  jmp __alltraps
c01029ee:	e9 a3 fd ff ff       	jmp    c0102796 <__alltraps>

c01029f3 <vector65>:
.globl vector65
vector65:
  pushl $0
c01029f3:	6a 00                	push   $0x0
  pushl $65
c01029f5:	6a 41                	push   $0x41
  jmp __alltraps
c01029f7:	e9 9a fd ff ff       	jmp    c0102796 <__alltraps>

c01029fc <vector66>:
.globl vector66
vector66:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $66
c01029fe:	6a 42                	push   $0x42
  jmp __alltraps
c0102a00:	e9 91 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a05 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $67
c0102a07:	6a 43                	push   $0x43
  jmp __alltraps
c0102a09:	e9 88 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a0e <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a0e:	6a 00                	push   $0x0
  pushl $68
c0102a10:	6a 44                	push   $0x44
  jmp __alltraps
c0102a12:	e9 7f fd ff ff       	jmp    c0102796 <__alltraps>

c0102a17 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a17:	6a 00                	push   $0x0
  pushl $69
c0102a19:	6a 45                	push   $0x45
  jmp __alltraps
c0102a1b:	e9 76 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a20 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $70
c0102a22:	6a 46                	push   $0x46
  jmp __alltraps
c0102a24:	e9 6d fd ff ff       	jmp    c0102796 <__alltraps>

c0102a29 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $71
c0102a2b:	6a 47                	push   $0x47
  jmp __alltraps
c0102a2d:	e9 64 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a32 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a32:	6a 00                	push   $0x0
  pushl $72
c0102a34:	6a 48                	push   $0x48
  jmp __alltraps
c0102a36:	e9 5b fd ff ff       	jmp    c0102796 <__alltraps>

c0102a3b <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a3b:	6a 00                	push   $0x0
  pushl $73
c0102a3d:	6a 49                	push   $0x49
  jmp __alltraps
c0102a3f:	e9 52 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a44 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $74
c0102a46:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a48:	e9 49 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a4d <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $75
c0102a4f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a51:	e9 40 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a56 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a56:	6a 00                	push   $0x0
  pushl $76
c0102a58:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a5a:	e9 37 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a5f <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a5f:	6a 00                	push   $0x0
  pushl $77
c0102a61:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a63:	e9 2e fd ff ff       	jmp    c0102796 <__alltraps>

c0102a68 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a68:	6a 00                	push   $0x0
  pushl $78
c0102a6a:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a6c:	e9 25 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a71 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $79
c0102a73:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a75:	e9 1c fd ff ff       	jmp    c0102796 <__alltraps>

c0102a7a <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a7a:	6a 00                	push   $0x0
  pushl $80
c0102a7c:	6a 50                	push   $0x50
  jmp __alltraps
c0102a7e:	e9 13 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a83 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $81
c0102a85:	6a 51                	push   $0x51
  jmp __alltraps
c0102a87:	e9 0a fd ff ff       	jmp    c0102796 <__alltraps>

c0102a8c <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $82
c0102a8e:	6a 52                	push   $0x52
  jmp __alltraps
c0102a90:	e9 01 fd ff ff       	jmp    c0102796 <__alltraps>

c0102a95 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $83
c0102a97:	6a 53                	push   $0x53
  jmp __alltraps
c0102a99:	e9 f8 fc ff ff       	jmp    c0102796 <__alltraps>

c0102a9e <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a9e:	6a 00                	push   $0x0
  pushl $84
c0102aa0:	6a 54                	push   $0x54
  jmp __alltraps
c0102aa2:	e9 ef fc ff ff       	jmp    c0102796 <__alltraps>

c0102aa7 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102aa7:	6a 00                	push   $0x0
  pushl $85
c0102aa9:	6a 55                	push   $0x55
  jmp __alltraps
c0102aab:	e9 e6 fc ff ff       	jmp    c0102796 <__alltraps>

c0102ab0 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $86
c0102ab2:	6a 56                	push   $0x56
  jmp __alltraps
c0102ab4:	e9 dd fc ff ff       	jmp    c0102796 <__alltraps>

c0102ab9 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $87
c0102abb:	6a 57                	push   $0x57
  jmp __alltraps
c0102abd:	e9 d4 fc ff ff       	jmp    c0102796 <__alltraps>

c0102ac2 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ac2:	6a 00                	push   $0x0
  pushl $88
c0102ac4:	6a 58                	push   $0x58
  jmp __alltraps
c0102ac6:	e9 cb fc ff ff       	jmp    c0102796 <__alltraps>

c0102acb <vector89>:
.globl vector89
vector89:
  pushl $0
c0102acb:	6a 00                	push   $0x0
  pushl $89
c0102acd:	6a 59                	push   $0x59
  jmp __alltraps
c0102acf:	e9 c2 fc ff ff       	jmp    c0102796 <__alltraps>

c0102ad4 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102ad4:	6a 00                	push   $0x0
  pushl $90
c0102ad6:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102ad8:	e9 b9 fc ff ff       	jmp    c0102796 <__alltraps>

c0102add <vector91>:
.globl vector91
vector91:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $91
c0102adf:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102ae1:	e9 b0 fc ff ff       	jmp    c0102796 <__alltraps>

c0102ae6 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102ae6:	6a 00                	push   $0x0
  pushl $92
c0102ae8:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102aea:	e9 a7 fc ff ff       	jmp    c0102796 <__alltraps>

c0102aef <vector93>:
.globl vector93
vector93:
  pushl $0
c0102aef:	6a 00                	push   $0x0
  pushl $93
c0102af1:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102af3:	e9 9e fc ff ff       	jmp    c0102796 <__alltraps>

c0102af8 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102af8:	6a 00                	push   $0x0
  pushl $94
c0102afa:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102afc:	e9 95 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b01 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $95
c0102b03:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102b05:	e9 8c fc ff ff       	jmp    c0102796 <__alltraps>

c0102b0a <vector96>:
.globl vector96
vector96:
  pushl $0
c0102b0a:	6a 00                	push   $0x0
  pushl $96
c0102b0c:	6a 60                	push   $0x60
  jmp __alltraps
c0102b0e:	e9 83 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b13 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b13:	6a 00                	push   $0x0
  pushl $97
c0102b15:	6a 61                	push   $0x61
  jmp __alltraps
c0102b17:	e9 7a fc ff ff       	jmp    c0102796 <__alltraps>

c0102b1c <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b1c:	6a 00                	push   $0x0
  pushl $98
c0102b1e:	6a 62                	push   $0x62
  jmp __alltraps
c0102b20:	e9 71 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b25 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $99
c0102b27:	6a 63                	push   $0x63
  jmp __alltraps
c0102b29:	e9 68 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b2e <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b2e:	6a 00                	push   $0x0
  pushl $100
c0102b30:	6a 64                	push   $0x64
  jmp __alltraps
c0102b32:	e9 5f fc ff ff       	jmp    c0102796 <__alltraps>

c0102b37 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b37:	6a 00                	push   $0x0
  pushl $101
c0102b39:	6a 65                	push   $0x65
  jmp __alltraps
c0102b3b:	e9 56 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b40 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b40:	6a 00                	push   $0x0
  pushl $102
c0102b42:	6a 66                	push   $0x66
  jmp __alltraps
c0102b44:	e9 4d fc ff ff       	jmp    c0102796 <__alltraps>

c0102b49 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $103
c0102b4b:	6a 67                	push   $0x67
  jmp __alltraps
c0102b4d:	e9 44 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b52 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b52:	6a 00                	push   $0x0
  pushl $104
c0102b54:	6a 68                	push   $0x68
  jmp __alltraps
c0102b56:	e9 3b fc ff ff       	jmp    c0102796 <__alltraps>

c0102b5b <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b5b:	6a 00                	push   $0x0
  pushl $105
c0102b5d:	6a 69                	push   $0x69
  jmp __alltraps
c0102b5f:	e9 32 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b64 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b64:	6a 00                	push   $0x0
  pushl $106
c0102b66:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b68:	e9 29 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b6d <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $107
c0102b6f:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b71:	e9 20 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b76 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b76:	6a 00                	push   $0x0
  pushl $108
c0102b78:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b7a:	e9 17 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b7f <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b7f:	6a 00                	push   $0x0
  pushl $109
c0102b81:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b83:	e9 0e fc ff ff       	jmp    c0102796 <__alltraps>

c0102b88 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b88:	6a 00                	push   $0x0
  pushl $110
c0102b8a:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b8c:	e9 05 fc ff ff       	jmp    c0102796 <__alltraps>

c0102b91 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $111
c0102b93:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b95:	e9 fc fb ff ff       	jmp    c0102796 <__alltraps>

c0102b9a <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b9a:	6a 00                	push   $0x0
  pushl $112
c0102b9c:	6a 70                	push   $0x70
  jmp __alltraps
c0102b9e:	e9 f3 fb ff ff       	jmp    c0102796 <__alltraps>

c0102ba3 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102ba3:	6a 00                	push   $0x0
  pushl $113
c0102ba5:	6a 71                	push   $0x71
  jmp __alltraps
c0102ba7:	e9 ea fb ff ff       	jmp    c0102796 <__alltraps>

c0102bac <vector114>:
.globl vector114
vector114:
  pushl $0
c0102bac:	6a 00                	push   $0x0
  pushl $114
c0102bae:	6a 72                	push   $0x72
  jmp __alltraps
c0102bb0:	e9 e1 fb ff ff       	jmp    c0102796 <__alltraps>

c0102bb5 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102bb5:	6a 00                	push   $0x0
  pushl $115
c0102bb7:	6a 73                	push   $0x73
  jmp __alltraps
c0102bb9:	e9 d8 fb ff ff       	jmp    c0102796 <__alltraps>

c0102bbe <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bbe:	6a 00                	push   $0x0
  pushl $116
c0102bc0:	6a 74                	push   $0x74
  jmp __alltraps
c0102bc2:	e9 cf fb ff ff       	jmp    c0102796 <__alltraps>

c0102bc7 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bc7:	6a 00                	push   $0x0
  pushl $117
c0102bc9:	6a 75                	push   $0x75
  jmp __alltraps
c0102bcb:	e9 c6 fb ff ff       	jmp    c0102796 <__alltraps>

c0102bd0 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102bd0:	6a 00                	push   $0x0
  pushl $118
c0102bd2:	6a 76                	push   $0x76
  jmp __alltraps
c0102bd4:	e9 bd fb ff ff       	jmp    c0102796 <__alltraps>

c0102bd9 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $119
c0102bdb:	6a 77                	push   $0x77
  jmp __alltraps
c0102bdd:	e9 b4 fb ff ff       	jmp    c0102796 <__alltraps>

c0102be2 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102be2:	6a 00                	push   $0x0
  pushl $120
c0102be4:	6a 78                	push   $0x78
  jmp __alltraps
c0102be6:	e9 ab fb ff ff       	jmp    c0102796 <__alltraps>

c0102beb <vector121>:
.globl vector121
vector121:
  pushl $0
c0102beb:	6a 00                	push   $0x0
  pushl $121
c0102bed:	6a 79                	push   $0x79
  jmp __alltraps
c0102bef:	e9 a2 fb ff ff       	jmp    c0102796 <__alltraps>

c0102bf4 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102bf4:	6a 00                	push   $0x0
  pushl $122
c0102bf6:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102bf8:	e9 99 fb ff ff       	jmp    c0102796 <__alltraps>

c0102bfd <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bfd:	6a 00                	push   $0x0
  pushl $123
c0102bff:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102c01:	e9 90 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c06 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102c06:	6a 00                	push   $0x0
  pushl $124
c0102c08:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102c0a:	e9 87 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c0f <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c0f:	6a 00                	push   $0x0
  pushl $125
c0102c11:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c13:	e9 7e fb ff ff       	jmp    c0102796 <__alltraps>

c0102c18 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c18:	6a 00                	push   $0x0
  pushl $126
c0102c1a:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c1c:	e9 75 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c21 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c21:	6a 00                	push   $0x0
  pushl $127
c0102c23:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c25:	e9 6c fb ff ff       	jmp    c0102796 <__alltraps>

c0102c2a <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c2a:	6a 00                	push   $0x0
  pushl $128
c0102c2c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c31:	e9 60 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c36 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c36:	6a 00                	push   $0x0
  pushl $129
c0102c38:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c3d:	e9 54 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c42 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c42:	6a 00                	push   $0x0
  pushl $130
c0102c44:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c49:	e9 48 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c4e <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c4e:	6a 00                	push   $0x0
  pushl $131
c0102c50:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c55:	e9 3c fb ff ff       	jmp    c0102796 <__alltraps>

c0102c5a <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $132
c0102c5c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c61:	e9 30 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c66 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c66:	6a 00                	push   $0x0
  pushl $133
c0102c68:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c6d:	e9 24 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c72 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c72:	6a 00                	push   $0x0
  pushl $134
c0102c74:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c79:	e9 18 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c7e <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $135
c0102c80:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c85:	e9 0c fb ff ff       	jmp    c0102796 <__alltraps>

c0102c8a <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c8a:	6a 00                	push   $0x0
  pushl $136
c0102c8c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c91:	e9 00 fb ff ff       	jmp    c0102796 <__alltraps>

c0102c96 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $137
c0102c98:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c9d:	e9 f4 fa ff ff       	jmp    c0102796 <__alltraps>

c0102ca2 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $138
c0102ca4:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102ca9:	e9 e8 fa ff ff       	jmp    c0102796 <__alltraps>

c0102cae <vector139>:
.globl vector139
vector139:
  pushl $0
c0102cae:	6a 00                	push   $0x0
  pushl $139
c0102cb0:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102cb5:	e9 dc fa ff ff       	jmp    c0102796 <__alltraps>

c0102cba <vector140>:
.globl vector140
vector140:
  pushl $0
c0102cba:	6a 00                	push   $0x0
  pushl $140
c0102cbc:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cc1:	e9 d0 fa ff ff       	jmp    c0102796 <__alltraps>

c0102cc6 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $141
c0102cc8:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ccd:	e9 c4 fa ff ff       	jmp    c0102796 <__alltraps>

c0102cd2 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102cd2:	6a 00                	push   $0x0
  pushl $142
c0102cd4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102cd9:	e9 b8 fa ff ff       	jmp    c0102796 <__alltraps>

c0102cde <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cde:	6a 00                	push   $0x0
  pushl $143
c0102ce0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102ce5:	e9 ac fa ff ff       	jmp    c0102796 <__alltraps>

c0102cea <vector144>:
.globl vector144
vector144:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $144
c0102cec:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102cf1:	e9 a0 fa ff ff       	jmp    c0102796 <__alltraps>

c0102cf6 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102cf6:	6a 00                	push   $0x0
  pushl $145
c0102cf8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cfd:	e9 94 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d02 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102d02:	6a 00                	push   $0x0
  pushl $146
c0102d04:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102d09:	e9 88 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d0e <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $147
c0102d10:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d15:	e9 7c fa ff ff       	jmp    c0102796 <__alltraps>

c0102d1a <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d1a:	6a 00                	push   $0x0
  pushl $148
c0102d1c:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d21:	e9 70 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d26 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d26:	6a 00                	push   $0x0
  pushl $149
c0102d28:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d2d:	e9 64 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d32 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $150
c0102d34:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d39:	e9 58 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d3e <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d3e:	6a 00                	push   $0x0
  pushl $151
c0102d40:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d45:	e9 4c fa ff ff       	jmp    c0102796 <__alltraps>

c0102d4a <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d4a:	6a 00                	push   $0x0
  pushl $152
c0102d4c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d51:	e9 40 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d56 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d56:	6a 00                	push   $0x0
  pushl $153
c0102d58:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d5d:	e9 34 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d62 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d62:	6a 00                	push   $0x0
  pushl $154
c0102d64:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d69:	e9 28 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d6e <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d6e:	6a 00                	push   $0x0
  pushl $155
c0102d70:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d75:	e9 1c fa ff ff       	jmp    c0102796 <__alltraps>

c0102d7a <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d7a:	6a 00                	push   $0x0
  pushl $156
c0102d7c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d81:	e9 10 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d86 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d86:	6a 00                	push   $0x0
  pushl $157
c0102d88:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d8d:	e9 04 fa ff ff       	jmp    c0102796 <__alltraps>

c0102d92 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d92:	6a 00                	push   $0x0
  pushl $158
c0102d94:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d99:	e9 f8 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102d9e <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d9e:	6a 00                	push   $0x0
  pushl $159
c0102da0:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102da5:	e9 ec f9 ff ff       	jmp    c0102796 <__alltraps>

c0102daa <vector160>:
.globl vector160
vector160:
  pushl $0
c0102daa:	6a 00                	push   $0x0
  pushl $160
c0102dac:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102db1:	e9 e0 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102db6 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102db6:	6a 00                	push   $0x0
  pushl $161
c0102db8:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102dbd:	e9 d4 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102dc2 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102dc2:	6a 00                	push   $0x0
  pushl $162
c0102dc4:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102dc9:	e9 c8 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102dce <vector163>:
.globl vector163
vector163:
  pushl $0
c0102dce:	6a 00                	push   $0x0
  pushl $163
c0102dd0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102dd5:	e9 bc f9 ff ff       	jmp    c0102796 <__alltraps>

c0102dda <vector164>:
.globl vector164
vector164:
  pushl $0
c0102dda:	6a 00                	push   $0x0
  pushl $164
c0102ddc:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102de1:	e9 b0 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102de6 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102de6:	6a 00                	push   $0x0
  pushl $165
c0102de8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ded:	e9 a4 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102df2 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102df2:	6a 00                	push   $0x0
  pushl $166
c0102df4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102df9:	e9 98 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102dfe <vector167>:
.globl vector167
vector167:
  pushl $0
c0102dfe:	6a 00                	push   $0x0
  pushl $167
c0102e00:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102e05:	e9 8c f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e0a <vector168>:
.globl vector168
vector168:
  pushl $0
c0102e0a:	6a 00                	push   $0x0
  pushl $168
c0102e0c:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e11:	e9 80 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e16 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e16:	6a 00                	push   $0x0
  pushl $169
c0102e18:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e1d:	e9 74 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e22 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e22:	6a 00                	push   $0x0
  pushl $170
c0102e24:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e29:	e9 68 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e2e <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e2e:	6a 00                	push   $0x0
  pushl $171
c0102e30:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e35:	e9 5c f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e3a <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e3a:	6a 00                	push   $0x0
  pushl $172
c0102e3c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e41:	e9 50 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e46 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e46:	6a 00                	push   $0x0
  pushl $173
c0102e48:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e4d:	e9 44 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e52 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e52:	6a 00                	push   $0x0
  pushl $174
c0102e54:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e59:	e9 38 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e5e <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e5e:	6a 00                	push   $0x0
  pushl $175
c0102e60:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e65:	e9 2c f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e6a <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e6a:	6a 00                	push   $0x0
  pushl $176
c0102e6c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e71:	e9 20 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e76 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e76:	6a 00                	push   $0x0
  pushl $177
c0102e78:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e7d:	e9 14 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e82 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e82:	6a 00                	push   $0x0
  pushl $178
c0102e84:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e89:	e9 08 f9 ff ff       	jmp    c0102796 <__alltraps>

c0102e8e <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e8e:	6a 00                	push   $0x0
  pushl $179
c0102e90:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e95:	e9 fc f8 ff ff       	jmp    c0102796 <__alltraps>

c0102e9a <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e9a:	6a 00                	push   $0x0
  pushl $180
c0102e9c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102ea1:	e9 f0 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102ea6 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102ea6:	6a 00                	push   $0x0
  pushl $181
c0102ea8:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102ead:	e9 e4 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102eb2 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102eb2:	6a 00                	push   $0x0
  pushl $182
c0102eb4:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102eb9:	e9 d8 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102ebe <vector183>:
.globl vector183
vector183:
  pushl $0
c0102ebe:	6a 00                	push   $0x0
  pushl $183
c0102ec0:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102ec5:	e9 cc f8 ff ff       	jmp    c0102796 <__alltraps>

c0102eca <vector184>:
.globl vector184
vector184:
  pushl $0
c0102eca:	6a 00                	push   $0x0
  pushl $184
c0102ecc:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ed1:	e9 c0 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102ed6 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102ed6:	6a 00                	push   $0x0
  pushl $185
c0102ed8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102edd:	e9 b4 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102ee2 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ee2:	6a 00                	push   $0x0
  pushl $186
c0102ee4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ee9:	e9 a8 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102eee <vector187>:
.globl vector187
vector187:
  pushl $0
c0102eee:	6a 00                	push   $0x0
  pushl $187
c0102ef0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ef5:	e9 9c f8 ff ff       	jmp    c0102796 <__alltraps>

c0102efa <vector188>:
.globl vector188
vector188:
  pushl $0
c0102efa:	6a 00                	push   $0x0
  pushl $188
c0102efc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102f01:	e9 90 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f06 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102f06:	6a 00                	push   $0x0
  pushl $189
c0102f08:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102f0d:	e9 84 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f12 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f12:	6a 00                	push   $0x0
  pushl $190
c0102f14:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f19:	e9 78 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f1e <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f1e:	6a 00                	push   $0x0
  pushl $191
c0102f20:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f25:	e9 6c f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f2a <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f2a:	6a 00                	push   $0x0
  pushl $192
c0102f2c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f31:	e9 60 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f36 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f36:	6a 00                	push   $0x0
  pushl $193
c0102f38:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f3d:	e9 54 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f42 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f42:	6a 00                	push   $0x0
  pushl $194
c0102f44:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f49:	e9 48 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f4e <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f4e:	6a 00                	push   $0x0
  pushl $195
c0102f50:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f55:	e9 3c f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f5a <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f5a:	6a 00                	push   $0x0
  pushl $196
c0102f5c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f61:	e9 30 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f66 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f66:	6a 00                	push   $0x0
  pushl $197
c0102f68:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f6d:	e9 24 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f72 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f72:	6a 00                	push   $0x0
  pushl $198
c0102f74:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f79:	e9 18 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f7e <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f7e:	6a 00                	push   $0x0
  pushl $199
c0102f80:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f85:	e9 0c f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f8a <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f8a:	6a 00                	push   $0x0
  pushl $200
c0102f8c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f91:	e9 00 f8 ff ff       	jmp    c0102796 <__alltraps>

c0102f96 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f96:	6a 00                	push   $0x0
  pushl $201
c0102f98:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f9d:	e9 f4 f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fa2 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102fa2:	6a 00                	push   $0x0
  pushl $202
c0102fa4:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102fa9:	e9 e8 f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fae <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fae:	6a 00                	push   $0x0
  pushl $203
c0102fb0:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fb5:	e9 dc f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fba <vector204>:
.globl vector204
vector204:
  pushl $0
c0102fba:	6a 00                	push   $0x0
  pushl $204
c0102fbc:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102fc1:	e9 d0 f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fc6 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fc6:	6a 00                	push   $0x0
  pushl $205
c0102fc8:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fcd:	e9 c4 f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fd2 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fd2:	6a 00                	push   $0x0
  pushl $206
c0102fd4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fd9:	e9 b8 f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fde <vector207>:
.globl vector207
vector207:
  pushl $0
c0102fde:	6a 00                	push   $0x0
  pushl $207
c0102fe0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102fe5:	e9 ac f7 ff ff       	jmp    c0102796 <__alltraps>

c0102fea <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fea:	6a 00                	push   $0x0
  pushl $208
c0102fec:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102ff1:	e9 a0 f7 ff ff       	jmp    c0102796 <__alltraps>

c0102ff6 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102ff6:	6a 00                	push   $0x0
  pushl $209
c0102ff8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102ffd:	e9 94 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103002 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103002:	6a 00                	push   $0x0
  pushl $210
c0103004:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103009:	e9 88 f7 ff ff       	jmp    c0102796 <__alltraps>

c010300e <vector211>:
.globl vector211
vector211:
  pushl $0
c010300e:	6a 00                	push   $0x0
  pushl $211
c0103010:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103015:	e9 7c f7 ff ff       	jmp    c0102796 <__alltraps>

c010301a <vector212>:
.globl vector212
vector212:
  pushl $0
c010301a:	6a 00                	push   $0x0
  pushl $212
c010301c:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103021:	e9 70 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103026 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103026:	6a 00                	push   $0x0
  pushl $213
c0103028:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010302d:	e9 64 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103032 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103032:	6a 00                	push   $0x0
  pushl $214
c0103034:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103039:	e9 58 f7 ff ff       	jmp    c0102796 <__alltraps>

c010303e <vector215>:
.globl vector215
vector215:
  pushl $0
c010303e:	6a 00                	push   $0x0
  pushl $215
c0103040:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103045:	e9 4c f7 ff ff       	jmp    c0102796 <__alltraps>

c010304a <vector216>:
.globl vector216
vector216:
  pushl $0
c010304a:	6a 00                	push   $0x0
  pushl $216
c010304c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103051:	e9 40 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103056 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103056:	6a 00                	push   $0x0
  pushl $217
c0103058:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010305d:	e9 34 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103062 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103062:	6a 00                	push   $0x0
  pushl $218
c0103064:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103069:	e9 28 f7 ff ff       	jmp    c0102796 <__alltraps>

c010306e <vector219>:
.globl vector219
vector219:
  pushl $0
c010306e:	6a 00                	push   $0x0
  pushl $219
c0103070:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103075:	e9 1c f7 ff ff       	jmp    c0102796 <__alltraps>

c010307a <vector220>:
.globl vector220
vector220:
  pushl $0
c010307a:	6a 00                	push   $0x0
  pushl $220
c010307c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103081:	e9 10 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103086 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103086:	6a 00                	push   $0x0
  pushl $221
c0103088:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010308d:	e9 04 f7 ff ff       	jmp    c0102796 <__alltraps>

c0103092 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103092:	6a 00                	push   $0x0
  pushl $222
c0103094:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103099:	e9 f8 f6 ff ff       	jmp    c0102796 <__alltraps>

c010309e <vector223>:
.globl vector223
vector223:
  pushl $0
c010309e:	6a 00                	push   $0x0
  pushl $223
c01030a0:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01030a5:	e9 ec f6 ff ff       	jmp    c0102796 <__alltraps>

c01030aa <vector224>:
.globl vector224
vector224:
  pushl $0
c01030aa:	6a 00                	push   $0x0
  pushl $224
c01030ac:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030b1:	e9 e0 f6 ff ff       	jmp    c0102796 <__alltraps>

c01030b6 <vector225>:
.globl vector225
vector225:
  pushl $0
c01030b6:	6a 00                	push   $0x0
  pushl $225
c01030b8:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030bd:	e9 d4 f6 ff ff       	jmp    c0102796 <__alltraps>

c01030c2 <vector226>:
.globl vector226
vector226:
  pushl $0
c01030c2:	6a 00                	push   $0x0
  pushl $226
c01030c4:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030c9:	e9 c8 f6 ff ff       	jmp    c0102796 <__alltraps>

c01030ce <vector227>:
.globl vector227
vector227:
  pushl $0
c01030ce:	6a 00                	push   $0x0
  pushl $227
c01030d0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030d5:	e9 bc f6 ff ff       	jmp    c0102796 <__alltraps>

c01030da <vector228>:
.globl vector228
vector228:
  pushl $0
c01030da:	6a 00                	push   $0x0
  pushl $228
c01030dc:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030e1:	e9 b0 f6 ff ff       	jmp    c0102796 <__alltraps>

c01030e6 <vector229>:
.globl vector229
vector229:
  pushl $0
c01030e6:	6a 00                	push   $0x0
  pushl $229
c01030e8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030ed:	e9 a4 f6 ff ff       	jmp    c0102796 <__alltraps>

c01030f2 <vector230>:
.globl vector230
vector230:
  pushl $0
c01030f2:	6a 00                	push   $0x0
  pushl $230
c01030f4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030f9:	e9 98 f6 ff ff       	jmp    c0102796 <__alltraps>

c01030fe <vector231>:
.globl vector231
vector231:
  pushl $0
c01030fe:	6a 00                	push   $0x0
  pushl $231
c0103100:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103105:	e9 8c f6 ff ff       	jmp    c0102796 <__alltraps>

c010310a <vector232>:
.globl vector232
vector232:
  pushl $0
c010310a:	6a 00                	push   $0x0
  pushl $232
c010310c:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103111:	e9 80 f6 ff ff       	jmp    c0102796 <__alltraps>

c0103116 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103116:	6a 00                	push   $0x0
  pushl $233
c0103118:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010311d:	e9 74 f6 ff ff       	jmp    c0102796 <__alltraps>

c0103122 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103122:	6a 00                	push   $0x0
  pushl $234
c0103124:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103129:	e9 68 f6 ff ff       	jmp    c0102796 <__alltraps>

c010312e <vector235>:
.globl vector235
vector235:
  pushl $0
c010312e:	6a 00                	push   $0x0
  pushl $235
c0103130:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103135:	e9 5c f6 ff ff       	jmp    c0102796 <__alltraps>

c010313a <vector236>:
.globl vector236
vector236:
  pushl $0
c010313a:	6a 00                	push   $0x0
  pushl $236
c010313c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103141:	e9 50 f6 ff ff       	jmp    c0102796 <__alltraps>

c0103146 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103146:	6a 00                	push   $0x0
  pushl $237
c0103148:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010314d:	e9 44 f6 ff ff       	jmp    c0102796 <__alltraps>

c0103152 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103152:	6a 00                	push   $0x0
  pushl $238
c0103154:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103159:	e9 38 f6 ff ff       	jmp    c0102796 <__alltraps>

c010315e <vector239>:
.globl vector239
vector239:
  pushl $0
c010315e:	6a 00                	push   $0x0
  pushl $239
c0103160:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103165:	e9 2c f6 ff ff       	jmp    c0102796 <__alltraps>

c010316a <vector240>:
.globl vector240
vector240:
  pushl $0
c010316a:	6a 00                	push   $0x0
  pushl $240
c010316c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103171:	e9 20 f6 ff ff       	jmp    c0102796 <__alltraps>

c0103176 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103176:	6a 00                	push   $0x0
  pushl $241
c0103178:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010317d:	e9 14 f6 ff ff       	jmp    c0102796 <__alltraps>

c0103182 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103182:	6a 00                	push   $0x0
  pushl $242
c0103184:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103189:	e9 08 f6 ff ff       	jmp    c0102796 <__alltraps>

c010318e <vector243>:
.globl vector243
vector243:
  pushl $0
c010318e:	6a 00                	push   $0x0
  pushl $243
c0103190:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103195:	e9 fc f5 ff ff       	jmp    c0102796 <__alltraps>

c010319a <vector244>:
.globl vector244
vector244:
  pushl $0
c010319a:	6a 00                	push   $0x0
  pushl $244
c010319c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01031a1:	e9 f0 f5 ff ff       	jmp    c0102796 <__alltraps>

c01031a6 <vector245>:
.globl vector245
vector245:
  pushl $0
c01031a6:	6a 00                	push   $0x0
  pushl $245
c01031a8:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01031ad:	e9 e4 f5 ff ff       	jmp    c0102796 <__alltraps>

c01031b2 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031b2:	6a 00                	push   $0x0
  pushl $246
c01031b4:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031b9:	e9 d8 f5 ff ff       	jmp    c0102796 <__alltraps>

c01031be <vector247>:
.globl vector247
vector247:
  pushl $0
c01031be:	6a 00                	push   $0x0
  pushl $247
c01031c0:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031c5:	e9 cc f5 ff ff       	jmp    c0102796 <__alltraps>

c01031ca <vector248>:
.globl vector248
vector248:
  pushl $0
c01031ca:	6a 00                	push   $0x0
  pushl $248
c01031cc:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031d1:	e9 c0 f5 ff ff       	jmp    c0102796 <__alltraps>

c01031d6 <vector249>:
.globl vector249
vector249:
  pushl $0
c01031d6:	6a 00                	push   $0x0
  pushl $249
c01031d8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031dd:	e9 b4 f5 ff ff       	jmp    c0102796 <__alltraps>

c01031e2 <vector250>:
.globl vector250
vector250:
  pushl $0
c01031e2:	6a 00                	push   $0x0
  pushl $250
c01031e4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031e9:	e9 a8 f5 ff ff       	jmp    c0102796 <__alltraps>

c01031ee <vector251>:
.globl vector251
vector251:
  pushl $0
c01031ee:	6a 00                	push   $0x0
  pushl $251
c01031f0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031f5:	e9 9c f5 ff ff       	jmp    c0102796 <__alltraps>

c01031fa <vector252>:
.globl vector252
vector252:
  pushl $0
c01031fa:	6a 00                	push   $0x0
  pushl $252
c01031fc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103201:	e9 90 f5 ff ff       	jmp    c0102796 <__alltraps>

c0103206 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103206:	6a 00                	push   $0x0
  pushl $253
c0103208:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010320d:	e9 84 f5 ff ff       	jmp    c0102796 <__alltraps>

c0103212 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103212:	6a 00                	push   $0x0
  pushl $254
c0103214:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103219:	e9 78 f5 ff ff       	jmp    c0102796 <__alltraps>

c010321e <vector255>:
.globl vector255
vector255:
  pushl $0
c010321e:	6a 00                	push   $0x0
  pushl $255
c0103220:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103225:	e9 6c f5 ff ff       	jmp    c0102796 <__alltraps>

c010322a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010322a:	55                   	push   %ebp
c010322b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010322d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103230:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c0103235:	29 c2                	sub    %eax,%edx
c0103237:	89 d0                	mov    %edx,%eax
c0103239:	c1 f8 05             	sar    $0x5,%eax
}
c010323c:	5d                   	pop    %ebp
c010323d:	c3                   	ret    

c010323e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010323e:	55                   	push   %ebp
c010323f:	89 e5                	mov    %esp,%ebp
c0103241:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103244:	8b 45 08             	mov    0x8(%ebp),%eax
c0103247:	89 04 24             	mov    %eax,(%esp)
c010324a:	e8 db ff ff ff       	call   c010322a <page2ppn>
c010324f:	c1 e0 0c             	shl    $0xc,%eax
}
c0103252:	c9                   	leave  
c0103253:	c3                   	ret    

c0103254 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103254:	55                   	push   %ebp
c0103255:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103257:	8b 45 08             	mov    0x8(%ebp),%eax
c010325a:	8b 00                	mov    (%eax),%eax
}
c010325c:	5d                   	pop    %ebp
c010325d:	c3                   	ret    

c010325e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010325e:	55                   	push   %ebp
c010325f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103261:	8b 45 08             	mov    0x8(%ebp),%eax
c0103264:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103267:	89 10                	mov    %edx,(%eax)
}
c0103269:	5d                   	pop    %ebp
c010326a:	c3                   	ret    

c010326b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010326b:	55                   	push   %ebp
c010326c:	89 e5                	mov    %esp,%ebp
c010326e:	83 ec 10             	sub    $0x10,%esp
c0103271:	c7 45 fc 40 40 12 c0 	movl   $0xc0124040,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103278:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010327b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010327e:	89 50 04             	mov    %edx,0x4(%eax)
c0103281:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103284:	8b 50 04             	mov    0x4(%eax),%edx
c0103287:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010328a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010328c:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0103293:	00 00 00 
}
c0103296:	c9                   	leave  
c0103297:	c3                   	ret    

c0103298 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103298:	55                   	push   %ebp
c0103299:	89 e5                	mov    %esp,%ebp
c010329b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010329e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01032a2:	75 24                	jne    c01032c8 <default_init_memmap+0x30>
c01032a4:	c7 44 24 0c b0 94 10 	movl   $0xc01094b0,0xc(%esp)
c01032ab:	c0 
c01032ac:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01032b3:	c0 
c01032b4:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01032bb:	00 
c01032bc:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c01032c3:	e8 19 da ff ff       	call   c0100ce1 <__panic>
    struct Page *p = base;
c01032c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01032cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01032ce:	eb 7d                	jmp    c010334d <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032d3:	83 c0 04             	add    $0x4,%eax
c01032d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032e6:	0f a3 10             	bt     %edx,(%eax)
c01032e9:	19 c0                	sbb    %eax,%eax
c01032eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01032ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032f2:	0f 95 c0             	setne  %al
c01032f5:	0f b6 c0             	movzbl %al,%eax
c01032f8:	85 c0                	test   %eax,%eax
c01032fa:	75 24                	jne    c0103320 <default_init_memmap+0x88>
c01032fc:	c7 44 24 0c e1 94 10 	movl   $0xc01094e1,0xc(%esp)
c0103303:	c0 
c0103304:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010330b:	c0 
c010330c:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0103313:	00 
c0103314:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010331b:	e8 c1 d9 ff ff       	call   c0100ce1 <__panic>
        p->flags = p->property = 0;
c0103320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103323:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332d:	8b 50 08             	mov    0x8(%eax),%edx
c0103330:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103333:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0103336:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010333d:	00 
c010333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103341:	89 04 24             	mov    %eax,(%esp)
c0103344:	e8 15 ff ff ff       	call   c010325e <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103349:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010334d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103350:	c1 e0 05             	shl    $0x5,%eax
c0103353:	89 c2                	mov    %eax,%edx
c0103355:	8b 45 08             	mov    0x8(%ebp),%eax
c0103358:	01 d0                	add    %edx,%eax
c010335a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010335d:	0f 85 6d ff ff ff    	jne    c01032d0 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0103363:	8b 45 08             	mov    0x8(%ebp),%eax
c0103366:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103369:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010336c:	8b 45 08             	mov    0x8(%ebp),%eax
c010336f:	83 c0 04             	add    $0x4,%eax
c0103372:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103379:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010337c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010337f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103382:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0103385:	8b 15 48 40 12 c0    	mov    0xc0124048,%edx
c010338b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010338e:	01 d0                	add    %edx,%eax
c0103390:	a3 48 40 12 c0       	mov    %eax,0xc0124048
    list_add(&free_list, &(base->page_link));
c0103395:	8b 45 08             	mov    0x8(%ebp),%eax
c0103398:	83 c0 0c             	add    $0xc,%eax
c010339b:	c7 45 dc 40 40 12 c0 	movl   $0xc0124040,-0x24(%ebp)
c01033a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01033a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01033ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01033b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033b4:	8b 40 04             	mov    0x4(%eax),%eax
c01033b7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033ba:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01033bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033c0:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01033c3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01033c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033c9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01033cc:	89 10                	mov    %edx,(%eax)
c01033ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033d1:	8b 10                	mov    (%eax),%edx
c01033d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01033d6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01033d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033dc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01033df:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01033e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033e5:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01033e8:	89 10                	mov    %edx,(%eax)
}
c01033ea:	c9                   	leave  
c01033eb:	c3                   	ret    

c01033ec <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01033ec:	55                   	push   %ebp
c01033ed:	89 e5                	mov    %esp,%ebp
c01033ef:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01033f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033f6:	75 24                	jne    c010341c <default_alloc_pages+0x30>
c01033f8:	c7 44 24 0c b0 94 10 	movl   $0xc01094b0,0xc(%esp)
c01033ff:	c0 
c0103400:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103407:	c0 
c0103408:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c010340f:	00 
c0103410:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103417:	e8 c5 d8 ff ff       	call   c0100ce1 <__panic>
    if (n > nr_free) {
c010341c:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103421:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103424:	73 0a                	jae    c0103430 <default_alloc_pages+0x44>
        return NULL;
c0103426:	b8 00 00 00 00       	mov    $0x0,%eax
c010342b:	e9 36 01 00 00       	jmp    c0103566 <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c0103430:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103437:	c7 45 f0 40 40 12 c0 	movl   $0xc0124040,-0x10(%ebp)
 
// Step1：找到第一个长度大于等于n的块
    while ((le = list_next(le)) != &free_list) {
c010343e:	eb 1c                	jmp    c010345c <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0103440:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103443:	83 e8 0c             	sub    $0xc,%eax
c0103446:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103449:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010344c:	8b 40 08             	mov    0x8(%eax),%eax
c010344f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103452:	72 08                	jb     c010345c <default_alloc_pages+0x70>
            page = p;
c0103454:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103457:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010345a:	eb 18                	jmp    c0103474 <default_alloc_pages+0x88>
c010345c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010345f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103465:	8b 40 04             	mov    0x4(%eax),%eax
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
 
// Step1：找到第一个长度大于等于n的块
    while ((le = list_next(le)) != &free_list) {
c0103468:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010346b:	81 7d f0 40 40 12 c0 	cmpl   $0xc0124040,-0x10(%ebp)
c0103472:	75 cc                	jne    c0103440 <default_alloc_pages+0x54>
    }
 
// Step2：如果可以找到长度大于等于n的块，则
// (1) 如果长度大于n，在从这个块中取走长度为n的存储空间，并将剩下的存储空间插入到列表中
// (2) 删除原来的块
    if (page != NULL) {
c0103474:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103478:	0f 84 e5 00 00 00    	je     c0103563 <default_alloc_pages+0x177>
        if (page->property > n) {
c010347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103481:	8b 40 08             	mov    0x8(%eax),%eax
c0103484:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103487:	0f 86 85 00 00 00    	jbe    c0103512 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c010348d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103490:	c1 e0 05             	shl    $0x5,%eax
c0103493:	89 c2                	mov    %eax,%edx
c0103495:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103498:	01 d0                	add    %edx,%eax
c010349a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034a0:	8b 40 08             	mov    0x8(%eax),%eax
c01034a3:	2b 45 08             	sub    0x8(%ebp),%eax
c01034a6:	89 c2                	mov    %eax,%edx
c01034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ab:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034b1:	83 c0 04             	add    $0x4,%eax
c01034b4:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01034bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01034be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01034c4:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c01034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034ca:	83 c0 0c             	add    $0xc,%eax
c01034cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034d0:	83 c2 0c             	add    $0xc,%edx
c01034d3:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01034d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01034d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034dc:	8b 40 04             	mov    0x4(%eax),%eax
c01034df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034e2:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01034e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01034e8:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01034eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01034ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034f1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034f4:	89 10                	mov    %edx,(%eax)
c01034f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034f9:	8b 10                	mov    (%eax),%edx
c01034fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103501:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103504:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103507:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010350a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010350d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103510:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0103512:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103515:	83 c0 0c             	add    $0xc,%eax
c0103518:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010351b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010351e:	8b 40 04             	mov    0x4(%eax),%eax
c0103521:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103524:	8b 12                	mov    (%edx),%edx
c0103526:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103529:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010352c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010352f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103532:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103535:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103538:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010353b:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c010353d:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103542:	2b 45 08             	sub    0x8(%ebp),%eax
c0103545:	a3 48 40 12 c0       	mov    %eax,0xc0124048
        ClearPageProperty(page);
c010354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010354d:	83 c0 04             	add    $0x4,%eax
c0103550:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103557:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010355a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010355d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103560:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0103563:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103566:	c9                   	leave  
c0103567:	c3                   	ret    

c0103568 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103568:	55                   	push   %ebp
c0103569:	89 e5                	mov    %esp,%ebp
c010356b:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0103571:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103575:	75 24                	jne    c010359b <default_free_pages+0x33>
c0103577:	c7 44 24 0c b0 94 10 	movl   $0xc01094b0,0xc(%esp)
c010357e:	c0 
c010357f:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103586:	c0 
c0103587:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010358e:	00 
c010358f:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103596:	e8 46 d7 ff ff       	call   c0100ce1 <__panic>
    struct Page *p = base;
c010359b:	8b 45 08             	mov    0x8(%ebp),%eax
c010359e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
// 检查每个block中的各个page property是否合法
    for (; p != base + n; p ++) {
c01035a1:	e9 9d 00 00 00       	jmp    c0103643 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a9:	83 c0 04             	add    $0x4,%eax
c01035ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01035b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01035bc:	0f a3 10             	bt     %edx,(%eax)
c01035bf:	19 c0                	sbb    %eax,%eax
c01035c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c01035c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01035c8:	0f 95 c0             	setne  %al
c01035cb:	0f b6 c0             	movzbl %al,%eax
c01035ce:	85 c0                	test   %eax,%eax
c01035d0:	75 2c                	jne    c01035fe <default_free_pages+0x96>
c01035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d5:	83 c0 04             	add    $0x4,%eax
c01035d8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c01035df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01035e8:	0f a3 10             	bt     %edx,(%eax)
c01035eb:	19 c0                	sbb    %eax,%eax
c01035ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c01035f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01035f4:	0f 95 c0             	setne  %al
c01035f7:	0f b6 c0             	movzbl %al,%eax
c01035fa:	85 c0                	test   %eax,%eax
c01035fc:	74 24                	je     c0103622 <default_free_pages+0xba>
c01035fe:	c7 44 24 0c f4 94 10 	movl   $0xc01094f4,0xc(%esp)
c0103605:	c0 
c0103606:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010360d:	c0 
c010360e:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103615:	00 
c0103616:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010361d:	e8 bf d6 ff ff       	call   c0100ce1 <__panic>
        p->flags = 0;
c0103622:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010362c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103633:	00 
c0103634:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103637:	89 04 24             	mov    %eax,(%esp)
c010363a:	e8 1f fc ff ff       	call   c010325e <set_page_ref>
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
 
// 检查每个block中的各个page property是否合法
    for (; p != base + n; p ++) {
c010363f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103643:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103646:	c1 e0 05             	shl    $0x5,%eax
c0103649:	89 c2                	mov    %eax,%edx
c010364b:	8b 45 08             	mov    0x8(%ebp),%eax
c010364e:	01 d0                	add    %edx,%eax
c0103650:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103653:	0f 85 4d ff ff ff    	jne    c01035a6 <default_free_pages+0x3e>
        p->flags = 0;
        set_page_ref(p, 0);
    }
 
// 设置好释放空间的长度和page property
    base->property = n;
c0103659:	8b 45 08             	mov    0x8(%ebp),%eax
c010365c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010365f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103662:	8b 45 08             	mov    0x8(%ebp),%eax
c0103665:	83 c0 04             	add    $0x4,%eax
c0103668:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010366f:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103672:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103675:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103678:	0f ab 10             	bts    %edx,(%eax)
c010367b:	c7 45 c4 40 40 12 c0 	movl   $0xc0124040,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103682:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103685:	8b 40 04             	mov    0x4(%eax),%eax
 
// Step1：找到插入链表的位置（链表已按照地址从大到小排序）
    list_entry_t *le = list_next(&free_list);
c0103688:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *prev = &free_list;
c010368b:	c7 45 ec 40 40 12 c0 	movl   $0xc0124040,-0x14(%ebp)
    while (le != &free_list) {
c0103692:	eb 28                	jmp    c01036bc <default_free_pages+0x154>
        p = le2page(le, page_link);
c0103694:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103697:	83 e8 0c             	sub    $0xc,%eax
c010369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base < p) {
c010369d:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036a3:	73 02                	jae    c01036a7 <default_free_pages+0x13f>
            break;
c01036a5:	eb 1e                	jmp    c01036c5 <default_free_pages+0x15d>
        }
        prev = le;
c01036a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01036ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01036b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036b6:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01036b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    SetPageProperty(base);
 
// Step1：找到插入链表的位置（链表已按照地址从大到小排序）
    list_entry_t *le = list_next(&free_list);
    list_entry_t *prev = &free_list;
    while (le != &free_list) {
c01036bc:	81 7d f0 40 40 12 c0 	cmpl   $0xc0124040,-0x10(%ebp)
c01036c3:	75 cf                	jne    c0103694 <default_free_pages+0x12c>
        prev = le;
        le = list_next(le);
    }
 
// Step2：检查是否可以和链表的前一项中的空间合并
    p = le2page(prev, page_link);
c01036c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036c8:	83 e8 0c             	sub    $0xc,%eax
c01036cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (prev != &free_list && p + p -> property == base) {
c01036ce:	81 7d ec 40 40 12 c0 	cmpl   $0xc0124040,-0x14(%ebp)
c01036d5:	74 44                	je     c010371b <default_free_pages+0x1b3>
c01036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036da:	8b 40 08             	mov    0x8(%eax),%eax
c01036dd:	c1 e0 05             	shl    $0x5,%eax
c01036e0:	89 c2                	mov    %eax,%edx
c01036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e5:	01 d0                	add    %edx,%eax
c01036e7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036ea:	75 2f                	jne    c010371b <default_free_pages+0x1b3>
        p -> property += base -> property;
c01036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ef:	8b 50 08             	mov    0x8(%eax),%edx
c01036f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f5:	8b 40 08             	mov    0x8(%eax),%eax
c01036f8:	01 c2                	add    %eax,%edx
c01036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036fd:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(base);
c0103700:	8b 45 08             	mov    0x8(%ebp),%eax
c0103703:	83 c0 04             	add    $0x4,%eax
c0103706:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c010370d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103710:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103713:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103716:	0f b3 10             	btr    %edx,(%eax)
c0103719:	eb 4e                	jmp    c0103769 <default_free_pages+0x201>
    } else {
        list_add_after(prev, &(base -> page_link));
c010371b:	8b 45 08             	mov    0x8(%ebp),%eax
c010371e:	8d 50 0c             	lea    0xc(%eax),%edx
c0103721:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103724:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103727:	89 55 b0             	mov    %edx,-0x50(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010372a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010372d:	8b 40 04             	mov    0x4(%eax),%eax
c0103730:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103733:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0103736:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103739:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010373c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010373f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103742:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103745:	89 10                	mov    %edx,(%eax)
c0103747:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010374a:	8b 10                	mov    (%eax),%edx
c010374c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010374f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103752:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103755:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103758:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010375b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010375e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103761:	89 10                	mov    %edx,(%eax)
        p = base;
c0103763:	8b 45 08             	mov    0x8(%ebp),%eax
c0103766:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
 
// Step3：检查是否可以和链表的后一项中的空间合并
    struct Page *nextp = le2page(le, page_link);
c0103769:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010376c:	83 e8 0c             	sub    $0xc,%eax
c010376f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (le != &free_list && p + p -> property == nextp) {
c0103772:	81 7d f0 40 40 12 c0 	cmpl   $0xc0124040,-0x10(%ebp)
c0103779:	74 6a                	je     c01037e5 <default_free_pages+0x27d>
c010377b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377e:	8b 40 08             	mov    0x8(%eax),%eax
c0103781:	c1 e0 05             	shl    $0x5,%eax
c0103784:	89 c2                	mov    %eax,%edx
c0103786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103789:	01 d0                	add    %edx,%eax
c010378b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010378e:	75 55                	jne    c01037e5 <default_free_pages+0x27d>
        p -> property += nextp -> property;
c0103790:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103793:	8b 50 08             	mov    0x8(%eax),%edx
c0103796:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103799:	8b 40 08             	mov    0x8(%eax),%eax
c010379c:	01 c2                	add    %eax,%edx
c010379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037a1:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(nextp);
c01037a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037a7:	83 c0 04             	add    $0x4,%eax
c01037aa:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01037b1:	89 45 9c             	mov    %eax,-0x64(%ebp)
c01037b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037b7:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037ba:	0f b3 10             	btr    %edx,(%eax)
c01037bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037c0:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01037c3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01037c6:	8b 40 04             	mov    0x4(%eax),%eax
c01037c9:	8b 55 98             	mov    -0x68(%ebp),%edx
c01037cc:	8b 12                	mov    (%edx),%edx
c01037ce:	89 55 94             	mov    %edx,-0x6c(%ebp)
c01037d1:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01037d4:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01037d7:	8b 55 90             	mov    -0x70(%ebp),%edx
c01037da:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037dd:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037e0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037e3:	89 10                	mov    %edx,(%eax)
        list_del(le);
    }
 
    nr_free += n;
c01037e5:	8b 15 48 40 12 c0    	mov    0xc0124048,%edx
c01037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037ee:	01 d0                	add    %edx,%eax
c01037f0:	a3 48 40 12 c0       	mov    %eax,0xc0124048
}
c01037f5:	c9                   	leave  
c01037f6:	c3                   	ret    

c01037f7 <default_nr_free_pages>:


static size_t
default_nr_free_pages(void) {
c01037f7:	55                   	push   %ebp
c01037f8:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01037fa:	a1 48 40 12 c0       	mov    0xc0124048,%eax
}
c01037ff:	5d                   	pop    %ebp
c0103800:	c3                   	ret    

c0103801 <basic_check>:

static void
basic_check(void) {
c0103801:	55                   	push   %ebp
c0103802:	89 e5                	mov    %esp,%ebp
c0103804:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103807:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103811:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103814:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103817:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010381a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103821:	e8 d7 0e 00 00       	call   c01046fd <alloc_pages>
c0103826:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103829:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010382d:	75 24                	jne    c0103853 <basic_check+0x52>
c010382f:	c7 44 24 0c 19 95 10 	movl   $0xc0109519,0xc(%esp)
c0103836:	c0 
c0103837:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010383e:	c0 
c010383f:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0103846:	00 
c0103847:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010384e:	e8 8e d4 ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103853:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010385a:	e8 9e 0e 00 00       	call   c01046fd <alloc_pages>
c010385f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103862:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103866:	75 24                	jne    c010388c <basic_check+0x8b>
c0103868:	c7 44 24 0c 35 95 10 	movl   $0xc0109535,0xc(%esp)
c010386f:	c0 
c0103870:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103877:	c0 
c0103878:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010387f:	00 
c0103880:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103887:	e8 55 d4 ff ff       	call   c0100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010388c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103893:	e8 65 0e 00 00       	call   c01046fd <alloc_pages>
c0103898:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010389b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010389f:	75 24                	jne    c01038c5 <basic_check+0xc4>
c01038a1:	c7 44 24 0c 51 95 10 	movl   $0xc0109551,0xc(%esp)
c01038a8:	c0 
c01038a9:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01038b0:	c0 
c01038b1:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01038b8:	00 
c01038b9:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c01038c0:	e8 1c d4 ff ff       	call   c0100ce1 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01038c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038cb:	74 10                	je     c01038dd <basic_check+0xdc>
c01038cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038d3:	74 08                	je     c01038dd <basic_check+0xdc>
c01038d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038db:	75 24                	jne    c0103901 <basic_check+0x100>
c01038dd:	c7 44 24 0c 70 95 10 	movl   $0xc0109570,0xc(%esp)
c01038e4:	c0 
c01038e5:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01038ec:	c0 
c01038ed:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01038f4:	00 
c01038f5:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c01038fc:	e8 e0 d3 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103901:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103904:	89 04 24             	mov    %eax,(%esp)
c0103907:	e8 48 f9 ff ff       	call   c0103254 <page_ref>
c010390c:	85 c0                	test   %eax,%eax
c010390e:	75 1e                	jne    c010392e <basic_check+0x12d>
c0103910:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103913:	89 04 24             	mov    %eax,(%esp)
c0103916:	e8 39 f9 ff ff       	call   c0103254 <page_ref>
c010391b:	85 c0                	test   %eax,%eax
c010391d:	75 0f                	jne    c010392e <basic_check+0x12d>
c010391f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103922:	89 04 24             	mov    %eax,(%esp)
c0103925:	e8 2a f9 ff ff       	call   c0103254 <page_ref>
c010392a:	85 c0                	test   %eax,%eax
c010392c:	74 24                	je     c0103952 <basic_check+0x151>
c010392e:	c7 44 24 0c 94 95 10 	movl   $0xc0109594,0xc(%esp)
c0103935:	c0 
c0103936:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010393d:	c0 
c010393e:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103945:	00 
c0103946:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010394d:	e8 8f d3 ff ff       	call   c0100ce1 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103952:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103955:	89 04 24             	mov    %eax,(%esp)
c0103958:	e8 e1 f8 ff ff       	call   c010323e <page2pa>
c010395d:	8b 15 a0 3f 12 c0    	mov    0xc0123fa0,%edx
c0103963:	c1 e2 0c             	shl    $0xc,%edx
c0103966:	39 d0                	cmp    %edx,%eax
c0103968:	72 24                	jb     c010398e <basic_check+0x18d>
c010396a:	c7 44 24 0c d0 95 10 	movl   $0xc01095d0,0xc(%esp)
c0103971:	c0 
c0103972:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103979:	c0 
c010397a:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0103981:	00 
c0103982:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103989:	e8 53 d3 ff ff       	call   c0100ce1 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010398e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103991:	89 04 24             	mov    %eax,(%esp)
c0103994:	e8 a5 f8 ff ff       	call   c010323e <page2pa>
c0103999:	8b 15 a0 3f 12 c0    	mov    0xc0123fa0,%edx
c010399f:	c1 e2 0c             	shl    $0xc,%edx
c01039a2:	39 d0                	cmp    %edx,%eax
c01039a4:	72 24                	jb     c01039ca <basic_check+0x1c9>
c01039a6:	c7 44 24 0c ed 95 10 	movl   $0xc01095ed,0xc(%esp)
c01039ad:	c0 
c01039ae:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01039b5:	c0 
c01039b6:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01039bd:	00 
c01039be:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c01039c5:	e8 17 d3 ff ff       	call   c0100ce1 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01039ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039cd:	89 04 24             	mov    %eax,(%esp)
c01039d0:	e8 69 f8 ff ff       	call   c010323e <page2pa>
c01039d5:	8b 15 a0 3f 12 c0    	mov    0xc0123fa0,%edx
c01039db:	c1 e2 0c             	shl    $0xc,%edx
c01039de:	39 d0                	cmp    %edx,%eax
c01039e0:	72 24                	jb     c0103a06 <basic_check+0x205>
c01039e2:	c7 44 24 0c 0a 96 10 	movl   $0xc010960a,0xc(%esp)
c01039e9:	c0 
c01039ea:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01039f1:	c0 
c01039f2:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01039f9:	00 
c01039fa:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103a01:	e8 db d2 ff ff       	call   c0100ce1 <__panic>

    list_entry_t free_list_store = free_list;
c0103a06:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c0103a0b:	8b 15 44 40 12 c0    	mov    0xc0124044,%edx
c0103a11:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a17:	c7 45 e0 40 40 12 c0 	movl   $0xc0124040,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a24:	89 50 04             	mov    %edx,0x4(%eax)
c0103a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a2a:	8b 50 04             	mov    0x4(%eax),%edx
c0103a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a30:	89 10                	mov    %edx,(%eax)
c0103a32:	c7 45 dc 40 40 12 c0 	movl   $0xc0124040,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103a39:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a3c:	8b 40 04             	mov    0x4(%eax),%eax
c0103a3f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103a42:	0f 94 c0             	sete   %al
c0103a45:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103a48:	85 c0                	test   %eax,%eax
c0103a4a:	75 24                	jne    c0103a70 <basic_check+0x26f>
c0103a4c:	c7 44 24 0c 27 96 10 	movl   $0xc0109627,0xc(%esp)
c0103a53:	c0 
c0103a54:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103a5b:	c0 
c0103a5c:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103a63:	00 
c0103a64:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103a6b:	e8 71 d2 ff ff       	call   c0100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103a70:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103a75:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103a78:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0103a7f:	00 00 00 

    assert(alloc_page() == NULL);
c0103a82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a89:	e8 6f 0c 00 00       	call   c01046fd <alloc_pages>
c0103a8e:	85 c0                	test   %eax,%eax
c0103a90:	74 24                	je     c0103ab6 <basic_check+0x2b5>
c0103a92:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c0103a99:	c0 
c0103a9a:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103aa1:	c0 
c0103aa2:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103aa9:	00 
c0103aaa:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103ab1:	e8 2b d2 ff ff       	call   c0100ce1 <__panic>

    free_page(p0);
c0103ab6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103abd:	00 
c0103abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ac1:	89 04 24             	mov    %eax,(%esp)
c0103ac4:	e8 9f 0c 00 00       	call   c0104768 <free_pages>
    free_page(p1);
c0103ac9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ad0:	00 
c0103ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ad4:	89 04 24             	mov    %eax,(%esp)
c0103ad7:	e8 8c 0c 00 00       	call   c0104768 <free_pages>
    free_page(p2);
c0103adc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ae3:	00 
c0103ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae7:	89 04 24             	mov    %eax,(%esp)
c0103aea:	e8 79 0c 00 00       	call   c0104768 <free_pages>
    assert(nr_free == 3);
c0103aef:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103af4:	83 f8 03             	cmp    $0x3,%eax
c0103af7:	74 24                	je     c0103b1d <basic_check+0x31c>
c0103af9:	c7 44 24 0c 53 96 10 	movl   $0xc0109653,0xc(%esp)
c0103b00:	c0 
c0103b01:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103b08:	c0 
c0103b09:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103b10:	00 
c0103b11:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103b18:	e8 c4 d1 ff ff       	call   c0100ce1 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b24:	e8 d4 0b 00 00       	call   c01046fd <alloc_pages>
c0103b29:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b30:	75 24                	jne    c0103b56 <basic_check+0x355>
c0103b32:	c7 44 24 0c 19 95 10 	movl   $0xc0109519,0xc(%esp)
c0103b39:	c0 
c0103b3a:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103b41:	c0 
c0103b42:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103b49:	00 
c0103b4a:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103b51:	e8 8b d1 ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b5d:	e8 9b 0b 00 00       	call   c01046fd <alloc_pages>
c0103b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b69:	75 24                	jne    c0103b8f <basic_check+0x38e>
c0103b6b:	c7 44 24 0c 35 95 10 	movl   $0xc0109535,0xc(%esp)
c0103b72:	c0 
c0103b73:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103b7a:	c0 
c0103b7b:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103b82:	00 
c0103b83:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103b8a:	e8 52 d1 ff ff       	call   c0100ce1 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b96:	e8 62 0b 00 00       	call   c01046fd <alloc_pages>
c0103b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ba2:	75 24                	jne    c0103bc8 <basic_check+0x3c7>
c0103ba4:	c7 44 24 0c 51 95 10 	movl   $0xc0109551,0xc(%esp)
c0103bab:	c0 
c0103bac:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103bb3:	c0 
c0103bb4:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103bbb:	00 
c0103bbc:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103bc3:	e8 19 d1 ff ff       	call   c0100ce1 <__panic>

    assert(alloc_page() == NULL);
c0103bc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bcf:	e8 29 0b 00 00       	call   c01046fd <alloc_pages>
c0103bd4:	85 c0                	test   %eax,%eax
c0103bd6:	74 24                	je     c0103bfc <basic_check+0x3fb>
c0103bd8:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103be7:	c0 
c0103be8:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103bef:	00 
c0103bf0:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103bf7:	e8 e5 d0 ff ff       	call   c0100ce1 <__panic>

    free_page(p0);
c0103bfc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c03:	00 
c0103c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c07:	89 04 24             	mov    %eax,(%esp)
c0103c0a:	e8 59 0b 00 00       	call   c0104768 <free_pages>
c0103c0f:	c7 45 d8 40 40 12 c0 	movl   $0xc0124040,-0x28(%ebp)
c0103c16:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c19:	8b 40 04             	mov    0x4(%eax),%eax
c0103c1c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c1f:	0f 94 c0             	sete   %al
c0103c22:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c25:	85 c0                	test   %eax,%eax
c0103c27:	74 24                	je     c0103c4d <basic_check+0x44c>
c0103c29:	c7 44 24 0c 60 96 10 	movl   $0xc0109660,0xc(%esp)
c0103c30:	c0 
c0103c31:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103c38:	c0 
c0103c39:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103c40:	00 
c0103c41:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103c48:	e8 94 d0 ff ff       	call   c0100ce1 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103c4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c54:	e8 a4 0a 00 00       	call   c01046fd <alloc_pages>
c0103c59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c5f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103c62:	74 24                	je     c0103c88 <basic_check+0x487>
c0103c64:	c7 44 24 0c 78 96 10 	movl   $0xc0109678,0xc(%esp)
c0103c6b:	c0 
c0103c6c:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103c73:	c0 
c0103c74:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103c7b:	00 
c0103c7c:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103c83:	e8 59 d0 ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0103c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c8f:	e8 69 0a 00 00       	call   c01046fd <alloc_pages>
c0103c94:	85 c0                	test   %eax,%eax
c0103c96:	74 24                	je     c0103cbc <basic_check+0x4bb>
c0103c98:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c0103c9f:	c0 
c0103ca0:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103ca7:	c0 
c0103ca8:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103caf:	00 
c0103cb0:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103cb7:	e8 25 d0 ff ff       	call   c0100ce1 <__panic>

    assert(nr_free == 0);
c0103cbc:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103cc1:	85 c0                	test   %eax,%eax
c0103cc3:	74 24                	je     c0103ce9 <basic_check+0x4e8>
c0103cc5:	c7 44 24 0c 91 96 10 	movl   $0xc0109691,0xc(%esp)
c0103ccc:	c0 
c0103ccd:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103cd4:	c0 
c0103cd5:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103cdc:	00 
c0103cdd:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103ce4:	e8 f8 cf ff ff       	call   c0100ce1 <__panic>
    free_list = free_list_store;
c0103ce9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103cec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103cef:	a3 40 40 12 c0       	mov    %eax,0xc0124040
c0103cf4:	89 15 44 40 12 c0    	mov    %edx,0xc0124044
    nr_free = nr_free_store;
c0103cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cfd:	a3 48 40 12 c0       	mov    %eax,0xc0124048

    free_page(p);
c0103d02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d09:	00 
c0103d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d0d:	89 04 24             	mov    %eax,(%esp)
c0103d10:	e8 53 0a 00 00       	call   c0104768 <free_pages>
    free_page(p1);
c0103d15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d1c:	00 
c0103d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d20:	89 04 24             	mov    %eax,(%esp)
c0103d23:	e8 40 0a 00 00       	call   c0104768 <free_pages>
    free_page(p2);
c0103d28:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d2f:	00 
c0103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d33:	89 04 24             	mov    %eax,(%esp)
c0103d36:	e8 2d 0a 00 00       	call   c0104768 <free_pages>
}
c0103d3b:	c9                   	leave  
c0103d3c:	c3                   	ret    

c0103d3d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103d3d:	55                   	push   %ebp
c0103d3e:	89 e5                	mov    %esp,%ebp
c0103d40:	53                   	push   %ebx
c0103d41:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103d47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103d55:	c7 45 ec 40 40 12 c0 	movl   $0xc0124040,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d5c:	eb 6b                	jmp    c0103dc9 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d61:	83 e8 0c             	sub    $0xc,%eax
c0103d64:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d6a:	83 c0 04             	add    $0x4,%eax
c0103d6d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103d74:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d77:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d7a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d7d:	0f a3 10             	bt     %edx,(%eax)
c0103d80:	19 c0                	sbb    %eax,%eax
c0103d82:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103d85:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d89:	0f 95 c0             	setne  %al
c0103d8c:	0f b6 c0             	movzbl %al,%eax
c0103d8f:	85 c0                	test   %eax,%eax
c0103d91:	75 24                	jne    c0103db7 <default_check+0x7a>
c0103d93:	c7 44 24 0c 9e 96 10 	movl   $0xc010969e,0xc(%esp)
c0103d9a:	c0 
c0103d9b:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103da2:	c0 
c0103da3:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0103daa:	00 
c0103dab:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103db2:	e8 2a cf ff ff       	call   c0100ce1 <__panic>
        count ++, total += p->property;
c0103db7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dbe:	8b 50 08             	mov    0x8(%eax),%edx
c0103dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dc4:	01 d0                	add    %edx,%eax
c0103dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dcc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103dcf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103dd2:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103dd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103dd8:	81 7d ec 40 40 12 c0 	cmpl   $0xc0124040,-0x14(%ebp)
c0103ddf:	0f 85 79 ff ff ff    	jne    c0103d5e <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103de5:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103de8:	e8 ad 09 00 00       	call   c010479a <nr_free_pages>
c0103ded:	39 c3                	cmp    %eax,%ebx
c0103def:	74 24                	je     c0103e15 <default_check+0xd8>
c0103df1:	c7 44 24 0c ae 96 10 	movl   $0xc01096ae,0xc(%esp)
c0103df8:	c0 
c0103df9:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103e00:	c0 
c0103e01:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103e08:	00 
c0103e09:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103e10:	e8 cc ce ff ff       	call   c0100ce1 <__panic>

    basic_check();
c0103e15:	e8 e7 f9 ff ff       	call   c0103801 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e1a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e21:	e8 d7 08 00 00       	call   c01046fd <alloc_pages>
c0103e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103e29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e2d:	75 24                	jne    c0103e53 <default_check+0x116>
c0103e2f:	c7 44 24 0c c7 96 10 	movl   $0xc01096c7,0xc(%esp)
c0103e36:	c0 
c0103e37:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103e3e:	c0 
c0103e3f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103e46:	00 
c0103e47:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103e4e:	e8 8e ce ff ff       	call   c0100ce1 <__panic>
    assert(!PageProperty(p0));
c0103e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e56:	83 c0 04             	add    $0x4,%eax
c0103e59:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103e60:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e63:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e66:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e69:	0f a3 10             	bt     %edx,(%eax)
c0103e6c:	19 c0                	sbb    %eax,%eax
c0103e6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103e71:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103e75:	0f 95 c0             	setne  %al
c0103e78:	0f b6 c0             	movzbl %al,%eax
c0103e7b:	85 c0                	test   %eax,%eax
c0103e7d:	74 24                	je     c0103ea3 <default_check+0x166>
c0103e7f:	c7 44 24 0c d2 96 10 	movl   $0xc01096d2,0xc(%esp)
c0103e86:	c0 
c0103e87:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103e8e:	c0 
c0103e8f:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103e96:	00 
c0103e97:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103e9e:	e8 3e ce ff ff       	call   c0100ce1 <__panic>

    list_entry_t free_list_store = free_list;
c0103ea3:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c0103ea8:	8b 15 44 40 12 c0    	mov    0xc0124044,%edx
c0103eae:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103eb1:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103eb4:	c7 45 b4 40 40 12 c0 	movl   $0xc0124040,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ebb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ebe:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ec1:	89 50 04             	mov    %edx,0x4(%eax)
c0103ec4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ec7:	8b 50 04             	mov    0x4(%eax),%edx
c0103eca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ecd:	89 10                	mov    %edx,(%eax)
c0103ecf:	c7 45 b0 40 40 12 c0 	movl   $0xc0124040,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103ed6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ed9:	8b 40 04             	mov    0x4(%eax),%eax
c0103edc:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103edf:	0f 94 c0             	sete   %al
c0103ee2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ee5:	85 c0                	test   %eax,%eax
c0103ee7:	75 24                	jne    c0103f0d <default_check+0x1d0>
c0103ee9:	c7 44 24 0c 27 96 10 	movl   $0xc0109627,0xc(%esp)
c0103ef0:	c0 
c0103ef1:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103ef8:	c0 
c0103ef9:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0103f00:	00 
c0103f01:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103f08:	e8 d4 cd ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0103f0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f14:	e8 e4 07 00 00       	call   c01046fd <alloc_pages>
c0103f19:	85 c0                	test   %eax,%eax
c0103f1b:	74 24                	je     c0103f41 <default_check+0x204>
c0103f1d:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c0103f24:	c0 
c0103f25:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103f2c:	c0 
c0103f2d:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103f34:	00 
c0103f35:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103f3c:	e8 a0 cd ff ff       	call   c0100ce1 <__panic>

    unsigned int nr_free_store = nr_free;
c0103f41:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c0103f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103f49:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0103f50:	00 00 00 

    free_pages(p0 + 2, 3);
c0103f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f56:	83 c0 40             	add    $0x40,%eax
c0103f59:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f60:	00 
c0103f61:	89 04 24             	mov    %eax,(%esp)
c0103f64:	e8 ff 07 00 00       	call   c0104768 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f69:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103f70:	e8 88 07 00 00       	call   c01046fd <alloc_pages>
c0103f75:	85 c0                	test   %eax,%eax
c0103f77:	74 24                	je     c0103f9d <default_check+0x260>
c0103f79:	c7 44 24 0c e4 96 10 	movl   $0xc01096e4,0xc(%esp)
c0103f80:	c0 
c0103f81:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103f88:	c0 
c0103f89:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103f90:	00 
c0103f91:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103f98:	e8 44 cd ff ff       	call   c0100ce1 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103f9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fa0:	83 c0 40             	add    $0x40,%eax
c0103fa3:	83 c0 04             	add    $0x4,%eax
c0103fa6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103fad:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fb0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fb3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103fb6:	0f a3 10             	bt     %edx,(%eax)
c0103fb9:	19 c0                	sbb    %eax,%eax
c0103fbb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103fbe:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103fc2:	0f 95 c0             	setne  %al
c0103fc5:	0f b6 c0             	movzbl %al,%eax
c0103fc8:	85 c0                	test   %eax,%eax
c0103fca:	74 0e                	je     c0103fda <default_check+0x29d>
c0103fcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fcf:	83 c0 40             	add    $0x40,%eax
c0103fd2:	8b 40 08             	mov    0x8(%eax),%eax
c0103fd5:	83 f8 03             	cmp    $0x3,%eax
c0103fd8:	74 24                	je     c0103ffe <default_check+0x2c1>
c0103fda:	c7 44 24 0c fc 96 10 	movl   $0xc01096fc,0xc(%esp)
c0103fe1:	c0 
c0103fe2:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0103fe9:	c0 
c0103fea:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0103ff1:	00 
c0103ff2:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0103ff9:	e8 e3 cc ff ff       	call   c0100ce1 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103ffe:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104005:	e8 f3 06 00 00       	call   c01046fd <alloc_pages>
c010400a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010400d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104011:	75 24                	jne    c0104037 <default_check+0x2fa>
c0104013:	c7 44 24 0c 28 97 10 	movl   $0xc0109728,0xc(%esp)
c010401a:	c0 
c010401b:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0104022:	c0 
c0104023:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c010402a:	00 
c010402b:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0104032:	e8 aa cc ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c0104037:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010403e:	e8 ba 06 00 00       	call   c01046fd <alloc_pages>
c0104043:	85 c0                	test   %eax,%eax
c0104045:	74 24                	je     c010406b <default_check+0x32e>
c0104047:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c010404e:	c0 
c010404f:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0104056:	c0 
c0104057:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c010405e:	00 
c010405f:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0104066:	e8 76 cc ff ff       	call   c0100ce1 <__panic>
    assert(p0 + 2 == p1);
c010406b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010406e:	83 c0 40             	add    $0x40,%eax
c0104071:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104074:	74 24                	je     c010409a <default_check+0x35d>
c0104076:	c7 44 24 0c 46 97 10 	movl   $0xc0109746,0xc(%esp)
c010407d:	c0 
c010407e:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0104085:	c0 
c0104086:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c010408d:	00 
c010408e:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0104095:	e8 47 cc ff ff       	call   c0100ce1 <__panic>

    p2 = p0 + 1;
c010409a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010409d:	83 c0 20             	add    $0x20,%eax
c01040a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01040a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040aa:	00 
c01040ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040ae:	89 04 24             	mov    %eax,(%esp)
c01040b1:	e8 b2 06 00 00       	call   c0104768 <free_pages>
    free_pages(p1, 3);
c01040b6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040bd:	00 
c01040be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040c1:	89 04 24             	mov    %eax,(%esp)
c01040c4:	e8 9f 06 00 00       	call   c0104768 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01040c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040cc:	83 c0 04             	add    $0x4,%eax
c01040cf:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01040d6:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040dc:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01040df:	0f a3 10             	bt     %edx,(%eax)
c01040e2:	19 c0                	sbb    %eax,%eax
c01040e4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01040e7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01040eb:	0f 95 c0             	setne  %al
c01040ee:	0f b6 c0             	movzbl %al,%eax
c01040f1:	85 c0                	test   %eax,%eax
c01040f3:	74 0b                	je     c0104100 <default_check+0x3c3>
c01040f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040f8:	8b 40 08             	mov    0x8(%eax),%eax
c01040fb:	83 f8 01             	cmp    $0x1,%eax
c01040fe:	74 24                	je     c0104124 <default_check+0x3e7>
c0104100:	c7 44 24 0c 54 97 10 	movl   $0xc0109754,0xc(%esp)
c0104107:	c0 
c0104108:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010410f:	c0 
c0104110:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104117:	00 
c0104118:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010411f:	e8 bd cb ff ff       	call   c0100ce1 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104124:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104127:	83 c0 04             	add    $0x4,%eax
c010412a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104131:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104134:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104137:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010413a:	0f a3 10             	bt     %edx,(%eax)
c010413d:	19 c0                	sbb    %eax,%eax
c010413f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104142:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104146:	0f 95 c0             	setne  %al
c0104149:	0f b6 c0             	movzbl %al,%eax
c010414c:	85 c0                	test   %eax,%eax
c010414e:	74 0b                	je     c010415b <default_check+0x41e>
c0104150:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104153:	8b 40 08             	mov    0x8(%eax),%eax
c0104156:	83 f8 03             	cmp    $0x3,%eax
c0104159:	74 24                	je     c010417f <default_check+0x442>
c010415b:	c7 44 24 0c 7c 97 10 	movl   $0xc010977c,0xc(%esp)
c0104162:	c0 
c0104163:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010416a:	c0 
c010416b:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0104172:	00 
c0104173:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010417a:	e8 62 cb ff ff       	call   c0100ce1 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010417f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104186:	e8 72 05 00 00       	call   c01046fd <alloc_pages>
c010418b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010418e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104191:	83 e8 20             	sub    $0x20,%eax
c0104194:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104197:	74 24                	je     c01041bd <default_check+0x480>
c0104199:	c7 44 24 0c a2 97 10 	movl   $0xc01097a2,0xc(%esp)
c01041a0:	c0 
c01041a1:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01041a8:	c0 
c01041a9:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01041b0:	00 
c01041b1:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c01041b8:	e8 24 cb ff ff       	call   c0100ce1 <__panic>
    free_page(p0);
c01041bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041c4:	00 
c01041c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041c8:	89 04 24             	mov    %eax,(%esp)
c01041cb:	e8 98 05 00 00       	call   c0104768 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01041d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01041d7:	e8 21 05 00 00       	call   c01046fd <alloc_pages>
c01041dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041e2:	83 c0 20             	add    $0x20,%eax
c01041e5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041e8:	74 24                	je     c010420e <default_check+0x4d1>
c01041ea:	c7 44 24 0c c0 97 10 	movl   $0xc01097c0,0xc(%esp)
c01041f1:	c0 
c01041f2:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01041f9:	c0 
c01041fa:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0104201:	00 
c0104202:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0104209:	e8 d3 ca ff ff       	call   c0100ce1 <__panic>

    free_pages(p0, 2);
c010420e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104215:	00 
c0104216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104219:	89 04 24             	mov    %eax,(%esp)
c010421c:	e8 47 05 00 00       	call   c0104768 <free_pages>
    free_page(p2);
c0104221:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104228:	00 
c0104229:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010422c:	89 04 24             	mov    %eax,(%esp)
c010422f:	e8 34 05 00 00       	call   c0104768 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104234:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010423b:	e8 bd 04 00 00       	call   c01046fd <alloc_pages>
c0104240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104243:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104247:	75 24                	jne    c010426d <default_check+0x530>
c0104249:	c7 44 24 0c e0 97 10 	movl   $0xc01097e0,0xc(%esp)
c0104250:	c0 
c0104251:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0104258:	c0 
c0104259:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0104260:	00 
c0104261:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0104268:	e8 74 ca ff ff       	call   c0100ce1 <__panic>
    assert(alloc_page() == NULL);
c010426d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104274:	e8 84 04 00 00       	call   c01046fd <alloc_pages>
c0104279:	85 c0                	test   %eax,%eax
c010427b:	74 24                	je     c01042a1 <default_check+0x564>
c010427d:	c7 44 24 0c 3e 96 10 	movl   $0xc010963e,0xc(%esp)
c0104284:	c0 
c0104285:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010428c:	c0 
c010428d:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0104294:	00 
c0104295:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010429c:	e8 40 ca ff ff       	call   c0100ce1 <__panic>

    assert(nr_free == 0);
c01042a1:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c01042a6:	85 c0                	test   %eax,%eax
c01042a8:	74 24                	je     c01042ce <default_check+0x591>
c01042aa:	c7 44 24 0c 91 96 10 	movl   $0xc0109691,0xc(%esp)
c01042b1:	c0 
c01042b2:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c01042b9:	c0 
c01042ba:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01042c1:	00 
c01042c2:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c01042c9:	e8 13 ca ff ff       	call   c0100ce1 <__panic>
    nr_free = nr_free_store;
c01042ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042d1:	a3 48 40 12 c0       	mov    %eax,0xc0124048

    free_list = free_list_store;
c01042d6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01042d9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01042dc:	a3 40 40 12 c0       	mov    %eax,0xc0124040
c01042e1:	89 15 44 40 12 c0    	mov    %edx,0xc0124044
    free_pages(p0, 5);
c01042e7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01042ee:	00 
c01042ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042f2:	89 04 24             	mov    %eax,(%esp)
c01042f5:	e8 6e 04 00 00       	call   c0104768 <free_pages>

    le = &free_list;
c01042fa:	c7 45 ec 40 40 12 c0 	movl   $0xc0124040,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104301:	eb 1d                	jmp    c0104320 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104303:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104306:	83 e8 0c             	sub    $0xc,%eax
c0104309:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010430c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104310:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104313:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104316:	8b 40 08             	mov    0x8(%eax),%eax
c0104319:	29 c2                	sub    %eax,%edx
c010431b:	89 d0                	mov    %edx,%eax
c010431d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104320:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104323:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104326:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104329:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010432c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010432f:	81 7d ec 40 40 12 c0 	cmpl   $0xc0124040,-0x14(%ebp)
c0104336:	75 cb                	jne    c0104303 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010433c:	74 24                	je     c0104362 <default_check+0x625>
c010433e:	c7 44 24 0c fe 97 10 	movl   $0xc01097fe,0xc(%esp)
c0104345:	c0 
c0104346:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c010434d:	c0 
c010434e:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
c0104355:	00 
c0104356:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c010435d:	e8 7f c9 ff ff       	call   c0100ce1 <__panic>
    assert(total == 0);
c0104362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104366:	74 24                	je     c010438c <default_check+0x64f>
c0104368:	c7 44 24 0c 09 98 10 	movl   $0xc0109809,0xc(%esp)
c010436f:	c0 
c0104370:	c7 44 24 08 b6 94 10 	movl   $0xc01094b6,0x8(%esp)
c0104377:	c0 
c0104378:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c010437f:	00 
c0104380:	c7 04 24 cb 94 10 c0 	movl   $0xc01094cb,(%esp)
c0104387:	e8 55 c9 ff ff       	call   c0100ce1 <__panic>
}
c010438c:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104392:	5b                   	pop    %ebx
c0104393:	5d                   	pop    %ebp
c0104394:	c3                   	ret    

c0104395 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104395:	55                   	push   %ebp
c0104396:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104398:	8b 55 08             	mov    0x8(%ebp),%edx
c010439b:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01043a0:	29 c2                	sub    %eax,%edx
c01043a2:	89 d0                	mov    %edx,%eax
c01043a4:	c1 f8 05             	sar    $0x5,%eax
}
c01043a7:	5d                   	pop    %ebp
c01043a8:	c3                   	ret    

c01043a9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01043a9:	55                   	push   %ebp
c01043aa:	89 e5                	mov    %esp,%ebp
c01043ac:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01043af:	8b 45 08             	mov    0x8(%ebp),%eax
c01043b2:	89 04 24             	mov    %eax,(%esp)
c01043b5:	e8 db ff ff ff       	call   c0104395 <page2ppn>
c01043ba:	c1 e0 0c             	shl    $0xc,%eax
}
c01043bd:	c9                   	leave  
c01043be:	c3                   	ret    

c01043bf <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01043bf:	55                   	push   %ebp
c01043c0:	89 e5                	mov    %esp,%ebp
c01043c2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01043c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c8:	c1 e8 0c             	shr    $0xc,%eax
c01043cb:	89 c2                	mov    %eax,%edx
c01043cd:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01043d2:	39 c2                	cmp    %eax,%edx
c01043d4:	72 1c                	jb     c01043f2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01043d6:	c7 44 24 08 44 98 10 	movl   $0xc0109844,0x8(%esp)
c01043dd:	c0 
c01043de:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01043e5:	00 
c01043e6:	c7 04 24 63 98 10 c0 	movl   $0xc0109863,(%esp)
c01043ed:	e8 ef c8 ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c01043f2:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01043f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01043fa:	c1 ea 0c             	shr    $0xc,%edx
c01043fd:	c1 e2 05             	shl    $0x5,%edx
c0104400:	01 d0                	add    %edx,%eax
}
c0104402:	c9                   	leave  
c0104403:	c3                   	ret    

c0104404 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104404:	55                   	push   %ebp
c0104405:	89 e5                	mov    %esp,%ebp
c0104407:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010440a:	8b 45 08             	mov    0x8(%ebp),%eax
c010440d:	89 04 24             	mov    %eax,(%esp)
c0104410:	e8 94 ff ff ff       	call   c01043a9 <page2pa>
c0104415:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010441b:	c1 e8 0c             	shr    $0xc,%eax
c010441e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104421:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0104426:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104429:	72 23                	jb     c010444e <page2kva+0x4a>
c010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104432:	c7 44 24 08 74 98 10 	movl   $0xc0109874,0x8(%esp)
c0104439:	c0 
c010443a:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0104441:	00 
c0104442:	c7 04 24 63 98 10 c0 	movl   $0xc0109863,(%esp)
c0104449:	e8 93 c8 ff ff       	call   c0100ce1 <__panic>
c010444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104451:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104456:	c9                   	leave  
c0104457:	c3                   	ret    

c0104458 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104458:	55                   	push   %ebp
c0104459:	89 e5                	mov    %esp,%ebp
c010445b:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010445e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104461:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104464:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010446b:	77 23                	ja     c0104490 <kva2page+0x38>
c010446d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104470:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104474:	c7 44 24 08 98 98 10 	movl   $0xc0109898,0x8(%esp)
c010447b:	c0 
c010447c:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0104483:	00 
c0104484:	c7 04 24 63 98 10 c0 	movl   $0xc0109863,(%esp)
c010448b:	e8 51 c8 ff ff       	call   c0100ce1 <__panic>
c0104490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104493:	05 00 00 00 40       	add    $0x40000000,%eax
c0104498:	89 04 24             	mov    %eax,(%esp)
c010449b:	e8 1f ff ff ff       	call   c01043bf <pa2page>
}
c01044a0:	c9                   	leave  
c01044a1:	c3                   	ret    

c01044a2 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c01044a2:	55                   	push   %ebp
c01044a3:	89 e5                	mov    %esp,%ebp
c01044a5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01044a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ab:	83 e0 01             	and    $0x1,%eax
c01044ae:	85 c0                	test   %eax,%eax
c01044b0:	75 1c                	jne    c01044ce <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01044b2:	c7 44 24 08 bc 98 10 	movl   $0xc01098bc,0x8(%esp)
c01044b9:	c0 
c01044ba:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01044c1:	00 
c01044c2:	c7 04 24 63 98 10 c0 	movl   $0xc0109863,(%esp)
c01044c9:	e8 13 c8 ff ff       	call   c0100ce1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01044ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044d6:	89 04 24             	mov    %eax,(%esp)
c01044d9:	e8 e1 fe ff ff       	call   c01043bf <pa2page>
}
c01044de:	c9                   	leave  
c01044df:	c3                   	ret    

c01044e0 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c01044e0:	55                   	push   %ebp
c01044e1:	89 e5                	mov    %esp,%ebp
c01044e3:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01044e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044ee:	89 04 24             	mov    %eax,(%esp)
c01044f1:	e8 c9 fe ff ff       	call   c01043bf <pa2page>
}
c01044f6:	c9                   	leave  
c01044f7:	c3                   	ret    

c01044f8 <page_ref>:

static inline int
page_ref(struct Page *page) {
c01044f8:	55                   	push   %ebp
c01044f9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01044fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01044fe:	8b 00                	mov    (%eax),%eax
}
c0104500:	5d                   	pop    %ebp
c0104501:	c3                   	ret    

c0104502 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104502:	55                   	push   %ebp
c0104503:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104505:	8b 45 08             	mov    0x8(%ebp),%eax
c0104508:	8b 55 0c             	mov    0xc(%ebp),%edx
c010450b:	89 10                	mov    %edx,(%eax)
}
c010450d:	5d                   	pop    %ebp
c010450e:	c3                   	ret    

c010450f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010450f:	55                   	push   %ebp
c0104510:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104512:	8b 45 08             	mov    0x8(%ebp),%eax
c0104515:	8b 00                	mov    (%eax),%eax
c0104517:	8d 50 01             	lea    0x1(%eax),%edx
c010451a:	8b 45 08             	mov    0x8(%ebp),%eax
c010451d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010451f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104522:	8b 00                	mov    (%eax),%eax
}
c0104524:	5d                   	pop    %ebp
c0104525:	c3                   	ret    

c0104526 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104526:	55                   	push   %ebp
c0104527:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104529:	8b 45 08             	mov    0x8(%ebp),%eax
c010452c:	8b 00                	mov    (%eax),%eax
c010452e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104531:	8b 45 08             	mov    0x8(%ebp),%eax
c0104534:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104536:	8b 45 08             	mov    0x8(%ebp),%eax
c0104539:	8b 00                	mov    (%eax),%eax
}
c010453b:	5d                   	pop    %ebp
c010453c:	c3                   	ret    

c010453d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010453d:	55                   	push   %ebp
c010453e:	89 e5                	mov    %esp,%ebp
c0104540:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104543:	9c                   	pushf  
c0104544:	58                   	pop    %eax
c0104545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104548:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010454b:	25 00 02 00 00       	and    $0x200,%eax
c0104550:	85 c0                	test   %eax,%eax
c0104552:	74 0c                	je     c0104560 <__intr_save+0x23>
        intr_disable();
c0104554:	e8 f1 d9 ff ff       	call   c0101f4a <intr_disable>
        return 1;
c0104559:	b8 01 00 00 00       	mov    $0x1,%eax
c010455e:	eb 05                	jmp    c0104565 <__intr_save+0x28>
    }
    return 0;
c0104560:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104565:	c9                   	leave  
c0104566:	c3                   	ret    

c0104567 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104567:	55                   	push   %ebp
c0104568:	89 e5                	mov    %esp,%ebp
c010456a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010456d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104571:	74 05                	je     c0104578 <__intr_restore+0x11>
        intr_enable();
c0104573:	e8 cc d9 ff ff       	call   c0101f44 <intr_enable>
    }
}
c0104578:	c9                   	leave  
c0104579:	c3                   	ret    

c010457a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c010457a:	55                   	push   %ebp
c010457b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c010457d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104580:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104583:	b8 23 00 00 00       	mov    $0x23,%eax
c0104588:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c010458a:	b8 23 00 00 00       	mov    $0x23,%eax
c010458f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104591:	b8 10 00 00 00       	mov    $0x10,%eax
c0104596:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104598:	b8 10 00 00 00       	mov    $0x10,%eax
c010459d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c010459f:	b8 10 00 00 00       	mov    $0x10,%eax
c01045a4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01045a6:	ea ad 45 10 c0 08 00 	ljmp   $0x8,$0xc01045ad
}
c01045ad:	5d                   	pop    %ebp
c01045ae:	c3                   	ret    

c01045af <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01045af:	55                   	push   %ebp
c01045b0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01045b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b5:	a3 c4 3f 12 c0       	mov    %eax,0xc0123fc4
}
c01045ba:	5d                   	pop    %ebp
c01045bb:	c3                   	ret    

c01045bc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01045bc:	55                   	push   %ebp
c01045bd:	89 e5                	mov    %esp,%ebp
c01045bf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01045c2:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c01045c7:	89 04 24             	mov    %eax,(%esp)
c01045ca:	e8 e0 ff ff ff       	call   c01045af <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01045cf:	66 c7 05 c8 3f 12 c0 	movw   $0x10,0xc0123fc8
c01045d6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01045d8:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c01045df:	68 00 
c01045e1:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c01045e6:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c01045ec:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c01045f1:	c1 e8 10             	shr    $0x10,%eax
c01045f4:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c01045f9:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104600:	83 e0 f0             	and    $0xfffffff0,%eax
c0104603:	83 c8 09             	or     $0x9,%eax
c0104606:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010460b:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104612:	83 e0 ef             	and    $0xffffffef,%eax
c0104615:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c010461a:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104621:	83 e0 9f             	and    $0xffffff9f,%eax
c0104624:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104629:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0104630:	83 c8 80             	or     $0xffffff80,%eax
c0104633:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0104638:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010463f:	83 e0 f0             	and    $0xfffffff0,%eax
c0104642:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104647:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010464e:	83 e0 ef             	and    $0xffffffef,%eax
c0104651:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104656:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010465d:	83 e0 df             	and    $0xffffffdf,%eax
c0104660:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104665:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010466c:	83 c8 40             	or     $0x40,%eax
c010466f:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104674:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c010467b:	83 e0 7f             	and    $0x7f,%eax
c010467e:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104683:	b8 c0 3f 12 c0       	mov    $0xc0123fc0,%eax
c0104688:	c1 e8 18             	shr    $0x18,%eax
c010468b:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104690:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c0104697:	e8 de fe ff ff       	call   c010457a <lgdt>
c010469c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01046a2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01046a6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01046a9:	c9                   	leave  
c01046aa:	c3                   	ret    

c01046ab <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01046ab:	55                   	push   %ebp
c01046ac:	89 e5                	mov    %esp,%ebp
c01046ae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01046b1:	c7 05 4c 40 12 c0 28 	movl   $0xc0109828,0xc012404c
c01046b8:	98 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01046bb:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01046c0:	8b 00                	mov    (%eax),%eax
c01046c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046c6:	c7 04 24 e8 98 10 c0 	movl   $0xc01098e8,(%esp)
c01046cd:	e8 85 bc ff ff       	call   c0100357 <cprintf>
    pmm_manager->init();
c01046d2:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01046d7:	8b 40 04             	mov    0x4(%eax),%eax
c01046da:	ff d0                	call   *%eax
}
c01046dc:	c9                   	leave  
c01046dd:	c3                   	ret    

c01046de <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01046de:	55                   	push   %ebp
c01046df:	89 e5                	mov    %esp,%ebp
c01046e1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c01046e4:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01046e9:	8b 40 08             	mov    0x8(%eax),%eax
c01046ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046ef:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046f3:	8b 55 08             	mov    0x8(%ebp),%edx
c01046f6:	89 14 24             	mov    %edx,(%esp)
c01046f9:	ff d0                	call   *%eax
}
c01046fb:	c9                   	leave  
c01046fc:	c3                   	ret    

c01046fd <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01046fd:	55                   	push   %ebp
c01046fe:	89 e5                	mov    %esp,%ebp
c0104700:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104703:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010470a:	e8 2e fe ff ff       	call   c010453d <__intr_save>
c010470f:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104712:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c0104717:	8b 40 0c             	mov    0xc(%eax),%eax
c010471a:	8b 55 08             	mov    0x8(%ebp),%edx
c010471d:	89 14 24             	mov    %edx,(%esp)
c0104720:	ff d0                	call   *%eax
c0104722:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104725:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104728:	89 04 24             	mov    %eax,(%esp)
c010472b:	e8 37 fe ff ff       	call   c0104567 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104734:	75 2d                	jne    c0104763 <alloc_pages+0x66>
c0104736:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010473a:	77 27                	ja     c0104763 <alloc_pages+0x66>
c010473c:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c0104741:	85 c0                	test   %eax,%eax
c0104743:	74 1e                	je     c0104763 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104745:	8b 55 08             	mov    0x8(%ebp),%edx
c0104748:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c010474d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104754:	00 
c0104755:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104759:	89 04 24             	mov    %eax,(%esp)
c010475c:	e8 14 1a 00 00       	call   c0106175 <swap_out>
    }
c0104761:	eb a7                	jmp    c010470a <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104766:	c9                   	leave  
c0104767:	c3                   	ret    

c0104768 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104768:	55                   	push   %ebp
c0104769:	89 e5                	mov    %esp,%ebp
c010476b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010476e:	e8 ca fd ff ff       	call   c010453d <__intr_save>
c0104773:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104776:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c010477b:	8b 40 10             	mov    0x10(%eax),%eax
c010477e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104781:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104785:	8b 55 08             	mov    0x8(%ebp),%edx
c0104788:	89 14 24             	mov    %edx,(%esp)
c010478b:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104790:	89 04 24             	mov    %eax,(%esp)
c0104793:	e8 cf fd ff ff       	call   c0104567 <__intr_restore>
}
c0104798:	c9                   	leave  
c0104799:	c3                   	ret    

c010479a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010479a:	55                   	push   %ebp
c010479b:	89 e5                	mov    %esp,%ebp
c010479d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01047a0:	e8 98 fd ff ff       	call   c010453d <__intr_save>
c01047a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01047a8:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c01047ad:	8b 40 14             	mov    0x14(%eax),%eax
c01047b0:	ff d0                	call   *%eax
c01047b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01047b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b8:	89 04 24             	mov    %eax,(%esp)
c01047bb:	e8 a7 fd ff ff       	call   c0104567 <__intr_restore>
    return ret;
c01047c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01047c3:	c9                   	leave  
c01047c4:	c3                   	ret    

c01047c5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01047c5:	55                   	push   %ebp
c01047c6:	89 e5                	mov    %esp,%ebp
c01047c8:	57                   	push   %edi
c01047c9:	56                   	push   %esi
c01047ca:	53                   	push   %ebx
c01047cb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01047d1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01047d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01047df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01047e6:	c7 04 24 ff 98 10 c0 	movl   $0xc01098ff,(%esp)
c01047ed:	e8 65 bb ff ff       	call   c0100357 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01047f2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01047f9:	e9 15 01 00 00       	jmp    c0104913 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01047fe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104801:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104804:	89 d0                	mov    %edx,%eax
c0104806:	c1 e0 02             	shl    $0x2,%eax
c0104809:	01 d0                	add    %edx,%eax
c010480b:	c1 e0 02             	shl    $0x2,%eax
c010480e:	01 c8                	add    %ecx,%eax
c0104810:	8b 50 08             	mov    0x8(%eax),%edx
c0104813:	8b 40 04             	mov    0x4(%eax),%eax
c0104816:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104819:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010481c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010481f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104822:	89 d0                	mov    %edx,%eax
c0104824:	c1 e0 02             	shl    $0x2,%eax
c0104827:	01 d0                	add    %edx,%eax
c0104829:	c1 e0 02             	shl    $0x2,%eax
c010482c:	01 c8                	add    %ecx,%eax
c010482e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104831:	8b 58 10             	mov    0x10(%eax),%ebx
c0104834:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104837:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010483a:	01 c8                	add    %ecx,%eax
c010483c:	11 da                	adc    %ebx,%edx
c010483e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104841:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104844:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104847:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010484a:	89 d0                	mov    %edx,%eax
c010484c:	c1 e0 02             	shl    $0x2,%eax
c010484f:	01 d0                	add    %edx,%eax
c0104851:	c1 e0 02             	shl    $0x2,%eax
c0104854:	01 c8                	add    %ecx,%eax
c0104856:	83 c0 14             	add    $0x14,%eax
c0104859:	8b 00                	mov    (%eax),%eax
c010485b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104861:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104864:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104867:	83 c0 ff             	add    $0xffffffff,%eax
c010486a:	83 d2 ff             	adc    $0xffffffff,%edx
c010486d:	89 c6                	mov    %eax,%esi
c010486f:	89 d7                	mov    %edx,%edi
c0104871:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104874:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104877:	89 d0                	mov    %edx,%eax
c0104879:	c1 e0 02             	shl    $0x2,%eax
c010487c:	01 d0                	add    %edx,%eax
c010487e:	c1 e0 02             	shl    $0x2,%eax
c0104881:	01 c8                	add    %ecx,%eax
c0104883:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104886:	8b 58 10             	mov    0x10(%eax),%ebx
c0104889:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010488f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104893:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104897:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010489b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010489e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048a5:	89 54 24 10          	mov    %edx,0x10(%esp)
c01048a9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01048ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01048b1:	c7 04 24 0c 99 10 c0 	movl   $0xc010990c,(%esp)
c01048b8:	e8 9a ba ff ff       	call   c0100357 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01048bd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048c3:	89 d0                	mov    %edx,%eax
c01048c5:	c1 e0 02             	shl    $0x2,%eax
c01048c8:	01 d0                	add    %edx,%eax
c01048ca:	c1 e0 02             	shl    $0x2,%eax
c01048cd:	01 c8                	add    %ecx,%eax
c01048cf:	83 c0 14             	add    $0x14,%eax
c01048d2:	8b 00                	mov    (%eax),%eax
c01048d4:	83 f8 01             	cmp    $0x1,%eax
c01048d7:	75 36                	jne    c010490f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01048d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048df:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01048e2:	77 2b                	ja     c010490f <page_init+0x14a>
c01048e4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01048e7:	72 05                	jb     c01048ee <page_init+0x129>
c01048e9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01048ec:	73 21                	jae    c010490f <page_init+0x14a>
c01048ee:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01048f2:	77 1b                	ja     c010490f <page_init+0x14a>
c01048f4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01048f8:	72 09                	jb     c0104903 <page_init+0x13e>
c01048fa:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104901:	77 0c                	ja     c010490f <page_init+0x14a>
                maxpa = end;
c0104903:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104906:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104909:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010490c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010490f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104913:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104916:	8b 00                	mov    (%eax),%eax
c0104918:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010491b:	0f 8f dd fe ff ff    	jg     c01047fe <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104925:	72 1d                	jb     c0104944 <page_init+0x17f>
c0104927:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010492b:	77 09                	ja     c0104936 <page_init+0x171>
c010492d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104934:	76 0e                	jbe    c0104944 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104936:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010493d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104944:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104947:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010494a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010494e:	c1 ea 0c             	shr    $0xc,%edx
c0104951:	a3 a0 3f 12 c0       	mov    %eax,0xc0123fa0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104956:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010495d:	b8 30 41 12 c0       	mov    $0xc0124130,%eax
c0104962:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104965:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104968:	01 d0                	add    %edx,%eax
c010496a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010496d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104970:	ba 00 00 00 00       	mov    $0x0,%edx
c0104975:	f7 75 ac             	divl   -0x54(%ebp)
c0104978:	89 d0                	mov    %edx,%eax
c010497a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010497d:	29 c2                	sub    %eax,%edx
c010497f:	89 d0                	mov    %edx,%eax
c0104981:	a3 54 40 12 c0       	mov    %eax,0xc0124054

    for (i = 0; i < npage; i ++) {
c0104986:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010498d:	eb 27                	jmp    c01049b6 <page_init+0x1f1>
        SetPageReserved(pages + i);
c010498f:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c0104994:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104997:	c1 e2 05             	shl    $0x5,%edx
c010499a:	01 d0                	add    %edx,%eax
c010499c:	83 c0 04             	add    $0x4,%eax
c010499f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01049a6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01049a9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01049ac:	8b 55 90             	mov    -0x70(%ebp),%edx
c01049af:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01049b2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01049b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01049b9:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01049be:	39 c2                	cmp    %eax,%edx
c01049c0:	72 cd                	jb     c010498f <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01049c2:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01049c7:	c1 e0 05             	shl    $0x5,%eax
c01049ca:	89 c2                	mov    %eax,%edx
c01049cc:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c01049d1:	01 d0                	add    %edx,%eax
c01049d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01049d6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01049dd:	77 23                	ja     c0104a02 <page_init+0x23d>
c01049df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01049e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049e6:	c7 44 24 08 98 98 10 	movl   $0xc0109898,0x8(%esp)
c01049ed:	c0 
c01049ee:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01049f5:	00 
c01049f6:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01049fd:	e8 df c2 ff ff       	call   c0100ce1 <__panic>
c0104a02:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a05:	05 00 00 00 40       	add    $0x40000000,%eax
c0104a0a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104a0d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104a14:	e9 74 01 00 00       	jmp    c0104b8d <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104a19:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a1f:	89 d0                	mov    %edx,%eax
c0104a21:	c1 e0 02             	shl    $0x2,%eax
c0104a24:	01 d0                	add    %edx,%eax
c0104a26:	c1 e0 02             	shl    $0x2,%eax
c0104a29:	01 c8                	add    %ecx,%eax
c0104a2b:	8b 50 08             	mov    0x8(%eax),%edx
c0104a2e:	8b 40 04             	mov    0x4(%eax),%eax
c0104a31:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a37:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a3a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a3d:	89 d0                	mov    %edx,%eax
c0104a3f:	c1 e0 02             	shl    $0x2,%eax
c0104a42:	01 d0                	add    %edx,%eax
c0104a44:	c1 e0 02             	shl    $0x2,%eax
c0104a47:	01 c8                	add    %ecx,%eax
c0104a49:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104a4c:	8b 58 10             	mov    0x10(%eax),%ebx
c0104a4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a55:	01 c8                	add    %ecx,%eax
c0104a57:	11 da                	adc    %ebx,%edx
c0104a59:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a5c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104a5f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104a62:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a65:	89 d0                	mov    %edx,%eax
c0104a67:	c1 e0 02             	shl    $0x2,%eax
c0104a6a:	01 d0                	add    %edx,%eax
c0104a6c:	c1 e0 02             	shl    $0x2,%eax
c0104a6f:	01 c8                	add    %ecx,%eax
c0104a71:	83 c0 14             	add    $0x14,%eax
c0104a74:	8b 00                	mov    (%eax),%eax
c0104a76:	83 f8 01             	cmp    $0x1,%eax
c0104a79:	0f 85 0a 01 00 00    	jne    c0104b89 <page_init+0x3c4>
            if (begin < freemem) {
c0104a7f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a82:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a87:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104a8a:	72 17                	jb     c0104aa3 <page_init+0x2de>
c0104a8c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104a8f:	77 05                	ja     c0104a96 <page_init+0x2d1>
c0104a91:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104a94:	76 0d                	jbe    c0104aa3 <page_init+0x2de>
                begin = freemem;
c0104a96:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a99:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a9c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104aa3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104aa7:	72 1d                	jb     c0104ac6 <page_init+0x301>
c0104aa9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104aad:	77 09                	ja     c0104ab8 <page_init+0x2f3>
c0104aaf:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104ab6:	76 0e                	jbe    c0104ac6 <page_init+0x301>
                end = KMEMSIZE;
c0104ab8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104abf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104ac6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ac9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104acc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104acf:	0f 87 b4 00 00 00    	ja     c0104b89 <page_init+0x3c4>
c0104ad5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104ad8:	72 09                	jb     c0104ae3 <page_init+0x31e>
c0104ada:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104add:	0f 83 a6 00 00 00    	jae    c0104b89 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104ae3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104aea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104aed:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104af0:	01 d0                	add    %edx,%eax
c0104af2:	83 e8 01             	sub    $0x1,%eax
c0104af5:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104af8:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104afb:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b00:	f7 75 9c             	divl   -0x64(%ebp)
c0104b03:	89 d0                	mov    %edx,%eax
c0104b05:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104b08:	29 c2                	sub    %eax,%edx
c0104b0a:	89 d0                	mov    %edx,%eax
c0104b0c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b11:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104b17:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b1a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104b1d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104b20:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b25:	89 c7                	mov    %eax,%edi
c0104b27:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104b2d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104b30:	89 d0                	mov    %edx,%eax
c0104b32:	83 e0 00             	and    $0x0,%eax
c0104b35:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104b38:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104b3b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104b3e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b41:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104b44:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b47:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b4a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b4d:	77 3a                	ja     c0104b89 <page_init+0x3c4>
c0104b4f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b52:	72 05                	jb     c0104b59 <page_init+0x394>
c0104b54:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104b57:	73 30                	jae    c0104b89 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104b59:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104b5c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104b5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b62:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104b65:	29 c8                	sub    %ecx,%eax
c0104b67:	19 da                	sbb    %ebx,%edx
c0104b69:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104b6d:	c1 ea 0c             	shr    $0xc,%edx
c0104b70:	89 c3                	mov    %eax,%ebx
c0104b72:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b75:	89 04 24             	mov    %eax,(%esp)
c0104b78:	e8 42 f8 ff ff       	call   c01043bf <pa2page>
c0104b7d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104b81:	89 04 24             	mov    %eax,(%esp)
c0104b84:	e8 55 fb ff ff       	call   c01046de <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104b89:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104b8d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104b90:	8b 00                	mov    (%eax),%eax
c0104b92:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104b95:	0f 8f 7e fe ff ff    	jg     c0104a19 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104b9b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104ba1:	5b                   	pop    %ebx
c0104ba2:	5e                   	pop    %esi
c0104ba3:	5f                   	pop    %edi
c0104ba4:	5d                   	pop    %ebp
c0104ba5:	c3                   	ret    

c0104ba6 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104ba6:	55                   	push   %ebp
c0104ba7:	89 e5                	mov    %esp,%ebp
c0104ba9:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104bac:	8b 45 14             	mov    0x14(%ebp),%eax
c0104baf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104bb2:	31 d0                	xor    %edx,%eax
c0104bb4:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104bb9:	85 c0                	test   %eax,%eax
c0104bbb:	74 24                	je     c0104be1 <boot_map_segment+0x3b>
c0104bbd:	c7 44 24 0c 4a 99 10 	movl   $0xc010994a,0xc(%esp)
c0104bc4:	c0 
c0104bc5:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0104bcc:	c0 
c0104bcd:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104bd4:	00 
c0104bd5:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104bdc:	e8 00 c1 ff ff       	call   c0100ce1 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104be1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104be8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104beb:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104bf0:	89 c2                	mov    %eax,%edx
c0104bf2:	8b 45 10             	mov    0x10(%ebp),%eax
c0104bf5:	01 c2                	add    %eax,%edx
c0104bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bfa:	01 d0                	add    %edx,%eax
c0104bfc:	83 e8 01             	sub    $0x1,%eax
c0104bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c05:	ba 00 00 00 00       	mov    $0x0,%edx
c0104c0a:	f7 75 f0             	divl   -0x10(%ebp)
c0104c0d:	89 d0                	mov    %edx,%eax
c0104c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104c12:	29 c2                	sub    %eax,%edx
c0104c14:	89 d0                	mov    %edx,%eax
c0104c16:	c1 e8 0c             	shr    $0xc,%eax
c0104c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c2a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104c2d:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c3b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c3e:	eb 6b                	jmp    c0104cab <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104c40:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104c47:	00 
c0104c48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c52:	89 04 24             	mov    %eax,(%esp)
c0104c55:	e8 82 01 00 00       	call   c0104ddc <get_pte>
c0104c5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104c5d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104c61:	75 24                	jne    c0104c87 <boot_map_segment+0xe1>
c0104c63:	c7 44 24 0c 76 99 10 	movl   $0xc0109976,0xc(%esp)
c0104c6a:	c0 
c0104c6b:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0104c72:	c0 
c0104c73:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0104c7a:	00 
c0104c7b:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104c82:	e8 5a c0 ff ff       	call   c0100ce1 <__panic>
        *ptep = pa | PTE_P | perm;
c0104c87:	8b 45 18             	mov    0x18(%ebp),%eax
c0104c8a:	8b 55 14             	mov    0x14(%ebp),%edx
c0104c8d:	09 d0                	or     %edx,%eax
c0104c8f:	83 c8 01             	or     $0x1,%eax
c0104c92:	89 c2                	mov    %eax,%edx
c0104c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c97:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104c99:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104c9d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104ca4:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104caf:	75 8f                	jne    c0104c40 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104cb1:	c9                   	leave  
c0104cb2:	c3                   	ret    

c0104cb3 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104cb3:	55                   	push   %ebp
c0104cb4:	89 e5                	mov    %esp,%ebp
c0104cb6:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104cb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cc0:	e8 38 fa ff ff       	call   c01046fd <alloc_pages>
c0104cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ccc:	75 1c                	jne    c0104cea <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104cce:	c7 44 24 08 83 99 10 	movl   $0xc0109983,0x8(%esp)
c0104cd5:	c0 
c0104cd6:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0104cdd:	00 
c0104cde:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104ce5:	e8 f7 bf ff ff       	call   c0100ce1 <__panic>
    }
    return page2kva(p);
c0104cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ced:	89 04 24             	mov    %eax,(%esp)
c0104cf0:	e8 0f f7 ff ff       	call   c0104404 <page2kva>
}
c0104cf5:	c9                   	leave  
c0104cf6:	c3                   	ret    

c0104cf7 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104cf7:	55                   	push   %ebp
c0104cf8:	89 e5                	mov    %esp,%ebp
c0104cfa:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104cfd:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d05:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104d0c:	77 23                	ja     c0104d31 <pmm_init+0x3a>
c0104d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d11:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d15:	c7 44 24 08 98 98 10 	movl   $0xc0109898,0x8(%esp)
c0104d1c:	c0 
c0104d1d:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104d24:	00 
c0104d25:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104d2c:	e8 b0 bf ff ff       	call   c0100ce1 <__panic>
c0104d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d34:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d39:	a3 50 40 12 c0       	mov    %eax,0xc0124050
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104d3e:	e8 68 f9 ff ff       	call   c01046ab <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104d43:	e8 7d fa ff ff       	call   c01047c5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104d48:	e8 ab 04 00 00       	call   c01051f8 <check_alloc_page>

    check_pgdir();
c0104d4d:	e8 c4 04 00 00       	call   c0105216 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104d52:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104d57:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104d5d:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d65:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104d6c:	77 23                	ja     c0104d91 <pmm_init+0x9a>
c0104d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d71:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d75:	c7 44 24 08 98 98 10 	movl   $0xc0109898,0x8(%esp)
c0104d7c:	c0 
c0104d7d:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0104d84:	00 
c0104d85:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104d8c:	e8 50 bf ff ff       	call   c0100ce1 <__panic>
c0104d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d94:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d99:	83 c8 03             	or     $0x3,%eax
c0104d9c:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104d9e:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104da3:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104daa:	00 
c0104dab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104db2:	00 
c0104db3:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104dba:	38 
c0104dbb:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104dc2:	c0 
c0104dc3:	89 04 24             	mov    %eax,(%esp)
c0104dc6:	e8 db fd ff ff       	call   c0104ba6 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104dcb:	e8 ec f7 ff ff       	call   c01045bc <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104dd0:	e8 dc 0a 00 00       	call   c01058b1 <check_boot_pgdir>

    print_pgdir();
c0104dd5:	e8 64 0f 00 00       	call   c0105d3e <print_pgdir>

}
c0104dda:	c9                   	leave  
c0104ddb:	c3                   	ret    

c0104ddc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104ddc:	55                   	push   %ebp
c0104ddd:	89 e5                	mov    %esp,%ebp
c0104ddf:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    //typedef uintptr_t pde_t;
    pde_t *pdep = &pgdir[PDX(la)];  // (1)获取页表
c0104de2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104de5:	c1 e8 16             	shr    $0x16,%eax
c0104de8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104def:	8b 45 08             	mov    0x8(%ebp),%eax
c0104df2:	01 d0                	add    %edx,%eax
c0104df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))             // (2)假设页目录项不存在
c0104df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dfa:	8b 00                	mov    (%eax),%eax
c0104dfc:	83 e0 01             	and    $0x1,%eax
c0104dff:	85 c0                	test   %eax,%eax
c0104e01:	0f 85 af 00 00 00    	jne    c0104eb6 <get_pte+0xda>
    {      
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) // (3) check if creating is needed, then alloc page for page table
c0104e07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104e0b:	74 15                	je     c0104e22 <get_pte+0x46>
c0104e0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e14:	e8 e4 f8 ff ff       	call   c01046fd <alloc_pages>
c0104e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e20:	75 0a                	jne    c0104e2c <get_pte+0x50>
        {    //假如不需要分配或是分配失败
            return NULL;
c0104e22:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e27:	e9 e6 00 00 00       	jmp    c0104f12 <get_pte+0x136>
        }
        set_page_ref(page, 1);                      // (4)设置被引用1次
c0104e2c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e33:	00 
c0104e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e37:	89 04 24             	mov    %eax,(%esp)
c0104e3a:	e8 c3 f6 ff ff       	call   c0104502 <set_page_ref>
        uintptr_t pa = page2pa(page);                  // (5)得到该页物理地址
c0104e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e42:	89 04 24             	mov    %eax,(%esp)
c0104e45:	e8 5f f5 ff ff       	call   c01043a9 <page2pa>
c0104e4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                  // (6)物理地址转虚拟地址，并初始化
c0104e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e56:	c1 e8 0c             	shr    $0xc,%eax
c0104e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e5c:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0104e61:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e64:	72 23                	jb     c0104e89 <get_pte+0xad>
c0104e66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e69:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e6d:	c7 44 24 08 74 98 10 	movl   $0xc0109874,0x8(%esp)
c0104e74:	c0 
c0104e75:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c0104e7c:	00 
c0104e7d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104e84:	e8 58 be ff ff       	call   c0100ce1 <__panic>
c0104e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e8c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e91:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e98:	00 
c0104e99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ea0:	00 
c0104ea1:	89 04 24             	mov    %eax,(%esp)
c0104ea4:	e8 d2 3b 00 00       	call   c0108a7b <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;            // (7)设置可读，可写，存在位
c0104ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eac:	83 c8 07             	or     $0x7,%eax
c0104eaf:	89 c2                	mov    %eax,%edx
c0104eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb4:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];     // (8) return page table entry
c0104eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb9:	8b 00                	mov    (%eax),%eax
c0104ebb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ec0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ec6:	c1 e8 0c             	shr    $0xc,%eax
c0104ec9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ecc:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0104ed1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104ed4:	72 23                	jb     c0104ef9 <get_pte+0x11d>
c0104ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ed9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104edd:	c7 44 24 08 74 98 10 	movl   $0xc0109874,0x8(%esp)
c0104ee4:	c0 
c0104ee5:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
c0104eec:	00 
c0104eed:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0104ef4:	e8 e8 bd ff ff       	call   c0100ce1 <__panic>
c0104ef9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104efc:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f01:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f04:	c1 ea 0c             	shr    $0xc,%edx
c0104f07:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104f0d:	c1 e2 02             	shl    $0x2,%edx
c0104f10:	01 d0                	add    %edx,%eax
    //KADDR(PDE_ADDR(*pdep)):这部分是由页目录项地址得到关联的页表物理地址，再转成虚拟地址
    //PTX(la)：返回虚拟地址la的页表项索引
    //最后返回的是虚拟地址la对应的页表项入口地址
}
c0104f12:	c9                   	leave  
c0104f13:	c3                   	ret    

c0104f14 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104f14:	55                   	push   %ebp
c0104f15:	89 e5                	mov    %esp,%ebp
c0104f17:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f21:	00 
c0104f22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f29:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f2c:	89 04 24             	mov    %eax,(%esp)
c0104f2f:	e8 a8 fe ff ff       	call   c0104ddc <get_pte>
c0104f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104f37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104f3b:	74 08                	je     c0104f45 <get_page+0x31>
        *ptep_store = ptep;
c0104f3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f43:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f49:	74 1b                	je     c0104f66 <get_page+0x52>
c0104f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f4e:	8b 00                	mov    (%eax),%eax
c0104f50:	83 e0 01             	and    $0x1,%eax
c0104f53:	85 c0                	test   %eax,%eax
c0104f55:	74 0f                	je     c0104f66 <get_page+0x52>
        return pte2page(*ptep);
c0104f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f5a:	8b 00                	mov    (%eax),%eax
c0104f5c:	89 04 24             	mov    %eax,(%esp)
c0104f5f:	e8 3e f5 ff ff       	call   c01044a2 <pte2page>
c0104f64:	eb 05                	jmp    c0104f6b <get_page+0x57>
    }
    return NULL;
c0104f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f6b:	c9                   	leave  
c0104f6c:	c3                   	ret    

c0104f6d <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104f6d:	55                   	push   %ebp
c0104f6e:	89 e5                	mov    %esp,%ebp
c0104f70:	83 ec 28             	sub    $0x28,%esp
                                  //(6) flush tlb
    }
#endif

//(1) check if this page table entry is present
    if (*ptep & PTE_P) { 
c0104f73:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f76:	8b 00                	mov    (%eax),%eax
c0104f78:	83 e0 01             	and    $0x1,%eax
c0104f7b:	85 c0                	test   %eax,%eax
c0104f7d:	74 52                	je     c0104fd1 <page_remove_pte+0x64>
//(2) find corresponding page to pte
        struct Page *page = pte2page(*ptep); 
c0104f7f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f82:	8b 00                	mov    (%eax),%eax
c0104f84:	89 04 24             	mov    %eax,(%esp)
c0104f87:	e8 16 f5 ff ff       	call   c01044a2 <pte2page>
c0104f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//(3) decrease page reference
        page_ref_dec(page);
c0104f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f92:	89 04 24             	mov    %eax,(%esp)
c0104f95:	e8 8c f5 ff ff       	call   c0104526 <page_ref_dec>
//(4) and free this page when page reference reachs 0
        if (page -> ref == 0) {
c0104f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f9d:	8b 00                	mov    (%eax),%eax
c0104f9f:	85 c0                	test   %eax,%eax
c0104fa1:	75 13                	jne    c0104fb6 <page_remove_pte+0x49>
            free_page(page);
c0104fa3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104faa:	00 
c0104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fae:	89 04 24             	mov    %eax,(%esp)
c0104fb1:	e8 b2 f7 ff ff       	call   c0104768 <free_pages>
        }
//(5) clear second page table entry
        *ptep = 0;
c0104fb6:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
//(6) flush tlb
        tlb_invalidate(pgdir, la);
c0104fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fc9:	89 04 24             	mov    %eax,(%esp)
c0104fcc:	e8 ff 00 00 00       	call   c01050d0 <tlb_invalidate>
    }

}
c0104fd1:	c9                   	leave  
c0104fd2:	c3                   	ret    

c0104fd3 <page_remove>:


//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104fd3:	55                   	push   %ebp
c0104fd4:	89 e5                	mov    %esp,%ebp
c0104fd6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104fd9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fe0:	00 
c0104fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fe8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104feb:	89 04 24             	mov    %eax,(%esp)
c0104fee:	e8 e9 fd ff ff       	call   c0104ddc <get_pte>
c0104ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ffa:	74 19                	je     c0105015 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105003:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105006:	89 44 24 04          	mov    %eax,0x4(%esp)
c010500a:	8b 45 08             	mov    0x8(%ebp),%eax
c010500d:	89 04 24             	mov    %eax,(%esp)
c0105010:	e8 58 ff ff ff       	call   c0104f6d <page_remove_pte>
    }
}
c0105015:	c9                   	leave  
c0105016:	c3                   	ret    

c0105017 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105017:	55                   	push   %ebp
c0105018:	89 e5                	mov    %esp,%ebp
c010501a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010501d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105024:	00 
c0105025:	8b 45 10             	mov    0x10(%ebp),%eax
c0105028:	89 44 24 04          	mov    %eax,0x4(%esp)
c010502c:	8b 45 08             	mov    0x8(%ebp),%eax
c010502f:	89 04 24             	mov    %eax,(%esp)
c0105032:	e8 a5 fd ff ff       	call   c0104ddc <get_pte>
c0105037:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010503a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010503e:	75 0a                	jne    c010504a <page_insert+0x33>
        return -E_NO_MEM;
c0105040:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105045:	e9 84 00 00 00       	jmp    c01050ce <page_insert+0xb7>
    }
    page_ref_inc(page);
c010504a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010504d:	89 04 24             	mov    %eax,(%esp)
c0105050:	e8 ba f4 ff ff       	call   c010450f <page_ref_inc>
    if (*ptep & PTE_P) {
c0105055:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105058:	8b 00                	mov    (%eax),%eax
c010505a:	83 e0 01             	and    $0x1,%eax
c010505d:	85 c0                	test   %eax,%eax
c010505f:	74 3e                	je     c010509f <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105061:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105064:	8b 00                	mov    (%eax),%eax
c0105066:	89 04 24             	mov    %eax,(%esp)
c0105069:	e8 34 f4 ff ff       	call   c01044a2 <pte2page>
c010506e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105071:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105074:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105077:	75 0d                	jne    c0105086 <page_insert+0x6f>
            page_ref_dec(page);
c0105079:	8b 45 0c             	mov    0xc(%ebp),%eax
c010507c:	89 04 24             	mov    %eax,(%esp)
c010507f:	e8 a2 f4 ff ff       	call   c0104526 <page_ref_dec>
c0105084:	eb 19                	jmp    c010509f <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105086:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105089:	89 44 24 08          	mov    %eax,0x8(%esp)
c010508d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105090:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105094:	8b 45 08             	mov    0x8(%ebp),%eax
c0105097:	89 04 24             	mov    %eax,(%esp)
c010509a:	e8 ce fe ff ff       	call   c0104f6d <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050a2:	89 04 24             	mov    %eax,(%esp)
c01050a5:	e8 ff f2 ff ff       	call   c01043a9 <page2pa>
c01050aa:	0b 45 14             	or     0x14(%ebp),%eax
c01050ad:	83 c8 01             	or     $0x1,%eax
c01050b0:	89 c2                	mov    %eax,%edx
c01050b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050b5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01050b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01050ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050be:	8b 45 08             	mov    0x8(%ebp),%eax
c01050c1:	89 04 24             	mov    %eax,(%esp)
c01050c4:	e8 07 00 00 00       	call   c01050d0 <tlb_invalidate>
    return 0;
c01050c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050ce:	c9                   	leave  
c01050cf:	c3                   	ret    

c01050d0 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01050d0:	55                   	push   %ebp
c01050d1:	89 e5                	mov    %esp,%ebp
c01050d3:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01050d6:	0f 20 d8             	mov    %cr3,%eax
c01050d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01050dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01050df:	89 c2                	mov    %eax,%edx
c01050e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01050e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050e7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01050ee:	77 23                	ja     c0105113 <tlb_invalidate+0x43>
c01050f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050f7:	c7 44 24 08 98 98 10 	movl   $0xc0109898,0x8(%esp)
c01050fe:	c0 
c01050ff:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0105106:	00 
c0105107:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010510e:	e8 ce bb ff ff       	call   c0100ce1 <__panic>
c0105113:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105116:	05 00 00 00 40       	add    $0x40000000,%eax
c010511b:	39 c2                	cmp    %eax,%edx
c010511d:	75 0c                	jne    c010512b <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010511f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105122:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105125:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105128:	0f 01 38             	invlpg (%eax)
    }
}
c010512b:	c9                   	leave  
c010512c:	c3                   	ret    

c010512d <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010512d:	55                   	push   %ebp
c010512e:	89 e5                	mov    %esp,%ebp
c0105130:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010513a:	e8 be f5 ff ff       	call   c01046fd <alloc_pages>
c010513f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105146:	0f 84 a7 00 00 00    	je     c01051f3 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010514c:	8b 45 10             	mov    0x10(%ebp),%eax
c010514f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105153:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105156:	89 44 24 08          	mov    %eax,0x8(%esp)
c010515a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010515d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105161:	8b 45 08             	mov    0x8(%ebp),%eax
c0105164:	89 04 24             	mov    %eax,(%esp)
c0105167:	e8 ab fe ff ff       	call   c0105017 <page_insert>
c010516c:	85 c0                	test   %eax,%eax
c010516e:	74 1a                	je     c010518a <pgdir_alloc_page+0x5d>
            free_page(page);
c0105170:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105177:	00 
c0105178:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010517b:	89 04 24             	mov    %eax,(%esp)
c010517e:	e8 e5 f5 ff ff       	call   c0104768 <free_pages>
            return NULL;
c0105183:	b8 00 00 00 00       	mov    $0x0,%eax
c0105188:	eb 6c                	jmp    c01051f6 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c010518a:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c010518f:	85 c0                	test   %eax,%eax
c0105191:	74 60                	je     c01051f3 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105193:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0105198:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010519f:	00 
c01051a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051a3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01051a7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051ae:	89 04 24             	mov    %eax,(%esp)
c01051b1:	e8 73 0f 00 00       	call   c0106129 <swap_map_swappable>
            page->pra_vaddr=la;
c01051b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051bc:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01051bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051c2:	89 04 24             	mov    %eax,(%esp)
c01051c5:	e8 2e f3 ff ff       	call   c01044f8 <page_ref>
c01051ca:	83 f8 01             	cmp    $0x1,%eax
c01051cd:	74 24                	je     c01051f3 <pgdir_alloc_page+0xc6>
c01051cf:	c7 44 24 0c 9c 99 10 	movl   $0xc010999c,0xc(%esp)
c01051d6:	c0 
c01051d7:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01051de:	c0 
c01051df:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c01051e6:	00 
c01051e7:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01051ee:	e8 ee ba ff ff       	call   c0100ce1 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01051f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01051f6:	c9                   	leave  
c01051f7:	c3                   	ret    

c01051f8 <check_alloc_page>:

static void
check_alloc_page(void) {
c01051f8:	55                   	push   %ebp
c01051f9:	89 e5                	mov    %esp,%ebp
c01051fb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01051fe:	a1 4c 40 12 c0       	mov    0xc012404c,%eax
c0105203:	8b 40 18             	mov    0x18(%eax),%eax
c0105206:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105208:	c7 04 24 b0 99 10 c0 	movl   $0xc01099b0,(%esp)
c010520f:	e8 43 b1 ff ff       	call   c0100357 <cprintf>
}
c0105214:	c9                   	leave  
c0105215:	c3                   	ret    

c0105216 <check_pgdir>:

static void
check_pgdir(void) {
c0105216:	55                   	push   %ebp
c0105217:	89 e5                	mov    %esp,%ebp
c0105219:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010521c:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0105221:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105226:	76 24                	jbe    c010524c <check_pgdir+0x36>
c0105228:	c7 44 24 0c cf 99 10 	movl   $0xc01099cf,0xc(%esp)
c010522f:	c0 
c0105230:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105237:	c0 
c0105238:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c010523f:	00 
c0105240:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105247:	e8 95 ba ff ff       	call   c0100ce1 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010524c:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105251:	85 c0                	test   %eax,%eax
c0105253:	74 0e                	je     c0105263 <check_pgdir+0x4d>
c0105255:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010525a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010525f:	85 c0                	test   %eax,%eax
c0105261:	74 24                	je     c0105287 <check_pgdir+0x71>
c0105263:	c7 44 24 0c ec 99 10 	movl   $0xc01099ec,0xc(%esp)
c010526a:	c0 
c010526b:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105272:	c0 
c0105273:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c010527a:	00 
c010527b:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105282:	e8 5a ba ff ff       	call   c0100ce1 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105287:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010528c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105293:	00 
c0105294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010529b:	00 
c010529c:	89 04 24             	mov    %eax,(%esp)
c010529f:	e8 70 fc ff ff       	call   c0104f14 <get_page>
c01052a4:	85 c0                	test   %eax,%eax
c01052a6:	74 24                	je     c01052cc <check_pgdir+0xb6>
c01052a8:	c7 44 24 0c 24 9a 10 	movl   $0xc0109a24,0xc(%esp)
c01052af:	c0 
c01052b0:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01052b7:	c0 
c01052b8:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01052bf:	00 
c01052c0:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01052c7:	e8 15 ba ff ff       	call   c0100ce1 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01052cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052d3:	e8 25 f4 ff ff       	call   c01046fd <alloc_pages>
c01052d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01052db:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01052e0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01052e7:	00 
c01052e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052ef:	00 
c01052f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052f3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052f7:	89 04 24             	mov    %eax,(%esp)
c01052fa:	e8 18 fd ff ff       	call   c0105017 <page_insert>
c01052ff:	85 c0                	test   %eax,%eax
c0105301:	74 24                	je     c0105327 <check_pgdir+0x111>
c0105303:	c7 44 24 0c 4c 9a 10 	movl   $0xc0109a4c,0xc(%esp)
c010530a:	c0 
c010530b:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105312:	c0 
c0105313:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c010531a:	00 
c010531b:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105322:	e8 ba b9 ff ff       	call   c0100ce1 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105327:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010532c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105333:	00 
c0105334:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010533b:	00 
c010533c:	89 04 24             	mov    %eax,(%esp)
c010533f:	e8 98 fa ff ff       	call   c0104ddc <get_pte>
c0105344:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105347:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010534b:	75 24                	jne    c0105371 <check_pgdir+0x15b>
c010534d:	c7 44 24 0c 78 9a 10 	movl   $0xc0109a78,0xc(%esp)
c0105354:	c0 
c0105355:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c010535c:	c0 
c010535d:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0105364:	00 
c0105365:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010536c:	e8 70 b9 ff ff       	call   c0100ce1 <__panic>
    assert(pte2page(*ptep) == p1);
c0105371:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105374:	8b 00                	mov    (%eax),%eax
c0105376:	89 04 24             	mov    %eax,(%esp)
c0105379:	e8 24 f1 ff ff       	call   c01044a2 <pte2page>
c010537e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105381:	74 24                	je     c01053a7 <check_pgdir+0x191>
c0105383:	c7 44 24 0c a5 9a 10 	movl   $0xc0109aa5,0xc(%esp)
c010538a:	c0 
c010538b:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105392:	c0 
c0105393:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c010539a:	00 
c010539b:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01053a2:	e8 3a b9 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p1) == 1);
c01053a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053aa:	89 04 24             	mov    %eax,(%esp)
c01053ad:	e8 46 f1 ff ff       	call   c01044f8 <page_ref>
c01053b2:	83 f8 01             	cmp    $0x1,%eax
c01053b5:	74 24                	je     c01053db <check_pgdir+0x1c5>
c01053b7:	c7 44 24 0c bb 9a 10 	movl   $0xc0109abb,0xc(%esp)
c01053be:	c0 
c01053bf:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01053c6:	c0 
c01053c7:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c01053ce:	00 
c01053cf:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01053d6:	e8 06 b9 ff ff       	call   c0100ce1 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01053db:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01053e0:	8b 00                	mov    (%eax),%eax
c01053e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053ed:	c1 e8 0c             	shr    $0xc,%eax
c01053f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053f3:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01053f8:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01053fb:	72 23                	jb     c0105420 <check_pgdir+0x20a>
c01053fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105400:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105404:	c7 44 24 08 74 98 10 	movl   $0xc0109874,0x8(%esp)
c010540b:	c0 
c010540c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0105413:	00 
c0105414:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010541b:	e8 c1 b8 ff ff       	call   c0100ce1 <__panic>
c0105420:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105423:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105428:	83 c0 04             	add    $0x4,%eax
c010542b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010542e:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105433:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010543a:	00 
c010543b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105442:	00 
c0105443:	89 04 24             	mov    %eax,(%esp)
c0105446:	e8 91 f9 ff ff       	call   c0104ddc <get_pte>
c010544b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010544e:	74 24                	je     c0105474 <check_pgdir+0x25e>
c0105450:	c7 44 24 0c d0 9a 10 	movl   $0xc0109ad0,0xc(%esp)
c0105457:	c0 
c0105458:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c010545f:	c0 
c0105460:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0105467:	00 
c0105468:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010546f:	e8 6d b8 ff ff       	call   c0100ce1 <__panic>

    p2 = alloc_page();
c0105474:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010547b:	e8 7d f2 ff ff       	call   c01046fd <alloc_pages>
c0105480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105483:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105488:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010548f:	00 
c0105490:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105497:	00 
c0105498:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010549b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010549f:	89 04 24             	mov    %eax,(%esp)
c01054a2:	e8 70 fb ff ff       	call   c0105017 <page_insert>
c01054a7:	85 c0                	test   %eax,%eax
c01054a9:	74 24                	je     c01054cf <check_pgdir+0x2b9>
c01054ab:	c7 44 24 0c f8 9a 10 	movl   $0xc0109af8,0xc(%esp)
c01054b2:	c0 
c01054b3:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01054ba:	c0 
c01054bb:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01054c2:	00 
c01054c3:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01054ca:	e8 12 b8 ff ff       	call   c0100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01054cf:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01054d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01054db:	00 
c01054dc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01054e3:	00 
c01054e4:	89 04 24             	mov    %eax,(%esp)
c01054e7:	e8 f0 f8 ff ff       	call   c0104ddc <get_pte>
c01054ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054f3:	75 24                	jne    c0105519 <check_pgdir+0x303>
c01054f5:	c7 44 24 0c 30 9b 10 	movl   $0xc0109b30,0xc(%esp)
c01054fc:	c0 
c01054fd:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105504:	c0 
c0105505:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c010550c:	00 
c010550d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105514:	e8 c8 b7 ff ff       	call   c0100ce1 <__panic>
    assert(*ptep & PTE_U);
c0105519:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010551c:	8b 00                	mov    (%eax),%eax
c010551e:	83 e0 04             	and    $0x4,%eax
c0105521:	85 c0                	test   %eax,%eax
c0105523:	75 24                	jne    c0105549 <check_pgdir+0x333>
c0105525:	c7 44 24 0c 60 9b 10 	movl   $0xc0109b60,0xc(%esp)
c010552c:	c0 
c010552d:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105534:	c0 
c0105535:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c010553c:	00 
c010553d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105544:	e8 98 b7 ff ff       	call   c0100ce1 <__panic>
    assert(*ptep & PTE_W);
c0105549:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010554c:	8b 00                	mov    (%eax),%eax
c010554e:	83 e0 02             	and    $0x2,%eax
c0105551:	85 c0                	test   %eax,%eax
c0105553:	75 24                	jne    c0105579 <check_pgdir+0x363>
c0105555:	c7 44 24 0c 6e 9b 10 	movl   $0xc0109b6e,0xc(%esp)
c010555c:	c0 
c010555d:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105564:	c0 
c0105565:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c010556c:	00 
c010556d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105574:	e8 68 b7 ff ff       	call   c0100ce1 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105579:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010557e:	8b 00                	mov    (%eax),%eax
c0105580:	83 e0 04             	and    $0x4,%eax
c0105583:	85 c0                	test   %eax,%eax
c0105585:	75 24                	jne    c01055ab <check_pgdir+0x395>
c0105587:	c7 44 24 0c 7c 9b 10 	movl   $0xc0109b7c,0xc(%esp)
c010558e:	c0 
c010558f:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105596:	c0 
c0105597:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c010559e:	00 
c010559f:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01055a6:	e8 36 b7 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 1);
c01055ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055ae:	89 04 24             	mov    %eax,(%esp)
c01055b1:	e8 42 ef ff ff       	call   c01044f8 <page_ref>
c01055b6:	83 f8 01             	cmp    $0x1,%eax
c01055b9:	74 24                	je     c01055df <check_pgdir+0x3c9>
c01055bb:	c7 44 24 0c 92 9b 10 	movl   $0xc0109b92,0xc(%esp)
c01055c2:	c0 
c01055c3:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01055ca:	c0 
c01055cb:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01055d2:	00 
c01055d3:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01055da:	e8 02 b7 ff ff       	call   c0100ce1 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01055df:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01055e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01055eb:	00 
c01055ec:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01055f3:	00 
c01055f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055fb:	89 04 24             	mov    %eax,(%esp)
c01055fe:	e8 14 fa ff ff       	call   c0105017 <page_insert>
c0105603:	85 c0                	test   %eax,%eax
c0105605:	74 24                	je     c010562b <check_pgdir+0x415>
c0105607:	c7 44 24 0c a4 9b 10 	movl   $0xc0109ba4,0xc(%esp)
c010560e:	c0 
c010560f:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105616:	c0 
c0105617:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c010561e:	00 
c010561f:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105626:	e8 b6 b6 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p1) == 2);
c010562b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010562e:	89 04 24             	mov    %eax,(%esp)
c0105631:	e8 c2 ee ff ff       	call   c01044f8 <page_ref>
c0105636:	83 f8 02             	cmp    $0x2,%eax
c0105639:	74 24                	je     c010565f <check_pgdir+0x449>
c010563b:	c7 44 24 0c d0 9b 10 	movl   $0xc0109bd0,0xc(%esp)
c0105642:	c0 
c0105643:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c010564a:	c0 
c010564b:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105652:	00 
c0105653:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010565a:	e8 82 b6 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c010565f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105662:	89 04 24             	mov    %eax,(%esp)
c0105665:	e8 8e ee ff ff       	call   c01044f8 <page_ref>
c010566a:	85 c0                	test   %eax,%eax
c010566c:	74 24                	je     c0105692 <check_pgdir+0x47c>
c010566e:	c7 44 24 0c e2 9b 10 	movl   $0xc0109be2,0xc(%esp)
c0105675:	c0 
c0105676:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c010567d:	c0 
c010567e:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105685:	00 
c0105686:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010568d:	e8 4f b6 ff ff       	call   c0100ce1 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105692:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105697:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010569e:	00 
c010569f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01056a6:	00 
c01056a7:	89 04 24             	mov    %eax,(%esp)
c01056aa:	e8 2d f7 ff ff       	call   c0104ddc <get_pte>
c01056af:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056b6:	75 24                	jne    c01056dc <check_pgdir+0x4c6>
c01056b8:	c7 44 24 0c 30 9b 10 	movl   $0xc0109b30,0xc(%esp)
c01056bf:	c0 
c01056c0:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01056c7:	c0 
c01056c8:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c01056cf:	00 
c01056d0:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01056d7:	e8 05 b6 ff ff       	call   c0100ce1 <__panic>
    assert(pte2page(*ptep) == p1);
c01056dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056df:	8b 00                	mov    (%eax),%eax
c01056e1:	89 04 24             	mov    %eax,(%esp)
c01056e4:	e8 b9 ed ff ff       	call   c01044a2 <pte2page>
c01056e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01056ec:	74 24                	je     c0105712 <check_pgdir+0x4fc>
c01056ee:	c7 44 24 0c a5 9a 10 	movl   $0xc0109aa5,0xc(%esp)
c01056f5:	c0 
c01056f6:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01056fd:	c0 
c01056fe:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105705:	00 
c0105706:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010570d:	e8 cf b5 ff ff       	call   c0100ce1 <__panic>
    assert((*ptep & PTE_U) == 0);
c0105712:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105715:	8b 00                	mov    (%eax),%eax
c0105717:	83 e0 04             	and    $0x4,%eax
c010571a:	85 c0                	test   %eax,%eax
c010571c:	74 24                	je     c0105742 <check_pgdir+0x52c>
c010571e:	c7 44 24 0c f4 9b 10 	movl   $0xc0109bf4,0xc(%esp)
c0105725:	c0 
c0105726:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c010572d:	c0 
c010572e:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105735:	00 
c0105736:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010573d:	e8 9f b5 ff ff       	call   c0100ce1 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105742:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105747:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010574e:	00 
c010574f:	89 04 24             	mov    %eax,(%esp)
c0105752:	e8 7c f8 ff ff       	call   c0104fd3 <page_remove>
    assert(page_ref(p1) == 1);
c0105757:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010575a:	89 04 24             	mov    %eax,(%esp)
c010575d:	e8 96 ed ff ff       	call   c01044f8 <page_ref>
c0105762:	83 f8 01             	cmp    $0x1,%eax
c0105765:	74 24                	je     c010578b <check_pgdir+0x575>
c0105767:	c7 44 24 0c bb 9a 10 	movl   $0xc0109abb,0xc(%esp)
c010576e:	c0 
c010576f:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105776:	c0 
c0105777:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010577e:	00 
c010577f:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105786:	e8 56 b5 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c010578b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010578e:	89 04 24             	mov    %eax,(%esp)
c0105791:	e8 62 ed ff ff       	call   c01044f8 <page_ref>
c0105796:	85 c0                	test   %eax,%eax
c0105798:	74 24                	je     c01057be <check_pgdir+0x5a8>
c010579a:	c7 44 24 0c e2 9b 10 	movl   $0xc0109be2,0xc(%esp)
c01057a1:	c0 
c01057a2:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01057a9:	c0 
c01057aa:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c01057b1:	00 
c01057b2:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01057b9:	e8 23 b5 ff ff       	call   c0100ce1 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01057be:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01057c3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057ca:	00 
c01057cb:	89 04 24             	mov    %eax,(%esp)
c01057ce:	e8 00 f8 ff ff       	call   c0104fd3 <page_remove>
    assert(page_ref(p1) == 0);
c01057d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057d6:	89 04 24             	mov    %eax,(%esp)
c01057d9:	e8 1a ed ff ff       	call   c01044f8 <page_ref>
c01057de:	85 c0                	test   %eax,%eax
c01057e0:	74 24                	je     c0105806 <check_pgdir+0x5f0>
c01057e2:	c7 44 24 0c 09 9c 10 	movl   $0xc0109c09,0xc(%esp)
c01057e9:	c0 
c01057ea:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01057f1:	c0 
c01057f2:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01057f9:	00 
c01057fa:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105801:	e8 db b4 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p2) == 0);
c0105806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105809:	89 04 24             	mov    %eax,(%esp)
c010580c:	e8 e7 ec ff ff       	call   c01044f8 <page_ref>
c0105811:	85 c0                	test   %eax,%eax
c0105813:	74 24                	je     c0105839 <check_pgdir+0x623>
c0105815:	c7 44 24 0c e2 9b 10 	movl   $0xc0109be2,0xc(%esp)
c010581c:	c0 
c010581d:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105824:	c0 
c0105825:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c010582c:	00 
c010582d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105834:	e8 a8 b4 ff ff       	call   c0100ce1 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105839:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010583e:	8b 00                	mov    (%eax),%eax
c0105840:	89 04 24             	mov    %eax,(%esp)
c0105843:	e8 98 ec ff ff       	call   c01044e0 <pde2page>
c0105848:	89 04 24             	mov    %eax,(%esp)
c010584b:	e8 a8 ec ff ff       	call   c01044f8 <page_ref>
c0105850:	83 f8 01             	cmp    $0x1,%eax
c0105853:	74 24                	je     c0105879 <check_pgdir+0x663>
c0105855:	c7 44 24 0c 1c 9c 10 	movl   $0xc0109c1c,0xc(%esp)
c010585c:	c0 
c010585d:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105864:	c0 
c0105865:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c010586c:	00 
c010586d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105874:	e8 68 b4 ff ff       	call   c0100ce1 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105879:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010587e:	8b 00                	mov    (%eax),%eax
c0105880:	89 04 24             	mov    %eax,(%esp)
c0105883:	e8 58 ec ff ff       	call   c01044e0 <pde2page>
c0105888:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010588f:	00 
c0105890:	89 04 24             	mov    %eax,(%esp)
c0105893:	e8 d0 ee ff ff       	call   c0104768 <free_pages>
    boot_pgdir[0] = 0;
c0105898:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010589d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01058a3:	c7 04 24 43 9c 10 c0 	movl   $0xc0109c43,(%esp)
c01058aa:	e8 a8 aa ff ff       	call   c0100357 <cprintf>
}
c01058af:	c9                   	leave  
c01058b0:	c3                   	ret    

c01058b1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01058b1:	55                   	push   %ebp
c01058b2:	89 e5                	mov    %esp,%ebp
c01058b4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01058b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01058be:	e9 ca 00 00 00       	jmp    c010598d <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058cc:	c1 e8 0c             	shr    $0xc,%eax
c01058cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058d2:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01058d7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01058da:	72 23                	jb     c01058ff <check_boot_pgdir+0x4e>
c01058dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058df:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058e3:	c7 44 24 08 74 98 10 	movl   $0xc0109874,0x8(%esp)
c01058ea:	c0 
c01058eb:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01058f2:	00 
c01058f3:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01058fa:	e8 e2 b3 ff ff       	call   c0100ce1 <__panic>
c01058ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105902:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105907:	89 c2                	mov    %eax,%edx
c0105909:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010590e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105915:	00 
c0105916:	89 54 24 04          	mov    %edx,0x4(%esp)
c010591a:	89 04 24             	mov    %eax,(%esp)
c010591d:	e8 ba f4 ff ff       	call   c0104ddc <get_pte>
c0105922:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105925:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105929:	75 24                	jne    c010594f <check_boot_pgdir+0x9e>
c010592b:	c7 44 24 0c 60 9c 10 	movl   $0xc0109c60,0xc(%esp)
c0105932:	c0 
c0105933:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c010593a:	c0 
c010593b:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105942:	00 
c0105943:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c010594a:	e8 92 b3 ff ff       	call   c0100ce1 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010594f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105952:	8b 00                	mov    (%eax),%eax
c0105954:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105959:	89 c2                	mov    %eax,%edx
c010595b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595e:	39 c2                	cmp    %eax,%edx
c0105960:	74 24                	je     c0105986 <check_boot_pgdir+0xd5>
c0105962:	c7 44 24 0c 9d 9c 10 	movl   $0xc0109c9d,0xc(%esp)
c0105969:	c0 
c010596a:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105971:	c0 
c0105972:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105979:	00 
c010597a:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105981:	e8 5b b3 ff ff       	call   c0100ce1 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105986:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010598d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105990:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0105995:	39 c2                	cmp    %eax,%edx
c0105997:	0f 82 26 ff ff ff    	jb     c01058c3 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010599d:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01059a2:	05 ac 0f 00 00       	add    $0xfac,%eax
c01059a7:	8b 00                	mov    (%eax),%eax
c01059a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01059ae:	89 c2                	mov    %eax,%edx
c01059b0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01059b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01059b8:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01059bf:	77 23                	ja     c01059e4 <check_boot_pgdir+0x133>
c01059c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059c8:	c7 44 24 08 98 98 10 	movl   $0xc0109898,0x8(%esp)
c01059cf:	c0 
c01059d0:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01059d7:	00 
c01059d8:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c01059df:	e8 fd b2 ff ff       	call   c0100ce1 <__panic>
c01059e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059e7:	05 00 00 00 40       	add    $0x40000000,%eax
c01059ec:	39 c2                	cmp    %eax,%edx
c01059ee:	74 24                	je     c0105a14 <check_boot_pgdir+0x163>
c01059f0:	c7 44 24 0c b4 9c 10 	movl   $0xc0109cb4,0xc(%esp)
c01059f7:	c0 
c01059f8:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c01059ff:	c0 
c0105a00:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105a07:	00 
c0105a08:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105a0f:	e8 cd b2 ff ff       	call   c0100ce1 <__panic>

    assert(boot_pgdir[0] == 0);
c0105a14:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105a19:	8b 00                	mov    (%eax),%eax
c0105a1b:	85 c0                	test   %eax,%eax
c0105a1d:	74 24                	je     c0105a43 <check_boot_pgdir+0x192>
c0105a1f:	c7 44 24 0c e8 9c 10 	movl   $0xc0109ce8,0xc(%esp)
c0105a26:	c0 
c0105a27:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105a2e:	c0 
c0105a2f:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105a36:	00 
c0105a37:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105a3e:	e8 9e b2 ff ff       	call   c0100ce1 <__panic>

    struct Page *p;
    p = alloc_page();
c0105a43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a4a:	e8 ae ec ff ff       	call   c01046fd <alloc_pages>
c0105a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105a52:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105a57:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a5e:	00 
c0105a5f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105a66:	00 
c0105a67:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a6e:	89 04 24             	mov    %eax,(%esp)
c0105a71:	e8 a1 f5 ff ff       	call   c0105017 <page_insert>
c0105a76:	85 c0                	test   %eax,%eax
c0105a78:	74 24                	je     c0105a9e <check_boot_pgdir+0x1ed>
c0105a7a:	c7 44 24 0c fc 9c 10 	movl   $0xc0109cfc,0xc(%esp)
c0105a81:	c0 
c0105a82:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105a89:	c0 
c0105a8a:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0105a91:	00 
c0105a92:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105a99:	e8 43 b2 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p) == 1);
c0105a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aa1:	89 04 24             	mov    %eax,(%esp)
c0105aa4:	e8 4f ea ff ff       	call   c01044f8 <page_ref>
c0105aa9:	83 f8 01             	cmp    $0x1,%eax
c0105aac:	74 24                	je     c0105ad2 <check_boot_pgdir+0x221>
c0105aae:	c7 44 24 0c 2a 9d 10 	movl   $0xc0109d2a,0xc(%esp)
c0105ab5:	c0 
c0105ab6:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105abd:	c0 
c0105abe:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105ac5:	00 
c0105ac6:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105acd:	e8 0f b2 ff ff       	call   c0100ce1 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105ad2:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105ad7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105ade:	00 
c0105adf:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105ae6:	00 
c0105ae7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105aea:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105aee:	89 04 24             	mov    %eax,(%esp)
c0105af1:	e8 21 f5 ff ff       	call   c0105017 <page_insert>
c0105af6:	85 c0                	test   %eax,%eax
c0105af8:	74 24                	je     c0105b1e <check_boot_pgdir+0x26d>
c0105afa:	c7 44 24 0c 3c 9d 10 	movl   $0xc0109d3c,0xc(%esp)
c0105b01:	c0 
c0105b02:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105b09:	c0 
c0105b0a:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105b11:	00 
c0105b12:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105b19:	e8 c3 b1 ff ff       	call   c0100ce1 <__panic>
    assert(page_ref(p) == 2);
c0105b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b21:	89 04 24             	mov    %eax,(%esp)
c0105b24:	e8 cf e9 ff ff       	call   c01044f8 <page_ref>
c0105b29:	83 f8 02             	cmp    $0x2,%eax
c0105b2c:	74 24                	je     c0105b52 <check_boot_pgdir+0x2a1>
c0105b2e:	c7 44 24 0c 73 9d 10 	movl   $0xc0109d73,0xc(%esp)
c0105b35:	c0 
c0105b36:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105b3d:	c0 
c0105b3e:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0105b45:	00 
c0105b46:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105b4d:	e8 8f b1 ff ff       	call   c0100ce1 <__panic>

    const char *str = "ucore: Hello world!!";
c0105b52:	c7 45 dc 84 9d 10 c0 	movl   $0xc0109d84,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105b59:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b60:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b67:	e8 38 2c 00 00       	call   c01087a4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105b6c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105b73:	00 
c0105b74:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b7b:	e8 9d 2c 00 00       	call   c010881d <strcmp>
c0105b80:	85 c0                	test   %eax,%eax
c0105b82:	74 24                	je     c0105ba8 <check_boot_pgdir+0x2f7>
c0105b84:	c7 44 24 0c 9c 9d 10 	movl   $0xc0109d9c,0xc(%esp)
c0105b8b:	c0 
c0105b8c:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105b93:	c0 
c0105b94:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0105b9b:	00 
c0105b9c:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105ba3:	e8 39 b1 ff ff       	call   c0100ce1 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105ba8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bab:	89 04 24             	mov    %eax,(%esp)
c0105bae:	e8 51 e8 ff ff       	call   c0104404 <page2kva>
c0105bb3:	05 00 01 00 00       	add    $0x100,%eax
c0105bb8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105bbb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105bc2:	e8 85 2b 00 00       	call   c010874c <strlen>
c0105bc7:	85 c0                	test   %eax,%eax
c0105bc9:	74 24                	je     c0105bef <check_boot_pgdir+0x33e>
c0105bcb:	c7 44 24 0c d4 9d 10 	movl   $0xc0109dd4,0xc(%esp)
c0105bd2:	c0 
c0105bd3:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105bda:	c0 
c0105bdb:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105be2:	00 
c0105be3:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105bea:	e8 f2 b0 ff ff       	call   c0100ce1 <__panic>

    free_page(p);
c0105bef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105bf6:	00 
c0105bf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bfa:	89 04 24             	mov    %eax,(%esp)
c0105bfd:	e8 66 eb ff ff       	call   c0104768 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105c02:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105c07:	8b 00                	mov    (%eax),%eax
c0105c09:	89 04 24             	mov    %eax,(%esp)
c0105c0c:	e8 cf e8 ff ff       	call   c01044e0 <pde2page>
c0105c11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c18:	00 
c0105c19:	89 04 24             	mov    %eax,(%esp)
c0105c1c:	e8 47 eb ff ff       	call   c0104768 <free_pages>
    boot_pgdir[0] = 0;
c0105c21:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0105c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105c2c:	c7 04 24 f8 9d 10 c0 	movl   $0xc0109df8,(%esp)
c0105c33:	e8 1f a7 ff ff       	call   c0100357 <cprintf>
}
c0105c38:	c9                   	leave  
c0105c39:	c3                   	ret    

c0105c3a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105c3a:	55                   	push   %ebp
c0105c3b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c40:	83 e0 04             	and    $0x4,%eax
c0105c43:	85 c0                	test   %eax,%eax
c0105c45:	74 07                	je     c0105c4e <perm2str+0x14>
c0105c47:	b8 75 00 00 00       	mov    $0x75,%eax
c0105c4c:	eb 05                	jmp    c0105c53 <perm2str+0x19>
c0105c4e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c53:	a2 28 40 12 c0       	mov    %al,0xc0124028
    str[1] = 'r';
c0105c58:	c6 05 29 40 12 c0 72 	movb   $0x72,0xc0124029
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c62:	83 e0 02             	and    $0x2,%eax
c0105c65:	85 c0                	test   %eax,%eax
c0105c67:	74 07                	je     c0105c70 <perm2str+0x36>
c0105c69:	b8 77 00 00 00       	mov    $0x77,%eax
c0105c6e:	eb 05                	jmp    c0105c75 <perm2str+0x3b>
c0105c70:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c75:	a2 2a 40 12 c0       	mov    %al,0xc012402a
    str[3] = '\0';
c0105c7a:	c6 05 2b 40 12 c0 00 	movb   $0x0,0xc012402b
    return str;
c0105c81:	b8 28 40 12 c0       	mov    $0xc0124028,%eax
}
c0105c86:	5d                   	pop    %ebp
c0105c87:	c3                   	ret    

c0105c88 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105c88:	55                   	push   %ebp
c0105c89:	89 e5                	mov    %esp,%ebp
c0105c8b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105c8e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c91:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c94:	72 0a                	jb     c0105ca0 <get_pgtable_items+0x18>
        return 0;
c0105c96:	b8 00 00 00 00       	mov    $0x0,%eax
c0105c9b:	e9 9c 00 00 00       	jmp    c0105d3c <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105ca0:	eb 04                	jmp    c0105ca6 <get_pgtable_items+0x1e>
        start ++;
c0105ca2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105ca6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105cac:	73 18                	jae    c0105cc6 <get_pgtable_items+0x3e>
c0105cae:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cb8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cbb:	01 d0                	add    %edx,%eax
c0105cbd:	8b 00                	mov    (%eax),%eax
c0105cbf:	83 e0 01             	and    $0x1,%eax
c0105cc2:	85 c0                	test   %eax,%eax
c0105cc4:	74 dc                	je     c0105ca2 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105cc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ccc:	73 69                	jae    c0105d37 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105cce:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105cd2:	74 08                	je     c0105cdc <get_pgtable_items+0x54>
            *left_store = start;
c0105cd4:	8b 45 18             	mov    0x18(%ebp),%eax
c0105cd7:	8b 55 10             	mov    0x10(%ebp),%edx
c0105cda:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105cdc:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cdf:	8d 50 01             	lea    0x1(%eax),%edx
c0105ce2:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ce5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cec:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cef:	01 d0                	add    %edx,%eax
c0105cf1:	8b 00                	mov    (%eax),%eax
c0105cf3:	83 e0 07             	and    $0x7,%eax
c0105cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105cf9:	eb 04                	jmp    c0105cff <get_pgtable_items+0x77>
            start ++;
c0105cfb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105cff:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d02:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d05:	73 1d                	jae    c0105d24 <get_pgtable_items+0x9c>
c0105d07:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105d11:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d14:	01 d0                	add    %edx,%eax
c0105d16:	8b 00                	mov    (%eax),%eax
c0105d18:	83 e0 07             	and    $0x7,%eax
c0105d1b:	89 c2                	mov    %eax,%edx
c0105d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d20:	39 c2                	cmp    %eax,%edx
c0105d22:	74 d7                	je     c0105cfb <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105d24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105d28:	74 08                	je     c0105d32 <get_pgtable_items+0xaa>
            *right_store = start;
c0105d2a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105d2d:	8b 55 10             	mov    0x10(%ebp),%edx
c0105d30:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d35:	eb 05                	jmp    c0105d3c <get_pgtable_items+0xb4>
    }
    return 0;
c0105d37:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d3c:	c9                   	leave  
c0105d3d:	c3                   	ret    

c0105d3e <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105d3e:	55                   	push   %ebp
c0105d3f:	89 e5                	mov    %esp,%ebp
c0105d41:	57                   	push   %edi
c0105d42:	56                   	push   %esi
c0105d43:	53                   	push   %ebx
c0105d44:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105d47:	c7 04 24 18 9e 10 c0 	movl   $0xc0109e18,(%esp)
c0105d4e:	e8 04 a6 ff ff       	call   c0100357 <cprintf>
    size_t left, right = 0, perm;
c0105d53:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105d5a:	e9 fa 00 00 00       	jmp    c0105e59 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d62:	89 04 24             	mov    %eax,(%esp)
c0105d65:	e8 d0 fe ff ff       	call   c0105c3a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105d6a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d70:	29 d1                	sub    %edx,%ecx
c0105d72:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d74:	89 d6                	mov    %edx,%esi
c0105d76:	c1 e6 16             	shl    $0x16,%esi
c0105d79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105d7c:	89 d3                	mov    %edx,%ebx
c0105d7e:	c1 e3 16             	shl    $0x16,%ebx
c0105d81:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d84:	89 d1                	mov    %edx,%ecx
c0105d86:	c1 e1 16             	shl    $0x16,%ecx
c0105d89:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105d8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d8f:	29 d7                	sub    %edx,%edi
c0105d91:	89 fa                	mov    %edi,%edx
c0105d93:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105d97:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105d9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105da3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105da7:	c7 04 24 49 9e 10 c0 	movl   $0xc0109e49,(%esp)
c0105dae:	e8 a4 a5 ff ff       	call   c0100357 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105db6:	c1 e0 0a             	shl    $0xa,%eax
c0105db9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105dbc:	eb 54                	jmp    c0105e12 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dc1:	89 04 24             	mov    %eax,(%esp)
c0105dc4:	e8 71 fe ff ff       	call   c0105c3a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105dc9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105dcc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105dcf:	29 d1                	sub    %edx,%ecx
c0105dd1:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105dd3:	89 d6                	mov    %edx,%esi
c0105dd5:	c1 e6 0c             	shl    $0xc,%esi
c0105dd8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105ddb:	89 d3                	mov    %edx,%ebx
c0105ddd:	c1 e3 0c             	shl    $0xc,%ebx
c0105de0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105de3:	c1 e2 0c             	shl    $0xc,%edx
c0105de6:	89 d1                	mov    %edx,%ecx
c0105de8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105deb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105dee:	29 d7                	sub    %edx,%edi
c0105df0:	89 fa                	mov    %edi,%edx
c0105df2:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105df6:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105dfa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105dfe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105e02:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e06:	c7 04 24 68 9e 10 c0 	movl   $0xc0109e68,(%esp)
c0105e0d:	e8 45 a5 ff ff       	call   c0100357 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105e12:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105e17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e1a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e1d:	89 ce                	mov    %ecx,%esi
c0105e1f:	c1 e6 0a             	shl    $0xa,%esi
c0105e22:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105e25:	89 cb                	mov    %ecx,%ebx
c0105e27:	c1 e3 0a             	shl    $0xa,%ebx
c0105e2a:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105e2d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e31:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105e34:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e38:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e3c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e40:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105e44:	89 1c 24             	mov    %ebx,(%esp)
c0105e47:	e8 3c fe ff ff       	call   c0105c88 <get_pgtable_items>
c0105e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e53:	0f 85 65 ff ff ff    	jne    c0105dbe <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e59:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e61:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105e64:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e68:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105e6b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e6f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e73:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e77:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105e7e:	00 
c0105e7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105e86:	e8 fd fd ff ff       	call   c0105c88 <get_pgtable_items>
c0105e8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e92:	0f 85 c7 fe ff ff    	jne    c0105d5f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105e98:	c7 04 24 8c 9e 10 c0 	movl   $0xc0109e8c,(%esp)
c0105e9f:	e8 b3 a4 ff ff       	call   c0100357 <cprintf>
}
c0105ea4:	83 c4 4c             	add    $0x4c,%esp
c0105ea7:	5b                   	pop    %ebx
c0105ea8:	5e                   	pop    %esi
c0105ea9:	5f                   	pop    %edi
c0105eaa:	5d                   	pop    %ebp
c0105eab:	c3                   	ret    

c0105eac <kmalloc>:

void *
kmalloc(size_t n) {
c0105eac:	55                   	push   %ebp
c0105ead:	89 e5                	mov    %esp,%ebp
c0105eaf:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105eb9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105ec0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ec4:	74 09                	je     c0105ecf <kmalloc+0x23>
c0105ec6:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105ecd:	76 24                	jbe    c0105ef3 <kmalloc+0x47>
c0105ecf:	c7 44 24 0c bd 9e 10 	movl   $0xc0109ebd,0xc(%esp)
c0105ed6:	c0 
c0105ed7:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105ede:	c0 
c0105edf:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c0105ee6:	00 
c0105ee7:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105eee:	e8 ee ad ff ff       	call   c0100ce1 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105ef3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef6:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105efb:	c1 e8 0c             	shr    $0xc,%eax
c0105efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f04:	89 04 24             	mov    %eax,(%esp)
c0105f07:	e8 f1 e7 ff ff       	call   c01046fd <alloc_pages>
c0105f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f13:	75 24                	jne    c0105f39 <kmalloc+0x8d>
c0105f15:	c7 44 24 0c d4 9e 10 	movl   $0xc0109ed4,0xc(%esp)
c0105f1c:	c0 
c0105f1d:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105f24:	c0 
c0105f25:	c7 44 24 04 a2 02 00 	movl   $0x2a2,0x4(%esp)
c0105f2c:	00 
c0105f2d:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105f34:	e8 a8 ad ff ff       	call   c0100ce1 <__panic>
    ptr=page2kva(base);
c0105f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f3c:	89 04 24             	mov    %eax,(%esp)
c0105f3f:	e8 c0 e4 ff ff       	call   c0104404 <page2kva>
c0105f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f4a:	c9                   	leave  
c0105f4b:	c3                   	ret    

c0105f4c <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105f4c:	55                   	push   %ebp
c0105f4d:	89 e5                	mov    %esp,%ebp
c0105f4f:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105f52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f56:	74 09                	je     c0105f61 <kfree+0x15>
c0105f58:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105f5f:	76 24                	jbe    c0105f85 <kfree+0x39>
c0105f61:	c7 44 24 0c bd 9e 10 	movl   $0xc0109ebd,0xc(%esp)
c0105f68:	c0 
c0105f69:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105f70:	c0 
c0105f71:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c0105f78:	00 
c0105f79:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105f80:	e8 5c ad ff ff       	call   c0100ce1 <__panic>
    assert(ptr != NULL);
c0105f85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f89:	75 24                	jne    c0105faf <kfree+0x63>
c0105f8b:	c7 44 24 0c e1 9e 10 	movl   $0xc0109ee1,0xc(%esp)
c0105f92:	c0 
c0105f93:	c7 44 24 08 61 99 10 	movl   $0xc0109961,0x8(%esp)
c0105f9a:	c0 
c0105f9b:	c7 44 24 04 aa 02 00 	movl   $0x2aa,0x4(%esp)
c0105fa2:	00 
c0105fa3:	c7 04 24 3c 99 10 c0 	movl   $0xc010993c,(%esp)
c0105faa:	e8 32 ad ff ff       	call   c0100ce1 <__panic>
    struct Page *base=NULL;
c0105faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fb9:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105fbe:	c1 e8 0c             	shr    $0xc,%eax
c0105fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105fc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc7:	89 04 24             	mov    %eax,(%esp)
c0105fca:	e8 89 e4 ff ff       	call   c0104458 <kva2page>
c0105fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fdc:	89 04 24             	mov    %eax,(%esp)
c0105fdf:	e8 84 e7 ff ff       	call   c0104768 <free_pages>
}
c0105fe4:	c9                   	leave  
c0105fe5:	c3                   	ret    

c0105fe6 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105fe6:	55                   	push   %ebp
c0105fe7:	89 e5                	mov    %esp,%ebp
c0105fe9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0105fec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fef:	c1 e8 0c             	shr    $0xc,%eax
c0105ff2:	89 c2                	mov    %eax,%edx
c0105ff4:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0105ff9:	39 c2                	cmp    %eax,%edx
c0105ffb:	72 1c                	jb     c0106019 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0105ffd:	c7 44 24 08 f0 9e 10 	movl   $0xc0109ef0,0x8(%esp)
c0106004:	c0 
c0106005:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010600c:	00 
c010600d:	c7 04 24 0f 9f 10 c0 	movl   $0xc0109f0f,(%esp)
c0106014:	e8 c8 ac ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c0106019:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c010601e:	8b 55 08             	mov    0x8(%ebp),%edx
c0106021:	c1 ea 0c             	shr    $0xc,%edx
c0106024:	c1 e2 05             	shl    $0x5,%edx
c0106027:	01 d0                	add    %edx,%eax
}
c0106029:	c9                   	leave  
c010602a:	c3                   	ret    

c010602b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010602b:	55                   	push   %ebp
c010602c:	89 e5                	mov    %esp,%ebp
c010602e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106031:	8b 45 08             	mov    0x8(%ebp),%eax
c0106034:	83 e0 01             	and    $0x1,%eax
c0106037:	85 c0                	test   %eax,%eax
c0106039:	75 1c                	jne    c0106057 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010603b:	c7 44 24 08 20 9f 10 	movl   $0xc0109f20,0x8(%esp)
c0106042:	c0 
c0106043:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010604a:	00 
c010604b:	c7 04 24 0f 9f 10 c0 	movl   $0xc0109f0f,(%esp)
c0106052:	e8 8a ac ff ff       	call   c0100ce1 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106057:	8b 45 08             	mov    0x8(%ebp),%eax
c010605a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010605f:	89 04 24             	mov    %eax,(%esp)
c0106062:	e8 7f ff ff ff       	call   c0105fe6 <pa2page>
}
c0106067:	c9                   	leave  
c0106068:	c3                   	ret    

c0106069 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106069:	55                   	push   %ebp
c010606a:	89 e5                	mov    %esp,%ebp
c010606c:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010606f:	e8 53 1e 00 00       	call   c0107ec7 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106074:	a1 fc 40 12 c0       	mov    0xc01240fc,%eax
c0106079:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010607e:	76 0c                	jbe    c010608c <swap_init+0x23>
c0106080:	a1 fc 40 12 c0       	mov    0xc01240fc,%eax
c0106085:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c010608a:	76 25                	jbe    c01060b1 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010608c:	a1 fc 40 12 c0       	mov    0xc01240fc,%eax
c0106091:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106095:	c7 44 24 08 41 9f 10 	movl   $0xc0109f41,0x8(%esp)
c010609c:	c0 
c010609d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01060a4:	00 
c01060a5:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01060ac:	e8 30 ac ff ff       	call   c0100ce1 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01060b1:	c7 05 34 40 12 c0 40 	movl   $0xc0120a40,0xc0124034
c01060b8:	0a 12 c0 
     int r = sm->init();
c01060bb:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c01060c0:	8b 40 04             	mov    0x4(%eax),%eax
c01060c3:	ff d0                	call   *%eax
c01060c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01060c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060cc:	75 26                	jne    c01060f4 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01060ce:	c7 05 2c 40 12 c0 01 	movl   $0x1,0xc012402c
c01060d5:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01060d8:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c01060dd:	8b 00                	mov    (%eax),%eax
c01060df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060e3:	c7 04 24 6b 9f 10 c0 	movl   $0xc0109f6b,(%esp)
c01060ea:	e8 68 a2 ff ff       	call   c0100357 <cprintf>
          check_swap();
c01060ef:	e8 a4 04 00 00       	call   c0106598 <check_swap>
     }

     return r;
c01060f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01060f7:	c9                   	leave  
c01060f8:	c3                   	ret    

c01060f9 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01060f9:	55                   	push   %ebp
c01060fa:	89 e5                	mov    %esp,%ebp
c01060fc:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01060ff:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106104:	8b 40 08             	mov    0x8(%eax),%eax
c0106107:	8b 55 08             	mov    0x8(%ebp),%edx
c010610a:	89 14 24             	mov    %edx,(%esp)
c010610d:	ff d0                	call   *%eax
}
c010610f:	c9                   	leave  
c0106110:	c3                   	ret    

c0106111 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106111:	55                   	push   %ebp
c0106112:	89 e5                	mov    %esp,%ebp
c0106114:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106117:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c010611c:	8b 40 0c             	mov    0xc(%eax),%eax
c010611f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106122:	89 14 24             	mov    %edx,(%esp)
c0106125:	ff d0                	call   *%eax
}
c0106127:	c9                   	leave  
c0106128:	c3                   	ret    

c0106129 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106129:	55                   	push   %ebp
c010612a:	89 e5                	mov    %esp,%ebp
c010612c:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010612f:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106134:	8b 40 10             	mov    0x10(%eax),%eax
c0106137:	8b 55 14             	mov    0x14(%ebp),%edx
c010613a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010613e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106141:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106145:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106148:	89 54 24 04          	mov    %edx,0x4(%esp)
c010614c:	8b 55 08             	mov    0x8(%ebp),%edx
c010614f:	89 14 24             	mov    %edx,(%esp)
c0106152:	ff d0                	call   *%eax
}
c0106154:	c9                   	leave  
c0106155:	c3                   	ret    

c0106156 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106156:	55                   	push   %ebp
c0106157:	89 e5                	mov    %esp,%ebp
c0106159:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010615c:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106161:	8b 40 14             	mov    0x14(%eax),%eax
c0106164:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106167:	89 54 24 04          	mov    %edx,0x4(%esp)
c010616b:	8b 55 08             	mov    0x8(%ebp),%edx
c010616e:	89 14 24             	mov    %edx,(%esp)
c0106171:	ff d0                	call   *%eax
}
c0106173:	c9                   	leave  
c0106174:	c3                   	ret    

c0106175 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106175:	55                   	push   %ebp
c0106176:	89 e5                	mov    %esp,%ebp
c0106178:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010617b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106182:	e9 5a 01 00 00       	jmp    c01062e1 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106187:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c010618c:	8b 40 18             	mov    0x18(%eax),%eax
c010618f:	8b 55 10             	mov    0x10(%ebp),%edx
c0106192:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106196:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106199:	89 54 24 04          	mov    %edx,0x4(%esp)
c010619d:	8b 55 08             	mov    0x8(%ebp),%edx
c01061a0:	89 14 24             	mov    %edx,(%esp)
c01061a3:	ff d0                	call   *%eax
c01061a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01061a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01061ac:	74 18                	je     c01061c6 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01061ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061b5:	c7 04 24 80 9f 10 c0 	movl   $0xc0109f80,(%esp)
c01061bc:	e8 96 a1 ff ff       	call   c0100357 <cprintf>
c01061c1:	e9 27 01 00 00       	jmp    c01062ed <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01061c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061c9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01061cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01061cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01061d2:	8b 40 0c             	mov    0xc(%eax),%eax
c01061d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01061dc:	00 
c01061dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01061e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061e4:	89 04 24             	mov    %eax,(%esp)
c01061e7:	e8 f0 eb ff ff       	call   c0104ddc <get_pte>
c01061ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01061ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061f2:	8b 00                	mov    (%eax),%eax
c01061f4:	83 e0 01             	and    $0x1,%eax
c01061f7:	85 c0                	test   %eax,%eax
c01061f9:	75 24                	jne    c010621f <swap_out+0xaa>
c01061fb:	c7 44 24 0c ad 9f 10 	movl   $0xc0109fad,0xc(%esp)
c0106202:	c0 
c0106203:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c010620a:	c0 
c010620b:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106212:	00 
c0106213:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010621a:	e8 c2 aa ff ff       	call   c0100ce1 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010621f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106225:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106228:	c1 ea 0c             	shr    $0xc,%edx
c010622b:	83 c2 01             	add    $0x1,%edx
c010622e:	c1 e2 08             	shl    $0x8,%edx
c0106231:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106235:	89 14 24             	mov    %edx,(%esp)
c0106238:	e8 44 1d 00 00       	call   c0107f81 <swapfs_write>
c010623d:	85 c0                	test   %eax,%eax
c010623f:	74 34                	je     c0106275 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106241:	c7 04 24 d7 9f 10 c0 	movl   $0xc0109fd7,(%esp)
c0106248:	e8 0a a1 ff ff       	call   c0100357 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010624d:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c0106252:	8b 40 10             	mov    0x10(%eax),%eax
c0106255:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106258:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010625f:	00 
c0106260:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106264:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106267:	89 54 24 04          	mov    %edx,0x4(%esp)
c010626b:	8b 55 08             	mov    0x8(%ebp),%edx
c010626e:	89 14 24             	mov    %edx,(%esp)
c0106271:	ff d0                	call   *%eax
c0106273:	eb 68                	jmp    c01062dd <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106278:	8b 40 1c             	mov    0x1c(%eax),%eax
c010627b:	c1 e8 0c             	shr    $0xc,%eax
c010627e:	83 c0 01             	add    $0x1,%eax
c0106281:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106285:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106288:	89 44 24 08          	mov    %eax,0x8(%esp)
c010628c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010628f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106293:	c7 04 24 f0 9f 10 c0 	movl   $0xc0109ff0,(%esp)
c010629a:	e8 b8 a0 ff ff       	call   c0100357 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010629f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062a2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01062a5:	c1 e8 0c             	shr    $0xc,%eax
c01062a8:	83 c0 01             	add    $0x1,%eax
c01062ab:	c1 e0 08             	shl    $0x8,%eax
c01062ae:	89 c2                	mov    %eax,%edx
c01062b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062b3:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01062b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062bf:	00 
c01062c0:	89 04 24             	mov    %eax,(%esp)
c01062c3:	e8 a0 e4 ff ff       	call   c0104768 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01062c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01062cb:	8b 40 0c             	mov    0xc(%eax),%eax
c01062ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01062d1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062d5:	89 04 24             	mov    %eax,(%esp)
c01062d8:	e8 f3 ed ff ff       	call   c01050d0 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01062dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01062e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01062e7:	0f 85 9a fe ff ff    	jne    c0106187 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01062ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01062f0:	c9                   	leave  
c01062f1:	c3                   	ret    

c01062f2 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01062f2:	55                   	push   %ebp
c01062f3:	89 e5                	mov    %esp,%ebp
c01062f5:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01062f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062ff:	e8 f9 e3 ff ff       	call   c01046fd <alloc_pages>
c0106304:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010630b:	75 24                	jne    c0106331 <swap_in+0x3f>
c010630d:	c7 44 24 0c 30 a0 10 	movl   $0xc010a030,0xc(%esp)
c0106314:	c0 
c0106315:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c010631c:	c0 
c010631d:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106324:	00 
c0106325:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010632c:	e8 b0 a9 ff ff       	call   c0100ce1 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106331:	8b 45 08             	mov    0x8(%ebp),%eax
c0106334:	8b 40 0c             	mov    0xc(%eax),%eax
c0106337:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010633e:	00 
c010633f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106342:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106346:	89 04 24             	mov    %eax,(%esp)
c0106349:	e8 8e ea ff ff       	call   c0104ddc <get_pte>
c010634e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106351:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106354:	8b 00                	mov    (%eax),%eax
c0106356:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106359:	89 54 24 04          	mov    %edx,0x4(%esp)
c010635d:	89 04 24             	mov    %eax,(%esp)
c0106360:	e8 aa 1b 00 00       	call   c0107f0f <swapfs_read>
c0106365:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106368:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010636c:	74 2a                	je     c0106398 <swap_in+0xa6>
     {
        assert(r!=0);
c010636e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106372:	75 24                	jne    c0106398 <swap_in+0xa6>
c0106374:	c7 44 24 0c 3d a0 10 	movl   $0xc010a03d,0xc(%esp)
c010637b:	c0 
c010637c:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106383:	c0 
c0106384:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c010638b:	00 
c010638c:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106393:	e8 49 a9 ff ff       	call   c0100ce1 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106398:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010639b:	8b 00                	mov    (%eax),%eax
c010639d:	c1 e8 08             	shr    $0x8,%eax
c01063a0:	89 c2                	mov    %eax,%edx
c01063a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063a5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01063ad:	c7 04 24 44 a0 10 c0 	movl   $0xc010a044,(%esp)
c01063b4:	e8 9e 9f ff ff       	call   c0100357 <cprintf>
     *ptr_result=result;
c01063b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01063bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01063bf:	89 10                	mov    %edx,(%eax)
     return 0;
c01063c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01063c6:	c9                   	leave  
c01063c7:	c3                   	ret    

c01063c8 <check_content_set>:



static inline void
check_content_set(void)
{
c01063c8:	55                   	push   %ebp
c01063c9:	89 e5                	mov    %esp,%ebp
c01063cb:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01063ce:	b8 00 10 00 00       	mov    $0x1000,%eax
c01063d3:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01063d6:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c01063db:	83 f8 01             	cmp    $0x1,%eax
c01063de:	74 24                	je     c0106404 <check_content_set+0x3c>
c01063e0:	c7 44 24 0c 82 a0 10 	movl   $0xc010a082,0xc(%esp)
c01063e7:	c0 
c01063e8:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01063ef:	c0 
c01063f0:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01063f7:	00 
c01063f8:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01063ff:	e8 dd a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106404:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106409:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010640c:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106411:	83 f8 01             	cmp    $0x1,%eax
c0106414:	74 24                	je     c010643a <check_content_set+0x72>
c0106416:	c7 44 24 0c 82 a0 10 	movl   $0xc010a082,0xc(%esp)
c010641d:	c0 
c010641e:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106425:	c0 
c0106426:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010642d:	00 
c010642e:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106435:	e8 a7 a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010643a:	b8 00 20 00 00       	mov    $0x2000,%eax
c010643f:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106442:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106447:	83 f8 02             	cmp    $0x2,%eax
c010644a:	74 24                	je     c0106470 <check_content_set+0xa8>
c010644c:	c7 44 24 0c 91 a0 10 	movl   $0xc010a091,0xc(%esp)
c0106453:	c0 
c0106454:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c010645b:	c0 
c010645c:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106463:	00 
c0106464:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010646b:	e8 71 a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106470:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106475:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106478:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010647d:	83 f8 02             	cmp    $0x2,%eax
c0106480:	74 24                	je     c01064a6 <check_content_set+0xde>
c0106482:	c7 44 24 0c 91 a0 10 	movl   $0xc010a091,0xc(%esp)
c0106489:	c0 
c010648a:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106491:	c0 
c0106492:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106499:	00 
c010649a:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01064a1:	e8 3b a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01064a6:	b8 00 30 00 00       	mov    $0x3000,%eax
c01064ab:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01064ae:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c01064b3:	83 f8 03             	cmp    $0x3,%eax
c01064b6:	74 24                	je     c01064dc <check_content_set+0x114>
c01064b8:	c7 44 24 0c a0 a0 10 	movl   $0xc010a0a0,0xc(%esp)
c01064bf:	c0 
c01064c0:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01064c7:	c0 
c01064c8:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01064cf:	00 
c01064d0:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01064d7:	e8 05 a8 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01064dc:	b8 10 30 00 00       	mov    $0x3010,%eax
c01064e1:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01064e4:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c01064e9:	83 f8 03             	cmp    $0x3,%eax
c01064ec:	74 24                	je     c0106512 <check_content_set+0x14a>
c01064ee:	c7 44 24 0c a0 a0 10 	movl   $0xc010a0a0,0xc(%esp)
c01064f5:	c0 
c01064f6:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01064fd:	c0 
c01064fe:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106505:	00 
c0106506:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010650d:	e8 cf a7 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106512:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106517:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010651a:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010651f:	83 f8 04             	cmp    $0x4,%eax
c0106522:	74 24                	je     c0106548 <check_content_set+0x180>
c0106524:	c7 44 24 0c af a0 10 	movl   $0xc010a0af,0xc(%esp)
c010652b:	c0 
c010652c:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106533:	c0 
c0106534:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010653b:	00 
c010653c:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106543:	e8 99 a7 ff ff       	call   c0100ce1 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106548:	b8 10 40 00 00       	mov    $0x4010,%eax
c010654d:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106550:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106555:	83 f8 04             	cmp    $0x4,%eax
c0106558:	74 24                	je     c010657e <check_content_set+0x1b6>
c010655a:	c7 44 24 0c af a0 10 	movl   $0xc010a0af,0xc(%esp)
c0106561:	c0 
c0106562:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106569:	c0 
c010656a:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106571:	00 
c0106572:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106579:	e8 63 a7 ff ff       	call   c0100ce1 <__panic>
}
c010657e:	c9                   	leave  
c010657f:	c3                   	ret    

c0106580 <check_content_access>:

static inline int
check_content_access(void)
{
c0106580:	55                   	push   %ebp
c0106581:	89 e5                	mov    %esp,%ebp
c0106583:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106586:	a1 34 40 12 c0       	mov    0xc0124034,%eax
c010658b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010658e:	ff d0                	call   *%eax
c0106590:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106593:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106596:	c9                   	leave  
c0106597:	c3                   	ret    

c0106598 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106598:	55                   	push   %ebp
c0106599:	89 e5                	mov    %esp,%ebp
c010659b:	53                   	push   %ebx
c010659c:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010659f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01065a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01065ad:	c7 45 e8 40 40 12 c0 	movl   $0xc0124040,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01065b4:	eb 6b                	jmp    c0106621 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01065b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065b9:	83 e8 0c             	sub    $0xc,%eax
c01065bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01065bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065c2:	83 c0 04             	add    $0x4,%eax
c01065c5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01065cc:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01065cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01065d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01065d5:	0f a3 10             	bt     %edx,(%eax)
c01065d8:	19 c0                	sbb    %eax,%eax
c01065da:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01065dd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01065e1:	0f 95 c0             	setne  %al
c01065e4:	0f b6 c0             	movzbl %al,%eax
c01065e7:	85 c0                	test   %eax,%eax
c01065e9:	75 24                	jne    c010660f <check_swap+0x77>
c01065eb:	c7 44 24 0c be a0 10 	movl   $0xc010a0be,0xc(%esp)
c01065f2:	c0 
c01065f3:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01065fa:	c0 
c01065fb:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106602:	00 
c0106603:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010660a:	e8 d2 a6 ff ff       	call   c0100ce1 <__panic>
        count ++, total += p->property;
c010660f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106616:	8b 50 08             	mov    0x8(%eax),%edx
c0106619:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010661c:	01 d0                	add    %edx,%eax
c010661e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106621:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106624:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106627:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010662a:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010662d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106630:	81 7d e8 40 40 12 c0 	cmpl   $0xc0124040,-0x18(%ebp)
c0106637:	0f 85 79 ff ff ff    	jne    c01065b6 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010663d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106640:	e8 55 e1 ff ff       	call   c010479a <nr_free_pages>
c0106645:	39 c3                	cmp    %eax,%ebx
c0106647:	74 24                	je     c010666d <check_swap+0xd5>
c0106649:	c7 44 24 0c ce a0 10 	movl   $0xc010a0ce,0xc(%esp)
c0106650:	c0 
c0106651:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106658:	c0 
c0106659:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106660:	00 
c0106661:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106668:	e8 74 a6 ff ff       	call   c0100ce1 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010666d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106670:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106674:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106677:	89 44 24 04          	mov    %eax,0x4(%esp)
c010667b:	c7 04 24 e8 a0 10 c0 	movl   $0xc010a0e8,(%esp)
c0106682:	e8 d0 9c ff ff       	call   c0100357 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106687:	e8 bd 0a 00 00       	call   c0107149 <mm_create>
c010668c:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c010668f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106693:	75 24                	jne    c01066b9 <check_swap+0x121>
c0106695:	c7 44 24 0c 0e a1 10 	movl   $0xc010a10e,0xc(%esp)
c010669c:	c0 
c010669d:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01066a4:	c0 
c01066a5:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01066ac:	00 
c01066ad:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01066b4:	e8 28 a6 ff ff       	call   c0100ce1 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01066b9:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c01066be:	85 c0                	test   %eax,%eax
c01066c0:	74 24                	je     c01066e6 <check_swap+0x14e>
c01066c2:	c7 44 24 0c 19 a1 10 	movl   $0xc010a119,0xc(%esp)
c01066c9:	c0 
c01066ca:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01066d1:	c0 
c01066d2:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01066d9:	00 
c01066da:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01066e1:	e8 fb a5 ff ff       	call   c0100ce1 <__panic>

     check_mm_struct = mm;
c01066e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066e9:	a3 2c 41 12 c0       	mov    %eax,0xc012412c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01066ee:	8b 15 e0 09 12 c0    	mov    0xc01209e0,%edx
c01066f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066f7:	89 50 0c             	mov    %edx,0xc(%eax)
c01066fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066fd:	8b 40 0c             	mov    0xc(%eax),%eax
c0106700:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106703:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106706:	8b 00                	mov    (%eax),%eax
c0106708:	85 c0                	test   %eax,%eax
c010670a:	74 24                	je     c0106730 <check_swap+0x198>
c010670c:	c7 44 24 0c 31 a1 10 	movl   $0xc010a131,0xc(%esp)
c0106713:	c0 
c0106714:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c010671b:	c0 
c010671c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106723:	00 
c0106724:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010672b:	e8 b1 a5 ff ff       	call   c0100ce1 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106730:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106737:	00 
c0106738:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010673f:	00 
c0106740:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106747:	e8 75 0a 00 00       	call   c01071c1 <vma_create>
c010674c:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c010674f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106753:	75 24                	jne    c0106779 <check_swap+0x1e1>
c0106755:	c7 44 24 0c 3f a1 10 	movl   $0xc010a13f,0xc(%esp)
c010675c:	c0 
c010675d:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106764:	c0 
c0106765:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010676c:	00 
c010676d:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106774:	e8 68 a5 ff ff       	call   c0100ce1 <__panic>

     insert_vma_struct(mm, vma);
c0106779:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010677c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106780:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106783:	89 04 24             	mov    %eax,(%esp)
c0106786:	e8 c6 0b 00 00       	call   c0107351 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010678b:	c7 04 24 4c a1 10 c0 	movl   $0xc010a14c,(%esp)
c0106792:	e8 c0 9b ff ff       	call   c0100357 <cprintf>
     pte_t *temp_ptep=NULL;
c0106797:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010679e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067a1:	8b 40 0c             	mov    0xc(%eax),%eax
c01067a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01067ab:	00 
c01067ac:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01067b3:	00 
c01067b4:	89 04 24             	mov    %eax,(%esp)
c01067b7:	e8 20 e6 ff ff       	call   c0104ddc <get_pte>
c01067bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01067bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01067c3:	75 24                	jne    c01067e9 <check_swap+0x251>
c01067c5:	c7 44 24 0c 80 a1 10 	movl   $0xc010a180,0xc(%esp)
c01067cc:	c0 
c01067cd:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01067d4:	c0 
c01067d5:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01067dc:	00 
c01067dd:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01067e4:	e8 f8 a4 ff ff       	call   c0100ce1 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01067e9:	c7 04 24 94 a1 10 c0 	movl   $0xc010a194,(%esp)
c01067f0:	e8 62 9b ff ff       	call   c0100357 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01067f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01067fc:	e9 a3 00 00 00       	jmp    c01068a4 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106801:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106808:	e8 f0 de ff ff       	call   c01046fd <alloc_pages>
c010680d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106810:	89 04 95 60 40 12 c0 	mov    %eax,-0x3fedbfa0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010681a:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c0106821:	85 c0                	test   %eax,%eax
c0106823:	75 24                	jne    c0106849 <check_swap+0x2b1>
c0106825:	c7 44 24 0c b8 a1 10 	movl   $0xc010a1b8,0xc(%esp)
c010682c:	c0 
c010682d:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106834:	c0 
c0106835:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010683c:	00 
c010683d:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106844:	e8 98 a4 ff ff       	call   c0100ce1 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106849:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010684c:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c0106853:	83 c0 04             	add    $0x4,%eax
c0106856:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010685d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106860:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106863:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106866:	0f a3 10             	bt     %edx,(%eax)
c0106869:	19 c0                	sbb    %eax,%eax
c010686b:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010686e:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106872:	0f 95 c0             	setne  %al
c0106875:	0f b6 c0             	movzbl %al,%eax
c0106878:	85 c0                	test   %eax,%eax
c010687a:	74 24                	je     c01068a0 <check_swap+0x308>
c010687c:	c7 44 24 0c cc a1 10 	movl   $0xc010a1cc,0xc(%esp)
c0106883:	c0 
c0106884:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c010688b:	c0 
c010688c:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106893:	00 
c0106894:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c010689b:	e8 41 a4 ff ff       	call   c0100ce1 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068a0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01068a4:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01068a8:	0f 8e 53 ff ff ff    	jle    c0106801 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01068ae:	a1 40 40 12 c0       	mov    0xc0124040,%eax
c01068b3:	8b 15 44 40 12 c0    	mov    0xc0124044,%edx
c01068b9:	89 45 98             	mov    %eax,-0x68(%ebp)
c01068bc:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01068bf:	c7 45 a8 40 40 12 c0 	movl   $0xc0124040,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01068c6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068c9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01068cc:	89 50 04             	mov    %edx,0x4(%eax)
c01068cf:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068d2:	8b 50 04             	mov    0x4(%eax),%edx
c01068d5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01068d8:	89 10                	mov    %edx,(%eax)
c01068da:	c7 45 a4 40 40 12 c0 	movl   $0xc0124040,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01068e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01068e4:	8b 40 04             	mov    0x4(%eax),%eax
c01068e7:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01068ea:	0f 94 c0             	sete   %al
c01068ed:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01068f0:	85 c0                	test   %eax,%eax
c01068f2:	75 24                	jne    c0106918 <check_swap+0x380>
c01068f4:	c7 44 24 0c e7 a1 10 	movl   $0xc010a1e7,0xc(%esp)
c01068fb:	c0 
c01068fc:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106903:	c0 
c0106904:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010690b:	00 
c010690c:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106913:	e8 c9 a3 ff ff       	call   c0100ce1 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106918:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c010691d:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106920:	c7 05 48 40 12 c0 00 	movl   $0x0,0xc0124048
c0106927:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010692a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106931:	eb 1e                	jmp    c0106951 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106933:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106936:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c010693d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106944:	00 
c0106945:	89 04 24             	mov    %eax,(%esp)
c0106948:	e8 1b de ff ff       	call   c0104768 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010694d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106951:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106955:	7e dc                	jle    c0106933 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106957:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c010695c:	83 f8 04             	cmp    $0x4,%eax
c010695f:	74 24                	je     c0106985 <check_swap+0x3ed>
c0106961:	c7 44 24 0c 00 a2 10 	movl   $0xc010a200,0xc(%esp)
c0106968:	c0 
c0106969:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106970:	c0 
c0106971:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106978:	00 
c0106979:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106980:	e8 5c a3 ff ff       	call   c0100ce1 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106985:	c7 04 24 24 a2 10 c0 	movl   $0xc010a224,(%esp)
c010698c:	e8 c6 99 ff ff       	call   c0100357 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106991:	c7 05 38 40 12 c0 00 	movl   $0x0,0xc0124038
c0106998:	00 00 00 
     
     check_content_set();
c010699b:	e8 28 fa ff ff       	call   c01063c8 <check_content_set>
     assert( nr_free == 0);         
c01069a0:	a1 48 40 12 c0       	mov    0xc0124048,%eax
c01069a5:	85 c0                	test   %eax,%eax
c01069a7:	74 24                	je     c01069cd <check_swap+0x435>
c01069a9:	c7 44 24 0c 4b a2 10 	movl   $0xc010a24b,0xc(%esp)
c01069b0:	c0 
c01069b1:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c01069b8:	c0 
c01069b9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01069c0:	00 
c01069c1:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c01069c8:	e8 14 a3 ff ff       	call   c0100ce1 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01069cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069d4:	eb 26                	jmp    c01069fc <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01069d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069d9:	c7 04 85 80 40 12 c0 	movl   $0xffffffff,-0x3fedbf80(,%eax,4)
c01069e0:	ff ff ff ff 
c01069e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069e7:	8b 14 85 80 40 12 c0 	mov    -0x3fedbf80(,%eax,4),%edx
c01069ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069f1:	89 14 85 c0 40 12 c0 	mov    %edx,-0x3fedbf40(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01069f8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01069fc:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106a00:	7e d4                	jle    c01069d6 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a09:	e9 eb 00 00 00       	jmp    c0106af9 <check_swap+0x561>
         check_ptep[i]=0;
c0106a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a11:	c7 04 85 14 41 12 c0 	movl   $0x0,-0x3fedbeec(,%eax,4)
c0106a18:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106a1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a1f:	83 c0 01             	add    $0x1,%eax
c0106a22:	c1 e0 0c             	shl    $0xc,%eax
c0106a25:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106a2c:	00 
c0106a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a31:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a34:	89 04 24             	mov    %eax,(%esp)
c0106a37:	e8 a0 e3 ff ff       	call   c0104ddc <get_pte>
c0106a3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a3f:	89 04 95 14 41 12 c0 	mov    %eax,-0x3fedbeec(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a49:	8b 04 85 14 41 12 c0 	mov    -0x3fedbeec(,%eax,4),%eax
c0106a50:	85 c0                	test   %eax,%eax
c0106a52:	75 24                	jne    c0106a78 <check_swap+0x4e0>
c0106a54:	c7 44 24 0c 58 a2 10 	movl   $0xc010a258,0xc(%esp)
c0106a5b:	c0 
c0106a5c:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106a63:	c0 
c0106a64:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106a6b:	00 
c0106a6c:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106a73:	e8 69 a2 ff ff       	call   c0100ce1 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a7b:	8b 04 85 14 41 12 c0 	mov    -0x3fedbeec(,%eax,4),%eax
c0106a82:	8b 00                	mov    (%eax),%eax
c0106a84:	89 04 24             	mov    %eax,(%esp)
c0106a87:	e8 9f f5 ff ff       	call   c010602b <pte2page>
c0106a8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a8f:	8b 14 95 60 40 12 c0 	mov    -0x3fedbfa0(,%edx,4),%edx
c0106a96:	39 d0                	cmp    %edx,%eax
c0106a98:	74 24                	je     c0106abe <check_swap+0x526>
c0106a9a:	c7 44 24 0c 70 a2 10 	movl   $0xc010a270,0xc(%esp)
c0106aa1:	c0 
c0106aa2:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106aa9:	c0 
c0106aaa:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106ab1:	00 
c0106ab2:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106ab9:	e8 23 a2 ff ff       	call   c0100ce1 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ac1:	8b 04 85 14 41 12 c0 	mov    -0x3fedbeec(,%eax,4),%eax
c0106ac8:	8b 00                	mov    (%eax),%eax
c0106aca:	83 e0 01             	and    $0x1,%eax
c0106acd:	85 c0                	test   %eax,%eax
c0106acf:	75 24                	jne    c0106af5 <check_swap+0x55d>
c0106ad1:	c7 44 24 0c 98 a2 10 	movl   $0xc010a298,0xc(%esp)
c0106ad8:	c0 
c0106ad9:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106ae0:	c0 
c0106ae1:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106ae8:	00 
c0106ae9:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106af0:	e8 ec a1 ff ff       	call   c0100ce1 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106af5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106af9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106afd:	0f 8e 0b ff ff ff    	jle    c0106a0e <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106b03:	c7 04 24 b4 a2 10 c0 	movl   $0xc010a2b4,(%esp)
c0106b0a:	e8 48 98 ff ff       	call   c0100357 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106b0f:	e8 6c fa ff ff       	call   c0106580 <check_content_access>
c0106b14:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106b17:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106b1b:	74 24                	je     c0106b41 <check_swap+0x5a9>
c0106b1d:	c7 44 24 0c da a2 10 	movl   $0xc010a2da,0xc(%esp)
c0106b24:	c0 
c0106b25:	c7 44 24 08 c2 9f 10 	movl   $0xc0109fc2,0x8(%esp)
c0106b2c:	c0 
c0106b2d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106b34:	00 
c0106b35:	c7 04 24 5c 9f 10 c0 	movl   $0xc0109f5c,(%esp)
c0106b3c:	e8 a0 a1 ff ff       	call   c0100ce1 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b41:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b48:	eb 1e                	jmp    c0106b68 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b4d:	8b 04 85 60 40 12 c0 	mov    -0x3fedbfa0(,%eax,4),%eax
c0106b54:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b5b:	00 
c0106b5c:	89 04 24             	mov    %eax,(%esp)
c0106b5f:	e8 04 dc ff ff       	call   c0104768 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b64:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b68:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b6c:	7e dc                	jle    c0106b4a <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b71:	89 04 24             	mov    %eax,(%esp)
c0106b74:	e8 08 09 00 00       	call   c0107481 <mm_destroy>
         
     nr_free = nr_free_store;
c0106b79:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b7c:	a3 48 40 12 c0       	mov    %eax,0xc0124048
     free_list = free_list_store;
c0106b81:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106b84:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106b87:	a3 40 40 12 c0       	mov    %eax,0xc0124040
c0106b8c:	89 15 44 40 12 c0    	mov    %edx,0xc0124044

     
     le = &free_list;
c0106b92:	c7 45 e8 40 40 12 c0 	movl   $0xc0124040,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b99:	eb 1d                	jmp    c0106bb8 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b9e:	83 e8 0c             	sub    $0xc,%eax
c0106ba1:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106ba4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106bab:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106bae:	8b 40 08             	mov    0x8(%eax),%eax
c0106bb1:	29 c2                	sub    %eax,%edx
c0106bb3:	89 d0                	mov    %edx,%eax
c0106bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106bb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bbb:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106bbe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106bc1:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106bc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bc7:	81 7d e8 40 40 12 c0 	cmpl   $0xc0124040,-0x18(%ebp)
c0106bce:	75 cb                	jne    c0106b9b <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bd3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bde:	c7 04 24 e1 a2 10 c0 	movl   $0xc010a2e1,(%esp)
c0106be5:	e8 6d 97 ff ff       	call   c0100357 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106bea:	c7 04 24 fb a2 10 c0 	movl   $0xc010a2fb,(%esp)
c0106bf1:	e8 61 97 ff ff       	call   c0100357 <cprintf>
}
c0106bf6:	83 c4 74             	add    $0x74,%esp
c0106bf9:	5b                   	pop    %ebx
c0106bfa:	5d                   	pop    %ebp
c0106bfb:	c3                   	ret    

c0106bfc <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106bfc:	55                   	push   %ebp
c0106bfd:	89 e5                	mov    %esp,%ebp
c0106bff:	83 ec 10             	sub    $0x10,%esp
c0106c02:	c7 45 fc 24 41 12 c0 	movl   $0xc0124124,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106c0f:	89 50 04             	mov    %edx,0x4(%eax)
c0106c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c15:	8b 50 04             	mov    0x4(%eax),%edx
c0106c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c1b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c20:	c7 40 14 24 41 12 c0 	movl   $0xc0124124,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106c27:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c2c:	c9                   	leave  
c0106c2d:	c3                   	ret    

c0106c2e <_fifo_map_swappable>:
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */

static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106c2e:	55                   	push   %ebp
c0106c2f:	89 e5                	mov    %esp,%ebp
c0106c31:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c37:	8b 40 14             	mov    0x14(%eax),%eax
c0106c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106c3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c40:	83 c0 14             	add    $0x14,%eax
c0106c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106c46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c4a:	74 06                	je     c0106c52 <_fifo_map_swappable+0x24>
c0106c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c50:	75 24                	jne    c0106c76 <_fifo_map_swappable+0x48>
c0106c52:	c7 44 24 0c 14 a3 10 	movl   $0xc010a314,0xc(%esp)
c0106c59:	c0 
c0106c5a:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106c61:	c0 
c0106c62:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
c0106c69:	00 
c0106c6a:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106c71:	e8 6b a0 ff ff       	call   c0100ce1 <__panic>
c0106c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c79:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c91:	8b 40 04             	mov    0x4(%eax),%eax
c0106c94:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c97:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106c9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c9d:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106ca0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106ca3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106ca6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ca9:	89 10                	mov    %edx,(%eax)
c0106cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106cae:	8b 10                	mov    (%eax),%edx
c0106cb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106cb3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106cb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106cbc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106cbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cc2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106cc5:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);  /////
    return 0;
c0106cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ccc:	c9                   	leave  
c0106ccd:	c3                   	ret    

c0106cce <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106cce:	55                   	push   %ebp
c0106ccf:	89 e5                	mov    %esp,%ebp
c0106cd1:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cd7:	8b 40 14             	mov    0x14(%eax),%eax
c0106cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ce1:	75 24                	jne    c0106d07 <_fifo_swap_out_victim+0x39>
c0106ce3:	c7 44 24 0c 5b a3 10 	movl   $0xc010a35b,0xc(%esp)
c0106cea:	c0 
c0106ceb:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106cf2:	c0 
c0106cf3:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
c0106cfa:	00 
c0106cfb:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106d02:	e8 da 9f ff ff       	call   c0100ce1 <__panic>
     assert(in_tick==0);
c0106d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106d0b:	74 24                	je     c0106d31 <_fifo_swap_out_victim+0x63>
c0106d0d:	c7 44 24 0c 68 a3 10 	movl   $0xc010a368,0xc(%esp)
c0106d14:	c0 
c0106d15:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106d1c:	c0 
c0106d1d:	c7 44 24 04 45 00 00 	movl   $0x45,0x4(%esp)
c0106d24:	00 
c0106d25:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106d2c:	e8 b0 9f ff ff       	call   c0100ce1 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page

     list_entry_t *le = head->prev;
c0106d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d34:	8b 00                	mov    (%eax),%eax
c0106d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(le, pra_page_link);
c0106d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d3c:	83 e8 14             	sub    $0x14,%eax
c0106d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d45:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d4b:	8b 40 04             	mov    0x4(%eax),%eax
c0106d4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106d51:	8b 12                	mov    (%edx),%edx
c0106d53:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106d56:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106d5f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d68:	89 10                	mov    %edx,(%eax)
     list_del(le);
     *ptr_page = page;
c0106d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d70:	89 10                	mov    %edx,(%eax)

     return 0;
c0106d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d77:	c9                   	leave  
c0106d78:	c3                   	ret    

c0106d79 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106d79:	55                   	push   %ebp
c0106d7a:	89 e5                	mov    %esp,%ebp
c0106d7c:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106d7f:	c7 04 24 74 a3 10 c0 	movl   $0xc010a374,(%esp)
c0106d86:	e8 cc 95 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106d8b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106d90:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106d93:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106d98:	83 f8 04             	cmp    $0x4,%eax
c0106d9b:	74 24                	je     c0106dc1 <_fifo_check_swap+0x48>
c0106d9d:	c7 44 24 0c 9a a3 10 	movl   $0xc010a39a,0xc(%esp)
c0106da4:	c0 
c0106da5:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106dac:	c0 
c0106dad:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0106db4:	00 
c0106db5:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106dbc:	e8 20 9f ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106dc1:	c7 04 24 ac a3 10 c0 	movl   $0xc010a3ac,(%esp)
c0106dc8:	e8 8a 95 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106dcd:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106dd2:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106dd5:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106dda:	83 f8 04             	cmp    $0x4,%eax
c0106ddd:	74 24                	je     c0106e03 <_fifo_check_swap+0x8a>
c0106ddf:	c7 44 24 0c 9a a3 10 	movl   $0xc010a39a,0xc(%esp)
c0106de6:	c0 
c0106de7:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106dee:	c0 
c0106def:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0106df6:	00 
c0106df7:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106dfe:	e8 de 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106e03:	c7 04 24 d4 a3 10 c0 	movl   $0xc010a3d4,(%esp)
c0106e0a:	e8 48 95 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106e0f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106e14:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106e17:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106e1c:	83 f8 04             	cmp    $0x4,%eax
c0106e1f:	74 24                	je     c0106e45 <_fifo_check_swap+0xcc>
c0106e21:	c7 44 24 0c 9a a3 10 	movl   $0xc010a39a,0xc(%esp)
c0106e28:	c0 
c0106e29:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106e30:	c0 
c0106e31:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0106e38:	00 
c0106e39:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106e40:	e8 9c 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106e45:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106e4c:	e8 06 95 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106e51:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106e56:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106e59:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106e5e:	83 f8 04             	cmp    $0x4,%eax
c0106e61:	74 24                	je     c0106e87 <_fifo_check_swap+0x10e>
c0106e63:	c7 44 24 0c 9a a3 10 	movl   $0xc010a39a,0xc(%esp)
c0106e6a:	c0 
c0106e6b:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106e72:	c0 
c0106e73:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0106e7a:	00 
c0106e7b:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106e82:	e8 5a 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106e87:	c7 04 24 24 a4 10 c0 	movl   $0xc010a424,(%esp)
c0106e8e:	e8 c4 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106e93:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106e98:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106e9b:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106ea0:	83 f8 05             	cmp    $0x5,%eax
c0106ea3:	74 24                	je     c0106ec9 <_fifo_check_swap+0x150>
c0106ea5:	c7 44 24 0c 4a a4 10 	movl   $0xc010a44a,0xc(%esp)
c0106eac:	c0 
c0106ead:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106eb4:	c0 
c0106eb5:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0106ebc:	00 
c0106ebd:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106ec4:	e8 18 9e ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106ec9:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106ed0:	e8 82 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106ed5:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106eda:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106edd:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106ee2:	83 f8 05             	cmp    $0x5,%eax
c0106ee5:	74 24                	je     c0106f0b <_fifo_check_swap+0x192>
c0106ee7:	c7 44 24 0c 4a a4 10 	movl   $0xc010a44a,0xc(%esp)
c0106eee:	c0 
c0106eef:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106ef6:	c0 
c0106ef7:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0106efe:	00 
c0106eff:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106f06:	e8 d6 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106f0b:	c7 04 24 ac a3 10 c0 	movl   $0xc010a3ac,(%esp)
c0106f12:	e8 40 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106f17:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106f1c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106f1f:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106f24:	83 f8 06             	cmp    $0x6,%eax
c0106f27:	74 24                	je     c0106f4d <_fifo_check_swap+0x1d4>
c0106f29:	c7 44 24 0c 59 a4 10 	movl   $0xc010a459,0xc(%esp)
c0106f30:	c0 
c0106f31:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106f38:	c0 
c0106f39:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0106f40:	00 
c0106f41:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106f48:	e8 94 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106f4d:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c0106f54:	e8 fe 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106f59:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f5e:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106f61:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106f66:	83 f8 07             	cmp    $0x7,%eax
c0106f69:	74 24                	je     c0106f8f <_fifo_check_swap+0x216>
c0106f6b:	c7 44 24 0c 68 a4 10 	movl   $0xc010a468,0xc(%esp)
c0106f72:	c0 
c0106f73:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106f7a:	c0 
c0106f7b:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0106f82:	00 
c0106f83:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106f8a:	e8 52 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106f8f:	c7 04 24 74 a3 10 c0 	movl   $0xc010a374,(%esp)
c0106f96:	e8 bc 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106f9b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106fa0:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106fa3:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106fa8:	83 f8 08             	cmp    $0x8,%eax
c0106fab:	74 24                	je     c0106fd1 <_fifo_check_swap+0x258>
c0106fad:	c7 44 24 0c 77 a4 10 	movl   $0xc010a477,0xc(%esp)
c0106fb4:	c0 
c0106fb5:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106fbc:	c0 
c0106fbd:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0106fc4:	00 
c0106fc5:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0106fcc:	e8 10 9d ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106fd1:	c7 04 24 d4 a3 10 c0 	movl   $0xc010a3d4,(%esp)
c0106fd8:	e8 7a 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106fdd:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106fe2:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106fe5:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0106fea:	83 f8 09             	cmp    $0x9,%eax
c0106fed:	74 24                	je     c0107013 <_fifo_check_swap+0x29a>
c0106fef:	c7 44 24 0c 86 a4 10 	movl   $0xc010a486,0xc(%esp)
c0106ff6:	c0 
c0106ff7:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0106ffe:	c0 
c0106fff:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c0107006:	00 
c0107007:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c010700e:	e8 ce 9c ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107013:	c7 04 24 24 a4 10 c0 	movl   $0xc010a424,(%esp)
c010701a:	e8 38 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010701f:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107024:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0107027:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010702c:	83 f8 0a             	cmp    $0xa,%eax
c010702f:	74 24                	je     c0107055 <_fifo_check_swap+0x2dc>
c0107031:	c7 44 24 0c 95 a4 10 	movl   $0xc010a495,0xc(%esp)
c0107038:	c0 
c0107039:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c0107040:	c0 
c0107041:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c0107048:	00 
c0107049:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c0107050:	e8 8c 9c ff ff       	call   c0100ce1 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107055:	c7 04 24 ac a3 10 c0 	movl   $0xc010a3ac,(%esp)
c010705c:	e8 f6 92 ff ff       	call   c0100357 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c0107061:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107066:	0f b6 00             	movzbl (%eax),%eax
c0107069:	3c 0a                	cmp    $0xa,%al
c010706b:	74 24                	je     c0107091 <_fifo_check_swap+0x318>
c010706d:	c7 44 24 0c a8 a4 10 	movl   $0xc010a4a8,0xc(%esp)
c0107074:	c0 
c0107075:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c010707c:	c0 
c010707d:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0107084:	00 
c0107085:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c010708c:	e8 50 9c ff ff       	call   c0100ce1 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0107091:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107096:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0107099:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c010709e:	83 f8 0b             	cmp    $0xb,%eax
c01070a1:	74 24                	je     c01070c7 <_fifo_check_swap+0x34e>
c01070a3:	c7 44 24 0c c9 a4 10 	movl   $0xc010a4c9,0xc(%esp)
c01070aa:	c0 
c01070ab:	c7 44 24 08 32 a3 10 	movl   $0xc010a332,0x8(%esp)
c01070b2:	c0 
c01070b3:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c01070ba:	00 
c01070bb:	c7 04 24 47 a3 10 c0 	movl   $0xc010a347,(%esp)
c01070c2:	e8 1a 9c ff ff       	call   c0100ce1 <__panic>
    return 0;
c01070c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070cc:	c9                   	leave  
c01070cd:	c3                   	ret    

c01070ce <_fifo_init>:


static int
_fifo_init(void)
{
c01070ce:	55                   	push   %ebp
c01070cf:	89 e5                	mov    %esp,%ebp
    return 0;
c01070d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070d6:	5d                   	pop    %ebp
c01070d7:	c3                   	ret    

c01070d8 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01070d8:	55                   	push   %ebp
c01070d9:	89 e5                	mov    %esp,%ebp
    return 0;
c01070db:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01070e0:	5d                   	pop    %ebp
c01070e1:	c3                   	ret    

c01070e2 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c01070e2:	55                   	push   %ebp
c01070e3:	89 e5                	mov    %esp,%ebp
c01070e5:	b8 00 00 00 00       	mov    $0x0,%eax
c01070ea:	5d                   	pop    %ebp
c01070eb:	c3                   	ret    

c01070ec <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01070ec:	55                   	push   %ebp
c01070ed:	89 e5                	mov    %esp,%ebp
c01070ef:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01070f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01070f5:	c1 e8 0c             	shr    $0xc,%eax
c01070f8:	89 c2                	mov    %eax,%edx
c01070fa:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c01070ff:	39 c2                	cmp    %eax,%edx
c0107101:	72 1c                	jb     c010711f <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107103:	c7 44 24 08 ec a4 10 	movl   $0xc010a4ec,0x8(%esp)
c010710a:	c0 
c010710b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107112:	00 
c0107113:	c7 04 24 0b a5 10 c0 	movl   $0xc010a50b,(%esp)
c010711a:	e8 c2 9b ff ff       	call   c0100ce1 <__panic>
    }
    return &pages[PPN(pa)];
c010711f:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c0107124:	8b 55 08             	mov    0x8(%ebp),%edx
c0107127:	c1 ea 0c             	shr    $0xc,%edx
c010712a:	c1 e2 05             	shl    $0x5,%edx
c010712d:	01 d0                	add    %edx,%eax
}
c010712f:	c9                   	leave  
c0107130:	c3                   	ret    

c0107131 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0107131:	55                   	push   %ebp
c0107132:	89 e5                	mov    %esp,%ebp
c0107134:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0107137:	8b 45 08             	mov    0x8(%ebp),%eax
c010713a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010713f:	89 04 24             	mov    %eax,(%esp)
c0107142:	e8 a5 ff ff ff       	call   c01070ec <pa2page>
}
c0107147:	c9                   	leave  
c0107148:	c3                   	ret    

c0107149 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107149:	55                   	push   %ebp
c010714a:	89 e5                	mov    %esp,%ebp
c010714c:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c010714f:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107156:	e8 51 ed ff ff       	call   c0105eac <kmalloc>
c010715b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c010715e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107162:	74 58                	je     c01071bc <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0107164:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107167:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010716a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010716d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107170:	89 50 04             	mov    %edx,0x4(%eax)
c0107173:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107176:	8b 50 04             	mov    0x4(%eax),%edx
c0107179:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010717c:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010717e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107181:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107188:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010718b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107192:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107195:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010719c:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c01071a1:	85 c0                	test   %eax,%eax
c01071a3:	74 0d                	je     c01071b2 <mm_create+0x69>
c01071a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071a8:	89 04 24             	mov    %eax,(%esp)
c01071ab:	e8 49 ef ff ff       	call   c01060f9 <swap_init_mm>
c01071b0:	eb 0a                	jmp    c01071bc <mm_create+0x73>
        else mm->sm_priv = NULL;
c01071b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071b5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01071bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01071bf:	c9                   	leave  
c01071c0:	c3                   	ret    

c01071c1 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01071c1:	55                   	push   %ebp
c01071c2:	89 e5                	mov    %esp,%ebp
c01071c4:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01071c7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01071ce:	e8 d9 ec ff ff       	call   c0105eac <kmalloc>
c01071d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01071d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071da:	74 1b                	je     c01071f7 <vma_create+0x36>
        vma->vm_start = vm_start;
c01071dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071df:	8b 55 08             	mov    0x8(%ebp),%edx
c01071e2:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01071e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01071eb:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01071ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071f1:	8b 55 10             	mov    0x10(%ebp),%edx
c01071f4:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01071f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01071fa:	c9                   	leave  
c01071fb:	c3                   	ret    

c01071fc <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01071fc:	55                   	push   %ebp
c01071fd:	89 e5                	mov    %esp,%ebp
c01071ff:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107202:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010720d:	0f 84 95 00 00 00    	je     c01072a8 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107213:	8b 45 08             	mov    0x8(%ebp),%eax
c0107216:	8b 40 08             	mov    0x8(%eax),%eax
c0107219:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010721c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107220:	74 16                	je     c0107238 <find_vma+0x3c>
c0107222:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107225:	8b 40 04             	mov    0x4(%eax),%eax
c0107228:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010722b:	77 0b                	ja     c0107238 <find_vma+0x3c>
c010722d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107230:	8b 40 08             	mov    0x8(%eax),%eax
c0107233:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107236:	77 61                	ja     c0107299 <find_vma+0x9d>
                bool found = 0;
c0107238:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c010723f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107242:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107245:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107248:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c010724b:	eb 28                	jmp    c0107275 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c010724d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107250:	83 e8 10             	sub    $0x10,%eax
c0107253:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107256:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107259:	8b 40 04             	mov    0x4(%eax),%eax
c010725c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010725f:	77 14                	ja     c0107275 <find_vma+0x79>
c0107261:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107264:	8b 40 08             	mov    0x8(%eax),%eax
c0107267:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010726a:	76 09                	jbe    c0107275 <find_vma+0x79>
                        found = 1;
c010726c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107273:	eb 17                	jmp    c010728c <find_vma+0x90>
c0107275:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107278:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010727b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010727e:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107281:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107284:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107287:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010728a:	75 c1                	jne    c010724d <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010728c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107290:	75 07                	jne    c0107299 <find_vma+0x9d>
                    vma = NULL;
c0107292:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107299:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010729d:	74 09                	je     c01072a8 <find_vma+0xac>
            mm->mmap_cache = vma;
c010729f:	8b 45 08             	mov    0x8(%ebp),%eax
c01072a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01072a5:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01072a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01072ab:	c9                   	leave  
c01072ac:	c3                   	ret    

c01072ad <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c01072ad:	55                   	push   %ebp
c01072ae:	89 e5                	mov    %esp,%ebp
c01072b0:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c01072b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01072b6:	8b 50 04             	mov    0x4(%eax),%edx
c01072b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01072bc:	8b 40 08             	mov    0x8(%eax),%eax
c01072bf:	39 c2                	cmp    %eax,%edx
c01072c1:	72 24                	jb     c01072e7 <check_vma_overlap+0x3a>
c01072c3:	c7 44 24 0c 19 a5 10 	movl   $0xc010a519,0xc(%esp)
c01072ca:	c0 
c01072cb:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01072d2:	c0 
c01072d3:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01072da:	00 
c01072db:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c01072e2:	e8 fa 99 ff ff       	call   c0100ce1 <__panic>
    assert(prev->vm_end <= next->vm_start);
c01072e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01072ea:	8b 50 08             	mov    0x8(%eax),%edx
c01072ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072f0:	8b 40 04             	mov    0x4(%eax),%eax
c01072f3:	39 c2                	cmp    %eax,%edx
c01072f5:	76 24                	jbe    c010731b <check_vma_overlap+0x6e>
c01072f7:	c7 44 24 0c 5c a5 10 	movl   $0xc010a55c,0xc(%esp)
c01072fe:	c0 
c01072ff:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107306:	c0 
c0107307:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c010730e:	00 
c010730f:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107316:	e8 c6 99 ff ff       	call   c0100ce1 <__panic>
    assert(next->vm_start < next->vm_end);
c010731b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010731e:	8b 50 04             	mov    0x4(%eax),%edx
c0107321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107324:	8b 40 08             	mov    0x8(%eax),%eax
c0107327:	39 c2                	cmp    %eax,%edx
c0107329:	72 24                	jb     c010734f <check_vma_overlap+0xa2>
c010732b:	c7 44 24 0c 7b a5 10 	movl   $0xc010a57b,0xc(%esp)
c0107332:	c0 
c0107333:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c010733a:	c0 
c010733b:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107342:	00 
c0107343:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c010734a:	e8 92 99 ff ff       	call   c0100ce1 <__panic>
}
c010734f:	c9                   	leave  
c0107350:	c3                   	ret    

c0107351 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107351:	55                   	push   %ebp
c0107352:	89 e5                	mov    %esp,%ebp
c0107354:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107357:	8b 45 0c             	mov    0xc(%ebp),%eax
c010735a:	8b 50 04             	mov    0x4(%eax),%edx
c010735d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107360:	8b 40 08             	mov    0x8(%eax),%eax
c0107363:	39 c2                	cmp    %eax,%edx
c0107365:	72 24                	jb     c010738b <insert_vma_struct+0x3a>
c0107367:	c7 44 24 0c 99 a5 10 	movl   $0xc010a599,0xc(%esp)
c010736e:	c0 
c010736f:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107376:	c0 
c0107377:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010737e:	00 
c010737f:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107386:	e8 56 99 ff ff       	call   c0100ce1 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c010738b:	8b 45 08             	mov    0x8(%ebp),%eax
c010738e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107391:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107394:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107397:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010739a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010739d:	eb 21                	jmp    c01073c0 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010739f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073a2:	83 e8 10             	sub    $0x10,%eax
c01073a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01073a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073ab:	8b 50 04             	mov    0x4(%eax),%edx
c01073ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073b1:	8b 40 04             	mov    0x4(%eax),%eax
c01073b4:	39 c2                	cmp    %eax,%edx
c01073b6:	76 02                	jbe    c01073ba <insert_vma_struct+0x69>
                break;
c01073b8:	eb 1d                	jmp    c01073d7 <insert_vma_struct+0x86>
            }
            le_prev = le;
c01073ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01073c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01073c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073c9:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c01073cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01073d5:	75 c8                	jne    c010739f <insert_vma_struct+0x4e>
c01073d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073da:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01073dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073e0:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01073e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01073e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01073ec:	74 15                	je     c0107403 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01073ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073f1:	8d 50 f0             	lea    -0x10(%eax),%edx
c01073f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01073f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073fb:	89 14 24             	mov    %edx,(%esp)
c01073fe:	e8 aa fe ff ff       	call   c01072ad <check_vma_overlap>
    }
    if (le_next != list) {
c0107403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107406:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107409:	74 15                	je     c0107420 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c010740b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010740e:	83 e8 10             	sub    $0x10,%eax
c0107411:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107415:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107418:	89 04 24             	mov    %eax,(%esp)
c010741b:	e8 8d fe ff ff       	call   c01072ad <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107420:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107423:	8b 55 08             	mov    0x8(%ebp),%edx
c0107426:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107428:	8b 45 0c             	mov    0xc(%ebp),%eax
c010742b:	8d 50 10             	lea    0x10(%eax),%edx
c010742e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107431:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107434:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107437:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010743a:	8b 40 04             	mov    0x4(%eax),%eax
c010743d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107440:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107443:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107446:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107449:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010744c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010744f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107452:	89 10                	mov    %edx,(%eax)
c0107454:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107457:	8b 10                	mov    (%eax),%edx
c0107459:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010745c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010745f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107462:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107465:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107468:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010746b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010746e:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107470:	8b 45 08             	mov    0x8(%ebp),%eax
c0107473:	8b 40 10             	mov    0x10(%eax),%eax
c0107476:	8d 50 01             	lea    0x1(%eax),%edx
c0107479:	8b 45 08             	mov    0x8(%ebp),%eax
c010747c:	89 50 10             	mov    %edx,0x10(%eax)
}
c010747f:	c9                   	leave  
c0107480:	c3                   	ret    

c0107481 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107481:	55                   	push   %ebp
c0107482:	89 e5                	mov    %esp,%ebp
c0107484:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107487:	8b 45 08             	mov    0x8(%ebp),%eax
c010748a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c010748d:	eb 3e                	jmp    c01074cd <mm_destroy+0x4c>
c010748f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107492:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107495:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107498:	8b 40 04             	mov    0x4(%eax),%eax
c010749b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010749e:	8b 12                	mov    (%edx),%edx
c01074a0:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01074a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01074a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01074ac:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01074af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01074b5:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c01074b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074ba:	83 e8 10             	sub    $0x10,%eax
c01074bd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01074c4:	00 
c01074c5:	89 04 24             	mov    %eax,(%esp)
c01074c8:	e8 7f ea ff ff       	call   c0105f4c <kfree>
c01074cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01074d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074d6:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01074d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01074dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01074df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01074e2:	75 ab                	jne    c010748f <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01074e4:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01074eb:	00 
c01074ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01074ef:	89 04 24             	mov    %eax,(%esp)
c01074f2:	e8 55 ea ff ff       	call   c0105f4c <kfree>
    mm=NULL;
c01074f7:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01074fe:	c9                   	leave  
c01074ff:	c3                   	ret    

c0107500 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107500:	55                   	push   %ebp
c0107501:	89 e5                	mov    %esp,%ebp
c0107503:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107506:	e8 02 00 00 00       	call   c010750d <check_vmm>
}
c010750b:	c9                   	leave  
c010750c:	c3                   	ret    

c010750d <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010750d:	55                   	push   %ebp
c010750e:	89 e5                	mov    %esp,%ebp
c0107510:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107513:	e8 82 d2 ff ff       	call   c010479a <nr_free_pages>
c0107518:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c010751b:	e8 41 00 00 00       	call   c0107561 <check_vma_struct>
    check_pgfault();
c0107520:	e8 03 05 00 00       	call   c0107a28 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0107525:	e8 70 d2 ff ff       	call   c010479a <nr_free_pages>
c010752a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010752d:	74 24                	je     c0107553 <check_vmm+0x46>
c010752f:	c7 44 24 0c b8 a5 10 	movl   $0xc010a5b8,0xc(%esp)
c0107536:	c0 
c0107537:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c010753e:	c0 
c010753f:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0107546:	00 
c0107547:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c010754e:	e8 8e 97 ff ff       	call   c0100ce1 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0107553:	c7 04 24 df a5 10 c0 	movl   $0xc010a5df,(%esp)
c010755a:	e8 f8 8d ff ff       	call   c0100357 <cprintf>
}
c010755f:	c9                   	leave  
c0107560:	c3                   	ret    

c0107561 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107561:	55                   	push   %ebp
c0107562:	89 e5                	mov    %esp,%ebp
c0107564:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107567:	e8 2e d2 ff ff       	call   c010479a <nr_free_pages>
c010756c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010756f:	e8 d5 fb ff ff       	call   c0107149 <mm_create>
c0107574:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107577:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010757b:	75 24                	jne    c01075a1 <check_vma_struct+0x40>
c010757d:	c7 44 24 0c f7 a5 10 	movl   $0xc010a5f7,0xc(%esp)
c0107584:	c0 
c0107585:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c010758c:	c0 
c010758d:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107594:	00 
c0107595:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c010759c:	e8 40 97 ff ff       	call   c0100ce1 <__panic>

    int step1 = 10, step2 = step1 * 10;
c01075a1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01075a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01075ab:	89 d0                	mov    %edx,%eax
c01075ad:	c1 e0 02             	shl    $0x2,%eax
c01075b0:	01 d0                	add    %edx,%eax
c01075b2:	01 c0                	add    %eax,%eax
c01075b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01075b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01075ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01075bd:	eb 70                	jmp    c010762f <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01075bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075c2:	89 d0                	mov    %edx,%eax
c01075c4:	c1 e0 02             	shl    $0x2,%eax
c01075c7:	01 d0                	add    %edx,%eax
c01075c9:	83 c0 02             	add    $0x2,%eax
c01075cc:	89 c1                	mov    %eax,%ecx
c01075ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075d1:	89 d0                	mov    %edx,%eax
c01075d3:	c1 e0 02             	shl    $0x2,%eax
c01075d6:	01 d0                	add    %edx,%eax
c01075d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01075df:	00 
c01075e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01075e4:	89 04 24             	mov    %eax,(%esp)
c01075e7:	e8 d5 fb ff ff       	call   c01071c1 <vma_create>
c01075ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01075ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01075f3:	75 24                	jne    c0107619 <check_vma_struct+0xb8>
c01075f5:	c7 44 24 0c 02 a6 10 	movl   $0xc010a602,0xc(%esp)
c01075fc:	c0 
c01075fd:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107604:	c0 
c0107605:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010760c:	00 
c010760d:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107614:	e8 c8 96 ff ff       	call   c0100ce1 <__panic>
        insert_vma_struct(mm, vma);
c0107619:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010761c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107620:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107623:	89 04 24             	mov    %eax,(%esp)
c0107626:	e8 26 fd ff ff       	call   c0107351 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c010762b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010762f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107633:	7f 8a                	jg     c01075bf <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107638:	83 c0 01             	add    $0x1,%eax
c010763b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010763e:	eb 70                	jmp    c01076b0 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107640:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107643:	89 d0                	mov    %edx,%eax
c0107645:	c1 e0 02             	shl    $0x2,%eax
c0107648:	01 d0                	add    %edx,%eax
c010764a:	83 c0 02             	add    $0x2,%eax
c010764d:	89 c1                	mov    %eax,%ecx
c010764f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107652:	89 d0                	mov    %edx,%eax
c0107654:	c1 e0 02             	shl    $0x2,%eax
c0107657:	01 d0                	add    %edx,%eax
c0107659:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107660:	00 
c0107661:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107665:	89 04 24             	mov    %eax,(%esp)
c0107668:	e8 54 fb ff ff       	call   c01071c1 <vma_create>
c010766d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107670:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107674:	75 24                	jne    c010769a <check_vma_struct+0x139>
c0107676:	c7 44 24 0c 02 a6 10 	movl   $0xc010a602,0xc(%esp)
c010767d:	c0 
c010767e:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107685:	c0 
c0107686:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c010768d:	00 
c010768e:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107695:	e8 47 96 ff ff       	call   c0100ce1 <__panic>
        insert_vma_struct(mm, vma);
c010769a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010769d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076a4:	89 04 24             	mov    %eax,(%esp)
c01076a7:	e8 a5 fc ff ff       	call   c0107351 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01076ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01076b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01076b6:	7e 88                	jle    c0107640 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01076b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076bb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01076be:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01076c1:	8b 40 04             	mov    0x4(%eax),%eax
c01076c4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01076c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01076ce:	e9 97 00 00 00       	jmp    c010776a <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c01076d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01076d9:	75 24                	jne    c01076ff <check_vma_struct+0x19e>
c01076db:	c7 44 24 0c 0e a6 10 	movl   $0xc010a60e,0xc(%esp)
c01076e2:	c0 
c01076e3:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01076ea:	c0 
c01076eb:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01076f2:	00 
c01076f3:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c01076fa:	e8 e2 95 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01076ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107702:	83 e8 10             	sub    $0x10,%eax
c0107705:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010770b:	8b 48 04             	mov    0x4(%eax),%ecx
c010770e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107711:	89 d0                	mov    %edx,%eax
c0107713:	c1 e0 02             	shl    $0x2,%eax
c0107716:	01 d0                	add    %edx,%eax
c0107718:	39 c1                	cmp    %eax,%ecx
c010771a:	75 17                	jne    c0107733 <check_vma_struct+0x1d2>
c010771c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010771f:	8b 48 08             	mov    0x8(%eax),%ecx
c0107722:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107725:	89 d0                	mov    %edx,%eax
c0107727:	c1 e0 02             	shl    $0x2,%eax
c010772a:	01 d0                	add    %edx,%eax
c010772c:	83 c0 02             	add    $0x2,%eax
c010772f:	39 c1                	cmp    %eax,%ecx
c0107731:	74 24                	je     c0107757 <check_vma_struct+0x1f6>
c0107733:	c7 44 24 0c 28 a6 10 	movl   $0xc010a628,0xc(%esp)
c010773a:	c0 
c010773b:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107742:	c0 
c0107743:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010774a:	00 
c010774b:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107752:	e8 8a 95 ff ff       	call   c0100ce1 <__panic>
c0107757:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010775a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010775d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107760:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107763:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107766:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010776a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010776d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107770:	0f 8e 5d ff ff ff    	jle    c01076d3 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107776:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c010777d:	e9 cd 01 00 00       	jmp    c010794f <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107782:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107785:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107789:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010778c:	89 04 24             	mov    %eax,(%esp)
c010778f:	e8 68 fa ff ff       	call   c01071fc <find_vma>
c0107794:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107797:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010779b:	75 24                	jne    c01077c1 <check_vma_struct+0x260>
c010779d:	c7 44 24 0c 5d a6 10 	movl   $0xc010a65d,0xc(%esp)
c01077a4:	c0 
c01077a5:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01077ac:	c0 
c01077ad:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01077b4:	00 
c01077b5:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c01077bc:	e8 20 95 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01077c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077c4:	83 c0 01             	add    $0x1,%eax
c01077c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01077ce:	89 04 24             	mov    %eax,(%esp)
c01077d1:	e8 26 fa ff ff       	call   c01071fc <find_vma>
c01077d6:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01077d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01077dd:	75 24                	jne    c0107803 <check_vma_struct+0x2a2>
c01077df:	c7 44 24 0c 6a a6 10 	movl   $0xc010a66a,0xc(%esp)
c01077e6:	c0 
c01077e7:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01077ee:	c0 
c01077ef:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01077f6:	00 
c01077f7:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c01077fe:	e8 de 94 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107803:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107806:	83 c0 02             	add    $0x2,%eax
c0107809:	89 44 24 04          	mov    %eax,0x4(%esp)
c010780d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107810:	89 04 24             	mov    %eax,(%esp)
c0107813:	e8 e4 f9 ff ff       	call   c01071fc <find_vma>
c0107818:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c010781b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010781f:	74 24                	je     c0107845 <check_vma_struct+0x2e4>
c0107821:	c7 44 24 0c 77 a6 10 	movl   $0xc010a677,0xc(%esp)
c0107828:	c0 
c0107829:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107830:	c0 
c0107831:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107838:	00 
c0107839:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107840:	e8 9c 94 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107845:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107848:	83 c0 03             	add    $0x3,%eax
c010784b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010784f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107852:	89 04 24             	mov    %eax,(%esp)
c0107855:	e8 a2 f9 ff ff       	call   c01071fc <find_vma>
c010785a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c010785d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107861:	74 24                	je     c0107887 <check_vma_struct+0x326>
c0107863:	c7 44 24 0c 84 a6 10 	movl   $0xc010a684,0xc(%esp)
c010786a:	c0 
c010786b:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107872:	c0 
c0107873:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010787a:	00 
c010787b:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107882:	e8 5a 94 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107887:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010788a:	83 c0 04             	add    $0x4,%eax
c010788d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107891:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107894:	89 04 24             	mov    %eax,(%esp)
c0107897:	e8 60 f9 ff ff       	call   c01071fc <find_vma>
c010789c:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010789f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01078a3:	74 24                	je     c01078c9 <check_vma_struct+0x368>
c01078a5:	c7 44 24 0c 91 a6 10 	movl   $0xc010a691,0xc(%esp)
c01078ac:	c0 
c01078ad:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01078b4:	c0 
c01078b5:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01078bc:	00 
c01078bd:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c01078c4:	e8 18 94 ff ff       	call   c0100ce1 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01078c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01078cc:	8b 50 04             	mov    0x4(%eax),%edx
c01078cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078d2:	39 c2                	cmp    %eax,%edx
c01078d4:	75 10                	jne    c01078e6 <check_vma_struct+0x385>
c01078d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01078d9:	8b 50 08             	mov    0x8(%eax),%edx
c01078dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078df:	83 c0 02             	add    $0x2,%eax
c01078e2:	39 c2                	cmp    %eax,%edx
c01078e4:	74 24                	je     c010790a <check_vma_struct+0x3a9>
c01078e6:	c7 44 24 0c a0 a6 10 	movl   $0xc010a6a0,0xc(%esp)
c01078ed:	c0 
c01078ee:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01078f5:	c0 
c01078f6:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01078fd:	00 
c01078fe:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107905:	e8 d7 93 ff ff       	call   c0100ce1 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010790a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010790d:	8b 50 04             	mov    0x4(%eax),%edx
c0107910:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107913:	39 c2                	cmp    %eax,%edx
c0107915:	75 10                	jne    c0107927 <check_vma_struct+0x3c6>
c0107917:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010791a:	8b 50 08             	mov    0x8(%eax),%edx
c010791d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107920:	83 c0 02             	add    $0x2,%eax
c0107923:	39 c2                	cmp    %eax,%edx
c0107925:	74 24                	je     c010794b <check_vma_struct+0x3ea>
c0107927:	c7 44 24 0c d0 a6 10 	movl   $0xc010a6d0,0xc(%esp)
c010792e:	c0 
c010792f:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107936:	c0 
c0107937:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010793e:	00 
c010793f:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107946:	e8 96 93 ff ff       	call   c0100ce1 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010794b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010794f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107952:	89 d0                	mov    %edx,%eax
c0107954:	c1 e0 02             	shl    $0x2,%eax
c0107957:	01 d0                	add    %edx,%eax
c0107959:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010795c:	0f 8d 20 fe ff ff    	jge    c0107782 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107962:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107969:	eb 70                	jmp    c01079db <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c010796b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010796e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107972:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107975:	89 04 24             	mov    %eax,(%esp)
c0107978:	e8 7f f8 ff ff       	call   c01071fc <find_vma>
c010797d:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107980:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107984:	74 27                	je     c01079ad <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107986:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107989:	8b 50 08             	mov    0x8(%eax),%edx
c010798c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010798f:	8b 40 04             	mov    0x4(%eax),%eax
c0107992:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107996:	89 44 24 08          	mov    %eax,0x8(%esp)
c010799a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010799d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079a1:	c7 04 24 00 a7 10 c0 	movl   $0xc010a700,(%esp)
c01079a8:	e8 aa 89 ff ff       	call   c0100357 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01079ad:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01079b1:	74 24                	je     c01079d7 <check_vma_struct+0x476>
c01079b3:	c7 44 24 0c 25 a7 10 	movl   $0xc010a725,0xc(%esp)
c01079ba:	c0 
c01079bb:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c01079c2:	c0 
c01079c3:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01079ca:	00 
c01079cb:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c01079d2:	e8 0a 93 ff ff       	call   c0100ce1 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01079d7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01079db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01079df:	79 8a                	jns    c010796b <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01079e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079e4:	89 04 24             	mov    %eax,(%esp)
c01079e7:	e8 95 fa ff ff       	call   c0107481 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01079ec:	e8 a9 cd ff ff       	call   c010479a <nr_free_pages>
c01079f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01079f4:	74 24                	je     c0107a1a <check_vma_struct+0x4b9>
c01079f6:	c7 44 24 0c b8 a5 10 	movl   $0xc010a5b8,0xc(%esp)
c01079fd:	c0 
c01079fe:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107a05:	c0 
c0107a06:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107a0d:	00 
c0107a0e:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107a15:	e8 c7 92 ff ff       	call   c0100ce1 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107a1a:	c7 04 24 3c a7 10 c0 	movl   $0xc010a73c,(%esp)
c0107a21:	e8 31 89 ff ff       	call   c0100357 <cprintf>
}
c0107a26:	c9                   	leave  
c0107a27:	c3                   	ret    

c0107a28 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107a28:	55                   	push   %ebp
c0107a29:	89 e5                	mov    %esp,%ebp
c0107a2b:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a2e:	e8 67 cd ff ff       	call   c010479a <nr_free_pages>
c0107a33:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107a36:	e8 0e f7 ff ff       	call   c0107149 <mm_create>
c0107a3b:	a3 2c 41 12 c0       	mov    %eax,0xc012412c
    assert(check_mm_struct != NULL);
c0107a40:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0107a45:	85 c0                	test   %eax,%eax
c0107a47:	75 24                	jne    c0107a6d <check_pgfault+0x45>
c0107a49:	c7 44 24 0c 5b a7 10 	movl   $0xc010a75b,0xc(%esp)
c0107a50:	c0 
c0107a51:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107a58:	c0 
c0107a59:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107a60:	00 
c0107a61:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107a68:	e8 74 92 ff ff       	call   c0100ce1 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107a6d:	a1 2c 41 12 c0       	mov    0xc012412c,%eax
c0107a72:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107a75:	8b 15 e0 09 12 c0    	mov    0xc01209e0,%edx
c0107a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a7e:	89 50 0c             	mov    %edx,0xc(%eax)
c0107a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a84:	8b 40 0c             	mov    0xc(%eax),%eax
c0107a87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a8d:	8b 00                	mov    (%eax),%eax
c0107a8f:	85 c0                	test   %eax,%eax
c0107a91:	74 24                	je     c0107ab7 <check_pgfault+0x8f>
c0107a93:	c7 44 24 0c 73 a7 10 	movl   $0xc010a773,0xc(%esp)
c0107a9a:	c0 
c0107a9b:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107aa2:	c0 
c0107aa3:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107aaa:	00 
c0107aab:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107ab2:	e8 2a 92 ff ff       	call   c0100ce1 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107ab7:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107abe:	00 
c0107abf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107ac6:	00 
c0107ac7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107ace:	e8 ee f6 ff ff       	call   c01071c1 <vma_create>
c0107ad3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107ad6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107ada:	75 24                	jne    c0107b00 <check_pgfault+0xd8>
c0107adc:	c7 44 24 0c 02 a6 10 	movl   $0xc010a602,0xc(%esp)
c0107ae3:	c0 
c0107ae4:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107aeb:	c0 
c0107aec:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107af3:	00 
c0107af4:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107afb:	e8 e1 91 ff ff       	call   c0100ce1 <__panic>

    insert_vma_struct(mm, vma);
c0107b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b0a:	89 04 24             	mov    %eax,(%esp)
c0107b0d:	e8 3f f8 ff ff       	call   c0107351 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107b12:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107b19:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b23:	89 04 24             	mov    %eax,(%esp)
c0107b26:	e8 d1 f6 ff ff       	call   c01071fc <find_vma>
c0107b2b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107b2e:	74 24                	je     c0107b54 <check_pgfault+0x12c>
c0107b30:	c7 44 24 0c 81 a7 10 	movl   $0xc010a781,0xc(%esp)
c0107b37:	c0 
c0107b38:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107b3f:	c0 
c0107b40:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107b47:	00 
c0107b48:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107b4f:	e8 8d 91 ff ff       	call   c0100ce1 <__panic>

    int i, sum = 0;
c0107b54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107b62:	eb 17                	jmp    c0107b7b <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b67:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b6a:	01 d0                	add    %edx,%eax
c0107b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b6f:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b74:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107b77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b7b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107b7f:	7e e3                	jle    c0107b64 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107b81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107b88:	eb 15                	jmp    c0107b9f <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b90:	01 d0                	add    %edx,%eax
c0107b92:	0f b6 00             	movzbl (%eax),%eax
c0107b95:	0f be c0             	movsbl %al,%eax
c0107b98:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b9f:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107ba3:	7e e5                	jle    c0107b8a <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107ba5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ba9:	74 24                	je     c0107bcf <check_pgfault+0x1a7>
c0107bab:	c7 44 24 0c 9b a7 10 	movl   $0xc010a79b,0xc(%esp)
c0107bb2:	c0 
c0107bb3:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107bba:	c0 
c0107bbb:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107bc2:	00 
c0107bc3:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107bca:	e8 12 91 ff ff       	call   c0100ce1 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107bcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bd2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107bd5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107bd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107be4:	89 04 24             	mov    %eax,(%esp)
c0107be7:	e8 e7 d3 ff ff       	call   c0104fd3 <page_remove>
    free_page(pde2page(pgdir[0]));
c0107bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bef:	8b 00                	mov    (%eax),%eax
c0107bf1:	89 04 24             	mov    %eax,(%esp)
c0107bf4:	e8 38 f5 ff ff       	call   c0107131 <pde2page>
c0107bf9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107c00:	00 
c0107c01:	89 04 24             	mov    %eax,(%esp)
c0107c04:	e8 5f cb ff ff       	call   c0104768 <free_pages>
    pgdir[0] = 0;
c0107c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107c12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c1f:	89 04 24             	mov    %eax,(%esp)
c0107c22:	e8 5a f8 ff ff       	call   c0107481 <mm_destroy>
    check_mm_struct = NULL;
c0107c27:	c7 05 2c 41 12 c0 00 	movl   $0x0,0xc012412c
c0107c2e:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107c31:	e8 64 cb ff ff       	call   c010479a <nr_free_pages>
c0107c36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107c39:	74 24                	je     c0107c5f <check_pgfault+0x237>
c0107c3b:	c7 44 24 0c b8 a5 10 	movl   $0xc010a5b8,0xc(%esp)
c0107c42:	c0 
c0107c43:	c7 44 24 08 37 a5 10 	movl   $0xc010a537,0x8(%esp)
c0107c4a:	c0 
c0107c4b:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107c52:	00 
c0107c53:	c7 04 24 4c a5 10 c0 	movl   $0xc010a54c,(%esp)
c0107c5a:	e8 82 90 ff ff       	call   c0100ce1 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107c5f:	c7 04 24 a4 a7 10 c0 	movl   $0xc010a7a4,(%esp)
c0107c66:	e8 ec 86 ff ff       	call   c0100357 <cprintf>
}
c0107c6b:	c9                   	leave  
c0107c6c:	c3                   	ret    

c0107c6d <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107c6d:	55                   	push   %ebp
c0107c6e:	89 e5                	mov    %esp,%ebp
c0107c70:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107c73:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107c7a:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c84:	89 04 24             	mov    %eax,(%esp)
c0107c87:	e8 70 f5 ff ff       	call   c01071fc <find_vma>
c0107c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107c8f:	a1 38 40 12 c0       	mov    0xc0124038,%eax
c0107c94:	83 c0 01             	add    $0x1,%eax
c0107c97:	a3 38 40 12 c0       	mov    %eax,0xc0124038
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107ca0:	74 0b                	je     c0107cad <do_pgfault+0x40>
c0107ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107ca5:	8b 40 04             	mov    0x4(%eax),%eax
c0107ca8:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107cab:	76 18                	jbe    c0107cc5 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107cad:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cb4:	c7 04 24 c0 a7 10 c0 	movl   $0xc010a7c0,(%esp)
c0107cbb:	e8 97 86 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107cc0:	e9 7f 01 00 00       	jmp    c0107e44 <do_pgfault+0x1d7>
    }
    //check the error_code
    switch (error_code & 3) {
c0107cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cc8:	83 e0 03             	and    $0x3,%eax
c0107ccb:	85 c0                	test   %eax,%eax
c0107ccd:	74 36                	je     c0107d05 <do_pgfault+0x98>
c0107ccf:	83 f8 01             	cmp    $0x1,%eax
c0107cd2:	74 20                	je     c0107cf4 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107cd7:	8b 40 0c             	mov    0xc(%eax),%eax
c0107cda:	83 e0 02             	and    $0x2,%eax
c0107cdd:	85 c0                	test   %eax,%eax
c0107cdf:	75 11                	jne    c0107cf2 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107ce1:	c7 04 24 f0 a7 10 c0 	movl   $0xc010a7f0,(%esp)
c0107ce8:	e8 6a 86 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107ced:	e9 52 01 00 00       	jmp    c0107e44 <do_pgfault+0x1d7>
        }
        break;
c0107cf2:	eb 2f                	jmp    c0107d23 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107cf4:	c7 04 24 50 a8 10 c0 	movl   $0xc010a850,(%esp)
c0107cfb:	e8 57 86 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107d00:	e9 3f 01 00 00       	jmp    c0107e44 <do_pgfault+0x1d7>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d08:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d0b:	83 e0 05             	and    $0x5,%eax
c0107d0e:	85 c0                	test   %eax,%eax
c0107d10:	75 11                	jne    c0107d23 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107d12:	c7 04 24 88 a8 10 c0 	movl   $0xc010a888,(%esp)
c0107d19:	e8 39 86 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107d1e:	e9 21 01 00 00       	jmp    c0107e44 <do_pgfault+0x1d7>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107d23:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d2d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d30:	83 e0 02             	and    $0x2,%eax
c0107d33:	85 c0                	test   %eax,%eax
c0107d35:	74 04                	je     c0107d3b <do_pgfault+0xce>
        perm |= PTE_W;
c0107d37:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107d3b:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107d41:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107d49:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107d4c:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107d53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
ptep = get_pte(mm->pgdir, addr, 1); // 根据引发缺页异常的地址 去找到 地址所对应的 PTE 如果找不到 则创建一页表
c0107d5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d5d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d60:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107d67:	00 
c0107d68:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d6b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107d6f:	89 04 24             	mov    %eax,(%esp)
c0107d72:	e8 65 d0 ff ff       	call   c0104ddc <get_pte>
c0107d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) { // PTE 所指向的 物理页表地址 若不存在 则分配一物理页并将逻辑地址和物理地址作映射 (就是让 PTE 指向 物理页帧)
c0107d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d7d:	8b 00                	mov    (%eax),%eax
c0107d7f:	85 c0                	test   %eax,%eax
c0107d81:	75 29                	jne    c0107dac <do_pgfault+0x13f>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0107d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d86:	8b 40 0c             	mov    0xc(%eax),%eax
c0107d89:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107d8c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107d90:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d93:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107d97:	89 04 24             	mov    %eax,(%esp)
c0107d9a:	e8 8e d3 ff ff       	call   c010512d <pgdir_alloc_page>
c0107d9f:	85 c0                	test   %eax,%eax
c0107da1:	0f 85 96 00 00 00    	jne    c0107e3d <do_pgfault+0x1d0>
            goto failed;
c0107da7:	e9 98 00 00 00       	jmp    c0107e44 <do_pgfault+0x1d7>
        }
    } 
    else { // 如果 PTE 存在 说明此时 P 位为 0 该页被换出到外存中 需要将其换入内存
        if(swap_init_ok) { // 是否可以换入页面
c0107dac:	a1 2c 40 12 c0       	mov    0xc012402c,%eax
c0107db1:	85 c0                	test   %eax,%eax
c0107db3:	0f 84 84 00 00 00    	je     c0107e3d <do_pgfault+0x1d0>
            struct Page *page = NULL;
c0107db9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page); // 根据 PTE 找到 换出那页所在的硬盘地址 并将其从外存中换入
c0107dc0:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107dc3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107dc7:	8b 45 10             	mov    0x10(%ebp),%eax
c0107dca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dd1:	89 04 24             	mov    %eax,(%esp)
c0107dd4:	e8 19 e5 ff ff       	call   c01062f2 <swap_in>
c0107dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0107ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107de0:	74 0e                	je     c0107df0 <do_pgfault+0x183>
                cprintf("swap_in in do_pgfault failed\n");
c0107de2:	c7 04 24 eb a8 10 c0 	movl   $0xc010a8eb,(%esp)
c0107de9:	e8 69 85 ff ff       	call   c0100357 <cprintf>
c0107dee:	eb 54                	jmp    c0107e44 <do_pgfault+0x1d7>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm); // 建立虚拟地址和物理地址之间的对应关系(更新 PTE 因为 已经被换入到内存中了)
c0107df0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107df6:	8b 40 0c             	mov    0xc(%eax),%eax
c0107df9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107dfc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107e03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107e07:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e0b:	89 04 24             	mov    %eax,(%esp)
c0107e0e:	e8 04 d2 ff ff       	call   c0105017 <page_insert>
            swap_map_swappable(mm, addr, page, 0); // 使这一页可以置换
c0107e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107e1d:	00 
c0107e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e22:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e29:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e2c:	89 04 24             	mov    %eax,(%esp)
c0107e2f:	e8 f5 e2 ff ff       	call   c0106129 <swap_map_swappable>
            page->pra_vaddr = addr; // 设置 这一页的虚拟地址
c0107e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e37:	8b 55 10             	mov    0x10(%ebp),%edx
c0107e3a:	89 50 1c             	mov    %edx,0x1c(%eax)
        }
    }


   ret = 0;
c0107e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107e47:	c9                   	leave  
c0107e48:	c3                   	ret    

c0107e49 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107e49:	55                   	push   %ebp
c0107e4a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107e4c:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e4f:	a1 54 40 12 c0       	mov    0xc0124054,%eax
c0107e54:	29 c2                	sub    %eax,%edx
c0107e56:	89 d0                	mov    %edx,%eax
c0107e58:	c1 f8 05             	sar    $0x5,%eax
}
c0107e5b:	5d                   	pop    %ebp
c0107e5c:	c3                   	ret    

c0107e5d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107e5d:	55                   	push   %ebp
c0107e5e:	89 e5                	mov    %esp,%ebp
c0107e60:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107e63:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e66:	89 04 24             	mov    %eax,(%esp)
c0107e69:	e8 db ff ff ff       	call   c0107e49 <page2ppn>
c0107e6e:	c1 e0 0c             	shl    $0xc,%eax
}
c0107e71:	c9                   	leave  
c0107e72:	c3                   	ret    

c0107e73 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107e73:	55                   	push   %ebp
c0107e74:	89 e5                	mov    %esp,%ebp
c0107e76:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107e79:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e7c:	89 04 24             	mov    %eax,(%esp)
c0107e7f:	e8 d9 ff ff ff       	call   c0107e5d <page2pa>
c0107e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e8a:	c1 e8 0c             	shr    $0xc,%eax
c0107e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e90:	a1 a0 3f 12 c0       	mov    0xc0123fa0,%eax
c0107e95:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107e98:	72 23                	jb     c0107ebd <page2kva+0x4a>
c0107e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ea1:	c7 44 24 08 0c a9 10 	movl   $0xc010a90c,0x8(%esp)
c0107ea8:	c0 
c0107ea9:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107eb0:	00 
c0107eb1:	c7 04 24 2f a9 10 c0 	movl   $0xc010a92f,(%esp)
c0107eb8:	e8 24 8e ff ff       	call   c0100ce1 <__panic>
c0107ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ec0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107ec5:	c9                   	leave  
c0107ec6:	c3                   	ret    

c0107ec7 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107ec7:	55                   	push   %ebp
c0107ec8:	89 e5                	mov    %esp,%ebp
c0107eca:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107ecd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ed4:	e8 69 9b ff ff       	call   c0101a42 <ide_device_valid>
c0107ed9:	85 c0                	test   %eax,%eax
c0107edb:	75 1c                	jne    c0107ef9 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107edd:	c7 44 24 08 3d a9 10 	movl   $0xc010a93d,0x8(%esp)
c0107ee4:	c0 
c0107ee5:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107eec:	00 
c0107eed:	c7 04 24 57 a9 10 c0 	movl   $0xc010a957,(%esp)
c0107ef4:	e8 e8 8d ff ff       	call   c0100ce1 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107ef9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f00:	e8 7c 9b ff ff       	call   c0101a81 <ide_device_size>
c0107f05:	c1 e8 03             	shr    $0x3,%eax
c0107f08:	a3 fc 40 12 c0       	mov    %eax,0xc01240fc
}
c0107f0d:	c9                   	leave  
c0107f0e:	c3                   	ret    

c0107f0f <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107f0f:	55                   	push   %ebp
c0107f10:	89 e5                	mov    %esp,%ebp
c0107f12:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107f15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f18:	89 04 24             	mov    %eax,(%esp)
c0107f1b:	e8 53 ff ff ff       	call   c0107e73 <page2kva>
c0107f20:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f23:	c1 ea 08             	shr    $0x8,%edx
c0107f26:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f2d:	74 0b                	je     c0107f3a <swapfs_read+0x2b>
c0107f2f:	8b 15 fc 40 12 c0    	mov    0xc01240fc,%edx
c0107f35:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107f38:	72 23                	jb     c0107f5d <swapfs_read+0x4e>
c0107f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f41:	c7 44 24 08 68 a9 10 	movl   $0xc010a968,0x8(%esp)
c0107f48:	c0 
c0107f49:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107f50:	00 
c0107f51:	c7 04 24 57 a9 10 c0 	movl   $0xc010a957,(%esp)
c0107f58:	e8 84 8d ff ff       	call   c0100ce1 <__panic>
c0107f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f60:	c1 e2 03             	shl    $0x3,%edx
c0107f63:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107f6a:	00 
c0107f6b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f6f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f7a:	e8 41 9b ff ff       	call   c0101ac0 <ide_read_secs>
}
c0107f7f:	c9                   	leave  
c0107f80:	c3                   	ret    

c0107f81 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107f81:	55                   	push   %ebp
c0107f82:	89 e5                	mov    %esp,%ebp
c0107f84:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107f87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f8a:	89 04 24             	mov    %eax,(%esp)
c0107f8d:	e8 e1 fe ff ff       	call   c0107e73 <page2kva>
c0107f92:	8b 55 08             	mov    0x8(%ebp),%edx
c0107f95:	c1 ea 08             	shr    $0x8,%edx
c0107f98:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f9f:	74 0b                	je     c0107fac <swapfs_write+0x2b>
c0107fa1:	8b 15 fc 40 12 c0    	mov    0xc01240fc,%edx
c0107fa7:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107faa:	72 23                	jb     c0107fcf <swapfs_write+0x4e>
c0107fac:	8b 45 08             	mov    0x8(%ebp),%eax
c0107faf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107fb3:	c7 44 24 08 68 a9 10 	movl   $0xc010a968,0x8(%esp)
c0107fba:	c0 
c0107fbb:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107fc2:	00 
c0107fc3:	c7 04 24 57 a9 10 c0 	movl   $0xc010a957,(%esp)
c0107fca:	e8 12 8d ff ff       	call   c0100ce1 <__panic>
c0107fcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fd2:	c1 e2 03             	shl    $0x3,%edx
c0107fd5:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107fdc:	00 
c0107fdd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107fe1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fe5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107fec:	e8 11 9d ff ff       	call   c0101d02 <ide_write_secs>
}
c0107ff1:	c9                   	leave  
c0107ff2:	c3                   	ret    

c0107ff3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107ff3:	55                   	push   %ebp
c0107ff4:	89 e5                	mov    %esp,%ebp
c0107ff6:	83 ec 58             	sub    $0x58,%esp
c0107ff9:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ffc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107fff:	8b 45 14             	mov    0x14(%ebp),%eax
c0108002:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108005:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108008:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010800b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010800e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108011:	8b 45 18             	mov    0x18(%ebp),%eax
c0108014:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108017:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010801a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010801d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108020:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108023:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108026:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108029:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010802d:	74 1c                	je     c010804b <printnum+0x58>
c010802f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108032:	ba 00 00 00 00       	mov    $0x0,%edx
c0108037:	f7 75 e4             	divl   -0x1c(%ebp)
c010803a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010803d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108040:	ba 00 00 00 00       	mov    $0x0,%edx
c0108045:	f7 75 e4             	divl   -0x1c(%ebp)
c0108048:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010804b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010804e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108051:	f7 75 e4             	divl   -0x1c(%ebp)
c0108054:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108057:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010805a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010805d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108060:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108063:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108066:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108069:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010806c:	8b 45 18             	mov    0x18(%ebp),%eax
c010806f:	ba 00 00 00 00       	mov    $0x0,%edx
c0108074:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108077:	77 56                	ja     c01080cf <printnum+0xdc>
c0108079:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010807c:	72 05                	jb     c0108083 <printnum+0x90>
c010807e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108081:	77 4c                	ja     c01080cf <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108083:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108086:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108089:	8b 45 20             	mov    0x20(%ebp),%eax
c010808c:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108090:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108094:	8b 45 18             	mov    0x18(%ebp),%eax
c0108097:	89 44 24 10          	mov    %eax,0x10(%esp)
c010809b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010809e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01080a1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01080a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01080b3:	89 04 24             	mov    %eax,(%esp)
c01080b6:	e8 38 ff ff ff       	call   c0107ff3 <printnum>
c01080bb:	eb 1c                	jmp    c01080d9 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01080bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080c4:	8b 45 20             	mov    0x20(%ebp),%eax
c01080c7:	89 04 24             	mov    %eax,(%esp)
c01080ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01080cd:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01080cf:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01080d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01080d7:	7f e4                	jg     c01080bd <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01080d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01080dc:	05 08 aa 10 c0       	add    $0xc010aa08,%eax
c01080e1:	0f b6 00             	movzbl (%eax),%eax
c01080e4:	0f be c0             	movsbl %al,%eax
c01080e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01080ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01080ee:	89 04 24             	mov    %eax,(%esp)
c01080f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f4:	ff d0                	call   *%eax
}
c01080f6:	c9                   	leave  
c01080f7:	c3                   	ret    

c01080f8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01080f8:	55                   	push   %ebp
c01080f9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01080fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01080ff:	7e 14                	jle    c0108115 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108101:	8b 45 08             	mov    0x8(%ebp),%eax
c0108104:	8b 00                	mov    (%eax),%eax
c0108106:	8d 48 08             	lea    0x8(%eax),%ecx
c0108109:	8b 55 08             	mov    0x8(%ebp),%edx
c010810c:	89 0a                	mov    %ecx,(%edx)
c010810e:	8b 50 04             	mov    0x4(%eax),%edx
c0108111:	8b 00                	mov    (%eax),%eax
c0108113:	eb 30                	jmp    c0108145 <getuint+0x4d>
    }
    else if (lflag) {
c0108115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108119:	74 16                	je     c0108131 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010811b:	8b 45 08             	mov    0x8(%ebp),%eax
c010811e:	8b 00                	mov    (%eax),%eax
c0108120:	8d 48 04             	lea    0x4(%eax),%ecx
c0108123:	8b 55 08             	mov    0x8(%ebp),%edx
c0108126:	89 0a                	mov    %ecx,(%edx)
c0108128:	8b 00                	mov    (%eax),%eax
c010812a:	ba 00 00 00 00       	mov    $0x0,%edx
c010812f:	eb 14                	jmp    c0108145 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108131:	8b 45 08             	mov    0x8(%ebp),%eax
c0108134:	8b 00                	mov    (%eax),%eax
c0108136:	8d 48 04             	lea    0x4(%eax),%ecx
c0108139:	8b 55 08             	mov    0x8(%ebp),%edx
c010813c:	89 0a                	mov    %ecx,(%edx)
c010813e:	8b 00                	mov    (%eax),%eax
c0108140:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108145:	5d                   	pop    %ebp
c0108146:	c3                   	ret    

c0108147 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108147:	55                   	push   %ebp
c0108148:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010814a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010814e:	7e 14                	jle    c0108164 <getint+0x1d>
        return va_arg(*ap, long long);
c0108150:	8b 45 08             	mov    0x8(%ebp),%eax
c0108153:	8b 00                	mov    (%eax),%eax
c0108155:	8d 48 08             	lea    0x8(%eax),%ecx
c0108158:	8b 55 08             	mov    0x8(%ebp),%edx
c010815b:	89 0a                	mov    %ecx,(%edx)
c010815d:	8b 50 04             	mov    0x4(%eax),%edx
c0108160:	8b 00                	mov    (%eax),%eax
c0108162:	eb 28                	jmp    c010818c <getint+0x45>
    }
    else if (lflag) {
c0108164:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108168:	74 12                	je     c010817c <getint+0x35>
        return va_arg(*ap, long);
c010816a:	8b 45 08             	mov    0x8(%ebp),%eax
c010816d:	8b 00                	mov    (%eax),%eax
c010816f:	8d 48 04             	lea    0x4(%eax),%ecx
c0108172:	8b 55 08             	mov    0x8(%ebp),%edx
c0108175:	89 0a                	mov    %ecx,(%edx)
c0108177:	8b 00                	mov    (%eax),%eax
c0108179:	99                   	cltd   
c010817a:	eb 10                	jmp    c010818c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010817c:	8b 45 08             	mov    0x8(%ebp),%eax
c010817f:	8b 00                	mov    (%eax),%eax
c0108181:	8d 48 04             	lea    0x4(%eax),%ecx
c0108184:	8b 55 08             	mov    0x8(%ebp),%edx
c0108187:	89 0a                	mov    %ecx,(%edx)
c0108189:	8b 00                	mov    (%eax),%eax
c010818b:	99                   	cltd   
    }
}
c010818c:	5d                   	pop    %ebp
c010818d:	c3                   	ret    

c010818e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010818e:	55                   	push   %ebp
c010818f:	89 e5                	mov    %esp,%ebp
c0108191:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108194:	8d 45 14             	lea    0x14(%ebp),%eax
c0108197:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010819a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010819d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01081a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01081a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01081a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081af:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b2:	89 04 24             	mov    %eax,(%esp)
c01081b5:	e8 02 00 00 00       	call   c01081bc <vprintfmt>
    va_end(ap);
}
c01081ba:	c9                   	leave  
c01081bb:	c3                   	ret    

c01081bc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01081bc:	55                   	push   %ebp
c01081bd:	89 e5                	mov    %esp,%ebp
c01081bf:	56                   	push   %esi
c01081c0:	53                   	push   %ebx
c01081c1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01081c4:	eb 18                	jmp    c01081de <vprintfmt+0x22>
            if (ch == '\0') {
c01081c6:	85 db                	test   %ebx,%ebx
c01081c8:	75 05                	jne    c01081cf <vprintfmt+0x13>
                return;
c01081ca:	e9 d1 03 00 00       	jmp    c01085a0 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01081cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081d6:	89 1c 24             	mov    %ebx,(%esp)
c01081d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01081dc:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01081de:	8b 45 10             	mov    0x10(%ebp),%eax
c01081e1:	8d 50 01             	lea    0x1(%eax),%edx
c01081e4:	89 55 10             	mov    %edx,0x10(%ebp)
c01081e7:	0f b6 00             	movzbl (%eax),%eax
c01081ea:	0f b6 d8             	movzbl %al,%ebx
c01081ed:	83 fb 25             	cmp    $0x25,%ebx
c01081f0:	75 d4                	jne    c01081c6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01081f2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01081f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01081fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108200:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010820a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010820d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108210:	8b 45 10             	mov    0x10(%ebp),%eax
c0108213:	8d 50 01             	lea    0x1(%eax),%edx
c0108216:	89 55 10             	mov    %edx,0x10(%ebp)
c0108219:	0f b6 00             	movzbl (%eax),%eax
c010821c:	0f b6 d8             	movzbl %al,%ebx
c010821f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108222:	83 f8 55             	cmp    $0x55,%eax
c0108225:	0f 87 44 03 00 00    	ja     c010856f <vprintfmt+0x3b3>
c010822b:	8b 04 85 2c aa 10 c0 	mov    -0x3fef55d4(,%eax,4),%eax
c0108232:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108234:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108238:	eb d6                	jmp    c0108210 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010823a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010823e:	eb d0                	jmp    c0108210 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108240:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108247:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010824a:	89 d0                	mov    %edx,%eax
c010824c:	c1 e0 02             	shl    $0x2,%eax
c010824f:	01 d0                	add    %edx,%eax
c0108251:	01 c0                	add    %eax,%eax
c0108253:	01 d8                	add    %ebx,%eax
c0108255:	83 e8 30             	sub    $0x30,%eax
c0108258:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010825b:	8b 45 10             	mov    0x10(%ebp),%eax
c010825e:	0f b6 00             	movzbl (%eax),%eax
c0108261:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108264:	83 fb 2f             	cmp    $0x2f,%ebx
c0108267:	7e 0b                	jle    c0108274 <vprintfmt+0xb8>
c0108269:	83 fb 39             	cmp    $0x39,%ebx
c010826c:	7f 06                	jg     c0108274 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010826e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108272:	eb d3                	jmp    c0108247 <vprintfmt+0x8b>
            goto process_precision;
c0108274:	eb 33                	jmp    c01082a9 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108276:	8b 45 14             	mov    0x14(%ebp),%eax
c0108279:	8d 50 04             	lea    0x4(%eax),%edx
c010827c:	89 55 14             	mov    %edx,0x14(%ebp)
c010827f:	8b 00                	mov    (%eax),%eax
c0108281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108284:	eb 23                	jmp    c01082a9 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108286:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010828a:	79 0c                	jns    c0108298 <vprintfmt+0xdc>
                width = 0;
c010828c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108293:	e9 78 ff ff ff       	jmp    c0108210 <vprintfmt+0x54>
c0108298:	e9 73 ff ff ff       	jmp    c0108210 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010829d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01082a4:	e9 67 ff ff ff       	jmp    c0108210 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01082a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082ad:	79 12                	jns    c01082c1 <vprintfmt+0x105>
                width = precision, precision = -1;
c01082af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01082b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01082bc:	e9 4f ff ff ff       	jmp    c0108210 <vprintfmt+0x54>
c01082c1:	e9 4a ff ff ff       	jmp    c0108210 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01082c6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01082ca:	e9 41 ff ff ff       	jmp    c0108210 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01082cf:	8b 45 14             	mov    0x14(%ebp),%eax
c01082d2:	8d 50 04             	lea    0x4(%eax),%edx
c01082d5:	89 55 14             	mov    %edx,0x14(%ebp)
c01082d8:	8b 00                	mov    (%eax),%eax
c01082da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01082dd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082e1:	89 04 24             	mov    %eax,(%esp)
c01082e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01082e7:	ff d0                	call   *%eax
            break;
c01082e9:	e9 ac 02 00 00       	jmp    c010859a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01082ee:	8b 45 14             	mov    0x14(%ebp),%eax
c01082f1:	8d 50 04             	lea    0x4(%eax),%edx
c01082f4:	89 55 14             	mov    %edx,0x14(%ebp)
c01082f7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01082f9:	85 db                	test   %ebx,%ebx
c01082fb:	79 02                	jns    c01082ff <vprintfmt+0x143>
                err = -err;
c01082fd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01082ff:	83 fb 06             	cmp    $0x6,%ebx
c0108302:	7f 0b                	jg     c010830f <vprintfmt+0x153>
c0108304:	8b 34 9d ec a9 10 c0 	mov    -0x3fef5614(,%ebx,4),%esi
c010830b:	85 f6                	test   %esi,%esi
c010830d:	75 23                	jne    c0108332 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010830f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108313:	c7 44 24 08 19 aa 10 	movl   $0xc010aa19,0x8(%esp)
c010831a:	c0 
c010831b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010831e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108322:	8b 45 08             	mov    0x8(%ebp),%eax
c0108325:	89 04 24             	mov    %eax,(%esp)
c0108328:	e8 61 fe ff ff       	call   c010818e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010832d:	e9 68 02 00 00       	jmp    c010859a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108332:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108336:	c7 44 24 08 22 aa 10 	movl   $0xc010aa22,0x8(%esp)
c010833d:	c0 
c010833e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108341:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108345:	8b 45 08             	mov    0x8(%ebp),%eax
c0108348:	89 04 24             	mov    %eax,(%esp)
c010834b:	e8 3e fe ff ff       	call   c010818e <printfmt>
            }
            break;
c0108350:	e9 45 02 00 00       	jmp    c010859a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108355:	8b 45 14             	mov    0x14(%ebp),%eax
c0108358:	8d 50 04             	lea    0x4(%eax),%edx
c010835b:	89 55 14             	mov    %edx,0x14(%ebp)
c010835e:	8b 30                	mov    (%eax),%esi
c0108360:	85 f6                	test   %esi,%esi
c0108362:	75 05                	jne    c0108369 <vprintfmt+0x1ad>
                p = "(null)";
c0108364:	be 25 aa 10 c0       	mov    $0xc010aa25,%esi
            }
            if (width > 0 && padc != '-') {
c0108369:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010836d:	7e 3e                	jle    c01083ad <vprintfmt+0x1f1>
c010836f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108373:	74 38                	je     c01083ad <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108375:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010837b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010837f:	89 34 24             	mov    %esi,(%esp)
c0108382:	e8 ed 03 00 00       	call   c0108774 <strnlen>
c0108387:	29 c3                	sub    %eax,%ebx
c0108389:	89 d8                	mov    %ebx,%eax
c010838b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010838e:	eb 17                	jmp    c01083a7 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108390:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108394:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010839b:	89 04 24             	mov    %eax,(%esp)
c010839e:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a1:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01083a3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01083a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01083ab:	7f e3                	jg     c0108390 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01083ad:	eb 38                	jmp    c01083e7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01083af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01083b3:	74 1f                	je     c01083d4 <vprintfmt+0x218>
c01083b5:	83 fb 1f             	cmp    $0x1f,%ebx
c01083b8:	7e 05                	jle    c01083bf <vprintfmt+0x203>
c01083ba:	83 fb 7e             	cmp    $0x7e,%ebx
c01083bd:	7e 15                	jle    c01083d4 <vprintfmt+0x218>
                    putch('?', putdat);
c01083bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083c6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01083cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01083d0:	ff d0                	call   *%eax
c01083d2:	eb 0f                	jmp    c01083e3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01083d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083db:	89 1c 24             	mov    %ebx,(%esp)
c01083de:	8b 45 08             	mov    0x8(%ebp),%eax
c01083e1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01083e3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01083e7:	89 f0                	mov    %esi,%eax
c01083e9:	8d 70 01             	lea    0x1(%eax),%esi
c01083ec:	0f b6 00             	movzbl (%eax),%eax
c01083ef:	0f be d8             	movsbl %al,%ebx
c01083f2:	85 db                	test   %ebx,%ebx
c01083f4:	74 10                	je     c0108406 <vprintfmt+0x24a>
c01083f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01083fa:	78 b3                	js     c01083af <vprintfmt+0x1f3>
c01083fc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108400:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108404:	79 a9                	jns    c01083af <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108406:	eb 17                	jmp    c010841f <vprintfmt+0x263>
                putch(' ', putdat);
c0108408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010840b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010840f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108416:	8b 45 08             	mov    0x8(%ebp),%eax
c0108419:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010841b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010841f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108423:	7f e3                	jg     c0108408 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0108425:	e9 70 01 00 00       	jmp    c010859a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010842a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010842d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108431:	8d 45 14             	lea    0x14(%ebp),%eax
c0108434:	89 04 24             	mov    %eax,(%esp)
c0108437:	e8 0b fd ff ff       	call   c0108147 <getint>
c010843c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010843f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108445:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108448:	85 d2                	test   %edx,%edx
c010844a:	79 26                	jns    c0108472 <vprintfmt+0x2b6>
                putch('-', putdat);
c010844c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010844f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108453:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010845a:	8b 45 08             	mov    0x8(%ebp),%eax
c010845d:	ff d0                	call   *%eax
                num = -(long long)num;
c010845f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108462:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108465:	f7 d8                	neg    %eax
c0108467:	83 d2 00             	adc    $0x0,%edx
c010846a:	f7 da                	neg    %edx
c010846c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010846f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108472:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108479:	e9 a8 00 00 00       	jmp    c0108526 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010847e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108481:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108485:	8d 45 14             	lea    0x14(%ebp),%eax
c0108488:	89 04 24             	mov    %eax,(%esp)
c010848b:	e8 68 fc ff ff       	call   c01080f8 <getuint>
c0108490:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108493:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108496:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010849d:	e9 84 00 00 00       	jmp    c0108526 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01084a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084a9:	8d 45 14             	lea    0x14(%ebp),%eax
c01084ac:	89 04 24             	mov    %eax,(%esp)
c01084af:	e8 44 fc ff ff       	call   c01080f8 <getuint>
c01084b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01084ba:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01084c1:	eb 63                	jmp    c0108526 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01084c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084ca:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01084d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01084d4:	ff d0                	call   *%eax
            putch('x', putdat);
c01084d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084dd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01084e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01084e7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01084e9:	8b 45 14             	mov    0x14(%ebp),%eax
c01084ec:	8d 50 04             	lea    0x4(%eax),%edx
c01084ef:	89 55 14             	mov    %edx,0x14(%ebp)
c01084f2:	8b 00                	mov    (%eax),%eax
c01084f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01084fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108505:	eb 1f                	jmp    c0108526 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108507:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010850a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010850e:	8d 45 14             	lea    0x14(%ebp),%eax
c0108511:	89 04 24             	mov    %eax,(%esp)
c0108514:	e8 df fb ff ff       	call   c01080f8 <getuint>
c0108519:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010851c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010851f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108526:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010852a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010852d:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108531:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108534:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108538:	89 44 24 10          	mov    %eax,0x10(%esp)
c010853c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010853f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108542:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108546:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010854a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010854d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108551:	8b 45 08             	mov    0x8(%ebp),%eax
c0108554:	89 04 24             	mov    %eax,(%esp)
c0108557:	e8 97 fa ff ff       	call   c0107ff3 <printnum>
            break;
c010855c:	eb 3c                	jmp    c010859a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010855e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108561:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108565:	89 1c 24             	mov    %ebx,(%esp)
c0108568:	8b 45 08             	mov    0x8(%ebp),%eax
c010856b:	ff d0                	call   *%eax
            break;
c010856d:	eb 2b                	jmp    c010859a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010856f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108572:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108576:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010857d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108580:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108582:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108586:	eb 04                	jmp    c010858c <vprintfmt+0x3d0>
c0108588:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010858c:	8b 45 10             	mov    0x10(%ebp),%eax
c010858f:	83 e8 01             	sub    $0x1,%eax
c0108592:	0f b6 00             	movzbl (%eax),%eax
c0108595:	3c 25                	cmp    $0x25,%al
c0108597:	75 ef                	jne    c0108588 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0108599:	90                   	nop
        }
    }
c010859a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010859b:	e9 3e fc ff ff       	jmp    c01081de <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01085a0:	83 c4 40             	add    $0x40,%esp
c01085a3:	5b                   	pop    %ebx
c01085a4:	5e                   	pop    %esi
c01085a5:	5d                   	pop    %ebp
c01085a6:	c3                   	ret    

c01085a7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01085a7:	55                   	push   %ebp
c01085a8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01085aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085ad:	8b 40 08             	mov    0x8(%eax),%eax
c01085b0:	8d 50 01             	lea    0x1(%eax),%edx
c01085b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085b6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01085b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085bc:	8b 10                	mov    (%eax),%edx
c01085be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085c1:	8b 40 04             	mov    0x4(%eax),%eax
c01085c4:	39 c2                	cmp    %eax,%edx
c01085c6:	73 12                	jae    c01085da <sprintputch+0x33>
        *b->buf ++ = ch;
c01085c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085cb:	8b 00                	mov    (%eax),%eax
c01085cd:	8d 48 01             	lea    0x1(%eax),%ecx
c01085d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01085d3:	89 0a                	mov    %ecx,(%edx)
c01085d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01085d8:	88 10                	mov    %dl,(%eax)
    }
}
c01085da:	5d                   	pop    %ebp
c01085db:	c3                   	ret    

c01085dc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01085dc:	55                   	push   %ebp
c01085dd:	89 e5                	mov    %esp,%ebp
c01085df:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01085e2:	8d 45 14             	lea    0x14(%ebp),%eax
c01085e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01085e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01085f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01085f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108600:	89 04 24             	mov    %eax,(%esp)
c0108603:	e8 08 00 00 00       	call   c0108610 <vsnprintf>
c0108608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010860b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010860e:	c9                   	leave  
c010860f:	c3                   	ret    

c0108610 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108610:	55                   	push   %ebp
c0108611:	89 e5                	mov    %esp,%ebp
c0108613:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108616:	8b 45 08             	mov    0x8(%ebp),%eax
c0108619:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010861c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010861f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108622:	8b 45 08             	mov    0x8(%ebp),%eax
c0108625:	01 d0                	add    %edx,%eax
c0108627:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010862a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108631:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108635:	74 0a                	je     c0108641 <vsnprintf+0x31>
c0108637:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010863a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010863d:	39 c2                	cmp    %eax,%edx
c010863f:	76 07                	jbe    c0108648 <vsnprintf+0x38>
        return -E_INVAL;
c0108641:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108646:	eb 2a                	jmp    c0108672 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108648:	8b 45 14             	mov    0x14(%ebp),%eax
c010864b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010864f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108652:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108656:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108659:	89 44 24 04          	mov    %eax,0x4(%esp)
c010865d:	c7 04 24 a7 85 10 c0 	movl   $0xc01085a7,(%esp)
c0108664:	e8 53 fb ff ff       	call   c01081bc <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0108669:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010866c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010866f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108672:	c9                   	leave  
c0108673:	c3                   	ret    

c0108674 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108674:	55                   	push   %ebp
c0108675:	89 e5                	mov    %esp,%ebp
c0108677:	57                   	push   %edi
c0108678:	56                   	push   %esi
c0108679:	53                   	push   %ebx
c010867a:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010867d:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c0108682:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c0108688:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010868e:	6b f0 05             	imul   $0x5,%eax,%esi
c0108691:	01 f7                	add    %esi,%edi
c0108693:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0108698:	f7 e6                	mul    %esi
c010869a:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010869d:	89 f2                	mov    %esi,%edx
c010869f:	83 c0 0b             	add    $0xb,%eax
c01086a2:	83 d2 00             	adc    $0x0,%edx
c01086a5:	89 c7                	mov    %eax,%edi
c01086a7:	83 e7 ff             	and    $0xffffffff,%edi
c01086aa:	89 f9                	mov    %edi,%ecx
c01086ac:	0f b7 da             	movzwl %dx,%ebx
c01086af:	89 0d 60 0a 12 c0    	mov    %ecx,0xc0120a60
c01086b5:	89 1d 64 0a 12 c0    	mov    %ebx,0xc0120a64
    unsigned long long result = (next >> 12);
c01086bb:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c01086c0:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01086c6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01086ca:	c1 ea 0c             	shr    $0xc,%edx
c01086cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01086d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01086d3:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01086da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01086e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01086e3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01086e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01086ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01086f0:	74 1c                	je     c010870e <rand+0x9a>
c01086f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086f5:	ba 00 00 00 00       	mov    $0x0,%edx
c01086fa:	f7 75 dc             	divl   -0x24(%ebp)
c01086fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108700:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108703:	ba 00 00 00 00       	mov    $0x0,%edx
c0108708:	f7 75 dc             	divl   -0x24(%ebp)
c010870b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010870e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108711:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108714:	f7 75 dc             	divl   -0x24(%ebp)
c0108717:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010871a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010871d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108720:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108723:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108726:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108729:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010872c:	83 c4 24             	add    $0x24,%esp
c010872f:	5b                   	pop    %ebx
c0108730:	5e                   	pop    %esi
c0108731:	5f                   	pop    %edi
c0108732:	5d                   	pop    %ebp
c0108733:	c3                   	ret    

c0108734 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108734:	55                   	push   %ebp
c0108735:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108737:	8b 45 08             	mov    0x8(%ebp),%eax
c010873a:	ba 00 00 00 00       	mov    $0x0,%edx
c010873f:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c0108744:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c010874a:	5d                   	pop    %ebp
c010874b:	c3                   	ret    

c010874c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010874c:	55                   	push   %ebp
c010874d:	89 e5                	mov    %esp,%ebp
c010874f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108759:	eb 04                	jmp    c010875f <strlen+0x13>
        cnt ++;
c010875b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010875f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108762:	8d 50 01             	lea    0x1(%eax),%edx
c0108765:	89 55 08             	mov    %edx,0x8(%ebp)
c0108768:	0f b6 00             	movzbl (%eax),%eax
c010876b:	84 c0                	test   %al,%al
c010876d:	75 ec                	jne    c010875b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010876f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108772:	c9                   	leave  
c0108773:	c3                   	ret    

c0108774 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108774:	55                   	push   %ebp
c0108775:	89 e5                	mov    %esp,%ebp
c0108777:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010877a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108781:	eb 04                	jmp    c0108787 <strnlen+0x13>
        cnt ++;
c0108783:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108787:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010878a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010878d:	73 10                	jae    c010879f <strnlen+0x2b>
c010878f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108792:	8d 50 01             	lea    0x1(%eax),%edx
c0108795:	89 55 08             	mov    %edx,0x8(%ebp)
c0108798:	0f b6 00             	movzbl (%eax),%eax
c010879b:	84 c0                	test   %al,%al
c010879d:	75 e4                	jne    c0108783 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010879f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01087a2:	c9                   	leave  
c01087a3:	c3                   	ret    

c01087a4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01087a4:	55                   	push   %ebp
c01087a5:	89 e5                	mov    %esp,%ebp
c01087a7:	57                   	push   %edi
c01087a8:	56                   	push   %esi
c01087a9:	83 ec 20             	sub    $0x20,%esp
c01087ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01087af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01087b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01087bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087be:	89 d1                	mov    %edx,%ecx
c01087c0:	89 c2                	mov    %eax,%edx
c01087c2:	89 ce                	mov    %ecx,%esi
c01087c4:	89 d7                	mov    %edx,%edi
c01087c6:	ac                   	lods   %ds:(%esi),%al
c01087c7:	aa                   	stos   %al,%es:(%edi)
c01087c8:	84 c0                	test   %al,%al
c01087ca:	75 fa                	jne    c01087c6 <strcpy+0x22>
c01087cc:	89 fa                	mov    %edi,%edx
c01087ce:	89 f1                	mov    %esi,%ecx
c01087d0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01087d3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01087d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01087d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01087dc:	83 c4 20             	add    $0x20,%esp
c01087df:	5e                   	pop    %esi
c01087e0:	5f                   	pop    %edi
c01087e1:	5d                   	pop    %ebp
c01087e2:	c3                   	ret    

c01087e3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01087e3:	55                   	push   %ebp
c01087e4:	89 e5                	mov    %esp,%ebp
c01087e6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01087e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01087ef:	eb 21                	jmp    c0108812 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01087f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087f4:	0f b6 10             	movzbl (%eax),%edx
c01087f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087fa:	88 10                	mov    %dl,(%eax)
c01087fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087ff:	0f b6 00             	movzbl (%eax),%eax
c0108802:	84 c0                	test   %al,%al
c0108804:	74 04                	je     c010880a <strncpy+0x27>
            src ++;
c0108806:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010880a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010880e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108812:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108816:	75 d9                	jne    c01087f1 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0108818:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010881b:	c9                   	leave  
c010881c:	c3                   	ret    

c010881d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010881d:	55                   	push   %ebp
c010881e:	89 e5                	mov    %esp,%ebp
c0108820:	57                   	push   %edi
c0108821:	56                   	push   %esi
c0108822:	83 ec 20             	sub    $0x20,%esp
c0108825:	8b 45 08             	mov    0x8(%ebp),%eax
c0108828:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010882b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010882e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108831:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108834:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108837:	89 d1                	mov    %edx,%ecx
c0108839:	89 c2                	mov    %eax,%edx
c010883b:	89 ce                	mov    %ecx,%esi
c010883d:	89 d7                	mov    %edx,%edi
c010883f:	ac                   	lods   %ds:(%esi),%al
c0108840:	ae                   	scas   %es:(%edi),%al
c0108841:	75 08                	jne    c010884b <strcmp+0x2e>
c0108843:	84 c0                	test   %al,%al
c0108845:	75 f8                	jne    c010883f <strcmp+0x22>
c0108847:	31 c0                	xor    %eax,%eax
c0108849:	eb 04                	jmp    c010884f <strcmp+0x32>
c010884b:	19 c0                	sbb    %eax,%eax
c010884d:	0c 01                	or     $0x1,%al
c010884f:	89 fa                	mov    %edi,%edx
c0108851:	89 f1                	mov    %esi,%ecx
c0108853:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108856:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108859:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010885c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010885f:	83 c4 20             	add    $0x20,%esp
c0108862:	5e                   	pop    %esi
c0108863:	5f                   	pop    %edi
c0108864:	5d                   	pop    %ebp
c0108865:	c3                   	ret    

c0108866 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108866:	55                   	push   %ebp
c0108867:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108869:	eb 0c                	jmp    c0108877 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010886b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010886f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108873:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108877:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010887b:	74 1a                	je     c0108897 <strncmp+0x31>
c010887d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108880:	0f b6 00             	movzbl (%eax),%eax
c0108883:	84 c0                	test   %al,%al
c0108885:	74 10                	je     c0108897 <strncmp+0x31>
c0108887:	8b 45 08             	mov    0x8(%ebp),%eax
c010888a:	0f b6 10             	movzbl (%eax),%edx
c010888d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108890:	0f b6 00             	movzbl (%eax),%eax
c0108893:	38 c2                	cmp    %al,%dl
c0108895:	74 d4                	je     c010886b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108897:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010889b:	74 18                	je     c01088b5 <strncmp+0x4f>
c010889d:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a0:	0f b6 00             	movzbl (%eax),%eax
c01088a3:	0f b6 d0             	movzbl %al,%edx
c01088a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088a9:	0f b6 00             	movzbl (%eax),%eax
c01088ac:	0f b6 c0             	movzbl %al,%eax
c01088af:	29 c2                	sub    %eax,%edx
c01088b1:	89 d0                	mov    %edx,%eax
c01088b3:	eb 05                	jmp    c01088ba <strncmp+0x54>
c01088b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088ba:	5d                   	pop    %ebp
c01088bb:	c3                   	ret    

c01088bc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01088bc:	55                   	push   %ebp
c01088bd:	89 e5                	mov    %esp,%ebp
c01088bf:	83 ec 04             	sub    $0x4,%esp
c01088c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088c5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01088c8:	eb 14                	jmp    c01088de <strchr+0x22>
        if (*s == c) {
c01088ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01088cd:	0f b6 00             	movzbl (%eax),%eax
c01088d0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01088d3:	75 05                	jne    c01088da <strchr+0x1e>
            return (char *)s;
c01088d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d8:	eb 13                	jmp    c01088ed <strchr+0x31>
        }
        s ++;
c01088da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01088de:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e1:	0f b6 00             	movzbl (%eax),%eax
c01088e4:	84 c0                	test   %al,%al
c01088e6:	75 e2                	jne    c01088ca <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01088e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088ed:	c9                   	leave  
c01088ee:	c3                   	ret    

c01088ef <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01088ef:	55                   	push   %ebp
c01088f0:	89 e5                	mov    %esp,%ebp
c01088f2:	83 ec 04             	sub    $0x4,%esp
c01088f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088f8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01088fb:	eb 11                	jmp    c010890e <strfind+0x1f>
        if (*s == c) {
c01088fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108900:	0f b6 00             	movzbl (%eax),%eax
c0108903:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108906:	75 02                	jne    c010890a <strfind+0x1b>
            break;
c0108908:	eb 0e                	jmp    c0108918 <strfind+0x29>
        }
        s ++;
c010890a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010890e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108911:	0f b6 00             	movzbl (%eax),%eax
c0108914:	84 c0                	test   %al,%al
c0108916:	75 e5                	jne    c01088fd <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0108918:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010891b:	c9                   	leave  
c010891c:	c3                   	ret    

c010891d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010891d:	55                   	push   %ebp
c010891e:	89 e5                	mov    %esp,%ebp
c0108920:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010892a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108931:	eb 04                	jmp    c0108937 <strtol+0x1a>
        s ++;
c0108933:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108937:	8b 45 08             	mov    0x8(%ebp),%eax
c010893a:	0f b6 00             	movzbl (%eax),%eax
c010893d:	3c 20                	cmp    $0x20,%al
c010893f:	74 f2                	je     c0108933 <strtol+0x16>
c0108941:	8b 45 08             	mov    0x8(%ebp),%eax
c0108944:	0f b6 00             	movzbl (%eax),%eax
c0108947:	3c 09                	cmp    $0x9,%al
c0108949:	74 e8                	je     c0108933 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010894b:	8b 45 08             	mov    0x8(%ebp),%eax
c010894e:	0f b6 00             	movzbl (%eax),%eax
c0108951:	3c 2b                	cmp    $0x2b,%al
c0108953:	75 06                	jne    c010895b <strtol+0x3e>
        s ++;
c0108955:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108959:	eb 15                	jmp    c0108970 <strtol+0x53>
    }
    else if (*s == '-') {
c010895b:	8b 45 08             	mov    0x8(%ebp),%eax
c010895e:	0f b6 00             	movzbl (%eax),%eax
c0108961:	3c 2d                	cmp    $0x2d,%al
c0108963:	75 0b                	jne    c0108970 <strtol+0x53>
        s ++, neg = 1;
c0108965:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108969:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108970:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108974:	74 06                	je     c010897c <strtol+0x5f>
c0108976:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010897a:	75 24                	jne    c01089a0 <strtol+0x83>
c010897c:	8b 45 08             	mov    0x8(%ebp),%eax
c010897f:	0f b6 00             	movzbl (%eax),%eax
c0108982:	3c 30                	cmp    $0x30,%al
c0108984:	75 1a                	jne    c01089a0 <strtol+0x83>
c0108986:	8b 45 08             	mov    0x8(%ebp),%eax
c0108989:	83 c0 01             	add    $0x1,%eax
c010898c:	0f b6 00             	movzbl (%eax),%eax
c010898f:	3c 78                	cmp    $0x78,%al
c0108991:	75 0d                	jne    c01089a0 <strtol+0x83>
        s += 2, base = 16;
c0108993:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108997:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010899e:	eb 2a                	jmp    c01089ca <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01089a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089a4:	75 17                	jne    c01089bd <strtol+0xa0>
c01089a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01089a9:	0f b6 00             	movzbl (%eax),%eax
c01089ac:	3c 30                	cmp    $0x30,%al
c01089ae:	75 0d                	jne    c01089bd <strtol+0xa0>
        s ++, base = 8;
c01089b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089b4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01089bb:	eb 0d                	jmp    c01089ca <strtol+0xad>
    }
    else if (base == 0) {
c01089bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089c1:	75 07                	jne    c01089ca <strtol+0xad>
        base = 10;
c01089c3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01089ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01089cd:	0f b6 00             	movzbl (%eax),%eax
c01089d0:	3c 2f                	cmp    $0x2f,%al
c01089d2:	7e 1b                	jle    c01089ef <strtol+0xd2>
c01089d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01089d7:	0f b6 00             	movzbl (%eax),%eax
c01089da:	3c 39                	cmp    $0x39,%al
c01089dc:	7f 11                	jg     c01089ef <strtol+0xd2>
            dig = *s - '0';
c01089de:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e1:	0f b6 00             	movzbl (%eax),%eax
c01089e4:	0f be c0             	movsbl %al,%eax
c01089e7:	83 e8 30             	sub    $0x30,%eax
c01089ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089ed:	eb 48                	jmp    c0108a37 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01089ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f2:	0f b6 00             	movzbl (%eax),%eax
c01089f5:	3c 60                	cmp    $0x60,%al
c01089f7:	7e 1b                	jle    c0108a14 <strtol+0xf7>
c01089f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089fc:	0f b6 00             	movzbl (%eax),%eax
c01089ff:	3c 7a                	cmp    $0x7a,%al
c0108a01:	7f 11                	jg     c0108a14 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a06:	0f b6 00             	movzbl (%eax),%eax
c0108a09:	0f be c0             	movsbl %al,%eax
c0108a0c:	83 e8 57             	sub    $0x57,%eax
c0108a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a12:	eb 23                	jmp    c0108a37 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a17:	0f b6 00             	movzbl (%eax),%eax
c0108a1a:	3c 40                	cmp    $0x40,%al
c0108a1c:	7e 3d                	jle    c0108a5b <strtol+0x13e>
c0108a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a21:	0f b6 00             	movzbl (%eax),%eax
c0108a24:	3c 5a                	cmp    $0x5a,%al
c0108a26:	7f 33                	jg     c0108a5b <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a2b:	0f b6 00             	movzbl (%eax),%eax
c0108a2e:	0f be c0             	movsbl %al,%eax
c0108a31:	83 e8 37             	sub    $0x37,%eax
c0108a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a3a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108a3d:	7c 02                	jl     c0108a41 <strtol+0x124>
            break;
c0108a3f:	eb 1a                	jmp    c0108a5b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108a41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a48:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108a4c:	89 c2                	mov    %eax,%edx
c0108a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a51:	01 d0                	add    %edx,%eax
c0108a53:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108a56:	e9 6f ff ff ff       	jmp    c01089ca <strtol+0xad>

    if (endptr) {
c0108a5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108a5f:	74 08                	je     c0108a69 <strtol+0x14c>
        *endptr = (char *) s;
c0108a61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a64:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a67:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108a69:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108a6d:	74 07                	je     c0108a76 <strtol+0x159>
c0108a6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a72:	f7 d8                	neg    %eax
c0108a74:	eb 03                	jmp    c0108a79 <strtol+0x15c>
c0108a76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108a79:	c9                   	leave  
c0108a7a:	c3                   	ret    

c0108a7b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108a7b:	55                   	push   %ebp
c0108a7c:	89 e5                	mov    %esp,%ebp
c0108a7e:	57                   	push   %edi
c0108a7f:	83 ec 24             	sub    $0x24,%esp
c0108a82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a85:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108a88:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108a8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a8f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108a92:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108a95:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108a9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108a9e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108aa2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108aa5:	89 d7                	mov    %edx,%edi
c0108aa7:	f3 aa                	rep stos %al,%es:(%edi)
c0108aa9:	89 fa                	mov    %edi,%edx
c0108aab:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108aae:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108ab1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108ab4:	83 c4 24             	add    $0x24,%esp
c0108ab7:	5f                   	pop    %edi
c0108ab8:	5d                   	pop    %ebp
c0108ab9:	c3                   	ret    

c0108aba <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108aba:	55                   	push   %ebp
c0108abb:	89 e5                	mov    %esp,%ebp
c0108abd:	57                   	push   %edi
c0108abe:	56                   	push   %esi
c0108abf:	53                   	push   %ebx
c0108ac0:	83 ec 30             	sub    $0x30,%esp
c0108ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108acf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ad8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108adb:	73 42                	jae    c0108b1f <memmove+0x65>
c0108add:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ae6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108aec:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108aef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108af2:	c1 e8 02             	shr    $0x2,%eax
c0108af5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108af7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108afd:	89 d7                	mov    %edx,%edi
c0108aff:	89 c6                	mov    %eax,%esi
c0108b01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b03:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108b06:	83 e1 03             	and    $0x3,%ecx
c0108b09:	74 02                	je     c0108b0d <memmove+0x53>
c0108b0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b0d:	89 f0                	mov    %esi,%eax
c0108b0f:	89 fa                	mov    %edi,%edx
c0108b11:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108b14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108b17:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108b1d:	eb 36                	jmp    c0108b55 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b22:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b28:	01 c2                	add    %eax,%edx
c0108b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b2d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b33:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b39:	89 c1                	mov    %eax,%ecx
c0108b3b:	89 d8                	mov    %ebx,%eax
c0108b3d:	89 d6                	mov    %edx,%esi
c0108b3f:	89 c7                	mov    %eax,%edi
c0108b41:	fd                   	std    
c0108b42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b44:	fc                   	cld    
c0108b45:	89 f8                	mov    %edi,%eax
c0108b47:	89 f2                	mov    %esi,%edx
c0108b49:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108b4c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108b4f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108b55:	83 c4 30             	add    $0x30,%esp
c0108b58:	5b                   	pop    %ebx
c0108b59:	5e                   	pop    %esi
c0108b5a:	5f                   	pop    %edi
c0108b5b:	5d                   	pop    %ebp
c0108b5c:	c3                   	ret    

c0108b5d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108b5d:	55                   	push   %ebp
c0108b5e:	89 e5                	mov    %esp,%ebp
c0108b60:	57                   	push   %edi
c0108b61:	56                   	push   %esi
c0108b62:	83 ec 20             	sub    $0x20,%esp
c0108b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b71:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b7a:	c1 e8 02             	shr    $0x2,%eax
c0108b7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b85:	89 d7                	mov    %edx,%edi
c0108b87:	89 c6                	mov    %eax,%esi
c0108b89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b8b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108b8e:	83 e1 03             	and    $0x3,%ecx
c0108b91:	74 02                	je     c0108b95 <memcpy+0x38>
c0108b93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b95:	89 f0                	mov    %esi,%eax
c0108b97:	89 fa                	mov    %edi,%edx
c0108b99:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108b9c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108b9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108ba5:	83 c4 20             	add    $0x20,%esp
c0108ba8:	5e                   	pop    %esi
c0108ba9:	5f                   	pop    %edi
c0108baa:	5d                   	pop    %ebp
c0108bab:	c3                   	ret    

c0108bac <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108bac:	55                   	push   %ebp
c0108bad:	89 e5                	mov    %esp,%ebp
c0108baf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bbb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108bbe:	eb 30                	jmp    c0108bf0 <memcmp+0x44>
        if (*s1 != *s2) {
c0108bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108bc3:	0f b6 10             	movzbl (%eax),%edx
c0108bc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108bc9:	0f b6 00             	movzbl (%eax),%eax
c0108bcc:	38 c2                	cmp    %al,%dl
c0108bce:	74 18                	je     c0108be8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108bd3:	0f b6 00             	movzbl (%eax),%eax
c0108bd6:	0f b6 d0             	movzbl %al,%edx
c0108bd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108bdc:	0f b6 00             	movzbl (%eax),%eax
c0108bdf:	0f b6 c0             	movzbl %al,%eax
c0108be2:	29 c2                	sub    %eax,%edx
c0108be4:	89 d0                	mov    %edx,%eax
c0108be6:	eb 1a                	jmp    c0108c02 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108be8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108bec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108bf0:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bf3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108bf6:	89 55 10             	mov    %edx,0x10(%ebp)
c0108bf9:	85 c0                	test   %eax,%eax
c0108bfb:	75 c3                	jne    c0108bc0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c02:	c9                   	leave  
c0108c03:	c3                   	ret    
