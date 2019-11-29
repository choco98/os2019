
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
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
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 5e 9b 00 00       	call   c0109bb4 <memset>

    cons_init();                // init the console
c0100056:	e8 88 15 00 00       	call   c01015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 40 9d 10 c0 	movl   $0xc0109d40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 5c 9d 10 c0 	movl   $0xc0109d5c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 8b 53 00 00       	call   c010540f <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 38 1f 00 00       	call   c0101fc1 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 8a 20 00 00       	call   c0102118 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 db 79 00 00       	call   c0107a6e <vmm_init>
    proc_init();                // init process table
c0100093:	e8 12 8d 00 00       	call   c0108daa <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 77 16 00 00       	call   c0101714 <ide_init>
    swap_init();                // init swap
c010009d:	e8 f9 65 00 00       	call   c010669b <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 f2 0c 00 00       	call   c0100d99 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 83 1e 00 00       	call   c0101f2f <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 b8 8e 00 00       	call   c0108f69 <cpu_idle>

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
c01000ce:	e8 f8 0b 00 00       	call   c0100ccb <mon_backtrace>
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
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 61 9d 10 c0 	movl   $0xc0109d61,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 6f 9d 10 c0 	movl   $0xc0109d6f,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 7d 9d 10 c0 	movl   $0xc0109d7d,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 8b 9d 10 c0 	movl   $0xc0109d8b,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 99 9d 10 c0 	movl   $0xc0109d99,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
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
c010021c:	c7 04 24 a8 9d 10 c0 	movl   $0xc0109da8,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 c8 9d 10 c0 	movl   $0xc0109dc8,(%esp)
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
c010025d:	c7 04 24 e7 9d 10 c0 	movl   $0xc0109de7,(%esp)
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
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
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
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
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
c010030c:	e8 fe 12 00 00       	call   c010160f <cons_putc>
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
c0100349:	e8 a7 8f 00 00       	call   c01092f5 <vprintfmt>
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
c0100385:	e8 85 12 00 00       	call   c010160f <cons_putc>
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
c01003e1:	e8 65 12 00 00       	call   c010164b <cons_getc>
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
c0100553:	c7 00 ec 9d 10 c0    	movl   $0xc0109dec,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 ec 9d 10 c0 	movl   $0xc0109dec,0x8(%eax)
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

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 10 bf 10 c0 	movl   $0xc010bf10,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 cc d1 11 c0 	movl   $0xc011d1cc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec cd d1 11 c0 	movl   $0xc011d1cd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 cc 19 12 c0 	movl   $0xc01219cc,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 25 93 00 00       	call   c0109a28 <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 f6 9d 10 c0 	movl   $0xc0109df6,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 0f 9e 10 c0 	movl   $0xc0109e0f,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 3d 9d 10 	movl   $0xc0109d3d,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 27 9e 10 c0 	movl   $0xc0109e27,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 3f 9e 10 c0 	movl   $0xc0109e3f,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 57 9e 10 c0 	movl   $0xc0109e57,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 70 9e 10 c0 	movl   $0xc0109e70,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 9a 9e 10 c0 	movl   $0xc0109e9a,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 b6 9e 10 c0 	movl   $0xc0109eb6,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	e9 88 00 00 00       	jmp    c0100a7e <print_stackframe+0xad>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 c8 9e 10 c0 	movl   $0xc0109ec8,(%esp)
c0100a0b:	e8 43 f9 ff ff       	call   c0100353 <cprintf>
		uint32_t *args = (uint32_t *)ebp + 2;
c0100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a13:	83 c0 08             	add    $0x8,%eax
c0100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(b = 0; b < 4; b ++){
c0100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a20:	eb 25                	jmp    c0100a47 <print_stackframe+0x76>
			cprintf("0x%08x ", args[b]);
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2f:	01 d0                	add    %edx,%eax
c0100a31:	8b 00                	mov    (%eax),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	c7 04 24 e4 9e 10 c0 	movl   $0xc0109ee4,(%esp)
c0100a3e:	e8 10 f9 ff ff       	call   c0100353 <cprintf>

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		uint32_t *args = (uint32_t *)ebp + 2;
		for(b = 0; b < 4; b ++){
c0100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4b:	7e d5                	jle    c0100a22 <print_stackframe+0x51>
			cprintf("0x%08x ", args[b]);
		}
		cprintf("\n");
c0100a4d:	c7 04 24 ec 9e 10 c0 	movl   $0xc0109eec,(%esp)
c0100a54:	e8 fa f8 ff ff       	call   c0100353 <cprintf>
		print_debuginfo(eip - 1);
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	83 e8 01             	sub    $0x1,%eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 b6 fe ff ff       	call   c010091d <print_debuginfo>
		eip = ((uint32_t *)ebp)[1];
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t *)ebp)[0];
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();

	int k, b;
	for(k = 0; ebp != 0 && k < STACKFRAME_DEPTH; k++){
c0100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a82:	74 0a                	je     c0100a8e <print_stackframe+0xbd>
c0100a84:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a88:	0f 8e 68 ff ff ff    	jle    c01009f6 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = ((uint32_t *)ebp)[1];
		ebp = ((uint32_t *)ebp)[0];
	}
}
c0100a8e:	c9                   	leave  
c0100a8f:	c3                   	ret    

c0100a90 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a90:	55                   	push   %ebp
c0100a91:	89 e5                	mov    %esp,%ebp
c0100a93:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	eb 0c                	jmp    c0100aab <parse+0x1b>
            *buf ++ = '\0';
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa8:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aae:	0f b6 00             	movzbl (%eax),%eax
c0100ab1:	84 c0                	test   %al,%al
c0100ab3:	74 1d                	je     c0100ad2 <parse+0x42>
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	0f b6 00             	movzbl (%eax),%eax
c0100abb:	0f be c0             	movsbl %al,%eax
c0100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac2:	c7 04 24 70 9f 10 c0 	movl   $0xc0109f70,(%esp)
c0100ac9:	e8 27 8f 00 00       	call   c01099f5 <strchr>
c0100ace:	85 c0                	test   %eax,%eax
c0100ad0:	75 cd                	jne    c0100a9f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad5:	0f b6 00             	movzbl (%eax),%eax
c0100ad8:	84 c0                	test   %al,%al
c0100ada:	75 02                	jne    c0100ade <parse+0x4e>
            break;
c0100adc:	eb 67                	jmp    c0100b45 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae2:	75 14                	jne    c0100af8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aeb:	00 
c0100aec:	c7 04 24 75 9f 10 c0 	movl   $0xc0109f75,(%esp)
c0100af3:	e8 5b f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	8d 50 01             	lea    0x1(%eax),%edx
c0100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0b:	01 c2                	add    %eax,%edx
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	eb 04                	jmp    c0100b18 <parse+0x88>
            buf ++;
c0100b14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1b:	0f b6 00             	movzbl (%eax),%eax
c0100b1e:	84 c0                	test   %al,%al
c0100b20:	74 1d                	je     c0100b3f <parse+0xaf>
c0100b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b25:	0f b6 00             	movzbl (%eax),%eax
c0100b28:	0f be c0             	movsbl %al,%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 70 9f 10 c0 	movl   $0xc0109f70,(%esp)
c0100b36:	e8 ba 8e 00 00       	call   c01099f5 <strchr>
c0100b3b:	85 c0                	test   %eax,%eax
c0100b3d:	74 d5                	je     c0100b14 <parse+0x84>
            buf ++;
        }
    }
c0100b3f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b40:	e9 66 ff ff ff       	jmp    c0100aab <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b48:	c9                   	leave  
c0100b49:	c3                   	ret    

c0100b4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4a:	55                   	push   %ebp
c0100b4b:	89 e5                	mov    %esp,%ebp
c0100b4d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b50:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5a:	89 04 24             	mov    %eax,(%esp)
c0100b5d:	e8 2e ff ff ff       	call   c0100a90 <parse>
c0100b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b69:	75 0a                	jne    c0100b75 <runcmd+0x2b>
        return 0;
c0100b6b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b70:	e9 85 00 00 00       	jmp    c0100bfa <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7c:	eb 5c                	jmp    c0100bda <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b84:	89 d0                	mov    %edx,%eax
c0100b86:	01 c0                	add    %eax,%eax
c0100b88:	01 d0                	add    %edx,%eax
c0100b8a:	c1 e0 02             	shl    $0x2,%eax
c0100b8d:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100b92:	8b 00                	mov    (%eax),%eax
c0100b94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b98:	89 04 24             	mov    %eax,(%esp)
c0100b9b:	e8 b6 8d 00 00       	call   c0109956 <strcmp>
c0100ba0:	85 c0                	test   %eax,%eax
c0100ba2:	75 32                	jne    c0100bd6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba7:	89 d0                	mov    %edx,%eax
c0100ba9:	01 c0                	add    %eax,%eax
c0100bab:	01 d0                	add    %edx,%eax
c0100bad:	c1 e0 02             	shl    $0x2,%eax
c0100bb0:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bb5:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbb:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc8:	83 c2 04             	add    $0x4,%edx
c0100bcb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bcf:	89 0c 24             	mov    %ecx,(%esp)
c0100bd2:	ff d0                	call   *%eax
c0100bd4:	eb 24                	jmp    c0100bfa <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdd:	83 f8 02             	cmp    $0x2,%eax
c0100be0:	76 9c                	jbe    c0100b7e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be9:	c7 04 24 93 9f 10 c0 	movl   $0xc0109f93,(%esp)
c0100bf0:	e8 5e f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfa:	c9                   	leave  
c0100bfb:	c3                   	ret    

c0100bfc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfc:	55                   	push   %ebp
c0100bfd:	89 e5                	mov    %esp,%ebp
c0100bff:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c02:	c7 04 24 ac 9f 10 c0 	movl   $0xc0109fac,(%esp)
c0100c09:	e8 45 f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0e:	c7 04 24 d4 9f 10 c0 	movl   $0xc0109fd4,(%esp)
c0100c15:	e8 39 f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1e:	74 0b                	je     c0100c2b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c23:	89 04 24             	mov    %eax,(%esp)
c0100c26:	e8 a4 16 00 00       	call   c01022cf <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2b:	c7 04 24 f9 9f 10 c0 	movl   $0xc0109ff9,(%esp)
c0100c32:	e8 13 f6 ff ff       	call   c010024a <readline>
c0100c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3e:	74 18                	je     c0100c58 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4a:	89 04 24             	mov    %eax,(%esp)
c0100c4d:	e8 f8 fe ff ff       	call   c0100b4a <runcmd>
c0100c52:	85 c0                	test   %eax,%eax
c0100c54:	79 02                	jns    c0100c58 <kmonitor+0x5c>
                break;
c0100c56:	eb 02                	jmp    c0100c5a <kmonitor+0x5e>
            }
        }
    }
c0100c58:	eb d1                	jmp    c0100c2b <kmonitor+0x2f>
}
c0100c5a:	c9                   	leave  
c0100c5b:	c3                   	ret    

c0100c5c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5c:	55                   	push   %ebp
c0100c5d:	89 e5                	mov    %esp,%ebp
c0100c5f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c69:	eb 3f                	jmp    c0100caa <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c7c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c82:	89 d0                	mov    %edx,%eax
c0100c84:	01 c0                	add    %eax,%eax
c0100c86:	01 d0                	add    %edx,%eax
c0100c88:	c1 e0 02             	shl    $0x2,%eax
c0100c8b:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c90:	8b 00                	mov    (%eax),%eax
c0100c92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9a:	c7 04 24 fd 9f 10 c0 	movl   $0xc0109ffd,(%esp)
c0100ca1:	e8 ad f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cad:	83 f8 02             	cmp    $0x2,%eax
c0100cb0:	76 b9                	jbe    c0100c6b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb7:	c9                   	leave  
c0100cb8:	c3                   	ret    

c0100cb9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb9:	55                   	push   %ebp
c0100cba:	89 e5                	mov    %esp,%ebp
c0100cbc:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbf:	e8 c3 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc9:	c9                   	leave  
c0100cca:	c3                   	ret    

c0100ccb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccb:	55                   	push   %ebp
c0100ccc:	89 e5                	mov    %esp,%ebp
c0100cce:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd1:	e8 fb fc ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdb:	c9                   	leave  
c0100cdc:	c3                   	ret    

c0100cdd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdd:	55                   	push   %ebp
c0100cde:	89 e5                	mov    %esp,%ebp
c0100ce0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce3:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100ce8:	85 c0                	test   %eax,%eax
c0100cea:	74 02                	je     c0100cee <__panic+0x11>
        goto panic_dead;
c0100cec:	eb 48                	jmp    c0100d36 <__panic+0x59>
    }
    is_panic = 1;
c0100cee:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100cf5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d01:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0c:	c7 04 24 06 a0 10 c0 	movl   $0xc010a006,(%esp)
c0100d13:	e8 3b f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d22:	89 04 24             	mov    %eax,(%esp)
c0100d25:	e8 f6 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d2a:	c7 04 24 22 a0 10 c0 	movl   $0xc010a022,(%esp)
c0100d31:	e8 1d f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d36:	e8 fa 11 00 00       	call   c0101f35 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d42:	e8 b5 fe ff ff       	call   c0100bfc <kmonitor>
    }
c0100d47:	eb f2                	jmp    c0100d3b <__panic+0x5e>

c0100d49 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d49:	55                   	push   %ebp
c0100d4a:	89 e5                	mov    %esp,%ebp
c0100d4c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d63:	c7 04 24 24 a0 10 c0 	movl   $0xc010a024,(%esp)
c0100d6a:	e8 e4 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d79:	89 04 24             	mov    %eax,(%esp)
c0100d7c:	e8 9f f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d81:	c7 04 24 22 a0 10 c0 	movl   $0xc010a022,(%esp)
c0100d88:	e8 c6 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100d8d:	c9                   	leave  
c0100d8e:	c3                   	ret    

c0100d8f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8f:	55                   	push   %ebp
c0100d90:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d92:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100d97:	5d                   	pop    %ebp
c0100d98:	c3                   	ret    

c0100d99 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d99:	55                   	push   %ebp
c0100d9a:	89 e5                	mov    %esp,%ebp
c0100d9c:	83 ec 28             	sub    $0x28,%esp
c0100d9f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da5:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dad:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db1:	ee                   	out    %al,(%dx)
c0100db2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
c0100dc5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dcb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dcf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd8:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100ddf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de2:	c7 04 24 42 a0 10 c0 	movl   $0xc010a042,(%esp)
c0100de9:	e8 65 f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df5:	e8 99 11 00 00       	call   c0101f93 <pic_enable>
}
c0100dfa:	c9                   	leave  
c0100dfb:	c3                   	ret    

c0100dfc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfc:	55                   	push   %ebp
c0100dfd:	89 e5                	mov    %esp,%ebp
c0100dff:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e02:	9c                   	pushf  
c0100e03:	58                   	pop    %eax
c0100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0a:	25 00 02 00 00       	and    $0x200,%eax
c0100e0f:	85 c0                	test   %eax,%eax
c0100e11:	74 0c                	je     c0100e1f <__intr_save+0x23>
        intr_disable();
c0100e13:	e8 1d 11 00 00       	call   c0101f35 <intr_disable>
        return 1;
c0100e18:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1d:	eb 05                	jmp    c0100e24 <__intr_save+0x28>
    }
    return 0;
c0100e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e24:	c9                   	leave  
c0100e25:	c3                   	ret    

c0100e26 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e26:	55                   	push   %ebp
c0100e27:	89 e5                	mov    %esp,%ebp
c0100e29:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e30:	74 05                	je     c0100e37 <__intr_restore+0x11>
        intr_enable();
c0100e32:	e8 f8 10 00 00       	call   c0101f2f <intr_enable>
    }
}
c0100e37:	c9                   	leave  
c0100e38:	c3                   	ret    

c0100e39 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e39:	55                   	push   %ebp
c0100e3a:	89 e5                	mov    %esp,%ebp
c0100e3c:	83 ec 10             	sub    $0x10,%esp
c0100e3f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e45:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e79:	89 c2                	mov    %eax,%edx
c0100e7b:	ec                   	in     (%dx),%al
c0100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7f:	c9                   	leave  
c0100e80:	c3                   	ret    

c0100e81 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e81:	55                   	push   %ebp
c0100e82:	89 e5                	mov    %esp,%ebp
c0100e84:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e87:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea3:	0f b7 00             	movzwl (%eax),%eax
c0100ea6:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eaa:	74 12                	je     c0100ebe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eac:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb3:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100eba:	b4 03 
c0100ebc:	eb 13                	jmp    c0100ed1 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec8:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100ecf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed1:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ed8:	0f b7 c0             	movzwl %ax,%eax
c0100edb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100edf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eeb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eec:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ef3:	83 c0 01             	add    $0x1,%eax
c0100ef6:	0f b7 c0             	movzwl %ax,%eax
c0100ef9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f01:	89 c2                	mov    %eax,%edx
c0100f03:	ec                   	in     (%dx),%al
c0100f04:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f07:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0b:	0f b6 c0             	movzbl %al,%eax
c0100f0e:	c1 e0 08             	shl    $0x8,%eax
c0100f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f14:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f1b:	0f b7 c0             	movzwl %ax,%eax
c0100f1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f22:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f36:	83 c0 01             	add    $0x1,%eax
c0100f39:	0f b7 c0             	movzwl %ax,%eax
c0100f3c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f40:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f44:	89 c2                	mov    %eax,%edx
c0100f46:	ec                   	in     (%dx),%al
c0100f47:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4e:	0f b6 c0             	movzbl %al,%eax
c0100f51:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f57:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5f:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f65:	c9                   	leave  
c0100f66:	c3                   	ret    

c0100f67 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f67:	55                   	push   %ebp
c0100f68:	89 e5                	mov    %esp,%ebp
c0100f6a:	83 ec 48             	sub    $0x48,%esp
c0100f6d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f73:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7f:	ee                   	out    %al,(%dx)
c0100f80:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f86:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f92:	ee                   	out    %al,(%dx)
c0100f93:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f99:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa5:	ee                   	out    %al,(%dx)
c0100fa6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fac:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
c0100fb9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
c0100fcc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fda:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
c0100fdf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fed:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
c0100ff2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffc:	89 c2                	mov    %eax,%edx
c0100ffe:	ec                   	in     (%dx),%al
c0100fff:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101002:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101006:	3c ff                	cmp    $0xff,%al
c0101008:	0f 95 c0             	setne  %al
c010100b:	0f b6 c0             	movzbl %al,%eax
c010100e:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c0101013:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101019:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101023:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101029:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102d:	89 c2                	mov    %eax,%edx
c010102f:	ec                   	in     (%dx),%al
c0101030:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101033:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101038:	85 c0                	test   %eax,%eax
c010103a:	74 0c                	je     c0101048 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101043:	e8 4b 0f 00 00       	call   c0101f93 <pic_enable>
    }
}
c0101048:	c9                   	leave  
c0101049:	c3                   	ret    

c010104a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104a:	55                   	push   %ebp
c010104b:	89 e5                	mov    %esp,%ebp
c010104d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101057:	eb 09                	jmp    c0101062 <lpt_putc_sub+0x18>
        delay();
c0101059:	e8 db fd ff ff       	call   c0100e39 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101062:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101068:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106c:	89 c2                	mov    %eax,%edx
c010106e:	ec                   	in     (%dx),%al
c010106f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101072:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101076:	84 c0                	test   %al,%al
c0101078:	78 09                	js     c0101083 <lpt_putc_sub+0x39>
c010107a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101081:	7e d6                	jle    c0101059 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101083:	8b 45 08             	mov    0x8(%ebp),%eax
c0101086:	0f b6 c0             	movzbl %al,%eax
c0101089:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101096:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109a:	ee                   	out    %al,(%dx)
c010109b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ad:	ee                   	out    %al,(%dx)
c01010ae:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c1:	c9                   	leave  
c01010c2:	c3                   	ret    

c01010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c3:	55                   	push   %ebp
c01010c4:	89 e5                	mov    %esp,%ebp
c01010c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cd:	74 0d                	je     c01010dc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d2:	89 04 24             	mov    %eax,(%esp)
c01010d5:	e8 70 ff ff ff       	call   c010104a <lpt_putc_sub>
c01010da:	eb 24                	jmp    c0101100 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e3:	e8 62 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ef:	e8 56 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fb:	e8 4a ff ff ff       	call   c010104a <lpt_putc_sub>
    }
}
c0101100:	c9                   	leave  
c0101101:	c3                   	ret    

c0101102 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101102:	55                   	push   %ebp
c0101103:	89 e5                	mov    %esp,%ebp
c0101105:	53                   	push   %ebx
c0101106:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	b0 00                	mov    $0x0,%al
c010110e:	85 c0                	test   %eax,%eax
c0101110:	75 07                	jne    c0101119 <cga_putc+0x17>
        c |= 0x0700;
c0101112:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101119:	8b 45 08             	mov    0x8(%ebp),%eax
c010111c:	0f b6 c0             	movzbl %al,%eax
c010111f:	83 f8 0a             	cmp    $0xa,%eax
c0101122:	74 4c                	je     c0101170 <cga_putc+0x6e>
c0101124:	83 f8 0d             	cmp    $0xd,%eax
c0101127:	74 57                	je     c0101180 <cga_putc+0x7e>
c0101129:	83 f8 08             	cmp    $0x8,%eax
c010112c:	0f 85 88 00 00 00    	jne    c01011ba <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101132:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101139:	66 85 c0             	test   %ax,%ax
c010113c:	74 30                	je     c010116e <cga_putc+0x6c>
            crt_pos --;
c010113e:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101145:	83 e8 01             	sub    $0x1,%eax
c0101148:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114e:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101153:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c010115a:	0f b7 d2             	movzwl %dx,%edx
c010115d:	01 d2                	add    %edx,%edx
c010115f:	01 c2                	add    %eax,%edx
c0101161:	8b 45 08             	mov    0x8(%ebp),%eax
c0101164:	b0 00                	mov    $0x0,%al
c0101166:	83 c8 20             	or     $0x20,%eax
c0101169:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116c:	eb 72                	jmp    c01011e0 <cga_putc+0xde>
c010116e:	eb 70                	jmp    c01011e0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101170:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101177:	83 c0 50             	add    $0x50,%eax
c010117a:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101180:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c0101187:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c010118e:	0f b7 c1             	movzwl %cx,%eax
c0101191:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101197:	c1 e8 10             	shr    $0x10,%eax
c010119a:	89 c2                	mov    %eax,%edx
c010119c:	66 c1 ea 06          	shr    $0x6,%dx
c01011a0:	89 d0                	mov    %edx,%eax
c01011a2:	c1 e0 02             	shl    $0x2,%eax
c01011a5:	01 d0                	add    %edx,%eax
c01011a7:	c1 e0 04             	shl    $0x4,%eax
c01011aa:	29 c1                	sub    %eax,%ecx
c01011ac:	89 ca                	mov    %ecx,%edx
c01011ae:	89 d8                	mov    %ebx,%eax
c01011b0:	29 d0                	sub    %edx,%eax
c01011b2:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011b8:	eb 26                	jmp    c01011e0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ba:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011c0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011c7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ca:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011d1:	0f b7 c0             	movzwl %ax,%eax
c01011d4:	01 c0                	add    %eax,%eax
c01011d6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011dc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011df:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011eb:	76 5b                	jbe    c0101248 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ed:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011f2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f8:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011fd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101204:	00 
c0101205:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101209:	89 04 24             	mov    %eax,(%esp)
c010120c:	e8 e2 89 00 00       	call   c0109bf3 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101211:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101218:	eb 15                	jmp    c010122f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010121a:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101222:	01 d2                	add    %edx,%edx
c0101224:	01 d0                	add    %edx,%eax
c0101226:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101236:	7e e2                	jle    c010121a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101238:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010123f:	83 e8 50             	sub    $0x50,%eax
c0101242:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101248:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101256:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010125a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101262:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101263:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010126a:	66 c1 e8 08          	shr    $0x8,%ax
c010126e:	0f b6 c0             	movzbl %al,%eax
c0101271:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101278:	83 c2 01             	add    $0x1,%edx
c010127b:	0f b7 d2             	movzwl %dx,%edx
c010127e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101282:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128e:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0101295:	0f b7 c0             	movzwl %ax,%eax
c0101298:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a9:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012b0:	0f b6 c0             	movzbl %al,%eax
c01012b3:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012ba:	83 c2 01             	add    $0x1,%edx
c01012bd:	0f b7 d2             	movzwl %dx,%edx
c01012c0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012cf:	ee                   	out    %al,(%dx)
}
c01012d0:	83 c4 34             	add    $0x34,%esp
c01012d3:	5b                   	pop    %ebx
c01012d4:	5d                   	pop    %ebp
c01012d5:	c3                   	ret    

c01012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d6:	55                   	push   %ebp
c01012d7:	89 e5                	mov    %esp,%ebp
c01012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e3:	eb 09                	jmp    c01012ee <serial_putc_sub+0x18>
        delay();
c01012e5:	e8 4f fb ff ff       	call   c0100e39 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 20             	and    $0x20,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 09                	jne    c0101315 <serial_putc_sub+0x3f>
c010130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101313:	7e d0                	jle    c01012e5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101315:	8b 45 08             	mov    0x8(%ebp),%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101321:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132c:	ee                   	out    %al,(%dx)
}
c010132d:	c9                   	leave  
c010132e:	c3                   	ret    

c010132f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132f:	55                   	push   %ebp
c0101330:	89 e5                	mov    %esp,%ebp
c0101332:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101335:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101339:	74 0d                	je     c0101348 <serial_putc+0x19>
        serial_putc_sub(c);
c010133b:	8b 45 08             	mov    0x8(%ebp),%eax
c010133e:	89 04 24             	mov    %eax,(%esp)
c0101341:	e8 90 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101346:	eb 24                	jmp    c010136c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134f:	e8 82 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135b:	e8 76 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101360:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101367:	e8 6a ff ff ff       	call   c01012d6 <serial_putc_sub>
    }
}
c010136c:	c9                   	leave  
c010136d:	c3                   	ret    

c010136e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136e:	55                   	push   %ebp
c010136f:	89 e5                	mov    %esp,%ebp
c0101371:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101374:	eb 33                	jmp    c01013a9 <cons_intr+0x3b>
        if (c != 0) {
c0101376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137a:	74 2d                	je     c01013a9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137c:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101381:	8d 50 01             	lea    0x1(%eax),%edx
c0101384:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c010138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138d:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101393:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101398:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139d:	75 0a                	jne    c01013a9 <cons_intr+0x3b>
                cons.wpos = 0;
c010139f:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013a6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ac:	ff d0                	call   *%eax
c01013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b5:	75 bf                	jne    c0101376 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b7:	c9                   	leave  
c01013b8:	c3                   	ret    

c01013b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b9:	55                   	push   %ebp
c01013ba:	89 e5                	mov    %esp,%ebp
c01013bc:	83 ec 10             	sub    $0x10,%esp
c01013bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c9:	89 c2                	mov    %eax,%edx
c01013cb:	ec                   	in     (%dx),%al
c01013cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d3:	0f b6 c0             	movzbl %al,%eax
c01013d6:	83 e0 01             	and    $0x1,%eax
c01013d9:	85 c0                	test   %eax,%eax
c01013db:	75 07                	jne    c01013e4 <serial_proc_data+0x2b>
        return -1;
c01013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e2:	eb 2a                	jmp    c010140e <serial_proc_data+0x55>
c01013e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ee:	89 c2                	mov    %eax,%edx
c01013f0:	ec                   	in     (%dx),%al
c01013f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f8:	0f b6 c0             	movzbl %al,%eax
c01013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101402:	75 07                	jne    c010140b <serial_proc_data+0x52>
        c = '\b';
c0101404:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101416:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c010141b:	85 c0                	test   %eax,%eax
c010141d:	74 0c                	je     c010142b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141f:	c7 04 24 b9 13 10 c0 	movl   $0xc01013b9,(%esp)
c0101426:	e8 43 ff ff ff       	call   c010136e <cons_intr>
    }
}
c010142b:	c9                   	leave  
c010142c:	c3                   	ret    

c010142d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142d:	55                   	push   %ebp
c010142e:	89 e5                	mov    %esp,%ebp
c0101430:	83 ec 38             	sub    $0x38,%esp
c0101433:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101439:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143d:	89 c2                	mov    %eax,%edx
c010143f:	ec                   	in     (%dx),%al
c0101440:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101447:	0f b6 c0             	movzbl %al,%eax
c010144a:	83 e0 01             	and    $0x1,%eax
c010144d:	85 c0                	test   %eax,%eax
c010144f:	75 0a                	jne    c010145b <kbd_proc_data+0x2e>
        return -1;
c0101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101456:	e9 59 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
c010145b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101461:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101465:	89 c2                	mov    %eax,%edx
c0101467:	ec                   	in     (%dx),%al
c0101468:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101472:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101476:	75 17                	jne    c010148f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101478:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010147d:	83 c8 40             	or     $0x40,%eax
c0101480:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c0101485:	b8 00 00 00 00       	mov    $0x0,%eax
c010148a:	e9 25 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	84 c0                	test   %al,%al
c0101495:	79 47                	jns    c01014de <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101497:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010149c:	83 e0 40             	and    $0x40,%eax
c010149f:	85 c0                	test   %eax,%eax
c01014a1:	75 09                	jne    c01014ac <kbd_proc_data+0x7f>
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	83 e0 7f             	and    $0x7f,%eax
c01014aa:	eb 04                	jmp    c01014b0 <kbd_proc_data+0x83>
c01014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b7:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014be:	83 c8 40             	or     $0x40,%eax
c01014c1:	0f b6 c0             	movzbl %al,%eax
c01014c4:	f7 d0                	not    %eax
c01014c6:	89 c2                	mov    %eax,%edx
c01014c8:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014cd:	21 d0                	and    %edx,%eax
c01014cf:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d9:	e9 d6 00 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014de:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014e3:	83 e0 40             	and    $0x40,%eax
c01014e6:	85 c0                	test   %eax,%eax
c01014e8:	74 11                	je     c01014fb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ea:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ee:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014f3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f6:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c01014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ff:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101506:	0f b6 d0             	movzbl %al,%edx
c0101509:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010150e:	09 d0                	or     %edx,%eax
c0101510:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c0101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101519:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c0101520:	0f b6 d0             	movzbl %al,%edx
c0101523:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101528:	31 d0                	xor    %edx,%eax
c010152a:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c010152f:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101534:	83 e0 03             	and    $0x3,%eax
c0101537:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c010153e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101542:	01 d0                	add    %edx,%eax
c0101544:	0f b6 00             	movzbl (%eax),%eax
c0101547:	0f b6 c0             	movzbl %al,%eax
c010154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154d:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101552:	83 e0 08             	and    $0x8,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 22                	je     c010157b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101559:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155d:	7e 0c                	jle    c010156b <kbd_proc_data+0x13e>
c010155f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101563:	7f 06                	jg     c010156b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101565:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101569:	eb 10                	jmp    c010157b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156f:	7e 0a                	jle    c010157b <kbd_proc_data+0x14e>
c0101571:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101575:	7f 04                	jg     c010157b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101577:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157b:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101580:	f7 d0                	not    %eax
c0101582:	83 e0 06             	and    $0x6,%eax
c0101585:	85 c0                	test   %eax,%eax
c0101587:	75 28                	jne    c01015b1 <kbd_proc_data+0x184>
c0101589:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101590:	75 1f                	jne    c01015b1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101592:	c7 04 24 5d a0 10 c0 	movl   $0xc010a05d,(%esp)
c0101599:	e8 b5 ed ff ff       	call   c0100353 <cprintf>
c010159e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ac:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bc:	c7 04 24 2d 14 10 c0 	movl   $0xc010142d,(%esp)
c01015c3:	e8 a6 fd ff ff       	call   c010136e <cons_intr>
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <kbd_init>:

static void
kbd_init(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d0:	e8 e1 ff ff ff       	call   c01015b6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015dc:	e8 b2 09 00 00       	call   c0101f93 <pic_enable>
}
c01015e1:	c9                   	leave  
c01015e2:	c3                   	ret    

c01015e3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e3:	55                   	push   %ebp
c01015e4:	89 e5                	mov    %esp,%ebp
c01015e6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e9:	e8 93 f8 ff ff       	call   c0100e81 <cga_init>
    serial_init();
c01015ee:	e8 74 f9 ff ff       	call   c0100f67 <serial_init>
    kbd_init();
c01015f3:	e8 d2 ff ff ff       	call   c01015ca <kbd_init>
    if (!serial_exists) {
c01015f8:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c01015fd:	85 c0                	test   %eax,%eax
c01015ff:	75 0c                	jne    c010160d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101601:	c7 04 24 69 a0 10 c0 	movl   $0xc010a069,(%esp)
c0101608:	e8 46 ed ff ff       	call   c0100353 <cprintf>
    }
}
c010160d:	c9                   	leave  
c010160e:	c3                   	ret    

c010160f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160f:	55                   	push   %ebp
c0101610:	89 e5                	mov    %esp,%ebp
c0101612:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101615:	e8 e2 f7 ff ff       	call   c0100dfc <__intr_save>
c010161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101620:	89 04 24             	mov    %eax,(%esp)
c0101623:	e8 9b fa ff ff       	call   c01010c3 <lpt_putc>
        cga_putc(c);
c0101628:	8b 45 08             	mov    0x8(%ebp),%eax
c010162b:	89 04 24             	mov    %eax,(%esp)
c010162e:	e8 cf fa ff ff       	call   c0101102 <cga_putc>
        serial_putc(c);
c0101633:	8b 45 08             	mov    0x8(%ebp),%eax
c0101636:	89 04 24             	mov    %eax,(%esp)
c0101639:	e8 f1 fc ff ff       	call   c010132f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101641:	89 04 24             	mov    %eax,(%esp)
c0101644:	e8 dd f7 ff ff       	call   c0100e26 <__intr_restore>
}
c0101649:	c9                   	leave  
c010164a:	c3                   	ret    

c010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164b:	55                   	push   %ebp
c010164c:	89 e5                	mov    %esp,%ebp
c010164e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101658:	e8 9f f7 ff ff       	call   c0100dfc <__intr_save>
c010165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101660:	e8 ab fd ff ff       	call   c0101410 <serial_intr>
        kbd_intr();
c0101665:	e8 4c ff ff ff       	call   c01015b6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166a:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c0101670:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101675:	39 c2                	cmp    %eax,%edx
c0101677:	74 31                	je     c01016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101679:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c010167e:	8d 50 01             	lea    0x1(%eax),%edx
c0101681:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c0101687:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c010168e:	0f b6 c0             	movzbl %al,%eax
c0101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101694:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101699:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169e:	75 0a                	jne    c01016aa <cons_getc+0x5f>
                cons.rpos = 0;
c01016a0:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ad:	89 04 24             	mov    %eax,(%esp)
c01016b0:	e8 71 f7 ff ff       	call   c0100e26 <__intr_restore>
    return c;
c01016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b8:	c9                   	leave  
c01016b9:	c3                   	ret    

c01016ba <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 14             	sub    $0x14,%esp
c01016c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c7:	90                   	nop
c01016c8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cc:	83 c0 07             	add    $0x7,%eax
c01016cf:	0f b7 c0             	movzwl %ax,%eax
c01016d2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016da:	89 c2                	mov    %eax,%edx
c01016dc:	ec                   	in     (%dx),%al
c01016dd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e4:	0f b6 c0             	movzbl %al,%eax
c01016e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ed:	25 80 00 00 00       	and    $0x80,%eax
c01016f2:	85 c0                	test   %eax,%eax
c01016f4:	75 d2                	jne    c01016c8 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016fa:	74 11                	je     c010170d <ide_wait_ready+0x53>
c01016fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ff:	83 e0 21             	and    $0x21,%eax
c0101702:	85 c0                	test   %eax,%eax
c0101704:	74 07                	je     c010170d <ide_wait_ready+0x53>
        return -1;
c0101706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170b:	eb 05                	jmp    c0101712 <ide_wait_ready+0x58>
    }
    return 0;
c010170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101712:	c9                   	leave  
c0101713:	c3                   	ret    

c0101714 <ide_init>:

void
ide_init(void) {
c0101714:	55                   	push   %ebp
c0101715:	89 e5                	mov    %esp,%ebp
c0101717:	57                   	push   %edi
c0101718:	53                   	push   %ebx
c0101719:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171f:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101725:	e9 d6 02 00 00       	jmp    c0101a00 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010172a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172e:	c1 e0 03             	shl    $0x3,%eax
c0101731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101738:	29 c2                	sub    %eax,%edx
c010173a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101740:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101743:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101747:	66 d1 e8             	shr    %ax
c010174a:	0f b7 c0             	movzwl %ax,%eax
c010174d:	0f b7 04 85 88 a0 10 	movzwl -0x3fef5f78(,%eax,4),%eax
c0101754:	c0 
c0101755:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101759:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101764:	00 
c0101765:	89 04 24             	mov    %eax,(%esp)
c0101768:	e8 4d ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101771:	83 e0 01             	and    $0x1,%eax
c0101774:	c1 e0 04             	shl    $0x4,%eax
c0101777:	83 c8 e0             	or     $0xffffffe0,%eax
c010177a:	0f b6 c0             	movzbl %al,%eax
c010177d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101781:	83 c2 06             	add    $0x6,%edx
c0101784:	0f b7 d2             	movzwl %dx,%edx
c0101787:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178b:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101792:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101797:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a2:	00 
c01017a3:	89 04 24             	mov    %eax,(%esp)
c01017a6:	e8 0f ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017ab:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017af:	83 c0 07             	add    $0x7,%eax
c01017b2:	0f b7 c0             	movzwl %ax,%eax
c01017b5:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b9:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c1:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c5:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d1:	00 
c01017d2:	89 04 24             	mov    %eax,(%esp)
c01017d5:	e8 e0 fe ff ff       	call   c01016ba <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017da:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017de:	83 c0 07             	add    $0x7,%eax
c01017e1:	0f b7 c0             	movzwl %ax,%eax
c01017e4:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e8:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017ec:	89 c2                	mov    %eax,%edx
c01017ee:	ec                   	in     (%dx),%al
c01017ef:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f6:	84 c0                	test   %al,%al
c01017f8:	0f 84 f7 01 00 00    	je     c01019f5 <ide_init+0x2e1>
c01017fe:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101809:	00 
c010180a:	89 04 24             	mov    %eax,(%esp)
c010180d:	e8 a8 fe ff ff       	call   c01016ba <ide_wait_ready>
c0101812:	85 c0                	test   %eax,%eax
c0101814:	0f 85 db 01 00 00    	jne    c01019f5 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010181a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181e:	c1 e0 03             	shl    $0x3,%eax
c0101821:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101828:	29 c2                	sub    %eax,%edx
c010182a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101830:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101833:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101837:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010183a:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101840:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101843:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010184a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101850:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101853:	89 cb                	mov    %ecx,%ebx
c0101855:	89 df                	mov    %ebx,%edi
c0101857:	89 c1                	mov    %eax,%ecx
c0101859:	fc                   	cld    
c010185a:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185c:	89 c8                	mov    %ecx,%eax
c010185e:	89 fb                	mov    %edi,%ebx
c0101860:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101863:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101866:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101872:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101878:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187e:	25 00 00 00 04       	and    $0x4000000,%eax
c0101883:	85 c0                	test   %eax,%eax
c0101885:	74 0e                	je     c0101895 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188a:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101890:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101893:	eb 09                	jmp    c010189e <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101898:	8b 40 78             	mov    0x78(%eax),%eax
c010189b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a2:	c1 e0 03             	shl    $0x3,%eax
c01018a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ac:	29 c2                	sub    %eax,%edx
c01018ae:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b7:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018be:	c1 e0 03             	shl    $0x3,%eax
c01018c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c8:	29 c2                	sub    %eax,%edx
c01018ca:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d3:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d9:	83 c0 62             	add    $0x62,%eax
c01018dc:	0f b7 00             	movzwl (%eax),%eax
c01018df:	0f b7 c0             	movzwl %ax,%eax
c01018e2:	25 00 02 00 00       	and    $0x200,%eax
c01018e7:	85 c0                	test   %eax,%eax
c01018e9:	75 24                	jne    c010190f <ide_init+0x1fb>
c01018eb:	c7 44 24 0c 90 a0 10 	movl   $0xc010a090,0xc(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 08 d3 a0 10 	movl   $0xc010a0d3,0x8(%esp)
c01018fa:	c0 
c01018fb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101902:	00 
c0101903:	c7 04 24 e8 a0 10 c0 	movl   $0xc010a0e8,(%esp)
c010190a:	e8 ce f3 ff ff       	call   c0100cdd <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101913:	c1 e0 03             	shl    $0x3,%eax
c0101916:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191d:	29 c2                	sub    %eax,%edx
c010191f:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101925:	83 c0 0c             	add    $0xc,%eax
c0101928:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192e:	83 c0 36             	add    $0x36,%eax
c0101931:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101934:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101942:	eb 34                	jmp    c0101978 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010194a:	01 c2                	add    %eax,%edx
c010194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194f:	8d 48 01             	lea    0x1(%eax),%ecx
c0101952:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101955:	01 c8                	add    %ecx,%eax
c0101957:	0f b6 00             	movzbl (%eax),%eax
c010195a:	88 02                	mov    %al,(%edx)
c010195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195f:	8d 50 01             	lea    0x1(%eax),%edx
c0101962:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101965:	01 c2                	add    %eax,%edx
c0101967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196d:	01 c8                	add    %ecx,%eax
c010196f:	0f b6 00             	movzbl (%eax),%eax
c0101972:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101974:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197e:	72 c4                	jb     c0101944 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101980:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101983:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101986:	01 d0                	add    %edx,%eax
c0101988:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101991:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101994:	85 c0                	test   %eax,%eax
c0101996:	74 0f                	je     c01019a7 <ide_init+0x293>
c0101998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199e:	01 d0                	add    %edx,%eax
c01019a0:	0f b6 00             	movzbl (%eax),%eax
c01019a3:	3c 20                	cmp    $0x20,%al
c01019a5:	74 d9                	je     c0101980 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019ab:	c1 e0 03             	shl    $0x3,%eax
c01019ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b5:	29 c2                	sub    %eax,%edx
c01019b7:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019bd:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019c0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c4:	c1 e0 03             	shl    $0x3,%eax
c01019c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ce:	29 c2                	sub    %eax,%edx
c01019d0:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d6:	8b 50 08             	mov    0x8(%eax),%edx
c01019d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e9:	c7 04 24 fa a0 10 c0 	movl   $0xc010a0fa,(%esp)
c01019f0:	e8 5e e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f9:	83 c0 01             	add    $0x1,%eax
c01019fc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a00:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a05:	0f 86 1f fd ff ff    	jbe    c010172a <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a12:	e8 7c 05 00 00       	call   c0101f93 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a17:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1e:	e8 70 05 00 00       	call   c0101f93 <pic_enable>
}
c0101a23:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a29:	5b                   	pop    %ebx
c0101a2a:	5f                   	pop    %edi
c0101a2b:	5d                   	pop    %ebp
c0101a2c:	c3                   	ret    

c0101a2d <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
c0101a30:	83 ec 04             	sub    $0x4,%esp
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a3a:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3f:	77 24                	ja     c0101a65 <ide_device_valid+0x38>
c0101a41:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a45:	c1 e0 03             	shl    $0x3,%eax
c0101a48:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4f:	29 c2                	sub    %eax,%edx
c0101a51:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a57:	0f b6 00             	movzbl (%eax),%eax
c0101a5a:	84 c0                	test   %al,%al
c0101a5c:	74 07                	je     c0101a65 <ide_device_valid+0x38>
c0101a5e:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a63:	eb 05                	jmp    c0101a6a <ide_device_valid+0x3d>
c0101a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a6a:	c9                   	leave  
c0101a6b:	c3                   	ret    

c0101a6c <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6c:	55                   	push   %ebp
c0101a6d:	89 e5                	mov    %esp,%ebp
c0101a6f:	83 ec 08             	sub    $0x8,%esp
c0101a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a75:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a79:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7d:	89 04 24             	mov    %eax,(%esp)
c0101a80:	e8 a8 ff ff ff       	call   c0101a2d <ide_device_valid>
c0101a85:	85 c0                	test   %eax,%eax
c0101a87:	74 1b                	je     c0101aa4 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8d:	c1 e0 03             	shl    $0x3,%eax
c0101a90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a97:	29 c2                	sub    %eax,%edx
c0101a99:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a9f:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa2:	eb 05                	jmp    c0101aa9 <ide_device_size+0x3d>
    }
    return 0;
c0101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa9:	c9                   	leave  
c0101aaa:	c3                   	ret    

c0101aab <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aab:	55                   	push   %ebp
c0101aac:	89 e5                	mov    %esp,%ebp
c0101aae:	57                   	push   %edi
c0101aaf:	53                   	push   %ebx
c0101ab0:	83 ec 50             	sub    $0x50,%esp
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101aba:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac1:	77 24                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101ac3:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac8:	77 1d                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101aca:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ace:	c1 e0 03             	shl    $0x3,%eax
c0101ad1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad8:	29 c2                	sub    %eax,%edx
c0101ada:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101ae0:	0f b6 00             	movzbl (%eax),%eax
c0101ae3:	84 c0                	test   %al,%al
c0101ae5:	75 24                	jne    c0101b0b <ide_read_secs+0x60>
c0101ae7:	c7 44 24 0c 18 a1 10 	movl   $0xc010a118,0xc(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 08 d3 a0 10 	movl   $0xc010a0d3,0x8(%esp)
c0101af6:	c0 
c0101af7:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afe:	00 
c0101aff:	c7 04 24 e8 a0 10 c0 	movl   $0xc010a0e8,(%esp)
c0101b06:	e8 d2 f1 ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0b:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b12:	77 0f                	ja     c0101b23 <ide_read_secs+0x78>
c0101b14:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b1a:	01 d0                	add    %edx,%eax
c0101b1c:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b21:	76 24                	jbe    c0101b47 <ide_read_secs+0x9c>
c0101b23:	c7 44 24 0c 40 a1 10 	movl   $0xc010a140,0xc(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 08 d3 a0 10 	movl   $0xc010a0d3,0x8(%esp)
c0101b32:	c0 
c0101b33:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b3a:	00 
c0101b3b:	c7 04 24 e8 a0 10 c0 	movl   $0xc010a0e8,(%esp)
c0101b42:	e8 96 f1 ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b47:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4b:	66 d1 e8             	shr    %ax
c0101b4e:	0f b7 c0             	movzwl %ax,%eax
c0101b51:	0f b7 04 85 88 a0 10 	movzwl -0x3fef5f78(,%eax,4),%eax
c0101b58:	c0 
c0101b59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b61:	66 d1 e8             	shr    %ax
c0101b64:	0f b7 c0             	movzwl %ax,%eax
c0101b67:	0f b7 04 85 8a a0 10 	movzwl -0x3fef5f76(,%eax,4),%eax
c0101b6e:	c0 
c0101b6f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b73:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7e:	00 
c0101b7f:	89 04 24             	mov    %eax,(%esp)
c0101b82:	e8 33 fb ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b87:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8b:	83 c0 02             	add    $0x2,%eax
c0101b8e:	0f b7 c0             	movzwl %ax,%eax
c0101b91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b95:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba2:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba5:	0f b6 c0             	movzbl %al,%eax
c0101ba8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bac:	83 c2 02             	add    $0x2,%edx
c0101baf:	0f b7 d2             	movzwl %dx,%edx
c0101bb2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb6:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc5:	0f b6 c0             	movzbl %al,%eax
c0101bc8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcc:	83 c2 03             	add    $0x3,%edx
c0101bcf:	0f b7 d2             	movzwl %dx,%edx
c0101bd2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be5:	c1 e8 08             	shr    $0x8,%eax
c0101be8:	0f b6 c0             	movzbl %al,%eax
c0101beb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bef:	83 c2 04             	add    $0x4,%edx
c0101bf2:	0f b7 d2             	movzwl %dx,%edx
c0101bf5:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf9:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c00:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c04:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c08:	c1 e8 10             	shr    $0x10,%eax
c0101c0b:	0f b6 c0             	movzbl %al,%eax
c0101c0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c12:	83 c2 05             	add    $0x5,%edx
c0101c15:	0f b7 d2             	movzwl %dx,%edx
c0101c18:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1c:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c23:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c27:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c28:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2c:	83 e0 01             	and    $0x1,%eax
c0101c2f:	c1 e0 04             	shl    $0x4,%eax
c0101c32:	89 c2                	mov    %eax,%edx
c0101c34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c37:	c1 e8 18             	shr    $0x18,%eax
c0101c3a:	83 e0 0f             	and    $0xf,%eax
c0101c3d:	09 d0                	or     %edx,%eax
c0101c3f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c42:	0f b6 c0             	movzbl %al,%eax
c0101c45:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c49:	83 c2 06             	add    $0x6,%edx
c0101c4c:	0f b7 d2             	movzwl %dx,%edx
c0101c4f:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c53:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c56:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c5a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c63:	83 c0 07             	add    $0x7,%eax
c0101c66:	0f b7 c0             	movzwl %ax,%eax
c0101c69:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c71:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c75:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c79:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c81:	eb 5a                	jmp    c0101cdd <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c83:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c87:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8e:	00 
c0101c8f:	89 04 24             	mov    %eax,(%esp)
c0101c92:	e8 23 fa ff ff       	call   c01016ba <ide_wait_ready>
c0101c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9e:	74 02                	je     c0101ca2 <ide_read_secs+0x1f7>
            goto out;
c0101ca0:	eb 41                	jmp    c0101ce3 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca9:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cac:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101caf:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbf:	89 cb                	mov    %ecx,%ebx
c0101cc1:	89 df                	mov    %ebx,%edi
c0101cc3:	89 c1                	mov    %eax,%ecx
c0101cc5:	fc                   	cld    
c0101cc6:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc8:	89 c8                	mov    %ecx,%eax
c0101cca:	89 fb                	mov    %edi,%ebx
c0101ccc:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ccf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd2:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd6:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce1:	75 a0                	jne    c0101c83 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce6:	83 c4 50             	add    $0x50,%esp
c0101ce9:	5b                   	pop    %ebx
c0101cea:	5f                   	pop    %edi
c0101ceb:	5d                   	pop    %ebp
c0101cec:	c3                   	ret    

c0101ced <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ced:	55                   	push   %ebp
c0101cee:	89 e5                	mov    %esp,%ebp
c0101cf0:	56                   	push   %esi
c0101cf1:	53                   	push   %ebx
c0101cf2:	83 ec 50             	sub    $0x50,%esp
c0101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfc:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d03:	77 24                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d05:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d0a:	77 1d                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d0c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d10:	c1 e0 03             	shl    $0x3,%eax
c0101d13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d1a:	29 c2                	sub    %eax,%edx
c0101d1c:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d22:	0f b6 00             	movzbl (%eax),%eax
c0101d25:	84 c0                	test   %al,%al
c0101d27:	75 24                	jne    c0101d4d <ide_write_secs+0x60>
c0101d29:	c7 44 24 0c 18 a1 10 	movl   $0xc010a118,0xc(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 08 d3 a0 10 	movl   $0xc010a0d3,0x8(%esp)
c0101d38:	c0 
c0101d39:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d40:	00 
c0101d41:	c7 04 24 e8 a0 10 c0 	movl   $0xc010a0e8,(%esp)
c0101d48:	e8 90 ef ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4d:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d54:	77 0f                	ja     c0101d65 <ide_write_secs+0x78>
c0101d56:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d59:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5c:	01 d0                	add    %edx,%eax
c0101d5e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d63:	76 24                	jbe    c0101d89 <ide_write_secs+0x9c>
c0101d65:	c7 44 24 0c 40 a1 10 	movl   $0xc010a140,0xc(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 08 d3 a0 10 	movl   $0xc010a0d3,0x8(%esp)
c0101d74:	c0 
c0101d75:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7c:	00 
c0101d7d:	c7 04 24 e8 a0 10 c0 	movl   $0xc010a0e8,(%esp)
c0101d84:	e8 54 ef ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d89:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8d:	66 d1 e8             	shr    %ax
c0101d90:	0f b7 c0             	movzwl %ax,%eax
c0101d93:	0f b7 04 85 88 a0 10 	movzwl -0x3fef5f78(,%eax,4),%eax
c0101d9a:	c0 
c0101d9b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da3:	66 d1 e8             	shr    %ax
c0101da6:	0f b7 c0             	movzwl %ax,%eax
c0101da9:	0f b7 04 85 8a a0 10 	movzwl -0x3fef5f76(,%eax,4),%eax
c0101db0:	c0 
c0101db1:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dc0:	00 
c0101dc1:	89 04 24             	mov    %eax,(%esp)
c0101dc4:	e8 f1 f8 ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcd:	83 c0 02             	add    $0x2,%eax
c0101dd0:	0f b7 c0             	movzwl %ax,%eax
c0101dd3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd7:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ddb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ddf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de4:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de7:	0f b6 c0             	movzbl %al,%eax
c0101dea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101dee:	83 c2 02             	add    $0x2,%edx
c0101df1:	0f b7 d2             	movzwl %dx,%edx
c0101df4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e07:	0f b6 c0             	movzbl %al,%eax
c0101e0a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0e:	83 c2 03             	add    $0x3,%edx
c0101e11:	0f b7 d2             	movzwl %dx,%edx
c0101e14:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e18:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e23:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e27:	c1 e8 08             	shr    $0x8,%eax
c0101e2a:	0f b6 c0             	movzbl %al,%eax
c0101e2d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e31:	83 c2 04             	add    $0x4,%edx
c0101e34:	0f b7 d2             	movzwl %dx,%edx
c0101e37:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3b:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e42:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e46:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e4a:	c1 e8 10             	shr    $0x10,%eax
c0101e4d:	0f b6 c0             	movzbl %al,%eax
c0101e50:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e54:	83 c2 05             	add    $0x5,%edx
c0101e57:	0f b7 d2             	movzwl %dx,%edx
c0101e5a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5e:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e61:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e65:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e69:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e6a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6e:	83 e0 01             	and    $0x1,%eax
c0101e71:	c1 e0 04             	shl    $0x4,%eax
c0101e74:	89 c2                	mov    %eax,%edx
c0101e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e79:	c1 e8 18             	shr    $0x18,%eax
c0101e7c:	83 e0 0f             	and    $0xf,%eax
c0101e7f:	09 d0                	or     %edx,%eax
c0101e81:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e84:	0f b6 c0             	movzbl %al,%eax
c0101e87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8b:	83 c2 06             	add    $0x6,%edx
c0101e8e:	0f b7 d2             	movzwl %dx,%edx
c0101e91:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e95:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e98:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101ea0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea5:	83 c0 07             	add    $0x7,%eax
c0101ea8:	0f b7 c0             	movzwl %ax,%eax
c0101eab:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eaf:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb3:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb7:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ebb:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec3:	eb 5a                	jmp    c0101f1f <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ed0:	00 
c0101ed1:	89 04 24             	mov    %eax,(%esp)
c0101ed4:	e8 e1 f7 ff ff       	call   c01016ba <ide_wait_ready>
c0101ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ee0:	74 02                	je     c0101ee4 <ide_write_secs+0x1f7>
            goto out;
c0101ee2:	eb 41                	jmp    c0101f25 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eee:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef1:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f01:	89 cb                	mov    %ecx,%ebx
c0101f03:	89 de                	mov    %ebx,%esi
c0101f05:	89 c1                	mov    %eax,%ecx
c0101f07:	fc                   	cld    
c0101f08:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f0a:	89 c8                	mov    %ecx,%eax
c0101f0c:	89 f3                	mov    %esi,%ebx
c0101f0e:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f14:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f18:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f23:	75 a0                	jne    c0101ec5 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f28:	83 c4 50             	add    $0x50,%esp
c0101f2b:	5b                   	pop    %ebx
c0101f2c:	5e                   	pop    %esi
c0101f2d:	5d                   	pop    %ebp
c0101f2e:	c3                   	ret    

c0101f2f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2f:	55                   	push   %ebp
c0101f30:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f32:	fb                   	sti    
    sti();
}
c0101f33:	5d                   	pop    %ebp
c0101f34:	c3                   	ret    

c0101f35 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f35:	55                   	push   %ebp
c0101f36:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f38:	fa                   	cli    
    cli();
}
c0101f39:	5d                   	pop    %ebp
c0101f3a:	c3                   	ret    

c0101f3b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3b:	55                   	push   %ebp
c0101f3c:	89 e5                	mov    %esp,%ebp
c0101f3e:	83 ec 14             	sub    $0x14,%esp
c0101f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f44:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f48:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4c:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f52:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f57:	85 c0                	test   %eax,%eax
c0101f59:	74 36                	je     c0101f91 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5f:	0f b6 c0             	movzbl %al,%eax
c0101f62:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f68:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f73:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f74:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f78:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f85:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f88:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f90:	ee                   	out    %al,(%dx)
    }
}
c0101f91:	c9                   	leave  
c0101f92:	c3                   	ret    

c0101f93 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f93:	55                   	push   %ebp
c0101f94:	89 e5                	mov    %esp,%ebp
c0101f96:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa1:	89 c1                	mov    %eax,%ecx
c0101fa3:	d3 e2                	shl    %cl,%edx
c0101fa5:	89 d0                	mov    %edx,%eax
c0101fa7:	f7 d0                	not    %eax
c0101fa9:	89 c2                	mov    %eax,%edx
c0101fab:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fb2:	21 d0                	and    %edx,%eax
c0101fb4:	0f b7 c0             	movzwl %ax,%eax
c0101fb7:	89 04 24             	mov    %eax,(%esp)
c0101fba:	e8 7c ff ff ff       	call   c0101f3b <pic_setmask>
}
c0101fbf:	c9                   	leave  
c0101fc0:	c3                   	ret    

c0101fc1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc1:	55                   	push   %ebp
c0101fc2:	89 e5                	mov    %esp,%ebp
c0101fc4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc7:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fce:	00 00 00 
c0101fd1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd7:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fdb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fdf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe3:	ee                   	out    %al,(%dx)
c0101fe4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fea:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff6:	ee                   	out    %al,(%dx)
c0101ff7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102001:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102005:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102009:	ee                   	out    %al,(%dx)
c010200a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102010:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102014:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102018:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201c:	ee                   	out    %al,(%dx)
c010201d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102023:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102027:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202f:	ee                   	out    %al,(%dx)
c0102030:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102036:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010203a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102042:	ee                   	out    %al,(%dx)
c0102043:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102049:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102051:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102055:	ee                   	out    %al,(%dx)
c0102056:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102060:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102064:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102068:	ee                   	out    %al,(%dx)
c0102069:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102073:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102077:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207b:	ee                   	out    %al,(%dx)
c010207c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102082:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102086:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010208a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208e:	ee                   	out    %al,(%dx)
c010208f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102095:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102099:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a1:	ee                   	out    %al,(%dx)
c01020a2:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a8:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020b0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b4:	ee                   	out    %al,(%dx)
c01020b5:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020bb:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020bf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c7:	ee                   	out    %al,(%dx)
c01020c8:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020ce:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020da:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020db:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020e2:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e6:	74 12                	je     c01020fa <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e8:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020ef:	0f b7 c0             	movzwl %ax,%eax
c01020f2:	89 04 24             	mov    %eax,(%esp)
c01020f5:	e8 41 fe ff ff       	call   c0101f3b <pic_setmask>
    }
}
c01020fa:	c9                   	leave  
c01020fb:	c3                   	ret    

c01020fc <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fc:	55                   	push   %ebp
c01020fd:	89 e5                	mov    %esp,%ebp
c01020ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102102:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102109:	00 
c010210a:	c7 04 24 80 a1 10 c0 	movl   $0xc010a180,(%esp)
c0102111:	e8 3d e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102116:	c9                   	leave  
c0102117:	c3                   	ret    

c0102118 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102118:	55                   	push   %ebp
c0102119:	89 e5                	mov    %esp,%ebp
c010211b:	83 ec 10             	sub    $0x10,%esp
     /* LAB1 17343027 : STEP 2 */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
c010211e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102125:	e9 c3 00 00 00       	jmp    c01021ed <idt_init+0xd5>
	/*if(i == T_SYSCALL){
	    SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_USER);
	}
	else SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }*/
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010212a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010212d:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102134:	89 c2                	mov    %eax,%edx
c0102136:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102139:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c0102140:	c0 
c0102141:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102144:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c010214b:	c0 08 00 
c010214e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102151:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102158:	c0 
c0102159:	83 e2 e0             	and    $0xffffffe0,%edx
c010215c:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102163:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102166:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c010216d:	c0 
c010216e:	83 e2 1f             	and    $0x1f,%edx
c0102171:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102178:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217b:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102182:	c0 
c0102183:	83 e2 f0             	and    $0xfffffff0,%edx
c0102186:	83 ca 0e             	or     $0xe,%edx
c0102189:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102190:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102193:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c010219a:	c0 
c010219b:	83 e2 ef             	and    $0xffffffef,%edx
c010219e:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a8:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021af:	c0 
c01021b0:	83 e2 9f             	and    $0xffffff9f,%edx
c01021b3:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021bd:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021c4:	c0 
c01021c5:	83 ca 80             	or     $0xffffff80,%edx
c01021c8:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d2:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c01021d9:	c1 e8 10             	shr    $0x10,%eax
c01021dc:	89 c2                	mov    %eax,%edx
c01021de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e1:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c01021e8:	c0 
void
idt_init(void) {
     /* LAB1 17343027 : STEP 2 */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i ++) {
c01021e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021ed:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01021f4:	0f 8e 30 ff ff ff    	jle    c010212a <idt_init+0x12>
	else SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }*/
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021fa:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c01021ff:	66 a3 e8 55 12 c0    	mov    %ax,0xc01255e8
c0102205:	66 c7 05 ea 55 12 c0 	movw   $0x8,0xc01255ea
c010220c:	08 00 
c010220e:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c0102215:	83 e0 e0             	and    $0xffffffe0,%eax
c0102218:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c010221d:	0f b6 05 ec 55 12 c0 	movzbl 0xc01255ec,%eax
c0102224:	83 e0 1f             	and    $0x1f,%eax
c0102227:	a2 ec 55 12 c0       	mov    %al,0xc01255ec
c010222c:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102233:	83 e0 f0             	and    $0xfffffff0,%eax
c0102236:	83 c8 0e             	or     $0xe,%eax
c0102239:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010223e:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102245:	83 e0 ef             	and    $0xffffffef,%eax
c0102248:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010224d:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102254:	83 c8 60             	or     $0x60,%eax
c0102257:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010225c:	0f b6 05 ed 55 12 c0 	movzbl 0xc01255ed,%eax
c0102263:	83 c8 80             	or     $0xffffff80,%eax
c0102266:	a2 ed 55 12 c0       	mov    %al,0xc01255ed
c010226b:	a1 e4 47 12 c0       	mov    0xc01247e4,%eax
c0102270:	c1 e8 10             	shr    $0x10,%eax
c0102273:	66 a3 ee 55 12 c0    	mov    %ax,0xc01255ee
c0102279:	c7 45 f8 80 45 12 c0 	movl   $0xc0124580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102280:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102283:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c0102286:	c9                   	leave  
c0102287:	c3                   	ret    

c0102288 <trapname>:

static const char *
trapname(int trapno) {
c0102288:	55                   	push   %ebp
c0102289:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010228b:	8b 45 08             	mov    0x8(%ebp),%eax
c010228e:	83 f8 13             	cmp    $0x13,%eax
c0102291:	77 0c                	ja     c010229f <trapname+0x17>
        return excnames[trapno];
c0102293:	8b 45 08             	mov    0x8(%ebp),%eax
c0102296:	8b 04 85 60 a5 10 c0 	mov    -0x3fef5aa0(,%eax,4),%eax
c010229d:	eb 18                	jmp    c01022b7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010229f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022a3:	7e 0d                	jle    c01022b2 <trapname+0x2a>
c01022a5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022a9:	7f 07                	jg     c01022b2 <trapname+0x2a>
        return "Hardware Interrupt";
c01022ab:	b8 8a a1 10 c0       	mov    $0xc010a18a,%eax
c01022b0:	eb 05                	jmp    c01022b7 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022b2:	b8 9d a1 10 c0       	mov    $0xc010a19d,%eax
}
c01022b7:	5d                   	pop    %ebp
c01022b8:	c3                   	ret    

c01022b9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022b9:	55                   	push   %ebp
c01022ba:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01022bf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022c3:	66 83 f8 08          	cmp    $0x8,%ax
c01022c7:	0f 94 c0             	sete   %al
c01022ca:	0f b6 c0             	movzbl %al,%eax
}
c01022cd:	5d                   	pop    %ebp
c01022ce:	c3                   	ret    

c01022cf <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022cf:	55                   	push   %ebp
c01022d0:	89 e5                	mov    %esp,%ebp
c01022d2:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01022d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022dc:	c7 04 24 de a1 10 c0 	movl   $0xc010a1de,(%esp)
c01022e3:	e8 6b e0 ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c01022e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022eb:	89 04 24             	mov    %eax,(%esp)
c01022ee:	e8 a1 01 00 00       	call   c0102494 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f6:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022fa:	0f b7 c0             	movzwl %ax,%eax
c01022fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102301:	c7 04 24 ef a1 10 c0 	movl   $0xc010a1ef,(%esp)
c0102308:	e8 46 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010230d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102310:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0102314:	0f b7 c0             	movzwl %ax,%eax
c0102317:	89 44 24 04          	mov    %eax,0x4(%esp)
c010231b:	c7 04 24 02 a2 10 c0 	movl   $0xc010a202,(%esp)
c0102322:	e8 2c e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102327:	8b 45 08             	mov    0x8(%ebp),%eax
c010232a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010232e:	0f b7 c0             	movzwl %ax,%eax
c0102331:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102335:	c7 04 24 15 a2 10 c0 	movl   $0xc010a215,(%esp)
c010233c:	e8 12 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102341:	8b 45 08             	mov    0x8(%ebp),%eax
c0102344:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102348:	0f b7 c0             	movzwl %ax,%eax
c010234b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234f:	c7 04 24 28 a2 10 c0 	movl   $0xc010a228,(%esp)
c0102356:	e8 f8 df ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010235b:	8b 45 08             	mov    0x8(%ebp),%eax
c010235e:	8b 40 30             	mov    0x30(%eax),%eax
c0102361:	89 04 24             	mov    %eax,(%esp)
c0102364:	e8 1f ff ff ff       	call   c0102288 <trapname>
c0102369:	8b 55 08             	mov    0x8(%ebp),%edx
c010236c:	8b 52 30             	mov    0x30(%edx),%edx
c010236f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102373:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102377:	c7 04 24 3b a2 10 c0 	movl   $0xc010a23b,(%esp)
c010237e:	e8 d0 df ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102383:	8b 45 08             	mov    0x8(%ebp),%eax
c0102386:	8b 40 34             	mov    0x34(%eax),%eax
c0102389:	89 44 24 04          	mov    %eax,0x4(%esp)
c010238d:	c7 04 24 4d a2 10 c0 	movl   $0xc010a24d,(%esp)
c0102394:	e8 ba df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102399:	8b 45 08             	mov    0x8(%ebp),%eax
c010239c:	8b 40 38             	mov    0x38(%eax),%eax
c010239f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a3:	c7 04 24 5c a2 10 c0 	movl   $0xc010a25c,(%esp)
c01023aa:	e8 a4 df ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023af:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023b6:	0f b7 c0             	movzwl %ax,%eax
c01023b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023bd:	c7 04 24 6b a2 10 c0 	movl   $0xc010a26b,(%esp)
c01023c4:	e8 8a df ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cc:	8b 40 40             	mov    0x40(%eax),%eax
c01023cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d3:	c7 04 24 7e a2 10 c0 	movl   $0xc010a27e,(%esp)
c01023da:	e8 74 df ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023ed:	eb 3e                	jmp    c010242d <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f2:	8b 50 40             	mov    0x40(%eax),%edx
c01023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023f8:	21 d0                	and    %edx,%eax
c01023fa:	85 c0                	test   %eax,%eax
c01023fc:	74 28                	je     c0102426 <print_trapframe+0x157>
c01023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102401:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102408:	85 c0                	test   %eax,%eax
c010240a:	74 1a                	je     c0102426 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c010240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010240f:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c0102416:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241a:	c7 04 24 8d a2 10 c0 	movl   $0xc010a28d,(%esp)
c0102421:	e8 2d df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010242a:	d1 65 f0             	shll   -0x10(%ebp)
c010242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102430:	83 f8 17             	cmp    $0x17,%eax
c0102433:	76 ba                	jbe    c01023ef <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102435:	8b 45 08             	mov    0x8(%ebp),%eax
c0102438:	8b 40 40             	mov    0x40(%eax),%eax
c010243b:	25 00 30 00 00       	and    $0x3000,%eax
c0102440:	c1 e8 0c             	shr    $0xc,%eax
c0102443:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102447:	c7 04 24 91 a2 10 c0 	movl   $0xc010a291,(%esp)
c010244e:	e8 00 df ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102453:	8b 45 08             	mov    0x8(%ebp),%eax
c0102456:	89 04 24             	mov    %eax,(%esp)
c0102459:	e8 5b fe ff ff       	call   c01022b9 <trap_in_kernel>
c010245e:	85 c0                	test   %eax,%eax
c0102460:	75 30                	jne    c0102492 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102462:	8b 45 08             	mov    0x8(%ebp),%eax
c0102465:	8b 40 44             	mov    0x44(%eax),%eax
c0102468:	89 44 24 04          	mov    %eax,0x4(%esp)
c010246c:	c7 04 24 9a a2 10 c0 	movl   $0xc010a29a,(%esp)
c0102473:	e8 db de ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102478:	8b 45 08             	mov    0x8(%ebp),%eax
c010247b:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010247f:	0f b7 c0             	movzwl %ax,%eax
c0102482:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102486:	c7 04 24 a9 a2 10 c0 	movl   $0xc010a2a9,(%esp)
c010248d:	e8 c1 de ff ff       	call   c0100353 <cprintf>
    }
}
c0102492:	c9                   	leave  
c0102493:	c3                   	ret    

c0102494 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102494:	55                   	push   %ebp
c0102495:	89 e5                	mov    %esp,%ebp
c0102497:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010249a:	8b 45 08             	mov    0x8(%ebp),%eax
c010249d:	8b 00                	mov    (%eax),%eax
c010249f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a3:	c7 04 24 bc a2 10 c0 	movl   $0xc010a2bc,(%esp)
c01024aa:	e8 a4 de ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01024af:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b2:	8b 40 04             	mov    0x4(%eax),%eax
c01024b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b9:	c7 04 24 cb a2 10 c0 	movl   $0xc010a2cb,(%esp)
c01024c0:	e8 8e de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c8:	8b 40 08             	mov    0x8(%eax),%eax
c01024cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024cf:	c7 04 24 da a2 10 c0 	movl   $0xc010a2da,(%esp)
c01024d6:	e8 78 de ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024db:	8b 45 08             	mov    0x8(%ebp),%eax
c01024de:	8b 40 0c             	mov    0xc(%eax),%eax
c01024e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e5:	c7 04 24 e9 a2 10 c0 	movl   $0xc010a2e9,(%esp)
c01024ec:	e8 62 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f4:	8b 40 10             	mov    0x10(%eax),%eax
c01024f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fb:	c7 04 24 f8 a2 10 c0 	movl   $0xc010a2f8,(%esp)
c0102502:	e8 4c de ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102507:	8b 45 08             	mov    0x8(%ebp),%eax
c010250a:	8b 40 14             	mov    0x14(%eax),%eax
c010250d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102511:	c7 04 24 07 a3 10 c0 	movl   $0xc010a307,(%esp)
c0102518:	e8 36 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c010251d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102520:	8b 40 18             	mov    0x18(%eax),%eax
c0102523:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102527:	c7 04 24 16 a3 10 c0 	movl   $0xc010a316,(%esp)
c010252e:	e8 20 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102533:	8b 45 08             	mov    0x8(%ebp),%eax
c0102536:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102539:	89 44 24 04          	mov    %eax,0x4(%esp)
c010253d:	c7 04 24 25 a3 10 c0 	movl   $0xc010a325,(%esp)
c0102544:	e8 0a de ff ff       	call   c0100353 <cprintf>
}
c0102549:	c9                   	leave  
c010254a:	c3                   	ret    

c010254b <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010254b:	55                   	push   %ebp
c010254c:	89 e5                	mov    %esp,%ebp
c010254e:	53                   	push   %ebx
c010254f:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102552:	8b 45 08             	mov    0x8(%ebp),%eax
c0102555:	8b 40 34             	mov    0x34(%eax),%eax
c0102558:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010255b:	85 c0                	test   %eax,%eax
c010255d:	74 07                	je     c0102566 <print_pgfault+0x1b>
c010255f:	b9 34 a3 10 c0       	mov    $0xc010a334,%ecx
c0102564:	eb 05                	jmp    c010256b <print_pgfault+0x20>
c0102566:	b9 45 a3 10 c0       	mov    $0xc010a345,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010256b:	8b 45 08             	mov    0x8(%ebp),%eax
c010256e:	8b 40 34             	mov    0x34(%eax),%eax
c0102571:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102574:	85 c0                	test   %eax,%eax
c0102576:	74 07                	je     c010257f <print_pgfault+0x34>
c0102578:	ba 57 00 00 00       	mov    $0x57,%edx
c010257d:	eb 05                	jmp    c0102584 <print_pgfault+0x39>
c010257f:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102584:	8b 45 08             	mov    0x8(%ebp),%eax
c0102587:	8b 40 34             	mov    0x34(%eax),%eax
c010258a:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010258d:	85 c0                	test   %eax,%eax
c010258f:	74 07                	je     c0102598 <print_pgfault+0x4d>
c0102591:	b8 55 00 00 00       	mov    $0x55,%eax
c0102596:	eb 05                	jmp    c010259d <print_pgfault+0x52>
c0102598:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010259d:	0f 20 d3             	mov    %cr2,%ebx
c01025a0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01025a3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c01025a6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01025aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01025ae:	89 44 24 08          	mov    %eax,0x8(%esp)
c01025b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01025b6:	c7 04 24 54 a3 10 c0 	movl   $0xc010a354,(%esp)
c01025bd:	e8 91 dd ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01025c2:	83 c4 34             	add    $0x34,%esp
c01025c5:	5b                   	pop    %ebx
c01025c6:	5d                   	pop    %ebp
c01025c7:	c3                   	ret    

c01025c8 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025c8:	55                   	push   %ebp
c01025c9:	89 e5                	mov    %esp,%ebp
c01025cb:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d1:	89 04 24             	mov    %eax,(%esp)
c01025d4:	e8 72 ff ff ff       	call   c010254b <print_pgfault>
    if (check_mm_struct != NULL) {
c01025d9:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025de:	85 c0                	test   %eax,%eax
c01025e0:	74 28                	je     c010260a <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025e2:	0f 20 d0             	mov    %cr2,%eax
c01025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025eb:	89 c1                	mov    %eax,%ecx
c01025ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f0:	8b 50 34             	mov    0x34(%eax),%edx
c01025f3:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102600:	89 04 24             	mov    %eax,(%esp)
c0102603:	e8 77 5b 00 00       	call   c010817f <do_pgfault>
c0102608:	eb 1c                	jmp    c0102626 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c010260a:	c7 44 24 08 77 a3 10 	movl   $0xc010a377,0x8(%esp)
c0102611:	c0 
c0102612:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102619:	00 
c010261a:	c7 04 24 8e a3 10 c0 	movl   $0xc010a38e,(%esp)
c0102621:	e8 b7 e6 ff ff       	call   c0100cdd <__panic>
}
c0102626:	c9                   	leave  
c0102627:	c3                   	ret    

c0102628 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102628:	55                   	push   %ebp
c0102629:	89 e5                	mov    %esp,%ebp
c010262b:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c010262e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102631:	8b 40 30             	mov    0x30(%eax),%eax
c0102634:	83 f8 24             	cmp    $0x24,%eax
c0102637:	0f 84 8b 00 00 00    	je     c01026c8 <trap_dispatch+0xa0>
c010263d:	83 f8 24             	cmp    $0x24,%eax
c0102640:	77 1c                	ja     c010265e <trap_dispatch+0x36>
c0102642:	83 f8 20             	cmp    $0x20,%eax
c0102645:	0f 84 1d 01 00 00    	je     c0102768 <trap_dispatch+0x140>
c010264b:	83 f8 21             	cmp    $0x21,%eax
c010264e:	0f 84 9a 00 00 00    	je     c01026ee <trap_dispatch+0xc6>
c0102654:	83 f8 0e             	cmp    $0xe,%eax
c0102657:	74 28                	je     c0102681 <trap_dispatch+0x59>
c0102659:	e9 d2 00 00 00       	jmp    c0102730 <trap_dispatch+0x108>
c010265e:	83 f8 2e             	cmp    $0x2e,%eax
c0102661:	0f 82 c9 00 00 00    	jb     c0102730 <trap_dispatch+0x108>
c0102667:	83 f8 2f             	cmp    $0x2f,%eax
c010266a:	0f 86 fb 00 00 00    	jbe    c010276b <trap_dispatch+0x143>
c0102670:	83 e8 78             	sub    $0x78,%eax
c0102673:	83 f8 01             	cmp    $0x1,%eax
c0102676:	0f 87 b4 00 00 00    	ja     c0102730 <trap_dispatch+0x108>
c010267c:	e9 93 00 00 00       	jmp    c0102714 <trap_dispatch+0xec>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102681:	8b 45 08             	mov    0x8(%ebp),%eax
c0102684:	89 04 24             	mov    %eax,(%esp)
c0102687:	e8 3c ff ff ff       	call   c01025c8 <pgfault_handler>
c010268c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102693:	74 2e                	je     c01026c3 <trap_dispatch+0x9b>
            print_trapframe(tf);
c0102695:	8b 45 08             	mov    0x8(%ebp),%eax
c0102698:	89 04 24             	mov    %eax,(%esp)
c010269b:	e8 2f fc ff ff       	call   c01022cf <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c01026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026a7:	c7 44 24 08 9f a3 10 	movl   $0xc010a39f,0x8(%esp)
c01026ae:	c0 
c01026af:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01026b6:	00 
c01026b7:	c7 04 24 8e a3 10 c0 	movl   $0xc010a38e,(%esp)
c01026be:	e8 1a e6 ff ff       	call   c0100cdd <__panic>
        }
        break;
c01026c3:	e9 a4 00 00 00       	jmp    c010276c <trap_dispatch+0x144>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026c8:	e8 7e ef ff ff       	call   c010164b <cons_getc>
c01026cd:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026d0:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026d4:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026d8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026e0:	c7 04 24 ba a3 10 c0 	movl   $0xc010a3ba,(%esp)
c01026e7:	e8 67 dc ff ff       	call   c0100353 <cprintf>
        break;
c01026ec:	eb 7e                	jmp    c010276c <trap_dispatch+0x144>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026ee:	e8 58 ef ff ff       	call   c010164b <cons_getc>
c01026f3:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026f6:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026fa:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026fe:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102702:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102706:	c7 04 24 cc a3 10 c0 	movl   $0xc010a3cc,(%esp)
c010270d:	e8 41 dc ff ff       	call   c0100353 <cprintf>
        break;
c0102712:	eb 58                	jmp    c010276c <trap_dispatch+0x144>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102714:	c7 44 24 08 db a3 10 	movl   $0xc010a3db,0x8(%esp)
c010271b:	c0 
c010271c:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0102723:	00 
c0102724:	c7 04 24 8e a3 10 c0 	movl   $0xc010a38e,(%esp)
c010272b:	e8 ad e5 ff ff       	call   c0100cdd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102730:	8b 45 08             	mov    0x8(%ebp),%eax
c0102733:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102737:	0f b7 c0             	movzwl %ax,%eax
c010273a:	83 e0 03             	and    $0x3,%eax
c010273d:	85 c0                	test   %eax,%eax
c010273f:	75 2b                	jne    c010276c <trap_dispatch+0x144>
            print_trapframe(tf);
c0102741:	8b 45 08             	mov    0x8(%ebp),%eax
c0102744:	89 04 24             	mov    %eax,(%esp)
c0102747:	e8 83 fb ff ff       	call   c01022cf <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010274c:	c7 44 24 08 eb a3 10 	movl   $0xc010a3eb,0x8(%esp)
c0102753:	c0 
c0102754:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010275b:	00 
c010275c:	c7 04 24 8e a3 10 c0 	movl   $0xc010a38e,(%esp)
c0102763:	e8 75 e5 ff ff       	call   c0100cdd <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0102768:	90                   	nop
c0102769:	eb 01                	jmp    c010276c <trap_dispatch+0x144>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010276b:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010276c:	c9                   	leave  
c010276d:	c3                   	ret    

c010276e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010276e:	55                   	push   %ebp
c010276f:	89 e5                	mov    %esp,%ebp
c0102771:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102774:	8b 45 08             	mov    0x8(%ebp),%eax
c0102777:	89 04 24             	mov    %eax,(%esp)
c010277a:	e8 a9 fe ff ff       	call   c0102628 <trap_dispatch>
}
c010277f:	c9                   	leave  
c0102780:	c3                   	ret    

c0102781 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102781:	1e                   	push   %ds
    pushl %es
c0102782:	06                   	push   %es
    pushl %fs
c0102783:	0f a0                	push   %fs
    pushl %gs
c0102785:	0f a8                	push   %gs
    pushal
c0102787:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102788:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010278d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010278f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102791:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102792:	e8 d7 ff ff ff       	call   c010276e <trap>

    # pop the pushed stack pointer
    popl %esp
c0102797:	5c                   	pop    %esp

c0102798 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102798:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102799:	0f a9                	pop    %gs
    popl %fs
c010279b:	0f a1                	pop    %fs
    popl %es
c010279d:	07                   	pop    %es
    popl %ds
c010279e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010279f:	83 c4 08             	add    $0x8,%esp
    iret
c01027a2:	cf                   	iret   

c01027a3 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c01027a3:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c01027a7:	e9 ec ff ff ff       	jmp    c0102798 <__trapret>

c01027ac <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $0
c01027ae:	6a 00                	push   $0x0
  jmp __alltraps
c01027b0:	e9 cc ff ff ff       	jmp    c0102781 <__alltraps>

c01027b5 <vector1>:
.globl vector1
vector1:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $1
c01027b7:	6a 01                	push   $0x1
  jmp __alltraps
c01027b9:	e9 c3 ff ff ff       	jmp    c0102781 <__alltraps>

c01027be <vector2>:
.globl vector2
vector2:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $2
c01027c0:	6a 02                	push   $0x2
  jmp __alltraps
c01027c2:	e9 ba ff ff ff       	jmp    c0102781 <__alltraps>

c01027c7 <vector3>:
.globl vector3
vector3:
  pushl $0
c01027c7:	6a 00                	push   $0x0
  pushl $3
c01027c9:	6a 03                	push   $0x3
  jmp __alltraps
c01027cb:	e9 b1 ff ff ff       	jmp    c0102781 <__alltraps>

c01027d0 <vector4>:
.globl vector4
vector4:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $4
c01027d2:	6a 04                	push   $0x4
  jmp __alltraps
c01027d4:	e9 a8 ff ff ff       	jmp    c0102781 <__alltraps>

c01027d9 <vector5>:
.globl vector5
vector5:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $5
c01027db:	6a 05                	push   $0x5
  jmp __alltraps
c01027dd:	e9 9f ff ff ff       	jmp    c0102781 <__alltraps>

c01027e2 <vector6>:
.globl vector6
vector6:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $6
c01027e4:	6a 06                	push   $0x6
  jmp __alltraps
c01027e6:	e9 96 ff ff ff       	jmp    c0102781 <__alltraps>

c01027eb <vector7>:
.globl vector7
vector7:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $7
c01027ed:	6a 07                	push   $0x7
  jmp __alltraps
c01027ef:	e9 8d ff ff ff       	jmp    c0102781 <__alltraps>

c01027f4 <vector8>:
.globl vector8
vector8:
  pushl $8
c01027f4:	6a 08                	push   $0x8
  jmp __alltraps
c01027f6:	e9 86 ff ff ff       	jmp    c0102781 <__alltraps>

c01027fb <vector9>:
.globl vector9
vector9:
  pushl $9
c01027fb:	6a 09                	push   $0x9
  jmp __alltraps
c01027fd:	e9 7f ff ff ff       	jmp    c0102781 <__alltraps>

c0102802 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102802:	6a 0a                	push   $0xa
  jmp __alltraps
c0102804:	e9 78 ff ff ff       	jmp    c0102781 <__alltraps>

c0102809 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102809:	6a 0b                	push   $0xb
  jmp __alltraps
c010280b:	e9 71 ff ff ff       	jmp    c0102781 <__alltraps>

c0102810 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102810:	6a 0c                	push   $0xc
  jmp __alltraps
c0102812:	e9 6a ff ff ff       	jmp    c0102781 <__alltraps>

c0102817 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102817:	6a 0d                	push   $0xd
  jmp __alltraps
c0102819:	e9 63 ff ff ff       	jmp    c0102781 <__alltraps>

c010281e <vector14>:
.globl vector14
vector14:
  pushl $14
c010281e:	6a 0e                	push   $0xe
  jmp __alltraps
c0102820:	e9 5c ff ff ff       	jmp    c0102781 <__alltraps>

c0102825 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $15
c0102827:	6a 0f                	push   $0xf
  jmp __alltraps
c0102829:	e9 53 ff ff ff       	jmp    c0102781 <__alltraps>

c010282e <vector16>:
.globl vector16
vector16:
  pushl $0
c010282e:	6a 00                	push   $0x0
  pushl $16
c0102830:	6a 10                	push   $0x10
  jmp __alltraps
c0102832:	e9 4a ff ff ff       	jmp    c0102781 <__alltraps>

c0102837 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102837:	6a 11                	push   $0x11
  jmp __alltraps
c0102839:	e9 43 ff ff ff       	jmp    c0102781 <__alltraps>

c010283e <vector18>:
.globl vector18
vector18:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $18
c0102840:	6a 12                	push   $0x12
  jmp __alltraps
c0102842:	e9 3a ff ff ff       	jmp    c0102781 <__alltraps>

c0102847 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102847:	6a 00                	push   $0x0
  pushl $19
c0102849:	6a 13                	push   $0x13
  jmp __alltraps
c010284b:	e9 31 ff ff ff       	jmp    c0102781 <__alltraps>

c0102850 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $20
c0102852:	6a 14                	push   $0x14
  jmp __alltraps
c0102854:	e9 28 ff ff ff       	jmp    c0102781 <__alltraps>

c0102859 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102859:	6a 00                	push   $0x0
  pushl $21
c010285b:	6a 15                	push   $0x15
  jmp __alltraps
c010285d:	e9 1f ff ff ff       	jmp    c0102781 <__alltraps>

c0102862 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $22
c0102864:	6a 16                	push   $0x16
  jmp __alltraps
c0102866:	e9 16 ff ff ff       	jmp    c0102781 <__alltraps>

c010286b <vector23>:
.globl vector23
vector23:
  pushl $0
c010286b:	6a 00                	push   $0x0
  pushl $23
c010286d:	6a 17                	push   $0x17
  jmp __alltraps
c010286f:	e9 0d ff ff ff       	jmp    c0102781 <__alltraps>

c0102874 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $24
c0102876:	6a 18                	push   $0x18
  jmp __alltraps
c0102878:	e9 04 ff ff ff       	jmp    c0102781 <__alltraps>

c010287d <vector25>:
.globl vector25
vector25:
  pushl $0
c010287d:	6a 00                	push   $0x0
  pushl $25
c010287f:	6a 19                	push   $0x19
  jmp __alltraps
c0102881:	e9 fb fe ff ff       	jmp    c0102781 <__alltraps>

c0102886 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $26
c0102888:	6a 1a                	push   $0x1a
  jmp __alltraps
c010288a:	e9 f2 fe ff ff       	jmp    c0102781 <__alltraps>

c010288f <vector27>:
.globl vector27
vector27:
  pushl $0
c010288f:	6a 00                	push   $0x0
  pushl $27
c0102891:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102893:	e9 e9 fe ff ff       	jmp    c0102781 <__alltraps>

c0102898 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102898:	6a 00                	push   $0x0
  pushl $28
c010289a:	6a 1c                	push   $0x1c
  jmp __alltraps
c010289c:	e9 e0 fe ff ff       	jmp    c0102781 <__alltraps>

c01028a1 <vector29>:
.globl vector29
vector29:
  pushl $0
c01028a1:	6a 00                	push   $0x0
  pushl $29
c01028a3:	6a 1d                	push   $0x1d
  jmp __alltraps
c01028a5:	e9 d7 fe ff ff       	jmp    c0102781 <__alltraps>

c01028aa <vector30>:
.globl vector30
vector30:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $30
c01028ac:	6a 1e                	push   $0x1e
  jmp __alltraps
c01028ae:	e9 ce fe ff ff       	jmp    c0102781 <__alltraps>

c01028b3 <vector31>:
.globl vector31
vector31:
  pushl $0
c01028b3:	6a 00                	push   $0x0
  pushl $31
c01028b5:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028b7:	e9 c5 fe ff ff       	jmp    c0102781 <__alltraps>

c01028bc <vector32>:
.globl vector32
vector32:
  pushl $0
c01028bc:	6a 00                	push   $0x0
  pushl $32
c01028be:	6a 20                	push   $0x20
  jmp __alltraps
c01028c0:	e9 bc fe ff ff       	jmp    c0102781 <__alltraps>

c01028c5 <vector33>:
.globl vector33
vector33:
  pushl $0
c01028c5:	6a 00                	push   $0x0
  pushl $33
c01028c7:	6a 21                	push   $0x21
  jmp __alltraps
c01028c9:	e9 b3 fe ff ff       	jmp    c0102781 <__alltraps>

c01028ce <vector34>:
.globl vector34
vector34:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $34
c01028d0:	6a 22                	push   $0x22
  jmp __alltraps
c01028d2:	e9 aa fe ff ff       	jmp    c0102781 <__alltraps>

c01028d7 <vector35>:
.globl vector35
vector35:
  pushl $0
c01028d7:	6a 00                	push   $0x0
  pushl $35
c01028d9:	6a 23                	push   $0x23
  jmp __alltraps
c01028db:	e9 a1 fe ff ff       	jmp    c0102781 <__alltraps>

c01028e0 <vector36>:
.globl vector36
vector36:
  pushl $0
c01028e0:	6a 00                	push   $0x0
  pushl $36
c01028e2:	6a 24                	push   $0x24
  jmp __alltraps
c01028e4:	e9 98 fe ff ff       	jmp    c0102781 <__alltraps>

c01028e9 <vector37>:
.globl vector37
vector37:
  pushl $0
c01028e9:	6a 00                	push   $0x0
  pushl $37
c01028eb:	6a 25                	push   $0x25
  jmp __alltraps
c01028ed:	e9 8f fe ff ff       	jmp    c0102781 <__alltraps>

c01028f2 <vector38>:
.globl vector38
vector38:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $38
c01028f4:	6a 26                	push   $0x26
  jmp __alltraps
c01028f6:	e9 86 fe ff ff       	jmp    c0102781 <__alltraps>

c01028fb <vector39>:
.globl vector39
vector39:
  pushl $0
c01028fb:	6a 00                	push   $0x0
  pushl $39
c01028fd:	6a 27                	push   $0x27
  jmp __alltraps
c01028ff:	e9 7d fe ff ff       	jmp    c0102781 <__alltraps>

c0102904 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $40
c0102906:	6a 28                	push   $0x28
  jmp __alltraps
c0102908:	e9 74 fe ff ff       	jmp    c0102781 <__alltraps>

c010290d <vector41>:
.globl vector41
vector41:
  pushl $0
c010290d:	6a 00                	push   $0x0
  pushl $41
c010290f:	6a 29                	push   $0x29
  jmp __alltraps
c0102911:	e9 6b fe ff ff       	jmp    c0102781 <__alltraps>

c0102916 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $42
c0102918:	6a 2a                	push   $0x2a
  jmp __alltraps
c010291a:	e9 62 fe ff ff       	jmp    c0102781 <__alltraps>

c010291f <vector43>:
.globl vector43
vector43:
  pushl $0
c010291f:	6a 00                	push   $0x0
  pushl $43
c0102921:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102923:	e9 59 fe ff ff       	jmp    c0102781 <__alltraps>

c0102928 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $44
c010292a:	6a 2c                	push   $0x2c
  jmp __alltraps
c010292c:	e9 50 fe ff ff       	jmp    c0102781 <__alltraps>

c0102931 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102931:	6a 00                	push   $0x0
  pushl $45
c0102933:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102935:	e9 47 fe ff ff       	jmp    c0102781 <__alltraps>

c010293a <vector46>:
.globl vector46
vector46:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $46
c010293c:	6a 2e                	push   $0x2e
  jmp __alltraps
c010293e:	e9 3e fe ff ff       	jmp    c0102781 <__alltraps>

c0102943 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102943:	6a 00                	push   $0x0
  pushl $47
c0102945:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102947:	e9 35 fe ff ff       	jmp    c0102781 <__alltraps>

c010294c <vector48>:
.globl vector48
vector48:
  pushl $0
c010294c:	6a 00                	push   $0x0
  pushl $48
c010294e:	6a 30                	push   $0x30
  jmp __alltraps
c0102950:	e9 2c fe ff ff       	jmp    c0102781 <__alltraps>

c0102955 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102955:	6a 00                	push   $0x0
  pushl $49
c0102957:	6a 31                	push   $0x31
  jmp __alltraps
c0102959:	e9 23 fe ff ff       	jmp    c0102781 <__alltraps>

c010295e <vector50>:
.globl vector50
vector50:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $50
c0102960:	6a 32                	push   $0x32
  jmp __alltraps
c0102962:	e9 1a fe ff ff       	jmp    c0102781 <__alltraps>

c0102967 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $51
c0102969:	6a 33                	push   $0x33
  jmp __alltraps
c010296b:	e9 11 fe ff ff       	jmp    c0102781 <__alltraps>

c0102970 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $52
c0102972:	6a 34                	push   $0x34
  jmp __alltraps
c0102974:	e9 08 fe ff ff       	jmp    c0102781 <__alltraps>

c0102979 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102979:	6a 00                	push   $0x0
  pushl $53
c010297b:	6a 35                	push   $0x35
  jmp __alltraps
c010297d:	e9 ff fd ff ff       	jmp    c0102781 <__alltraps>

c0102982 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $54
c0102984:	6a 36                	push   $0x36
  jmp __alltraps
c0102986:	e9 f6 fd ff ff       	jmp    c0102781 <__alltraps>

c010298b <vector55>:
.globl vector55
vector55:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $55
c010298d:	6a 37                	push   $0x37
  jmp __alltraps
c010298f:	e9 ed fd ff ff       	jmp    c0102781 <__alltraps>

c0102994 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102994:	6a 00                	push   $0x0
  pushl $56
c0102996:	6a 38                	push   $0x38
  jmp __alltraps
c0102998:	e9 e4 fd ff ff       	jmp    c0102781 <__alltraps>

c010299d <vector57>:
.globl vector57
vector57:
  pushl $0
c010299d:	6a 00                	push   $0x0
  pushl $57
c010299f:	6a 39                	push   $0x39
  jmp __alltraps
c01029a1:	e9 db fd ff ff       	jmp    c0102781 <__alltraps>

c01029a6 <vector58>:
.globl vector58
vector58:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $58
c01029a8:	6a 3a                	push   $0x3a
  jmp __alltraps
c01029aa:	e9 d2 fd ff ff       	jmp    c0102781 <__alltraps>

c01029af <vector59>:
.globl vector59
vector59:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $59
c01029b1:	6a 3b                	push   $0x3b
  jmp __alltraps
c01029b3:	e9 c9 fd ff ff       	jmp    c0102781 <__alltraps>

c01029b8 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029b8:	6a 00                	push   $0x0
  pushl $60
c01029ba:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029bc:	e9 c0 fd ff ff       	jmp    c0102781 <__alltraps>

c01029c1 <vector61>:
.globl vector61
vector61:
  pushl $0
c01029c1:	6a 00                	push   $0x0
  pushl $61
c01029c3:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029c5:	e9 b7 fd ff ff       	jmp    c0102781 <__alltraps>

c01029ca <vector62>:
.globl vector62
vector62:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $62
c01029cc:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029ce:	e9 ae fd ff ff       	jmp    c0102781 <__alltraps>

c01029d3 <vector63>:
.globl vector63
vector63:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $63
c01029d5:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029d7:	e9 a5 fd ff ff       	jmp    c0102781 <__alltraps>

c01029dc <vector64>:
.globl vector64
vector64:
  pushl $0
c01029dc:	6a 00                	push   $0x0
  pushl $64
c01029de:	6a 40                	push   $0x40
  jmp __alltraps
c01029e0:	e9 9c fd ff ff       	jmp    c0102781 <__alltraps>

c01029e5 <vector65>:
.globl vector65
vector65:
  pushl $0
c01029e5:	6a 00                	push   $0x0
  pushl $65
c01029e7:	6a 41                	push   $0x41
  jmp __alltraps
c01029e9:	e9 93 fd ff ff       	jmp    c0102781 <__alltraps>

c01029ee <vector66>:
.globl vector66
vector66:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $66
c01029f0:	6a 42                	push   $0x42
  jmp __alltraps
c01029f2:	e9 8a fd ff ff       	jmp    c0102781 <__alltraps>

c01029f7 <vector67>:
.globl vector67
vector67:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $67
c01029f9:	6a 43                	push   $0x43
  jmp __alltraps
c01029fb:	e9 81 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a00 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102a00:	6a 00                	push   $0x0
  pushl $68
c0102a02:	6a 44                	push   $0x44
  jmp __alltraps
c0102a04:	e9 78 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a09 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102a09:	6a 00                	push   $0x0
  pushl $69
c0102a0b:	6a 45                	push   $0x45
  jmp __alltraps
c0102a0d:	e9 6f fd ff ff       	jmp    c0102781 <__alltraps>

c0102a12 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $70
c0102a14:	6a 46                	push   $0x46
  jmp __alltraps
c0102a16:	e9 66 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a1b <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $71
c0102a1d:	6a 47                	push   $0x47
  jmp __alltraps
c0102a1f:	e9 5d fd ff ff       	jmp    c0102781 <__alltraps>

c0102a24 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a24:	6a 00                	push   $0x0
  pushl $72
c0102a26:	6a 48                	push   $0x48
  jmp __alltraps
c0102a28:	e9 54 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a2d <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $73
c0102a2f:	6a 49                	push   $0x49
  jmp __alltraps
c0102a31:	e9 4b fd ff ff       	jmp    c0102781 <__alltraps>

c0102a36 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $74
c0102a38:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a3a:	e9 42 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a3f <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $75
c0102a41:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a43:	e9 39 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a48 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a48:	6a 00                	push   $0x0
  pushl $76
c0102a4a:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a4c:	e9 30 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a51 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $77
c0102a53:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a55:	e9 27 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a5a <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $78
c0102a5c:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a5e:	e9 1e fd ff ff       	jmp    c0102781 <__alltraps>

c0102a63 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $79
c0102a65:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a67:	e9 15 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a6c <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a6c:	6a 00                	push   $0x0
  pushl $80
c0102a6e:	6a 50                	push   $0x50
  jmp __alltraps
c0102a70:	e9 0c fd ff ff       	jmp    c0102781 <__alltraps>

c0102a75 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $81
c0102a77:	6a 51                	push   $0x51
  jmp __alltraps
c0102a79:	e9 03 fd ff ff       	jmp    c0102781 <__alltraps>

c0102a7e <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $82
c0102a80:	6a 52                	push   $0x52
  jmp __alltraps
c0102a82:	e9 fa fc ff ff       	jmp    c0102781 <__alltraps>

c0102a87 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $83
c0102a89:	6a 53                	push   $0x53
  jmp __alltraps
c0102a8b:	e9 f1 fc ff ff       	jmp    c0102781 <__alltraps>

c0102a90 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a90:	6a 00                	push   $0x0
  pushl $84
c0102a92:	6a 54                	push   $0x54
  jmp __alltraps
c0102a94:	e9 e8 fc ff ff       	jmp    c0102781 <__alltraps>

c0102a99 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $85
c0102a9b:	6a 55                	push   $0x55
  jmp __alltraps
c0102a9d:	e9 df fc ff ff       	jmp    c0102781 <__alltraps>

c0102aa2 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $86
c0102aa4:	6a 56                	push   $0x56
  jmp __alltraps
c0102aa6:	e9 d6 fc ff ff       	jmp    c0102781 <__alltraps>

c0102aab <vector87>:
.globl vector87
vector87:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $87
c0102aad:	6a 57                	push   $0x57
  jmp __alltraps
c0102aaf:	e9 cd fc ff ff       	jmp    c0102781 <__alltraps>

c0102ab4 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102ab4:	6a 00                	push   $0x0
  pushl $88
c0102ab6:	6a 58                	push   $0x58
  jmp __alltraps
c0102ab8:	e9 c4 fc ff ff       	jmp    c0102781 <__alltraps>

c0102abd <vector89>:
.globl vector89
vector89:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $89
c0102abf:	6a 59                	push   $0x59
  jmp __alltraps
c0102ac1:	e9 bb fc ff ff       	jmp    c0102781 <__alltraps>

c0102ac6 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $90
c0102ac8:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102aca:	e9 b2 fc ff ff       	jmp    c0102781 <__alltraps>

c0102acf <vector91>:
.globl vector91
vector91:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $91
c0102ad1:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102ad3:	e9 a9 fc ff ff       	jmp    c0102781 <__alltraps>

c0102ad8 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102ad8:	6a 00                	push   $0x0
  pushl $92
c0102ada:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102adc:	e9 a0 fc ff ff       	jmp    c0102781 <__alltraps>

c0102ae1 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $93
c0102ae3:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102ae5:	e9 97 fc ff ff       	jmp    c0102781 <__alltraps>

c0102aea <vector94>:
.globl vector94
vector94:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $94
c0102aec:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102aee:	e9 8e fc ff ff       	jmp    c0102781 <__alltraps>

c0102af3 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $95
c0102af5:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102af7:	e9 85 fc ff ff       	jmp    c0102781 <__alltraps>

c0102afc <vector96>:
.globl vector96
vector96:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $96
c0102afe:	6a 60                	push   $0x60
  jmp __alltraps
c0102b00:	e9 7c fc ff ff       	jmp    c0102781 <__alltraps>

c0102b05 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $97
c0102b07:	6a 61                	push   $0x61
  jmp __alltraps
c0102b09:	e9 73 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b0e <vector98>:
.globl vector98
vector98:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $98
c0102b10:	6a 62                	push   $0x62
  jmp __alltraps
c0102b12:	e9 6a fc ff ff       	jmp    c0102781 <__alltraps>

c0102b17 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $99
c0102b19:	6a 63                	push   $0x63
  jmp __alltraps
c0102b1b:	e9 61 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b20 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $100
c0102b22:	6a 64                	push   $0x64
  jmp __alltraps
c0102b24:	e9 58 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b29 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $101
c0102b2b:	6a 65                	push   $0x65
  jmp __alltraps
c0102b2d:	e9 4f fc ff ff       	jmp    c0102781 <__alltraps>

c0102b32 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $102
c0102b34:	6a 66                	push   $0x66
  jmp __alltraps
c0102b36:	e9 46 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b3b <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $103
c0102b3d:	6a 67                	push   $0x67
  jmp __alltraps
c0102b3f:	e9 3d fc ff ff       	jmp    c0102781 <__alltraps>

c0102b44 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $104
c0102b46:	6a 68                	push   $0x68
  jmp __alltraps
c0102b48:	e9 34 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b4d <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $105
c0102b4f:	6a 69                	push   $0x69
  jmp __alltraps
c0102b51:	e9 2b fc ff ff       	jmp    c0102781 <__alltraps>

c0102b56 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $106
c0102b58:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b5a:	e9 22 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b5f <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $107
c0102b61:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b63:	e9 19 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b68 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $108
c0102b6a:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b6c:	e9 10 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b71 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $109
c0102b73:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b75:	e9 07 fc ff ff       	jmp    c0102781 <__alltraps>

c0102b7a <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $110
c0102b7c:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b7e:	e9 fe fb ff ff       	jmp    c0102781 <__alltraps>

c0102b83 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $111
c0102b85:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b87:	e9 f5 fb ff ff       	jmp    c0102781 <__alltraps>

c0102b8c <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $112
c0102b8e:	6a 70                	push   $0x70
  jmp __alltraps
c0102b90:	e9 ec fb ff ff       	jmp    c0102781 <__alltraps>

c0102b95 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $113
c0102b97:	6a 71                	push   $0x71
  jmp __alltraps
c0102b99:	e9 e3 fb ff ff       	jmp    c0102781 <__alltraps>

c0102b9e <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $114
c0102ba0:	6a 72                	push   $0x72
  jmp __alltraps
c0102ba2:	e9 da fb ff ff       	jmp    c0102781 <__alltraps>

c0102ba7 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $115
c0102ba9:	6a 73                	push   $0x73
  jmp __alltraps
c0102bab:	e9 d1 fb ff ff       	jmp    c0102781 <__alltraps>

c0102bb0 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $116
c0102bb2:	6a 74                	push   $0x74
  jmp __alltraps
c0102bb4:	e9 c8 fb ff ff       	jmp    c0102781 <__alltraps>

c0102bb9 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $117
c0102bbb:	6a 75                	push   $0x75
  jmp __alltraps
c0102bbd:	e9 bf fb ff ff       	jmp    c0102781 <__alltraps>

c0102bc2 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $118
c0102bc4:	6a 76                	push   $0x76
  jmp __alltraps
c0102bc6:	e9 b6 fb ff ff       	jmp    c0102781 <__alltraps>

c0102bcb <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $119
c0102bcd:	6a 77                	push   $0x77
  jmp __alltraps
c0102bcf:	e9 ad fb ff ff       	jmp    c0102781 <__alltraps>

c0102bd4 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $120
c0102bd6:	6a 78                	push   $0x78
  jmp __alltraps
c0102bd8:	e9 a4 fb ff ff       	jmp    c0102781 <__alltraps>

c0102bdd <vector121>:
.globl vector121
vector121:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $121
c0102bdf:	6a 79                	push   $0x79
  jmp __alltraps
c0102be1:	e9 9b fb ff ff       	jmp    c0102781 <__alltraps>

c0102be6 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $122
c0102be8:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102bea:	e9 92 fb ff ff       	jmp    c0102781 <__alltraps>

c0102bef <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $123
c0102bf1:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102bf3:	e9 89 fb ff ff       	jmp    c0102781 <__alltraps>

c0102bf8 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $124
c0102bfa:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102bfc:	e9 80 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c01 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $125
c0102c03:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102c05:	e9 77 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c0a <vector126>:
.globl vector126
vector126:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $126
c0102c0c:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102c0e:	e9 6e fb ff ff       	jmp    c0102781 <__alltraps>

c0102c13 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $127
c0102c15:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c17:	e9 65 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c1c <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $128
c0102c1e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c23:	e9 59 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c28 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $129
c0102c2a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c2f:	e9 4d fb ff ff       	jmp    c0102781 <__alltraps>

c0102c34 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $130
c0102c36:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c3b:	e9 41 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c40 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $131
c0102c42:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c47:	e9 35 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c4c <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $132
c0102c4e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c53:	e9 29 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c58 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $133
c0102c5a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c5f:	e9 1d fb ff ff       	jmp    c0102781 <__alltraps>

c0102c64 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $134
c0102c66:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c6b:	e9 11 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c70 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $135
c0102c72:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c77:	e9 05 fb ff ff       	jmp    c0102781 <__alltraps>

c0102c7c <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $136
c0102c7e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c83:	e9 f9 fa ff ff       	jmp    c0102781 <__alltraps>

c0102c88 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $137
c0102c8a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c8f:	e9 ed fa ff ff       	jmp    c0102781 <__alltraps>

c0102c94 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $138
c0102c96:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c9b:	e9 e1 fa ff ff       	jmp    c0102781 <__alltraps>

c0102ca0 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $139
c0102ca2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102ca7:	e9 d5 fa ff ff       	jmp    c0102781 <__alltraps>

c0102cac <vector140>:
.globl vector140
vector140:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $140
c0102cae:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102cb3:	e9 c9 fa ff ff       	jmp    c0102781 <__alltraps>

c0102cb8 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $141
c0102cba:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102cbf:	e9 bd fa ff ff       	jmp    c0102781 <__alltraps>

c0102cc4 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $142
c0102cc6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102ccb:	e9 b1 fa ff ff       	jmp    c0102781 <__alltraps>

c0102cd0 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $143
c0102cd2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cd7:	e9 a5 fa ff ff       	jmp    c0102781 <__alltraps>

c0102cdc <vector144>:
.globl vector144
vector144:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $144
c0102cde:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ce3:	e9 99 fa ff ff       	jmp    c0102781 <__alltraps>

c0102ce8 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $145
c0102cea:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cef:	e9 8d fa ff ff       	jmp    c0102781 <__alltraps>

c0102cf4 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $146
c0102cf6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102cfb:	e9 81 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d00 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $147
c0102d02:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102d07:	e9 75 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d0c <vector148>:
.globl vector148
vector148:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $148
c0102d0e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102d13:	e9 69 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d18 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $149
c0102d1a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d1f:	e9 5d fa ff ff       	jmp    c0102781 <__alltraps>

c0102d24 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $150
c0102d26:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d2b:	e9 51 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d30 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $151
c0102d32:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d37:	e9 45 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d3c <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $152
c0102d3e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d43:	e9 39 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d48 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $153
c0102d4a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d4f:	e9 2d fa ff ff       	jmp    c0102781 <__alltraps>

c0102d54 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $154
c0102d56:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d5b:	e9 21 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d60 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $155
c0102d62:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d67:	e9 15 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d6c <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $156
c0102d6e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d73:	e9 09 fa ff ff       	jmp    c0102781 <__alltraps>

c0102d78 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $157
c0102d7a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d7f:	e9 fd f9 ff ff       	jmp    c0102781 <__alltraps>

c0102d84 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $158
c0102d86:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d8b:	e9 f1 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102d90 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $159
c0102d92:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d97:	e9 e5 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102d9c <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $160
c0102d9e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102da3:	e9 d9 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102da8 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $161
c0102daa:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102daf:	e9 cd f9 ff ff       	jmp    c0102781 <__alltraps>

c0102db4 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $162
c0102db6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102dbb:	e9 c1 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102dc0 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $163
c0102dc2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102dc7:	e9 b5 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102dcc <vector164>:
.globl vector164
vector164:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $164
c0102dce:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102dd3:	e9 a9 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102dd8 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $165
c0102dda:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ddf:	e9 9d f9 ff ff       	jmp    c0102781 <__alltraps>

c0102de4 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $166
c0102de6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102deb:	e9 91 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102df0 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $167
c0102df2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102df7:	e9 85 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102dfc <vector168>:
.globl vector168
vector168:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $168
c0102dfe:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102e03:	e9 79 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e08 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $169
c0102e0a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102e0f:	e9 6d f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e14 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $170
c0102e16:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e1b:	e9 61 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e20 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $171
c0102e22:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e27:	e9 55 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e2c <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $172
c0102e2e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e33:	e9 49 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e38 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $173
c0102e3a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e3f:	e9 3d f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e44 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $174
c0102e46:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e4b:	e9 31 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e50 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $175
c0102e52:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e57:	e9 25 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e5c <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $176
c0102e5e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e63:	e9 19 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e68 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $177
c0102e6a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e6f:	e9 0d f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e74 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $178
c0102e76:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e7b:	e9 01 f9 ff ff       	jmp    c0102781 <__alltraps>

c0102e80 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $179
c0102e82:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e87:	e9 f5 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102e8c <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $180
c0102e8e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e93:	e9 e9 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102e98 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $181
c0102e9a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e9f:	e9 dd f8 ff ff       	jmp    c0102781 <__alltraps>

c0102ea4 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $182
c0102ea6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102eab:	e9 d1 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102eb0 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $183
c0102eb2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102eb7:	e9 c5 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102ebc <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $184
c0102ebe:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102ec3:	e9 b9 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102ec8 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $185
c0102eca:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102ecf:	e9 ad f8 ff ff       	jmp    c0102781 <__alltraps>

c0102ed4 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $186
c0102ed6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102edb:	e9 a1 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102ee0 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $187
c0102ee2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ee7:	e9 95 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102eec <vector188>:
.globl vector188
vector188:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $188
c0102eee:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102ef3:	e9 89 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102ef8 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $189
c0102efa:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102eff:	e9 7d f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f04 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $190
c0102f06:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102f0b:	e9 71 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f10 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $191
c0102f12:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f17:	e9 65 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f1c <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $192
c0102f1e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f23:	e9 59 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f28 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $193
c0102f2a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f2f:	e9 4d f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f34 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $194
c0102f36:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f3b:	e9 41 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f40 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $195
c0102f42:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f47:	e9 35 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f4c <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $196
c0102f4e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f53:	e9 29 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f58 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $197
c0102f5a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f5f:	e9 1d f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f64 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $198
c0102f66:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f6b:	e9 11 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f70 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $199
c0102f72:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f77:	e9 05 f8 ff ff       	jmp    c0102781 <__alltraps>

c0102f7c <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $200
c0102f7e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f83:	e9 f9 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102f88 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $201
c0102f8a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f8f:	e9 ed f7 ff ff       	jmp    c0102781 <__alltraps>

c0102f94 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $202
c0102f96:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f9b:	e9 e1 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fa0 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $203
c0102fa2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102fa7:	e9 d5 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fac <vector204>:
.globl vector204
vector204:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $204
c0102fae:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102fb3:	e9 c9 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fb8 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $205
c0102fba:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fbf:	e9 bd f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fc4 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $206
c0102fc6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fcb:	e9 b1 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fd0 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $207
c0102fd2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102fd7:	e9 a5 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fdc <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $208
c0102fde:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102fe3:	e9 99 f7 ff ff       	jmp    c0102781 <__alltraps>

c0102fe8 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $209
c0102fea:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fef:	e9 8d f7 ff ff       	jmp    c0102781 <__alltraps>

c0102ff4 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $210
c0102ff6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102ffb:	e9 81 f7 ff ff       	jmp    c0102781 <__alltraps>

c0103000 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $211
c0103002:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103007:	e9 75 f7 ff ff       	jmp    c0102781 <__alltraps>

c010300c <vector212>:
.globl vector212
vector212:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $212
c010300e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103013:	e9 69 f7 ff ff       	jmp    c0102781 <__alltraps>

c0103018 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $213
c010301a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010301f:	e9 5d f7 ff ff       	jmp    c0102781 <__alltraps>

c0103024 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $214
c0103026:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010302b:	e9 51 f7 ff ff       	jmp    c0102781 <__alltraps>

c0103030 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $215
c0103032:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103037:	e9 45 f7 ff ff       	jmp    c0102781 <__alltraps>

c010303c <vector216>:
.globl vector216
vector216:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $216
c010303e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103043:	e9 39 f7 ff ff       	jmp    c0102781 <__alltraps>

c0103048 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $217
c010304a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010304f:	e9 2d f7 ff ff       	jmp    c0102781 <__alltraps>

c0103054 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $218
c0103056:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010305b:	e9 21 f7 ff ff       	jmp    c0102781 <__alltraps>

c0103060 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $219
c0103062:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103067:	e9 15 f7 ff ff       	jmp    c0102781 <__alltraps>

c010306c <vector220>:
.globl vector220
vector220:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $220
c010306e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103073:	e9 09 f7 ff ff       	jmp    c0102781 <__alltraps>

c0103078 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $221
c010307a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010307f:	e9 fd f6 ff ff       	jmp    c0102781 <__alltraps>

c0103084 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $222
c0103086:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010308b:	e9 f1 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103090 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $223
c0103092:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103097:	e9 e5 f6 ff ff       	jmp    c0102781 <__alltraps>

c010309c <vector224>:
.globl vector224
vector224:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $224
c010309e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01030a3:	e9 d9 f6 ff ff       	jmp    c0102781 <__alltraps>

c01030a8 <vector225>:
.globl vector225
vector225:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $225
c01030aa:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01030af:	e9 cd f6 ff ff       	jmp    c0102781 <__alltraps>

c01030b4 <vector226>:
.globl vector226
vector226:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $226
c01030b6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030bb:	e9 c1 f6 ff ff       	jmp    c0102781 <__alltraps>

c01030c0 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $227
c01030c2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030c7:	e9 b5 f6 ff ff       	jmp    c0102781 <__alltraps>

c01030cc <vector228>:
.globl vector228
vector228:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $228
c01030ce:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030d3:	e9 a9 f6 ff ff       	jmp    c0102781 <__alltraps>

c01030d8 <vector229>:
.globl vector229
vector229:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $229
c01030da:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030df:	e9 9d f6 ff ff       	jmp    c0102781 <__alltraps>

c01030e4 <vector230>:
.globl vector230
vector230:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $230
c01030e6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030eb:	e9 91 f6 ff ff       	jmp    c0102781 <__alltraps>

c01030f0 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $231
c01030f2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030f7:	e9 85 f6 ff ff       	jmp    c0102781 <__alltraps>

c01030fc <vector232>:
.globl vector232
vector232:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $232
c01030fe:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103103:	e9 79 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103108 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $233
c010310a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010310f:	e9 6d f6 ff ff       	jmp    c0102781 <__alltraps>

c0103114 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $234
c0103116:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010311b:	e9 61 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103120 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $235
c0103122:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103127:	e9 55 f6 ff ff       	jmp    c0102781 <__alltraps>

c010312c <vector236>:
.globl vector236
vector236:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $236
c010312e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103133:	e9 49 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103138 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $237
c010313a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010313f:	e9 3d f6 ff ff       	jmp    c0102781 <__alltraps>

c0103144 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $238
c0103146:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010314b:	e9 31 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103150 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $239
c0103152:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103157:	e9 25 f6 ff ff       	jmp    c0102781 <__alltraps>

c010315c <vector240>:
.globl vector240
vector240:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $240
c010315e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103163:	e9 19 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103168 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $241
c010316a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010316f:	e9 0d f6 ff ff       	jmp    c0102781 <__alltraps>

c0103174 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $242
c0103176:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010317b:	e9 01 f6 ff ff       	jmp    c0102781 <__alltraps>

c0103180 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $243
c0103182:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103187:	e9 f5 f5 ff ff       	jmp    c0102781 <__alltraps>

c010318c <vector244>:
.globl vector244
vector244:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $244
c010318e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103193:	e9 e9 f5 ff ff       	jmp    c0102781 <__alltraps>

c0103198 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $245
c010319a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010319f:	e9 dd f5 ff ff       	jmp    c0102781 <__alltraps>

c01031a4 <vector246>:
.globl vector246
vector246:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $246
c01031a6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01031ab:	e9 d1 f5 ff ff       	jmp    c0102781 <__alltraps>

c01031b0 <vector247>:
.globl vector247
vector247:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $247
c01031b2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031b7:	e9 c5 f5 ff ff       	jmp    c0102781 <__alltraps>

c01031bc <vector248>:
.globl vector248
vector248:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $248
c01031be:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031c3:	e9 b9 f5 ff ff       	jmp    c0102781 <__alltraps>

c01031c8 <vector249>:
.globl vector249
vector249:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $249
c01031ca:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031cf:	e9 ad f5 ff ff       	jmp    c0102781 <__alltraps>

c01031d4 <vector250>:
.globl vector250
vector250:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $250
c01031d6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031db:	e9 a1 f5 ff ff       	jmp    c0102781 <__alltraps>

c01031e0 <vector251>:
.globl vector251
vector251:
  pushl $0
c01031e0:	6a 00                	push   $0x0
  pushl $251
c01031e2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031e7:	e9 95 f5 ff ff       	jmp    c0102781 <__alltraps>

c01031ec <vector252>:
.globl vector252
vector252:
  pushl $0
c01031ec:	6a 00                	push   $0x0
  pushl $252
c01031ee:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031f3:	e9 89 f5 ff ff       	jmp    c0102781 <__alltraps>

c01031f8 <vector253>:
.globl vector253
vector253:
  pushl $0
c01031f8:	6a 00                	push   $0x0
  pushl $253
c01031fa:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031ff:	e9 7d f5 ff ff       	jmp    c0102781 <__alltraps>

c0103204 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103204:	6a 00                	push   $0x0
  pushl $254
c0103206:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010320b:	e9 71 f5 ff ff       	jmp    c0102781 <__alltraps>

c0103210 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103210:	6a 00                	push   $0x0
  pushl $255
c0103212:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103217:	e9 65 f5 ff ff       	jmp    c0102781 <__alltraps>

c010321c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010321c:	55                   	push   %ebp
c010321d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010321f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103222:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0103227:	29 c2                	sub    %eax,%edx
c0103229:	89 d0                	mov    %edx,%eax
c010322b:	c1 f8 05             	sar    $0x5,%eax
}
c010322e:	5d                   	pop    %ebp
c010322f:	c3                   	ret    

c0103230 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103230:	55                   	push   %ebp
c0103231:	89 e5                	mov    %esp,%ebp
c0103233:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103236:	8b 45 08             	mov    0x8(%ebp),%eax
c0103239:	89 04 24             	mov    %eax,(%esp)
c010323c:	e8 db ff ff ff       	call   c010321c <page2ppn>
c0103241:	c1 e0 0c             	shl    $0xc,%eax
}
c0103244:	c9                   	leave  
c0103245:	c3                   	ret    

c0103246 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103246:	55                   	push   %ebp
c0103247:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103249:	8b 45 08             	mov    0x8(%ebp),%eax
c010324c:	8b 00                	mov    (%eax),%eax
}
c010324e:	5d                   	pop    %ebp
c010324f:	c3                   	ret    

c0103250 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103250:	55                   	push   %ebp
c0103251:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103253:	8b 45 08             	mov    0x8(%ebp),%eax
c0103256:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103259:	89 10                	mov    %edx,(%eax)
}
c010325b:	5d                   	pop    %ebp
c010325c:	c3                   	ret    

c010325d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010325d:	55                   	push   %ebp
c010325e:	89 e5                	mov    %esp,%ebp
c0103260:	83 ec 10             	sub    $0x10,%esp
c0103263:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010326a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010326d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103270:	89 50 04             	mov    %edx,0x4(%eax)
c0103273:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103276:	8b 50 04             	mov    0x4(%eax),%edx
c0103279:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010327c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010327e:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103285:	00 00 00 
}
c0103288:	c9                   	leave  
c0103289:	c3                   	ret    

c010328a <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010328a:	55                   	push   %ebp
c010328b:	89 e5                	mov    %esp,%ebp
c010328d:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103290:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103294:	75 24                	jne    c01032ba <default_init_memmap+0x30>
c0103296:	c7 44 24 0c b0 a5 10 	movl   $0xc010a5b0,0xc(%esp)
c010329d:	c0 
c010329e:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01032a5:	c0 
c01032a6:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01032ad:	00 
c01032ae:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01032b5:	e8 23 da ff ff       	call   c0100cdd <__panic>
    struct Page *p = base;
c01032ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01032bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01032c0:	eb 7d                	jmp    c010333f <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c5:	83 c0 04             	add    $0x4,%eax
c01032c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032d8:	0f a3 10             	bt     %edx,(%eax)
c01032db:	19 c0                	sbb    %eax,%eax
c01032dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01032e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032e4:	0f 95 c0             	setne  %al
c01032e7:	0f b6 c0             	movzbl %al,%eax
c01032ea:	85 c0                	test   %eax,%eax
c01032ec:	75 24                	jne    c0103312 <default_init_memmap+0x88>
c01032ee:	c7 44 24 0c e1 a5 10 	movl   $0xc010a5e1,0xc(%esp)
c01032f5:	c0 
c01032f6:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01032fd:	c0 
c01032fe:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103305:	00 
c0103306:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010330d:	e8 cb d9 ff ff       	call   c0100cdd <__panic>
        p->flags = p->property = 0;
c0103312:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103315:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331f:	8b 50 08             	mov    0x8(%eax),%edx
c0103322:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103325:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0103328:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010332f:	00 
c0103330:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103333:	89 04 24             	mov    %eax,(%esp)
c0103336:	e8 15 ff ff ff       	call   c0103250 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010333b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010333f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103342:	c1 e0 05             	shl    $0x5,%eax
c0103345:	89 c2                	mov    %eax,%edx
c0103347:	8b 45 08             	mov    0x8(%ebp),%eax
c010334a:	01 d0                	add    %edx,%eax
c010334c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010334f:	0f 85 6d ff ff ff    	jne    c01032c2 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0103355:	8b 45 08             	mov    0x8(%ebp),%eax
c0103358:	8b 55 0c             	mov    0xc(%ebp),%edx
c010335b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010335e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103361:	83 c0 04             	add    $0x4,%eax
c0103364:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010336b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010336e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103371:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103374:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0103377:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c010337d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103380:	01 d0                	add    %edx,%eax
c0103382:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    list_add(&free_list, &(base->page_link));
c0103387:	8b 45 08             	mov    0x8(%ebp),%eax
c010338a:	83 c0 0c             	add    $0xc,%eax
c010338d:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c0103394:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103397:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010339a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010339d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01033a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01033a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033a6:	8b 40 04             	mov    0x4(%eax),%eax
c01033a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033ac:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01033af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033b2:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01033b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01033b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033bb:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01033be:	89 10                	mov    %edx,(%eax)
c01033c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033c3:	8b 10                	mov    (%eax),%edx
c01033c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01033c8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01033cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033ce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01033d1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01033d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033d7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01033da:	89 10                	mov    %edx,(%eax)
}
c01033dc:	c9                   	leave  
c01033dd:	c3                   	ret    

c01033de <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01033de:	55                   	push   %ebp
c01033df:	89 e5                	mov    %esp,%ebp
c01033e1:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01033e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033e8:	75 24                	jne    c010340e <default_alloc_pages+0x30>
c01033ea:	c7 44 24 0c b0 a5 10 	movl   $0xc010a5b0,0xc(%esp)
c01033f1:	c0 
c01033f2:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01033f9:	c0 
c01033fa:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0103401:	00 
c0103402:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103409:	e8 cf d8 ff ff       	call   c0100cdd <__panic>
    if (n > nr_free) {
c010340e:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103413:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103416:	73 0a                	jae    c0103422 <default_alloc_pages+0x44>
        return NULL;
c0103418:	b8 00 00 00 00       	mov    $0x0,%eax
c010341d:	e9 36 01 00 00       	jmp    c0103558 <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c0103422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103429:	c7 45 f0 18 7b 12 c0 	movl   $0xc0127b18,-0x10(%ebp)
 
// Step1：找到第一个长度大于等于n的块
    while ((le = list_next(le)) != &free_list) {
c0103430:	eb 1c                	jmp    c010344e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0103432:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103435:	83 e8 0c             	sub    $0xc,%eax
c0103438:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010343b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010343e:	8b 40 08             	mov    0x8(%eax),%eax
c0103441:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103444:	72 08                	jb     c010344e <default_alloc_pages+0x70>
            page = p;
c0103446:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103449:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010344c:	eb 18                	jmp    c0103466 <default_alloc_pages+0x88>
c010344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103451:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103457:	8b 40 04             	mov    0x4(%eax),%eax
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
 
// Step1：找到第一个长度大于等于n的块
    while ((le = list_next(le)) != &free_list) {
c010345a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010345d:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c0103464:	75 cc                	jne    c0103432 <default_alloc_pages+0x54>
    }
 
// Step2：如果可以找到长度大于等于n的块，则
// (1) 如果长度大于n，在从这个块中取走长度为n的存储空间，并将剩下的存储空间插入到列表中
// (2) 删除原来的块
    if (page != NULL) {
c0103466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010346a:	0f 84 e5 00 00 00    	je     c0103555 <default_alloc_pages+0x177>
        if (page->property > n) {
c0103470:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103473:	8b 40 08             	mov    0x8(%eax),%eax
c0103476:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103479:	0f 86 85 00 00 00    	jbe    c0103504 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c010347f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103482:	c1 e0 05             	shl    $0x5,%eax
c0103485:	89 c2                	mov    %eax,%edx
c0103487:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010348a:	01 d0                	add    %edx,%eax
c010348c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103492:	8b 40 08             	mov    0x8(%eax),%eax
c0103495:	2b 45 08             	sub    0x8(%ebp),%eax
c0103498:	89 c2                	mov    %eax,%edx
c010349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010349d:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01034a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034a3:	83 c0 04             	add    $0x4,%eax
c01034a6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01034ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01034b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01034b6:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c01034b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034bc:	83 c0 0c             	add    $0xc,%eax
c01034bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01034c2:	83 c2 0c             	add    $0xc,%edx
c01034c5:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01034c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01034cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034ce:	8b 40 04             	mov    0x4(%eax),%eax
c01034d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034d4:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01034d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01034da:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01034dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01034e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034e3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034e6:	89 10                	mov    %edx,(%eax)
c01034e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01034eb:	8b 10                	mov    (%eax),%edx
c01034ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01034f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01034f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01034fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103502:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0103504:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103507:	83 c0 0c             	add    $0xc,%eax
c010350a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010350d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103510:	8b 40 04             	mov    0x4(%eax),%eax
c0103513:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103516:	8b 12                	mov    (%edx),%edx
c0103518:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010351b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010351e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103521:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103524:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103527:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010352a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010352d:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c010352f:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103534:	2b 45 08             	sub    0x8(%ebp),%eax
c0103537:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
        ClearPageProperty(page);
c010353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010353f:	83 c0 04             	add    $0x4,%eax
c0103542:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103549:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010354c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010354f:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103552:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0103555:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103558:	c9                   	leave  
c0103559:	c3                   	ret    

c010355a <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010355a:	55                   	push   %ebp
c010355b:	89 e5                	mov    %esp,%ebp
c010355d:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0103563:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103567:	75 24                	jne    c010358d <default_free_pages+0x33>
c0103569:	c7 44 24 0c b0 a5 10 	movl   $0xc010a5b0,0xc(%esp)
c0103570:	c0 
c0103571:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103578:	c0 
c0103579:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0103580:	00 
c0103581:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103588:	e8 50 d7 ff ff       	call   c0100cdd <__panic>
    struct Page *p = base;
c010358d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103590:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
// 检查每个block中的各个page property是否合法
    for (; p != base + n; p ++) {
c0103593:	e9 9d 00 00 00       	jmp    c0103635 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0103598:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359b:	83 c0 04             	add    $0x4,%eax
c010359e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01035a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01035ae:	0f a3 10             	bt     %edx,(%eax)
c01035b1:	19 c0                	sbb    %eax,%eax
c01035b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c01035b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01035ba:	0f 95 c0             	setne  %al
c01035bd:	0f b6 c0             	movzbl %al,%eax
c01035c0:	85 c0                	test   %eax,%eax
c01035c2:	75 2c                	jne    c01035f0 <default_free_pages+0x96>
c01035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c7:	83 c0 04             	add    $0x4,%eax
c01035ca:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c01035d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01035da:	0f a3 10             	bt     %edx,(%eax)
c01035dd:	19 c0                	sbb    %eax,%eax
c01035df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c01035e2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01035e6:	0f 95 c0             	setne  %al
c01035e9:	0f b6 c0             	movzbl %al,%eax
c01035ec:	85 c0                	test   %eax,%eax
c01035ee:	74 24                	je     c0103614 <default_free_pages+0xba>
c01035f0:	c7 44 24 0c f4 a5 10 	movl   $0xc010a5f4,0xc(%esp)
c01035f7:	c0 
c01035f8:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01035ff:	c0 
c0103600:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0103607:	00 
c0103608:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010360f:	e8 c9 d6 ff ff       	call   c0100cdd <__panic>
        p->flags = 0;
c0103614:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c010361e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103625:	00 
c0103626:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103629:	89 04 24             	mov    %eax,(%esp)
c010362c:	e8 1f fc ff ff       	call   c0103250 <set_page_ref>
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
 
// 检查每个block中的各个page property是否合法
    for (; p != base + n; p ++) {
c0103631:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103635:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103638:	c1 e0 05             	shl    $0x5,%eax
c010363b:	89 c2                	mov    %eax,%edx
c010363d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103640:	01 d0                	add    %edx,%eax
c0103642:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103645:	0f 85 4d ff ff ff    	jne    c0103598 <default_free_pages+0x3e>
        p->flags = 0;
        set_page_ref(p, 0);
    }
 
// 设置好释放空间的长度和page property
    base->property = n;
c010364b:	8b 45 08             	mov    0x8(%ebp),%eax
c010364e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103651:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103654:	8b 45 08             	mov    0x8(%ebp),%eax
c0103657:	83 c0 04             	add    $0x4,%eax
c010365a:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103661:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103664:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103667:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010366a:	0f ab 10             	bts    %edx,(%eax)
c010366d:	c7 45 c4 18 7b 12 c0 	movl   $0xc0127b18,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103674:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103677:	8b 40 04             	mov    0x4(%eax),%eax
 
// Step1：找到插入链表的位置（链表已按照地址从大到小排序）
    list_entry_t *le = list_next(&free_list);
c010367a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *prev = &free_list;
c010367d:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while (le != &free_list) {
c0103684:	eb 28                	jmp    c01036ae <default_free_pages+0x154>
        p = le2page(le, page_link);
c0103686:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103689:	83 e8 0c             	sub    $0xc,%eax
c010368c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base < p) {
c010368f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103692:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103695:	73 02                	jae    c0103699 <default_free_pages+0x13f>
            break;
c0103697:	eb 1e                	jmp    c01036b7 <default_free_pages+0x15d>
        }
        prev = le;
c0103699:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010369c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036a2:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01036a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036a8:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01036ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    SetPageProperty(base);
 
// Step1：找到插入链表的位置（链表已按照地址从大到小排序）
    list_entry_t *le = list_next(&free_list);
    list_entry_t *prev = &free_list;
    while (le != &free_list) {
c01036ae:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c01036b5:	75 cf                	jne    c0103686 <default_free_pages+0x12c>
        prev = le;
        le = list_next(le);
    }
 
// Step2：检查是否可以和链表的前一项中的空间合并
    p = le2page(prev, page_link);
c01036b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036ba:	83 e8 0c             	sub    $0xc,%eax
c01036bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (prev != &free_list && p + p -> property == base) {
c01036c0:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c01036c7:	74 44                	je     c010370d <default_free_pages+0x1b3>
c01036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036cc:	8b 40 08             	mov    0x8(%eax),%eax
c01036cf:	c1 e0 05             	shl    $0x5,%eax
c01036d2:	89 c2                	mov    %eax,%edx
c01036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036d7:	01 d0                	add    %edx,%eax
c01036d9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01036dc:	75 2f                	jne    c010370d <default_free_pages+0x1b3>
        p -> property += base -> property;
c01036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e1:	8b 50 08             	mov    0x8(%eax),%edx
c01036e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e7:	8b 40 08             	mov    0x8(%eax),%eax
c01036ea:	01 c2                	add    %eax,%edx
c01036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ef:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(base);
c01036f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f5:	83 c0 04             	add    $0x4,%eax
c01036f8:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01036ff:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103702:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103705:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103708:	0f b3 10             	btr    %edx,(%eax)
c010370b:	eb 4e                	jmp    c010375b <default_free_pages+0x201>
    } else {
        list_add_after(prev, &(base -> page_link));
c010370d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103710:	8d 50 0c             	lea    0xc(%eax),%edx
c0103713:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103716:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103719:	89 55 b0             	mov    %edx,-0x50(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010371c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010371f:	8b 40 04             	mov    0x4(%eax),%eax
c0103722:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103725:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0103728:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010372b:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010372e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103731:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103734:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103737:	89 10                	mov    %edx,(%eax)
c0103739:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010373c:	8b 10                	mov    (%eax),%edx
c010373e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103741:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103744:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103747:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010374a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010374d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103750:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103753:	89 10                	mov    %edx,(%eax)
        p = base;
c0103755:	8b 45 08             	mov    0x8(%ebp),%eax
c0103758:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
 
// Step3：检查是否可以和链表的后一项中的空间合并
    struct Page *nextp = le2page(le, page_link);
c010375b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375e:	83 e8 0c             	sub    $0xc,%eax
c0103761:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (le != &free_list && p + p -> property == nextp) {
c0103764:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c010376b:	74 6a                	je     c01037d7 <default_free_pages+0x27d>
c010376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103770:	8b 40 08             	mov    0x8(%eax),%eax
c0103773:	c1 e0 05             	shl    $0x5,%eax
c0103776:	89 c2                	mov    %eax,%edx
c0103778:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377b:	01 d0                	add    %edx,%eax
c010377d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0103780:	75 55                	jne    c01037d7 <default_free_pages+0x27d>
        p -> property += nextp -> property;
c0103782:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103785:	8b 50 08             	mov    0x8(%eax),%edx
c0103788:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010378b:	8b 40 08             	mov    0x8(%eax),%eax
c010378e:	01 c2                	add    %eax,%edx
c0103790:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103793:	89 50 08             	mov    %edx,0x8(%eax)
        ClearPageProperty(nextp);
c0103796:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103799:	83 c0 04             	add    $0x4,%eax
c010379c:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01037a3:	89 45 9c             	mov    %eax,-0x64(%ebp)
c01037a6:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01037a9:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01037ac:	0f b3 10             	btr    %edx,(%eax)
c01037af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037b2:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01037b5:	8b 45 98             	mov    -0x68(%ebp),%eax
c01037b8:	8b 40 04             	mov    0x4(%eax),%eax
c01037bb:	8b 55 98             	mov    -0x68(%ebp),%edx
c01037be:	8b 12                	mov    (%edx),%edx
c01037c0:	89 55 94             	mov    %edx,-0x6c(%ebp)
c01037c3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01037c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01037c9:	8b 55 90             	mov    -0x70(%ebp),%edx
c01037cc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01037cf:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037d2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037d5:	89 10                	mov    %edx,(%eax)
        list_del(le);
    }
 
    nr_free += n;
c01037d7:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c01037dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037e0:	01 d0                	add    %edx,%eax
c01037e2:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
}
c01037e7:	c9                   	leave  
c01037e8:	c3                   	ret    

c01037e9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01037e9:	55                   	push   %ebp
c01037ea:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01037ec:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c01037f1:	5d                   	pop    %ebp
c01037f2:	c3                   	ret    

c01037f3 <basic_check>:

static void
basic_check(void) {
c01037f3:	55                   	push   %ebp
c01037f4:	89 e5                	mov    %esp,%ebp
c01037f6:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01037f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103803:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103806:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103809:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010380c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103813:	e8 c4 15 00 00       	call   c0104ddc <alloc_pages>
c0103818:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010381b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010381f:	75 24                	jne    c0103845 <basic_check+0x52>
c0103821:	c7 44 24 0c 19 a6 10 	movl   $0xc010a619,0xc(%esp)
c0103828:	c0 
c0103829:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103830:	c0 
c0103831:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0103838:	00 
c0103839:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103840:	e8 98 d4 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103845:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010384c:	e8 8b 15 00 00       	call   c0104ddc <alloc_pages>
c0103851:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103854:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103858:	75 24                	jne    c010387e <basic_check+0x8b>
c010385a:	c7 44 24 0c 35 a6 10 	movl   $0xc010a635,0xc(%esp)
c0103861:	c0 
c0103862:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103869:	c0 
c010386a:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103871:	00 
c0103872:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103879:	e8 5f d4 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c010387e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103885:	e8 52 15 00 00       	call   c0104ddc <alloc_pages>
c010388a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010388d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103891:	75 24                	jne    c01038b7 <basic_check+0xc4>
c0103893:	c7 44 24 0c 51 a6 10 	movl   $0xc010a651,0xc(%esp)
c010389a:	c0 
c010389b:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01038a2:	c0 
c01038a3:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01038aa:	00 
c01038ab:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01038b2:	e8 26 d4 ff ff       	call   c0100cdd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01038b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038bd:	74 10                	je     c01038cf <basic_check+0xdc>
c01038bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038c5:	74 08                	je     c01038cf <basic_check+0xdc>
c01038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038cd:	75 24                	jne    c01038f3 <basic_check+0x100>
c01038cf:	c7 44 24 0c 70 a6 10 	movl   $0xc010a670,0xc(%esp)
c01038d6:	c0 
c01038d7:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01038de:	c0 
c01038df:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01038e6:	00 
c01038e7:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01038ee:	e8 ea d3 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01038f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038f6:	89 04 24             	mov    %eax,(%esp)
c01038f9:	e8 48 f9 ff ff       	call   c0103246 <page_ref>
c01038fe:	85 c0                	test   %eax,%eax
c0103900:	75 1e                	jne    c0103920 <basic_check+0x12d>
c0103902:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103905:	89 04 24             	mov    %eax,(%esp)
c0103908:	e8 39 f9 ff ff       	call   c0103246 <page_ref>
c010390d:	85 c0                	test   %eax,%eax
c010390f:	75 0f                	jne    c0103920 <basic_check+0x12d>
c0103911:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103914:	89 04 24             	mov    %eax,(%esp)
c0103917:	e8 2a f9 ff ff       	call   c0103246 <page_ref>
c010391c:	85 c0                	test   %eax,%eax
c010391e:	74 24                	je     c0103944 <basic_check+0x151>
c0103920:	c7 44 24 0c 94 a6 10 	movl   $0xc010a694,0xc(%esp)
c0103927:	c0 
c0103928:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010392f:	c0 
c0103930:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103937:	00 
c0103938:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010393f:	e8 99 d3 ff ff       	call   c0100cdd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103947:	89 04 24             	mov    %eax,(%esp)
c010394a:	e8 e1 f8 ff ff       	call   c0103230 <page2pa>
c010394f:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103955:	c1 e2 0c             	shl    $0xc,%edx
c0103958:	39 d0                	cmp    %edx,%eax
c010395a:	72 24                	jb     c0103980 <basic_check+0x18d>
c010395c:	c7 44 24 0c d0 a6 10 	movl   $0xc010a6d0,0xc(%esp)
c0103963:	c0 
c0103964:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010396b:	c0 
c010396c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103973:	00 
c0103974:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010397b:	e8 5d d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103980:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103983:	89 04 24             	mov    %eax,(%esp)
c0103986:	e8 a5 f8 ff ff       	call   c0103230 <page2pa>
c010398b:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103991:	c1 e2 0c             	shl    $0xc,%edx
c0103994:	39 d0                	cmp    %edx,%eax
c0103996:	72 24                	jb     c01039bc <basic_check+0x1c9>
c0103998:	c7 44 24 0c ed a6 10 	movl   $0xc010a6ed,0xc(%esp)
c010399f:	c0 
c01039a0:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01039a7:	c0 
c01039a8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01039af:	00 
c01039b0:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01039b7:	e8 21 d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039bf:	89 04 24             	mov    %eax,(%esp)
c01039c2:	e8 69 f8 ff ff       	call   c0103230 <page2pa>
c01039c7:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01039cd:	c1 e2 0c             	shl    $0xc,%edx
c01039d0:	39 d0                	cmp    %edx,%eax
c01039d2:	72 24                	jb     c01039f8 <basic_check+0x205>
c01039d4:	c7 44 24 0c 0a a7 10 	movl   $0xc010a70a,0xc(%esp)
c01039db:	c0 
c01039dc:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01039e3:	c0 
c01039e4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01039eb:	00 
c01039ec:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01039f3:	e8 e5 d2 ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c01039f8:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c01039fd:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103a03:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a06:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a09:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a10:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a16:	89 50 04             	mov    %edx,0x4(%eax)
c0103a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a1c:	8b 50 04             	mov    0x4(%eax),%edx
c0103a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a22:	89 10                	mov    %edx,(%eax)
c0103a24:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103a2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a2e:	8b 40 04             	mov    0x4(%eax),%eax
c0103a31:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103a34:	0f 94 c0             	sete   %al
c0103a37:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103a3a:	85 c0                	test   %eax,%eax
c0103a3c:	75 24                	jne    c0103a62 <basic_check+0x26f>
c0103a3e:	c7 44 24 0c 27 a7 10 	movl   $0xc010a727,0xc(%esp)
c0103a45:	c0 
c0103a46:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103a4d:	c0 
c0103a4e:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103a55:	00 
c0103a56:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103a5d:	e8 7b d2 ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c0103a62:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103a67:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103a6a:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103a71:	00 00 00 

    assert(alloc_page() == NULL);
c0103a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a7b:	e8 5c 13 00 00       	call   c0104ddc <alloc_pages>
c0103a80:	85 c0                	test   %eax,%eax
c0103a82:	74 24                	je     c0103aa8 <basic_check+0x2b5>
c0103a84:	c7 44 24 0c 3e a7 10 	movl   $0xc010a73e,0xc(%esp)
c0103a8b:	c0 
c0103a8c:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103a93:	c0 
c0103a94:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0103a9b:	00 
c0103a9c:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103aa3:	e8 35 d2 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103aa8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103aaf:	00 
c0103ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ab3:	89 04 24             	mov    %eax,(%esp)
c0103ab6:	e8 8c 13 00 00       	call   c0104e47 <free_pages>
    free_page(p1);
c0103abb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ac2:	00 
c0103ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac6:	89 04 24             	mov    %eax,(%esp)
c0103ac9:	e8 79 13 00 00       	call   c0104e47 <free_pages>
    free_page(p2);
c0103ace:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ad5:	00 
c0103ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad9:	89 04 24             	mov    %eax,(%esp)
c0103adc:	e8 66 13 00 00       	call   c0104e47 <free_pages>
    assert(nr_free == 3);
c0103ae1:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103ae6:	83 f8 03             	cmp    $0x3,%eax
c0103ae9:	74 24                	je     c0103b0f <basic_check+0x31c>
c0103aeb:	c7 44 24 0c 53 a7 10 	movl   $0xc010a753,0xc(%esp)
c0103af2:	c0 
c0103af3:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103afa:	c0 
c0103afb:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103b02:	00 
c0103b03:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103b0a:	e8 ce d1 ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b16:	e8 c1 12 00 00       	call   c0104ddc <alloc_pages>
c0103b1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b22:	75 24                	jne    c0103b48 <basic_check+0x355>
c0103b24:	c7 44 24 0c 19 a6 10 	movl   $0xc010a619,0xc(%esp)
c0103b2b:	c0 
c0103b2c:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103b33:	c0 
c0103b34:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103b3b:	00 
c0103b3c:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103b43:	e8 95 d1 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b4f:	e8 88 12 00 00       	call   c0104ddc <alloc_pages>
c0103b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b5b:	75 24                	jne    c0103b81 <basic_check+0x38e>
c0103b5d:	c7 44 24 0c 35 a6 10 	movl   $0xc010a635,0xc(%esp)
c0103b64:	c0 
c0103b65:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103b6c:	c0 
c0103b6d:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103b74:	00 
c0103b75:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103b7c:	e8 5c d1 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b88:	e8 4f 12 00 00       	call   c0104ddc <alloc_pages>
c0103b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b94:	75 24                	jne    c0103bba <basic_check+0x3c7>
c0103b96:	c7 44 24 0c 51 a6 10 	movl   $0xc010a651,0xc(%esp)
c0103b9d:	c0 
c0103b9e:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103ba5:	c0 
c0103ba6:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103bad:	00 
c0103bae:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103bb5:	e8 23 d1 ff ff       	call   c0100cdd <__panic>

    assert(alloc_page() == NULL);
c0103bba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bc1:	e8 16 12 00 00       	call   c0104ddc <alloc_pages>
c0103bc6:	85 c0                	test   %eax,%eax
c0103bc8:	74 24                	je     c0103bee <basic_check+0x3fb>
c0103bca:	c7 44 24 0c 3e a7 10 	movl   $0xc010a73e,0xc(%esp)
c0103bd1:	c0 
c0103bd2:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103bd9:	c0 
c0103bda:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103be1:	00 
c0103be2:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103be9:	e8 ef d0 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103bee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103bf5:	00 
c0103bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bf9:	89 04 24             	mov    %eax,(%esp)
c0103bfc:	e8 46 12 00 00       	call   c0104e47 <free_pages>
c0103c01:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c0b:	8b 40 04             	mov    0x4(%eax),%eax
c0103c0e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c11:	0f 94 c0             	sete   %al
c0103c14:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c17:	85 c0                	test   %eax,%eax
c0103c19:	74 24                	je     c0103c3f <basic_check+0x44c>
c0103c1b:	c7 44 24 0c 60 a7 10 	movl   $0xc010a760,0xc(%esp)
c0103c22:	c0 
c0103c23:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103c2a:	c0 
c0103c2b:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103c32:	00 
c0103c33:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103c3a:	e8 9e d0 ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103c3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c46:	e8 91 11 00 00       	call   c0104ddc <alloc_pages>
c0103c4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c51:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103c54:	74 24                	je     c0103c7a <basic_check+0x487>
c0103c56:	c7 44 24 0c 78 a7 10 	movl   $0xc010a778,0xc(%esp)
c0103c5d:	c0 
c0103c5e:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103c65:	c0 
c0103c66:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103c6d:	00 
c0103c6e:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103c75:	e8 63 d0 ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103c7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c81:	e8 56 11 00 00       	call   c0104ddc <alloc_pages>
c0103c86:	85 c0                	test   %eax,%eax
c0103c88:	74 24                	je     c0103cae <basic_check+0x4bb>
c0103c8a:	c7 44 24 0c 3e a7 10 	movl   $0xc010a73e,0xc(%esp)
c0103c91:	c0 
c0103c92:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103c99:	c0 
c0103c9a:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103ca1:	00 
c0103ca2:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103ca9:	e8 2f d0 ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0103cae:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103cb3:	85 c0                	test   %eax,%eax
c0103cb5:	74 24                	je     c0103cdb <basic_check+0x4e8>
c0103cb7:	c7 44 24 0c 91 a7 10 	movl   $0xc010a791,0xc(%esp)
c0103cbe:	c0 
c0103cbf:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103cc6:	c0 
c0103cc7:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103cce:	00 
c0103ccf:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103cd6:	e8 02 d0 ff ff       	call   c0100cdd <__panic>
    free_list = free_list_store;
c0103cdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103cde:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ce1:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103ce6:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103cec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cef:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103cf4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cfb:	00 
c0103cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cff:	89 04 24             	mov    %eax,(%esp)
c0103d02:	e8 40 11 00 00       	call   c0104e47 <free_pages>
    free_page(p1);
c0103d07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d0e:	00 
c0103d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d12:	89 04 24             	mov    %eax,(%esp)
c0103d15:	e8 2d 11 00 00       	call   c0104e47 <free_pages>
    free_page(p2);
c0103d1a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d21:	00 
c0103d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d25:	89 04 24             	mov    %eax,(%esp)
c0103d28:	e8 1a 11 00 00       	call   c0104e47 <free_pages>
}
c0103d2d:	c9                   	leave  
c0103d2e:	c3                   	ret    

c0103d2f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103d2f:	55                   	push   %ebp
c0103d30:	89 e5                	mov    %esp,%ebp
c0103d32:	53                   	push   %ebx
c0103d33:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103d47:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d4e:	eb 6b                	jmp    c0103dbb <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d53:	83 e8 0c             	sub    $0xc,%eax
c0103d56:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d5c:	83 c0 04             	add    $0x4,%eax
c0103d5f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103d66:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d69:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d6c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d6f:	0f a3 10             	bt     %edx,(%eax)
c0103d72:	19 c0                	sbb    %eax,%eax
c0103d74:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103d77:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d7b:	0f 95 c0             	setne  %al
c0103d7e:	0f b6 c0             	movzbl %al,%eax
c0103d81:	85 c0                	test   %eax,%eax
c0103d83:	75 24                	jne    c0103da9 <default_check+0x7a>
c0103d85:	c7 44 24 0c 9e a7 10 	movl   $0xc010a79e,0xc(%esp)
c0103d8c:	c0 
c0103d8d:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103d94:	c0 
c0103d95:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103d9c:	00 
c0103d9d:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103da4:	e8 34 cf ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0103da9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103db0:	8b 50 08             	mov    0x8(%eax),%edx
c0103db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db6:	01 d0                	add    %edx,%eax
c0103db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103dbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103dc1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103dc4:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103dc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103dca:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103dd1:	0f 85 79 ff ff ff    	jne    c0103d50 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103dd7:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103dda:	e8 9a 10 00 00       	call   c0104e79 <nr_free_pages>
c0103ddf:	39 c3                	cmp    %eax,%ebx
c0103de1:	74 24                	je     c0103e07 <default_check+0xd8>
c0103de3:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c0103dea:	c0 
c0103deb:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103df2:	c0 
c0103df3:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103dfa:	00 
c0103dfb:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103e02:	e8 d6 ce ff ff       	call   c0100cdd <__panic>

    basic_check();
c0103e07:	e8 e7 f9 ff ff       	call   c01037f3 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e0c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e13:	e8 c4 0f 00 00       	call   c0104ddc <alloc_pages>
c0103e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103e1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e1f:	75 24                	jne    c0103e45 <default_check+0x116>
c0103e21:	c7 44 24 0c c7 a7 10 	movl   $0xc010a7c7,0xc(%esp)
c0103e28:	c0 
c0103e29:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103e30:	c0 
c0103e31:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103e38:	00 
c0103e39:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103e40:	e8 98 ce ff ff       	call   c0100cdd <__panic>
    assert(!PageProperty(p0));
c0103e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e48:	83 c0 04             	add    $0x4,%eax
c0103e4b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103e52:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e55:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e58:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e5b:	0f a3 10             	bt     %edx,(%eax)
c0103e5e:	19 c0                	sbb    %eax,%eax
c0103e60:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103e63:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103e67:	0f 95 c0             	setne  %al
c0103e6a:	0f b6 c0             	movzbl %al,%eax
c0103e6d:	85 c0                	test   %eax,%eax
c0103e6f:	74 24                	je     c0103e95 <default_check+0x166>
c0103e71:	c7 44 24 0c d2 a7 10 	movl   $0xc010a7d2,0xc(%esp)
c0103e78:	c0 
c0103e79:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103e80:	c0 
c0103e81:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103e88:	00 
c0103e89:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103e90:	e8 48 ce ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c0103e95:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103e9a:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103ea0:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103ea3:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103ea6:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ead:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103eb0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103eb3:	89 50 04             	mov    %edx,0x4(%eax)
c0103eb6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103eb9:	8b 50 04             	mov    0x4(%eax),%edx
c0103ebc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ebf:	89 10                	mov    %edx,(%eax)
c0103ec1:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103ec8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ecb:	8b 40 04             	mov    0x4(%eax),%eax
c0103ece:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103ed1:	0f 94 c0             	sete   %al
c0103ed4:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ed7:	85 c0                	test   %eax,%eax
c0103ed9:	75 24                	jne    c0103eff <default_check+0x1d0>
c0103edb:	c7 44 24 0c 27 a7 10 	movl   $0xc010a727,0xc(%esp)
c0103ee2:	c0 
c0103ee3:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103eea:	c0 
c0103eeb:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103ef2:	00 
c0103ef3:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103efa:	e8 de cd ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103eff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f06:	e8 d1 0e 00 00       	call   c0104ddc <alloc_pages>
c0103f0b:	85 c0                	test   %eax,%eax
c0103f0d:	74 24                	je     c0103f33 <default_check+0x204>
c0103f0f:	c7 44 24 0c 3e a7 10 	movl   $0xc010a73e,0xc(%esp)
c0103f16:	c0 
c0103f17:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103f1e:	c0 
c0103f1f:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103f26:	00 
c0103f27:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103f2e:	e8 aa cd ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c0103f33:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103f38:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103f3b:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103f42:	00 00 00 

    free_pages(p0 + 2, 3);
c0103f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f48:	83 c0 40             	add    $0x40,%eax
c0103f4b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f52:	00 
c0103f53:	89 04 24             	mov    %eax,(%esp)
c0103f56:	e8 ec 0e 00 00       	call   c0104e47 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f5b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103f62:	e8 75 0e 00 00       	call   c0104ddc <alloc_pages>
c0103f67:	85 c0                	test   %eax,%eax
c0103f69:	74 24                	je     c0103f8f <default_check+0x260>
c0103f6b:	c7 44 24 0c e4 a7 10 	movl   $0xc010a7e4,0xc(%esp)
c0103f72:	c0 
c0103f73:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103f7a:	c0 
c0103f7b:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103f82:	00 
c0103f83:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103f8a:	e8 4e cd ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f92:	83 c0 40             	add    $0x40,%eax
c0103f95:	83 c0 04             	add    $0x4,%eax
c0103f98:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103f9f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fa2:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fa5:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103fa8:	0f a3 10             	bt     %edx,(%eax)
c0103fab:	19 c0                	sbb    %eax,%eax
c0103fad:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103fb0:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103fb4:	0f 95 c0             	setne  %al
c0103fb7:	0f b6 c0             	movzbl %al,%eax
c0103fba:	85 c0                	test   %eax,%eax
c0103fbc:	74 0e                	je     c0103fcc <default_check+0x29d>
c0103fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fc1:	83 c0 40             	add    $0x40,%eax
c0103fc4:	8b 40 08             	mov    0x8(%eax),%eax
c0103fc7:	83 f8 03             	cmp    $0x3,%eax
c0103fca:	74 24                	je     c0103ff0 <default_check+0x2c1>
c0103fcc:	c7 44 24 0c fc a7 10 	movl   $0xc010a7fc,0xc(%esp)
c0103fd3:	c0 
c0103fd4:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0103fdb:	c0 
c0103fdc:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103fe3:	00 
c0103fe4:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0103feb:	e8 ed cc ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103ff0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103ff7:	e8 e0 0d 00 00       	call   c0104ddc <alloc_pages>
c0103ffc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103fff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104003:	75 24                	jne    c0104029 <default_check+0x2fa>
c0104005:	c7 44 24 0c 28 a8 10 	movl   $0xc010a828,0xc(%esp)
c010400c:	c0 
c010400d:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0104014:	c0 
c0104015:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010401c:	00 
c010401d:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0104024:	e8 b4 cc ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0104029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104030:	e8 a7 0d 00 00       	call   c0104ddc <alloc_pages>
c0104035:	85 c0                	test   %eax,%eax
c0104037:	74 24                	je     c010405d <default_check+0x32e>
c0104039:	c7 44 24 0c 3e a7 10 	movl   $0xc010a73e,0xc(%esp)
c0104040:	c0 
c0104041:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0104048:	c0 
c0104049:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104050:	00 
c0104051:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0104058:	e8 80 cc ff ff       	call   c0100cdd <__panic>
    assert(p0 + 2 == p1);
c010405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104060:	83 c0 40             	add    $0x40,%eax
c0104063:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104066:	74 24                	je     c010408c <default_check+0x35d>
c0104068:	c7 44 24 0c 46 a8 10 	movl   $0xc010a846,0xc(%esp)
c010406f:	c0 
c0104070:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0104077:	c0 
c0104078:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010407f:	00 
c0104080:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0104087:	e8 51 cc ff ff       	call   c0100cdd <__panic>

    p2 = p0 + 1;
c010408c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010408f:	83 c0 20             	add    $0x20,%eax
c0104092:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104095:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010409c:	00 
c010409d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040a0:	89 04 24             	mov    %eax,(%esp)
c01040a3:	e8 9f 0d 00 00       	call   c0104e47 <free_pages>
    free_pages(p1, 3);
c01040a8:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040af:	00 
c01040b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040b3:	89 04 24             	mov    %eax,(%esp)
c01040b6:	e8 8c 0d 00 00       	call   c0104e47 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01040bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040be:	83 c0 04             	add    $0x4,%eax
c01040c1:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01040c8:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040cb:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040ce:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01040d1:	0f a3 10             	bt     %edx,(%eax)
c01040d4:	19 c0                	sbb    %eax,%eax
c01040d6:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01040d9:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01040dd:	0f 95 c0             	setne  %al
c01040e0:	0f b6 c0             	movzbl %al,%eax
c01040e3:	85 c0                	test   %eax,%eax
c01040e5:	74 0b                	je     c01040f2 <default_check+0x3c3>
c01040e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040ea:	8b 40 08             	mov    0x8(%eax),%eax
c01040ed:	83 f8 01             	cmp    $0x1,%eax
c01040f0:	74 24                	je     c0104116 <default_check+0x3e7>
c01040f2:	c7 44 24 0c 54 a8 10 	movl   $0xc010a854,0xc(%esp)
c01040f9:	c0 
c01040fa:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0104101:	c0 
c0104102:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104109:	00 
c010410a:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0104111:	e8 c7 cb ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104116:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104119:	83 c0 04             	add    $0x4,%eax
c010411c:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104123:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104126:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104129:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010412c:	0f a3 10             	bt     %edx,(%eax)
c010412f:	19 c0                	sbb    %eax,%eax
c0104131:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104134:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104138:	0f 95 c0             	setne  %al
c010413b:	0f b6 c0             	movzbl %al,%eax
c010413e:	85 c0                	test   %eax,%eax
c0104140:	74 0b                	je     c010414d <default_check+0x41e>
c0104142:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104145:	8b 40 08             	mov    0x8(%eax),%eax
c0104148:	83 f8 03             	cmp    $0x3,%eax
c010414b:	74 24                	je     c0104171 <default_check+0x442>
c010414d:	c7 44 24 0c 7c a8 10 	movl   $0xc010a87c,0xc(%esp)
c0104154:	c0 
c0104155:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010415c:	c0 
c010415d:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0104164:	00 
c0104165:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010416c:	e8 6c cb ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104171:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104178:	e8 5f 0c 00 00       	call   c0104ddc <alloc_pages>
c010417d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104180:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104183:	83 e8 20             	sub    $0x20,%eax
c0104186:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104189:	74 24                	je     c01041af <default_check+0x480>
c010418b:	c7 44 24 0c a2 a8 10 	movl   $0xc010a8a2,0xc(%esp)
c0104192:	c0 
c0104193:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010419a:	c0 
c010419b:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01041a2:	00 
c01041a3:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01041aa:	e8 2e cb ff ff       	call   c0100cdd <__panic>
    free_page(p0);
c01041af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041b6:	00 
c01041b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041ba:	89 04 24             	mov    %eax,(%esp)
c01041bd:	e8 85 0c 00 00       	call   c0104e47 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01041c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01041c9:	e8 0e 0c 00 00       	call   c0104ddc <alloc_pages>
c01041ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041d4:	83 c0 20             	add    $0x20,%eax
c01041d7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041da:	74 24                	je     c0104200 <default_check+0x4d1>
c01041dc:	c7 44 24 0c c0 a8 10 	movl   $0xc010a8c0,0xc(%esp)
c01041e3:	c0 
c01041e4:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01041eb:	c0 
c01041ec:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01041f3:	00 
c01041f4:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01041fb:	e8 dd ca ff ff       	call   c0100cdd <__panic>

    free_pages(p0, 2);
c0104200:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104207:	00 
c0104208:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010420b:	89 04 24             	mov    %eax,(%esp)
c010420e:	e8 34 0c 00 00       	call   c0104e47 <free_pages>
    free_page(p2);
c0104213:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010421a:	00 
c010421b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010421e:	89 04 24             	mov    %eax,(%esp)
c0104221:	e8 21 0c 00 00       	call   c0104e47 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104226:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010422d:	e8 aa 0b 00 00       	call   c0104ddc <alloc_pages>
c0104232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104235:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104239:	75 24                	jne    c010425f <default_check+0x530>
c010423b:	c7 44 24 0c e0 a8 10 	movl   $0xc010a8e0,0xc(%esp)
c0104242:	c0 
c0104243:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010424a:	c0 
c010424b:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104252:	00 
c0104253:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010425a:	e8 7e ca ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c010425f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104266:	e8 71 0b 00 00       	call   c0104ddc <alloc_pages>
c010426b:	85 c0                	test   %eax,%eax
c010426d:	74 24                	je     c0104293 <default_check+0x564>
c010426f:	c7 44 24 0c 3e a7 10 	movl   $0xc010a73e,0xc(%esp)
c0104276:	c0 
c0104277:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010427e:	c0 
c010427f:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0104286:	00 
c0104287:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010428e:	e8 4a ca ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0104293:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0104298:	85 c0                	test   %eax,%eax
c010429a:	74 24                	je     c01042c0 <default_check+0x591>
c010429c:	c7 44 24 0c 91 a7 10 	movl   $0xc010a791,0xc(%esp)
c01042a3:	c0 
c01042a4:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c01042ab:	c0 
c01042ac:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01042b3:	00 
c01042b4:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c01042bb:	e8 1d ca ff ff       	call   c0100cdd <__panic>
    nr_free = nr_free_store;
c01042c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042c3:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c01042c8:	8b 45 80             	mov    -0x80(%ebp),%eax
c01042cb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01042ce:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c01042d3:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c01042d9:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01042e0:	00 
c01042e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042e4:	89 04 24             	mov    %eax,(%esp)
c01042e7:	e8 5b 0b 00 00       	call   c0104e47 <free_pages>

    le = &free_list;
c01042ec:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01042f3:	eb 1d                	jmp    c0104312 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01042f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042f8:	83 e8 0c             	sub    $0xc,%eax
c01042fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01042fe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104302:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104308:	8b 40 08             	mov    0x8(%eax),%eax
c010430b:	29 c2                	sub    %eax,%edx
c010430d:	89 d0                	mov    %edx,%eax
c010430f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104312:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104315:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104318:	8b 45 88             	mov    -0x78(%ebp),%eax
c010431b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010431e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104321:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0104328:	75 cb                	jne    c01042f5 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010432a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010432e:	74 24                	je     c0104354 <default_check+0x625>
c0104330:	c7 44 24 0c fe a8 10 	movl   $0xc010a8fe,0xc(%esp)
c0104337:	c0 
c0104338:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c010433f:	c0 
c0104340:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0104347:	00 
c0104348:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c010434f:	e8 89 c9 ff ff       	call   c0100cdd <__panic>
    assert(total == 0);
c0104354:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104358:	74 24                	je     c010437e <default_check+0x64f>
c010435a:	c7 44 24 0c 09 a9 10 	movl   $0xc010a909,0xc(%esp)
c0104361:	c0 
c0104362:	c7 44 24 08 b6 a5 10 	movl   $0xc010a5b6,0x8(%esp)
c0104369:	c0 
c010436a:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0104371:	00 
c0104372:	c7 04 24 cb a5 10 c0 	movl   $0xc010a5cb,(%esp)
c0104379:	e8 5f c9 ff ff       	call   c0100cdd <__panic>
}
c010437e:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104384:	5b                   	pop    %ebx
c0104385:	5d                   	pop    %ebp
c0104386:	c3                   	ret    

c0104387 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104387:	55                   	push   %ebp
c0104388:	89 e5                	mov    %esp,%ebp
c010438a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010438d:	9c                   	pushf  
c010438e:	58                   	pop    %eax
c010438f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104392:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104395:	25 00 02 00 00       	and    $0x200,%eax
c010439a:	85 c0                	test   %eax,%eax
c010439c:	74 0c                	je     c01043aa <__intr_save+0x23>
        intr_disable();
c010439e:	e8 92 db ff ff       	call   c0101f35 <intr_disable>
        return 1;
c01043a3:	b8 01 00 00 00       	mov    $0x1,%eax
c01043a8:	eb 05                	jmp    c01043af <__intr_save+0x28>
    }
    return 0;
c01043aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01043af:	c9                   	leave  
c01043b0:	c3                   	ret    

c01043b1 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01043b1:	55                   	push   %ebp
c01043b2:	89 e5                	mov    %esp,%ebp
c01043b4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01043b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01043bb:	74 05                	je     c01043c2 <__intr_restore+0x11>
        intr_enable();
c01043bd:	e8 6d db ff ff       	call   c0101f2f <intr_enable>
    }
}
c01043c2:	c9                   	leave  
c01043c3:	c3                   	ret    

c01043c4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01043c4:	55                   	push   %ebp
c01043c5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01043c7:	8b 55 08             	mov    0x8(%ebp),%edx
c01043ca:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01043cf:	29 c2                	sub    %eax,%edx
c01043d1:	89 d0                	mov    %edx,%eax
c01043d3:	c1 f8 05             	sar    $0x5,%eax
}
c01043d6:	5d                   	pop    %ebp
c01043d7:	c3                   	ret    

c01043d8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01043d8:	55                   	push   %ebp
c01043d9:	89 e5                	mov    %esp,%ebp
c01043db:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01043de:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e1:	89 04 24             	mov    %eax,(%esp)
c01043e4:	e8 db ff ff ff       	call   c01043c4 <page2ppn>
c01043e9:	c1 e0 0c             	shl    $0xc,%eax
}
c01043ec:	c9                   	leave  
c01043ed:	c3                   	ret    

c01043ee <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01043ee:	55                   	push   %ebp
c01043ef:	89 e5                	mov    %esp,%ebp
c01043f1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01043f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f7:	c1 e8 0c             	shr    $0xc,%eax
c01043fa:	89 c2                	mov    %eax,%edx
c01043fc:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104401:	39 c2                	cmp    %eax,%edx
c0104403:	72 1c                	jb     c0104421 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104405:	c7 44 24 08 44 a9 10 	movl   $0xc010a944,0x8(%esp)
c010440c:	c0 
c010440d:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104414:	00 
c0104415:	c7 04 24 63 a9 10 c0 	movl   $0xc010a963,(%esp)
c010441c:	e8 bc c8 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0104421:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104426:	8b 55 08             	mov    0x8(%ebp),%edx
c0104429:	c1 ea 0c             	shr    $0xc,%edx
c010442c:	c1 e2 05             	shl    $0x5,%edx
c010442f:	01 d0                	add    %edx,%eax
}
c0104431:	c9                   	leave  
c0104432:	c3                   	ret    

c0104433 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104433:	55                   	push   %ebp
c0104434:	89 e5                	mov    %esp,%ebp
c0104436:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104439:	8b 45 08             	mov    0x8(%ebp),%eax
c010443c:	89 04 24             	mov    %eax,(%esp)
c010443f:	e8 94 ff ff ff       	call   c01043d8 <page2pa>
c0104444:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104447:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010444a:	c1 e8 0c             	shr    $0xc,%eax
c010444d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104450:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104455:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104458:	72 23                	jb     c010447d <page2kva+0x4a>
c010445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104461:	c7 44 24 08 74 a9 10 	movl   $0xc010a974,0x8(%esp)
c0104468:	c0 
c0104469:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104470:	00 
c0104471:	c7 04 24 63 a9 10 c0 	movl   $0xc010a963,(%esp)
c0104478:	e8 60 c8 ff ff       	call   c0100cdd <__panic>
c010447d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104480:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104485:	c9                   	leave  
c0104486:	c3                   	ret    

c0104487 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104487:	55                   	push   %ebp
c0104488:	89 e5                	mov    %esp,%ebp
c010448a:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010448d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104490:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104493:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010449a:	77 23                	ja     c01044bf <kva2page+0x38>
c010449c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044a3:	c7 44 24 08 98 a9 10 	movl   $0xc010a998,0x8(%esp)
c01044aa:	c0 
c01044ab:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01044b2:	00 
c01044b3:	c7 04 24 63 a9 10 c0 	movl   $0xc010a963,(%esp)
c01044ba:	e8 1e c8 ff ff       	call   c0100cdd <__panic>
c01044bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c2:	05 00 00 00 40       	add    $0x40000000,%eax
c01044c7:	89 04 24             	mov    %eax,(%esp)
c01044ca:	e8 1f ff ff ff       	call   c01043ee <pa2page>
}
c01044cf:	c9                   	leave  
c01044d0:	c3                   	ret    

c01044d1 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c01044d1:	55                   	push   %ebp
c01044d2:	89 e5                	mov    %esp,%ebp
c01044d4:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c01044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044da:	ba 01 00 00 00       	mov    $0x1,%edx
c01044df:	89 c1                	mov    %eax,%ecx
c01044e1:	d3 e2                	shl    %cl,%edx
c01044e3:	89 d0                	mov    %edx,%eax
c01044e5:	89 04 24             	mov    %eax,(%esp)
c01044e8:	e8 ef 08 00 00       	call   c0104ddc <alloc_pages>
c01044ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c01044f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044f4:	75 07                	jne    c01044fd <__slob_get_free_pages+0x2c>
    return NULL;
c01044f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01044fb:	eb 0b                	jmp    c0104508 <__slob_get_free_pages+0x37>
  return page2kva(page);
c01044fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104500:	89 04 24             	mov    %eax,(%esp)
c0104503:	e8 2b ff ff ff       	call   c0104433 <page2kva>
}
c0104508:	c9                   	leave  
c0104509:	c3                   	ret    

c010450a <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010450a:	55                   	push   %ebp
c010450b:	89 e5                	mov    %esp,%ebp
c010450d:	53                   	push   %ebx
c010450e:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104511:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104514:	ba 01 00 00 00       	mov    $0x1,%edx
c0104519:	89 c1                	mov    %eax,%ecx
c010451b:	d3 e2                	shl    %cl,%edx
c010451d:	89 d0                	mov    %edx,%eax
c010451f:	89 c3                	mov    %eax,%ebx
c0104521:	8b 45 08             	mov    0x8(%ebp),%eax
c0104524:	89 04 24             	mov    %eax,(%esp)
c0104527:	e8 5b ff ff ff       	call   c0104487 <kva2page>
c010452c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104530:	89 04 24             	mov    %eax,(%esp)
c0104533:	e8 0f 09 00 00       	call   c0104e47 <free_pages>
}
c0104538:	83 c4 14             	add    $0x14,%esp
c010453b:	5b                   	pop    %ebx
c010453c:	5d                   	pop    %ebp
c010453d:	c3                   	ret    

c010453e <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c010453e:	55                   	push   %ebp
c010453f:	89 e5                	mov    %esp,%ebp
c0104541:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104544:	8b 45 08             	mov    0x8(%ebp),%eax
c0104547:	83 c0 08             	add    $0x8,%eax
c010454a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c010454f:	76 24                	jbe    c0104575 <slob_alloc+0x37>
c0104551:	c7 44 24 0c bc a9 10 	movl   $0xc010a9bc,0xc(%esp)
c0104558:	c0 
c0104559:	c7 44 24 08 db a9 10 	movl   $0xc010a9db,0x8(%esp)
c0104560:	c0 
c0104561:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0104568:	00 
c0104569:	c7 04 24 f0 a9 10 c0 	movl   $0xc010a9f0,(%esp)
c0104570:	e8 68 c7 ff ff       	call   c0100cdd <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104575:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c010457c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104583:	8b 45 08             	mov    0x8(%ebp),%eax
c0104586:	83 c0 07             	add    $0x7,%eax
c0104589:	c1 e8 03             	shr    $0x3,%eax
c010458c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c010458f:	e8 f3 fd ff ff       	call   c0104387 <__intr_save>
c0104594:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104597:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010459c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a2:	8b 40 04             	mov    0x4(%eax),%eax
c01045a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01045a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045ac:	74 25                	je     c01045d3 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01045ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01045b4:	01 d0                	add    %edx,%eax
c01045b6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01045b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01045bc:	f7 d8                	neg    %eax
c01045be:	21 d0                	and    %edx,%eax
c01045c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c01045c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01045c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c9:	29 c2                	sub    %eax,%edx
c01045cb:	89 d0                	mov    %edx,%eax
c01045cd:	c1 f8 03             	sar    $0x3,%eax
c01045d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c01045d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045d6:	8b 00                	mov    (%eax),%eax
c01045d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01045db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01045de:	01 ca                	add    %ecx,%edx
c01045e0:	39 d0                	cmp    %edx,%eax
c01045e2:	0f 8c aa 00 00 00    	jl     c0104692 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c01045e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01045ec:	74 38                	je     c0104626 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c01045ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045f1:	8b 00                	mov    (%eax),%eax
c01045f3:	2b 45 e8             	sub    -0x18(%ebp),%eax
c01045f6:	89 c2                	mov    %eax,%edx
c01045f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045fb:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c01045fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104600:	8b 50 04             	mov    0x4(%eax),%edx
c0104603:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104606:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104609:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010460c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010460f:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104612:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104615:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104618:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010461a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010461d:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104620:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104623:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104626:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104629:	8b 00                	mov    (%eax),%eax
c010462b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010462e:	75 0e                	jne    c010463e <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104630:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104633:	8b 50 04             	mov    0x4(%eax),%edx
c0104636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104639:	89 50 04             	mov    %edx,0x4(%eax)
c010463c:	eb 3c                	jmp    c010467a <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c010463e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104641:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104648:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010464b:	01 c2                	add    %eax,%edx
c010464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104650:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104656:	8b 40 04             	mov    0x4(%eax),%eax
c0104659:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010465c:	8b 12                	mov    (%edx),%edx
c010465e:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104661:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104663:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104666:	8b 40 04             	mov    0x4(%eax),%eax
c0104669:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010466c:	8b 52 04             	mov    0x4(%edx),%edx
c010466f:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104672:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104675:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104678:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c010467a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010467d:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104685:	89 04 24             	mov    %eax,(%esp)
c0104688:	e8 24 fd ff ff       	call   c01043b1 <__intr_restore>
			return cur;
c010468d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104690:	eb 7f                	jmp    c0104711 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104692:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104697:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010469a:	75 61                	jne    c01046fd <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c010469c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010469f:	89 04 24             	mov    %eax,(%esp)
c01046a2:	e8 0a fd ff ff       	call   c01043b1 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01046a7:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01046ae:	75 07                	jne    c01046b7 <slob_alloc+0x179>
				return 0;
c01046b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01046b5:	eb 5a                	jmp    c0104711 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01046b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046be:	00 
c01046bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c2:	89 04 24             	mov    %eax,(%esp)
c01046c5:	e8 07 fe ff ff       	call   c01044d1 <__slob_get_free_pages>
c01046ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c01046cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046d1:	75 07                	jne    c01046da <slob_alloc+0x19c>
				return 0;
c01046d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01046d8:	eb 37                	jmp    c0104711 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c01046da:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01046e1:	00 
c01046e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e5:	89 04 24             	mov    %eax,(%esp)
c01046e8:	e8 26 00 00 00       	call   c0104713 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c01046ed:	e8 95 fc ff ff       	call   c0104387 <__intr_save>
c01046f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c01046f5:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01046fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01046fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104700:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104703:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104706:	8b 40 04             	mov    0x4(%eax),%eax
c0104709:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c010470c:	e9 97 fe ff ff       	jmp    c01045a8 <slob_alloc+0x6a>
}
c0104711:	c9                   	leave  
c0104712:	c3                   	ret    

c0104713 <slob_free>:

static void slob_free(void *block, int size)
{
c0104713:	55                   	push   %ebp
c0104714:	89 e5                	mov    %esp,%ebp
c0104716:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104719:	8b 45 08             	mov    0x8(%ebp),%eax
c010471c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c010471f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104723:	75 05                	jne    c010472a <slob_free+0x17>
		return;
c0104725:	e9 ff 00 00 00       	jmp    c0104829 <slob_free+0x116>

	if (size)
c010472a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010472e:	74 10                	je     c0104740 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104730:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104733:	83 c0 07             	add    $0x7,%eax
c0104736:	c1 e8 03             	shr    $0x3,%eax
c0104739:	89 c2                	mov    %eax,%edx
c010473b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010473e:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104740:	e8 42 fc ff ff       	call   c0104387 <__intr_save>
c0104745:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104748:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010474d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104750:	eb 27                	jmp    c0104779 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104755:	8b 40 04             	mov    0x4(%eax),%eax
c0104758:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010475b:	77 13                	ja     c0104770 <slob_free+0x5d>
c010475d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104760:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104763:	77 27                	ja     c010478c <slob_free+0x79>
c0104765:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104768:	8b 40 04             	mov    0x4(%eax),%eax
c010476b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010476e:	77 1c                	ja     c010478c <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104770:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104773:	8b 40 04             	mov    0x4(%eax),%eax
c0104776:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104779:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010477f:	76 d1                	jbe    c0104752 <slob_free+0x3f>
c0104781:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104784:	8b 40 04             	mov    0x4(%eax),%eax
c0104787:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010478a:	76 c6                	jbe    c0104752 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c010478c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010478f:	8b 00                	mov    (%eax),%eax
c0104791:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104798:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010479b:	01 c2                	add    %eax,%edx
c010479d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a0:	8b 40 04             	mov    0x4(%eax),%eax
c01047a3:	39 c2                	cmp    %eax,%edx
c01047a5:	75 25                	jne    c01047cc <slob_free+0xb9>
		b->units += cur->next->units;
c01047a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047aa:	8b 10                	mov    (%eax),%edx
c01047ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047af:	8b 40 04             	mov    0x4(%eax),%eax
c01047b2:	8b 00                	mov    (%eax),%eax
c01047b4:	01 c2                	add    %eax,%edx
c01047b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047b9:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c01047bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047be:	8b 40 04             	mov    0x4(%eax),%eax
c01047c1:	8b 50 04             	mov    0x4(%eax),%edx
c01047c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047c7:	89 50 04             	mov    %edx,0x4(%eax)
c01047ca:	eb 0c                	jmp    c01047d8 <slob_free+0xc5>
	} else
		b->next = cur->next;
c01047cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047cf:	8b 50 04             	mov    0x4(%eax),%edx
c01047d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047d5:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c01047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047db:	8b 00                	mov    (%eax),%eax
c01047dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01047e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e7:	01 d0                	add    %edx,%eax
c01047e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047ec:	75 1f                	jne    c010480d <slob_free+0xfa>
		cur->units += b->units;
c01047ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f1:	8b 10                	mov    (%eax),%edx
c01047f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047f6:	8b 00                	mov    (%eax),%eax
c01047f8:	01 c2                	add    %eax,%edx
c01047fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fd:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c01047ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104802:	8b 50 04             	mov    0x4(%eax),%edx
c0104805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104808:	89 50 04             	mov    %edx,0x4(%eax)
c010480b:	eb 09                	jmp    c0104816 <slob_free+0x103>
	} else
		cur->next = b;
c010480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104810:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104813:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104816:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104819:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c010481e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104821:	89 04 24             	mov    %eax,(%esp)
c0104824:	e8 88 fb ff ff       	call   c01043b1 <__intr_restore>
}
c0104829:	c9                   	leave  
c010482a:	c3                   	ret    

c010482b <slob_init>:



void
slob_init(void) {
c010482b:	55                   	push   %ebp
c010482c:	89 e5                	mov    %esp,%ebp
c010482e:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104831:	c7 04 24 02 aa 10 c0 	movl   $0xc010aa02,(%esp)
c0104838:	e8 16 bb ff ff       	call   c0100353 <cprintf>
}
c010483d:	c9                   	leave  
c010483e:	c3                   	ret    

c010483f <kmalloc_init>:

inline void 
kmalloc_init(void) {
c010483f:	55                   	push   %ebp
c0104840:	89 e5                	mov    %esp,%ebp
c0104842:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104845:	e8 e1 ff ff ff       	call   c010482b <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c010484a:	c7 04 24 16 aa 10 c0 	movl   $0xc010aa16,(%esp)
c0104851:	e8 fd ba ff ff       	call   c0100353 <cprintf>
}
c0104856:	c9                   	leave  
c0104857:	c3                   	ret    

c0104858 <slob_allocated>:

size_t
slob_allocated(void) {
c0104858:	55                   	push   %ebp
c0104859:	89 e5                	mov    %esp,%ebp
  return 0;
c010485b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104860:	5d                   	pop    %ebp
c0104861:	c3                   	ret    

c0104862 <kallocated>:

size_t
kallocated(void) {
c0104862:	55                   	push   %ebp
c0104863:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104865:	e8 ee ff ff ff       	call   c0104858 <slob_allocated>
}
c010486a:	5d                   	pop    %ebp
c010486b:	c3                   	ret    

c010486c <find_order>:

static int find_order(int size)
{
c010486c:	55                   	push   %ebp
c010486d:	89 e5                	mov    %esp,%ebp
c010486f:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104872:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104879:	eb 07                	jmp    c0104882 <find_order+0x16>
		order++;
c010487b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c010487f:	d1 7d 08             	sarl   0x8(%ebp)
c0104882:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104889:	7f f0                	jg     c010487b <find_order+0xf>
		order++;
	return order;
c010488b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010488e:	c9                   	leave  
c010488f:	c3                   	ret    

c0104890 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104890:	55                   	push   %ebp
c0104891:	89 e5                	mov    %esp,%ebp
c0104893:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104896:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c010489d:	77 38                	ja     c01048d7 <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c010489f:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a2:	8d 50 08             	lea    0x8(%eax),%edx
c01048a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048ac:	00 
c01048ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048b4:	89 14 24             	mov    %edx,(%esp)
c01048b7:	e8 82 fc ff ff       	call   c010453e <slob_alloc>
c01048bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c01048bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048c3:	74 08                	je     c01048cd <__kmalloc+0x3d>
c01048c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c8:	83 c0 08             	add    $0x8,%eax
c01048cb:	eb 05                	jmp    c01048d2 <__kmalloc+0x42>
c01048cd:	b8 00 00 00 00       	mov    $0x0,%eax
c01048d2:	e9 a6 00 00 00       	jmp    c010497d <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c01048d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048de:	00 
c01048df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048e6:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c01048ed:	e8 4c fc ff ff       	call   c010453e <slob_alloc>
c01048f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c01048f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048f9:	75 07                	jne    c0104902 <__kmalloc+0x72>
		return 0;
c01048fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0104900:	eb 7b                	jmp    c010497d <__kmalloc+0xed>

	bb->order = find_order(size);
c0104902:	8b 45 08             	mov    0x8(%ebp),%eax
c0104905:	89 04 24             	mov    %eax,(%esp)
c0104908:	e8 5f ff ff ff       	call   c010486c <find_order>
c010490d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104910:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104912:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104915:	8b 00                	mov    (%eax),%eax
c0104917:	89 44 24 04          	mov    %eax,0x4(%esp)
c010491b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010491e:	89 04 24             	mov    %eax,(%esp)
c0104921:	e8 ab fb ff ff       	call   c01044d1 <__slob_get_free_pages>
c0104926:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104929:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c010492c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010492f:	8b 40 04             	mov    0x4(%eax),%eax
c0104932:	85 c0                	test   %eax,%eax
c0104934:	74 2f                	je     c0104965 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104936:	e8 4c fa ff ff       	call   c0104387 <__intr_save>
c010493b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c010493e:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c0104944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104947:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c010494a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010494d:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c0104952:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104955:	89 04 24             	mov    %eax,(%esp)
c0104958:	e8 54 fa ff ff       	call   c01043b1 <__intr_restore>
		return bb->pages;
c010495d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104960:	8b 40 04             	mov    0x4(%eax),%eax
c0104963:	eb 18                	jmp    c010497d <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104965:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c010496c:	00 
c010496d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104970:	89 04 24             	mov    %eax,(%esp)
c0104973:	e8 9b fd ff ff       	call   c0104713 <slob_free>
	return 0;
c0104978:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010497d:	c9                   	leave  
c010497e:	c3                   	ret    

c010497f <kmalloc>:

void *
kmalloc(size_t size)
{
c010497f:	55                   	push   %ebp
c0104980:	89 e5                	mov    %esp,%ebp
c0104982:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104985:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010498c:	00 
c010498d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104990:	89 04 24             	mov    %eax,(%esp)
c0104993:	e8 f8 fe ff ff       	call   c0104890 <__kmalloc>
}
c0104998:	c9                   	leave  
c0104999:	c3                   	ret    

c010499a <kfree>:


void kfree(void *block)
{
c010499a:	55                   	push   %ebp
c010499b:	89 e5                	mov    %esp,%ebp
c010499d:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c01049a0:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01049a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049ab:	75 05                	jne    c01049b2 <kfree+0x18>
		return;
c01049ad:	e9 a2 00 00 00       	jmp    c0104a54 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01049b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01049b5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049ba:	85 c0                	test   %eax,%eax
c01049bc:	75 7f                	jne    c0104a3d <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c01049be:	e8 c4 f9 ff ff       	call   c0104387 <__intr_save>
c01049c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01049c6:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c01049cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049ce:	eb 5c                	jmp    c0104a2c <kfree+0x92>
			if (bb->pages == block) {
c01049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d3:	8b 40 04             	mov    0x4(%eax),%eax
c01049d6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049d9:	75 3f                	jne    c0104a1a <kfree+0x80>
				*last = bb->next;
c01049db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049de:	8b 50 08             	mov    0x8(%eax),%edx
c01049e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e4:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c01049e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049e9:	89 04 24             	mov    %eax,(%esp)
c01049ec:	e8 c0 f9 ff ff       	call   c01043b1 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c01049f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049f4:	8b 10                	mov    (%eax),%edx
c01049f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049fd:	89 04 24             	mov    %eax,(%esp)
c0104a00:	e8 05 fb ff ff       	call   c010450a <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104a05:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104a0c:	00 
c0104a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a10:	89 04 24             	mov    %eax,(%esp)
c0104a13:	e8 fb fc ff ff       	call   c0104713 <slob_free>
				return;
c0104a18:	eb 3a                	jmp    c0104a54 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a1d:	83 c0 08             	add    $0x8,%eax
c0104a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a26:	8b 40 08             	mov    0x8(%eax),%eax
c0104a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a30:	75 9e                	jne    c01049d0 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a35:	89 04 24             	mov    %eax,(%esp)
c0104a38:	e8 74 f9 ff ff       	call   c01043b1 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a40:	83 e8 08             	sub    $0x8,%eax
c0104a43:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a4a:	00 
c0104a4b:	89 04 24             	mov    %eax,(%esp)
c0104a4e:	e8 c0 fc ff ff       	call   c0104713 <slob_free>
	return;
c0104a53:	90                   	nop
}
c0104a54:	c9                   	leave  
c0104a55:	c3                   	ret    

c0104a56 <ksize>:


unsigned int ksize(const void *block)
{
c0104a56:	55                   	push   %ebp
c0104a57:	89 e5                	mov    %esp,%ebp
c0104a59:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a60:	75 07                	jne    c0104a69 <ksize+0x13>
		return 0;
c0104a62:	b8 00 00 00 00       	mov    $0x0,%eax
c0104a67:	eb 6b                	jmp    c0104ad4 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a6c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a71:	85 c0                	test   %eax,%eax
c0104a73:	75 54                	jne    c0104ac9 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104a75:	e8 0d f9 ff ff       	call   c0104387 <__intr_save>
c0104a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104a7d:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a85:	eb 31                	jmp    c0104ab8 <ksize+0x62>
			if (bb->pages == block) {
c0104a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a8a:	8b 40 04             	mov    0x4(%eax),%eax
c0104a8d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104a90:	75 1d                	jne    c0104aaf <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a95:	89 04 24             	mov    %eax,(%esp)
c0104a98:	e8 14 f9 ff ff       	call   c01043b1 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa0:	8b 00                	mov    (%eax),%eax
c0104aa2:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104aa7:	89 c1                	mov    %eax,%ecx
c0104aa9:	d3 e2                	shl    %cl,%edx
c0104aab:	89 d0                	mov    %edx,%eax
c0104aad:	eb 25                	jmp    c0104ad4 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab2:	8b 40 08             	mov    0x8(%eax),%eax
c0104ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104abc:	75 c9                	jne    c0104a87 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac1:	89 04 24             	mov    %eax,(%esp)
c0104ac4:	e8 e8 f8 ff ff       	call   c01043b1 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104acc:	83 e8 08             	sub    $0x8,%eax
c0104acf:	8b 00                	mov    (%eax),%eax
c0104ad1:	c1 e0 03             	shl    $0x3,%eax
}
c0104ad4:	c9                   	leave  
c0104ad5:	c3                   	ret    

c0104ad6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104ad6:	55                   	push   %ebp
c0104ad7:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104ad9:	8b 55 08             	mov    0x8(%ebp),%edx
c0104adc:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104ae1:	29 c2                	sub    %eax,%edx
c0104ae3:	89 d0                	mov    %edx,%eax
c0104ae5:	c1 f8 05             	sar    $0x5,%eax
}
c0104ae8:	5d                   	pop    %ebp
c0104ae9:	c3                   	ret    

c0104aea <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104aea:	55                   	push   %ebp
c0104aeb:	89 e5                	mov    %esp,%ebp
c0104aed:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af3:	89 04 24             	mov    %eax,(%esp)
c0104af6:	e8 db ff ff ff       	call   c0104ad6 <page2ppn>
c0104afb:	c1 e0 0c             	shl    $0xc,%eax
}
c0104afe:	c9                   	leave  
c0104aff:	c3                   	ret    

c0104b00 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b00:	55                   	push   %ebp
c0104b01:	89 e5                	mov    %esp,%ebp
c0104b03:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b09:	c1 e8 0c             	shr    $0xc,%eax
c0104b0c:	89 c2                	mov    %eax,%edx
c0104b0e:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104b13:	39 c2                	cmp    %eax,%edx
c0104b15:	72 1c                	jb     c0104b33 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104b17:	c7 44 24 08 34 aa 10 	movl   $0xc010aa34,0x8(%esp)
c0104b1e:	c0 
c0104b1f:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104b26:	00 
c0104b27:	c7 04 24 53 aa 10 c0 	movl   $0xc010aa53,(%esp)
c0104b2e:	e8 aa c1 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0104b33:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104b38:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b3b:	c1 ea 0c             	shr    $0xc,%edx
c0104b3e:	c1 e2 05             	shl    $0x5,%edx
c0104b41:	01 d0                	add    %edx,%eax
}
c0104b43:	c9                   	leave  
c0104b44:	c3                   	ret    

c0104b45 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104b45:	55                   	push   %ebp
c0104b46:	89 e5                	mov    %esp,%ebp
c0104b48:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4e:	89 04 24             	mov    %eax,(%esp)
c0104b51:	e8 94 ff ff ff       	call   c0104aea <page2pa>
c0104b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b5c:	c1 e8 0c             	shr    $0xc,%eax
c0104b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b62:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104b67:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104b6a:	72 23                	jb     c0104b8f <page2kva+0x4a>
c0104b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b73:	c7 44 24 08 64 aa 10 	movl   $0xc010aa64,0x8(%esp)
c0104b7a:	c0 
c0104b7b:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104b82:	00 
c0104b83:	c7 04 24 53 aa 10 c0 	movl   $0xc010aa53,(%esp)
c0104b8a:	e8 4e c1 ff ff       	call   c0100cdd <__panic>
c0104b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b92:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104b97:	c9                   	leave  
c0104b98:	c3                   	ret    

c0104b99 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104b99:	55                   	push   %ebp
c0104b9a:	89 e5                	mov    %esp,%ebp
c0104b9c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ba2:	83 e0 01             	and    $0x1,%eax
c0104ba5:	85 c0                	test   %eax,%eax
c0104ba7:	75 1c                	jne    c0104bc5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104ba9:	c7 44 24 08 88 aa 10 	movl   $0xc010aa88,0x8(%esp)
c0104bb0:	c0 
c0104bb1:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104bb8:	00 
c0104bb9:	c7 04 24 53 aa 10 c0 	movl   $0xc010aa53,(%esp)
c0104bc0:	e8 18 c1 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104bc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bcd:	89 04 24             	mov    %eax,(%esp)
c0104bd0:	e8 2b ff ff ff       	call   c0104b00 <pa2page>
}
c0104bd5:	c9                   	leave  
c0104bd6:	c3                   	ret    

c0104bd7 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104bd7:	55                   	push   %ebp
c0104bd8:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bdd:	8b 00                	mov    (%eax),%eax
}
c0104bdf:	5d                   	pop    %ebp
c0104be0:	c3                   	ret    

c0104be1 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104be1:	55                   	push   %ebp
c0104be2:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104be4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104be7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104bea:	89 10                	mov    %edx,(%eax)
}
c0104bec:	5d                   	pop    %ebp
c0104bed:	c3                   	ret    

c0104bee <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104bee:	55                   	push   %ebp
c0104bef:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bf4:	8b 00                	mov    (%eax),%eax
c0104bf6:	8d 50 01             	lea    0x1(%eax),%edx
c0104bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bfc:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c01:	8b 00                	mov    (%eax),%eax
}
c0104c03:	5d                   	pop    %ebp
c0104c04:	c3                   	ret    

c0104c05 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104c05:	55                   	push   %ebp
c0104c06:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c0b:	8b 00                	mov    (%eax),%eax
c0104c0d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c13:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c18:	8b 00                	mov    (%eax),%eax
}
c0104c1a:	5d                   	pop    %ebp
c0104c1b:	c3                   	ret    

c0104c1c <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104c1c:	55                   	push   %ebp
c0104c1d:	89 e5                	mov    %esp,%ebp
c0104c1f:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104c22:	9c                   	pushf  
c0104c23:	58                   	pop    %eax
c0104c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104c2a:	25 00 02 00 00       	and    $0x200,%eax
c0104c2f:	85 c0                	test   %eax,%eax
c0104c31:	74 0c                	je     c0104c3f <__intr_save+0x23>
        intr_disable();
c0104c33:	e8 fd d2 ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0104c38:	b8 01 00 00 00       	mov    $0x1,%eax
c0104c3d:	eb 05                	jmp    c0104c44 <__intr_save+0x28>
    }
    return 0;
c0104c3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104c44:	c9                   	leave  
c0104c45:	c3                   	ret    

c0104c46 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104c46:	55                   	push   %ebp
c0104c47:	89 e5                	mov    %esp,%ebp
c0104c49:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104c4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104c50:	74 05                	je     c0104c57 <__intr_restore+0x11>
        intr_enable();
c0104c52:	e8 d8 d2 ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104c57:	c9                   	leave  
c0104c58:	c3                   	ret    

c0104c59 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104c59:	55                   	push   %ebp
c0104c5a:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c5f:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104c62:	b8 23 00 00 00       	mov    $0x23,%eax
c0104c67:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104c69:	b8 23 00 00 00       	mov    $0x23,%eax
c0104c6e:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104c70:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c75:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104c77:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c7c:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104c7e:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c83:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104c85:	ea 8c 4c 10 c0 08 00 	ljmp   $0x8,$0xc0104c8c
}
c0104c8c:	5d                   	pop    %ebp
c0104c8d:	c3                   	ret    

c0104c8e <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104c8e:	55                   	push   %ebp
c0104c8f:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c94:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104c99:	5d                   	pop    %ebp
c0104c9a:	c3                   	ret    

c0104c9b <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104c9b:	55                   	push   %ebp
c0104c9c:	89 e5                	mov    %esp,%ebp
c0104c9e:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104ca1:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104ca6:	89 04 24             	mov    %eax,(%esp)
c0104ca9:	e8 e0 ff ff ff       	call   c0104c8e <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104cae:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104cb5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104cb7:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104cbe:	68 00 
c0104cc0:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104cc5:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104ccb:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104cd0:	c1 e8 10             	shr    $0x10,%eax
c0104cd3:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104cd8:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104cdf:	83 e0 f0             	and    $0xfffffff0,%eax
c0104ce2:	83 c8 09             	or     $0x9,%eax
c0104ce5:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104cea:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104cf1:	83 e0 ef             	and    $0xffffffef,%eax
c0104cf4:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104cf9:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104d00:	83 e0 9f             	and    $0xffffff9f,%eax
c0104d03:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104d08:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104d0f:	83 c8 80             	or     $0xffffff80,%eax
c0104d12:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104d17:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104d1e:	83 e0 f0             	and    $0xfffffff0,%eax
c0104d21:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104d26:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104d2d:	83 e0 ef             	and    $0xffffffef,%eax
c0104d30:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104d35:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104d3c:	83 e0 df             	and    $0xffffffdf,%eax
c0104d3f:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104d44:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104d4b:	83 c8 40             	or     $0x40,%eax
c0104d4e:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104d53:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104d5a:	83 e0 7f             	and    $0x7f,%eax
c0104d5d:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104d62:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104d67:	c1 e8 18             	shr    $0x18,%eax
c0104d6a:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104d6f:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104d76:	e8 de fe ff ff       	call   c0104c59 <lgdt>
c0104d7b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104d81:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104d85:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104d88:	c9                   	leave  
c0104d89:	c3                   	ret    

c0104d8a <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104d8a:	55                   	push   %ebp
c0104d8b:	89 e5                	mov    %esp,%ebp
c0104d8d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104d90:	c7 05 24 7b 12 c0 28 	movl   $0xc010a928,0xc0127b24
c0104d97:	a9 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104d9a:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d9f:	8b 00                	mov    (%eax),%eax
c0104da1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104da5:	c7 04 24 b4 aa 10 c0 	movl   $0xc010aab4,(%esp)
c0104dac:	e8 a2 b5 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104db1:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104db6:	8b 40 04             	mov    0x4(%eax),%eax
c0104db9:	ff d0                	call   *%eax
}
c0104dbb:	c9                   	leave  
c0104dbc:	c3                   	ret    

c0104dbd <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104dbd:	55                   	push   %ebp
c0104dbe:	89 e5                	mov    %esp,%ebp
c0104dc0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104dc3:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104dc8:	8b 40 08             	mov    0x8(%eax),%eax
c0104dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104dce:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dd2:	8b 55 08             	mov    0x8(%ebp),%edx
c0104dd5:	89 14 24             	mov    %edx,(%esp)
c0104dd8:	ff d0                	call   *%eax
}
c0104dda:	c9                   	leave  
c0104ddb:	c3                   	ret    

c0104ddc <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104ddc:	55                   	push   %ebp
c0104ddd:	89 e5                	mov    %esp,%ebp
c0104ddf:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104de2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104de9:	e8 2e fe ff ff       	call   c0104c1c <__intr_save>
c0104dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104df1:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104df6:	8b 40 0c             	mov    0xc(%eax),%eax
c0104df9:	8b 55 08             	mov    0x8(%ebp),%edx
c0104dfc:	89 14 24             	mov    %edx,(%esp)
c0104dff:	ff d0                	call   *%eax
c0104e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e07:	89 04 24             	mov    %eax,(%esp)
c0104e0a:	e8 37 fe ff ff       	call   c0104c46 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e13:	75 2d                	jne    c0104e42 <alloc_pages+0x66>
c0104e15:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104e19:	77 27                	ja     c0104e42 <alloc_pages+0x66>
c0104e1b:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104e20:	85 c0                	test   %eax,%eax
c0104e22:	74 1e                	je     c0104e42 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104e24:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e27:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104e2c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e33:	00 
c0104e34:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e38:	89 04 24             	mov    %eax,(%esp)
c0104e3b:	e8 67 19 00 00       	call   c01067a7 <swap_out>
    }
c0104e40:	eb a7                	jmp    c0104de9 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104e45:	c9                   	leave  
c0104e46:	c3                   	ret    

c0104e47 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104e47:	55                   	push   %ebp
c0104e48:	89 e5                	mov    %esp,%ebp
c0104e4a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104e4d:	e8 ca fd ff ff       	call   c0104c1c <__intr_save>
c0104e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104e55:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e5a:	8b 40 10             	mov    0x10(%eax),%eax
c0104e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e60:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e64:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e67:	89 14 24             	mov    %edx,(%esp)
c0104e6a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e6f:	89 04 24             	mov    %eax,(%esp)
c0104e72:	e8 cf fd ff ff       	call   c0104c46 <__intr_restore>
}
c0104e77:	c9                   	leave  
c0104e78:	c3                   	ret    

c0104e79 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104e79:	55                   	push   %ebp
c0104e7a:	89 e5                	mov    %esp,%ebp
c0104e7c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104e7f:	e8 98 fd ff ff       	call   c0104c1c <__intr_save>
c0104e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104e87:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e8c:	8b 40 14             	mov    0x14(%eax),%eax
c0104e8f:	ff d0                	call   *%eax
c0104e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e97:	89 04 24             	mov    %eax,(%esp)
c0104e9a:	e8 a7 fd ff ff       	call   c0104c46 <__intr_restore>
    return ret;
c0104e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104ea2:	c9                   	leave  
c0104ea3:	c3                   	ret    

c0104ea4 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104ea4:	55                   	push   %ebp
c0104ea5:	89 e5                	mov    %esp,%ebp
c0104ea7:	57                   	push   %edi
c0104ea8:	56                   	push   %esi
c0104ea9:	53                   	push   %ebx
c0104eaa:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104eb0:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104eb7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104ebe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104ec5:	c7 04 24 cb aa 10 c0 	movl   $0xc010aacb,(%esp)
c0104ecc:	e8 82 b4 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104ed1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104ed8:	e9 15 01 00 00       	jmp    c0104ff2 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104edd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ee0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ee3:	89 d0                	mov    %edx,%eax
c0104ee5:	c1 e0 02             	shl    $0x2,%eax
c0104ee8:	01 d0                	add    %edx,%eax
c0104eea:	c1 e0 02             	shl    $0x2,%eax
c0104eed:	01 c8                	add    %ecx,%eax
c0104eef:	8b 50 08             	mov    0x8(%eax),%edx
c0104ef2:	8b 40 04             	mov    0x4(%eax),%eax
c0104ef5:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104ef8:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104efb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104efe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f01:	89 d0                	mov    %edx,%eax
c0104f03:	c1 e0 02             	shl    $0x2,%eax
c0104f06:	01 d0                	add    %edx,%eax
c0104f08:	c1 e0 02             	shl    $0x2,%eax
c0104f0b:	01 c8                	add    %ecx,%eax
c0104f0d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104f10:	8b 58 10             	mov    0x10(%eax),%ebx
c0104f13:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f16:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f19:	01 c8                	add    %ecx,%eax
c0104f1b:	11 da                	adc    %ebx,%edx
c0104f1d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104f20:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104f23:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f26:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f29:	89 d0                	mov    %edx,%eax
c0104f2b:	c1 e0 02             	shl    $0x2,%eax
c0104f2e:	01 d0                	add    %edx,%eax
c0104f30:	c1 e0 02             	shl    $0x2,%eax
c0104f33:	01 c8                	add    %ecx,%eax
c0104f35:	83 c0 14             	add    $0x14,%eax
c0104f38:	8b 00                	mov    (%eax),%eax
c0104f3a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104f40:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f43:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104f46:	83 c0 ff             	add    $0xffffffff,%eax
c0104f49:	83 d2 ff             	adc    $0xffffffff,%edx
c0104f4c:	89 c6                	mov    %eax,%esi
c0104f4e:	89 d7                	mov    %edx,%edi
c0104f50:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f53:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f56:	89 d0                	mov    %edx,%eax
c0104f58:	c1 e0 02             	shl    $0x2,%eax
c0104f5b:	01 d0                	add    %edx,%eax
c0104f5d:	c1 e0 02             	shl    $0x2,%eax
c0104f60:	01 c8                	add    %ecx,%eax
c0104f62:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104f65:	8b 58 10             	mov    0x10(%eax),%ebx
c0104f68:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104f6e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104f72:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104f76:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104f7a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f7d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f80:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f84:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104f88:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104f8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104f90:	c7 04 24 d8 aa 10 c0 	movl   $0xc010aad8,(%esp)
c0104f97:	e8 b7 b3 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104f9c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fa2:	89 d0                	mov    %edx,%eax
c0104fa4:	c1 e0 02             	shl    $0x2,%eax
c0104fa7:	01 d0                	add    %edx,%eax
c0104fa9:	c1 e0 02             	shl    $0x2,%eax
c0104fac:	01 c8                	add    %ecx,%eax
c0104fae:	83 c0 14             	add    $0x14,%eax
c0104fb1:	8b 00                	mov    (%eax),%eax
c0104fb3:	83 f8 01             	cmp    $0x1,%eax
c0104fb6:	75 36                	jne    c0104fee <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104fb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104fbe:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104fc1:	77 2b                	ja     c0104fee <page_init+0x14a>
c0104fc3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104fc6:	72 05                	jb     c0104fcd <page_init+0x129>
c0104fc8:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104fcb:	73 21                	jae    c0104fee <page_init+0x14a>
c0104fcd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104fd1:	77 1b                	ja     c0104fee <page_init+0x14a>
c0104fd3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104fd7:	72 09                	jb     c0104fe2 <page_init+0x13e>
c0104fd9:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104fe0:	77 0c                	ja     c0104fee <page_init+0x14a>
                maxpa = end;
c0104fe2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104fe5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104fe8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104feb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104fee:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104ff2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104ff5:	8b 00                	mov    (%eax),%eax
c0104ff7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104ffa:	0f 8f dd fe ff ff    	jg     c0104edd <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0105000:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105004:	72 1d                	jb     c0105023 <page_init+0x17f>
c0105006:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010500a:	77 09                	ja     c0105015 <page_init+0x171>
c010500c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0105013:	76 0e                	jbe    c0105023 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0105015:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010501c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0105023:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105026:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105029:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010502d:	c1 ea 0c             	shr    $0xc,%edx
c0105030:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0105035:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c010503c:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c0105041:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105044:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105047:	01 d0                	add    %edx,%eax
c0105049:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010504c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010504f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105054:	f7 75 ac             	divl   -0x54(%ebp)
c0105057:	89 d0                	mov    %edx,%eax
c0105059:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010505c:	29 c2                	sub    %eax,%edx
c010505e:	89 d0                	mov    %edx,%eax
c0105060:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c0105065:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010506c:	eb 27                	jmp    c0105095 <page_init+0x1f1>
        SetPageReserved(pages + i);
c010506e:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0105073:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105076:	c1 e2 05             	shl    $0x5,%edx
c0105079:	01 d0                	add    %edx,%eax
c010507b:	83 c0 04             	add    $0x4,%eax
c010507e:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0105085:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105088:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010508b:	8b 55 90             	mov    -0x70(%ebp),%edx
c010508e:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105091:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105095:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105098:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010509d:	39 c2                	cmp    %eax,%edx
c010509f:	72 cd                	jb     c010506e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01050a1:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01050a6:	c1 e0 05             	shl    $0x5,%eax
c01050a9:	89 c2                	mov    %eax,%edx
c01050ab:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01050b0:	01 d0                	add    %edx,%eax
c01050b2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01050b5:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01050bc:	77 23                	ja     c01050e1 <page_init+0x23d>
c01050be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01050c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050c5:	c7 44 24 08 08 ab 10 	movl   $0xc010ab08,0x8(%esp)
c01050cc:	c0 
c01050cd:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01050d4:	00 
c01050d5:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01050dc:	e8 fc bb ff ff       	call   c0100cdd <__panic>
c01050e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01050e4:	05 00 00 00 40       	add    $0x40000000,%eax
c01050e9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01050ec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01050f3:	e9 74 01 00 00       	jmp    c010526c <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01050f8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01050fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050fe:	89 d0                	mov    %edx,%eax
c0105100:	c1 e0 02             	shl    $0x2,%eax
c0105103:	01 d0                	add    %edx,%eax
c0105105:	c1 e0 02             	shl    $0x2,%eax
c0105108:	01 c8                	add    %ecx,%eax
c010510a:	8b 50 08             	mov    0x8(%eax),%edx
c010510d:	8b 40 04             	mov    0x4(%eax),%eax
c0105110:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105113:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105116:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105119:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010511c:	89 d0                	mov    %edx,%eax
c010511e:	c1 e0 02             	shl    $0x2,%eax
c0105121:	01 d0                	add    %edx,%eax
c0105123:	c1 e0 02             	shl    $0x2,%eax
c0105126:	01 c8                	add    %ecx,%eax
c0105128:	8b 48 0c             	mov    0xc(%eax),%ecx
c010512b:	8b 58 10             	mov    0x10(%eax),%ebx
c010512e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105131:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105134:	01 c8                	add    %ecx,%eax
c0105136:	11 da                	adc    %ebx,%edx
c0105138:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010513b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010513e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105141:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105144:	89 d0                	mov    %edx,%eax
c0105146:	c1 e0 02             	shl    $0x2,%eax
c0105149:	01 d0                	add    %edx,%eax
c010514b:	c1 e0 02             	shl    $0x2,%eax
c010514e:	01 c8                	add    %ecx,%eax
c0105150:	83 c0 14             	add    $0x14,%eax
c0105153:	8b 00                	mov    (%eax),%eax
c0105155:	83 f8 01             	cmp    $0x1,%eax
c0105158:	0f 85 0a 01 00 00    	jne    c0105268 <page_init+0x3c4>
            if (begin < freemem) {
c010515e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105161:	ba 00 00 00 00       	mov    $0x0,%edx
c0105166:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105169:	72 17                	jb     c0105182 <page_init+0x2de>
c010516b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010516e:	77 05                	ja     c0105175 <page_init+0x2d1>
c0105170:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105173:	76 0d                	jbe    c0105182 <page_init+0x2de>
                begin = freemem;
c0105175:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105178:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010517b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105182:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105186:	72 1d                	jb     c01051a5 <page_init+0x301>
c0105188:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010518c:	77 09                	ja     c0105197 <page_init+0x2f3>
c010518e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0105195:	76 0e                	jbe    c01051a5 <page_init+0x301>
                end = KMEMSIZE;
c0105197:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010519e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01051a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051ab:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051ae:	0f 87 b4 00 00 00    	ja     c0105268 <page_init+0x3c4>
c01051b4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051b7:	72 09                	jb     c01051c2 <page_init+0x31e>
c01051b9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01051bc:	0f 83 a6 00 00 00    	jae    c0105268 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c01051c2:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01051c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01051cc:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01051cf:	01 d0                	add    %edx,%eax
c01051d1:	83 e8 01             	sub    $0x1,%eax
c01051d4:	89 45 98             	mov    %eax,-0x68(%ebp)
c01051d7:	8b 45 98             	mov    -0x68(%ebp),%eax
c01051da:	ba 00 00 00 00       	mov    $0x0,%edx
c01051df:	f7 75 9c             	divl   -0x64(%ebp)
c01051e2:	89 d0                	mov    %edx,%eax
c01051e4:	8b 55 98             	mov    -0x68(%ebp),%edx
c01051e7:	29 c2                	sub    %eax,%edx
c01051e9:	89 d0                	mov    %edx,%eax
c01051eb:	ba 00 00 00 00       	mov    $0x0,%edx
c01051f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01051f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01051f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01051f9:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01051fc:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01051ff:	ba 00 00 00 00       	mov    $0x0,%edx
c0105204:	89 c7                	mov    %eax,%edi
c0105206:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010520c:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010520f:	89 d0                	mov    %edx,%eax
c0105211:	83 e0 00             	and    $0x0,%eax
c0105214:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105217:	8b 45 80             	mov    -0x80(%ebp),%eax
c010521a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010521d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105220:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105223:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105229:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010522c:	77 3a                	ja     c0105268 <page_init+0x3c4>
c010522e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105231:	72 05                	jb     c0105238 <page_init+0x394>
c0105233:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105236:	73 30                	jae    c0105268 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105238:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010523b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010523e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105241:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105244:	29 c8                	sub    %ecx,%eax
c0105246:	19 da                	sbb    %ebx,%edx
c0105248:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010524c:	c1 ea 0c             	shr    $0xc,%edx
c010524f:	89 c3                	mov    %eax,%ebx
c0105251:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105254:	89 04 24             	mov    %eax,(%esp)
c0105257:	e8 a4 f8 ff ff       	call   c0104b00 <pa2page>
c010525c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105260:	89 04 24             	mov    %eax,(%esp)
c0105263:	e8 55 fb ff ff       	call   c0104dbd <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0105268:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010526c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010526f:	8b 00                	mov    (%eax),%eax
c0105271:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105274:	0f 8f 7e fe ff ff    	jg     c01050f8 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010527a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0105280:	5b                   	pop    %ebx
c0105281:	5e                   	pop    %esi
c0105282:	5f                   	pop    %edi
c0105283:	5d                   	pop    %ebp
c0105284:	c3                   	ret    

c0105285 <enable_paging>:

static void
enable_paging(void) {
c0105285:	55                   	push   %ebp
c0105286:	89 e5                	mov    %esp,%ebp
c0105288:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010528b:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c0105290:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105293:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105296:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0105299:	0f 20 c0             	mov    %cr0,%eax
c010529c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010529f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01052a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01052a5:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01052ac:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01052b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01052b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052b9:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01052bc:	c9                   	leave  
c01052bd:	c3                   	ret    

c01052be <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01052be:	55                   	push   %ebp
c01052bf:	89 e5                	mov    %esp,%ebp
c01052c1:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01052c4:	8b 45 14             	mov    0x14(%ebp),%eax
c01052c7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01052ca:	31 d0                	xor    %edx,%eax
c01052cc:	25 ff 0f 00 00       	and    $0xfff,%eax
c01052d1:	85 c0                	test   %eax,%eax
c01052d3:	74 24                	je     c01052f9 <boot_map_segment+0x3b>
c01052d5:	c7 44 24 0c 3a ab 10 	movl   $0xc010ab3a,0xc(%esp)
c01052dc:	c0 
c01052dd:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01052e4:	c0 
c01052e5:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01052ec:	00 
c01052ed:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01052f4:	e8 e4 b9 ff ff       	call   c0100cdd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01052f9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105300:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105303:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105308:	89 c2                	mov    %eax,%edx
c010530a:	8b 45 10             	mov    0x10(%ebp),%eax
c010530d:	01 c2                	add    %eax,%edx
c010530f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105312:	01 d0                	add    %edx,%eax
c0105314:	83 e8 01             	sub    $0x1,%eax
c0105317:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010531a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010531d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105322:	f7 75 f0             	divl   -0x10(%ebp)
c0105325:	89 d0                	mov    %edx,%eax
c0105327:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010532a:	29 c2                	sub    %eax,%edx
c010532c:	89 d0                	mov    %edx,%eax
c010532e:	c1 e8 0c             	shr    $0xc,%eax
c0105331:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105334:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105337:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010533a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010533d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105342:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105345:	8b 45 14             	mov    0x14(%ebp),%eax
c0105348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010534b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010534e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105353:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105356:	eb 6b                	jmp    c01053c3 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105358:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010535f:	00 
c0105360:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105363:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105367:	8b 45 08             	mov    0x8(%ebp),%eax
c010536a:	89 04 24             	mov    %eax,(%esp)
c010536d:	e8 d1 01 00 00       	call   c0105543 <get_pte>
c0105372:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105375:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105379:	75 24                	jne    c010539f <boot_map_segment+0xe1>
c010537b:	c7 44 24 0c 66 ab 10 	movl   $0xc010ab66,0xc(%esp)
c0105382:	c0 
c0105383:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c010538a:	c0 
c010538b:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105392:	00 
c0105393:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c010539a:	e8 3e b9 ff ff       	call   c0100cdd <__panic>
        *ptep = pa | PTE_P | perm;
c010539f:	8b 45 18             	mov    0x18(%ebp),%eax
c01053a2:	8b 55 14             	mov    0x14(%ebp),%edx
c01053a5:	09 d0                	or     %edx,%eax
c01053a7:	83 c8 01             	or     $0x1,%eax
c01053aa:	89 c2                	mov    %eax,%edx
c01053ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053af:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01053b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01053b5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01053bc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01053c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053c7:	75 8f                	jne    c0105358 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01053c9:	c9                   	leave  
c01053ca:	c3                   	ret    

c01053cb <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01053cb:	55                   	push   %ebp
c01053cc:	89 e5                	mov    %esp,%ebp
c01053ce:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01053d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053d8:	e8 ff f9 ff ff       	call   c0104ddc <alloc_pages>
c01053dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01053e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01053e4:	75 1c                	jne    c0105402 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01053e6:	c7 44 24 08 73 ab 10 	movl   $0xc010ab73,0x8(%esp)
c01053ed:	c0 
c01053ee:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01053f5:	00 
c01053f6:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01053fd:	e8 db b8 ff ff       	call   c0100cdd <__panic>
    }
    return page2kva(p);
c0105402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105405:	89 04 24             	mov    %eax,(%esp)
c0105408:	e8 38 f7 ff ff       	call   c0104b45 <page2kva>
}
c010540d:	c9                   	leave  
c010540e:	c3                   	ret    

c010540f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010540f:	55                   	push   %ebp
c0105410:	89 e5                	mov    %esp,%ebp
c0105412:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105415:	e8 70 f9 ff ff       	call   c0104d8a <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010541a:	e8 85 fa ff ff       	call   c0104ea4 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010541f:	e8 3b 05 00 00       	call   c010595f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105424:	e8 a2 ff ff ff       	call   c01053cb <boot_alloc_page>
c0105429:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c010542e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105433:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010543a:	00 
c010543b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105442:	00 
c0105443:	89 04 24             	mov    %eax,(%esp)
c0105446:	e8 69 47 00 00       	call   c0109bb4 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010544b:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105450:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105453:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010545a:	77 23                	ja     c010547f <pmm_init+0x70>
c010545c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010545f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105463:	c7 44 24 08 08 ab 10 	movl   $0xc010ab08,0x8(%esp)
c010546a:	c0 
c010546b:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105472:	00 
c0105473:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c010547a:	e8 5e b8 ff ff       	call   c0100cdd <__panic>
c010547f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105482:	05 00 00 00 40       	add    $0x40000000,%eax
c0105487:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c010548c:	e8 ec 04 00 00       	call   c010597d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105491:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105496:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010549c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01054a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054a4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01054ab:	77 23                	ja     c01054d0 <pmm_init+0xc1>
c01054ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054b4:	c7 44 24 08 08 ab 10 	movl   $0xc010ab08,0x8(%esp)
c01054bb:	c0 
c01054bc:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01054c3:	00 
c01054c4:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01054cb:	e8 0d b8 ff ff       	call   c0100cdd <__panic>
c01054d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054d3:	05 00 00 00 40       	add    $0x40000000,%eax
c01054d8:	83 c8 03             	or     $0x3,%eax
c01054db:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01054dd:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01054e2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01054e9:	00 
c01054ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01054f1:	00 
c01054f2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01054f9:	38 
c01054fa:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105501:	c0 
c0105502:	89 04 24             	mov    %eax,(%esp)
c0105505:	e8 b4 fd ff ff       	call   c01052be <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010550a:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010550f:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0105515:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010551b:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010551d:	e8 63 fd ff ff       	call   c0105285 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105522:	e8 74 f7 ff ff       	call   c0104c9b <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105527:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010552c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105532:	e8 e1 0a 00 00       	call   c0106018 <check_boot_pgdir>

    print_pgdir();
c0105537:	e8 6e 0f 00 00       	call   c01064aa <print_pgdir>
    
    kmalloc_init();
c010553c:	e8 fe f2 ff ff       	call   c010483f <kmalloc_init>

}
c0105541:	c9                   	leave  
c0105542:	c3                   	ret    

c0105543 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105543:	55                   	push   %ebp
c0105544:	89 e5                	mov    %esp,%ebp
c0105546:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
    //typedef uintptr_t pde_t;
    pde_t *pdep = &pgdir[PDX(la)];  // (1)获取页表
c0105549:	8b 45 0c             	mov    0xc(%ebp),%eax
c010554c:	c1 e8 16             	shr    $0x16,%eax
c010554f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105556:	8b 45 08             	mov    0x8(%ebp),%eax
c0105559:	01 d0                	add    %edx,%eax
c010555b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P))             // (2)假设页目录项不存在
c010555e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105561:	8b 00                	mov    (%eax),%eax
c0105563:	83 e0 01             	and    $0x1,%eax
c0105566:	85 c0                	test   %eax,%eax
c0105568:	0f 85 af 00 00 00    	jne    c010561d <get_pte+0xda>
    {      
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) // (3) check if creating is needed, then alloc page for page table
c010556e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105572:	74 15                	je     c0105589 <get_pte+0x46>
c0105574:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010557b:	e8 5c f8 ff ff       	call   c0104ddc <alloc_pages>
c0105580:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105587:	75 0a                	jne    c0105593 <get_pte+0x50>
        {    //假如不需要分配或是分配失败
            return NULL;
c0105589:	b8 00 00 00 00       	mov    $0x0,%eax
c010558e:	e9 e6 00 00 00       	jmp    c0105679 <get_pte+0x136>
        }
        set_page_ref(page, 1);                      // (4)设置被引用1次
c0105593:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010559a:	00 
c010559b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010559e:	89 04 24             	mov    %eax,(%esp)
c01055a1:	e8 3b f6 ff ff       	call   c0104be1 <set_page_ref>
        uintptr_t pa = page2pa(page);                  // (5)得到该页物理地址
c01055a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a9:	89 04 24             	mov    %eax,(%esp)
c01055ac:	e8 39 f5 ff ff       	call   c0104aea <page2pa>
c01055b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);                  // (6)物理地址转虚拟地址，并初始化
c01055b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055bd:	c1 e8 0c             	shr    $0xc,%eax
c01055c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055c3:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01055c8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01055cb:	72 23                	jb     c01055f0 <get_pte+0xad>
c01055cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055d4:	c7 44 24 08 64 aa 10 	movl   $0xc010aa64,0x8(%esp)
c01055db:	c0 
c01055dc:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
c01055e3:	00 
c01055e4:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01055eb:	e8 ed b6 ff ff       	call   c0100cdd <__panic>
c01055f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055f3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01055f8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01055ff:	00 
c0105600:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105607:	00 
c0105608:	89 04 24             	mov    %eax,(%esp)
c010560b:	e8 a4 45 00 00       	call   c0109bb4 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;            // (7)设置可读，可写，存在位
c0105610:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105613:	83 c8 07             	or     $0x7,%eax
c0105616:	89 c2                	mov    %eax,%edx
c0105618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010561b:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];     // (8) return page table entry
c010561d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105620:	8b 00                	mov    (%eax),%eax
c0105622:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105627:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010562a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010562d:	c1 e8 0c             	shr    $0xc,%eax
c0105630:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105633:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105638:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010563b:	72 23                	jb     c0105660 <get_pte+0x11d>
c010563d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105640:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105644:	c7 44 24 08 64 aa 10 	movl   $0xc010aa64,0x8(%esp)
c010564b:	c0 
c010564c:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
c0105653:	00 
c0105654:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c010565b:	e8 7d b6 ff ff       	call   c0100cdd <__panic>
c0105660:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105663:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105668:	8b 55 0c             	mov    0xc(%ebp),%edx
c010566b:	c1 ea 0c             	shr    $0xc,%edx
c010566e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105674:	c1 e2 02             	shl    $0x2,%edx
c0105677:	01 d0                	add    %edx,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0105679:	c9                   	leave  
c010567a:	c3                   	ret    

c010567b <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010567b:	55                   	push   %ebp
c010567c:	89 e5                	mov    %esp,%ebp
c010567e:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105681:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105688:	00 
c0105689:	8b 45 0c             	mov    0xc(%ebp),%eax
c010568c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105690:	8b 45 08             	mov    0x8(%ebp),%eax
c0105693:	89 04 24             	mov    %eax,(%esp)
c0105696:	e8 a8 fe ff ff       	call   c0105543 <get_pte>
c010569b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010569e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056a2:	74 08                	je     c01056ac <get_page+0x31>
        *ptep_store = ptep;
c01056a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01056a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056aa:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01056ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056b0:	74 1b                	je     c01056cd <get_page+0x52>
c01056b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056b5:	8b 00                	mov    (%eax),%eax
c01056b7:	83 e0 01             	and    $0x1,%eax
c01056ba:	85 c0                	test   %eax,%eax
c01056bc:	74 0f                	je     c01056cd <get_page+0x52>
        return pa2page(*ptep);
c01056be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056c1:	8b 00                	mov    (%eax),%eax
c01056c3:	89 04 24             	mov    %eax,(%esp)
c01056c6:	e8 35 f4 ff ff       	call   c0104b00 <pa2page>
c01056cb:	eb 05                	jmp    c01056d2 <get_page+0x57>
    }
    return NULL;
c01056cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056d2:	c9                   	leave  
c01056d3:	c3                   	ret    

c01056d4 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01056d4:	55                   	push   %ebp
c01056d5:	89 e5                	mov    %esp,%ebp
c01056d7:	83 ec 28             	sub    $0x28,%esp
                                  //(6) flush tlb
    }
#endif

//(1) check if this page table entry is present
    if (*ptep & PTE_P) { 
c01056da:	8b 45 10             	mov    0x10(%ebp),%eax
c01056dd:	8b 00                	mov    (%eax),%eax
c01056df:	83 e0 01             	and    $0x1,%eax
c01056e2:	85 c0                	test   %eax,%eax
c01056e4:	74 52                	je     c0105738 <page_remove_pte+0x64>
//(2) find corresponding page to pte
        struct Page *page = pte2page(*ptep); 
c01056e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01056e9:	8b 00                	mov    (%eax),%eax
c01056eb:	89 04 24             	mov    %eax,(%esp)
c01056ee:	e8 a6 f4 ff ff       	call   c0104b99 <pte2page>
c01056f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//(3) decrease page reference
        page_ref_dec(page);
c01056f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f9:	89 04 24             	mov    %eax,(%esp)
c01056fc:	e8 04 f5 ff ff       	call   c0104c05 <page_ref_dec>
//(4) and free this page when page reference reachs 0
        if (page -> ref == 0) {
c0105701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105704:	8b 00                	mov    (%eax),%eax
c0105706:	85 c0                	test   %eax,%eax
c0105708:	75 13                	jne    c010571d <page_remove_pte+0x49>
            free_page(page);
c010570a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105711:	00 
c0105712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105715:	89 04 24             	mov    %eax,(%esp)
c0105718:	e8 2a f7 ff ff       	call   c0104e47 <free_pages>
        }
//(5) clear second page table entry
        *ptep = 0;
c010571d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
//(6) flush tlb
        tlb_invalidate(pgdir, la);
c0105726:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010572d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105730:	89 04 24             	mov    %eax,(%esp)
c0105733:	e8 ff 00 00 00       	call   c0105837 <tlb_invalidate>
    }
}
c0105738:	c9                   	leave  
c0105739:	c3                   	ret    

c010573a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010573a:	55                   	push   %ebp
c010573b:	89 e5                	mov    %esp,%ebp
c010573d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105740:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105747:	00 
c0105748:	8b 45 0c             	mov    0xc(%ebp),%eax
c010574b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010574f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105752:	89 04 24             	mov    %eax,(%esp)
c0105755:	e8 e9 fd ff ff       	call   c0105543 <get_pte>
c010575a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010575d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105761:	74 19                	je     c010577c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105766:	89 44 24 08          	mov    %eax,0x8(%esp)
c010576a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010576d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105771:	8b 45 08             	mov    0x8(%ebp),%eax
c0105774:	89 04 24             	mov    %eax,(%esp)
c0105777:	e8 58 ff ff ff       	call   c01056d4 <page_remove_pte>
    }
}
c010577c:	c9                   	leave  
c010577d:	c3                   	ret    

c010577e <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010577e:	55                   	push   %ebp
c010577f:	89 e5                	mov    %esp,%ebp
c0105781:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105784:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010578b:	00 
c010578c:	8b 45 10             	mov    0x10(%ebp),%eax
c010578f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105793:	8b 45 08             	mov    0x8(%ebp),%eax
c0105796:	89 04 24             	mov    %eax,(%esp)
c0105799:	e8 a5 fd ff ff       	call   c0105543 <get_pte>
c010579e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01057a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057a5:	75 0a                	jne    c01057b1 <page_insert+0x33>
        return -E_NO_MEM;
c01057a7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01057ac:	e9 84 00 00 00       	jmp    c0105835 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01057b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b4:	89 04 24             	mov    %eax,(%esp)
c01057b7:	e8 32 f4 ff ff       	call   c0104bee <page_ref_inc>
    if (*ptep & PTE_P) {
c01057bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057bf:	8b 00                	mov    (%eax),%eax
c01057c1:	83 e0 01             	and    $0x1,%eax
c01057c4:	85 c0                	test   %eax,%eax
c01057c6:	74 3e                	je     c0105806 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01057c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057cb:	8b 00                	mov    (%eax),%eax
c01057cd:	89 04 24             	mov    %eax,(%esp)
c01057d0:	e8 c4 f3 ff ff       	call   c0104b99 <pte2page>
c01057d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01057d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057db:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01057de:	75 0d                	jne    c01057ed <page_insert+0x6f>
            page_ref_dec(page);
c01057e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e3:	89 04 24             	mov    %eax,(%esp)
c01057e6:	e8 1a f4 ff ff       	call   c0104c05 <page_ref_dec>
c01057eb:	eb 19                	jmp    c0105806 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01057ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fe:	89 04 24             	mov    %eax,(%esp)
c0105801:	e8 ce fe ff ff       	call   c01056d4 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105806:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105809:	89 04 24             	mov    %eax,(%esp)
c010580c:	e8 d9 f2 ff ff       	call   c0104aea <page2pa>
c0105811:	0b 45 14             	or     0x14(%ebp),%eax
c0105814:	83 c8 01             	or     $0x1,%eax
c0105817:	89 c2                	mov    %eax,%edx
c0105819:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010581c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010581e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105821:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105825:	8b 45 08             	mov    0x8(%ebp),%eax
c0105828:	89 04 24             	mov    %eax,(%esp)
c010582b:	e8 07 00 00 00       	call   c0105837 <tlb_invalidate>
    return 0;
c0105830:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105835:	c9                   	leave  
c0105836:	c3                   	ret    

c0105837 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105837:	55                   	push   %ebp
c0105838:	89 e5                	mov    %esp,%ebp
c010583a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010583d:	0f 20 d8             	mov    %cr3,%eax
c0105840:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105843:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105846:	89 c2                	mov    %eax,%edx
c0105848:	8b 45 08             	mov    0x8(%ebp),%eax
c010584b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010584e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105855:	77 23                	ja     c010587a <tlb_invalidate+0x43>
c0105857:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010585a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010585e:	c7 44 24 08 08 ab 10 	movl   $0xc010ab08,0x8(%esp)
c0105865:	c0 
c0105866:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010586d:	00 
c010586e:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105875:	e8 63 b4 ff ff       	call   c0100cdd <__panic>
c010587a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010587d:	05 00 00 00 40       	add    $0x40000000,%eax
c0105882:	39 c2                	cmp    %eax,%edx
c0105884:	75 0c                	jne    c0105892 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105886:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105889:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010588c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010588f:	0f 01 38             	invlpg (%eax)
    }
}
c0105892:	c9                   	leave  
c0105893:	c3                   	ret    

c0105894 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105894:	55                   	push   %ebp
c0105895:	89 e5                	mov    %esp,%ebp
c0105897:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010589a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058a1:	e8 36 f5 ff ff       	call   c0104ddc <alloc_pages>
c01058a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01058a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01058ad:	0f 84 a7 00 00 00    	je     c010595a <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01058b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058bd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058cb:	89 04 24             	mov    %eax,(%esp)
c01058ce:	e8 ab fe ff ff       	call   c010577e <page_insert>
c01058d3:	85 c0                	test   %eax,%eax
c01058d5:	74 1a                	je     c01058f1 <pgdir_alloc_page+0x5d>
            free_page(page);
c01058d7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058de:	00 
c01058df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058e2:	89 04 24             	mov    %eax,(%esp)
c01058e5:	e8 5d f5 ff ff       	call   c0104e47 <free_pages>
            return NULL;
c01058ea:	b8 00 00 00 00       	mov    $0x0,%eax
c01058ef:	eb 6c                	jmp    c010595d <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01058f1:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01058f6:	85 c0                	test   %eax,%eax
c01058f8:	74 60                	je     c010595a <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01058fa:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01058ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105906:	00 
c0105907:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010590a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010590e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105911:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105915:	89 04 24             	mov    %eax,(%esp)
c0105918:	e8 3e 0e 00 00       	call   c010675b <swap_map_swappable>
            page->pra_vaddr=la;
c010591d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105920:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105923:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105926:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105929:	89 04 24             	mov    %eax,(%esp)
c010592c:	e8 a6 f2 ff ff       	call   c0104bd7 <page_ref>
c0105931:	83 f8 01             	cmp    $0x1,%eax
c0105934:	74 24                	je     c010595a <pgdir_alloc_page+0xc6>
c0105936:	c7 44 24 0c 8c ab 10 	movl   $0xc010ab8c,0xc(%esp)
c010593d:	c0 
c010593e:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105945:	c0 
c0105946:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c010594d:	00 
c010594e:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105955:	e8 83 b3 ff ff       	call   c0100cdd <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010595a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010595d:	c9                   	leave  
c010595e:	c3                   	ret    

c010595f <check_alloc_page>:

static void
check_alloc_page(void) {
c010595f:	55                   	push   %ebp
c0105960:	89 e5                	mov    %esp,%ebp
c0105962:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105965:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c010596a:	8b 40 18             	mov    0x18(%eax),%eax
c010596d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010596f:	c7 04 24 a0 ab 10 c0 	movl   $0xc010aba0,(%esp)
c0105976:	e8 d8 a9 ff ff       	call   c0100353 <cprintf>
}
c010597b:	c9                   	leave  
c010597c:	c3                   	ret    

c010597d <check_pgdir>:

static void
check_pgdir(void) {
c010597d:	55                   	push   %ebp
c010597e:	89 e5                	mov    %esp,%ebp
c0105980:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105983:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105988:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010598d:	76 24                	jbe    c01059b3 <check_pgdir+0x36>
c010598f:	c7 44 24 0c bf ab 10 	movl   $0xc010abbf,0xc(%esp)
c0105996:	c0 
c0105997:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c010599e:	c0 
c010599f:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c01059a6:	00 
c01059a7:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01059ae:	e8 2a b3 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01059b3:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059b8:	85 c0                	test   %eax,%eax
c01059ba:	74 0e                	je     c01059ca <check_pgdir+0x4d>
c01059bc:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059c1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01059c6:	85 c0                	test   %eax,%eax
c01059c8:	74 24                	je     c01059ee <check_pgdir+0x71>
c01059ca:	c7 44 24 0c dc ab 10 	movl   $0xc010abdc,0xc(%esp)
c01059d1:	c0 
c01059d2:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01059d9:	c0 
c01059da:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01059e1:	00 
c01059e2:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01059e9:	e8 ef b2 ff ff       	call   c0100cdd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01059ee:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059fa:	00 
c01059fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a02:	00 
c0105a03:	89 04 24             	mov    %eax,(%esp)
c0105a06:	e8 70 fc ff ff       	call   c010567b <get_page>
c0105a0b:	85 c0                	test   %eax,%eax
c0105a0d:	74 24                	je     c0105a33 <check_pgdir+0xb6>
c0105a0f:	c7 44 24 0c 14 ac 10 	movl   $0xc010ac14,0xc(%esp)
c0105a16:	c0 
c0105a17:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105a1e:	c0 
c0105a1f:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105a26:	00 
c0105a27:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105a2e:	e8 aa b2 ff ff       	call   c0100cdd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a3a:	e8 9d f3 ff ff       	call   c0104ddc <alloc_pages>
c0105a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105a42:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105a4e:	00 
c0105a4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a56:	00 
c0105a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a5a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a5e:	89 04 24             	mov    %eax,(%esp)
c0105a61:	e8 18 fd ff ff       	call   c010577e <page_insert>
c0105a66:	85 c0                	test   %eax,%eax
c0105a68:	74 24                	je     c0105a8e <check_pgdir+0x111>
c0105a6a:	c7 44 24 0c 3c ac 10 	movl   $0xc010ac3c,0xc(%esp)
c0105a71:	c0 
c0105a72:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105a79:	c0 
c0105a7a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105a81:	00 
c0105a82:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105a89:	e8 4f b2 ff ff       	call   c0100cdd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105a8e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a9a:	00 
c0105a9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105aa2:	00 
c0105aa3:	89 04 24             	mov    %eax,(%esp)
c0105aa6:	e8 98 fa ff ff       	call   c0105543 <get_pte>
c0105aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ab2:	75 24                	jne    c0105ad8 <check_pgdir+0x15b>
c0105ab4:	c7 44 24 0c 68 ac 10 	movl   $0xc010ac68,0xc(%esp)
c0105abb:	c0 
c0105abc:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105ac3:	c0 
c0105ac4:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105acb:	00 
c0105acc:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105ad3:	e8 05 b2 ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105adb:	8b 00                	mov    (%eax),%eax
c0105add:	89 04 24             	mov    %eax,(%esp)
c0105ae0:	e8 1b f0 ff ff       	call   c0104b00 <pa2page>
c0105ae5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105ae8:	74 24                	je     c0105b0e <check_pgdir+0x191>
c0105aea:	c7 44 24 0c 95 ac 10 	movl   $0xc010ac95,0xc(%esp)
c0105af1:	c0 
c0105af2:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105af9:	c0 
c0105afa:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105b01:	00 
c0105b02:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105b09:	e8 cf b1 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 1);
c0105b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b11:	89 04 24             	mov    %eax,(%esp)
c0105b14:	e8 be f0 ff ff       	call   c0104bd7 <page_ref>
c0105b19:	83 f8 01             	cmp    $0x1,%eax
c0105b1c:	74 24                	je     c0105b42 <check_pgdir+0x1c5>
c0105b1e:	c7 44 24 0c aa ac 10 	movl   $0xc010acaa,0xc(%esp)
c0105b25:	c0 
c0105b26:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105b2d:	c0 
c0105b2e:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105b35:	00 
c0105b36:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105b3d:	e8 9b b1 ff ff       	call   c0100cdd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105b42:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b47:	8b 00                	mov    (%eax),%eax
c0105b49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b54:	c1 e8 0c             	shr    $0xc,%eax
c0105b57:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b5a:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105b5f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105b62:	72 23                	jb     c0105b87 <check_pgdir+0x20a>
c0105b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b6b:	c7 44 24 08 64 aa 10 	movl   $0xc010aa64,0x8(%esp)
c0105b72:	c0 
c0105b73:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105b7a:	00 
c0105b7b:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105b82:	e8 56 b1 ff ff       	call   c0100cdd <__panic>
c0105b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b8a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105b8f:	83 c0 04             	add    $0x4,%eax
c0105b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105b95:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ba1:	00 
c0105ba2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105ba9:	00 
c0105baa:	89 04 24             	mov    %eax,(%esp)
c0105bad:	e8 91 f9 ff ff       	call   c0105543 <get_pte>
c0105bb2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105bb5:	74 24                	je     c0105bdb <check_pgdir+0x25e>
c0105bb7:	c7 44 24 0c bc ac 10 	movl   $0xc010acbc,0xc(%esp)
c0105bbe:	c0 
c0105bbf:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105bc6:	c0 
c0105bc7:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105bce:	00 
c0105bcf:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105bd6:	e8 02 b1 ff ff       	call   c0100cdd <__panic>

    p2 = alloc_page();
c0105bdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105be2:	e8 f5 f1 ff ff       	call   c0104ddc <alloc_pages>
c0105be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105bea:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105bef:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105bf6:	00 
c0105bf7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105bfe:	00 
c0105bff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c02:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c06:	89 04 24             	mov    %eax,(%esp)
c0105c09:	e8 70 fb ff ff       	call   c010577e <page_insert>
c0105c0e:	85 c0                	test   %eax,%eax
c0105c10:	74 24                	je     c0105c36 <check_pgdir+0x2b9>
c0105c12:	c7 44 24 0c e4 ac 10 	movl   $0xc010ace4,0xc(%esp)
c0105c19:	c0 
c0105c1a:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105c21:	c0 
c0105c22:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105c29:	00 
c0105c2a:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105c31:	e8 a7 b0 ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105c36:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c42:	00 
c0105c43:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105c4a:	00 
c0105c4b:	89 04 24             	mov    %eax,(%esp)
c0105c4e:	e8 f0 f8 ff ff       	call   c0105543 <get_pte>
c0105c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105c5a:	75 24                	jne    c0105c80 <check_pgdir+0x303>
c0105c5c:	c7 44 24 0c 1c ad 10 	movl   $0xc010ad1c,0xc(%esp)
c0105c63:	c0 
c0105c64:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105c6b:	c0 
c0105c6c:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105c73:	00 
c0105c74:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105c7b:	e8 5d b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_U);
c0105c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c83:	8b 00                	mov    (%eax),%eax
c0105c85:	83 e0 04             	and    $0x4,%eax
c0105c88:	85 c0                	test   %eax,%eax
c0105c8a:	75 24                	jne    c0105cb0 <check_pgdir+0x333>
c0105c8c:	c7 44 24 0c 4c ad 10 	movl   $0xc010ad4c,0xc(%esp)
c0105c93:	c0 
c0105c94:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105c9b:	c0 
c0105c9c:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105ca3:	00 
c0105ca4:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105cab:	e8 2d b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_W);
c0105cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cb3:	8b 00                	mov    (%eax),%eax
c0105cb5:	83 e0 02             	and    $0x2,%eax
c0105cb8:	85 c0                	test   %eax,%eax
c0105cba:	75 24                	jne    c0105ce0 <check_pgdir+0x363>
c0105cbc:	c7 44 24 0c 5a ad 10 	movl   $0xc010ad5a,0xc(%esp)
c0105cc3:	c0 
c0105cc4:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105ccb:	c0 
c0105ccc:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105cd3:	00 
c0105cd4:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105cdb:	e8 fd af ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105ce0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ce5:	8b 00                	mov    (%eax),%eax
c0105ce7:	83 e0 04             	and    $0x4,%eax
c0105cea:	85 c0                	test   %eax,%eax
c0105cec:	75 24                	jne    c0105d12 <check_pgdir+0x395>
c0105cee:	c7 44 24 0c 68 ad 10 	movl   $0xc010ad68,0xc(%esp)
c0105cf5:	c0 
c0105cf6:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105cfd:	c0 
c0105cfe:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105d05:	00 
c0105d06:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105d0d:	e8 cb af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 1);
c0105d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d15:	89 04 24             	mov    %eax,(%esp)
c0105d18:	e8 ba ee ff ff       	call   c0104bd7 <page_ref>
c0105d1d:	83 f8 01             	cmp    $0x1,%eax
c0105d20:	74 24                	je     c0105d46 <check_pgdir+0x3c9>
c0105d22:	c7 44 24 0c 7e ad 10 	movl   $0xc010ad7e,0xc(%esp)
c0105d29:	c0 
c0105d2a:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105d31:	c0 
c0105d32:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105d39:	00 
c0105d3a:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105d41:	e8 97 af ff ff       	call   c0100cdd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105d46:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d4b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105d52:	00 
c0105d53:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105d5a:	00 
c0105d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d5e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d62:	89 04 24             	mov    %eax,(%esp)
c0105d65:	e8 14 fa ff ff       	call   c010577e <page_insert>
c0105d6a:	85 c0                	test   %eax,%eax
c0105d6c:	74 24                	je     c0105d92 <check_pgdir+0x415>
c0105d6e:	c7 44 24 0c 90 ad 10 	movl   $0xc010ad90,0xc(%esp)
c0105d75:	c0 
c0105d76:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105d7d:	c0 
c0105d7e:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0105d85:	00 
c0105d86:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105d8d:	e8 4b af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 2);
c0105d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d95:	89 04 24             	mov    %eax,(%esp)
c0105d98:	e8 3a ee ff ff       	call   c0104bd7 <page_ref>
c0105d9d:	83 f8 02             	cmp    $0x2,%eax
c0105da0:	74 24                	je     c0105dc6 <check_pgdir+0x449>
c0105da2:	c7 44 24 0c bc ad 10 	movl   $0xc010adbc,0xc(%esp)
c0105da9:	c0 
c0105daa:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105db1:	c0 
c0105db2:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105db9:	00 
c0105dba:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105dc1:	e8 17 af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dc9:	89 04 24             	mov    %eax,(%esp)
c0105dcc:	e8 06 ee ff ff       	call   c0104bd7 <page_ref>
c0105dd1:	85 c0                	test   %eax,%eax
c0105dd3:	74 24                	je     c0105df9 <check_pgdir+0x47c>
c0105dd5:	c7 44 24 0c ce ad 10 	movl   $0xc010adce,0xc(%esp)
c0105ddc:	c0 
c0105ddd:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105de4:	c0 
c0105de5:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0105dec:	00 
c0105ded:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105df4:	e8 e4 ae ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105df9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105dfe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e05:	00 
c0105e06:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105e0d:	00 
c0105e0e:	89 04 24             	mov    %eax,(%esp)
c0105e11:	e8 2d f7 ff ff       	call   c0105543 <get_pte>
c0105e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e1d:	75 24                	jne    c0105e43 <check_pgdir+0x4c6>
c0105e1f:	c7 44 24 0c 1c ad 10 	movl   $0xc010ad1c,0xc(%esp)
c0105e26:	c0 
c0105e27:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105e2e:	c0 
c0105e2f:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0105e36:	00 
c0105e37:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105e3e:	e8 9a ae ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e46:	8b 00                	mov    (%eax),%eax
c0105e48:	89 04 24             	mov    %eax,(%esp)
c0105e4b:	e8 b0 ec ff ff       	call   c0104b00 <pa2page>
c0105e50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e53:	74 24                	je     c0105e79 <check_pgdir+0x4fc>
c0105e55:	c7 44 24 0c 95 ac 10 	movl   $0xc010ac95,0xc(%esp)
c0105e5c:	c0 
c0105e5d:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105e64:	c0 
c0105e65:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105e6c:	00 
c0105e6d:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105e74:	e8 64 ae ff ff       	call   c0100cdd <__panic>
    assert((*ptep & PTE_U) == 0);
c0105e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e7c:	8b 00                	mov    (%eax),%eax
c0105e7e:	83 e0 04             	and    $0x4,%eax
c0105e81:	85 c0                	test   %eax,%eax
c0105e83:	74 24                	je     c0105ea9 <check_pgdir+0x52c>
c0105e85:	c7 44 24 0c e0 ad 10 	movl   $0xc010ade0,0xc(%esp)
c0105e8c:	c0 
c0105e8d:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105e94:	c0 
c0105e95:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105e9c:	00 
c0105e9d:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105ea4:	e8 34 ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, 0x0);
c0105ea9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105eae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105eb5:	00 
c0105eb6:	89 04 24             	mov    %eax,(%esp)
c0105eb9:	e8 7c f8 ff ff       	call   c010573a <page_remove>
    assert(page_ref(p1) == 1);
c0105ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ec1:	89 04 24             	mov    %eax,(%esp)
c0105ec4:	e8 0e ed ff ff       	call   c0104bd7 <page_ref>
c0105ec9:	83 f8 01             	cmp    $0x1,%eax
c0105ecc:	74 24                	je     c0105ef2 <check_pgdir+0x575>
c0105ece:	c7 44 24 0c aa ac 10 	movl   $0xc010acaa,0xc(%esp)
c0105ed5:	c0 
c0105ed6:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105edd:	c0 
c0105ede:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c0105ee5:	00 
c0105ee6:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105eed:	e8 eb ad ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ef5:	89 04 24             	mov    %eax,(%esp)
c0105ef8:	e8 da ec ff ff       	call   c0104bd7 <page_ref>
c0105efd:	85 c0                	test   %eax,%eax
c0105eff:	74 24                	je     c0105f25 <check_pgdir+0x5a8>
c0105f01:	c7 44 24 0c ce ad 10 	movl   $0xc010adce,0xc(%esp)
c0105f08:	c0 
c0105f09:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105f10:	c0 
c0105f11:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0105f18:	00 
c0105f19:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105f20:	e8 b8 ad ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105f25:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f2a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105f31:	00 
c0105f32:	89 04 24             	mov    %eax,(%esp)
c0105f35:	e8 00 f8 ff ff       	call   c010573a <page_remove>
    assert(page_ref(p1) == 0);
c0105f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f3d:	89 04 24             	mov    %eax,(%esp)
c0105f40:	e8 92 ec ff ff       	call   c0104bd7 <page_ref>
c0105f45:	85 c0                	test   %eax,%eax
c0105f47:	74 24                	je     c0105f6d <check_pgdir+0x5f0>
c0105f49:	c7 44 24 0c f5 ad 10 	movl   $0xc010adf5,0xc(%esp)
c0105f50:	c0 
c0105f51:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105f58:	c0 
c0105f59:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0105f60:	00 
c0105f61:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105f68:	e8 70 ad ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f70:	89 04 24             	mov    %eax,(%esp)
c0105f73:	e8 5f ec ff ff       	call   c0104bd7 <page_ref>
c0105f78:	85 c0                	test   %eax,%eax
c0105f7a:	74 24                	je     c0105fa0 <check_pgdir+0x623>
c0105f7c:	c7 44 24 0c ce ad 10 	movl   $0xc010adce,0xc(%esp)
c0105f83:	c0 
c0105f84:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105f8b:	c0 
c0105f8c:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105f93:	00 
c0105f94:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105f9b:	e8 3d ad ff ff       	call   c0100cdd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105fa0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105fa5:	8b 00                	mov    (%eax),%eax
c0105fa7:	89 04 24             	mov    %eax,(%esp)
c0105faa:	e8 51 eb ff ff       	call   c0104b00 <pa2page>
c0105faf:	89 04 24             	mov    %eax,(%esp)
c0105fb2:	e8 20 ec ff ff       	call   c0104bd7 <page_ref>
c0105fb7:	83 f8 01             	cmp    $0x1,%eax
c0105fba:	74 24                	je     c0105fe0 <check_pgdir+0x663>
c0105fbc:	c7 44 24 0c 08 ae 10 	movl   $0xc010ae08,0xc(%esp)
c0105fc3:	c0 
c0105fc4:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0105fcb:	c0 
c0105fcc:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c0105fd3:	00 
c0105fd4:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0105fdb:	e8 fd ac ff ff       	call   c0100cdd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105fe0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105fe5:	8b 00                	mov    (%eax),%eax
c0105fe7:	89 04 24             	mov    %eax,(%esp)
c0105fea:	e8 11 eb ff ff       	call   c0104b00 <pa2page>
c0105fef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105ff6:	00 
c0105ff7:	89 04 24             	mov    %eax,(%esp)
c0105ffa:	e8 48 ee ff ff       	call   c0104e47 <free_pages>
    boot_pgdir[0] = 0;
c0105fff:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010600a:	c7 04 24 2e ae 10 c0 	movl   $0xc010ae2e,(%esp)
c0106011:	e8 3d a3 ff ff       	call   c0100353 <cprintf>
}
c0106016:	c9                   	leave  
c0106017:	c3                   	ret    

c0106018 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0106018:	55                   	push   %ebp
c0106019:	89 e5                	mov    %esp,%ebp
c010601b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010601e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106025:	e9 ca 00 00 00       	jmp    c01060f4 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010602a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010602d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106030:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106033:	c1 e8 0c             	shr    $0xc,%eax
c0106036:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106039:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010603e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106041:	72 23                	jb     c0106066 <check_boot_pgdir+0x4e>
c0106043:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106046:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010604a:	c7 44 24 08 64 aa 10 	movl   $0xc010aa64,0x8(%esp)
c0106051:	c0 
c0106052:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0106059:	00 
c010605a:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106061:	e8 77 ac ff ff       	call   c0100cdd <__panic>
c0106066:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106069:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010606e:	89 c2                	mov    %eax,%edx
c0106070:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106075:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010607c:	00 
c010607d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106081:	89 04 24             	mov    %eax,(%esp)
c0106084:	e8 ba f4 ff ff       	call   c0105543 <get_pte>
c0106089:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010608c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106090:	75 24                	jne    c01060b6 <check_boot_pgdir+0x9e>
c0106092:	c7 44 24 0c 48 ae 10 	movl   $0xc010ae48,0xc(%esp)
c0106099:	c0 
c010609a:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01060a1:	c0 
c01060a2:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c01060a9:	00 
c01060aa:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01060b1:	e8 27 ac ff ff       	call   c0100cdd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01060b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060b9:	8b 00                	mov    (%eax),%eax
c01060bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01060c0:	89 c2                	mov    %eax,%edx
c01060c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060c5:	39 c2                	cmp    %eax,%edx
c01060c7:	74 24                	je     c01060ed <check_boot_pgdir+0xd5>
c01060c9:	c7 44 24 0c 85 ae 10 	movl   $0xc010ae85,0xc(%esp)
c01060d0:	c0 
c01060d1:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01060d8:	c0 
c01060d9:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c01060e0:	00 
c01060e1:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01060e8:	e8 f0 ab ff ff       	call   c0100cdd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01060ed:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01060f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01060f7:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01060fc:	39 c2                	cmp    %eax,%edx
c01060fe:	0f 82 26 ff ff ff    	jb     c010602a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106104:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106109:	05 ac 0f 00 00       	add    $0xfac,%eax
c010610e:	8b 00                	mov    (%eax),%eax
c0106110:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106115:	89 c2                	mov    %eax,%edx
c0106117:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010611c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010611f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0106126:	77 23                	ja     c010614b <check_boot_pgdir+0x133>
c0106128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010612b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010612f:	c7 44 24 08 08 ab 10 	movl   $0xc010ab08,0x8(%esp)
c0106136:	c0 
c0106137:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
c010613e:	00 
c010613f:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106146:	e8 92 ab ff ff       	call   c0100cdd <__panic>
c010614b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010614e:	05 00 00 00 40       	add    $0x40000000,%eax
c0106153:	39 c2                	cmp    %eax,%edx
c0106155:	74 24                	je     c010617b <check_boot_pgdir+0x163>
c0106157:	c7 44 24 0c 9c ae 10 	movl   $0xc010ae9c,0xc(%esp)
c010615e:	c0 
c010615f:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0106166:	c0 
c0106167:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
c010616e:	00 
c010616f:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106176:	e8 62 ab ff ff       	call   c0100cdd <__panic>

    assert(boot_pgdir[0] == 0);
c010617b:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106180:	8b 00                	mov    (%eax),%eax
c0106182:	85 c0                	test   %eax,%eax
c0106184:	74 24                	je     c01061aa <check_boot_pgdir+0x192>
c0106186:	c7 44 24 0c d0 ae 10 	movl   $0xc010aed0,0xc(%esp)
c010618d:	c0 
c010618e:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0106195:	c0 
c0106196:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c010619d:	00 
c010619e:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01061a5:	e8 33 ab ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    p = alloc_page();
c01061aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061b1:	e8 26 ec ff ff       	call   c0104ddc <alloc_pages>
c01061b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01061b9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01061be:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01061c5:	00 
c01061c6:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01061cd:	00 
c01061ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01061d1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061d5:	89 04 24             	mov    %eax,(%esp)
c01061d8:	e8 a1 f5 ff ff       	call   c010577e <page_insert>
c01061dd:	85 c0                	test   %eax,%eax
c01061df:	74 24                	je     c0106205 <check_boot_pgdir+0x1ed>
c01061e1:	c7 44 24 0c e4 ae 10 	movl   $0xc010aee4,0xc(%esp)
c01061e8:	c0 
c01061e9:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01061f0:	c0 
c01061f1:	c7 44 24 04 6b 02 00 	movl   $0x26b,0x4(%esp)
c01061f8:	00 
c01061f9:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106200:	e8 d8 aa ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 1);
c0106205:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106208:	89 04 24             	mov    %eax,(%esp)
c010620b:	e8 c7 e9 ff ff       	call   c0104bd7 <page_ref>
c0106210:	83 f8 01             	cmp    $0x1,%eax
c0106213:	74 24                	je     c0106239 <check_boot_pgdir+0x221>
c0106215:	c7 44 24 0c 12 af 10 	movl   $0xc010af12,0xc(%esp)
c010621c:	c0 
c010621d:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0106224:	c0 
c0106225:	c7 44 24 04 6c 02 00 	movl   $0x26c,0x4(%esp)
c010622c:	00 
c010622d:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106234:	e8 a4 aa ff ff       	call   c0100cdd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106239:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010623e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106245:	00 
c0106246:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010624d:	00 
c010624e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106251:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106255:	89 04 24             	mov    %eax,(%esp)
c0106258:	e8 21 f5 ff ff       	call   c010577e <page_insert>
c010625d:	85 c0                	test   %eax,%eax
c010625f:	74 24                	je     c0106285 <check_boot_pgdir+0x26d>
c0106261:	c7 44 24 0c 24 af 10 	movl   $0xc010af24,0xc(%esp)
c0106268:	c0 
c0106269:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0106270:	c0 
c0106271:	c7 44 24 04 6d 02 00 	movl   $0x26d,0x4(%esp)
c0106278:	00 
c0106279:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106280:	e8 58 aa ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 2);
c0106285:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106288:	89 04 24             	mov    %eax,(%esp)
c010628b:	e8 47 e9 ff ff       	call   c0104bd7 <page_ref>
c0106290:	83 f8 02             	cmp    $0x2,%eax
c0106293:	74 24                	je     c01062b9 <check_boot_pgdir+0x2a1>
c0106295:	c7 44 24 0c 5b af 10 	movl   $0xc010af5b,0xc(%esp)
c010629c:	c0 
c010629d:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01062a4:	c0 
c01062a5:	c7 44 24 04 6e 02 00 	movl   $0x26e,0x4(%esp)
c01062ac:	00 
c01062ad:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c01062b4:	e8 24 aa ff ff       	call   c0100cdd <__panic>

    const char *str = "ucore: Hello world!!";
c01062b9:	c7 45 dc 6c af 10 c0 	movl   $0xc010af6c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01062c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01062c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062c7:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01062ce:	e8 0a 36 00 00       	call   c01098dd <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01062d3:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01062da:	00 
c01062db:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01062e2:	e8 6f 36 00 00       	call   c0109956 <strcmp>
c01062e7:	85 c0                	test   %eax,%eax
c01062e9:	74 24                	je     c010630f <check_boot_pgdir+0x2f7>
c01062eb:	c7 44 24 0c 84 af 10 	movl   $0xc010af84,0xc(%esp)
c01062f2:	c0 
c01062f3:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c01062fa:	c0 
c01062fb:	c7 44 24 04 72 02 00 	movl   $0x272,0x4(%esp)
c0106302:	00 
c0106303:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c010630a:	e8 ce a9 ff ff       	call   c0100cdd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010630f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106312:	89 04 24             	mov    %eax,(%esp)
c0106315:	e8 2b e8 ff ff       	call   c0104b45 <page2kva>
c010631a:	05 00 01 00 00       	add    $0x100,%eax
c010631f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106322:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106329:	e8 57 35 00 00       	call   c0109885 <strlen>
c010632e:	85 c0                	test   %eax,%eax
c0106330:	74 24                	je     c0106356 <check_boot_pgdir+0x33e>
c0106332:	c7 44 24 0c bc af 10 	movl   $0xc010afbc,0xc(%esp)
c0106339:	c0 
c010633a:	c7 44 24 08 51 ab 10 	movl   $0xc010ab51,0x8(%esp)
c0106341:	c0 
c0106342:	c7 44 24 04 75 02 00 	movl   $0x275,0x4(%esp)
c0106349:	00 
c010634a:	c7 04 24 2c ab 10 c0 	movl   $0xc010ab2c,(%esp)
c0106351:	e8 87 a9 ff ff       	call   c0100cdd <__panic>

    free_page(p);
c0106356:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010635d:	00 
c010635e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106361:	89 04 24             	mov    %eax,(%esp)
c0106364:	e8 de ea ff ff       	call   c0104e47 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0106369:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010636e:	8b 00                	mov    (%eax),%eax
c0106370:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106375:	89 04 24             	mov    %eax,(%esp)
c0106378:	e8 83 e7 ff ff       	call   c0104b00 <pa2page>
c010637d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106384:	00 
c0106385:	89 04 24             	mov    %eax,(%esp)
c0106388:	e8 ba ea ff ff       	call   c0104e47 <free_pages>
    boot_pgdir[0] = 0;
c010638d:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106398:	c7 04 24 e0 af 10 c0 	movl   $0xc010afe0,(%esp)
c010639f:	e8 af 9f ff ff       	call   c0100353 <cprintf>
}
c01063a4:	c9                   	leave  
c01063a5:	c3                   	ret    

c01063a6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01063a6:	55                   	push   %ebp
c01063a7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01063a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ac:	83 e0 04             	and    $0x4,%eax
c01063af:	85 c0                	test   %eax,%eax
c01063b1:	74 07                	je     c01063ba <perm2str+0x14>
c01063b3:	b8 75 00 00 00       	mov    $0x75,%eax
c01063b8:	eb 05                	jmp    c01063bf <perm2str+0x19>
c01063ba:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01063bf:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c01063c4:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01063cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ce:	83 e0 02             	and    $0x2,%eax
c01063d1:	85 c0                	test   %eax,%eax
c01063d3:	74 07                	je     c01063dc <perm2str+0x36>
c01063d5:	b8 77 00 00 00       	mov    $0x77,%eax
c01063da:	eb 05                	jmp    c01063e1 <perm2str+0x3b>
c01063dc:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01063e1:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c01063e6:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c01063ed:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c01063f2:	5d                   	pop    %ebp
c01063f3:	c3                   	ret    

c01063f4 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01063f4:	55                   	push   %ebp
c01063f5:	89 e5                	mov    %esp,%ebp
c01063f7:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01063fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01063fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106400:	72 0a                	jb     c010640c <get_pgtable_items+0x18>
        return 0;
c0106402:	b8 00 00 00 00       	mov    $0x0,%eax
c0106407:	e9 9c 00 00 00       	jmp    c01064a8 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010640c:	eb 04                	jmp    c0106412 <get_pgtable_items+0x1e>
        start ++;
c010640e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106412:	8b 45 10             	mov    0x10(%ebp),%eax
c0106415:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106418:	73 18                	jae    c0106432 <get_pgtable_items+0x3e>
c010641a:	8b 45 10             	mov    0x10(%ebp),%eax
c010641d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106424:	8b 45 14             	mov    0x14(%ebp),%eax
c0106427:	01 d0                	add    %edx,%eax
c0106429:	8b 00                	mov    (%eax),%eax
c010642b:	83 e0 01             	and    $0x1,%eax
c010642e:	85 c0                	test   %eax,%eax
c0106430:	74 dc                	je     c010640e <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106432:	8b 45 10             	mov    0x10(%ebp),%eax
c0106435:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106438:	73 69                	jae    c01064a3 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010643a:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010643e:	74 08                	je     c0106448 <get_pgtable_items+0x54>
            *left_store = start;
c0106440:	8b 45 18             	mov    0x18(%ebp),%eax
c0106443:	8b 55 10             	mov    0x10(%ebp),%edx
c0106446:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106448:	8b 45 10             	mov    0x10(%ebp),%eax
c010644b:	8d 50 01             	lea    0x1(%eax),%edx
c010644e:	89 55 10             	mov    %edx,0x10(%ebp)
c0106451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106458:	8b 45 14             	mov    0x14(%ebp),%eax
c010645b:	01 d0                	add    %edx,%eax
c010645d:	8b 00                	mov    (%eax),%eax
c010645f:	83 e0 07             	and    $0x7,%eax
c0106462:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106465:	eb 04                	jmp    c010646b <get_pgtable_items+0x77>
            start ++;
c0106467:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010646b:	8b 45 10             	mov    0x10(%ebp),%eax
c010646e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106471:	73 1d                	jae    c0106490 <get_pgtable_items+0x9c>
c0106473:	8b 45 10             	mov    0x10(%ebp),%eax
c0106476:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010647d:	8b 45 14             	mov    0x14(%ebp),%eax
c0106480:	01 d0                	add    %edx,%eax
c0106482:	8b 00                	mov    (%eax),%eax
c0106484:	83 e0 07             	and    $0x7,%eax
c0106487:	89 c2                	mov    %eax,%edx
c0106489:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010648c:	39 c2                	cmp    %eax,%edx
c010648e:	74 d7                	je     c0106467 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106490:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106494:	74 08                	je     c010649e <get_pgtable_items+0xaa>
            *right_store = start;
c0106496:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106499:	8b 55 10             	mov    0x10(%ebp),%edx
c010649c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010649e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01064a1:	eb 05                	jmp    c01064a8 <get_pgtable_items+0xb4>
    }
    return 0;
c01064a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01064a8:	c9                   	leave  
c01064a9:	c3                   	ret    

c01064aa <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01064aa:	55                   	push   %ebp
c01064ab:	89 e5                	mov    %esp,%ebp
c01064ad:	57                   	push   %edi
c01064ae:	56                   	push   %esi
c01064af:	53                   	push   %ebx
c01064b0:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01064b3:	c7 04 24 00 b0 10 c0 	movl   $0xc010b000,(%esp)
c01064ba:	e8 94 9e ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c01064bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01064c6:	e9 fa 00 00 00       	jmp    c01065c5 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01064cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ce:	89 04 24             	mov    %eax,(%esp)
c01064d1:	e8 d0 fe ff ff       	call   c01063a6 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01064d6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01064d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01064dc:	29 d1                	sub    %edx,%ecx
c01064de:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01064e0:	89 d6                	mov    %edx,%esi
c01064e2:	c1 e6 16             	shl    $0x16,%esi
c01064e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01064e8:	89 d3                	mov    %edx,%ebx
c01064ea:	c1 e3 16             	shl    $0x16,%ebx
c01064ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01064f0:	89 d1                	mov    %edx,%ecx
c01064f2:	c1 e1 16             	shl    $0x16,%ecx
c01064f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01064f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01064fb:	29 d7                	sub    %edx,%edi
c01064fd:	89 fa                	mov    %edi,%edx
c01064ff:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106503:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106507:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010650b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010650f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106513:	c7 04 24 31 b0 10 c0 	movl   $0xc010b031,(%esp)
c010651a:	e8 34 9e ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010651f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106522:	c1 e0 0a             	shl    $0xa,%eax
c0106525:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106528:	eb 54                	jmp    c010657e <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010652a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010652d:	89 04 24             	mov    %eax,(%esp)
c0106530:	e8 71 fe ff ff       	call   c01063a6 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106535:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106538:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010653b:	29 d1                	sub    %edx,%ecx
c010653d:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010653f:	89 d6                	mov    %edx,%esi
c0106541:	c1 e6 0c             	shl    $0xc,%esi
c0106544:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106547:	89 d3                	mov    %edx,%ebx
c0106549:	c1 e3 0c             	shl    $0xc,%ebx
c010654c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010654f:	c1 e2 0c             	shl    $0xc,%edx
c0106552:	89 d1                	mov    %edx,%ecx
c0106554:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106557:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010655a:	29 d7                	sub    %edx,%edi
c010655c:	89 fa                	mov    %edi,%edx
c010655e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106562:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106566:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010656a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010656e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106572:	c7 04 24 50 b0 10 c0 	movl   $0xc010b050,(%esp)
c0106579:	e8 d5 9d ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010657e:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106583:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106586:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106589:	89 ce                	mov    %ecx,%esi
c010658b:	c1 e6 0a             	shl    $0xa,%esi
c010658e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106591:	89 cb                	mov    %ecx,%ebx
c0106593:	c1 e3 0a             	shl    $0xa,%ebx
c0106596:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106599:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010659d:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01065a0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01065a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01065a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01065ac:	89 74 24 04          	mov    %esi,0x4(%esp)
c01065b0:	89 1c 24             	mov    %ebx,(%esp)
c01065b3:	e8 3c fe ff ff       	call   c01063f4 <get_pgtable_items>
c01065b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01065bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01065bf:	0f 85 65 ff ff ff    	jne    c010652a <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01065c5:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01065ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01065cd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01065d0:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01065d4:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01065d7:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01065db:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01065df:	89 44 24 08          	mov    %eax,0x8(%esp)
c01065e3:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01065ea:	00 
c01065eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01065f2:	e8 fd fd ff ff       	call   c01063f4 <get_pgtable_items>
c01065f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01065fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01065fe:	0f 85 c7 fe ff ff    	jne    c01064cb <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106604:	c7 04 24 74 b0 10 c0 	movl   $0xc010b074,(%esp)
c010660b:	e8 43 9d ff ff       	call   c0100353 <cprintf>
}
c0106610:	83 c4 4c             	add    $0x4c,%esp
c0106613:	5b                   	pop    %ebx
c0106614:	5e                   	pop    %esi
c0106615:	5f                   	pop    %edi
c0106616:	5d                   	pop    %ebp
c0106617:	c3                   	ret    

c0106618 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106618:	55                   	push   %ebp
c0106619:	89 e5                	mov    %esp,%ebp
c010661b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010661e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106621:	c1 e8 0c             	shr    $0xc,%eax
c0106624:	89 c2                	mov    %eax,%edx
c0106626:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010662b:	39 c2                	cmp    %eax,%edx
c010662d:	72 1c                	jb     c010664b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010662f:	c7 44 24 08 a8 b0 10 	movl   $0xc010b0a8,0x8(%esp)
c0106636:	c0 
c0106637:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010663e:	00 
c010663f:	c7 04 24 c7 b0 10 c0 	movl   $0xc010b0c7,(%esp)
c0106646:	e8 92 a6 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c010664b:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0106650:	8b 55 08             	mov    0x8(%ebp),%edx
c0106653:	c1 ea 0c             	shr    $0xc,%edx
c0106656:	c1 e2 05             	shl    $0x5,%edx
c0106659:	01 d0                	add    %edx,%eax
}
c010665b:	c9                   	leave  
c010665c:	c3                   	ret    

c010665d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010665d:	55                   	push   %ebp
c010665e:	89 e5                	mov    %esp,%ebp
c0106660:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106663:	8b 45 08             	mov    0x8(%ebp),%eax
c0106666:	83 e0 01             	and    $0x1,%eax
c0106669:	85 c0                	test   %eax,%eax
c010666b:	75 1c                	jne    c0106689 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010666d:	c7 44 24 08 d8 b0 10 	movl   $0xc010b0d8,0x8(%esp)
c0106674:	c0 
c0106675:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c010667c:	00 
c010667d:	c7 04 24 c7 b0 10 c0 	movl   $0xc010b0c7,(%esp)
c0106684:	e8 54 a6 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106689:	8b 45 08             	mov    0x8(%ebp),%eax
c010668c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106691:	89 04 24             	mov    %eax,(%esp)
c0106694:	e8 7f ff ff ff       	call   c0106618 <pa2page>
}
c0106699:	c9                   	leave  
c010669a:	c3                   	ret    

c010669b <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010669b:	55                   	push   %ebp
c010669c:	89 e5                	mov    %esp,%ebp
c010669e:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01066a1:	e8 33 1d 00 00       	call   c01083d9 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01066a6:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01066ab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01066b0:	76 0c                	jbe    c01066be <swap_init+0x23>
c01066b2:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01066b7:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01066bc:	76 25                	jbe    c01066e3 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01066be:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01066c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01066c7:	c7 44 24 08 f9 b0 10 	movl   $0xc010b0f9,0x8(%esp)
c01066ce:	c0 
c01066cf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01066d6:	00 
c01066d7:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c01066de:	e8 fa a5 ff ff       	call   c0100cdd <__panic>
     }
     

     sm = &swap_manager_fifo;
c01066e3:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c01066ea:	4a 12 c0 
     int r = sm->init();
c01066ed:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066f2:	8b 40 04             	mov    0x4(%eax),%eax
c01066f5:	ff d0                	call   *%eax
c01066f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01066fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01066fe:	75 26                	jne    c0106726 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106700:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c0106707:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c010670a:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010670f:	8b 00                	mov    (%eax),%eax
c0106711:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106715:	c7 04 24 23 b1 10 c0 	movl   $0xc010b123,(%esp)
c010671c:	e8 32 9c ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106721:	e8 a4 04 00 00       	call   c0106bca <check_swap>
     }

     return r;
c0106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106729:	c9                   	leave  
c010672a:	c3                   	ret    

c010672b <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c010672b:	55                   	push   %ebp
c010672c:	89 e5                	mov    %esp,%ebp
c010672e:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106731:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106736:	8b 40 08             	mov    0x8(%eax),%eax
c0106739:	8b 55 08             	mov    0x8(%ebp),%edx
c010673c:	89 14 24             	mov    %edx,(%esp)
c010673f:	ff d0                	call   *%eax
}
c0106741:	c9                   	leave  
c0106742:	c3                   	ret    

c0106743 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106743:	55                   	push   %ebp
c0106744:	89 e5                	mov    %esp,%ebp
c0106746:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106749:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010674e:	8b 40 0c             	mov    0xc(%eax),%eax
c0106751:	8b 55 08             	mov    0x8(%ebp),%edx
c0106754:	89 14 24             	mov    %edx,(%esp)
c0106757:	ff d0                	call   *%eax
}
c0106759:	c9                   	leave  
c010675a:	c3                   	ret    

c010675b <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010675b:	55                   	push   %ebp
c010675c:	89 e5                	mov    %esp,%ebp
c010675e:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106761:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106766:	8b 40 10             	mov    0x10(%eax),%eax
c0106769:	8b 55 14             	mov    0x14(%ebp),%edx
c010676c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106770:	8b 55 10             	mov    0x10(%ebp),%edx
c0106773:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106777:	8b 55 0c             	mov    0xc(%ebp),%edx
c010677a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010677e:	8b 55 08             	mov    0x8(%ebp),%edx
c0106781:	89 14 24             	mov    %edx,(%esp)
c0106784:	ff d0                	call   *%eax
}
c0106786:	c9                   	leave  
c0106787:	c3                   	ret    

c0106788 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106788:	55                   	push   %ebp
c0106789:	89 e5                	mov    %esp,%ebp
c010678b:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010678e:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106793:	8b 40 14             	mov    0x14(%eax),%eax
c0106796:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106799:	89 54 24 04          	mov    %edx,0x4(%esp)
c010679d:	8b 55 08             	mov    0x8(%ebp),%edx
c01067a0:	89 14 24             	mov    %edx,(%esp)
c01067a3:	ff d0                	call   *%eax
}
c01067a5:	c9                   	leave  
c01067a6:	c3                   	ret    

c01067a7 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01067a7:	55                   	push   %ebp
c01067a8:	89 e5                	mov    %esp,%ebp
c01067aa:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01067ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01067b4:	e9 5a 01 00 00       	jmp    c0106913 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01067b9:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067be:	8b 40 18             	mov    0x18(%eax),%eax
c01067c1:	8b 55 10             	mov    0x10(%ebp),%edx
c01067c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01067c8:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01067cb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01067cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01067d2:	89 14 24             	mov    %edx,(%esp)
c01067d5:	ff d0                	call   *%eax
c01067d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01067da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01067de:	74 18                	je     c01067f8 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01067e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067e7:	c7 04 24 38 b1 10 c0 	movl   $0xc010b138,(%esp)
c01067ee:	e8 60 9b ff ff       	call   c0100353 <cprintf>
c01067f3:	e9 27 01 00 00       	jmp    c010691f <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01067f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067fb:	8b 40 1c             	mov    0x1c(%eax),%eax
c01067fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106801:	8b 45 08             	mov    0x8(%ebp),%eax
c0106804:	8b 40 0c             	mov    0xc(%eax),%eax
c0106807:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010680e:	00 
c010680f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106812:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106816:	89 04 24             	mov    %eax,(%esp)
c0106819:	e8 25 ed ff ff       	call   c0105543 <get_pte>
c010681e:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106821:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106824:	8b 00                	mov    (%eax),%eax
c0106826:	83 e0 01             	and    $0x1,%eax
c0106829:	85 c0                	test   %eax,%eax
c010682b:	75 24                	jne    c0106851 <swap_out+0xaa>
c010682d:	c7 44 24 0c 65 b1 10 	movl   $0xc010b165,0xc(%esp)
c0106834:	c0 
c0106835:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c010683c:	c0 
c010683d:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106844:	00 
c0106845:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c010684c:	e8 8c a4 ff ff       	call   c0100cdd <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106854:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106857:	8b 52 1c             	mov    0x1c(%edx),%edx
c010685a:	c1 ea 0c             	shr    $0xc,%edx
c010685d:	83 c2 01             	add    $0x1,%edx
c0106860:	c1 e2 08             	shl    $0x8,%edx
c0106863:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106867:	89 14 24             	mov    %edx,(%esp)
c010686a:	e8 24 1c 00 00       	call   c0108493 <swapfs_write>
c010686f:	85 c0                	test   %eax,%eax
c0106871:	74 34                	je     c01068a7 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106873:	c7 04 24 8f b1 10 c0 	movl   $0xc010b18f,(%esp)
c010687a:	e8 d4 9a ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010687f:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106884:	8b 40 10             	mov    0x10(%eax),%eax
c0106887:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010688a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106891:	00 
c0106892:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106896:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106899:	89 54 24 04          	mov    %edx,0x4(%esp)
c010689d:	8b 55 08             	mov    0x8(%ebp),%edx
c01068a0:	89 14 24             	mov    %edx,(%esp)
c01068a3:	ff d0                	call   *%eax
c01068a5:	eb 68                	jmp    c010690f <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01068a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068aa:	8b 40 1c             	mov    0x1c(%eax),%eax
c01068ad:	c1 e8 0c             	shr    $0xc,%eax
c01068b0:	83 c0 01             	add    $0x1,%eax
c01068b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01068b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01068be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068c5:	c7 04 24 a8 b1 10 c0 	movl   $0xc010b1a8,(%esp)
c01068cc:	e8 82 9a ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01068d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068d4:	8b 40 1c             	mov    0x1c(%eax),%eax
c01068d7:	c1 e8 0c             	shr    $0xc,%eax
c01068da:	83 c0 01             	add    $0x1,%eax
c01068dd:	c1 e0 08             	shl    $0x8,%eax
c01068e0:	89 c2                	mov    %eax,%edx
c01068e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01068e5:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01068e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01068f1:	00 
c01068f2:	89 04 24             	mov    %eax,(%esp)
c01068f5:	e8 4d e5 ff ff       	call   c0104e47 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01068fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01068fd:	8b 40 0c             	mov    0xc(%eax),%eax
c0106900:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106903:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106907:	89 04 24             	mov    %eax,(%esp)
c010690a:	e8 28 ef ff ff       	call   c0105837 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010690f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106916:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106919:	0f 85 9a fe ff ff    	jne    c01067b9 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010691f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106922:	c9                   	leave  
c0106923:	c3                   	ret    

c0106924 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106924:	55                   	push   %ebp
c0106925:	89 e5                	mov    %esp,%ebp
c0106927:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c010692a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106931:	e8 a6 e4 ff ff       	call   c0104ddc <alloc_pages>
c0106936:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010693d:	75 24                	jne    c0106963 <swap_in+0x3f>
c010693f:	c7 44 24 0c e8 b1 10 	movl   $0xc010b1e8,0xc(%esp)
c0106946:	c0 
c0106947:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c010694e:	c0 
c010694f:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106956:	00 
c0106957:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c010695e:	e8 7a a3 ff ff       	call   c0100cdd <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106963:	8b 45 08             	mov    0x8(%ebp),%eax
c0106966:	8b 40 0c             	mov    0xc(%eax),%eax
c0106969:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106970:	00 
c0106971:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106974:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106978:	89 04 24             	mov    %eax,(%esp)
c010697b:	e8 c3 eb ff ff       	call   c0105543 <get_pte>
c0106980:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106983:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106986:	8b 00                	mov    (%eax),%eax
c0106988:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010698b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010698f:	89 04 24             	mov    %eax,(%esp)
c0106992:	e8 8a 1a 00 00       	call   c0108421 <swapfs_read>
c0106997:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010699a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010699e:	74 2a                	je     c01069ca <swap_in+0xa6>
     {
        assert(r!=0);
c01069a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01069a4:	75 24                	jne    c01069ca <swap_in+0xa6>
c01069a6:	c7 44 24 0c f5 b1 10 	movl   $0xc010b1f5,0xc(%esp)
c01069ad:	c0 
c01069ae:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c01069b5:	c0 
c01069b6:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01069bd:	00 
c01069be:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c01069c5:	e8 13 a3 ff ff       	call   c0100cdd <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01069ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01069cd:	8b 00                	mov    (%eax),%eax
c01069cf:	c1 e8 08             	shr    $0x8,%eax
c01069d2:	89 c2                	mov    %eax,%edx
c01069d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01069d7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01069db:	89 54 24 04          	mov    %edx,0x4(%esp)
c01069df:	c7 04 24 fc b1 10 c0 	movl   $0xc010b1fc,(%esp)
c01069e6:	e8 68 99 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c01069eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01069ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01069f1:	89 10                	mov    %edx,(%eax)
     return 0;
c01069f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01069f8:	c9                   	leave  
c01069f9:	c3                   	ret    

c01069fa <check_content_set>:



static inline void
check_content_set(void)
{
c01069fa:	55                   	push   %ebp
c01069fb:	89 e5                	mov    %esp,%ebp
c01069fd:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106a00:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106a05:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106a08:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a0d:	83 f8 01             	cmp    $0x1,%eax
c0106a10:	74 24                	je     c0106a36 <check_content_set+0x3c>
c0106a12:	c7 44 24 0c 3a b2 10 	movl   $0xc010b23a,0xc(%esp)
c0106a19:	c0 
c0106a1a:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106a21:	c0 
c0106a22:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106a29:	00 
c0106a2a:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106a31:	e8 a7 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106a36:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106a3b:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106a3e:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a43:	83 f8 01             	cmp    $0x1,%eax
c0106a46:	74 24                	je     c0106a6c <check_content_set+0x72>
c0106a48:	c7 44 24 0c 3a b2 10 	movl   $0xc010b23a,0xc(%esp)
c0106a4f:	c0 
c0106a50:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106a57:	c0 
c0106a58:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106a5f:	00 
c0106a60:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106a67:	e8 71 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106a6c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106a71:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106a74:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a79:	83 f8 02             	cmp    $0x2,%eax
c0106a7c:	74 24                	je     c0106aa2 <check_content_set+0xa8>
c0106a7e:	c7 44 24 0c 49 b2 10 	movl   $0xc010b249,0xc(%esp)
c0106a85:	c0 
c0106a86:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106a8d:	c0 
c0106a8e:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106a95:	00 
c0106a96:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106a9d:	e8 3b a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106aa2:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106aa7:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106aaa:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106aaf:	83 f8 02             	cmp    $0x2,%eax
c0106ab2:	74 24                	je     c0106ad8 <check_content_set+0xde>
c0106ab4:	c7 44 24 0c 49 b2 10 	movl   $0xc010b249,0xc(%esp)
c0106abb:	c0 
c0106abc:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106ac3:	c0 
c0106ac4:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106acb:	00 
c0106acc:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106ad3:	e8 05 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106ad8:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106add:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106ae0:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106ae5:	83 f8 03             	cmp    $0x3,%eax
c0106ae8:	74 24                	je     c0106b0e <check_content_set+0x114>
c0106aea:	c7 44 24 0c 58 b2 10 	movl   $0xc010b258,0xc(%esp)
c0106af1:	c0 
c0106af2:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106af9:	c0 
c0106afa:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106b01:	00 
c0106b02:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106b09:	e8 cf a1 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106b0e:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106b13:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106b16:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b1b:	83 f8 03             	cmp    $0x3,%eax
c0106b1e:	74 24                	je     c0106b44 <check_content_set+0x14a>
c0106b20:	c7 44 24 0c 58 b2 10 	movl   $0xc010b258,0xc(%esp)
c0106b27:	c0 
c0106b28:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106b2f:	c0 
c0106b30:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106b37:	00 
c0106b38:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106b3f:	e8 99 a1 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106b44:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106b49:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106b4c:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b51:	83 f8 04             	cmp    $0x4,%eax
c0106b54:	74 24                	je     c0106b7a <check_content_set+0x180>
c0106b56:	c7 44 24 0c 67 b2 10 	movl   $0xc010b267,0xc(%esp)
c0106b5d:	c0 
c0106b5e:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106b65:	c0 
c0106b66:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106b6d:	00 
c0106b6e:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106b75:	e8 63 a1 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106b7a:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106b7f:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106b82:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b87:	83 f8 04             	cmp    $0x4,%eax
c0106b8a:	74 24                	je     c0106bb0 <check_content_set+0x1b6>
c0106b8c:	c7 44 24 0c 67 b2 10 	movl   $0xc010b267,0xc(%esp)
c0106b93:	c0 
c0106b94:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106b9b:	c0 
c0106b9c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106ba3:	00 
c0106ba4:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106bab:	e8 2d a1 ff ff       	call   c0100cdd <__panic>
}
c0106bb0:	c9                   	leave  
c0106bb1:	c3                   	ret    

c0106bb2 <check_content_access>:

static inline int
check_content_access(void)
{
c0106bb2:	55                   	push   %ebp
c0106bb3:	89 e5                	mov    %esp,%ebp
c0106bb5:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106bb8:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106bbd:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106bc0:	ff d0                	call   *%eax
c0106bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106bc8:	c9                   	leave  
c0106bc9:	c3                   	ret    

c0106bca <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106bca:	55                   	push   %ebp
c0106bcb:	89 e5                	mov    %esp,%ebp
c0106bcd:	53                   	push   %ebx
c0106bce:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106bd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106bdf:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106be6:	eb 6b                	jmp    c0106c53 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106beb:	83 e8 0c             	sub    $0xc,%eax
c0106bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bf4:	83 c0 04             	add    $0x4,%eax
c0106bf7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106bfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106c01:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106c04:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106c07:	0f a3 10             	bt     %edx,(%eax)
c0106c0a:	19 c0                	sbb    %eax,%eax
c0106c0c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106c0f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106c13:	0f 95 c0             	setne  %al
c0106c16:	0f b6 c0             	movzbl %al,%eax
c0106c19:	85 c0                	test   %eax,%eax
c0106c1b:	75 24                	jne    c0106c41 <check_swap+0x77>
c0106c1d:	c7 44 24 0c 76 b2 10 	movl   $0xc010b276,0xc(%esp)
c0106c24:	c0 
c0106c25:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106c2c:	c0 
c0106c2d:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106c34:	00 
c0106c35:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106c3c:	e8 9c a0 ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0106c41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c48:	8b 50 08             	mov    0x8(%eax),%edx
c0106c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c4e:	01 d0                	add    %edx,%eax
c0106c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c56:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106c59:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106c5c:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106c5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c62:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106c69:	0f 85 79 ff ff ff    	jne    c0106be8 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106c6f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106c72:	e8 02 e2 ff ff       	call   c0104e79 <nr_free_pages>
c0106c77:	39 c3                	cmp    %eax,%ebx
c0106c79:	74 24                	je     c0106c9f <check_swap+0xd5>
c0106c7b:	c7 44 24 0c 86 b2 10 	movl   $0xc010b286,0xc(%esp)
c0106c82:	c0 
c0106c83:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106c8a:	c0 
c0106c8b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106c92:	00 
c0106c93:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106c9a:	e8 3e a0 ff ff       	call   c0100cdd <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ca2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cad:	c7 04 24 a0 b2 10 c0 	movl   $0xc010b2a0,(%esp)
c0106cb4:	e8 9a 96 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106cb9:	e8 09 0a 00 00       	call   c01076c7 <mm_create>
c0106cbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106cc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106cc5:	75 24                	jne    c0106ceb <check_swap+0x121>
c0106cc7:	c7 44 24 0c c6 b2 10 	movl   $0xc010b2c6,0xc(%esp)
c0106cce:	c0 
c0106ccf:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106cd6:	c0 
c0106cd7:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106cde:	00 
c0106cdf:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106ce6:	e8 f2 9f ff ff       	call   c0100cdd <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106ceb:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106cf0:	85 c0                	test   %eax,%eax
c0106cf2:	74 24                	je     c0106d18 <check_swap+0x14e>
c0106cf4:	c7 44 24 0c d1 b2 10 	movl   $0xc010b2d1,0xc(%esp)
c0106cfb:	c0 
c0106cfc:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106d03:	c0 
c0106d04:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106d0b:	00 
c0106d0c:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106d13:	e8 c5 9f ff ff       	call   c0100cdd <__panic>

     check_mm_struct = mm;
c0106d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d1b:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106d20:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d29:	89 50 0c             	mov    %edx,0xc(%eax)
c0106d2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d2f:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d32:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106d38:	8b 00                	mov    (%eax),%eax
c0106d3a:	85 c0                	test   %eax,%eax
c0106d3c:	74 24                	je     c0106d62 <check_swap+0x198>
c0106d3e:	c7 44 24 0c e9 b2 10 	movl   $0xc010b2e9,0xc(%esp)
c0106d45:	c0 
c0106d46:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106d4d:	c0 
c0106d4e:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106d55:	00 
c0106d56:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106d5d:	e8 7b 9f ff ff       	call   c0100cdd <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106d62:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106d69:	00 
c0106d6a:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106d71:	00 
c0106d72:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106d79:	e8 c1 09 00 00       	call   c010773f <vma_create>
c0106d7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106d81:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106d85:	75 24                	jne    c0106dab <check_swap+0x1e1>
c0106d87:	c7 44 24 0c f7 b2 10 	movl   $0xc010b2f7,0xc(%esp)
c0106d8e:	c0 
c0106d8f:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106d96:	c0 
c0106d97:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106d9e:	00 
c0106d9f:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106da6:	e8 32 9f ff ff       	call   c0100cdd <__panic>

     insert_vma_struct(mm, vma);
c0106dab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106dae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106db5:	89 04 24             	mov    %eax,(%esp)
c0106db8:	e8 12 0b 00 00       	call   c01078cf <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106dbd:	c7 04 24 04 b3 10 c0 	movl   $0xc010b304,(%esp)
c0106dc4:	e8 8a 95 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106dc9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106dd3:	8b 40 0c             	mov    0xc(%eax),%eax
c0106dd6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106ddd:	00 
c0106dde:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106de5:	00 
c0106de6:	89 04 24             	mov    %eax,(%esp)
c0106de9:	e8 55 e7 ff ff       	call   c0105543 <get_pte>
c0106dee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106df1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106df5:	75 24                	jne    c0106e1b <check_swap+0x251>
c0106df7:	c7 44 24 0c 38 b3 10 	movl   $0xc010b338,0xc(%esp)
c0106dfe:	c0 
c0106dff:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106e06:	c0 
c0106e07:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106e0e:	00 
c0106e0f:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106e16:	e8 c2 9e ff ff       	call   c0100cdd <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106e1b:	c7 04 24 4c b3 10 c0 	movl   $0xc010b34c,(%esp)
c0106e22:	e8 2c 95 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106e27:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106e2e:	e9 a3 00 00 00       	jmp    c0106ed6 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106e33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106e3a:	e8 9d df ff ff       	call   c0104ddc <alloc_pages>
c0106e3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106e42:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e4c:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106e53:	85 c0                	test   %eax,%eax
c0106e55:	75 24                	jne    c0106e7b <check_swap+0x2b1>
c0106e57:	c7 44 24 0c 70 b3 10 	movl   $0xc010b370,0xc(%esp)
c0106e5e:	c0 
c0106e5f:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106e66:	c0 
c0106e67:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106e6e:	00 
c0106e6f:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106e76:	e8 62 9e ff ff       	call   c0100cdd <__panic>
          assert(!PageProperty(check_rp[i]));
c0106e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e7e:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106e85:	83 c0 04             	add    $0x4,%eax
c0106e88:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106e8f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106e92:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106e95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106e98:	0f a3 10             	bt     %edx,(%eax)
c0106e9b:	19 c0                	sbb    %eax,%eax
c0106e9d:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106ea0:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106ea4:	0f 95 c0             	setne  %al
c0106ea7:	0f b6 c0             	movzbl %al,%eax
c0106eaa:	85 c0                	test   %eax,%eax
c0106eac:	74 24                	je     c0106ed2 <check_swap+0x308>
c0106eae:	c7 44 24 0c 84 b3 10 	movl   $0xc010b384,0xc(%esp)
c0106eb5:	c0 
c0106eb6:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106ebd:	c0 
c0106ebe:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106ec5:	00 
c0106ec6:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106ecd:	e8 0b 9e ff ff       	call   c0100cdd <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ed2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106ed6:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106eda:	0f 8e 53 ff ff ff    	jle    c0106e33 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106ee0:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0106ee5:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0106eeb:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106eee:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106ef1:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106ef8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106efb:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106efe:	89 50 04             	mov    %edx,0x4(%eax)
c0106f01:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f04:	8b 50 04             	mov    0x4(%eax),%edx
c0106f07:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f0a:	89 10                	mov    %edx,(%eax)
c0106f0c:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106f13:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106f16:	8b 40 04             	mov    0x4(%eax),%eax
c0106f19:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106f1c:	0f 94 c0             	sete   %al
c0106f1f:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106f22:	85 c0                	test   %eax,%eax
c0106f24:	75 24                	jne    c0106f4a <check_swap+0x380>
c0106f26:	c7 44 24 0c 9f b3 10 	movl   $0xc010b39f,0xc(%esp)
c0106f2d:	c0 
c0106f2e:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106f35:	c0 
c0106f36:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106f3d:	00 
c0106f3e:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106f45:	e8 93 9d ff ff       	call   c0100cdd <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106f4a:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f4f:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106f52:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0106f59:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f63:	eb 1e                	jmp    c0106f83 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f68:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106f6f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106f76:	00 
c0106f77:	89 04 24             	mov    %eax,(%esp)
c0106f7a:	e8 c8 de ff ff       	call   c0104e47 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106f83:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106f87:	7e dc                	jle    c0106f65 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106f89:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f8e:	83 f8 04             	cmp    $0x4,%eax
c0106f91:	74 24                	je     c0106fb7 <check_swap+0x3ed>
c0106f93:	c7 44 24 0c b8 b3 10 	movl   $0xc010b3b8,0xc(%esp)
c0106f9a:	c0 
c0106f9b:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106fa2:	c0 
c0106fa3:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106faa:	00 
c0106fab:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106fb2:	e8 26 9d ff ff       	call   c0100cdd <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106fb7:	c7 04 24 dc b3 10 c0 	movl   $0xc010b3dc,(%esp)
c0106fbe:	e8 90 93 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106fc3:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0106fca:	00 00 00 
     
     check_content_set();
c0106fcd:	e8 28 fa ff ff       	call   c01069fa <check_content_set>
     assert( nr_free == 0);         
c0106fd2:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106fd7:	85 c0                	test   %eax,%eax
c0106fd9:	74 24                	je     c0106fff <check_swap+0x435>
c0106fdb:	c7 44 24 0c 03 b4 10 	movl   $0xc010b403,0xc(%esp)
c0106fe2:	c0 
c0106fe3:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0106fea:	c0 
c0106feb:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106ff2:	00 
c0106ff3:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0106ffa:	e8 de 9c ff ff       	call   c0100cdd <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106fff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107006:	eb 26                	jmp    c010702e <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0107008:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010700b:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c0107012:	ff ff ff ff 
c0107016:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107019:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c0107020:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107023:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010702a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010702e:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0107032:	7e d4                	jle    c0107008 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107034:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010703b:	e9 eb 00 00 00       	jmp    c010712b <check_swap+0x561>
         check_ptep[i]=0;
c0107040:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107043:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c010704a:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c010704e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107051:	83 c0 01             	add    $0x1,%eax
c0107054:	c1 e0 0c             	shl    $0xc,%eax
c0107057:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010705e:	00 
c010705f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107063:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107066:	89 04 24             	mov    %eax,(%esp)
c0107069:	e8 d5 e4 ff ff       	call   c0105543 <get_pte>
c010706e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107071:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0107078:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010707b:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107082:	85 c0                	test   %eax,%eax
c0107084:	75 24                	jne    c01070aa <check_swap+0x4e0>
c0107086:	c7 44 24 0c 10 b4 10 	movl   $0xc010b410,0xc(%esp)
c010708d:	c0 
c010708e:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0107095:	c0 
c0107096:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010709d:	00 
c010709e:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c01070a5:	e8 33 9c ff ff       	call   c0100cdd <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01070aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070ad:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c01070b4:	8b 00                	mov    (%eax),%eax
c01070b6:	89 04 24             	mov    %eax,(%esp)
c01070b9:	e8 9f f5 ff ff       	call   c010665d <pte2page>
c01070be:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01070c1:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c01070c8:	39 d0                	cmp    %edx,%eax
c01070ca:	74 24                	je     c01070f0 <check_swap+0x526>
c01070cc:	c7 44 24 0c 28 b4 10 	movl   $0xc010b428,0xc(%esp)
c01070d3:	c0 
c01070d4:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c01070db:	c0 
c01070dc:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01070e3:	00 
c01070e4:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c01070eb:	e8 ed 9b ff ff       	call   c0100cdd <__panic>
         assert((*check_ptep[i] & PTE_P));          
c01070f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070f3:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c01070fa:	8b 00                	mov    (%eax),%eax
c01070fc:	83 e0 01             	and    $0x1,%eax
c01070ff:	85 c0                	test   %eax,%eax
c0107101:	75 24                	jne    c0107127 <check_swap+0x55d>
c0107103:	c7 44 24 0c 50 b4 10 	movl   $0xc010b450,0xc(%esp)
c010710a:	c0 
c010710b:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c0107112:	c0 
c0107113:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010711a:	00 
c010711b:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c0107122:	e8 b6 9b ff ff       	call   c0100cdd <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107127:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010712b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010712f:	0f 8e 0b ff ff ff    	jle    c0107040 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0107135:	c7 04 24 6c b4 10 c0 	movl   $0xc010b46c,(%esp)
c010713c:	e8 12 92 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0107141:	e8 6c fa ff ff       	call   c0106bb2 <check_content_access>
c0107146:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0107149:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010714d:	74 24                	je     c0107173 <check_swap+0x5a9>
c010714f:	c7 44 24 0c 92 b4 10 	movl   $0xc010b492,0xc(%esp)
c0107156:	c0 
c0107157:	c7 44 24 08 7a b1 10 	movl   $0xc010b17a,0x8(%esp)
c010715e:	c0 
c010715f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0107166:	00 
c0107167:	c7 04 24 14 b1 10 c0 	movl   $0xc010b114,(%esp)
c010716e:	e8 6a 9b ff ff       	call   c0100cdd <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107173:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010717a:	eb 1e                	jmp    c010719a <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c010717c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010717f:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0107186:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010718d:	00 
c010718e:	89 04 24             	mov    %eax,(%esp)
c0107191:	e8 b1 dc ff ff       	call   c0104e47 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107196:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010719a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010719e:	7e dc                	jle    c010717c <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01071a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01071a3:	89 04 24             	mov    %eax,(%esp)
c01071a6:	e8 54 08 00 00       	call   c01079ff <mm_destroy>
         
     nr_free = nr_free_store;
c01071ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01071ae:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c01071b3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01071b6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01071b9:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c01071be:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c01071c4:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01071cb:	eb 1d                	jmp    c01071ea <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c01071cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01071d0:	83 e8 0c             	sub    $0xc,%eax
c01071d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c01071d6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01071da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01071dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01071e0:	8b 40 08             	mov    0x8(%eax),%eax
c01071e3:	29 c2                	sub    %eax,%edx
c01071e5:	89 d0                	mov    %edx,%eax
c01071e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01071ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01071ed:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01071f0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01071f3:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01071f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01071f9:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0107200:	75 cb                	jne    c01071cd <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107202:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107205:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107209:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010720c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107210:	c7 04 24 99 b4 10 c0 	movl   $0xc010b499,(%esp)
c0107217:	e8 37 91 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010721c:	c7 04 24 b3 b4 10 c0 	movl   $0xc010b4b3,(%esp)
c0107223:	e8 2b 91 ff ff       	call   c0100353 <cprintf>
}
c0107228:	83 c4 74             	add    $0x74,%esp
c010722b:	5b                   	pop    %ebx
c010722c:	5d                   	pop    %ebp
c010722d:	c3                   	ret    

c010722e <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010722e:	55                   	push   %ebp
c010722f:	89 e5                	mov    %esp,%ebp
c0107231:	83 ec 10             	sub    $0x10,%esp
c0107234:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010723b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010723e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107241:	89 50 04             	mov    %edx,0x4(%eax)
c0107244:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107247:	8b 50 04             	mov    0x4(%eax),%edx
c010724a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010724d:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010724f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107252:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107259:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010725e:	c9                   	leave  
c010725f:	c3                   	ret    

c0107260 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107260:	55                   	push   %ebp
c0107261:	89 e5                	mov    %esp,%ebp
c0107263:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107266:	8b 45 08             	mov    0x8(%ebp),%eax
c0107269:	8b 40 14             	mov    0x14(%eax),%eax
c010726c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c010726f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107272:	83 c0 14             	add    $0x14,%eax
c0107275:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010727c:	74 06                	je     c0107284 <_fifo_map_swappable+0x24>
c010727e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107282:	75 24                	jne    c01072a8 <_fifo_map_swappable+0x48>
c0107284:	c7 44 24 0c cc b4 10 	movl   $0xc010b4cc,0xc(%esp)
c010728b:	c0 
c010728c:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107293:	c0 
c0107294:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010729b:	00 
c010729c:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c01072a3:	e8 35 9a ff ff       	call   c0100cdd <__panic>
c01072a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01072ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01072b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01072ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01072c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072c3:	8b 40 04             	mov    0x4(%eax),%eax
c01072c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01072c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01072cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01072cf:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01072d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01072d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01072d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01072db:	89 10                	mov    %edx,(%eax)
c01072dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01072e0:	8b 10                	mov    (%eax),%edx
c01072e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01072e5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01072e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01072eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01072ee:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01072f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01072f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01072f7:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);  /////
    return 0;
c01072f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01072fe:	c9                   	leave  
c01072ff:	c3                   	ret    

c0107300 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107300:	55                   	push   %ebp
c0107301:	89 e5                	mov    %esp,%ebp
c0107303:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107306:	8b 45 08             	mov    0x8(%ebp),%eax
c0107309:	8b 40 14             	mov    0x14(%eax),%eax
c010730c:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c010730f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107313:	75 24                	jne    c0107339 <_fifo_swap_out_victim+0x39>
c0107315:	c7 44 24 0c 13 b5 10 	movl   $0xc010b513,0xc(%esp)
c010731c:	c0 
c010731d:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107324:	c0 
c0107325:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c010732c:	00 
c010732d:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c0107334:	e8 a4 99 ff ff       	call   c0100cdd <__panic>
     assert(in_tick==0);
c0107339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010733d:	74 24                	je     c0107363 <_fifo_swap_out_victim+0x63>
c010733f:	c7 44 24 0c 20 b5 10 	movl   $0xc010b520,0xc(%esp)
c0107346:	c0 
c0107347:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c010734e:	c0 
c010734f:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
c0107356:	00 
c0107357:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c010735e:	e8 7a 99 ff ff       	call   c0100cdd <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page

     list_entry_t *le = head->prev;
c0107363:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107366:	8b 00                	mov    (%eax),%eax
c0107368:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(le, pra_page_link);
c010736b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010736e:	83 e8 14             	sub    $0x14,%eax
c0107371:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107374:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107377:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010737a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010737d:	8b 40 04             	mov    0x4(%eax),%eax
c0107380:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107383:	8b 12                	mov    (%edx),%edx
c0107385:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107388:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010738b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010738e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107391:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107394:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107397:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010739a:	89 10                	mov    %edx,(%eax)
     list_del(le);
     *ptr_page = page;
c010739c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010739f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01073a2:	89 10                	mov    %edx,(%eax)

     return 0;
c01073a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01073a9:	c9                   	leave  
c01073aa:	c3                   	ret    

c01073ab <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c01073ab:	55                   	push   %ebp
c01073ac:	89 e5                	mov    %esp,%ebp
c01073ae:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01073b1:	c7 04 24 2c b5 10 c0 	movl   $0xc010b52c,(%esp)
c01073b8:	e8 96 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01073bd:	b8 00 30 00 00       	mov    $0x3000,%eax
c01073c2:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01073c5:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01073ca:	83 f8 04             	cmp    $0x4,%eax
c01073cd:	74 24                	je     c01073f3 <_fifo_check_swap+0x48>
c01073cf:	c7 44 24 0c 52 b5 10 	movl   $0xc010b552,0xc(%esp)
c01073d6:	c0 
c01073d7:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01073de:	c0 
c01073df:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01073e6:	00 
c01073e7:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c01073ee:	e8 ea 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01073f3:	c7 04 24 64 b5 10 c0 	movl   $0xc010b564,(%esp)
c01073fa:	e8 54 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01073ff:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107404:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107407:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010740c:	83 f8 04             	cmp    $0x4,%eax
c010740f:	74 24                	je     c0107435 <_fifo_check_swap+0x8a>
c0107411:	c7 44 24 0c 52 b5 10 	movl   $0xc010b552,0xc(%esp)
c0107418:	c0 
c0107419:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107420:	c0 
c0107421:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0107428:	00 
c0107429:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c0107430:	e8 a8 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107435:	c7 04 24 8c b5 10 c0 	movl   $0xc010b58c,(%esp)
c010743c:	e8 12 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107441:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107446:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107449:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010744e:	83 f8 04             	cmp    $0x4,%eax
c0107451:	74 24                	je     c0107477 <_fifo_check_swap+0xcc>
c0107453:	c7 44 24 0c 52 b5 10 	movl   $0xc010b552,0xc(%esp)
c010745a:	c0 
c010745b:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107462:	c0 
c0107463:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010746a:	00 
c010746b:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c0107472:	e8 66 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107477:	c7 04 24 b4 b5 10 c0 	movl   $0xc010b5b4,(%esp)
c010747e:	e8 d0 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107483:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107488:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010748b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107490:	83 f8 04             	cmp    $0x4,%eax
c0107493:	74 24                	je     c01074b9 <_fifo_check_swap+0x10e>
c0107495:	c7 44 24 0c 52 b5 10 	movl   $0xc010b552,0xc(%esp)
c010749c:	c0 
c010749d:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01074a4:	c0 
c01074a5:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01074ac:	00 
c01074ad:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c01074b4:	e8 24 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01074b9:	c7 04 24 dc b5 10 c0 	movl   $0xc010b5dc,(%esp)
c01074c0:	e8 8e 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01074c5:	b8 00 50 00 00       	mov    $0x5000,%eax
c01074ca:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01074cd:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074d2:	83 f8 05             	cmp    $0x5,%eax
c01074d5:	74 24                	je     c01074fb <_fifo_check_swap+0x150>
c01074d7:	c7 44 24 0c 02 b6 10 	movl   $0xc010b602,0xc(%esp)
c01074de:	c0 
c01074df:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01074e6:	c0 
c01074e7:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01074ee:	00 
c01074ef:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c01074f6:	e8 e2 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01074fb:	c7 04 24 b4 b5 10 c0 	movl   $0xc010b5b4,(%esp)
c0107502:	e8 4c 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107507:	b8 00 20 00 00       	mov    $0x2000,%eax
c010750c:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010750f:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107514:	83 f8 05             	cmp    $0x5,%eax
c0107517:	74 24                	je     c010753d <_fifo_check_swap+0x192>
c0107519:	c7 44 24 0c 02 b6 10 	movl   $0xc010b602,0xc(%esp)
c0107520:	c0 
c0107521:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107528:	c0 
c0107529:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0107530:	00 
c0107531:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c0107538:	e8 a0 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010753d:	c7 04 24 64 b5 10 c0 	movl   $0xc010b564,(%esp)
c0107544:	e8 0a 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107549:	b8 00 10 00 00       	mov    $0x1000,%eax
c010754e:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107551:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107556:	83 f8 06             	cmp    $0x6,%eax
c0107559:	74 24                	je     c010757f <_fifo_check_swap+0x1d4>
c010755b:	c7 44 24 0c 11 b6 10 	movl   $0xc010b611,0xc(%esp)
c0107562:	c0 
c0107563:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c010756a:	c0 
c010756b:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107572:	00 
c0107573:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c010757a:	e8 5e 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010757f:	c7 04 24 b4 b5 10 c0 	movl   $0xc010b5b4,(%esp)
c0107586:	e8 c8 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010758b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107590:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107593:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107598:	83 f8 07             	cmp    $0x7,%eax
c010759b:	74 24                	je     c01075c1 <_fifo_check_swap+0x216>
c010759d:	c7 44 24 0c 20 b6 10 	movl   $0xc010b620,0xc(%esp)
c01075a4:	c0 
c01075a5:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01075ac:	c0 
c01075ad:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01075b4:	00 
c01075b5:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c01075bc:	e8 1c 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01075c1:	c7 04 24 2c b5 10 c0 	movl   $0xc010b52c,(%esp)
c01075c8:	e8 86 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01075cd:	b8 00 30 00 00       	mov    $0x3000,%eax
c01075d2:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01075d5:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01075da:	83 f8 08             	cmp    $0x8,%eax
c01075dd:	74 24                	je     c0107603 <_fifo_check_swap+0x258>
c01075df:	c7 44 24 0c 2f b6 10 	movl   $0xc010b62f,0xc(%esp)
c01075e6:	c0 
c01075e7:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01075ee:	c0 
c01075ef:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01075f6:	00 
c01075f7:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c01075fe:	e8 da 96 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107603:	c7 04 24 8c b5 10 c0 	movl   $0xc010b58c,(%esp)
c010760a:	e8 44 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010760f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107614:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107617:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010761c:	83 f8 09             	cmp    $0x9,%eax
c010761f:	74 24                	je     c0107645 <_fifo_check_swap+0x29a>
c0107621:	c7 44 24 0c 3e b6 10 	movl   $0xc010b63e,0xc(%esp)
c0107628:	c0 
c0107629:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107630:	c0 
c0107631:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107638:	00 
c0107639:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c0107640:	e8 98 96 ff ff       	call   c0100cdd <__panic>
    return 0;
c0107645:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010764a:	c9                   	leave  
c010764b:	c3                   	ret    

c010764c <_fifo_init>:


static int
_fifo_init(void)
{
c010764c:	55                   	push   %ebp
c010764d:	89 e5                	mov    %esp,%ebp
    return 0;
c010764f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107654:	5d                   	pop    %ebp
c0107655:	c3                   	ret    

c0107656 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107656:	55                   	push   %ebp
c0107657:	89 e5                	mov    %esp,%ebp
    return 0;
c0107659:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010765e:	5d                   	pop    %ebp
c010765f:	c3                   	ret    

c0107660 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107660:	55                   	push   %ebp
c0107661:	89 e5                	mov    %esp,%ebp
c0107663:	b8 00 00 00 00       	mov    $0x0,%eax
c0107668:	5d                   	pop    %ebp
c0107669:	c3                   	ret    

c010766a <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010766a:	55                   	push   %ebp
c010766b:	89 e5                	mov    %esp,%ebp
c010766d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107670:	8b 45 08             	mov    0x8(%ebp),%eax
c0107673:	c1 e8 0c             	shr    $0xc,%eax
c0107676:	89 c2                	mov    %eax,%edx
c0107678:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010767d:	39 c2                	cmp    %eax,%edx
c010767f:	72 1c                	jb     c010769d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107681:	c7 44 24 08 60 b6 10 	movl   $0xc010b660,0x8(%esp)
c0107688:	c0 
c0107689:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107690:	00 
c0107691:	c7 04 24 7f b6 10 c0 	movl   $0xc010b67f,(%esp)
c0107698:	e8 40 96 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c010769d:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01076a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01076a5:	c1 ea 0c             	shr    $0xc,%edx
c01076a8:	c1 e2 05             	shl    $0x5,%edx
c01076ab:	01 d0                	add    %edx,%eax
}
c01076ad:	c9                   	leave  
c01076ae:	c3                   	ret    

c01076af <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01076af:	55                   	push   %ebp
c01076b0:	89 e5                	mov    %esp,%ebp
c01076b2:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01076b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01076b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01076bd:	89 04 24             	mov    %eax,(%esp)
c01076c0:	e8 a5 ff ff ff       	call   c010766a <pa2page>
}
c01076c5:	c9                   	leave  
c01076c6:	c3                   	ret    

c01076c7 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01076c7:	55                   	push   %ebp
c01076c8:	89 e5                	mov    %esp,%ebp
c01076ca:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01076cd:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01076d4:	e8 a6 d2 ff ff       	call   c010497f <kmalloc>
c01076d9:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01076dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076e0:	74 58                	je     c010773a <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01076e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01076e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01076ee:	89 50 04             	mov    %edx,0x4(%eax)
c01076f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076f4:	8b 50 04             	mov    0x4(%eax),%edx
c01076f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076fa:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01076fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107709:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107710:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107713:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010771a:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c010771f:	85 c0                	test   %eax,%eax
c0107721:	74 0d                	je     c0107730 <mm_create+0x69>
c0107723:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107726:	89 04 24             	mov    %eax,(%esp)
c0107729:	e8 fd ef ff ff       	call   c010672b <swap_init_mm>
c010772e:	eb 0a                	jmp    c010773a <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107733:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010773a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010773d:	c9                   	leave  
c010773e:	c3                   	ret    

c010773f <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010773f:	55                   	push   %ebp
c0107740:	89 e5                	mov    %esp,%ebp
c0107742:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107745:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010774c:	e8 2e d2 ff ff       	call   c010497f <kmalloc>
c0107751:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107758:	74 1b                	je     c0107775 <vma_create+0x36>
        vma->vm_start = vm_start;
c010775a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010775d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107760:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107766:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107769:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c010776c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010776f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107772:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107775:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107778:	c9                   	leave  
c0107779:	c3                   	ret    

c010777a <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c010777a:	55                   	push   %ebp
c010777b:	89 e5                	mov    %esp,%ebp
c010777d:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107780:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010778b:	0f 84 95 00 00 00    	je     c0107826 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107791:	8b 45 08             	mov    0x8(%ebp),%eax
c0107794:	8b 40 08             	mov    0x8(%eax),%eax
c0107797:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c010779a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010779e:	74 16                	je     c01077b6 <find_vma+0x3c>
c01077a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01077a3:	8b 40 04             	mov    0x4(%eax),%eax
c01077a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01077a9:	77 0b                	ja     c01077b6 <find_vma+0x3c>
c01077ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01077ae:	8b 40 08             	mov    0x8(%eax),%eax
c01077b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01077b4:	77 61                	ja     c0107817 <find_vma+0x9d>
                bool found = 0;
c01077b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01077bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01077c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01077c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01077c9:	eb 28                	jmp    c01077f3 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01077cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077ce:	83 e8 10             	sub    $0x10,%eax
c01077d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01077d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01077d7:	8b 40 04             	mov    0x4(%eax),%eax
c01077da:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01077dd:	77 14                	ja     c01077f3 <find_vma+0x79>
c01077df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01077e2:	8b 40 08             	mov    0x8(%eax),%eax
c01077e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01077e8:	76 09                	jbe    c01077f3 <find_vma+0x79>
                        found = 1;
c01077ea:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01077f1:	eb 17                	jmp    c010780a <find_vma+0x90>
c01077f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01077f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077fc:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c01077ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107805:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107808:	75 c1                	jne    c01077cb <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010780a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010780e:	75 07                	jne    c0107817 <find_vma+0x9d>
                    vma = NULL;
c0107810:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107817:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010781b:	74 09                	je     c0107826 <find_vma+0xac>
            mm->mmap_cache = vma;
c010781d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107820:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107823:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107826:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107829:	c9                   	leave  
c010782a:	c3                   	ret    

c010782b <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c010782b:	55                   	push   %ebp
c010782c:	89 e5                	mov    %esp,%ebp
c010782e:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107831:	8b 45 08             	mov    0x8(%ebp),%eax
c0107834:	8b 50 04             	mov    0x4(%eax),%edx
c0107837:	8b 45 08             	mov    0x8(%ebp),%eax
c010783a:	8b 40 08             	mov    0x8(%eax),%eax
c010783d:	39 c2                	cmp    %eax,%edx
c010783f:	72 24                	jb     c0107865 <check_vma_overlap+0x3a>
c0107841:	c7 44 24 0c 8d b6 10 	movl   $0xc010b68d,0xc(%esp)
c0107848:	c0 
c0107849:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107850:	c0 
c0107851:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107858:	00 
c0107859:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107860:	e8 78 94 ff ff       	call   c0100cdd <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107865:	8b 45 08             	mov    0x8(%ebp),%eax
c0107868:	8b 50 08             	mov    0x8(%eax),%edx
c010786b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010786e:	8b 40 04             	mov    0x4(%eax),%eax
c0107871:	39 c2                	cmp    %eax,%edx
c0107873:	76 24                	jbe    c0107899 <check_vma_overlap+0x6e>
c0107875:	c7 44 24 0c d0 b6 10 	movl   $0xc010b6d0,0xc(%esp)
c010787c:	c0 
c010787d:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107884:	c0 
c0107885:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c010788c:	00 
c010788d:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107894:	e8 44 94 ff ff       	call   c0100cdd <__panic>
    assert(next->vm_start < next->vm_end);
c0107899:	8b 45 0c             	mov    0xc(%ebp),%eax
c010789c:	8b 50 04             	mov    0x4(%eax),%edx
c010789f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078a2:	8b 40 08             	mov    0x8(%eax),%eax
c01078a5:	39 c2                	cmp    %eax,%edx
c01078a7:	72 24                	jb     c01078cd <check_vma_overlap+0xa2>
c01078a9:	c7 44 24 0c ef b6 10 	movl   $0xc010b6ef,0xc(%esp)
c01078b0:	c0 
c01078b1:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c01078b8:	c0 
c01078b9:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01078c0:	00 
c01078c1:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c01078c8:	e8 10 94 ff ff       	call   c0100cdd <__panic>
}
c01078cd:	c9                   	leave  
c01078ce:	c3                   	ret    

c01078cf <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01078cf:	55                   	push   %ebp
c01078d0:	89 e5                	mov    %esp,%ebp
c01078d2:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01078d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078d8:	8b 50 04             	mov    0x4(%eax),%edx
c01078db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078de:	8b 40 08             	mov    0x8(%eax),%eax
c01078e1:	39 c2                	cmp    %eax,%edx
c01078e3:	72 24                	jb     c0107909 <insert_vma_struct+0x3a>
c01078e5:	c7 44 24 0c 0d b7 10 	movl   $0xc010b70d,0xc(%esp)
c01078ec:	c0 
c01078ed:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c01078f4:	c0 
c01078f5:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01078fc:	00 
c01078fd:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107904:	e8 d4 93 ff ff       	call   c0100cdd <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107909:	8b 45 08             	mov    0x8(%ebp),%eax
c010790c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010790f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107912:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107915:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107918:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010791b:	eb 21                	jmp    c010793e <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010791d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107920:	83 e8 10             	sub    $0x10,%eax
c0107923:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107926:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107929:	8b 50 04             	mov    0x4(%eax),%edx
c010792c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010792f:	8b 40 04             	mov    0x4(%eax),%eax
c0107932:	39 c2                	cmp    %eax,%edx
c0107934:	76 02                	jbe    c0107938 <insert_vma_struct+0x69>
                break;
c0107936:	eb 1d                	jmp    c0107955 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107938:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010793b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010793e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107941:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107944:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107947:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010794a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010794d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107950:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107953:	75 c8                	jne    c010791d <insert_vma_struct+0x4e>
c0107955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107958:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010795b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010795e:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107961:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107964:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107967:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010796a:	74 15                	je     c0107981 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c010796c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010796f:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107972:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107975:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107979:	89 14 24             	mov    %edx,(%esp)
c010797c:	e8 aa fe ff ff       	call   c010782b <check_vma_overlap>
    }
    if (le_next != list) {
c0107981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107984:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107987:	74 15                	je     c010799e <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010798c:	83 e8 10             	sub    $0x10,%eax
c010798f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107993:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107996:	89 04 24             	mov    %eax,(%esp)
c0107999:	e8 8d fe ff ff       	call   c010782b <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010799e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01079a4:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01079a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079a9:	8d 50 10             	lea    0x10(%eax),%edx
c01079ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079af:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01079b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01079b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01079b8:	8b 40 04             	mov    0x4(%eax),%eax
c01079bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01079be:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01079c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01079c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01079c7:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01079ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01079cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01079d0:	89 10                	mov    %edx,(%eax)
c01079d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01079d5:	8b 10                	mov    (%eax),%edx
c01079d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01079da:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01079dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01079e0:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01079e3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01079e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01079e9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01079ec:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01079ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01079f1:	8b 40 10             	mov    0x10(%eax),%eax
c01079f4:	8d 50 01             	lea    0x1(%eax),%edx
c01079f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01079fa:	89 50 10             	mov    %edx,0x10(%eax)
}
c01079fd:	c9                   	leave  
c01079fe:	c3                   	ret    

c01079ff <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01079ff:	55                   	push   %ebp
c0107a00:	89 e5                	mov    %esp,%ebp
c0107a02:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107a0b:	eb 36                	jmp    c0107a43 <mm_destroy+0x44>
c0107a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a16:	8b 40 04             	mov    0x4(%eax),%eax
c0107a19:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107a1c:	8b 12                	mov    (%edx),%edx
c0107a1e:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107a21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a2a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107a33:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a38:	83 e8 10             	sub    $0x10,%eax
c0107a3b:	89 04 24             	mov    %eax,(%esp)
c0107a3e:	e8 57 cf ff ff       	call   c010499a <kfree>
c0107a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107a4c:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107a58:	75 b3                	jne    c0107a0d <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a5d:	89 04 24             	mov    %eax,(%esp)
c0107a60:	e8 35 cf ff ff       	call   c010499a <kfree>
    mm=NULL;
c0107a65:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107a6c:	c9                   	leave  
c0107a6d:	c3                   	ret    

c0107a6e <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107a6e:	55                   	push   %ebp
c0107a6f:	89 e5                	mov    %esp,%ebp
c0107a71:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107a74:	e8 02 00 00 00       	call   c0107a7b <check_vmm>
}
c0107a79:	c9                   	leave  
c0107a7a:	c3                   	ret    

c0107a7b <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107a7b:	55                   	push   %ebp
c0107a7c:	89 e5                	mov    %esp,%ebp
c0107a7e:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a81:	e8 f3 d3 ff ff       	call   c0104e79 <nr_free_pages>
c0107a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107a89:	e8 13 00 00 00       	call   c0107aa1 <check_vma_struct>
    check_pgfault();
c0107a8e:	e8 a7 04 00 00       	call   c0107f3a <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0107a93:	c7 04 24 29 b7 10 c0 	movl   $0xc010b729,(%esp)
c0107a9a:	e8 b4 88 ff ff       	call   c0100353 <cprintf>
}
c0107a9f:	c9                   	leave  
c0107aa0:	c3                   	ret    

c0107aa1 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107aa1:	55                   	push   %ebp
c0107aa2:	89 e5                	mov    %esp,%ebp
c0107aa4:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107aa7:	e8 cd d3 ff ff       	call   c0104e79 <nr_free_pages>
c0107aac:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107aaf:	e8 13 fc ff ff       	call   c01076c7 <mm_create>
c0107ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107ab7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107abb:	75 24                	jne    c0107ae1 <check_vma_struct+0x40>
c0107abd:	c7 44 24 0c 41 b7 10 	movl   $0xc010b741,0xc(%esp)
c0107ac4:	c0 
c0107ac5:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107acc:	c0 
c0107acd:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107ad4:	00 
c0107ad5:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107adc:	e8 fc 91 ff ff       	call   c0100cdd <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107ae1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107ae8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107aeb:	89 d0                	mov    %edx,%eax
c0107aed:	c1 e0 02             	shl    $0x2,%eax
c0107af0:	01 d0                	add    %edx,%eax
c0107af2:	01 c0                	add    %eax,%eax
c0107af4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107afd:	eb 70                	jmp    c0107b6f <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b02:	89 d0                	mov    %edx,%eax
c0107b04:	c1 e0 02             	shl    $0x2,%eax
c0107b07:	01 d0                	add    %edx,%eax
c0107b09:	83 c0 02             	add    $0x2,%eax
c0107b0c:	89 c1                	mov    %eax,%ecx
c0107b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b11:	89 d0                	mov    %edx,%eax
c0107b13:	c1 e0 02             	shl    $0x2,%eax
c0107b16:	01 d0                	add    %edx,%eax
c0107b18:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b1f:	00 
c0107b20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107b24:	89 04 24             	mov    %eax,(%esp)
c0107b27:	e8 13 fc ff ff       	call   c010773f <vma_create>
c0107b2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107b2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107b33:	75 24                	jne    c0107b59 <check_vma_struct+0xb8>
c0107b35:	c7 44 24 0c 4c b7 10 	movl   $0xc010b74c,0xc(%esp)
c0107b3c:	c0 
c0107b3d:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107b44:	c0 
c0107b45:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107b4c:	00 
c0107b4d:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107b54:	e8 84 91 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107b59:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b63:	89 04 24             	mov    %eax,(%esp)
c0107b66:	e8 64 fd ff ff       	call   c01078cf <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107b6b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107b73:	7f 8a                	jg     c0107aff <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b78:	83 c0 01             	add    $0x1,%eax
c0107b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107b7e:	eb 70                	jmp    c0107bf0 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b83:	89 d0                	mov    %edx,%eax
c0107b85:	c1 e0 02             	shl    $0x2,%eax
c0107b88:	01 d0                	add    %edx,%eax
c0107b8a:	83 c0 02             	add    $0x2,%eax
c0107b8d:	89 c1                	mov    %eax,%ecx
c0107b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b92:	89 d0                	mov    %edx,%eax
c0107b94:	c1 e0 02             	shl    $0x2,%eax
c0107b97:	01 d0                	add    %edx,%eax
c0107b99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107ba0:	00 
c0107ba1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107ba5:	89 04 24             	mov    %eax,(%esp)
c0107ba8:	e8 92 fb ff ff       	call   c010773f <vma_create>
c0107bad:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107bb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107bb4:	75 24                	jne    c0107bda <check_vma_struct+0x139>
c0107bb6:	c7 44 24 0c 4c b7 10 	movl   $0xc010b74c,0xc(%esp)
c0107bbd:	c0 
c0107bbe:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107bc5:	c0 
c0107bc6:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107bcd:	00 
c0107bce:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107bd5:	e8 03 91 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107bda:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107be4:	89 04 24             	mov    %eax,(%esp)
c0107be7:	e8 e3 fc ff ff       	call   c01078cf <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107bec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bf3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107bf6:	7e 88                	jle    c0107b80 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107bf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bfb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107bfe:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107c01:	8b 40 04             	mov    0x4(%eax),%eax
c0107c04:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107c07:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107c0e:	e9 97 00 00 00       	jmp    c0107caa <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c16:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107c19:	75 24                	jne    c0107c3f <check_vma_struct+0x19e>
c0107c1b:	c7 44 24 0c 58 b7 10 	movl   $0xc010b758,0xc(%esp)
c0107c22:	c0 
c0107c23:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107c2a:	c0 
c0107c2b:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107c32:	00 
c0107c33:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107c3a:	e8 9e 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c42:	83 e8 10             	sub    $0x10,%eax
c0107c45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107c4b:	8b 48 04             	mov    0x4(%eax),%ecx
c0107c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107c51:	89 d0                	mov    %edx,%eax
c0107c53:	c1 e0 02             	shl    $0x2,%eax
c0107c56:	01 d0                	add    %edx,%eax
c0107c58:	39 c1                	cmp    %eax,%ecx
c0107c5a:	75 17                	jne    c0107c73 <check_vma_struct+0x1d2>
c0107c5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107c5f:	8b 48 08             	mov    0x8(%eax),%ecx
c0107c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107c65:	89 d0                	mov    %edx,%eax
c0107c67:	c1 e0 02             	shl    $0x2,%eax
c0107c6a:	01 d0                	add    %edx,%eax
c0107c6c:	83 c0 02             	add    $0x2,%eax
c0107c6f:	39 c1                	cmp    %eax,%ecx
c0107c71:	74 24                	je     c0107c97 <check_vma_struct+0x1f6>
c0107c73:	c7 44 24 0c 70 b7 10 	movl   $0xc010b770,0xc(%esp)
c0107c7a:	c0 
c0107c7b:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107c82:	c0 
c0107c83:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107c8a:	00 
c0107c8b:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107c92:	e8 46 90 ff ff       	call   c0100cdd <__panic>
c0107c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c9a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107c9d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107ca0:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107ca6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cad:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107cb0:	0f 8e 5d ff ff ff    	jle    c0107c13 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107cb6:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107cbd:	e9 cd 01 00 00       	jmp    c0107e8f <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ccc:	89 04 24             	mov    %eax,(%esp)
c0107ccf:	e8 a6 fa ff ff       	call   c010777a <find_vma>
c0107cd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107cd7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107cdb:	75 24                	jne    c0107d01 <check_vma_struct+0x260>
c0107cdd:	c7 44 24 0c a5 b7 10 	movl   $0xc010b7a5,0xc(%esp)
c0107ce4:	c0 
c0107ce5:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107cec:	c0 
c0107ced:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107cf4:	00 
c0107cf5:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107cfc:	e8 dc 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d04:	83 c0 01             	add    $0x1,%eax
c0107d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d0e:	89 04 24             	mov    %eax,(%esp)
c0107d11:	e8 64 fa ff ff       	call   c010777a <find_vma>
c0107d16:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107d19:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107d1d:	75 24                	jne    c0107d43 <check_vma_struct+0x2a2>
c0107d1f:	c7 44 24 0c b2 b7 10 	movl   $0xc010b7b2,0xc(%esp)
c0107d26:	c0 
c0107d27:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107d2e:	c0 
c0107d2f:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107d36:	00 
c0107d37:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107d3e:	e8 9a 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d46:	83 c0 02             	add    $0x2,%eax
c0107d49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d50:	89 04 24             	mov    %eax,(%esp)
c0107d53:	e8 22 fa ff ff       	call   c010777a <find_vma>
c0107d58:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107d5b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107d5f:	74 24                	je     c0107d85 <check_vma_struct+0x2e4>
c0107d61:	c7 44 24 0c bf b7 10 	movl   $0xc010b7bf,0xc(%esp)
c0107d68:	c0 
c0107d69:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107d70:	c0 
c0107d71:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107d78:	00 
c0107d79:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107d80:	e8 58 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d88:	83 c0 03             	add    $0x3,%eax
c0107d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d92:	89 04 24             	mov    %eax,(%esp)
c0107d95:	e8 e0 f9 ff ff       	call   c010777a <find_vma>
c0107d9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107d9d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107da1:	74 24                	je     c0107dc7 <check_vma_struct+0x326>
c0107da3:	c7 44 24 0c cc b7 10 	movl   $0xc010b7cc,0xc(%esp)
c0107daa:	c0 
c0107dab:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107db2:	c0 
c0107db3:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107dba:	00 
c0107dbb:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107dc2:	e8 16 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dca:	83 c0 04             	add    $0x4,%eax
c0107dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dd4:	89 04 24             	mov    %eax,(%esp)
c0107dd7:	e8 9e f9 ff ff       	call   c010777a <find_vma>
c0107ddc:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107ddf:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107de3:	74 24                	je     c0107e09 <check_vma_struct+0x368>
c0107de5:	c7 44 24 0c d9 b7 10 	movl   $0xc010b7d9,0xc(%esp)
c0107dec:	c0 
c0107ded:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107df4:	c0 
c0107df5:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107dfc:	00 
c0107dfd:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107e04:	e8 d4 8e ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107e09:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107e0c:	8b 50 04             	mov    0x4(%eax),%edx
c0107e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e12:	39 c2                	cmp    %eax,%edx
c0107e14:	75 10                	jne    c0107e26 <check_vma_struct+0x385>
c0107e16:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107e19:	8b 50 08             	mov    0x8(%eax),%edx
c0107e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e1f:	83 c0 02             	add    $0x2,%eax
c0107e22:	39 c2                	cmp    %eax,%edx
c0107e24:	74 24                	je     c0107e4a <check_vma_struct+0x3a9>
c0107e26:	c7 44 24 0c e8 b7 10 	movl   $0xc010b7e8,0xc(%esp)
c0107e2d:	c0 
c0107e2e:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107e35:	c0 
c0107e36:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0107e3d:	00 
c0107e3e:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107e45:	e8 93 8e ff ff       	call   c0100cdd <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107e4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e4d:	8b 50 04             	mov    0x4(%eax),%edx
c0107e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e53:	39 c2                	cmp    %eax,%edx
c0107e55:	75 10                	jne    c0107e67 <check_vma_struct+0x3c6>
c0107e57:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e5a:	8b 50 08             	mov    0x8(%eax),%edx
c0107e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e60:	83 c0 02             	add    $0x2,%eax
c0107e63:	39 c2                	cmp    %eax,%edx
c0107e65:	74 24                	je     c0107e8b <check_vma_struct+0x3ea>
c0107e67:	c7 44 24 0c 18 b8 10 	movl   $0xc010b818,0xc(%esp)
c0107e6e:	c0 
c0107e6f:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107e76:	c0 
c0107e77:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107e7e:	00 
c0107e7f:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107e86:	e8 52 8e ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107e8b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107e8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107e92:	89 d0                	mov    %edx,%eax
c0107e94:	c1 e0 02             	shl    $0x2,%eax
c0107e97:	01 d0                	add    %edx,%eax
c0107e99:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107e9c:	0f 8d 20 fe ff ff    	jge    c0107cc2 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107ea2:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107ea9:	eb 70                	jmp    c0107f1b <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107eae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107eb5:	89 04 24             	mov    %eax,(%esp)
c0107eb8:	e8 bd f8 ff ff       	call   c010777a <find_vma>
c0107ebd:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107ec0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107ec4:	74 27                	je     c0107eed <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107ec6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107ec9:	8b 50 08             	mov    0x8(%eax),%edx
c0107ecc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107ecf:	8b 40 04             	mov    0x4(%eax),%eax
c0107ed2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107ed6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107edd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ee1:	c7 04 24 48 b8 10 c0 	movl   $0xc010b848,(%esp)
c0107ee8:	e8 66 84 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107eed:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107ef1:	74 24                	je     c0107f17 <check_vma_struct+0x476>
c0107ef3:	c7 44 24 0c 6d b8 10 	movl   $0xc010b86d,0xc(%esp)
c0107efa:	c0 
c0107efb:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107f02:	c0 
c0107f03:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107f0a:	00 
c0107f0b:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107f12:	e8 c6 8d ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107f17:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107f1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f1f:	79 8a                	jns    c0107eab <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f24:	89 04 24             	mov    %eax,(%esp)
c0107f27:	e8 d3 fa ff ff       	call   c01079ff <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0107f2c:	c7 04 24 84 b8 10 c0 	movl   $0xc010b884,(%esp)
c0107f33:	e8 1b 84 ff ff       	call   c0100353 <cprintf>
}
c0107f38:	c9                   	leave  
c0107f39:	c3                   	ret    

c0107f3a <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107f3a:	55                   	push   %ebp
c0107f3b:	89 e5                	mov    %esp,%ebp
c0107f3d:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107f40:	e8 34 cf ff ff       	call   c0104e79 <nr_free_pages>
c0107f45:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107f48:	e8 7a f7 ff ff       	call   c01076c7 <mm_create>
c0107f4d:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c0107f52:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107f57:	85 c0                	test   %eax,%eax
c0107f59:	75 24                	jne    c0107f7f <check_pgfault+0x45>
c0107f5b:	c7 44 24 0c a3 b8 10 	movl   $0xc010b8a3,0xc(%esp)
c0107f62:	c0 
c0107f63:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107f6a:	c0 
c0107f6b:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0107f72:	00 
c0107f73:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107f7a:	e8 5e 8d ff ff       	call   c0100cdd <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107f7f:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107f84:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107f87:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0107f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f90:	89 50 0c             	mov    %edx,0xc(%eax)
c0107f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f96:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f9f:	8b 00                	mov    (%eax),%eax
c0107fa1:	85 c0                	test   %eax,%eax
c0107fa3:	74 24                	je     c0107fc9 <check_pgfault+0x8f>
c0107fa5:	c7 44 24 0c bb b8 10 	movl   $0xc010b8bb,0xc(%esp)
c0107fac:	c0 
c0107fad:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107fb4:	c0 
c0107fb5:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0107fbc:	00 
c0107fbd:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0107fc4:	e8 14 8d ff ff       	call   c0100cdd <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107fc9:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107fd0:	00 
c0107fd1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107fd8:	00 
c0107fd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107fe0:	e8 5a f7 ff ff       	call   c010773f <vma_create>
c0107fe5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107fe8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107fec:	75 24                	jne    c0108012 <check_pgfault+0xd8>
c0107fee:	c7 44 24 0c 4c b7 10 	movl   $0xc010b74c,0xc(%esp)
c0107ff5:	c0 
c0107ff6:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0107ffd:	c0 
c0107ffe:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0108005:	00 
c0108006:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c010800d:	e8 cb 8c ff ff       	call   c0100cdd <__panic>

    insert_vma_struct(mm, vma);
c0108012:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108015:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108019:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010801c:	89 04 24             	mov    %eax,(%esp)
c010801f:	e8 ab f8 ff ff       	call   c01078cf <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108024:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010802b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010802e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108032:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108035:	89 04 24             	mov    %eax,(%esp)
c0108038:	e8 3d f7 ff ff       	call   c010777a <find_vma>
c010803d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108040:	74 24                	je     c0108066 <check_pgfault+0x12c>
c0108042:	c7 44 24 0c c9 b8 10 	movl   $0xc010b8c9,0xc(%esp)
c0108049:	c0 
c010804a:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c0108051:	c0 
c0108052:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0108059:	00 
c010805a:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c0108061:	e8 77 8c ff ff       	call   c0100cdd <__panic>

    int i, sum = 0;
c0108066:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c010806d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108074:	eb 17                	jmp    c010808d <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108076:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108079:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010807c:	01 d0                	add    %edx,%eax
c010807e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108081:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108086:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108089:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010808d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108091:	7e e3                	jle    c0108076 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108093:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010809a:	eb 15                	jmp    c01080b1 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c010809c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010809f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080a2:	01 d0                	add    %edx,%eax
c01080a4:	0f b6 00             	movzbl (%eax),%eax
c01080a7:	0f be c0             	movsbl %al,%eax
c01080aa:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01080ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01080b1:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01080b5:	7e e5                	jle    c010809c <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c01080b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01080bb:	74 24                	je     c01080e1 <check_pgfault+0x1a7>
c01080bd:	c7 44 24 0c e3 b8 10 	movl   $0xc010b8e3,0xc(%esp)
c01080c4:	c0 
c01080c5:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c01080cc:	c0 
c01080cd:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01080d4:	00 
c01080d5:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c01080dc:	e8 fc 8b ff ff       	call   c0100cdd <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01080e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01080e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01080ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01080ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080f6:	89 04 24             	mov    %eax,(%esp)
c01080f9:	e8 3c d6 ff ff       	call   c010573a <page_remove>
    free_page(pde2page(pgdir[0]));
c01080fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108101:	8b 00                	mov    (%eax),%eax
c0108103:	89 04 24             	mov    %eax,(%esp)
c0108106:	e8 a4 f5 ff ff       	call   c01076af <pde2page>
c010810b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108112:	00 
c0108113:	89 04 24             	mov    %eax,(%esp)
c0108116:	e8 2c cd ff ff       	call   c0104e47 <free_pages>
    pgdir[0] = 0;
c010811b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010811e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108124:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108127:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010812e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108131:	89 04 24             	mov    %eax,(%esp)
c0108134:	e8 c6 f8 ff ff       	call   c01079ff <mm_destroy>
    check_mm_struct = NULL;
c0108139:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c0108140:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108143:	e8 31 cd ff ff       	call   c0104e79 <nr_free_pages>
c0108148:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010814b:	74 24                	je     c0108171 <check_pgfault+0x237>
c010814d:	c7 44 24 0c ec b8 10 	movl   $0xc010b8ec,0xc(%esp)
c0108154:	c0 
c0108155:	c7 44 24 08 ab b6 10 	movl   $0xc010b6ab,0x8(%esp)
c010815c:	c0 
c010815d:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0108164:	00 
c0108165:	c7 04 24 c0 b6 10 c0 	movl   $0xc010b6c0,(%esp)
c010816c:	e8 6c 8b ff ff       	call   c0100cdd <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108171:	c7 04 24 13 b9 10 c0 	movl   $0xc010b913,(%esp)
c0108178:	e8 d6 81 ff ff       	call   c0100353 <cprintf>
}
c010817d:	c9                   	leave  
c010817e:	c3                   	ret    

c010817f <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c010817f:	55                   	push   %ebp
c0108180:	89 e5                	mov    %esp,%ebp
c0108182:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108185:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c010818c:	8b 45 10             	mov    0x10(%ebp),%eax
c010818f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108193:	8b 45 08             	mov    0x8(%ebp),%eax
c0108196:	89 04 24             	mov    %eax,(%esp)
c0108199:	e8 dc f5 ff ff       	call   c010777a <find_vma>
c010819e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c01081a1:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01081a6:	83 c0 01             	add    $0x1,%eax
c01081a9:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c01081ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01081b2:	74 0b                	je     c01081bf <do_pgfault+0x40>
c01081b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081b7:	8b 40 04             	mov    0x4(%eax),%eax
c01081ba:	3b 45 10             	cmp    0x10(%ebp),%eax
c01081bd:	76 18                	jbe    c01081d7 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01081bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01081c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081c6:	c7 04 24 30 b9 10 c0 	movl   $0xc010b930,(%esp)
c01081cd:	e8 81 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c01081d2:	e9 7f 01 00 00       	jmp    c0108356 <do_pgfault+0x1d7>
    }
    //check the error_code
    switch (error_code & 3) {
c01081d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081da:	83 e0 03             	and    $0x3,%eax
c01081dd:	85 c0                	test   %eax,%eax
c01081df:	74 36                	je     c0108217 <do_pgfault+0x98>
c01081e1:	83 f8 01             	cmp    $0x1,%eax
c01081e4:	74 20                	je     c0108206 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01081e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081e9:	8b 40 0c             	mov    0xc(%eax),%eax
c01081ec:	83 e0 02             	and    $0x2,%eax
c01081ef:	85 c0                	test   %eax,%eax
c01081f1:	75 11                	jne    c0108204 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01081f3:	c7 04 24 60 b9 10 c0 	movl   $0xc010b960,(%esp)
c01081fa:	e8 54 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c01081ff:	e9 52 01 00 00       	jmp    c0108356 <do_pgfault+0x1d7>
        }
        break;
c0108204:	eb 2f                	jmp    c0108235 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108206:	c7 04 24 c0 b9 10 c0 	movl   $0xc010b9c0,(%esp)
c010820d:	e8 41 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108212:	e9 3f 01 00 00       	jmp    c0108356 <do_pgfault+0x1d7>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108217:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010821a:	8b 40 0c             	mov    0xc(%eax),%eax
c010821d:	83 e0 05             	and    $0x5,%eax
c0108220:	85 c0                	test   %eax,%eax
c0108222:	75 11                	jne    c0108235 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108224:	c7 04 24 f8 b9 10 c0 	movl   $0xc010b9f8,(%esp)
c010822b:	e8 23 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108230:	e9 21 01 00 00       	jmp    c0108356 <do_pgfault+0x1d7>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108235:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c010823c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010823f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108242:	83 e0 02             	and    $0x2,%eax
c0108245:	85 c0                	test   %eax,%eax
c0108247:	74 04                	je     c010824d <do_pgfault+0xce>
        perm |= PTE_W;
c0108249:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c010824d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108250:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108253:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108256:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010825b:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c010825e:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108265:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
ptep = get_pte(mm->pgdir, addr, 1); // 根据引发缺页异常的地址 去找到 地址所对应的 PTE 如果找不到 则创建一页表
c010826c:	8b 45 08             	mov    0x8(%ebp),%eax
c010826f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108272:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108279:	00 
c010827a:	8b 55 10             	mov    0x10(%ebp),%edx
c010827d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108281:	89 04 24             	mov    %eax,(%esp)
c0108284:	e8 ba d2 ff ff       	call   c0105543 <get_pte>
c0108289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) { // PTE 所指向的 物理页表地址 若不存在 则分配一物理页并将逻辑地址和物理地址作映射 (就是让 PTE 指向 物理页帧)
c010828c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010828f:	8b 00                	mov    (%eax),%eax
c0108291:	85 c0                	test   %eax,%eax
c0108293:	75 29                	jne    c01082be <do_pgfault+0x13f>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0108295:	8b 45 08             	mov    0x8(%ebp),%eax
c0108298:	8b 40 0c             	mov    0xc(%eax),%eax
c010829b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010829e:	89 54 24 08          	mov    %edx,0x8(%esp)
c01082a2:	8b 55 10             	mov    0x10(%ebp),%edx
c01082a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082a9:	89 04 24             	mov    %eax,(%esp)
c01082ac:	e8 e3 d5 ff ff       	call   c0105894 <pgdir_alloc_page>
c01082b1:	85 c0                	test   %eax,%eax
c01082b3:	0f 85 96 00 00 00    	jne    c010834f <do_pgfault+0x1d0>
            goto failed;
c01082b9:	e9 98 00 00 00       	jmp    c0108356 <do_pgfault+0x1d7>
        }
    }
    else { // 如果 PTE 存在 说明此时 P 位为 0 该页被换出到外存中 需要将其换入内存
        if(swap_init_ok) { // 是否可以换入页面
c01082be:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01082c3:	85 c0                	test   %eax,%eax
c01082c5:	0f 84 84 00 00 00    	je     c010834f <do_pgfault+0x1d0>
            struct Page *page = NULL;
c01082cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page); // 根据 PTE 找到 换出那页所在的硬盘地址 并将其从外存中换入
c01082d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01082d5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01082dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01082e3:	89 04 24             	mov    %eax,(%esp)
c01082e6:	e8 39 e6 ff ff       	call   c0106924 <swap_in>
c01082eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c01082ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01082f2:	74 0e                	je     c0108302 <do_pgfault+0x183>
                cprintf("swap_in in do_pgfault failed\n");
c01082f4:	c7 04 24 5b ba 10 c0 	movl   $0xc010ba5b,(%esp)
c01082fb:	e8 53 80 ff ff       	call   c0100353 <cprintf>
c0108300:	eb 54                	jmp    c0108356 <do_pgfault+0x1d7>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm); // 建立虚拟地址和物理地址之间的对应关系(更新 PTE 因为 已经被换入到内存中了)
c0108302:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108305:	8b 45 08             	mov    0x8(%ebp),%eax
c0108308:	8b 40 0c             	mov    0xc(%eax),%eax
c010830b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010830e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108312:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108315:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108319:	89 54 24 04          	mov    %edx,0x4(%esp)
c010831d:	89 04 24             	mov    %eax,(%esp)
c0108320:	e8 59 d4 ff ff       	call   c010577e <page_insert>
            swap_map_swappable(mm, addr, page, 0); // 使这一页可以置换
c0108325:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108328:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010832f:	00 
c0108330:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108334:	8b 45 10             	mov    0x10(%ebp),%eax
c0108337:	89 44 24 04          	mov    %eax,0x4(%esp)
c010833b:	8b 45 08             	mov    0x8(%ebp),%eax
c010833e:	89 04 24             	mov    %eax,(%esp)
c0108341:	e8 15 e4 ff ff       	call   c010675b <swap_map_swappable>
            page->pra_vaddr = addr; // 设置 这一页的虚拟地址
c0108346:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108349:	8b 55 10             	mov    0x10(%ebp),%edx
c010834c:	89 50 1c             	mov    %edx,0x1c(%eax)
        }
    }
   ret = 0;
c010834f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108356:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108359:	c9                   	leave  
c010835a:	c3                   	ret    

c010835b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010835b:	55                   	push   %ebp
c010835c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010835e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108361:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108366:	29 c2                	sub    %eax,%edx
c0108368:	89 d0                	mov    %edx,%eax
c010836a:	c1 f8 05             	sar    $0x5,%eax
}
c010836d:	5d                   	pop    %ebp
c010836e:	c3                   	ret    

c010836f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010836f:	55                   	push   %ebp
c0108370:	89 e5                	mov    %esp,%ebp
c0108372:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108375:	8b 45 08             	mov    0x8(%ebp),%eax
c0108378:	89 04 24             	mov    %eax,(%esp)
c010837b:	e8 db ff ff ff       	call   c010835b <page2ppn>
c0108380:	c1 e0 0c             	shl    $0xc,%eax
}
c0108383:	c9                   	leave  
c0108384:	c3                   	ret    

c0108385 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108385:	55                   	push   %ebp
c0108386:	89 e5                	mov    %esp,%ebp
c0108388:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010838b:	8b 45 08             	mov    0x8(%ebp),%eax
c010838e:	89 04 24             	mov    %eax,(%esp)
c0108391:	e8 d9 ff ff ff       	call   c010836f <page2pa>
c0108396:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108399:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010839c:	c1 e8 0c             	shr    $0xc,%eax
c010839f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083a2:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01083a7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01083aa:	72 23                	jb     c01083cf <page2kva+0x4a>
c01083ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083af:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01083b3:	c7 44 24 08 7c ba 10 	movl   $0xc010ba7c,0x8(%esp)
c01083ba:	c0 
c01083bb:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01083c2:	00 
c01083c3:	c7 04 24 9f ba 10 c0 	movl   $0xc010ba9f,(%esp)
c01083ca:	e8 0e 89 ff ff       	call   c0100cdd <__panic>
c01083cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083d2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01083d7:	c9                   	leave  
c01083d8:	c3                   	ret    

c01083d9 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01083d9:	55                   	push   %ebp
c01083da:	89 e5                	mov    %esp,%ebp
c01083dc:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01083df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083e6:	e8 42 96 ff ff       	call   c0101a2d <ide_device_valid>
c01083eb:	85 c0                	test   %eax,%eax
c01083ed:	75 1c                	jne    c010840b <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01083ef:	c7 44 24 08 ad ba 10 	movl   $0xc010baad,0x8(%esp)
c01083f6:	c0 
c01083f7:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01083fe:	00 
c01083ff:	c7 04 24 c7 ba 10 c0 	movl   $0xc010bac7,(%esp)
c0108406:	e8 d2 88 ff ff       	call   c0100cdd <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010840b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108412:	e8 55 96 ff ff       	call   c0101a6c <ide_device_size>
c0108417:	c1 e8 03             	shr    $0x3,%eax
c010841a:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c010841f:	c9                   	leave  
c0108420:	c3                   	ret    

c0108421 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108421:	55                   	push   %ebp
c0108422:	89 e5                	mov    %esp,%ebp
c0108424:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108427:	8b 45 0c             	mov    0xc(%ebp),%eax
c010842a:	89 04 24             	mov    %eax,(%esp)
c010842d:	e8 53 ff ff ff       	call   c0108385 <page2kva>
c0108432:	8b 55 08             	mov    0x8(%ebp),%edx
c0108435:	c1 ea 08             	shr    $0x8,%edx
c0108438:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010843b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010843f:	74 0b                	je     c010844c <swapfs_read+0x2b>
c0108441:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108447:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010844a:	72 23                	jb     c010846f <swapfs_read+0x4e>
c010844c:	8b 45 08             	mov    0x8(%ebp),%eax
c010844f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108453:	c7 44 24 08 d8 ba 10 	movl   $0xc010bad8,0x8(%esp)
c010845a:	c0 
c010845b:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108462:	00 
c0108463:	c7 04 24 c7 ba 10 c0 	movl   $0xc010bac7,(%esp)
c010846a:	e8 6e 88 ff ff       	call   c0100cdd <__panic>
c010846f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108472:	c1 e2 03             	shl    $0x3,%edx
c0108475:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010847c:	00 
c010847d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108481:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108485:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010848c:	e8 1a 96 ff ff       	call   c0101aab <ide_read_secs>
}
c0108491:	c9                   	leave  
c0108492:	c3                   	ret    

c0108493 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108493:	55                   	push   %ebp
c0108494:	89 e5                	mov    %esp,%ebp
c0108496:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108499:	8b 45 0c             	mov    0xc(%ebp),%eax
c010849c:	89 04 24             	mov    %eax,(%esp)
c010849f:	e8 e1 fe ff ff       	call   c0108385 <page2kva>
c01084a4:	8b 55 08             	mov    0x8(%ebp),%edx
c01084a7:	c1 ea 08             	shr    $0x8,%edx
c01084aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01084ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01084b1:	74 0b                	je     c01084be <swapfs_write+0x2b>
c01084b3:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c01084b9:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01084bc:	72 23                	jb     c01084e1 <swapfs_write+0x4e>
c01084be:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01084c5:	c7 44 24 08 d8 ba 10 	movl   $0xc010bad8,0x8(%esp)
c01084cc:	c0 
c01084cd:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01084d4:	00 
c01084d5:	c7 04 24 c7 ba 10 c0 	movl   $0xc010bac7,(%esp)
c01084dc:	e8 fc 87 ff ff       	call   c0100cdd <__panic>
c01084e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084e4:	c1 e2 03             	shl    $0x3,%edx
c01084e7:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01084ee:	00 
c01084ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084f3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01084f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01084fe:	e8 ea 97 ff ff       	call   c0101ced <ide_write_secs>
}
c0108503:	c9                   	leave  
c0108504:	c3                   	ret    

c0108505 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0108505:	52                   	push   %edx
    call *%ebx              # call fn
c0108506:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108508:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108509:	e8 24 08 00 00       	call   c0108d32 <do_exit>

c010850e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010850e:	55                   	push   %ebp
c010850f:	89 e5                	mov    %esp,%ebp
c0108511:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108514:	9c                   	pushf  
c0108515:	58                   	pop    %eax
c0108516:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108519:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010851c:	25 00 02 00 00       	and    $0x200,%eax
c0108521:	85 c0                	test   %eax,%eax
c0108523:	74 0c                	je     c0108531 <__intr_save+0x23>
        intr_disable();
c0108525:	e8 0b 9a ff ff       	call   c0101f35 <intr_disable>
        return 1;
c010852a:	b8 01 00 00 00       	mov    $0x1,%eax
c010852f:	eb 05                	jmp    c0108536 <__intr_save+0x28>
    }
    return 0;
c0108531:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108536:	c9                   	leave  
c0108537:	c3                   	ret    

c0108538 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108538:	55                   	push   %ebp
c0108539:	89 e5                	mov    %esp,%ebp
c010853b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010853e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108542:	74 05                	je     c0108549 <__intr_restore+0x11>
        intr_enable();
c0108544:	e8 e6 99 ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108549:	c9                   	leave  
c010854a:	c3                   	ret    

c010854b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010854b:	55                   	push   %ebp
c010854c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010854e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108551:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108556:	29 c2                	sub    %eax,%edx
c0108558:	89 d0                	mov    %edx,%eax
c010855a:	c1 f8 05             	sar    $0x5,%eax
}
c010855d:	5d                   	pop    %ebp
c010855e:	c3                   	ret    

c010855f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010855f:	55                   	push   %ebp
c0108560:	89 e5                	mov    %esp,%ebp
c0108562:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108565:	8b 45 08             	mov    0x8(%ebp),%eax
c0108568:	89 04 24             	mov    %eax,(%esp)
c010856b:	e8 db ff ff ff       	call   c010854b <page2ppn>
c0108570:	c1 e0 0c             	shl    $0xc,%eax
}
c0108573:	c9                   	leave  
c0108574:	c3                   	ret    

c0108575 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0108575:	55                   	push   %ebp
c0108576:	89 e5                	mov    %esp,%ebp
c0108578:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010857b:	8b 45 08             	mov    0x8(%ebp),%eax
c010857e:	c1 e8 0c             	shr    $0xc,%eax
c0108581:	89 c2                	mov    %eax,%edx
c0108583:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108588:	39 c2                	cmp    %eax,%edx
c010858a:	72 1c                	jb     c01085a8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010858c:	c7 44 24 08 f8 ba 10 	movl   $0xc010baf8,0x8(%esp)
c0108593:	c0 
c0108594:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010859b:	00 
c010859c:	c7 04 24 17 bb 10 c0 	movl   $0xc010bb17,(%esp)
c01085a3:	e8 35 87 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c01085a8:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01085ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01085b0:	c1 ea 0c             	shr    $0xc,%edx
c01085b3:	c1 e2 05             	shl    $0x5,%edx
c01085b6:	01 d0                	add    %edx,%eax
}
c01085b8:	c9                   	leave  
c01085b9:	c3                   	ret    

c01085ba <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01085ba:	55                   	push   %ebp
c01085bb:	89 e5                	mov    %esp,%ebp
c01085bd:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01085c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01085c3:	89 04 24             	mov    %eax,(%esp)
c01085c6:	e8 94 ff ff ff       	call   c010855f <page2pa>
c01085cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d1:	c1 e8 0c             	shr    $0xc,%eax
c01085d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085d7:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01085dc:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01085df:	72 23                	jb     c0108604 <page2kva+0x4a>
c01085e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085e8:	c7 44 24 08 28 bb 10 	movl   $0xc010bb28,0x8(%esp)
c01085ef:	c0 
c01085f0:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01085f7:	00 
c01085f8:	c7 04 24 17 bb 10 c0 	movl   $0xc010bb17,(%esp)
c01085ff:	e8 d9 86 ff ff       	call   c0100cdd <__panic>
c0108604:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108607:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010860c:	c9                   	leave  
c010860d:	c3                   	ret    

c010860e <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010860e:	55                   	push   %ebp
c010860f:	89 e5                	mov    %esp,%ebp
c0108611:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0108614:	8b 45 08             	mov    0x8(%ebp),%eax
c0108617:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010861a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0108621:	77 23                	ja     c0108646 <kva2page+0x38>
c0108623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108626:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010862a:	c7 44 24 08 4c bb 10 	movl   $0xc010bb4c,0x8(%esp)
c0108631:	c0 
c0108632:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0108639:	00 
c010863a:	c7 04 24 17 bb 10 c0 	movl   $0xc010bb17,(%esp)
c0108641:	e8 97 86 ff ff       	call   c0100cdd <__panic>
c0108646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108649:	05 00 00 00 40       	add    $0x40000000,%eax
c010864e:	89 04 24             	mov    %eax,(%esp)
c0108651:	e8 1f ff ff ff       	call   c0108575 <pa2page>
}
c0108656:	c9                   	leave  
c0108657:	c3                   	ret    

c0108658 <alloc_proc>:



// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c0108658:	55                   	push   %ebp
c0108659:	89 e5                	mov    %esp,%ebp
c010865b:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c010865e:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c0108665:	e8 15 c3 ff ff       	call   c010497f <kmalloc>
c010866a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c010866d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108671:	0f 84 97 00 00 00    	je     c010870e <alloc_proc+0xb6>
    //LAB4:EXERCISE1 YOUR CODE
    	proc->state = PROC_UNINIT;  // 正在创建和初始化状态中
c0108677:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010867a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	proc->pid = -1;  //未初始化的进程id为-1
c0108680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108683:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    	proc->runs = 0;  // 还没有运行过
c010868a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010868d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    	proc->kstack = 0;  // 初始化内核堆栈似乎是在do_fork()中进行的？
c0108694:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108697:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    	proc->need_resched = 0;  // 初始化为不需要调度
c010869e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086a1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    	proc->parent = NULL;
c01086a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ab:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    	proc->mm = NULL;  // 之后也不会分配，因为都是内核态线程，所以直接使用内核的mm
c01086b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086b5:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    	memset(&(proc->context), 0, sizeof(struct context));  
c01086bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086bf:	83 c0 1c             	add    $0x1c,%eax
c01086c2:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c01086c9:	00 
c01086ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086d1:	00 
c01086d2:	89 04 24             	mov    %eax,(%esp)
c01086d5:	e8 da 14 00 00       	call   c0109bb4 <memset>
    	// proc->tf = kmalloc(sizeof(struct trapframe));  // tf似乎不需要在此处设置
    	proc->cr3 = boot_cr3;  // 内核态线程不需要分配新的页表地址；这对于正确执行是必需的
c01086da:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c01086e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086e3:	89 50 40             	mov    %edx,0x40(%eax)
    	proc->flags = 0;  //标志位置为0
c01086e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086e9:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    	memset(proc->name, 0, PROC_NAME_LEN);  //将进程名清零，不过不是必需的
c01086f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086f3:	83 c0 48             	add    $0x48,%eax
c01086f6:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01086fd:	00 
c01086fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108705:	00 
c0108706:	89 04 24             	mov    %eax,(%esp)
c0108709:	e8 a6 14 00 00       	call   c0109bb4 <memset>
    }
    return proc;
c010870e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108711:	c9                   	leave  
c0108712:	c3                   	ret    

c0108713 <set_proc_name>:


// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108713:	55                   	push   %ebp
c0108714:	89 e5                	mov    %esp,%ebp
c0108716:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c0108719:	8b 45 08             	mov    0x8(%ebp),%eax
c010871c:	83 c0 48             	add    $0x48,%eax
c010871f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108726:	00 
c0108727:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010872e:	00 
c010872f:	89 04 24             	mov    %eax,(%esp)
c0108732:	e8 7d 14 00 00       	call   c0109bb4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c0108737:	8b 45 08             	mov    0x8(%ebp),%eax
c010873a:	8d 50 48             	lea    0x48(%eax),%edx
c010873d:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108744:	00 
c0108745:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108748:	89 44 24 04          	mov    %eax,0x4(%esp)
c010874c:	89 14 24             	mov    %edx,(%esp)
c010874f:	e8 42 15 00 00       	call   c0109c96 <memcpy>
}
c0108754:	c9                   	leave  
c0108755:	c3                   	ret    

c0108756 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0108756:	55                   	push   %ebp
c0108757:	89 e5                	mov    %esp,%ebp
c0108759:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c010875c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108763:	00 
c0108764:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010876b:	00 
c010876c:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c0108773:	e8 3c 14 00 00       	call   c0109bb4 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c0108778:	8b 45 08             	mov    0x8(%ebp),%eax
c010877b:	83 c0 48             	add    $0x48,%eax
c010877e:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108785:	00 
c0108786:	89 44 24 04          	mov    %eax,0x4(%esp)
c010878a:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c0108791:	e8 00 15 00 00       	call   c0109c96 <memcpy>
}
c0108796:	c9                   	leave  
c0108797:	c3                   	ret    

c0108798 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0108798:	55                   	push   %ebp
c0108799:	89 e5                	mov    %esp,%ebp
c010879b:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c010879e:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01087a5:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087aa:	83 c0 01             	add    $0x1,%eax
c01087ad:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01087b2:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087b7:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01087bc:	7e 0c                	jle    c01087ca <get_pid+0x32>
        last_pid = 1;
c01087be:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c01087c5:	00 00 00 
        goto inside;
c01087c8:	eb 13                	jmp    c01087dd <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01087ca:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c01087d0:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01087d5:	39 c2                	cmp    %eax,%edx
c01087d7:	0f 8c ac 00 00 00    	jl     c0108889 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01087dd:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c01087e4:	20 00 00 
    repeat:
        le = list;
c01087e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01087ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01087ed:	eb 7f                	jmp    c010886e <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01087ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087f2:	83 e8 58             	sub    $0x58,%eax
c01087f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01087f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087fb:	8b 50 04             	mov    0x4(%eax),%edx
c01087fe:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108803:	39 c2                	cmp    %eax,%edx
c0108805:	75 3e                	jne    c0108845 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0108807:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010880c:	83 c0 01             	add    $0x1,%eax
c010880f:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108814:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c010881a:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c010881f:	39 c2                	cmp    %eax,%edx
c0108821:	7c 4b                	jl     c010886e <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0108823:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108828:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c010882d:	7e 0a                	jle    c0108839 <get_pid+0xa1>
                        last_pid = 1;
c010882f:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108836:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0108839:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108840:	20 00 00 
                    goto repeat;
c0108843:	eb a2                	jmp    c01087e7 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108845:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108848:	8b 50 04             	mov    0x4(%eax),%edx
c010884b:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108850:	39 c2                	cmp    %eax,%edx
c0108852:	7e 1a                	jle    c010886e <get_pid+0xd6>
c0108854:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108857:	8b 50 04             	mov    0x4(%eax),%edx
c010885a:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c010885f:	39 c2                	cmp    %eax,%edx
c0108861:	7d 0b                	jge    c010886e <get_pid+0xd6>
                next_safe = proc->pid;
c0108863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108866:	8b 40 04             	mov    0x4(%eax),%eax
c0108869:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c010886e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108871:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108874:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108877:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c010887a:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010887d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108880:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108883:	0f 85 66 ff ff ff    	jne    c01087ef <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0108889:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c010888e:	c9                   	leave  
c010888f:	c3                   	ret    

c0108890 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108890:	55                   	push   %ebp
c0108891:	89 e5                	mov    %esp,%ebp
c0108893:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0108896:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010889b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010889e:	74 63                	je     c0108903 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01088a0:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01088a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c01088ae:	e8 5b fc ff ff       	call   c010850e <__intr_save>
c01088b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01088b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01088b9:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c01088be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088c1:	8b 40 0c             	mov    0xc(%eax),%eax
c01088c4:	05 00 20 00 00       	add    $0x2000,%eax
c01088c9:	89 04 24             	mov    %eax,(%esp)
c01088cc:	e8 bd c3 ff ff       	call   c0104c8e <load_esp0>
            lcr3(next->cr3);
c01088d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088d4:	8b 40 40             	mov    0x40(%eax),%eax
c01088d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01088da:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088dd:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01088e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088e3:	8d 50 1c             	lea    0x1c(%eax),%edx
c01088e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088e9:	83 c0 1c             	add    $0x1c,%eax
c01088ec:	89 54 24 04          	mov    %edx,0x4(%esp)
c01088f0:	89 04 24             	mov    %eax,(%esp)
c01088f3:	e8 8c 06 00 00       	call   c0108f84 <switch_to>
        }
        local_intr_restore(intr_flag);
c01088f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01088fb:	89 04 24             	mov    %eax,(%esp)
c01088fe:	e8 35 fc ff ff       	call   c0108538 <__intr_restore>
    }
}
c0108903:	c9                   	leave  
c0108904:	c3                   	ret    

c0108905 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108905:	55                   	push   %ebp
c0108906:	89 e5                	mov    %esp,%ebp
c0108908:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c010890b:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108910:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108913:	89 04 24             	mov    %eax,(%esp)
c0108916:	e8 88 9e ff ff       	call   c01027a3 <forkrets>
}
c010891b:	c9                   	leave  
c010891c:	c3                   	ret    

c010891d <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c010891d:	55                   	push   %ebp
c010891e:	89 e5                	mov    %esp,%ebp
c0108920:	53                   	push   %ebx
c0108921:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108924:	8b 45 08             	mov    0x8(%ebp),%eax
c0108927:	8d 58 60             	lea    0x60(%eax),%ebx
c010892a:	8b 45 08             	mov    0x8(%ebp),%eax
c010892d:	8b 40 04             	mov    0x4(%eax),%eax
c0108930:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108937:	00 
c0108938:	89 04 24             	mov    %eax,(%esp)
c010893b:	e8 c7 07 00 00       	call   c0109107 <hash32>
c0108940:	c1 e0 03             	shl    $0x3,%eax
c0108943:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108948:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010894b:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c010894e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108951:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108954:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108957:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010895a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010895d:	8b 40 04             	mov    0x4(%eax),%eax
c0108960:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108963:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108966:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108969:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010896c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010896f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108972:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108975:	89 10                	mov    %edx,(%eax)
c0108977:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010897a:	8b 10                	mov    (%eax),%edx
c010897c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010897f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108985:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108988:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010898b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010898e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108991:	89 10                	mov    %edx,(%eax)
}
c0108993:	83 c4 34             	add    $0x34,%esp
c0108996:	5b                   	pop    %ebx
c0108997:	5d                   	pop    %ebp
c0108998:	c3                   	ret    

c0108999 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108999:	55                   	push   %ebp
c010899a:	89 e5                	mov    %esp,%ebp
c010899c:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c010899f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01089a3:	7e 5f                	jle    c0108a04 <find_proc+0x6b>
c01089a5:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c01089ac:	7f 56                	jg     c0108a04 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c01089ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b1:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01089b8:	00 
c01089b9:	89 04 24             	mov    %eax,(%esp)
c01089bc:	e8 46 07 00 00       	call   c0109107 <hash32>
c01089c1:	c1 e0 03             	shl    $0x3,%eax
c01089c4:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c01089c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01089cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c01089d2:	eb 19                	jmp    c01089ed <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c01089d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089d7:	83 e8 60             	sub    $0x60,%eax
c01089da:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c01089dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089e0:	8b 40 04             	mov    0x4(%eax),%eax
c01089e3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01089e6:	75 05                	jne    c01089ed <find_proc+0x54>
                return proc;
c01089e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089eb:	eb 1c                	jmp    c0108a09 <find_proc+0x70>
c01089ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01089f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089f6:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c01089f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108a02:	75 d0                	jne    c01089d4 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108a09:	c9                   	leave  
c0108a0a:	c3                   	ret    

c0108a0b <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108a0b:	55                   	push   %ebp
c0108a0c:	89 e5                	mov    %esp,%ebp
c0108a0e:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108a11:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0108a18:	00 
c0108a19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108a20:	00 
c0108a21:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108a24:	89 04 24             	mov    %eax,(%esp)
c0108a27:	e8 88 11 00 00       	call   c0109bb4 <memset>
    tf.tf_cs = KERNEL_CS;
c0108a2c:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108a32:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108a38:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108a3c:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108a40:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108a44:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a4b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a51:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108a54:	b8 05 85 10 c0       	mov    $0xc0108505,%eax
c0108a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108a5c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a5f:	80 cc 01             	or     $0x1,%ah
c0108a62:	89 c2                	mov    %eax,%edx
c0108a64:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108a67:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108a6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108a72:	00 
c0108a73:	89 14 24             	mov    %edx,(%esp)
c0108a76:	e8 79 01 00 00       	call   c0108bf4 <do_fork>
}
c0108a7b:	c9                   	leave  
c0108a7c:	c3                   	ret    

c0108a7d <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108a7d:	55                   	push   %ebp
c0108a7e:	89 e5                	mov    %esp,%ebp
c0108a80:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108a83:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108a8a:	e8 4d c3 ff ff       	call   c0104ddc <alloc_pages>
c0108a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108a96:	74 1a                	je     c0108ab2 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a9b:	89 04 24             	mov    %eax,(%esp)
c0108a9e:	e8 17 fb ff ff       	call   c01085ba <page2kva>
c0108aa3:	89 c2                	mov    %eax,%edx
c0108aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa8:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108aab:	b8 00 00 00 00       	mov    $0x0,%eax
c0108ab0:	eb 05                	jmp    c0108ab7 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108ab2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108ab7:	c9                   	leave  
c0108ab8:	c3                   	ret    

c0108ab9 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108ab9:	55                   	push   %ebp
c0108aba:	89 e5                	mov    %esp,%ebp
c0108abc:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ac2:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ac5:	89 04 24             	mov    %eax,(%esp)
c0108ac8:	e8 41 fb ff ff       	call   c010860e <kva2page>
c0108acd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108ad4:	00 
c0108ad5:	89 04 24             	mov    %eax,(%esp)
c0108ad8:	e8 6a c3 ff ff       	call   c0104e47 <free_pages>
}
c0108add:	c9                   	leave  
c0108ade:	c3                   	ret    

c0108adf <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108adf:	55                   	push   %ebp
c0108ae0:	89 e5                	mov    %esp,%ebp
c0108ae2:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108ae5:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108aea:	8b 40 18             	mov    0x18(%eax),%eax
c0108aed:	85 c0                	test   %eax,%eax
c0108aef:	74 24                	je     c0108b15 <copy_mm+0x36>
c0108af1:	c7 44 24 0c 70 bb 10 	movl   $0xc010bb70,0xc(%esp)
c0108af8:	c0 
c0108af9:	c7 44 24 08 84 bb 10 	movl   $0xc010bb84,0x8(%esp)
c0108b00:	c0 
c0108b01:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0108b08:	00 
c0108b09:	c7 04 24 99 bb 10 c0 	movl   $0xc010bb99,(%esp)
c0108b10:	e8 c8 81 ff ff       	call   c0100cdd <__panic>
    /* do nothing in this project */
    return 0;
c0108b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b1a:	c9                   	leave  
c0108b1b:	c3                   	ret    

c0108b1c <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108b1c:	55                   	push   %ebp
c0108b1d:	89 e5                	mov    %esp,%ebp
c0108b1f:	57                   	push   %edi
c0108b20:	56                   	push   %esi
c0108b21:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b25:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b28:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108b2d:	89 c2                	mov    %eax,%edx
c0108b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b32:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b38:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b3b:	8b 55 10             	mov    0x10(%ebp),%edx
c0108b3e:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108b43:	89 c1                	mov    %eax,%ecx
c0108b45:	83 e1 01             	and    $0x1,%ecx
c0108b48:	85 c9                	test   %ecx,%ecx
c0108b4a:	74 0e                	je     c0108b5a <copy_thread+0x3e>
c0108b4c:	0f b6 0a             	movzbl (%edx),%ecx
c0108b4f:	88 08                	mov    %cl,(%eax)
c0108b51:	83 c0 01             	add    $0x1,%eax
c0108b54:	83 c2 01             	add    $0x1,%edx
c0108b57:	83 eb 01             	sub    $0x1,%ebx
c0108b5a:	89 c1                	mov    %eax,%ecx
c0108b5c:	83 e1 02             	and    $0x2,%ecx
c0108b5f:	85 c9                	test   %ecx,%ecx
c0108b61:	74 0f                	je     c0108b72 <copy_thread+0x56>
c0108b63:	0f b7 0a             	movzwl (%edx),%ecx
c0108b66:	66 89 08             	mov    %cx,(%eax)
c0108b69:	83 c0 02             	add    $0x2,%eax
c0108b6c:	83 c2 02             	add    $0x2,%edx
c0108b6f:	83 eb 02             	sub    $0x2,%ebx
c0108b72:	89 d9                	mov    %ebx,%ecx
c0108b74:	c1 e9 02             	shr    $0x2,%ecx
c0108b77:	89 c7                	mov    %eax,%edi
c0108b79:	89 d6                	mov    %edx,%esi
c0108b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b7d:	89 f2                	mov    %esi,%edx
c0108b7f:	89 f8                	mov    %edi,%eax
c0108b81:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108b86:	89 de                	mov    %ebx,%esi
c0108b88:	83 e6 02             	and    $0x2,%esi
c0108b8b:	85 f6                	test   %esi,%esi
c0108b8d:	74 0b                	je     c0108b9a <copy_thread+0x7e>
c0108b8f:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108b93:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108b97:	83 c1 02             	add    $0x2,%ecx
c0108b9a:	83 e3 01             	and    $0x1,%ebx
c0108b9d:	85 db                	test   %ebx,%ebx
c0108b9f:	74 07                	je     c0108ba8 <copy_thread+0x8c>
c0108ba1:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108ba5:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bab:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108bae:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb8:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108bbe:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bc4:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108bc7:	8b 55 08             	mov    0x8(%ebp),%edx
c0108bca:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108bcd:	8b 52 40             	mov    0x40(%edx),%edx
c0108bd0:	80 ce 02             	or     $0x2,%dh
c0108bd3:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108bd6:	ba 05 89 10 c0       	mov    $0xc0108905,%edx
c0108bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bde:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108be4:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108be7:	89 c2                	mov    %eax,%edx
c0108be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bec:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108bef:	5b                   	pop    %ebx
c0108bf0:	5e                   	pop    %esi
c0108bf1:	5f                   	pop    %edi
c0108bf2:	5d                   	pop    %ebp
c0108bf3:	c3                   	ret    

c0108bf4 <do_fork>:
 */



int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108bf4:	55                   	push   %ebp
c0108bf5:	89 e5                	mov    %esp,%ebp
c0108bf7:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_NO_FREE_PROC;
c0108bfa:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108c01:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108c06:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108c0b:	7e 05                	jle    c0108c12 <do_fork+0x1e>
        goto fork_out;
c0108c0d:	e9 0c 01 00 00       	jmp    c0108d1e <do_fork+0x12a>
    }
    ret = -E_NO_MEM;
c0108c12:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    1. call alloc_proc to allocate a proc_struct
    proc = alloc_proc();
c0108c19:	e8 3a fa ff ff       	call   c0108658 <alloc_proc>
c0108c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (proc == NULL) {  
c0108c21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108c25:	75 05                	jne    c0108c2c <do_fork+0x38>
    	goto fork_out;
c0108c27:	e9 f2 00 00 00       	jmp    c0108d1e <do_fork+0x12a>
    }
    proc->parent = current;  // 参考了答案
c0108c2c:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c35:	89 50 14             	mov    %edx,0x14(%eax)
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc) != 0) {  
c0108c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c3b:	89 04 24             	mov    %eax,(%esp)
c0108c3e:	e8 3a fe ff ff       	call   c0108a7d <setup_kstack>
c0108c43:	85 c0                	test   %eax,%eax
c0108c45:	74 05                	je     c0108c4c <do_fork+0x58>
    	goto bad_fork_cleanup_proc;
c0108c47:	e9 d7 00 00 00       	jmp    c0108d23 <do_fork+0x12f>
    }
    //    3. call copy_mm to dup OR share mm according clone_flag
    // CLONE_VM表示分享
    if (copy_mm(clone_flags, proc) != 0) {  
c0108c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c53:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c56:	89 04 24             	mov    %eax,(%esp)
c0108c59:	e8 81 fe ff ff       	call   c0108adf <copy_mm>
c0108c5e:	85 c0                	test   %eax,%eax
c0108c60:	74 11                	je     c0108c73 <do_fork+0x7f>
    	goto bad_fork_cleanup_kstack;
c0108c62:	90                   	nop
    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c66:	89 04 24             	mov    %eax,(%esp)
c0108c69:	e8 4b fe ff ff       	call   c0108ab9 <put_kstack>
c0108c6e:	e9 b0 00 00 00       	jmp    c0108d23 <do_fork+0x12f>
    // CLONE_VM表示分享
    if (copy_mm(clone_flags, proc) != 0) {  
    	goto bad_fork_cleanup_kstack;
    }
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
c0108c73:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c76:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c84:	89 04 24             	mov    %eax,(%esp)
c0108c87:	e8 90 fe ff ff       	call   c0108b1c <copy_thread>
    //    5. insert proc_struct into hash_list && proc_list
    // 参考了答案：关中断的原因是，进程号要求唯一性，此操作需要为原子操作，防止被打断而重复添加
    bool intr_flag;
	local_intr_save(intr_flag);
c0108c8c:	e8 7d f8 ff ff       	call   c010850e <__intr_save>
c0108c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
	{
    	proc->pid = get_pid();
c0108c94:	e8 ff fa ff ff       	call   c0108798 <get_pid>
c0108c99:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108c9c:	89 42 04             	mov    %eax,0x4(%edx)
		hash_proc(proc);
c0108c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ca2:	89 04 24             	mov    %eax,(%esp)
c0108ca5:	e8 73 fc ff ff       	call   c010891d <hash_proc>
		nr_process++;  
c0108caa:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108caf:	83 c0 01             	add    $0x1,%eax
c0108cb2:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00
		list_add_before(&proc_list, &proc->list_link);
c0108cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cba:	83 c0 58             	add    $0x58,%eax
c0108cbd:	c7 45 e8 10 7c 12 c0 	movl   $0xc0127c10,-0x18(%ebp)
c0108cc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0108cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cca:	8b 00                	mov    (%eax),%eax
c0108ccc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108ccf:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108cd2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108cd8:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108cdb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108cde:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108ce1:	89 10                	mov    %edx,(%eax)
c0108ce3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108ce6:	8b 10                	mov    (%eax),%edx
c0108ce8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ceb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108cf1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108cf4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108cf7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108cfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108cfd:	89 10                	mov    %edx,(%eax)
	}
	local_intr_restore(intr_flag);
c0108cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d02:	89 04 24             	mov    %eax,(%esp)
c0108d05:	e8 2e f8 ff ff       	call   c0108538 <__intr_restore>
    //    6. call wakeup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
c0108d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d0d:	89 04 24             	mov    %eax,(%esp)
c0108d10:	e8 e3 02 00 00       	call   c0108ff8 <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
c0108d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d18:	8b 40 04             	mov    0x4(%eax),%eax
c0108d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
fork_out:
    return ret;
c0108d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d21:	eb 0d                	jmp    c0108d30 <do_fork+0x13c>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d26:	89 04 24             	mov    %eax,(%esp)
c0108d29:	e8 6c bc ff ff       	call   c010499a <kfree>
    goto fork_out;
c0108d2e:	eb ee                	jmp    c0108d1e <do_fork+0x12a>
}
c0108d30:	c9                   	leave  
c0108d31:	c3                   	ret    

c0108d32 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108d32:	55                   	push   %ebp
c0108d33:	89 e5                	mov    %esp,%ebp
c0108d35:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108d38:	c7 44 24 08 ad bb 10 	movl   $0xc010bbad,0x8(%esp)
c0108d3f:	c0 
c0108d40:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0108d47:	00 
c0108d48:	c7 04 24 99 bb 10 c0 	movl   $0xc010bb99,(%esp)
c0108d4f:	e8 89 7f ff ff       	call   c0100cdd <__panic>

c0108d54 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108d54:	55                   	push   %ebp
c0108d55:	89 e5                	mov    %esp,%ebp
c0108d57:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108d5a:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108d5f:	89 04 24             	mov    %eax,(%esp)
c0108d62:	e8 ef f9 ff ff       	call   c0108756 <get_proc_name>
c0108d67:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108d6d:	8b 52 04             	mov    0x4(%edx),%edx
c0108d70:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d74:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108d78:	c7 04 24 c0 bb 10 c0 	movl   $0xc010bbc0,(%esp)
c0108d7f:	e8 cf 75 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d8b:	c7 04 24 e6 bb 10 c0 	movl   $0xc010bbe6,(%esp)
c0108d92:	e8 bc 75 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108d97:	c7 04 24 f3 bb 10 c0 	movl   $0xc010bbf3,(%esp)
c0108d9e:	e8 b0 75 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108da8:	c9                   	leave  
c0108da9:	c3                   	ret    

c0108daa <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108daa:	55                   	push   %ebp
c0108dab:	89 e5                	mov    %esp,%ebp
c0108dad:	83 ec 28             	sub    $0x28,%esp
c0108db0:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108dba:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108dbd:	89 50 04             	mov    %edx,0x4(%eax)
c0108dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108dc3:	8b 50 04             	mov    0x4(%eax),%edx
c0108dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108dc9:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108dcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108dd2:	eb 26                	jmp    c0108dfa <proc_init+0x50>
        list_init(hash_list + i);
c0108dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108dd7:	c1 e0 03             	shl    $0x3,%eax
c0108dda:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108ddf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108de5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108de8:	89 50 04             	mov    %edx,0x4(%eax)
c0108deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108dee:	8b 50 04             	mov    0x4(%eax),%edx
c0108df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108df4:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108df6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108dfa:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108e01:	7e d1                	jle    c0108dd4 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108e03:	e8 50 f8 ff ff       	call   c0108658 <alloc_proc>
c0108e08:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0108e0d:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e12:	85 c0                	test   %eax,%eax
c0108e14:	75 1c                	jne    c0108e32 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0108e16:	c7 44 24 08 0f bc 10 	movl   $0xc010bc0f,0x8(%esp)
c0108e1d:	c0 
c0108e1e:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
c0108e25:	00 
c0108e26:	c7 04 24 99 bb 10 c0 	movl   $0xc010bb99,(%esp)
c0108e2d:	e8 ab 7e ff ff       	call   c0100cdd <__panic>
    }

    idleproc->pid = 0;
c0108e32:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108e3e:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e43:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108e49:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e4e:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c0108e53:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108e56:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e5b:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108e62:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e67:	c7 44 24 04 27 bc 10 	movl   $0xc010bc27,0x4(%esp)
c0108e6e:	c0 
c0108e6f:	89 04 24             	mov    %eax,(%esp)
c0108e72:	e8 9c f8 ff ff       	call   c0108713 <set_proc_name>
    nr_process ++;
c0108e77:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108e7c:	83 c0 01             	add    $0x1,%eax
c0108e7f:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c0108e84:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e89:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108e8e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108e95:	00 
c0108e96:	c7 44 24 04 2c bc 10 	movl   $0xc010bc2c,0x4(%esp)
c0108e9d:	c0 
c0108e9e:	c7 04 24 54 8d 10 c0 	movl   $0xc0108d54,(%esp)
c0108ea5:	e8 61 fb ff ff       	call   c0108a0b <kernel_thread>
c0108eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108ead:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108eb1:	7f 1c                	jg     c0108ecf <proc_init+0x125>
        panic("create init_main failed.\n");
c0108eb3:	c7 44 24 08 3a bc 10 	movl   $0xc010bc3a,0x8(%esp)
c0108eba:	c0 
c0108ebb:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108ec2:	00 
c0108ec3:	c7 04 24 99 bb 10 c0 	movl   $0xc010bb99,(%esp)
c0108eca:	e8 0e 7e ff ff       	call   c0100cdd <__panic>
    }

    initproc = find_proc(pid);
c0108ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ed2:	89 04 24             	mov    %eax,(%esp)
c0108ed5:	e8 bf fa ff ff       	call   c0108999 <find_proc>
c0108eda:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c0108edf:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108ee4:	c7 44 24 04 54 bc 10 	movl   $0xc010bc54,0x4(%esp)
c0108eeb:	c0 
c0108eec:	89 04 24             	mov    %eax,(%esp)
c0108eef:	e8 1f f8 ff ff       	call   c0108713 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108ef4:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108ef9:	85 c0                	test   %eax,%eax
c0108efb:	74 0c                	je     c0108f09 <proc_init+0x15f>
c0108efd:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108f02:	8b 40 04             	mov    0x4(%eax),%eax
c0108f05:	85 c0                	test   %eax,%eax
c0108f07:	74 24                	je     c0108f2d <proc_init+0x183>
c0108f09:	c7 44 24 0c 5c bc 10 	movl   $0xc010bc5c,0xc(%esp)
c0108f10:	c0 
c0108f11:	c7 44 24 08 84 bb 10 	movl   $0xc010bb84,0x8(%esp)
c0108f18:	c0 
c0108f19:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
c0108f20:	00 
c0108f21:	c7 04 24 99 bb 10 c0 	movl   $0xc010bb99,(%esp)
c0108f28:	e8 b0 7d ff ff       	call   c0100cdd <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108f2d:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108f32:	85 c0                	test   %eax,%eax
c0108f34:	74 0d                	je     c0108f43 <proc_init+0x199>
c0108f36:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108f3b:	8b 40 04             	mov    0x4(%eax),%eax
c0108f3e:	83 f8 01             	cmp    $0x1,%eax
c0108f41:	74 24                	je     c0108f67 <proc_init+0x1bd>
c0108f43:	c7 44 24 0c 84 bc 10 	movl   $0xc010bc84,0xc(%esp)
c0108f4a:	c0 
c0108f4b:	c7 44 24 08 84 bb 10 	movl   $0xc010bb84,0x8(%esp)
c0108f52:	c0 
c0108f53:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c0108f5a:	00 
c0108f5b:	c7 04 24 99 bb 10 c0 	movl   $0xc010bb99,(%esp)
c0108f62:	e8 76 7d ff ff       	call   c0100cdd <__panic>
}
c0108f67:	c9                   	leave  
c0108f68:	c3                   	ret    

c0108f69 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0108f69:	55                   	push   %ebp
c0108f6a:	89 e5                	mov    %esp,%ebp
c0108f6c:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0108f6f:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108f74:	8b 40 10             	mov    0x10(%eax),%eax
c0108f77:	85 c0                	test   %eax,%eax
c0108f79:	74 07                	je     c0108f82 <cpu_idle+0x19>
            schedule();
c0108f7b:	e8 c1 00 00 00       	call   c0109041 <schedule>
        }
    }
c0108f80:	eb ed                	jmp    c0108f6f <cpu_idle+0x6>
c0108f82:	eb eb                	jmp    c0108f6f <cpu_idle+0x6>

c0108f84 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108f84:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108f88:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c0108f8a:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c0108f8d:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c0108f90:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c0108f93:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0108f96:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0108f99:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c0108f9c:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108f9f:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c0108fa3:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0108fa6:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0108fa9:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c0108fac:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c0108faf:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c0108fb2:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0108fb5:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0108fb8:	ff 30                	pushl  (%eax)

    ret
c0108fba:	c3                   	ret    

c0108fbb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108fbb:	55                   	push   %ebp
c0108fbc:	89 e5                	mov    %esp,%ebp
c0108fbe:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108fc1:	9c                   	pushf  
c0108fc2:	58                   	pop    %eax
c0108fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108fc9:	25 00 02 00 00       	and    $0x200,%eax
c0108fce:	85 c0                	test   %eax,%eax
c0108fd0:	74 0c                	je     c0108fde <__intr_save+0x23>
        intr_disable();
c0108fd2:	e8 5e 8f ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0108fd7:	b8 01 00 00 00       	mov    $0x1,%eax
c0108fdc:	eb 05                	jmp    c0108fe3 <__intr_save+0x28>
    }
    return 0;
c0108fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108fe3:	c9                   	leave  
c0108fe4:	c3                   	ret    

c0108fe5 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108fe5:	55                   	push   %ebp
c0108fe6:	89 e5                	mov    %esp,%ebp
c0108fe8:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108feb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108fef:	74 05                	je     c0108ff6 <__intr_restore+0x11>
        intr_enable();
c0108ff1:	e8 39 8f ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108ff6:	c9                   	leave  
c0108ff7:	c3                   	ret    

c0108ff8 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0108ff8:	55                   	push   %ebp
c0108ff9:	89 e5                	mov    %esp,%ebp
c0108ffb:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0108ffe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109001:	8b 00                	mov    (%eax),%eax
c0109003:	83 f8 03             	cmp    $0x3,%eax
c0109006:	74 0a                	je     c0109012 <wakeup_proc+0x1a>
c0109008:	8b 45 08             	mov    0x8(%ebp),%eax
c010900b:	8b 00                	mov    (%eax),%eax
c010900d:	83 f8 02             	cmp    $0x2,%eax
c0109010:	75 24                	jne    c0109036 <wakeup_proc+0x3e>
c0109012:	c7 44 24 0c ac bc 10 	movl   $0xc010bcac,0xc(%esp)
c0109019:	c0 
c010901a:	c7 44 24 08 e7 bc 10 	movl   $0xc010bce7,0x8(%esp)
c0109021:	c0 
c0109022:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0109029:	00 
c010902a:	c7 04 24 fc bc 10 c0 	movl   $0xc010bcfc,(%esp)
c0109031:	e8 a7 7c ff ff       	call   c0100cdd <__panic>
    proc->state = PROC_RUNNABLE;
c0109036:	8b 45 08             	mov    0x8(%ebp),%eax
c0109039:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c010903f:	c9                   	leave  
c0109040:	c3                   	ret    

c0109041 <schedule>:

void
schedule(void) {
c0109041:	55                   	push   %ebp
c0109042:	89 e5                	mov    %esp,%ebp
c0109044:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0109047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010904e:	e8 68 ff ff ff       	call   c0108fbb <__intr_save>
c0109053:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0109056:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c010905b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0109062:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0109068:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c010906d:	39 c2                	cmp    %eax,%edx
c010906f:	74 0a                	je     c010907b <schedule+0x3a>
c0109071:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109076:	83 c0 58             	add    $0x58,%eax
c0109079:	eb 05                	jmp    c0109080 <schedule+0x3f>
c010907b:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c0109080:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0109083:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109086:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109089:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010908c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010908f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109092:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109095:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109098:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c010909f:	74 15                	je     c01090b6 <schedule+0x75>
                next = le2proc(le, list_link);
c01090a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090a4:	83 e8 58             	sub    $0x58,%eax
c01090a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c01090aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090ad:	8b 00                	mov    (%eax),%eax
c01090af:	83 f8 02             	cmp    $0x2,%eax
c01090b2:	75 02                	jne    c01090b6 <schedule+0x75>
                    break;
c01090b4:	eb 08                	jmp    c01090be <schedule+0x7d>
                }
            }
        } while (le != last);
c01090b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c01090bc:	75 cb                	jne    c0109089 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c01090be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01090c2:	74 0a                	je     c01090ce <schedule+0x8d>
c01090c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090c7:	8b 00                	mov    (%eax),%eax
c01090c9:	83 f8 02             	cmp    $0x2,%eax
c01090cc:	74 08                	je     c01090d6 <schedule+0x95>
            next = idleproc;
c01090ce:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c01090d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c01090d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090d9:	8b 40 08             	mov    0x8(%eax),%eax
c01090dc:	8d 50 01             	lea    0x1(%eax),%edx
c01090df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090e2:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c01090e5:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01090ea:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01090ed:	74 0b                	je     c01090fa <schedule+0xb9>
            proc_run(next);
c01090ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090f2:	89 04 24             	mov    %eax,(%esp)
c01090f5:	e8 96 f7 ff ff       	call   c0108890 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c01090fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01090fd:	89 04 24             	mov    %eax,(%esp)
c0109100:	e8 e0 fe ff ff       	call   c0108fe5 <__intr_restore>
}
c0109105:	c9                   	leave  
c0109106:	c3                   	ret    

c0109107 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109107:	55                   	push   %ebp
c0109108:	89 e5                	mov    %esp,%ebp
c010910a:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010910d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109110:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109116:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109119:	b8 20 00 00 00       	mov    $0x20,%eax
c010911e:	2b 45 0c             	sub    0xc(%ebp),%eax
c0109121:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109124:	89 c1                	mov    %eax,%ecx
c0109126:	d3 ea                	shr    %cl,%edx
c0109128:	89 d0                	mov    %edx,%eax
}
c010912a:	c9                   	leave  
c010912b:	c3                   	ret    

c010912c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010912c:	55                   	push   %ebp
c010912d:	89 e5                	mov    %esp,%ebp
c010912f:	83 ec 58             	sub    $0x58,%esp
c0109132:	8b 45 10             	mov    0x10(%ebp),%eax
c0109135:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109138:	8b 45 14             	mov    0x14(%ebp),%eax
c010913b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010913e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109141:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109144:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109147:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010914a:	8b 45 18             	mov    0x18(%ebp),%eax
c010914d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109150:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109153:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109156:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109159:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010915c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010915f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109166:	74 1c                	je     c0109184 <printnum+0x58>
c0109168:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010916b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109170:	f7 75 e4             	divl   -0x1c(%ebp)
c0109173:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109176:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109179:	ba 00 00 00 00       	mov    $0x0,%edx
c010917e:	f7 75 e4             	divl   -0x1c(%ebp)
c0109181:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109184:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109187:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010918a:	f7 75 e4             	divl   -0x1c(%ebp)
c010918d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109190:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109193:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109196:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109199:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010919c:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010919f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01091a2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01091a5:	8b 45 18             	mov    0x18(%ebp),%eax
c01091a8:	ba 00 00 00 00       	mov    $0x0,%edx
c01091ad:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01091b0:	77 56                	ja     c0109208 <printnum+0xdc>
c01091b2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01091b5:	72 05                	jb     c01091bc <printnum+0x90>
c01091b7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01091ba:	77 4c                	ja     c0109208 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01091bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01091bf:	8d 50 ff             	lea    -0x1(%eax),%edx
c01091c2:	8b 45 20             	mov    0x20(%ebp),%eax
c01091c5:	89 44 24 18          	mov    %eax,0x18(%esp)
c01091c9:	89 54 24 14          	mov    %edx,0x14(%esp)
c01091cd:	8b 45 18             	mov    0x18(%ebp),%eax
c01091d0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01091d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01091d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01091da:	89 44 24 08          	mov    %eax,0x8(%esp)
c01091de:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01091e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ec:	89 04 24             	mov    %eax,(%esp)
c01091ef:	e8 38 ff ff ff       	call   c010912c <printnum>
c01091f4:	eb 1c                	jmp    c0109212 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01091f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091fd:	8b 45 20             	mov    0x20(%ebp),%eax
c0109200:	89 04 24             	mov    %eax,(%esp)
c0109203:	8b 45 08             	mov    0x8(%ebp),%eax
c0109206:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109208:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010920c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0109210:	7f e4                	jg     c01091f6 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109212:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109215:	05 94 bd 10 c0       	add    $0xc010bd94,%eax
c010921a:	0f b6 00             	movzbl (%eax),%eax
c010921d:	0f be c0             	movsbl %al,%eax
c0109220:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109223:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109227:	89 04 24             	mov    %eax,(%esp)
c010922a:	8b 45 08             	mov    0x8(%ebp),%eax
c010922d:	ff d0                	call   *%eax
}
c010922f:	c9                   	leave  
c0109230:	c3                   	ret    

c0109231 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0109231:	55                   	push   %ebp
c0109232:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109234:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109238:	7e 14                	jle    c010924e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010923a:	8b 45 08             	mov    0x8(%ebp),%eax
c010923d:	8b 00                	mov    (%eax),%eax
c010923f:	8d 48 08             	lea    0x8(%eax),%ecx
c0109242:	8b 55 08             	mov    0x8(%ebp),%edx
c0109245:	89 0a                	mov    %ecx,(%edx)
c0109247:	8b 50 04             	mov    0x4(%eax),%edx
c010924a:	8b 00                	mov    (%eax),%eax
c010924c:	eb 30                	jmp    c010927e <getuint+0x4d>
    }
    else if (lflag) {
c010924e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109252:	74 16                	je     c010926a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109254:	8b 45 08             	mov    0x8(%ebp),%eax
c0109257:	8b 00                	mov    (%eax),%eax
c0109259:	8d 48 04             	lea    0x4(%eax),%ecx
c010925c:	8b 55 08             	mov    0x8(%ebp),%edx
c010925f:	89 0a                	mov    %ecx,(%edx)
c0109261:	8b 00                	mov    (%eax),%eax
c0109263:	ba 00 00 00 00       	mov    $0x0,%edx
c0109268:	eb 14                	jmp    c010927e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010926a:	8b 45 08             	mov    0x8(%ebp),%eax
c010926d:	8b 00                	mov    (%eax),%eax
c010926f:	8d 48 04             	lea    0x4(%eax),%ecx
c0109272:	8b 55 08             	mov    0x8(%ebp),%edx
c0109275:	89 0a                	mov    %ecx,(%edx)
c0109277:	8b 00                	mov    (%eax),%eax
c0109279:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010927e:	5d                   	pop    %ebp
c010927f:	c3                   	ret    

c0109280 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109280:	55                   	push   %ebp
c0109281:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109283:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109287:	7e 14                	jle    c010929d <getint+0x1d>
        return va_arg(*ap, long long);
c0109289:	8b 45 08             	mov    0x8(%ebp),%eax
c010928c:	8b 00                	mov    (%eax),%eax
c010928e:	8d 48 08             	lea    0x8(%eax),%ecx
c0109291:	8b 55 08             	mov    0x8(%ebp),%edx
c0109294:	89 0a                	mov    %ecx,(%edx)
c0109296:	8b 50 04             	mov    0x4(%eax),%edx
c0109299:	8b 00                	mov    (%eax),%eax
c010929b:	eb 28                	jmp    c01092c5 <getint+0x45>
    }
    else if (lflag) {
c010929d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01092a1:	74 12                	je     c01092b5 <getint+0x35>
        return va_arg(*ap, long);
c01092a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01092a6:	8b 00                	mov    (%eax),%eax
c01092a8:	8d 48 04             	lea    0x4(%eax),%ecx
c01092ab:	8b 55 08             	mov    0x8(%ebp),%edx
c01092ae:	89 0a                	mov    %ecx,(%edx)
c01092b0:	8b 00                	mov    (%eax),%eax
c01092b2:	99                   	cltd   
c01092b3:	eb 10                	jmp    c01092c5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01092b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01092b8:	8b 00                	mov    (%eax),%eax
c01092ba:	8d 48 04             	lea    0x4(%eax),%ecx
c01092bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01092c0:	89 0a                	mov    %ecx,(%edx)
c01092c2:	8b 00                	mov    (%eax),%eax
c01092c4:	99                   	cltd   
    }
}
c01092c5:	5d                   	pop    %ebp
c01092c6:	c3                   	ret    

c01092c7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01092c7:	55                   	push   %ebp
c01092c8:	89 e5                	mov    %esp,%ebp
c01092ca:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01092cd:	8d 45 14             	lea    0x14(%ebp),%eax
c01092d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01092d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01092da:	8b 45 10             	mov    0x10(%ebp),%eax
c01092dd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01092e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01092e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01092eb:	89 04 24             	mov    %eax,(%esp)
c01092ee:	e8 02 00 00 00       	call   c01092f5 <vprintfmt>
    va_end(ap);
}
c01092f3:	c9                   	leave  
c01092f4:	c3                   	ret    

c01092f5 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01092f5:	55                   	push   %ebp
c01092f6:	89 e5                	mov    %esp,%ebp
c01092f8:	56                   	push   %esi
c01092f9:	53                   	push   %ebx
c01092fa:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01092fd:	eb 18                	jmp    c0109317 <vprintfmt+0x22>
            if (ch == '\0') {
c01092ff:	85 db                	test   %ebx,%ebx
c0109301:	75 05                	jne    c0109308 <vprintfmt+0x13>
                return;
c0109303:	e9 d1 03 00 00       	jmp    c01096d9 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0109308:	8b 45 0c             	mov    0xc(%ebp),%eax
c010930b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010930f:	89 1c 24             	mov    %ebx,(%esp)
c0109312:	8b 45 08             	mov    0x8(%ebp),%eax
c0109315:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109317:	8b 45 10             	mov    0x10(%ebp),%eax
c010931a:	8d 50 01             	lea    0x1(%eax),%edx
c010931d:	89 55 10             	mov    %edx,0x10(%ebp)
c0109320:	0f b6 00             	movzbl (%eax),%eax
c0109323:	0f b6 d8             	movzbl %al,%ebx
c0109326:	83 fb 25             	cmp    $0x25,%ebx
c0109329:	75 d4                	jne    c01092ff <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010932b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010932f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109339:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010933c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109343:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109346:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109349:	8b 45 10             	mov    0x10(%ebp),%eax
c010934c:	8d 50 01             	lea    0x1(%eax),%edx
c010934f:	89 55 10             	mov    %edx,0x10(%ebp)
c0109352:	0f b6 00             	movzbl (%eax),%eax
c0109355:	0f b6 d8             	movzbl %al,%ebx
c0109358:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010935b:	83 f8 55             	cmp    $0x55,%eax
c010935e:	0f 87 44 03 00 00    	ja     c01096a8 <vprintfmt+0x3b3>
c0109364:	8b 04 85 b8 bd 10 c0 	mov    -0x3fef4248(,%eax,4),%eax
c010936b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010936d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109371:	eb d6                	jmp    c0109349 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109373:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0109377:	eb d0                	jmp    c0109349 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109379:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109383:	89 d0                	mov    %edx,%eax
c0109385:	c1 e0 02             	shl    $0x2,%eax
c0109388:	01 d0                	add    %edx,%eax
c010938a:	01 c0                	add    %eax,%eax
c010938c:	01 d8                	add    %ebx,%eax
c010938e:	83 e8 30             	sub    $0x30,%eax
c0109391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109394:	8b 45 10             	mov    0x10(%ebp),%eax
c0109397:	0f b6 00             	movzbl (%eax),%eax
c010939a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010939d:	83 fb 2f             	cmp    $0x2f,%ebx
c01093a0:	7e 0b                	jle    c01093ad <vprintfmt+0xb8>
c01093a2:	83 fb 39             	cmp    $0x39,%ebx
c01093a5:	7f 06                	jg     c01093ad <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01093a7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01093ab:	eb d3                	jmp    c0109380 <vprintfmt+0x8b>
            goto process_precision;
c01093ad:	eb 33                	jmp    c01093e2 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01093af:	8b 45 14             	mov    0x14(%ebp),%eax
c01093b2:	8d 50 04             	lea    0x4(%eax),%edx
c01093b5:	89 55 14             	mov    %edx,0x14(%ebp)
c01093b8:	8b 00                	mov    (%eax),%eax
c01093ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01093bd:	eb 23                	jmp    c01093e2 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01093bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01093c3:	79 0c                	jns    c01093d1 <vprintfmt+0xdc>
                width = 0;
c01093c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01093cc:	e9 78 ff ff ff       	jmp    c0109349 <vprintfmt+0x54>
c01093d1:	e9 73 ff ff ff       	jmp    c0109349 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01093d6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01093dd:	e9 67 ff ff ff       	jmp    c0109349 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01093e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01093e6:	79 12                	jns    c01093fa <vprintfmt+0x105>
                width = precision, precision = -1;
c01093e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01093eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01093ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01093f5:	e9 4f ff ff ff       	jmp    c0109349 <vprintfmt+0x54>
c01093fa:	e9 4a ff ff ff       	jmp    c0109349 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01093ff:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109403:	e9 41 ff ff ff       	jmp    c0109349 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109408:	8b 45 14             	mov    0x14(%ebp),%eax
c010940b:	8d 50 04             	lea    0x4(%eax),%edx
c010940e:	89 55 14             	mov    %edx,0x14(%ebp)
c0109411:	8b 00                	mov    (%eax),%eax
c0109413:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109416:	89 54 24 04          	mov    %edx,0x4(%esp)
c010941a:	89 04 24             	mov    %eax,(%esp)
c010941d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109420:	ff d0                	call   *%eax
            break;
c0109422:	e9 ac 02 00 00       	jmp    c01096d3 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109427:	8b 45 14             	mov    0x14(%ebp),%eax
c010942a:	8d 50 04             	lea    0x4(%eax),%edx
c010942d:	89 55 14             	mov    %edx,0x14(%ebp)
c0109430:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109432:	85 db                	test   %ebx,%ebx
c0109434:	79 02                	jns    c0109438 <vprintfmt+0x143>
                err = -err;
c0109436:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109438:	83 fb 06             	cmp    $0x6,%ebx
c010943b:	7f 0b                	jg     c0109448 <vprintfmt+0x153>
c010943d:	8b 34 9d 78 bd 10 c0 	mov    -0x3fef4288(,%ebx,4),%esi
c0109444:	85 f6                	test   %esi,%esi
c0109446:	75 23                	jne    c010946b <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0109448:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010944c:	c7 44 24 08 a5 bd 10 	movl   $0xc010bda5,0x8(%esp)
c0109453:	c0 
c0109454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109457:	89 44 24 04          	mov    %eax,0x4(%esp)
c010945b:	8b 45 08             	mov    0x8(%ebp),%eax
c010945e:	89 04 24             	mov    %eax,(%esp)
c0109461:	e8 61 fe ff ff       	call   c01092c7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109466:	e9 68 02 00 00       	jmp    c01096d3 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010946b:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010946f:	c7 44 24 08 ae bd 10 	movl   $0xc010bdae,0x8(%esp)
c0109476:	c0 
c0109477:	8b 45 0c             	mov    0xc(%ebp),%eax
c010947a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010947e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109481:	89 04 24             	mov    %eax,(%esp)
c0109484:	e8 3e fe ff ff       	call   c01092c7 <printfmt>
            }
            break;
c0109489:	e9 45 02 00 00       	jmp    c01096d3 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010948e:	8b 45 14             	mov    0x14(%ebp),%eax
c0109491:	8d 50 04             	lea    0x4(%eax),%edx
c0109494:	89 55 14             	mov    %edx,0x14(%ebp)
c0109497:	8b 30                	mov    (%eax),%esi
c0109499:	85 f6                	test   %esi,%esi
c010949b:	75 05                	jne    c01094a2 <vprintfmt+0x1ad>
                p = "(null)";
c010949d:	be b1 bd 10 c0       	mov    $0xc010bdb1,%esi
            }
            if (width > 0 && padc != '-') {
c01094a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01094a6:	7e 3e                	jle    c01094e6 <vprintfmt+0x1f1>
c01094a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01094ac:	74 38                	je     c01094e6 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01094ae:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01094b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01094b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094b8:	89 34 24             	mov    %esi,(%esp)
c01094bb:	e8 ed 03 00 00       	call   c01098ad <strnlen>
c01094c0:	29 c3                	sub    %eax,%ebx
c01094c2:	89 d8                	mov    %ebx,%eax
c01094c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01094c7:	eb 17                	jmp    c01094e0 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01094c9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01094cd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01094d0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01094d4:	89 04 24             	mov    %eax,(%esp)
c01094d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01094da:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01094dc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01094e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01094e4:	7f e3                	jg     c01094c9 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01094e6:	eb 38                	jmp    c0109520 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01094e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01094ec:	74 1f                	je     c010950d <vprintfmt+0x218>
c01094ee:	83 fb 1f             	cmp    $0x1f,%ebx
c01094f1:	7e 05                	jle    c01094f8 <vprintfmt+0x203>
c01094f3:	83 fb 7e             	cmp    $0x7e,%ebx
c01094f6:	7e 15                	jle    c010950d <vprintfmt+0x218>
                    putch('?', putdat);
c01094f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094ff:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109506:	8b 45 08             	mov    0x8(%ebp),%eax
c0109509:	ff d0                	call   *%eax
c010950b:	eb 0f                	jmp    c010951c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010950d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109510:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109514:	89 1c 24             	mov    %ebx,(%esp)
c0109517:	8b 45 08             	mov    0x8(%ebp),%eax
c010951a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010951c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109520:	89 f0                	mov    %esi,%eax
c0109522:	8d 70 01             	lea    0x1(%eax),%esi
c0109525:	0f b6 00             	movzbl (%eax),%eax
c0109528:	0f be d8             	movsbl %al,%ebx
c010952b:	85 db                	test   %ebx,%ebx
c010952d:	74 10                	je     c010953f <vprintfmt+0x24a>
c010952f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109533:	78 b3                	js     c01094e8 <vprintfmt+0x1f3>
c0109535:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109539:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010953d:	79 a9                	jns    c01094e8 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010953f:	eb 17                	jmp    c0109558 <vprintfmt+0x263>
                putch(' ', putdat);
c0109541:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109544:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109548:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010954f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109552:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109554:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109558:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010955c:	7f e3                	jg     c0109541 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010955e:	e9 70 01 00 00       	jmp    c01096d3 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109563:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109566:	89 44 24 04          	mov    %eax,0x4(%esp)
c010956a:	8d 45 14             	lea    0x14(%ebp),%eax
c010956d:	89 04 24             	mov    %eax,(%esp)
c0109570:	e8 0b fd ff ff       	call   c0109280 <getint>
c0109575:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109578:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010957b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010957e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109581:	85 d2                	test   %edx,%edx
c0109583:	79 26                	jns    c01095ab <vprintfmt+0x2b6>
                putch('-', putdat);
c0109585:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109588:	89 44 24 04          	mov    %eax,0x4(%esp)
c010958c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109593:	8b 45 08             	mov    0x8(%ebp),%eax
c0109596:	ff d0                	call   *%eax
                num = -(long long)num;
c0109598:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010959b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010959e:	f7 d8                	neg    %eax
c01095a0:	83 d2 00             	adc    $0x0,%edx
c01095a3:	f7 da                	neg    %edx
c01095a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01095ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01095b2:	e9 a8 00 00 00       	jmp    c010965f <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01095b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01095ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095be:	8d 45 14             	lea    0x14(%ebp),%eax
c01095c1:	89 04 24             	mov    %eax,(%esp)
c01095c4:	e8 68 fc ff ff       	call   c0109231 <getuint>
c01095c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01095cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01095d6:	e9 84 00 00 00       	jmp    c010965f <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01095db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01095de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095e2:	8d 45 14             	lea    0x14(%ebp),%eax
c01095e5:	89 04 24             	mov    %eax,(%esp)
c01095e8:	e8 44 fc ff ff       	call   c0109231 <getuint>
c01095ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01095f3:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01095fa:	eb 63                	jmp    c010965f <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01095fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109603:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010960a:	8b 45 08             	mov    0x8(%ebp),%eax
c010960d:	ff d0                	call   *%eax
            putch('x', putdat);
c010960f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109612:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109616:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010961d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109620:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109622:	8b 45 14             	mov    0x14(%ebp),%eax
c0109625:	8d 50 04             	lea    0x4(%eax),%edx
c0109628:	89 55 14             	mov    %edx,0x14(%ebp)
c010962b:	8b 00                	mov    (%eax),%eax
c010962d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109637:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010963e:	eb 1f                	jmp    c010965f <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109640:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109647:	8d 45 14             	lea    0x14(%ebp),%eax
c010964a:	89 04 24             	mov    %eax,(%esp)
c010964d:	e8 df fb ff ff       	call   c0109231 <getuint>
c0109652:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109655:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109658:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010965f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109663:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109666:	89 54 24 18          	mov    %edx,0x18(%esp)
c010966a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010966d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109671:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109675:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109678:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010967b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010967f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109683:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109686:	89 44 24 04          	mov    %eax,0x4(%esp)
c010968a:	8b 45 08             	mov    0x8(%ebp),%eax
c010968d:	89 04 24             	mov    %eax,(%esp)
c0109690:	e8 97 fa ff ff       	call   c010912c <printnum>
            break;
c0109695:	eb 3c                	jmp    c01096d3 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109697:	8b 45 0c             	mov    0xc(%ebp),%eax
c010969a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010969e:	89 1c 24             	mov    %ebx,(%esp)
c01096a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01096a4:	ff d0                	call   *%eax
            break;
c01096a6:	eb 2b                	jmp    c01096d3 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01096a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096af:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01096b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01096b9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01096bb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01096bf:	eb 04                	jmp    c01096c5 <vprintfmt+0x3d0>
c01096c1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01096c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01096c8:	83 e8 01             	sub    $0x1,%eax
c01096cb:	0f b6 00             	movzbl (%eax),%eax
c01096ce:	3c 25                	cmp    $0x25,%al
c01096d0:	75 ef                	jne    c01096c1 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01096d2:	90                   	nop
        }
    }
c01096d3:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01096d4:	e9 3e fc ff ff       	jmp    c0109317 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01096d9:	83 c4 40             	add    $0x40,%esp
c01096dc:	5b                   	pop    %ebx
c01096dd:	5e                   	pop    %esi
c01096de:	5d                   	pop    %ebp
c01096df:	c3                   	ret    

c01096e0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01096e0:	55                   	push   %ebp
c01096e1:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01096e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096e6:	8b 40 08             	mov    0x8(%eax),%eax
c01096e9:	8d 50 01             	lea    0x1(%eax),%edx
c01096ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096ef:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01096f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096f5:	8b 10                	mov    (%eax),%edx
c01096f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096fa:	8b 40 04             	mov    0x4(%eax),%eax
c01096fd:	39 c2                	cmp    %eax,%edx
c01096ff:	73 12                	jae    c0109713 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109701:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109704:	8b 00                	mov    (%eax),%eax
c0109706:	8d 48 01             	lea    0x1(%eax),%ecx
c0109709:	8b 55 0c             	mov    0xc(%ebp),%edx
c010970c:	89 0a                	mov    %ecx,(%edx)
c010970e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109711:	88 10                	mov    %dl,(%eax)
    }
}
c0109713:	5d                   	pop    %ebp
c0109714:	c3                   	ret    

c0109715 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109715:	55                   	push   %ebp
c0109716:	89 e5                	mov    %esp,%ebp
c0109718:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010971b:	8d 45 14             	lea    0x14(%ebp),%eax
c010971e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109721:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109724:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109728:	8b 45 10             	mov    0x10(%ebp),%eax
c010972b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010972f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109732:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109736:	8b 45 08             	mov    0x8(%ebp),%eax
c0109739:	89 04 24             	mov    %eax,(%esp)
c010973c:	e8 08 00 00 00       	call   c0109749 <vsnprintf>
c0109741:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109744:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109747:	c9                   	leave  
c0109748:	c3                   	ret    

c0109749 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109749:	55                   	push   %ebp
c010974a:	89 e5                	mov    %esp,%ebp
c010974c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010974f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109752:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109758:	8d 50 ff             	lea    -0x1(%eax),%edx
c010975b:	8b 45 08             	mov    0x8(%ebp),%eax
c010975e:	01 d0                	add    %edx,%eax
c0109760:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109763:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010976a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010976e:	74 0a                	je     c010977a <vsnprintf+0x31>
c0109770:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109773:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109776:	39 c2                	cmp    %eax,%edx
c0109778:	76 07                	jbe    c0109781 <vsnprintf+0x38>
        return -E_INVAL;
c010977a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010977f:	eb 2a                	jmp    c01097ab <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109781:	8b 45 14             	mov    0x14(%ebp),%eax
c0109784:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109788:	8b 45 10             	mov    0x10(%ebp),%eax
c010978b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010978f:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109792:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109796:	c7 04 24 e0 96 10 c0 	movl   $0xc01096e0,(%esp)
c010979d:	e8 53 fb ff ff       	call   c01092f5 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01097a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097a5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01097a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01097ab:	c9                   	leave  
c01097ac:	c3                   	ret    

c01097ad <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01097ad:	55                   	push   %ebp
c01097ae:	89 e5                	mov    %esp,%ebp
c01097b0:	57                   	push   %edi
c01097b1:	56                   	push   %esi
c01097b2:	53                   	push   %ebx
c01097b3:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01097b6:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c01097bb:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c01097c1:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c01097c7:	6b f0 05             	imul   $0x5,%eax,%esi
c01097ca:	01 f7                	add    %esi,%edi
c01097cc:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c01097d1:	f7 e6                	mul    %esi
c01097d3:	8d 34 17             	lea    (%edi,%edx,1),%esi
c01097d6:	89 f2                	mov    %esi,%edx
c01097d8:	83 c0 0b             	add    $0xb,%eax
c01097db:	83 d2 00             	adc    $0x0,%edx
c01097de:	89 c7                	mov    %eax,%edi
c01097e0:	83 e7 ff             	and    $0xffffffff,%edi
c01097e3:	89 f9                	mov    %edi,%ecx
c01097e5:	0f b7 da             	movzwl %dx,%ebx
c01097e8:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c01097ee:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c01097f4:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c01097f9:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c01097ff:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109803:	c1 ea 0c             	shr    $0xc,%edx
c0109806:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109809:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010980c:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109813:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109816:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109819:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010981c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010981f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109822:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109825:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109829:	74 1c                	je     c0109847 <rand+0x9a>
c010982b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010982e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109833:	f7 75 dc             	divl   -0x24(%ebp)
c0109836:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109839:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010983c:	ba 00 00 00 00       	mov    $0x0,%edx
c0109841:	f7 75 dc             	divl   -0x24(%ebp)
c0109844:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109847:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010984a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010984d:	f7 75 dc             	divl   -0x24(%ebp)
c0109850:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109853:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109856:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109859:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010985c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010985f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109862:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109865:	83 c4 24             	add    $0x24,%esp
c0109868:	5b                   	pop    %ebx
c0109869:	5e                   	pop    %esi
c010986a:	5f                   	pop    %edi
c010986b:	5d                   	pop    %ebp
c010986c:	c3                   	ret    

c010986d <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010986d:	55                   	push   %ebp
c010986e:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109870:	8b 45 08             	mov    0x8(%ebp),%eax
c0109873:	ba 00 00 00 00       	mov    $0x0,%edx
c0109878:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c010987d:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c0109883:	5d                   	pop    %ebp
c0109884:	c3                   	ret    

c0109885 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109885:	55                   	push   %ebp
c0109886:	89 e5                	mov    %esp,%ebp
c0109888:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010988b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109892:	eb 04                	jmp    c0109898 <strlen+0x13>
        cnt ++;
c0109894:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109898:	8b 45 08             	mov    0x8(%ebp),%eax
c010989b:	8d 50 01             	lea    0x1(%eax),%edx
c010989e:	89 55 08             	mov    %edx,0x8(%ebp)
c01098a1:	0f b6 00             	movzbl (%eax),%eax
c01098a4:	84 c0                	test   %al,%al
c01098a6:	75 ec                	jne    c0109894 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01098a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01098ab:	c9                   	leave  
c01098ac:	c3                   	ret    

c01098ad <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01098ad:	55                   	push   %ebp
c01098ae:	89 e5                	mov    %esp,%ebp
c01098b0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01098b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01098ba:	eb 04                	jmp    c01098c0 <strnlen+0x13>
        cnt ++;
c01098bc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01098c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01098c6:	73 10                	jae    c01098d8 <strnlen+0x2b>
c01098c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01098cb:	8d 50 01             	lea    0x1(%eax),%edx
c01098ce:	89 55 08             	mov    %edx,0x8(%ebp)
c01098d1:	0f b6 00             	movzbl (%eax),%eax
c01098d4:	84 c0                	test   %al,%al
c01098d6:	75 e4                	jne    c01098bc <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01098d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01098db:	c9                   	leave  
c01098dc:	c3                   	ret    

c01098dd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01098dd:	55                   	push   %ebp
c01098de:	89 e5                	mov    %esp,%ebp
c01098e0:	57                   	push   %edi
c01098e1:	56                   	push   %esi
c01098e2:	83 ec 20             	sub    $0x20,%esp
c01098e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01098e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01098eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01098f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01098f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098f7:	89 d1                	mov    %edx,%ecx
c01098f9:	89 c2                	mov    %eax,%edx
c01098fb:	89 ce                	mov    %ecx,%esi
c01098fd:	89 d7                	mov    %edx,%edi
c01098ff:	ac                   	lods   %ds:(%esi),%al
c0109900:	aa                   	stos   %al,%es:(%edi)
c0109901:	84 c0                	test   %al,%al
c0109903:	75 fa                	jne    c01098ff <strcpy+0x22>
c0109905:	89 fa                	mov    %edi,%edx
c0109907:	89 f1                	mov    %esi,%ecx
c0109909:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010990c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010990f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109912:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109915:	83 c4 20             	add    $0x20,%esp
c0109918:	5e                   	pop    %esi
c0109919:	5f                   	pop    %edi
c010991a:	5d                   	pop    %ebp
c010991b:	c3                   	ret    

c010991c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010991c:	55                   	push   %ebp
c010991d:	89 e5                	mov    %esp,%ebp
c010991f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109922:	8b 45 08             	mov    0x8(%ebp),%eax
c0109925:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109928:	eb 21                	jmp    c010994b <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010992a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010992d:	0f b6 10             	movzbl (%eax),%edx
c0109930:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109933:	88 10                	mov    %dl,(%eax)
c0109935:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109938:	0f b6 00             	movzbl (%eax),%eax
c010993b:	84 c0                	test   %al,%al
c010993d:	74 04                	je     c0109943 <strncpy+0x27>
            src ++;
c010993f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109943:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109947:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010994b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010994f:	75 d9                	jne    c010992a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109951:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109954:	c9                   	leave  
c0109955:	c3                   	ret    

c0109956 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109956:	55                   	push   %ebp
c0109957:	89 e5                	mov    %esp,%ebp
c0109959:	57                   	push   %edi
c010995a:	56                   	push   %esi
c010995b:	83 ec 20             	sub    $0x20,%esp
c010995e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109961:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109964:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109967:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010996a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010996d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109970:	89 d1                	mov    %edx,%ecx
c0109972:	89 c2                	mov    %eax,%edx
c0109974:	89 ce                	mov    %ecx,%esi
c0109976:	89 d7                	mov    %edx,%edi
c0109978:	ac                   	lods   %ds:(%esi),%al
c0109979:	ae                   	scas   %es:(%edi),%al
c010997a:	75 08                	jne    c0109984 <strcmp+0x2e>
c010997c:	84 c0                	test   %al,%al
c010997e:	75 f8                	jne    c0109978 <strcmp+0x22>
c0109980:	31 c0                	xor    %eax,%eax
c0109982:	eb 04                	jmp    c0109988 <strcmp+0x32>
c0109984:	19 c0                	sbb    %eax,%eax
c0109986:	0c 01                	or     $0x1,%al
c0109988:	89 fa                	mov    %edi,%edx
c010998a:	89 f1                	mov    %esi,%ecx
c010998c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010998f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109992:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109995:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109998:	83 c4 20             	add    $0x20,%esp
c010999b:	5e                   	pop    %esi
c010999c:	5f                   	pop    %edi
c010999d:	5d                   	pop    %ebp
c010999e:	c3                   	ret    

c010999f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010999f:	55                   	push   %ebp
c01099a0:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01099a2:	eb 0c                	jmp    c01099b0 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01099a4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01099a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01099ac:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01099b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01099b4:	74 1a                	je     c01099d0 <strncmp+0x31>
c01099b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b9:	0f b6 00             	movzbl (%eax),%eax
c01099bc:	84 c0                	test   %al,%al
c01099be:	74 10                	je     c01099d0 <strncmp+0x31>
c01099c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c3:	0f b6 10             	movzbl (%eax),%edx
c01099c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099c9:	0f b6 00             	movzbl (%eax),%eax
c01099cc:	38 c2                	cmp    %al,%dl
c01099ce:	74 d4                	je     c01099a4 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01099d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01099d4:	74 18                	je     c01099ee <strncmp+0x4f>
c01099d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01099d9:	0f b6 00             	movzbl (%eax),%eax
c01099dc:	0f b6 d0             	movzbl %al,%edx
c01099df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099e2:	0f b6 00             	movzbl (%eax),%eax
c01099e5:	0f b6 c0             	movzbl %al,%eax
c01099e8:	29 c2                	sub    %eax,%edx
c01099ea:	89 d0                	mov    %edx,%eax
c01099ec:	eb 05                	jmp    c01099f3 <strncmp+0x54>
c01099ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01099f3:	5d                   	pop    %ebp
c01099f4:	c3                   	ret    

c01099f5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01099f5:	55                   	push   %ebp
c01099f6:	89 e5                	mov    %esp,%ebp
c01099f8:	83 ec 04             	sub    $0x4,%esp
c01099fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099fe:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109a01:	eb 14                	jmp    c0109a17 <strchr+0x22>
        if (*s == c) {
c0109a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a06:	0f b6 00             	movzbl (%eax),%eax
c0109a09:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109a0c:	75 05                	jne    c0109a13 <strchr+0x1e>
            return (char *)s;
c0109a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a11:	eb 13                	jmp    c0109a26 <strchr+0x31>
        }
        s ++;
c0109a13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a1a:	0f b6 00             	movzbl (%eax),%eax
c0109a1d:	84 c0                	test   %al,%al
c0109a1f:	75 e2                	jne    c0109a03 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0109a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109a26:	c9                   	leave  
c0109a27:	c3                   	ret    

c0109a28 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109a28:	55                   	push   %ebp
c0109a29:	89 e5                	mov    %esp,%ebp
c0109a2b:	83 ec 04             	sub    $0x4,%esp
c0109a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a31:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109a34:	eb 11                	jmp    c0109a47 <strfind+0x1f>
        if (*s == c) {
c0109a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a39:	0f b6 00             	movzbl (%eax),%eax
c0109a3c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109a3f:	75 02                	jne    c0109a43 <strfind+0x1b>
            break;
c0109a41:	eb 0e                	jmp    c0109a51 <strfind+0x29>
        }
        s ++;
c0109a43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a4a:	0f b6 00             	movzbl (%eax),%eax
c0109a4d:	84 c0                	test   %al,%al
c0109a4f:	75 e5                	jne    c0109a36 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0109a51:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109a54:	c9                   	leave  
c0109a55:	c3                   	ret    

c0109a56 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109a56:	55                   	push   %ebp
c0109a57:	89 e5                	mov    %esp,%ebp
c0109a59:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109a5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109a63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109a6a:	eb 04                	jmp    c0109a70 <strtol+0x1a>
        s ++;
c0109a6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109a70:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a73:	0f b6 00             	movzbl (%eax),%eax
c0109a76:	3c 20                	cmp    $0x20,%al
c0109a78:	74 f2                	je     c0109a6c <strtol+0x16>
c0109a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a7d:	0f b6 00             	movzbl (%eax),%eax
c0109a80:	3c 09                	cmp    $0x9,%al
c0109a82:	74 e8                	je     c0109a6c <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a87:	0f b6 00             	movzbl (%eax),%eax
c0109a8a:	3c 2b                	cmp    $0x2b,%al
c0109a8c:	75 06                	jne    c0109a94 <strtol+0x3e>
        s ++;
c0109a8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a92:	eb 15                	jmp    c0109aa9 <strtol+0x53>
    }
    else if (*s == '-') {
c0109a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a97:	0f b6 00             	movzbl (%eax),%eax
c0109a9a:	3c 2d                	cmp    $0x2d,%al
c0109a9c:	75 0b                	jne    c0109aa9 <strtol+0x53>
        s ++, neg = 1;
c0109a9e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109aa2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109aa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109aad:	74 06                	je     c0109ab5 <strtol+0x5f>
c0109aaf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109ab3:	75 24                	jne    c0109ad9 <strtol+0x83>
c0109ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ab8:	0f b6 00             	movzbl (%eax),%eax
c0109abb:	3c 30                	cmp    $0x30,%al
c0109abd:	75 1a                	jne    c0109ad9 <strtol+0x83>
c0109abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ac2:	83 c0 01             	add    $0x1,%eax
c0109ac5:	0f b6 00             	movzbl (%eax),%eax
c0109ac8:	3c 78                	cmp    $0x78,%al
c0109aca:	75 0d                	jne    c0109ad9 <strtol+0x83>
        s += 2, base = 16;
c0109acc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109ad0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109ad7:	eb 2a                	jmp    c0109b03 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109ad9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109add:	75 17                	jne    c0109af6 <strtol+0xa0>
c0109adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae2:	0f b6 00             	movzbl (%eax),%eax
c0109ae5:	3c 30                	cmp    $0x30,%al
c0109ae7:	75 0d                	jne    c0109af6 <strtol+0xa0>
        s ++, base = 8;
c0109ae9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109aed:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109af4:	eb 0d                	jmp    c0109b03 <strtol+0xad>
    }
    else if (base == 0) {
c0109af6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109afa:	75 07                	jne    c0109b03 <strtol+0xad>
        base = 10;
c0109afc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b06:	0f b6 00             	movzbl (%eax),%eax
c0109b09:	3c 2f                	cmp    $0x2f,%al
c0109b0b:	7e 1b                	jle    c0109b28 <strtol+0xd2>
c0109b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b10:	0f b6 00             	movzbl (%eax),%eax
c0109b13:	3c 39                	cmp    $0x39,%al
c0109b15:	7f 11                	jg     c0109b28 <strtol+0xd2>
            dig = *s - '0';
c0109b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b1a:	0f b6 00             	movzbl (%eax),%eax
c0109b1d:	0f be c0             	movsbl %al,%eax
c0109b20:	83 e8 30             	sub    $0x30,%eax
c0109b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b26:	eb 48                	jmp    c0109b70 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b2b:	0f b6 00             	movzbl (%eax),%eax
c0109b2e:	3c 60                	cmp    $0x60,%al
c0109b30:	7e 1b                	jle    c0109b4d <strtol+0xf7>
c0109b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b35:	0f b6 00             	movzbl (%eax),%eax
c0109b38:	3c 7a                	cmp    $0x7a,%al
c0109b3a:	7f 11                	jg     c0109b4d <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b3f:	0f b6 00             	movzbl (%eax),%eax
c0109b42:	0f be c0             	movsbl %al,%eax
c0109b45:	83 e8 57             	sub    $0x57,%eax
c0109b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b4b:	eb 23                	jmp    c0109b70 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b50:	0f b6 00             	movzbl (%eax),%eax
c0109b53:	3c 40                	cmp    $0x40,%al
c0109b55:	7e 3d                	jle    c0109b94 <strtol+0x13e>
c0109b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b5a:	0f b6 00             	movzbl (%eax),%eax
c0109b5d:	3c 5a                	cmp    $0x5a,%al
c0109b5f:	7f 33                	jg     c0109b94 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b64:	0f b6 00             	movzbl (%eax),%eax
c0109b67:	0f be c0             	movsbl %al,%eax
c0109b6a:	83 e8 37             	sub    $0x37,%eax
c0109b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b73:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109b76:	7c 02                	jl     c0109b7a <strtol+0x124>
            break;
c0109b78:	eb 1a                	jmp    c0109b94 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109b7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109b7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109b81:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109b85:	89 c2                	mov    %eax,%edx
c0109b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b8a:	01 d0                	add    %edx,%eax
c0109b8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109b8f:	e9 6f ff ff ff       	jmp    c0109b03 <strtol+0xad>

    if (endptr) {
c0109b94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109b98:	74 08                	je     c0109ba2 <strtol+0x14c>
        *endptr = (char *) s;
c0109b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b9d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ba0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109ba2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109ba6:	74 07                	je     c0109baf <strtol+0x159>
c0109ba8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109bab:	f7 d8                	neg    %eax
c0109bad:	eb 03                	jmp    c0109bb2 <strtol+0x15c>
c0109baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109bb2:	c9                   	leave  
c0109bb3:	c3                   	ret    

c0109bb4 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109bb4:	55                   	push   %ebp
c0109bb5:	89 e5                	mov    %esp,%ebp
c0109bb7:	57                   	push   %edi
c0109bb8:	83 ec 24             	sub    $0x24,%esp
c0109bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bbe:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109bc1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109bc5:	8b 55 08             	mov    0x8(%ebp),%edx
c0109bc8:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109bcb:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109bce:	8b 45 10             	mov    0x10(%ebp),%eax
c0109bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109bd4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109bd7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109bdb:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109bde:	89 d7                	mov    %edx,%edi
c0109be0:	f3 aa                	rep stos %al,%es:(%edi)
c0109be2:	89 fa                	mov    %edi,%edx
c0109be4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109be7:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109bed:	83 c4 24             	add    $0x24,%esp
c0109bf0:	5f                   	pop    %edi
c0109bf1:	5d                   	pop    %ebp
c0109bf2:	c3                   	ret    

c0109bf3 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109bf3:	55                   	push   %ebp
c0109bf4:	89 e5                	mov    %esp,%ebp
c0109bf6:	57                   	push   %edi
c0109bf7:	56                   	push   %esi
c0109bf8:	53                   	push   %ebx
c0109bf9:	83 ec 30             	sub    $0x30,%esp
c0109bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c05:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109c08:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c0b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c11:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109c14:	73 42                	jae    c0109c58 <memmove+0x65>
c0109c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c25:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109c28:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109c2b:	c1 e8 02             	shr    $0x2,%eax
c0109c2e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109c33:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109c36:	89 d7                	mov    %edx,%edi
c0109c38:	89 c6                	mov    %eax,%esi
c0109c3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c3c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109c3f:	83 e1 03             	and    $0x3,%ecx
c0109c42:	74 02                	je     c0109c46 <memmove+0x53>
c0109c44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c46:	89 f0                	mov    %esi,%eax
c0109c48:	89 fa                	mov    %edi,%edx
c0109c4a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109c4d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109c50:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109c56:	eb 36                	jmp    c0109c8e <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c5b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c61:	01 c2                	add    %eax,%edx
c0109c63:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c66:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c6c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109c72:	89 c1                	mov    %eax,%ecx
c0109c74:	89 d8                	mov    %ebx,%eax
c0109c76:	89 d6                	mov    %edx,%esi
c0109c78:	89 c7                	mov    %eax,%edi
c0109c7a:	fd                   	std    
c0109c7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c7d:	fc                   	cld    
c0109c7e:	89 f8                	mov    %edi,%eax
c0109c80:	89 f2                	mov    %esi,%edx
c0109c82:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109c85:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109c88:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109c8e:	83 c4 30             	add    $0x30,%esp
c0109c91:	5b                   	pop    %ebx
c0109c92:	5e                   	pop    %esi
c0109c93:	5f                   	pop    %edi
c0109c94:	5d                   	pop    %ebp
c0109c95:	c3                   	ret    

c0109c96 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109c96:	55                   	push   %ebp
c0109c97:	89 e5                	mov    %esp,%ebp
c0109c99:	57                   	push   %edi
c0109c9a:	56                   	push   %esi
c0109c9b:	83 ec 20             	sub    $0x20,%esp
c0109c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109caa:	8b 45 10             	mov    0x10(%ebp),%eax
c0109cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109cb3:	c1 e8 02             	shr    $0x2,%eax
c0109cb6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cbe:	89 d7                	mov    %edx,%edi
c0109cc0:	89 c6                	mov    %eax,%esi
c0109cc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109cc4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109cc7:	83 e1 03             	and    $0x3,%ecx
c0109cca:	74 02                	je     c0109cce <memcpy+0x38>
c0109ccc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109cce:	89 f0                	mov    %esi,%eax
c0109cd0:	89 fa                	mov    %edi,%edx
c0109cd2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109cd5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109cde:	83 c4 20             	add    $0x20,%esp
c0109ce1:	5e                   	pop    %esi
c0109ce2:	5f                   	pop    %edi
c0109ce3:	5d                   	pop    %ebp
c0109ce4:	c3                   	ret    

c0109ce5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109ce5:	55                   	push   %ebp
c0109ce6:	89 e5                	mov    %esp,%ebp
c0109ce8:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109cf4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109cf7:	eb 30                	jmp    c0109d29 <memcmp+0x44>
        if (*s1 != *s2) {
c0109cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109cfc:	0f b6 10             	movzbl (%eax),%edx
c0109cff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109d02:	0f b6 00             	movzbl (%eax),%eax
c0109d05:	38 c2                	cmp    %al,%dl
c0109d07:	74 18                	je     c0109d21 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109d0c:	0f b6 00             	movzbl (%eax),%eax
c0109d0f:	0f b6 d0             	movzbl %al,%edx
c0109d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109d15:	0f b6 00             	movzbl (%eax),%eax
c0109d18:	0f b6 c0             	movzbl %al,%eax
c0109d1b:	29 c2                	sub    %eax,%edx
c0109d1d:	89 d0                	mov    %edx,%eax
c0109d1f:	eb 1a                	jmp    c0109d3b <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109d21:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109d25:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109d29:	8b 45 10             	mov    0x10(%ebp),%eax
c0109d2c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109d2f:	89 55 10             	mov    %edx,0x10(%ebp)
c0109d32:	85 c0                	test   %eax,%eax
c0109d34:	75 c3                	jne    c0109cf9 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109d3b:	c9                   	leave  
c0109d3c:	c3                   	ret    
