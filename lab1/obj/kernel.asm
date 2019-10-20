
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 14 34 00 00       	call   103440 <memset>

    cons_init();                // init the console
  10002c:	e8 56 15 00 00       	call   101587 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 35 10 00 	movl   $0x1035e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 35 10 00 	movl   $0x1035fc,(%esp)
  100046:	e8 d7 02 00 00       	call   100322 <cprintf>

    print_kerninfo();
  10004b:	e8 06 08 00 00       	call   100856 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 2c 2a 00 00       	call   102a86 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6b 16 00 00       	call   1016ca <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 bd 17 00 00       	call   101821 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 11 0d 00 00       	call   100d7a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 ca 15 00 00       	call   101638 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6d 01 00 00       	call   1001e0 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 04 0c 00 00       	call   100c9b <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 01 36 10 00 	movl   $0x103601,(%esp)
  100137:	e8 e6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
  100157:	e8 c6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 1d 36 10 00 	movl   $0x10361d,(%esp)
  100177:	e8 a6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 2b 36 10 00 	movl   $0x10362b,(%esp)
  100197:	e8 86 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 39 36 10 00 	movl   $0x103639,(%esp)
  1001b7:	e8 66 01 00 00       	call   100322 <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
  1001ce:	83 ec 08             	sub    $0x8,%esp
  1001d1:	cd 78                	int    $0x78
  1001d3:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"
		:
		:"i"(T_SWITCH_TOU)
	);
}
  1001d5:	5d                   	pop    %ebp
  1001d6:	c3                   	ret    

001001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d7:	55                   	push   %ebp
  1001d8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile(
  1001da:	cd 79                	int    $0x79
  1001dc:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"
		:
		:"i"(T_SWITCH_TOK)
	);
}
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e0:	55                   	push   %ebp
  1001e1:	89 e5                	mov    %esp,%ebp
  1001e3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e6:	e8 1a ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001eb:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1001f2:	e8 2b 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_user();
  1001f7:	e8 cf ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 04 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  100208:	e8 15 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_kernel();
  10020d:	e8 c5 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 ee fe ff ff       	call   100105 <lab1_print_cur_status>
}
  100217:	c9                   	leave  
  100218:	c3                   	ret    

00100219 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100219:	55                   	push   %ebp
  10021a:	89 e5                	mov    %esp,%ebp
  10021c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10021f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100223:	74 13                	je     100238 <readline+0x1f>
        cprintf("%s", prompt);
  100225:	8b 45 08             	mov    0x8(%ebp),%eax
  100228:	89 44 24 04          	mov    %eax,0x4(%esp)
  10022c:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  100233:	e8 ea 00 00 00       	call   100322 <cprintf>
    }
    int i = 0, c;
  100238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10023f:	e8 66 01 00 00       	call   1003aa <getchar>
  100244:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10024b:	79 07                	jns    100254 <readline+0x3b>
            return NULL;
  10024d:	b8 00 00 00 00       	mov    $0x0,%eax
  100252:	eb 79                	jmp    1002cd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100254:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100258:	7e 28                	jle    100282 <readline+0x69>
  10025a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100261:	7f 1f                	jg     100282 <readline+0x69>
            cputchar(c);
  100263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100266:	89 04 24             	mov    %eax,(%esp)
  100269:	e8 da 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100271:	8d 50 01             	lea    0x1(%eax),%edx
  100274:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10027a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100280:	eb 46                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100282:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100286:	75 17                	jne    10029f <readline+0x86>
  100288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10028c:	7e 11                	jle    10029f <readline+0x86>
            cputchar(c);
  10028e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100291:	89 04 24             	mov    %eax,(%esp)
  100294:	e8 af 00 00 00       	call   100348 <cputchar>
            i --;
  100299:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10029d:	eb 29                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10029f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002a3:	74 06                	je     1002ab <readline+0x92>
  1002a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a9:	75 1d                	jne    1002c8 <readline+0xaf>
            cputchar(c);
  1002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 92 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002be:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002c6:	eb 05                	jmp    1002cd <readline+0xb4>
        }
    }
  1002c8:	e9 72 ff ff ff       	jmp    10023f <readline+0x26>
}
  1002cd:	c9                   	leave  
  1002ce:	c3                   	ret    

001002cf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002cf:	55                   	push   %ebp
  1002d0:	89 e5                	mov    %esp,%ebp
  1002d2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d8:	89 04 24             	mov    %eax,(%esp)
  1002db:	e8 d3 12 00 00       	call   1015b3 <cons_putc>
    (*cnt) ++;
  1002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e3:	8b 00                	mov    (%eax),%eax
  1002e5:	8d 50 01             	lea    0x1(%eax),%edx
  1002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002eb:	89 10                	mov    %edx,(%eax)
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002ef:	55                   	push   %ebp
  1002f0:	89 e5                	mov    %esp,%ebp
  1002f2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100303:	8b 45 08             	mov    0x8(%ebp),%eax
  100306:	89 44 24 08          	mov    %eax,0x8(%esp)
  10030a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100311:	c7 04 24 cf 02 10 00 	movl   $0x1002cf,(%esp)
  100318:	e8 3c 29 00 00       	call   102c59 <vprintfmt>
    return cnt;
  10031d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100320:	c9                   	leave  
  100321:	c3                   	ret    

00100322 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100322:	55                   	push   %ebp
  100323:	89 e5                	mov    %esp,%ebp
  100325:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100328:	8d 45 0c             	lea    0xc(%ebp),%eax
  10032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100331:	89 44 24 04          	mov    %eax,0x4(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 04 24             	mov    %eax,(%esp)
  10033b:	e8 af ff ff ff       	call   1002ef <vcprintf>
  100340:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 5a 12 00 00       	call   1015b3 <cons_putc>
}
  100359:	c9                   	leave  
  10035a:	c3                   	ret    

0010035b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035b:	55                   	push   %ebp
  10035c:	89 e5                	mov    %esp,%ebp
  10035e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100368:	eb 13                	jmp    10037d <cputs+0x22>
        cputch(c, &cnt);
  10036a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10036e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100371:	89 54 24 04          	mov    %edx,0x4(%esp)
  100375:	89 04 24             	mov    %eax,(%esp)
  100378:	e8 52 ff ff ff       	call   1002cf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	8d 50 01             	lea    0x1(%eax),%edx
  100383:	89 55 08             	mov    %edx,0x8(%ebp)
  100386:	0f b6 00             	movzbl (%eax),%eax
  100389:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100390:	75 d8                	jne    10036a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100392:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100395:	89 44 24 04          	mov    %eax,0x4(%esp)
  100399:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a0:	e8 2a ff ff ff       	call   1002cf <cputch>
    return cnt;
  1003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a8:	c9                   	leave  
  1003a9:	c3                   	ret    

001003aa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003aa:	55                   	push   %ebp
  1003ab:	89 e5                	mov    %esp,%ebp
  1003ad:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b0:	e8 27 12 00 00       	call   1015dc <cons_getc>
  1003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003bc:	74 f2                	je     1003b0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003cc:	8b 00                	mov    (%eax),%eax
  1003ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e0:	e9 d2 00 00 00       	jmp    1004b7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003eb:	01 d0                	add    %edx,%eax
  1003ed:	89 c2                	mov    %eax,%edx
  1003ef:	c1 ea 1f             	shr    $0x1f,%edx
  1003f2:	01 d0                	add    %edx,%eax
  1003f4:	d1 f8                	sar    %eax
  1003f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ff:	eb 04                	jmp    100405 <stab_binsearch+0x42>
            m --;
  100401:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100408:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10040b:	7c 1f                	jl     10042c <stab_binsearch+0x69>
  10040d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100410:	89 d0                	mov    %edx,%eax
  100412:	01 c0                	add    %eax,%eax
  100414:	01 d0                	add    %edx,%eax
  100416:	c1 e0 02             	shl    $0x2,%eax
  100419:	89 c2                	mov    %eax,%edx
  10041b:	8b 45 08             	mov    0x8(%ebp),%eax
  10041e:	01 d0                	add    %edx,%eax
  100420:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100424:	0f b6 c0             	movzbl %al,%eax
  100427:	3b 45 14             	cmp    0x14(%ebp),%eax
  10042a:	75 d5                	jne    100401 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100432:	7d 0b                	jge    10043f <stab_binsearch+0x7c>
            l = true_m + 1;
  100434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100437:	83 c0 01             	add    $0x1,%eax
  10043a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10043d:	eb 78                	jmp    1004b7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10043f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100449:	89 d0                	mov    %edx,%eax
  10044b:	01 c0                	add    %eax,%eax
  10044d:	01 d0                	add    %edx,%eax
  10044f:	c1 e0 02             	shl    $0x2,%eax
  100452:	89 c2                	mov    %eax,%edx
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	01 d0                	add    %edx,%eax
  100459:	8b 40 08             	mov    0x8(%eax),%eax
  10045c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10045f:	73 13                	jae    100474 <stab_binsearch+0xb1>
            *region_left = m;
  100461:	8b 45 0c             	mov    0xc(%ebp),%eax
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10046c:	83 c0 01             	add    $0x1,%eax
  10046f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100472:	eb 43                	jmp    1004b7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100477:	89 d0                	mov    %edx,%eax
  100479:	01 c0                	add    %eax,%eax
  10047b:	01 d0                	add    %edx,%eax
  10047d:	c1 e0 02             	shl    $0x2,%eax
  100480:	89 c2                	mov    %eax,%edx
  100482:	8b 45 08             	mov    0x8(%ebp),%eax
  100485:	01 d0                	add    %edx,%eax
  100487:	8b 40 08             	mov    0x8(%eax),%eax
  10048a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10048d:	76 16                	jbe    1004a5 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	8d 50 ff             	lea    -0x1(%eax),%edx
  100495:	8b 45 10             	mov    0x10(%ebp),%eax
  100498:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049d:	83 e8 01             	sub    $0x1,%eax
  1004a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a3:	eb 12                	jmp    1004b7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ab:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 22 ff ff ff    	jle    1003e5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
  1004d6:	eb 3f                	jmp    100517 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 04                	jmp    1004e6 <stab_binsearch+0x123>
  1004e2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e9:	8b 00                	mov    (%eax),%eax
  1004eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ee:	7d 1f                	jge    10050f <stab_binsearch+0x14c>
  1004f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f3:	89 d0                	mov    %edx,%eax
  1004f5:	01 c0                	add    %eax,%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	c1 e0 02             	shl    $0x2,%eax
  1004fc:	89 c2                	mov    %eax,%edx
  1004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100501:	01 d0                	add    %edx,%eax
  100503:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100507:	0f b6 c0             	movzbl %al,%eax
  10050a:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050d:	75 d3                	jne    1004e2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100515:	89 10                	mov    %edx,(%eax)
    }
}
  100517:	c9                   	leave  
  100518:	c3                   	ret    

00100519 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100519:	55                   	push   %ebp
  10051a:	89 e5                	mov    %esp,%ebp
  10051c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100522:	c7 00 8c 36 10 00    	movl   $0x10368c,(%eax)
    info->eip_line = 0;
  100528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100532:	8b 45 0c             	mov    0xc(%ebp),%eax
  100535:	c7 40 08 8c 36 10 00 	movl   $0x10368c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100546:	8b 45 0c             	mov    0xc(%ebp),%eax
  100549:	8b 55 08             	mov    0x8(%ebp),%edx
  10054c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100559:	c7 45 f4 ec 3e 10 00 	movl   $0x103eec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100560:	c7 45 f0 40 b7 10 00 	movl   $0x10b740,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100567:	c7 45 ec 41 b7 10 00 	movl   $0x10b741,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10056e:	c7 45 e8 19 d7 10 00 	movl   $0x10d719,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100578:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057b:	76 0d                	jbe    10058a <debuginfo_eip+0x71>
  10057d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100580:	83 e8 01             	sub    $0x1,%eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x7b>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 c0 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10059e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a1:	29 c2                	sub    %eax,%edx
  1005a3:	89 d0                	mov    %edx,%eax
  1005a5:	c1 f8 02             	sar    $0x2,%eax
  1005a8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ae:	83 e8 01             	sub    $0x1,%eax
  1005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005c2:	00 
  1005c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005d4:	89 04 24             	mov    %eax,(%esp)
  1005d7:	e8 e7 fd ff ff       	call   1003c3 <stab_binsearch>
    if (lfile == 0)
  1005dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005df:	85 c0                	test   %eax,%eax
  1005e1:	75 0a                	jne    1005ed <debuginfo_eip+0xd4>
        return -1;
  1005e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e8:	e9 67 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100600:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100607:	00 
  100608:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10060b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10060f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100612:	89 44 24 04          	mov    %eax,0x4(%esp)
  100616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100619:	89 04 24             	mov    %eax,(%esp)
  10061c:	e8 a2 fd ff ff       	call   1003c3 <stab_binsearch>

    if (lfun <= rfun) {
  100621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100627:	39 c2                	cmp    %eax,%edx
  100629:	7f 7c                	jg     1006a7 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10062b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10062e:	89 c2                	mov    %eax,%edx
  100630:	89 d0                	mov    %edx,%eax
  100632:	01 c0                	add    %eax,%eax
  100634:	01 d0                	add    %edx,%eax
  100636:	c1 e0 02             	shl    $0x2,%eax
  100639:	89 c2                	mov    %eax,%edx
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	8b 10                	mov    (%eax),%edx
  100642:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100648:	29 c1                	sub    %eax,%ecx
  10064a:	89 c8                	mov    %ecx,%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	73 22                	jae    100672 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066a:	01 c2                	add    %eax,%edx
  10066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100675:	89 c2                	mov    %eax,%edx
  100677:	89 d0                	mov    %edx,%eax
  100679:	01 c0                	add    %eax,%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	c1 e0 02             	shl    $0x2,%eax
  100680:	89 c2                	mov    %eax,%edx
  100682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	8b 50 08             	mov    0x8(%eax),%edx
  10068a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	8b 40 10             	mov    0x10(%eax),%eax
  100696:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a5:	eb 15                	jmp    1006bc <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1006ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 08             	mov    0x8(%eax),%eax
  1006c2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006c9:	00 
  1006ca:	89 04 24             	mov    %eax,(%esp)
  1006cd:	e8 e2 2b 00 00       	call   1032b4 <strfind>
  1006d2:	89 c2                	mov    %eax,%edx
  1006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d7:	8b 40 08             	mov    0x8(%eax),%eax
  1006da:	29 c2                	sub    %eax,%edx
  1006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006df:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f0:	00 
  1006f1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100702:	89 04 24             	mov    %eax,(%esp)
  100705:	e8 b9 fc ff ff       	call   1003c3 <stab_binsearch>
    if (lline <= rline) {
  10070a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10070d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100710:	39 c2                	cmp    %eax,%edx
  100712:	7f 24                	jg     100738 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100714:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	89 d0                	mov    %edx,%eax
  10071b:	01 c0                	add    %eax,%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	c1 e0 02             	shl    $0x2,%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	01 d0                	add    %edx,%eax
  100729:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10072d:	0f b7 d0             	movzwl %ax,%edx
  100730:	8b 45 0c             	mov    0xc(%ebp),%eax
  100733:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100736:	eb 13                	jmp    10074b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10073d:	e9 12 01 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100742:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100745:	83 e8 01             	sub    $0x1,%eax
  100748:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10074b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10074e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100751:	39 c2                	cmp    %eax,%edx
  100753:	7c 56                	jl     1007ab <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	89 d0                	mov    %edx,%eax
  10075c:	01 c0                	add    %eax,%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	c1 e0 02             	shl    $0x2,%eax
  100763:	89 c2                	mov    %eax,%edx
  100765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100768:	01 d0                	add    %edx,%eax
  10076a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10076e:	3c 84                	cmp    $0x84,%al
  100770:	74 39                	je     1007ab <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100775:	89 c2                	mov    %eax,%edx
  100777:	89 d0                	mov    %edx,%eax
  100779:	01 c0                	add    %eax,%eax
  10077b:	01 d0                	add    %edx,%eax
  10077d:	c1 e0 02             	shl    $0x2,%eax
  100780:	89 c2                	mov    %eax,%edx
  100782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100785:	01 d0                	add    %edx,%eax
  100787:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078b:	3c 64                	cmp    $0x64,%al
  10078d:	75 b3                	jne    100742 <debuginfo_eip+0x229>
  10078f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	89 c2                	mov    %eax,%edx
  10079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	8b 40 08             	mov    0x8(%eax),%eax
  1007a7:	85 c0                	test   %eax,%eax
  1007a9:	74 97                	je     100742 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b1:	39 c2                	cmp    %eax,%edx
  1007b3:	7c 46                	jl     1007fb <debuginfo_eip+0x2e2>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 10                	mov    (%eax),%edx
  1007cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d2:	29 c1                	sub    %eax,%ecx
  1007d4:	89 c8                	mov    %ecx,%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	73 21                	jae    1007fb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f4:	01 c2                	add    %eax,%edx
  1007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7d 4a                	jge    10084f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100808:	83 c0 01             	add    $0x1,%eax
  10080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080e:	eb 18                	jmp    100828 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	8b 40 14             	mov    0x14(%eax),%eax
  100816:	8d 50 01             	lea    0x1(%eax),%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10082e:	39 c2                	cmp    %eax,%edx
  100830:	7d 1d                	jge    10084f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c a0                	cmp    $0xa0,%al
  10084d:	74 c1                	je     100810 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100854:	c9                   	leave  
  100855:	c3                   	ret    

00100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100856:	55                   	push   %ebp
  100857:	89 e5                	mov    %esp,%ebp
  100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085c:	c7 04 24 96 36 10 00 	movl   $0x103696,(%esp)
  100863:	e8 ba fa ff ff       	call   100322 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100868:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086f:	00 
  100870:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  100877:	e8 a6 fa ff ff       	call   100322 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087c:	c7 44 24 04 c9 35 10 	movl   $0x1035c9,0x4(%esp)
  100883:	00 
  100884:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  10088b:	e8 92 fa ff ff       	call   100322 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100890:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100897:	00 
  100898:	c7 04 24 df 36 10 00 	movl   $0x1036df,(%esp)
  10089f:	e8 7e fa ff ff       	call   100322 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a4:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  1008ab:	00 
  1008ac:	c7 04 24 f7 36 10 00 	movl   $0x1036f7,(%esp)
  1008b3:	e8 6a fa ff ff       	call   100322 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008c8:	29 c2                	sub    %eax,%edx
  1008ca:	89 d0                	mov    %edx,%eax
  1008cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d2:	85 c0                	test   %eax,%eax
  1008d4:	0f 48 c2             	cmovs  %edx,%eax
  1008d7:	c1 f8 0a             	sar    $0xa,%eax
  1008da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008de:	c7 04 24 10 37 10 00 	movl   $0x103710,(%esp)
  1008e5:	e8 38 fa ff ff       	call   100322 <cprintf>
}
  1008ea:	c9                   	leave  
  1008eb:	c3                   	ret    

001008ec <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ec:	55                   	push   %ebp
  1008ed:	89 e5                	mov    %esp,%ebp
  1008ef:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ff:	89 04 24             	mov    %eax,(%esp)
  100902:	e8 12 fc ff ff       	call   100519 <debuginfo_eip>
  100907:	85 c0                	test   %eax,%eax
  100909:	74 15                	je     100920 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090b:	8b 45 08             	mov    0x8(%ebp),%eax
  10090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100912:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  100919:	e8 04 fa ff ff       	call   100322 <cprintf>
  10091e:	eb 6d                	jmp    10098d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100927:	eb 1c                	jmp    100945 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092f:	01 d0                	add    %edx,%eax
  100931:	0f b6 00             	movzbl (%eax),%eax
  100934:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10093d:	01 ca                	add    %ecx,%edx
  10093f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094b:	7f dc                	jg     100929 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100956:	01 d0                	add    %edx,%eax
  100958:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10095b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10095e:	8b 55 08             	mov    0x8(%ebp),%edx
  100961:	89 d1                	mov    %edx,%ecx
  100963:	29 c1                	sub    %eax,%ecx
  100965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10096b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10096f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100975:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100979:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100981:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100988:	e8 95 f9 ff ff       	call   100322 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10098d:	c9                   	leave  
  10098e:	c3                   	ret    

0010098f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100995:	8b 45 04             	mov    0x4(%ebp),%eax
  100998:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10099b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099e:	c9                   	leave  
  10099f:	c3                   	ret    

001009a0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a0:	55                   	push   %ebp
  1009a1:	89 e5                	mov    %esp,%ebp
  1009a3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a6:	89 e8                	mov    %ebp,%eax
  1009a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     /* LAB1 YOUR CODE : STEP 1 */
  uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  1009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);
  1009b1:	e8 d9 ff ff ff       	call   10098f <read_eip>
  1009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i = 0, j = 0;
  1009b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  for(;(i < STACKFRAME_DEPTH)&&(ebp != 0);i++){    //(3) from 0 .. STACKFRAME_DEPTH
  1009c7:	e9 82 00 00 00       	jmp    100a4e <print_stackframe+0xae>
     cprintf("ebp:0x%08x eip:0x%08x args:",(uint32_t*)ebp,(uint32_t*)eip);//(3.1) printf value of ebp, eip
  1009cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009da:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  1009e1:	e8 3c f9 ff ff       	call   100322 <cprintf>
     for(j = 0;j < 4;j++){
  1009e6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009ed:	eb 28                	jmp    100a17 <print_stackframe+0x77>
//(3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
	cprintf("0x%08x ",*((uint32_t*)ebp+2+j));
  1009ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	01 d0                	add    %edx,%eax
  1009fe:	83 c0 08             	add    $0x8,%eax
  100a01:	8b 00                	mov    (%eax),%eax
  100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a07:	c7 04 24 84 37 10 00 	movl   $0x103784,(%esp)
  100a0e:	e8 0f f9 ff ff       	call   100322 <cprintf>
  uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);
  int i = 0, j = 0;
  for(;(i < STACKFRAME_DEPTH)&&(ebp != 0);i++){    //(3) from 0 .. STACKFRAME_DEPTH
     cprintf("ebp:0x%08x eip:0x%08x args:",(uint32_t*)ebp,(uint32_t*)eip);//(3.1) printf value of ebp, eip
     for(j = 0;j < 4;j++){
  100a13:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a17:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a1b:	7e d2                	jle    1009ef <print_stackframe+0x4f>
//(3.2) (uint32_t)calling arguments [0..4] = the contents in address (uint32_t)ebp +2 [0..4]
	cprintf("0x%08x ",*((uint32_t*)ebp+2+j));
     }
     cprintf("\n");//(3.3) cprintf("\n");
  100a1d:	c7 04 24 8c 37 10 00 	movl   $0x10378c,(%esp)
  100a24:	e8 f9 f8 ff ff       	call   100322 <cprintf>
     print_debuginfo(eip-1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
  100a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a2c:	83 e8 01             	sub    $0x1,%eax
  100a2f:	89 04 24             	mov    %eax,(%esp)
  100a32:	e8 b5 fe ff ff       	call   1008ec <print_debuginfo>
     //(3.5) popup a calling stackframe
     eip = *((uint32_t*)ebp + 1);//NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
  100a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3a:	83 c0 04             	add    $0x4,%eax
  100a3d:	8b 00                	mov    (%eax),%eax
  100a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ebp = *((uint32_t*)ebp);//the calling funciton's ebp = ss:[ebp]
  100a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a45:	8b 00                	mov    (%eax),%eax
  100a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
print_stackframe(void) {
     /* LAB1 YOUR CODE : STEP 1 */
  uint32_t ebp = read_ebp(); //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
  uint32_t eip = read_eip(); //(2) call read_eip() to get the value of eip. the type is (uint32_t);
  int i = 0, j = 0;
  for(;(i < STACKFRAME_DEPTH)&&(ebp != 0);i++){    //(3) from 0 .. STACKFRAME_DEPTH
  100a4a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a52:	7f 0a                	jg     100a5e <print_stackframe+0xbe>
  100a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a58:	0f 85 6e ff ff ff    	jne    1009cc <print_stackframe+0x2c>
     print_debuginfo(eip-1);//(3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
     //(3.5) popup a calling stackframe
     eip = *((uint32_t*)ebp + 1);//NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     ebp = *((uint32_t*)ebp);//the calling funciton's ebp = ss:[ebp]
  }
}
  100a5e:	c9                   	leave  
  100a5f:	c3                   	ret    

00100a60 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a60:	55                   	push   %ebp
  100a61:	89 e5                	mov    %esp,%ebp
  100a63:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6d:	eb 0c                	jmp    100a7b <parse+0x1b>
            *buf ++ = '\0';
  100a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a72:	8d 50 01             	lea    0x1(%eax),%edx
  100a75:	89 55 08             	mov    %edx,0x8(%ebp)
  100a78:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7e:	0f b6 00             	movzbl (%eax),%eax
  100a81:	84 c0                	test   %al,%al
  100a83:	74 1d                	je     100aa2 <parse+0x42>
  100a85:	8b 45 08             	mov    0x8(%ebp),%eax
  100a88:	0f b6 00             	movzbl (%eax),%eax
  100a8b:	0f be c0             	movsbl %al,%eax
  100a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a92:	c7 04 24 10 38 10 00 	movl   $0x103810,(%esp)
  100a99:	e8 e3 27 00 00       	call   103281 <strchr>
  100a9e:	85 c0                	test   %eax,%eax
  100aa0:	75 cd                	jne    100a6f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa5:	0f b6 00             	movzbl (%eax),%eax
  100aa8:	84 c0                	test   %al,%al
  100aaa:	75 02                	jne    100aae <parse+0x4e>
            break;
  100aac:	eb 67                	jmp    100b15 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab2:	75 14                	jne    100ac8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ab4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100abb:	00 
  100abc:	c7 04 24 15 38 10 00 	movl   $0x103815,(%esp)
  100ac3:	e8 5a f8 ff ff       	call   100322 <cprintf>
        }
        argv[argc ++] = buf;
  100ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acb:	8d 50 01             	lea    0x1(%eax),%edx
  100ace:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ad1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100adb:	01 c2                	add    %eax,%edx
  100add:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae0:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae2:	eb 04                	jmp    100ae8 <parse+0x88>
            buf ++;
  100ae4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aeb:	0f b6 00             	movzbl (%eax),%eax
  100aee:	84 c0                	test   %al,%al
  100af0:	74 1d                	je     100b0f <parse+0xaf>
  100af2:	8b 45 08             	mov    0x8(%ebp),%eax
  100af5:	0f b6 00             	movzbl (%eax),%eax
  100af8:	0f be c0             	movsbl %al,%eax
  100afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aff:	c7 04 24 10 38 10 00 	movl   $0x103810,(%esp)
  100b06:	e8 76 27 00 00       	call   103281 <strchr>
  100b0b:	85 c0                	test   %eax,%eax
  100b0d:	74 d5                	je     100ae4 <parse+0x84>
            buf ++;
        }
    }
  100b0f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b10:	e9 66 ff ff ff       	jmp    100a7b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b18:	c9                   	leave  
  100b19:	c3                   	ret    

00100b1a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b1a:	55                   	push   %ebp
  100b1b:	89 e5                	mov    %esp,%ebp
  100b1d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b20:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b27:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2a:	89 04 24             	mov    %eax,(%esp)
  100b2d:	e8 2e ff ff ff       	call   100a60 <parse>
  100b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b39:	75 0a                	jne    100b45 <runcmd+0x2b>
        return 0;
  100b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b40:	e9 85 00 00 00       	jmp    100bca <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b4c:	eb 5c                	jmp    100baa <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b4e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b54:	89 d0                	mov    %edx,%eax
  100b56:	01 c0                	add    %eax,%eax
  100b58:	01 d0                	add    %edx,%eax
  100b5a:	c1 e0 02             	shl    $0x2,%eax
  100b5d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b62:	8b 00                	mov    (%eax),%eax
  100b64:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b68:	89 04 24             	mov    %eax,(%esp)
  100b6b:	e8 72 26 00 00       	call   1031e2 <strcmp>
  100b70:	85 c0                	test   %eax,%eax
  100b72:	75 32                	jne    100ba6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b77:	89 d0                	mov    %edx,%eax
  100b79:	01 c0                	add    %eax,%eax
  100b7b:	01 d0                	add    %edx,%eax
  100b7d:	c1 e0 02             	shl    $0x2,%eax
  100b80:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b85:	8b 40 08             	mov    0x8(%eax),%eax
  100b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b8b:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b91:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b95:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b98:	83 c2 04             	add    $0x4,%edx
  100b9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9f:	89 0c 24             	mov    %ecx,(%esp)
  100ba2:	ff d0                	call   *%eax
  100ba4:	eb 24                	jmp    100bca <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bad:	83 f8 02             	cmp    $0x2,%eax
  100bb0:	76 9c                	jbe    100b4e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bb2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb9:	c7 04 24 33 38 10 00 	movl   $0x103833,(%esp)
  100bc0:	e8 5d f7 ff ff       	call   100322 <cprintf>
    return 0;
  100bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bca:	c9                   	leave  
  100bcb:	c3                   	ret    

00100bcc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bcc:	55                   	push   %ebp
  100bcd:	89 e5                	mov    %esp,%ebp
  100bcf:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd2:	c7 04 24 4c 38 10 00 	movl   $0x10384c,(%esp)
  100bd9:	e8 44 f7 ff ff       	call   100322 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bde:	c7 04 24 74 38 10 00 	movl   $0x103874,(%esp)
  100be5:	e8 38 f7 ff ff       	call   100322 <cprintf>

    if (tf != NULL) {
  100bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bee:	74 0b                	je     100bfb <kmonitor+0x2f>
        print_trapframe(tf);
  100bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf3:	89 04 24             	mov    %eax,(%esp)
  100bf6:	e8 dd 0d 00 00       	call   1019d8 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bfb:	c7 04 24 99 38 10 00 	movl   $0x103899,(%esp)
  100c02:	e8 12 f6 ff ff       	call   100219 <readline>
  100c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0e:	74 18                	je     100c28 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c1a:	89 04 24             	mov    %eax,(%esp)
  100c1d:	e8 f8 fe ff ff       	call   100b1a <runcmd>
  100c22:	85 c0                	test   %eax,%eax
  100c24:	79 02                	jns    100c28 <kmonitor+0x5c>
                break;
  100c26:	eb 02                	jmp    100c2a <kmonitor+0x5e>
            }
        }
    }
  100c28:	eb d1                	jmp    100bfb <kmonitor+0x2f>
}
  100c2a:	c9                   	leave  
  100c2b:	c3                   	ret    

00100c2c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c2c:	55                   	push   %ebp
  100c2d:	89 e5                	mov    %esp,%ebp
  100c2f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c39:	eb 3f                	jmp    100c7a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3e:	89 d0                	mov    %edx,%eax
  100c40:	01 c0                	add    %eax,%eax
  100c42:	01 d0                	add    %edx,%eax
  100c44:	c1 e0 02             	shl    $0x2,%eax
  100c47:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c52:	89 d0                	mov    %edx,%eax
  100c54:	01 c0                	add    %eax,%eax
  100c56:	01 d0                	add    %edx,%eax
  100c58:	c1 e0 02             	shl    $0x2,%eax
  100c5b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c60:	8b 00                	mov    (%eax),%eax
  100c62:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c6a:	c7 04 24 9d 38 10 00 	movl   $0x10389d,(%esp)
  100c71:	e8 ac f6 ff ff       	call   100322 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c76:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7d:	83 f8 02             	cmp    $0x2,%eax
  100c80:	76 b9                	jbe    100c3b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c87:	c9                   	leave  
  100c88:	c3                   	ret    

00100c89 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c89:	55                   	push   %ebp
  100c8a:	89 e5                	mov    %esp,%ebp
  100c8c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c8f:	e8 c2 fb ff ff       	call   100856 <print_kerninfo>
    return 0;
  100c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c99:	c9                   	leave  
  100c9a:	c3                   	ret    

00100c9b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c9b:	55                   	push   %ebp
  100c9c:	89 e5                	mov    %esp,%ebp
  100c9e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca1:	e8 fa fc ff ff       	call   1009a0 <print_stackframe>
    return 0;
  100ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cab:	c9                   	leave  
  100cac:	c3                   	ret    

00100cad <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cad:	55                   	push   %ebp
  100cae:	89 e5                	mov    %esp,%ebp
  100cb0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb3:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cb8:	85 c0                	test   %eax,%eax
  100cba:	74 02                	je     100cbe <__panic+0x11>
        goto panic_dead;
  100cbc:	eb 59                	jmp    100d17 <__panic+0x6a>
    }
    is_panic = 1;
  100cbe:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cc5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc8:	8d 45 14             	lea    0x14(%ebp),%eax
  100ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdc:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
  100ce3:	e8 3a f6 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cef:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf2:	89 04 24             	mov    %eax,(%esp)
  100cf5:	e8 f5 f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100cfa:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100d01:	e8 1c f6 ff ff       	call   100322 <cprintf>
    
    cprintf("stack trackback:\n");
  100d06:	c7 04 24 c4 38 10 00 	movl   $0x1038c4,(%esp)
  100d0d:	e8 10 f6 ff ff       	call   100322 <cprintf>
    print_stackframe();
  100d12:	e8 89 fc ff ff       	call   1009a0 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d17:	e8 22 09 00 00       	call   10163e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d23:	e8 a4 fe ff ff       	call   100bcc <kmonitor>
    }
  100d28:	eb f2                	jmp    100d1c <__panic+0x6f>

00100d2a <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d2a:	55                   	push   %ebp
  100d2b:	89 e5                	mov    %esp,%ebp
  100d2d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d30:	8d 45 14             	lea    0x14(%ebp),%eax
  100d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d39:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d44:	c7 04 24 d6 38 10 00 	movl   $0x1038d6,(%esp)
  100d4b:	e8 d2 f5 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d57:	8b 45 10             	mov    0x10(%ebp),%eax
  100d5a:	89 04 24             	mov    %eax,(%esp)
  100d5d:	e8 8d f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d62:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100d69:	e8 b4 f5 ff ff       	call   100322 <cprintf>
    va_end(ap);
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d73:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d78:	5d                   	pop    %ebp
  100d79:	c3                   	ret    

00100d7a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d7a:	55                   	push   %ebp
  100d7b:	89 e5                	mov    %esp,%ebp
  100d7d:	83 ec 28             	sub    $0x28,%esp
  100d80:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d86:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d8a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d92:	ee                   	out    %al,(%dx)
  100d93:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d99:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d9d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
  100da6:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dac:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100db4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db9:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100dc0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc3:	c7 04 24 f4 38 10 00 	movl   $0x1038f4,(%esp)
  100dca:	e8 53 f5 ff ff       	call   100322 <cprintf>
    pic_enable(IRQ_TIMER);
  100dcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd6:	e8 c1 08 00 00       	call   10169c <pic_enable>
}
  100ddb:	c9                   	leave  
  100ddc:	c3                   	ret    

00100ddd <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ddd:	55                   	push   %ebp
  100dde:	89 e5                	mov    %esp,%ebp
  100de0:	83 ec 10             	sub    $0x10,%esp
  100de3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ded:	89 c2                	mov    %eax,%edx
  100def:	ec                   	in     (%dx),%al
  100df0:	88 45 fd             	mov    %al,-0x3(%ebp)
  100df3:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dfd:	89 c2                	mov    %eax,%edx
  100dff:	ec                   	in     (%dx),%al
  100e00:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e03:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e09:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0d:	89 c2                	mov    %eax,%edx
  100e0f:	ec                   	in     (%dx),%al
  100e10:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e13:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e19:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e1d:	89 c2                	mov    %eax,%edx
  100e1f:	ec                   	in     (%dx),%al
  100e20:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e23:	c9                   	leave  
  100e24:	c3                   	ret    

00100e25 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e25:	55                   	push   %ebp
  100e26:	89 e5                	mov    %esp,%ebp
  100e28:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e2b:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e35:	0f b7 00             	movzwl (%eax),%eax
  100e38:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e47:	0f b7 00             	movzwl (%eax),%eax
  100e4a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e4e:	74 12                	je     100e62 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e50:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e57:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e5e:	b4 03 
  100e60:	eb 13                	jmp    100e75 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e65:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e69:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e6c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e73:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e75:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7c:	0f b7 c0             	movzwl %ax,%eax
  100e7f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e83:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e87:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e8b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e8f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e90:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e97:	83 c0 01             	add    $0x1,%eax
  100e9a:	0f b7 c0             	movzwl %ax,%eax
  100e9d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ea5:	89 c2                	mov    %eax,%edx
  100ea7:	ec                   	in     (%dx),%al
  100ea8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eab:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eaf:	0f b6 c0             	movzbl %al,%eax
  100eb2:	c1 e0 08             	shl    $0x8,%eax
  100eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eb8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebf:	0f b7 c0             	movzwl %ax,%eax
  100ec2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ec6:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eca:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ece:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ed2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ed3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eda:	83 c0 01             	add    $0x1,%eax
  100edd:	0f b7 c0             	movzwl %ax,%eax
  100ee0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee4:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ee8:	89 c2                	mov    %eax,%edx
  100eea:	ec                   	in     (%dx),%al
  100eeb:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef2:	0f b6 c0             	movzbl %al,%eax
  100ef5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efb:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f03:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f09:	c9                   	leave  
  100f0a:	c3                   	ret    

00100f0b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f0b:	55                   	push   %ebp
  100f0c:	89 e5                	mov    %esp,%ebp
  100f0e:	83 ec 48             	sub    $0x48,%esp
  100f11:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f17:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f1b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f1f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f23:	ee                   	out    %al,(%dx)
  100f24:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f2a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f2e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f32:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f36:	ee                   	out    %al,(%dx)
  100f37:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f3d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f41:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f45:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f49:	ee                   	out    %al,(%dx)
  100f4a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f50:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f54:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f58:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f5c:	ee                   	out    %al,(%dx)
  100f5d:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f63:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f67:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f6b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
  100f70:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f76:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f7a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f7e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f82:	ee                   	out    %al,(%dx)
  100f83:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f89:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f8d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f91:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f95:	ee                   	out    %al,(%dx)
  100f96:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fa0:	89 c2                	mov    %eax,%edx
  100fa2:	ec                   	in     (%dx),%al
  100fa3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fa6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100faa:	3c ff                	cmp    $0xff,%al
  100fac:	0f 95 c0             	setne  %al
  100faf:	0f b6 c0             	movzbl %al,%eax
  100fb2:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fb7:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fbd:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fc1:	89 c2                	mov    %eax,%edx
  100fc3:	ec                   	in     (%dx),%al
  100fc4:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fc7:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fcd:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fd1:	89 c2                	mov    %eax,%edx
  100fd3:	ec                   	in     (%dx),%al
  100fd4:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fd7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fdc:	85 c0                	test   %eax,%eax
  100fde:	74 0c                	je     100fec <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fe0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fe7:	e8 b0 06 00 00       	call   10169c <pic_enable>
    }
}
  100fec:	c9                   	leave  
  100fed:	c3                   	ret    

00100fee <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fee:	55                   	push   %ebp
  100fef:	89 e5                	mov    %esp,%ebp
  100ff1:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ffb:	eb 09                	jmp    101006 <lpt_putc_sub+0x18>
        delay();
  100ffd:	e8 db fd ff ff       	call   100ddd <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101002:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101006:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10100c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101010:	89 c2                	mov    %eax,%edx
  101012:	ec                   	in     (%dx),%al
  101013:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101016:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10101a:	84 c0                	test   %al,%al
  10101c:	78 09                	js     101027 <lpt_putc_sub+0x39>
  10101e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101025:	7e d6                	jle    100ffd <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101027:	8b 45 08             	mov    0x8(%ebp),%eax
  10102a:	0f b6 c0             	movzbl %al,%eax
  10102d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101033:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101036:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10103a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103e:	ee                   	out    %al,(%dx)
  10103f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101045:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101049:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10104d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101051:	ee                   	out    %al,(%dx)
  101052:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101058:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10105c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101060:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101064:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101065:	c9                   	leave  
  101066:	c3                   	ret    

00101067 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101067:	55                   	push   %ebp
  101068:	89 e5                	mov    %esp,%ebp
  10106a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10106d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101071:	74 0d                	je     101080 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101073:	8b 45 08             	mov    0x8(%ebp),%eax
  101076:	89 04 24             	mov    %eax,(%esp)
  101079:	e8 70 ff ff ff       	call   100fee <lpt_putc_sub>
  10107e:	eb 24                	jmp    1010a4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101080:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101087:	e8 62 ff ff ff       	call   100fee <lpt_putc_sub>
        lpt_putc_sub(' ');
  10108c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101093:	e8 56 ff ff ff       	call   100fee <lpt_putc_sub>
        lpt_putc_sub('\b');
  101098:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10109f:	e8 4a ff ff ff       	call   100fee <lpt_putc_sub>
    }
}
  1010a4:	c9                   	leave  
  1010a5:	c3                   	ret    

001010a6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010a6:	55                   	push   %ebp
  1010a7:	89 e5                	mov    %esp,%ebp
  1010a9:	53                   	push   %ebx
  1010aa:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b0:	b0 00                	mov    $0x0,%al
  1010b2:	85 c0                	test   %eax,%eax
  1010b4:	75 07                	jne    1010bd <cga_putc+0x17>
        c |= 0x0700;
  1010b6:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c0:	0f b6 c0             	movzbl %al,%eax
  1010c3:	83 f8 0a             	cmp    $0xa,%eax
  1010c6:	74 4c                	je     101114 <cga_putc+0x6e>
  1010c8:	83 f8 0d             	cmp    $0xd,%eax
  1010cb:	74 57                	je     101124 <cga_putc+0x7e>
  1010cd:	83 f8 08             	cmp    $0x8,%eax
  1010d0:	0f 85 88 00 00 00    	jne    10115e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010d6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dd:	66 85 c0             	test   %ax,%ax
  1010e0:	74 30                	je     101112 <cga_putc+0x6c>
            crt_pos --;
  1010e2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e9:	83 e8 01             	sub    $0x1,%eax
  1010ec:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010f2:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010f7:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010fe:	0f b7 d2             	movzwl %dx,%edx
  101101:	01 d2                	add    %edx,%edx
  101103:	01 c2                	add    %eax,%edx
  101105:	8b 45 08             	mov    0x8(%ebp),%eax
  101108:	b0 00                	mov    $0x0,%al
  10110a:	83 c8 20             	or     $0x20,%eax
  10110d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101110:	eb 72                	jmp    101184 <cga_putc+0xde>
  101112:	eb 70                	jmp    101184 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101114:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10111b:	83 c0 50             	add    $0x50,%eax
  10111e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101124:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10112b:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101132:	0f b7 c1             	movzwl %cx,%eax
  101135:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10113b:	c1 e8 10             	shr    $0x10,%eax
  10113e:	89 c2                	mov    %eax,%edx
  101140:	66 c1 ea 06          	shr    $0x6,%dx
  101144:	89 d0                	mov    %edx,%eax
  101146:	c1 e0 02             	shl    $0x2,%eax
  101149:	01 d0                	add    %edx,%eax
  10114b:	c1 e0 04             	shl    $0x4,%eax
  10114e:	29 c1                	sub    %eax,%ecx
  101150:	89 ca                	mov    %ecx,%edx
  101152:	89 d8                	mov    %ebx,%eax
  101154:	29 d0                	sub    %edx,%eax
  101156:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10115c:	eb 26                	jmp    101184 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10115e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101164:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116b:	8d 50 01             	lea    0x1(%eax),%edx
  10116e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101175:	0f b7 c0             	movzwl %ax,%eax
  101178:	01 c0                	add    %eax,%eax
  10117a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10117d:	8b 45 08             	mov    0x8(%ebp),%eax
  101180:	66 89 02             	mov    %ax,(%edx)
        break;
  101183:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101184:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10118b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10118f:	76 5b                	jbe    1011ec <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101191:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101196:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10119c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a8:	00 
  1011a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ad:	89 04 24             	mov    %eax,(%esp)
  1011b0:	e8 ca 22 00 00       	call   10347f <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011bc:	eb 15                	jmp    1011d3 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011be:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011c6:	01 d2                	add    %edx,%edx
  1011c8:	01 d0                	add    %edx,%eax
  1011ca:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011d3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011da:	7e e2                	jle    1011be <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011dc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e3:	83 e8 50             	sub    $0x50,%eax
  1011e6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011ec:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f3:	0f b7 c0             	movzwl %ax,%eax
  1011f6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011fa:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011fe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101202:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101206:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101207:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120e:	66 c1 e8 08          	shr    $0x8,%ax
  101212:	0f b6 c0             	movzbl %al,%eax
  101215:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10121c:	83 c2 01             	add    $0x1,%edx
  10121f:	0f b7 d2             	movzwl %dx,%edx
  101222:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101226:	88 45 ed             	mov    %al,-0x13(%ebp)
  101229:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101231:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101232:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101239:	0f b7 c0             	movzwl %ax,%eax
  10123c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101240:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101244:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101248:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10124c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10124d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101254:	0f b6 c0             	movzbl %al,%eax
  101257:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10125e:	83 c2 01             	add    $0x1,%edx
  101261:	0f b7 d2             	movzwl %dx,%edx
  101264:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101268:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10126b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10126f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101273:	ee                   	out    %al,(%dx)
}
  101274:	83 c4 34             	add    $0x34,%esp
  101277:	5b                   	pop    %ebx
  101278:	5d                   	pop    %ebp
  101279:	c3                   	ret    

0010127a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10127a:	55                   	push   %ebp
  10127b:	89 e5                	mov    %esp,%ebp
  10127d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101280:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101287:	eb 09                	jmp    101292 <serial_putc_sub+0x18>
        delay();
  101289:	e8 4f fb ff ff       	call   100ddd <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101292:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101298:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10129c:	89 c2                	mov    %eax,%edx
  10129e:	ec                   	in     (%dx),%al
  10129f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012a2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012a6:	0f b6 c0             	movzbl %al,%eax
  1012a9:	83 e0 20             	and    $0x20,%eax
  1012ac:	85 c0                	test   %eax,%eax
  1012ae:	75 09                	jne    1012b9 <serial_putc_sub+0x3f>
  1012b0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b7:	7e d0                	jle    101289 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1012bc:	0f b6 c0             	movzbl %al,%eax
  1012bf:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012c5:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012cc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012d0:	ee                   	out    %al,(%dx)
}
  1012d1:	c9                   	leave  
  1012d2:	c3                   	ret    

001012d3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012d3:	55                   	push   %ebp
  1012d4:	89 e5                	mov    %esp,%ebp
  1012d6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012dd:	74 0d                	je     1012ec <serial_putc+0x19>
        serial_putc_sub(c);
  1012df:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e2:	89 04 24             	mov    %eax,(%esp)
  1012e5:	e8 90 ff ff ff       	call   10127a <serial_putc_sub>
  1012ea:	eb 24                	jmp    101310 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f3:	e8 82 ff ff ff       	call   10127a <serial_putc_sub>
        serial_putc_sub(' ');
  1012f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012ff:	e8 76 ff ff ff       	call   10127a <serial_putc_sub>
        serial_putc_sub('\b');
  101304:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10130b:	e8 6a ff ff ff       	call   10127a <serial_putc_sub>
    }
}
  101310:	c9                   	leave  
  101311:	c3                   	ret    

00101312 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101312:	55                   	push   %ebp
  101313:	89 e5                	mov    %esp,%ebp
  101315:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101318:	eb 33                	jmp    10134d <cons_intr+0x3b>
        if (c != 0) {
  10131a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10131e:	74 2d                	je     10134d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101320:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101325:	8d 50 01             	lea    0x1(%eax),%edx
  101328:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10132e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101331:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101337:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10133c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101341:	75 0a                	jne    10134d <cons_intr+0x3b>
                cons.wpos = 0;
  101343:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10134a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10134d:	8b 45 08             	mov    0x8(%ebp),%eax
  101350:	ff d0                	call   *%eax
  101352:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101355:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101359:	75 bf                	jne    10131a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10135b:	c9                   	leave  
  10135c:	c3                   	ret    

0010135d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10135d:	55                   	push   %ebp
  10135e:	89 e5                	mov    %esp,%ebp
  101360:	83 ec 10             	sub    $0x10,%esp
  101363:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101369:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136d:	89 c2                	mov    %eax,%edx
  10136f:	ec                   	in     (%dx),%al
  101370:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101373:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101377:	0f b6 c0             	movzbl %al,%eax
  10137a:	83 e0 01             	and    $0x1,%eax
  10137d:	85 c0                	test   %eax,%eax
  10137f:	75 07                	jne    101388 <serial_proc_data+0x2b>
        return -1;
  101381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101386:	eb 2a                	jmp    1013b2 <serial_proc_data+0x55>
  101388:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10138e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101392:	89 c2                	mov    %eax,%edx
  101394:	ec                   	in     (%dx),%al
  101395:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101398:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10139c:	0f b6 c0             	movzbl %al,%eax
  10139f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013a2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013a6:	75 07                	jne    1013af <serial_proc_data+0x52>
        c = '\b';
  1013a8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013b2:	c9                   	leave  
  1013b3:	c3                   	ret    

001013b4 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013b4:	55                   	push   %ebp
  1013b5:	89 e5                	mov    %esp,%ebp
  1013b7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ba:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013bf:	85 c0                	test   %eax,%eax
  1013c1:	74 0c                	je     1013cf <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013c3:	c7 04 24 5d 13 10 00 	movl   $0x10135d,(%esp)
  1013ca:	e8 43 ff ff ff       	call   101312 <cons_intr>
    }
}
  1013cf:	c9                   	leave  
  1013d0:	c3                   	ret    

001013d1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013d1:	55                   	push   %ebp
  1013d2:	89 e5                	mov    %esp,%ebp
  1013d4:	83 ec 38             	sub    $0x38,%esp
  1013d7:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013dd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013e1:	89 c2                	mov    %eax,%edx
  1013e3:	ec                   	in     (%dx),%al
  1013e4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013eb:	0f b6 c0             	movzbl %al,%eax
  1013ee:	83 e0 01             	and    $0x1,%eax
  1013f1:	85 c0                	test   %eax,%eax
  1013f3:	75 0a                	jne    1013ff <kbd_proc_data+0x2e>
        return -1;
  1013f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013fa:	e9 59 01 00 00       	jmp    101558 <kbd_proc_data+0x187>
  1013ff:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101405:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101409:	89 c2                	mov    %eax,%edx
  10140b:	ec                   	in     (%dx),%al
  10140c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10140f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101413:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101416:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10141a:	75 17                	jne    101433 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10141c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101421:	83 c8 40             	or     $0x40,%eax
  101424:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101429:	b8 00 00 00 00       	mov    $0x0,%eax
  10142e:	e9 25 01 00 00       	jmp    101558 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101433:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101437:	84 c0                	test   %al,%al
  101439:	79 47                	jns    101482 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10143b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101440:	83 e0 40             	and    $0x40,%eax
  101443:	85 c0                	test   %eax,%eax
  101445:	75 09                	jne    101450 <kbd_proc_data+0x7f>
  101447:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144b:	83 e0 7f             	and    $0x7f,%eax
  10144e:	eb 04                	jmp    101454 <kbd_proc_data+0x83>
  101450:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101454:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101462:	83 c8 40             	or     $0x40,%eax
  101465:	0f b6 c0             	movzbl %al,%eax
  101468:	f7 d0                	not    %eax
  10146a:	89 c2                	mov    %eax,%edx
  10146c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101471:	21 d0                	and    %edx,%eax
  101473:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101478:	b8 00 00 00 00       	mov    $0x0,%eax
  10147d:	e9 d6 00 00 00       	jmp    101558 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101482:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101487:	83 e0 40             	and    $0x40,%eax
  10148a:	85 c0                	test   %eax,%eax
  10148c:	74 11                	je     10149f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10148e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101492:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101497:	83 e0 bf             	and    $0xffffffbf,%eax
  10149a:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10149f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a3:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014aa:	0f b6 d0             	movzbl %al,%edx
  1014ad:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b2:	09 d0                	or     %edx,%eax
  1014b4:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bd:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014c4:	0f b6 d0             	movzbl %al,%edx
  1014c7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014cc:	31 d0                	xor    %edx,%eax
  1014ce:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014d3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d8:	83 e0 03             	and    $0x3,%eax
  1014db:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e6:	01 d0                	add    %edx,%eax
  1014e8:	0f b6 00             	movzbl (%eax),%eax
  1014eb:	0f b6 c0             	movzbl %al,%eax
  1014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014f1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f6:	83 e0 08             	and    $0x8,%eax
  1014f9:	85 c0                	test   %eax,%eax
  1014fb:	74 22                	je     10151f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014fd:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101501:	7e 0c                	jle    10150f <kbd_proc_data+0x13e>
  101503:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101507:	7f 06                	jg     10150f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101509:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10150d:	eb 10                	jmp    10151f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10150f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101513:	7e 0a                	jle    10151f <kbd_proc_data+0x14e>
  101515:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101519:	7f 04                	jg     10151f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10151b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10151f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101524:	f7 d0                	not    %eax
  101526:	83 e0 06             	and    $0x6,%eax
  101529:	85 c0                	test   %eax,%eax
  10152b:	75 28                	jne    101555 <kbd_proc_data+0x184>
  10152d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101534:	75 1f                	jne    101555 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101536:	c7 04 24 0f 39 10 00 	movl   $0x10390f,(%esp)
  10153d:	e8 e0 ed ff ff       	call   100322 <cprintf>
  101542:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101548:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10154c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101550:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101554:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101555:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101558:	c9                   	leave  
  101559:	c3                   	ret    

0010155a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10155a:	55                   	push   %ebp
  10155b:	89 e5                	mov    %esp,%ebp
  10155d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101560:	c7 04 24 d1 13 10 00 	movl   $0x1013d1,(%esp)
  101567:	e8 a6 fd ff ff       	call   101312 <cons_intr>
}
  10156c:	c9                   	leave  
  10156d:	c3                   	ret    

0010156e <kbd_init>:

static void
kbd_init(void) {
  10156e:	55                   	push   %ebp
  10156f:	89 e5                	mov    %esp,%ebp
  101571:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101574:	e8 e1 ff ff ff       	call   10155a <kbd_intr>
    pic_enable(IRQ_KBD);
  101579:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101580:	e8 17 01 00 00       	call   10169c <pic_enable>
}
  101585:	c9                   	leave  
  101586:	c3                   	ret    

00101587 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101587:	55                   	push   %ebp
  101588:	89 e5                	mov    %esp,%ebp
  10158a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10158d:	e8 93 f8 ff ff       	call   100e25 <cga_init>
    serial_init();
  101592:	e8 74 f9 ff ff       	call   100f0b <serial_init>
    kbd_init();
  101597:	e8 d2 ff ff ff       	call   10156e <kbd_init>
    if (!serial_exists) {
  10159c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015a1:	85 c0                	test   %eax,%eax
  1015a3:	75 0c                	jne    1015b1 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015a5:	c7 04 24 1b 39 10 00 	movl   $0x10391b,(%esp)
  1015ac:	e8 71 ed ff ff       	call   100322 <cprintf>
    }
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bc:	89 04 24             	mov    %eax,(%esp)
  1015bf:	e8 a3 fa ff ff       	call   101067 <lpt_putc>
    cga_putc(c);
  1015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c7:	89 04 24             	mov    %eax,(%esp)
  1015ca:	e8 d7 fa ff ff       	call   1010a6 <cga_putc>
    serial_putc(c);
  1015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d2:	89 04 24             	mov    %eax,(%esp)
  1015d5:	e8 f9 fc ff ff       	call   1012d3 <serial_putc>
}
  1015da:	c9                   	leave  
  1015db:	c3                   	ret    

001015dc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015dc:	55                   	push   %ebp
  1015dd:	89 e5                	mov    %esp,%ebp
  1015df:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015e2:	e8 cd fd ff ff       	call   1013b4 <serial_intr>
    kbd_intr();
  1015e7:	e8 6e ff ff ff       	call   10155a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ec:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015f2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015f7:	39 c2                	cmp    %eax,%edx
  1015f9:	74 36                	je     101631 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015fb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101600:	8d 50 01             	lea    0x1(%eax),%edx
  101603:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101609:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101610:	0f b6 c0             	movzbl %al,%eax
  101613:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101616:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10161b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101620:	75 0a                	jne    10162c <cons_getc+0x50>
            cons.rpos = 0;
  101622:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101629:	00 00 00 
        }
        return c;
  10162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162f:	eb 05                	jmp    101636 <cons_getc+0x5a>
    }
    return 0;
  101631:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101636:	c9                   	leave  
  101637:	c3                   	ret    

00101638 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101638:	55                   	push   %ebp
  101639:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10163b:	fb                   	sti    
    sti();
}
  10163c:	5d                   	pop    %ebp
  10163d:	c3                   	ret    

0010163e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10163e:	55                   	push   %ebp
  10163f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101641:	fa                   	cli    
    cli();
}
  101642:	5d                   	pop    %ebp
  101643:	c3                   	ret    

00101644 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101644:	55                   	push   %ebp
  101645:	89 e5                	mov    %esp,%ebp
  101647:	83 ec 14             	sub    $0x14,%esp
  10164a:	8b 45 08             	mov    0x8(%ebp),%eax
  10164d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101651:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101655:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10165b:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101660:	85 c0                	test   %eax,%eax
  101662:	74 36                	je     10169a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101664:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101668:	0f b6 c0             	movzbl %al,%eax
  10166b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101671:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101674:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101678:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10167c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10167d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101681:	66 c1 e8 08          	shr    $0x8,%ax
  101685:	0f b6 c0             	movzbl %al,%eax
  101688:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10168e:	88 45 f9             	mov    %al,-0x7(%ebp)
  101691:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101695:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101699:	ee                   	out    %al,(%dx)
    }
}
  10169a:	c9                   	leave  
  10169b:	c3                   	ret    

0010169c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10169c:	55                   	push   %ebp
  10169d:	89 e5                	mov    %esp,%ebp
  10169f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a5:	ba 01 00 00 00       	mov    $0x1,%edx
  1016aa:	89 c1                	mov    %eax,%ecx
  1016ac:	d3 e2                	shl    %cl,%edx
  1016ae:	89 d0                	mov    %edx,%eax
  1016b0:	f7 d0                	not    %eax
  1016b2:	89 c2                	mov    %eax,%edx
  1016b4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016bb:	21 d0                	and    %edx,%eax
  1016bd:	0f b7 c0             	movzwl %ax,%eax
  1016c0:	89 04 24             	mov    %eax,(%esp)
  1016c3:	e8 7c ff ff ff       	call   101644 <pic_setmask>
}
  1016c8:	c9                   	leave  
  1016c9:	c3                   	ret    

001016ca <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ca:	55                   	push   %ebp
  1016cb:	89 e5                	mov    %esp,%ebp
  1016cd:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016d0:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016d7:	00 00 00 
  1016da:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016e4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ec:	ee                   	out    %al,(%dx)
  1016ed:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f3:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016f7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016ff:	ee                   	out    %al,(%dx)
  101700:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101706:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10170a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10170e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101712:	ee                   	out    %al,(%dx)
  101713:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101719:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10171d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101721:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101725:	ee                   	out    %al,(%dx)
  101726:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10172c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101730:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101734:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101738:	ee                   	out    %al,(%dx)
  101739:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10173f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101743:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101747:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10174b:	ee                   	out    %al,(%dx)
  10174c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101752:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101756:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10175a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
  10175f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101765:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101769:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10176d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
  101772:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101778:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10177c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101780:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
  101785:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10178b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10178f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101793:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101797:	ee                   	out    %al,(%dx)
  101798:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10179e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017a2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017aa:	ee                   	out    %al,(%dx)
  1017ab:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017b1:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017b5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017b9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017bd:	ee                   	out    %al,(%dx)
  1017be:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017c4:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017c8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017cc:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
  1017d1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017d7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017db:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017df:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017e3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017e4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017eb:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017ef:	74 12                	je     101803 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017f1:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017f8:	0f b7 c0             	movzwl %ax,%eax
  1017fb:	89 04 24             	mov    %eax,(%esp)
  1017fe:	e8 41 fe ff ff       	call   101644 <pic_setmask>
    }
}
  101803:	c9                   	leave  
  101804:	c3                   	ret    

00101805 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101805:	55                   	push   %ebp
  101806:	89 e5                	mov    %esp,%ebp
  101808:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10180b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101812:	00 
  101813:	c7 04 24 40 39 10 00 	movl   $0x103940,(%esp)
  10181a:	e8 03 eb ff ff       	call   100322 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10181f:	c9                   	leave  
  101820:	c3                   	ret    

00101821 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101821:	55                   	push   %ebp
  101822:	89 e5                	mov    %esp,%ebp
  101824:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  101827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(;i < 256;i++){
  10182e:	e9 c3 00 00 00       	jmp    1018f6 <idt_init+0xd5>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);	
  101833:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101836:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10183d:	89 c2                	mov    %eax,%edx
  10183f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101842:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101849:	00 
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101854:	00 08 00 
  101857:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101861:	00 
  101862:	83 e2 e0             	and    $0xffffffe0,%edx
  101865:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101876:	00 
  101877:	83 e2 1f             	and    $0x1f,%edx
  10187a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101884:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10188b:	00 
  10188c:	83 e2 f0             	and    $0xfffffff0,%edx
  10188f:	83 ca 0e             	or     $0xe,%edx
  101892:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101899:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a3:	00 
  1018a4:	83 e2 ef             	and    $0xffffffef,%edx
  1018a7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b8:	00 
  1018b9:	83 e2 9f             	and    $0xffffff9f,%edx
  1018bc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018cd:	00 
  1018ce:	83 ca 80             	or     $0xffffff80,%edx
  1018d1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018db:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018e2:	c1 e8 10             	shr    $0x10,%eax
  1018e5:	89 c2                	mov    %eax,%edx
  1018e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ea:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018f1:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(;i < 256;i++){
  1018f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018f6:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018fd:	0f 8e 30 ff ff ff    	jle    101833 <idt_init+0x12>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);	
	}
	SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101903:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101908:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  10190e:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101915:	08 00 
  101917:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10191e:	83 e0 e0             	and    $0xffffffe0,%eax
  101921:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101926:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10192d:	83 e0 1f             	and    $0x1f,%eax
  101930:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101935:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193c:	83 e0 f0             	and    $0xfffffff0,%eax
  10193f:	83 c8 0e             	or     $0xe,%eax
  101942:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101947:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194e:	83 e0 ef             	and    $0xffffffef,%eax
  101951:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101956:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10195d:	83 c8 60             	or     $0x60,%eax
  101960:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101965:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10196c:	83 c8 80             	or     $0xffffff80,%eax
  10196f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101974:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101979:	c1 e8 10             	shr    $0x10,%eax
  10197c:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101982:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101989:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10198c:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  10198f:	c9                   	leave  
  101990:	c3                   	ret    

00101991 <trapname>:

static const char *
trapname(int trapno) {
  101991:	55                   	push   %ebp
  101992:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101994:	8b 45 08             	mov    0x8(%ebp),%eax
  101997:	83 f8 13             	cmp    $0x13,%eax
  10199a:	77 0c                	ja     1019a8 <trapname+0x17>
        return excnames[trapno];
  10199c:	8b 45 08             	mov    0x8(%ebp),%eax
  10199f:	8b 04 85 a0 3c 10 00 	mov    0x103ca0(,%eax,4),%eax
  1019a6:	eb 18                	jmp    1019c0 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019a8:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019ac:	7e 0d                	jle    1019bb <trapname+0x2a>
  1019ae:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019b2:	7f 07                	jg     1019bb <trapname+0x2a>
        return "Hardware Interrupt";
  1019b4:	b8 4a 39 10 00       	mov    $0x10394a,%eax
  1019b9:	eb 05                	jmp    1019c0 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019bb:	b8 5d 39 10 00       	mov    $0x10395d,%eax
}
  1019c0:	5d                   	pop    %ebp
  1019c1:	c3                   	ret    

001019c2 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019c2:	55                   	push   %ebp
  1019c3:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019cc:	66 83 f8 08          	cmp    $0x8,%ax
  1019d0:	0f 94 c0             	sete   %al
  1019d3:	0f b6 c0             	movzbl %al,%eax
}
  1019d6:	5d                   	pop    %ebp
  1019d7:	c3                   	ret    

001019d8 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019d8:	55                   	push   %ebp
  1019d9:	89 e5                	mov    %esp,%ebp
  1019db:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019de:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e5:	c7 04 24 9e 39 10 00 	movl   $0x10399e,(%esp)
  1019ec:	e8 31 e9 ff ff       	call   100322 <cprintf>
    print_regs(&tf->tf_regs);
  1019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f4:	89 04 24             	mov    %eax,(%esp)
  1019f7:	e8 a1 01 00 00       	call   101b9d <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ff:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a03:	0f b7 c0             	movzwl %ax,%eax
  101a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a0a:	c7 04 24 af 39 10 00 	movl   $0x1039af,(%esp)
  101a11:	e8 0c e9 ff ff       	call   100322 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a16:	8b 45 08             	mov    0x8(%ebp),%eax
  101a19:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a1d:	0f b7 c0             	movzwl %ax,%eax
  101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a24:	c7 04 24 c2 39 10 00 	movl   $0x1039c2,(%esp)
  101a2b:	e8 f2 e8 ff ff       	call   100322 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a30:	8b 45 08             	mov    0x8(%ebp),%eax
  101a33:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a37:	0f b7 c0             	movzwl %ax,%eax
  101a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3e:	c7 04 24 d5 39 10 00 	movl   $0x1039d5,(%esp)
  101a45:	e8 d8 e8 ff ff       	call   100322 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a51:	0f b7 c0             	movzwl %ax,%eax
  101a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a58:	c7 04 24 e8 39 10 00 	movl   $0x1039e8,(%esp)
  101a5f:	e8 be e8 ff ff       	call   100322 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a64:	8b 45 08             	mov    0x8(%ebp),%eax
  101a67:	8b 40 30             	mov    0x30(%eax),%eax
  101a6a:	89 04 24             	mov    %eax,(%esp)
  101a6d:	e8 1f ff ff ff       	call   101991 <trapname>
  101a72:	8b 55 08             	mov    0x8(%ebp),%edx
  101a75:	8b 52 30             	mov    0x30(%edx),%edx
  101a78:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a80:	c7 04 24 fb 39 10 00 	movl   $0x1039fb,(%esp)
  101a87:	e8 96 e8 ff ff       	call   100322 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8f:	8b 40 34             	mov    0x34(%eax),%eax
  101a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a96:	c7 04 24 0d 3a 10 00 	movl   $0x103a0d,(%esp)
  101a9d:	e8 80 e8 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa5:	8b 40 38             	mov    0x38(%eax),%eax
  101aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aac:	c7 04 24 1c 3a 10 00 	movl   $0x103a1c,(%esp)
  101ab3:	e8 6a e8 ff ff       	call   100322 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101abf:	0f b7 c0             	movzwl %ax,%eax
  101ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac6:	c7 04 24 2b 3a 10 00 	movl   $0x103a2b,(%esp)
  101acd:	e8 50 e8 ff ff       	call   100322 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad5:	8b 40 40             	mov    0x40(%eax),%eax
  101ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adc:	c7 04 24 3e 3a 10 00 	movl   $0x103a3e,(%esp)
  101ae3:	e8 3a e8 ff ff       	call   100322 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101aef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101af6:	eb 3e                	jmp    101b36 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101af8:	8b 45 08             	mov    0x8(%ebp),%eax
  101afb:	8b 50 40             	mov    0x40(%eax),%edx
  101afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b01:	21 d0                	and    %edx,%eax
  101b03:	85 c0                	test   %eax,%eax
  101b05:	74 28                	je     101b2f <print_trapframe+0x157>
  101b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b0a:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b11:	85 c0                	test   %eax,%eax
  101b13:	74 1a                	je     101b2f <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b18:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b23:	c7 04 24 4d 3a 10 00 	movl   $0x103a4d,(%esp)
  101b2a:	e8 f3 e7 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b2f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b33:	d1 65 f0             	shll   -0x10(%ebp)
  101b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b39:	83 f8 17             	cmp    $0x17,%eax
  101b3c:	76 ba                	jbe    101af8 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 40             	mov    0x40(%eax),%eax
  101b44:	25 00 30 00 00       	and    $0x3000,%eax
  101b49:	c1 e8 0c             	shr    $0xc,%eax
  101b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b50:	c7 04 24 51 3a 10 00 	movl   $0x103a51,(%esp)
  101b57:	e8 c6 e7 ff ff       	call   100322 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	89 04 24             	mov    %eax,(%esp)
  101b62:	e8 5b fe ff ff       	call   1019c2 <trap_in_kernel>
  101b67:	85 c0                	test   %eax,%eax
  101b69:	75 30                	jne    101b9b <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6e:	8b 40 44             	mov    0x44(%eax),%eax
  101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b75:	c7 04 24 5a 3a 10 00 	movl   $0x103a5a,(%esp)
  101b7c:	e8 a1 e7 ff ff       	call   100322 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b88:	0f b7 c0             	movzwl %ax,%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 69 3a 10 00 	movl   $0x103a69,(%esp)
  101b96:	e8 87 e7 ff ff       	call   100322 <cprintf>
    }
}
  101b9b:	c9                   	leave  
  101b9c:	c3                   	ret    

00101b9d <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b9d:	55                   	push   %ebp
  101b9e:	89 e5                	mov    %esp,%ebp
  101ba0:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba6:	8b 00                	mov    (%eax),%eax
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 7c 3a 10 00 	movl   $0x103a7c,(%esp)
  101bb3:	e8 6a e7 ff ff       	call   100322 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	8b 40 04             	mov    0x4(%eax),%eax
  101bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc2:	c7 04 24 8b 3a 10 00 	movl   $0x103a8b,(%esp)
  101bc9:	e8 54 e7 ff ff       	call   100322 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bce:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd1:	8b 40 08             	mov    0x8(%eax),%eax
  101bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd8:	c7 04 24 9a 3a 10 00 	movl   $0x103a9a,(%esp)
  101bdf:	e8 3e e7 ff ff       	call   100322 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101be4:	8b 45 08             	mov    0x8(%ebp),%eax
  101be7:	8b 40 0c             	mov    0xc(%eax),%eax
  101bea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bee:	c7 04 24 a9 3a 10 00 	movl   $0x103aa9,(%esp)
  101bf5:	e8 28 e7 ff ff       	call   100322 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfd:	8b 40 10             	mov    0x10(%eax),%eax
  101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c04:	c7 04 24 b8 3a 10 00 	movl   $0x103ab8,(%esp)
  101c0b:	e8 12 e7 ff ff       	call   100322 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	8b 40 14             	mov    0x14(%eax),%eax
  101c16:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1a:	c7 04 24 c7 3a 10 00 	movl   $0x103ac7,(%esp)
  101c21:	e8 fc e6 ff ff       	call   100322 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c26:	8b 45 08             	mov    0x8(%ebp),%eax
  101c29:	8b 40 18             	mov    0x18(%eax),%eax
  101c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c30:	c7 04 24 d6 3a 10 00 	movl   $0x103ad6,(%esp)
  101c37:	e8 e6 e6 ff ff       	call   100322 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3f:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c46:	c7 04 24 e5 3a 10 00 	movl   $0x103ae5,(%esp)
  101c4d:	e8 d0 e6 ff ff       	call   100322 <cprintf>
}
  101c52:	c9                   	leave  
  101c53:	c3                   	ret    

00101c54 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c54:	55                   	push   %ebp
  101c55:	89 e5                	mov    %esp,%ebp
  101c57:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5d:	8b 40 30             	mov    0x30(%eax),%eax
  101c60:	83 f8 2f             	cmp    $0x2f,%eax
  101c63:	77 21                	ja     101c86 <trap_dispatch+0x32>
  101c65:	83 f8 2e             	cmp    $0x2e,%eax
  101c68:	0f 83 39 02 00 00    	jae    101ea7 <trap_dispatch+0x253>
  101c6e:	83 f8 21             	cmp    $0x21,%eax
  101c71:	0f 84 8a 00 00 00    	je     101d01 <trap_dispatch+0xad>
  101c77:	83 f8 24             	cmp    $0x24,%eax
  101c7a:	74 5c                	je     101cd8 <trap_dispatch+0x84>
  101c7c:	83 f8 20             	cmp    $0x20,%eax
  101c7f:	74 1c                	je     101c9d <trap_dispatch+0x49>
  101c81:	e9 e9 01 00 00       	jmp    101e6f <trap_dispatch+0x21b>
  101c86:	83 f8 78             	cmp    $0x78,%eax
  101c89:	0f 84 4e 01 00 00    	je     101ddd <trap_dispatch+0x189>
  101c8f:	83 f8 79             	cmp    $0x79,%eax
  101c92:	0f 84 95 01 00 00    	je     101e2d <trap_dispatch+0x1d9>
  101c98:	e9 d2 01 00 00       	jmp    101e6f <trap_dispatch+0x21b>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks ++;
  101c9d:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101ca2:	83 c0 01             	add    $0x1,%eax
  101ca5:	a3 08 f9 10 00       	mov    %eax,0x10f908
	if (ticks % TICK_NUM == 0)
  101caa:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cb0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cb5:	89 c8                	mov    %ecx,%eax
  101cb7:	f7 e2                	mul    %edx
  101cb9:	89 d0                	mov    %edx,%eax
  101cbb:	c1 e8 05             	shr    $0x5,%eax
  101cbe:	6b c0 64             	imul   $0x64,%eax,%eax
  101cc1:	29 c1                	sub    %eax,%ecx
  101cc3:	89 c8                	mov    %ecx,%eax
  101cc5:	85 c0                	test   %eax,%eax
  101cc7:	75 0a                	jne    101cd3 <trap_dispatch+0x7f>
		print_ticks();
  101cc9:	e8 37 fb ff ff       	call   101805 <print_ticks>
        break;
  101cce:	e9 d5 01 00 00       	jmp    101ea8 <trap_dispatch+0x254>
  101cd3:	e9 d0 01 00 00       	jmp    101ea8 <trap_dispatch+0x254>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cd8:	e8 ff f8 ff ff       	call   1015dc <cons_getc>
  101cdd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ce0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ce4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ce8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 f4 3a 10 00 	movl   $0x103af4,(%esp)
  101cf7:	e8 26 e6 ff ff       	call   100322 <cprintf>
        break;
  101cfc:	e9 a7 01 00 00       	jmp    101ea8 <trap_dispatch+0x254>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d01:	e8 d6 f8 ff ff       	call   1015dc <cons_getc>
  101d06:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d09:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d0d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d11:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d19:	c7 04 24 06 3b 10 00 	movl   $0x103b06,(%esp)
  101d20:	e8 fd e5 ff ff       	call   100322 <cprintf>
        switch (c){
  101d25:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d29:	83 f8 30             	cmp    $0x30,%eax
  101d2c:	74 0a                	je     101d38 <trap_dispatch+0xe4>
  101d2e:	83 f8 33             	cmp    $0x33,%eax
  101d31:	74 4e                	je     101d81 <trap_dispatch+0x12d>
                    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
                    tf->tf_eflags |= FL_IOPL_MASK;
                }
                print_trapframe(tf);
        }
        break;
  101d33:	e9 70 01 00 00       	jmp    101ea8 <trap_dispatch+0x254>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
        cprintf("kbd [%03d] %c\n", c, c);
        switch (c){
            case '0':
                if(tf->tf_cs != KERNEL_CS){
  101d38:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d3f:	66 83 f8 08          	cmp    $0x8,%ax
  101d43:	74 31                	je     101d76 <trap_dispatch+0x122>
		            tf->tf_cs = KERNEL_CS;
  101d45:	8b 45 08             	mov    0x8(%ebp),%eax
  101d48:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d51:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d57:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5a:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	66 89 50 2c          	mov    %dx,0x2c(%eax)
		            tf->tf_eflags &=~FL_IOPL_MASK;
  101d65:	8b 45 08             	mov    0x8(%ebp),%eax
  101d68:	8b 40 40             	mov    0x40(%eax),%eax
  101d6b:	80 e4 cf             	and    $0xcf,%ah
  101d6e:	89 c2                	mov    %eax,%edx
  101d70:	8b 45 08             	mov    0x8(%ebp),%eax
  101d73:	89 50 40             	mov    %edx,0x40(%eax)
                }
                print_trapframe(tf);                
  101d76:	8b 45 08             	mov    0x8(%ebp),%eax
  101d79:	89 04 24             	mov    %eax,(%esp)
  101d7c:	e8 57 fc ff ff       	call   1019d8 <print_trapframe>
            case '3':
                if(tf->tf_cs != USER_CS){
  101d81:	8b 45 08             	mov    0x8(%ebp),%eax
  101d84:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d88:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d8c:	74 3f                	je     101dcd <trap_dispatch+0x179>
                    tf->tf_cs = USER_CS;
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101d97:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9a:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101da0:	8b 45 08             	mov    0x8(%ebp),%eax
  101da3:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101da7:	8b 45 08             	mov    0x8(%ebp),%eax
  101daa:	66 89 50 28          	mov    %dx,0x28(%eax)
  101dae:	8b 45 08             	mov    0x8(%ebp),%eax
  101db1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101db5:	8b 45 08             	mov    0x8(%ebp),%eax
  101db8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                    tf->tf_eflags |= FL_IOPL_MASK;
  101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbf:	8b 40 40             	mov    0x40(%eax),%eax
  101dc2:	80 cc 30             	or     $0x30,%ah
  101dc5:	89 c2                	mov    %eax,%edx
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	89 50 40             	mov    %edx,0x40(%eax)
                }
                print_trapframe(tf);
  101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd0:	89 04 24             	mov    %eax,(%esp)
  101dd3:	e8 00 fc ff ff       	call   1019d8 <print_trapframe>
        }
        break;
  101dd8:	e9 cb 00 00 00       	jmp    101ea8 <trap_dispatch+0x254>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	if(tf->tf_cs != USER_CS){
  101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  101de0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de4:	66 83 f8 1b          	cmp    $0x1b,%ax
  101de8:	74 41                	je     101e2b <trap_dispatch+0x1d7>
        // switchk2u = *tf;
		// switchk2u.tf_cs = USER_CS;
        tf->tf_cs = USER_CS;
  101dea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ded:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
		// switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
        tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101df3:	8b 45 08             	mov    0x8(%ebp),%eax
  101df6:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dff:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e03:	8b 45 08             	mov    0x8(%ebp),%eax
  101e06:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e11:	8b 45 08             	mov    0x8(%ebp),%eax
  101e14:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        // switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe)-8;
		// switchk2u.tf_eflags |= FL_IOPL_MASK;
        tf->tf_eflags |= FL_IOPL_MASK;
  101e18:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1b:	8b 40 40             	mov    0x40(%eax),%eax
  101e1e:	80 cc 30             	or     $0x30,%ah
  101e21:	89 c2                	mov    %eax,%edx
  101e23:	8b 45 08             	mov    0x8(%ebp),%eax
  101e26:	89 50 40             	mov    %edx,0x40(%eax)
        // *((uint32_t *)tf-1) = (uint32_t)&switchk2u;
	}
	break;
  101e29:	eb 7d                	jmp    101ea8 <trap_dispatch+0x254>
  101e2b:	eb 7b                	jmp    101ea8 <trap_dispatch+0x254>

    case T_SWITCH_TOK:
	if(tf->tf_cs != KERNEL_CS){
  101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e34:	66 83 f8 08          	cmp    $0x8,%ax
  101e38:	74 33                	je     101e6d <trap_dispatch+0x219>
		tf->tf_cs = KERNEL_CS;
  101e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3d:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
		tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e43:	8b 45 08             	mov    0x8(%ebp),%eax
  101e46:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4f:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e53:	8b 45 08             	mov    0x8(%ebp),%eax
  101e56:	66 89 50 2c          	mov    %dx,0x2c(%eax)
		tf->tf_eflags &=~FL_IOPL_MASK;
  101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5d:	8b 40 40             	mov    0x40(%eax),%eax
  101e60:	80 e4 cf             	and    $0xcf,%ah
  101e63:	89 c2                	mov    %eax,%edx
  101e65:	8b 45 08             	mov    0x8(%ebp),%eax
  101e68:	89 50 40             	mov    %edx,0x40(%eax)

        //switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe)-8));
        //memmove(switchu2k,tf,sizeof(struct trapframe)-8);
        //*((uint32_t *)tf - 1) = (uint32_t)switchu2k;        
	}
    break;
  101e6b:	eb 3b                	jmp    101ea8 <trap_dispatch+0x254>
  101e6d:	eb 39                	jmp    101ea8 <trap_dispatch+0x254>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e72:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e76:	0f b7 c0             	movzwl %ax,%eax
  101e79:	83 e0 03             	and    $0x3,%eax
  101e7c:	85 c0                	test   %eax,%eax
  101e7e:	75 28                	jne    101ea8 <trap_dispatch+0x254>
            print_trapframe(tf);
  101e80:	8b 45 08             	mov    0x8(%ebp),%eax
  101e83:	89 04 24             	mov    %eax,(%esp)
  101e86:	e8 4d fb ff ff       	call   1019d8 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e8b:	c7 44 24 08 15 3b 10 	movl   $0x103b15,0x8(%esp)
  101e92:	00 
  101e93:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  101e9a:	00 
  101e9b:	c7 04 24 31 3b 10 00 	movl   $0x103b31,(%esp)
  101ea2:	e8 06 ee ff ff       	call   100cad <__panic>
    break;

    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ea7:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ea8:	c9                   	leave  
  101ea9:	c3                   	ret    

00101eaa <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101eaa:	55                   	push   %ebp
  101eab:	89 e5                	mov    %esp,%ebp
  101ead:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb3:	89 04 24             	mov    %eax,(%esp)
  101eb6:	e8 99 fd ff ff       	call   101c54 <trap_dispatch>
}
  101ebb:	c9                   	leave  
  101ebc:	c3                   	ret    

00101ebd <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ebd:	1e                   	push   %ds
    pushl %es
  101ebe:	06                   	push   %es
    pushl %fs
  101ebf:	0f a0                	push   %fs
    pushl %gs
  101ec1:	0f a8                	push   %gs
    pushal
  101ec3:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ec4:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ec9:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ecb:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ecd:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ece:	e8 d7 ff ff ff       	call   101eaa <trap>

    # pop the pushed stack pointer
    popl %esp
  101ed3:	5c                   	pop    %esp

00101ed4 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ed4:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ed5:	0f a9                	pop    %gs
    popl %fs
  101ed7:	0f a1                	pop    %fs
    popl %es
  101ed9:	07                   	pop    %es
    popl %ds
  101eda:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101edb:	83 c4 08             	add    $0x8,%esp
    iret
  101ede:	cf                   	iret   

00101edf <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101edf:	6a 00                	push   $0x0
  pushl $0
  101ee1:	6a 00                	push   $0x0
  jmp __alltraps
  101ee3:	e9 d5 ff ff ff       	jmp    101ebd <__alltraps>

00101ee8 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $1
  101eea:	6a 01                	push   $0x1
  jmp __alltraps
  101eec:	e9 cc ff ff ff       	jmp    101ebd <__alltraps>

00101ef1 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $2
  101ef3:	6a 02                	push   $0x2
  jmp __alltraps
  101ef5:	e9 c3 ff ff ff       	jmp    101ebd <__alltraps>

00101efa <vector3>:
.globl vector3
vector3:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $3
  101efc:	6a 03                	push   $0x3
  jmp __alltraps
  101efe:	e9 ba ff ff ff       	jmp    101ebd <__alltraps>

00101f03 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $4
  101f05:	6a 04                	push   $0x4
  jmp __alltraps
  101f07:	e9 b1 ff ff ff       	jmp    101ebd <__alltraps>

00101f0c <vector5>:
.globl vector5
vector5:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $5
  101f0e:	6a 05                	push   $0x5
  jmp __alltraps
  101f10:	e9 a8 ff ff ff       	jmp    101ebd <__alltraps>

00101f15 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $6
  101f17:	6a 06                	push   $0x6
  jmp __alltraps
  101f19:	e9 9f ff ff ff       	jmp    101ebd <__alltraps>

00101f1e <vector7>:
.globl vector7
vector7:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $7
  101f20:	6a 07                	push   $0x7
  jmp __alltraps
  101f22:	e9 96 ff ff ff       	jmp    101ebd <__alltraps>

00101f27 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f27:	6a 08                	push   $0x8
  jmp __alltraps
  101f29:	e9 8f ff ff ff       	jmp    101ebd <__alltraps>

00101f2e <vector9>:
.globl vector9
vector9:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $9
  101f30:	6a 09                	push   $0x9
  jmp __alltraps
  101f32:	e9 86 ff ff ff       	jmp    101ebd <__alltraps>

00101f37 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f37:	6a 0a                	push   $0xa
  jmp __alltraps
  101f39:	e9 7f ff ff ff       	jmp    101ebd <__alltraps>

00101f3e <vector11>:
.globl vector11
vector11:
  pushl $11
  101f3e:	6a 0b                	push   $0xb
  jmp __alltraps
  101f40:	e9 78 ff ff ff       	jmp    101ebd <__alltraps>

00101f45 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f45:	6a 0c                	push   $0xc
  jmp __alltraps
  101f47:	e9 71 ff ff ff       	jmp    101ebd <__alltraps>

00101f4c <vector13>:
.globl vector13
vector13:
  pushl $13
  101f4c:	6a 0d                	push   $0xd
  jmp __alltraps
  101f4e:	e9 6a ff ff ff       	jmp    101ebd <__alltraps>

00101f53 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f53:	6a 0e                	push   $0xe
  jmp __alltraps
  101f55:	e9 63 ff ff ff       	jmp    101ebd <__alltraps>

00101f5a <vector15>:
.globl vector15
vector15:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $15
  101f5c:	6a 0f                	push   $0xf
  jmp __alltraps
  101f5e:	e9 5a ff ff ff       	jmp    101ebd <__alltraps>

00101f63 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $16
  101f65:	6a 10                	push   $0x10
  jmp __alltraps
  101f67:	e9 51 ff ff ff       	jmp    101ebd <__alltraps>

00101f6c <vector17>:
.globl vector17
vector17:
  pushl $17
  101f6c:	6a 11                	push   $0x11
  jmp __alltraps
  101f6e:	e9 4a ff ff ff       	jmp    101ebd <__alltraps>

00101f73 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $18
  101f75:	6a 12                	push   $0x12
  jmp __alltraps
  101f77:	e9 41 ff ff ff       	jmp    101ebd <__alltraps>

00101f7c <vector19>:
.globl vector19
vector19:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $19
  101f7e:	6a 13                	push   $0x13
  jmp __alltraps
  101f80:	e9 38 ff ff ff       	jmp    101ebd <__alltraps>

00101f85 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $20
  101f87:	6a 14                	push   $0x14
  jmp __alltraps
  101f89:	e9 2f ff ff ff       	jmp    101ebd <__alltraps>

00101f8e <vector21>:
.globl vector21
vector21:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $21
  101f90:	6a 15                	push   $0x15
  jmp __alltraps
  101f92:	e9 26 ff ff ff       	jmp    101ebd <__alltraps>

00101f97 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $22
  101f99:	6a 16                	push   $0x16
  jmp __alltraps
  101f9b:	e9 1d ff ff ff       	jmp    101ebd <__alltraps>

00101fa0 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $23
  101fa2:	6a 17                	push   $0x17
  jmp __alltraps
  101fa4:	e9 14 ff ff ff       	jmp    101ebd <__alltraps>

00101fa9 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $24
  101fab:	6a 18                	push   $0x18
  jmp __alltraps
  101fad:	e9 0b ff ff ff       	jmp    101ebd <__alltraps>

00101fb2 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $25
  101fb4:	6a 19                	push   $0x19
  jmp __alltraps
  101fb6:	e9 02 ff ff ff       	jmp    101ebd <__alltraps>

00101fbb <vector26>:
.globl vector26
vector26:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $26
  101fbd:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fbf:	e9 f9 fe ff ff       	jmp    101ebd <__alltraps>

00101fc4 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $27
  101fc6:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fc8:	e9 f0 fe ff ff       	jmp    101ebd <__alltraps>

00101fcd <vector28>:
.globl vector28
vector28:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $28
  101fcf:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fd1:	e9 e7 fe ff ff       	jmp    101ebd <__alltraps>

00101fd6 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $29
  101fd8:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fda:	e9 de fe ff ff       	jmp    101ebd <__alltraps>

00101fdf <vector30>:
.globl vector30
vector30:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $30
  101fe1:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fe3:	e9 d5 fe ff ff       	jmp    101ebd <__alltraps>

00101fe8 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $31
  101fea:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fec:	e9 cc fe ff ff       	jmp    101ebd <__alltraps>

00101ff1 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $32
  101ff3:	6a 20                	push   $0x20
  jmp __alltraps
  101ff5:	e9 c3 fe ff ff       	jmp    101ebd <__alltraps>

00101ffa <vector33>:
.globl vector33
vector33:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $33
  101ffc:	6a 21                	push   $0x21
  jmp __alltraps
  101ffe:	e9 ba fe ff ff       	jmp    101ebd <__alltraps>

00102003 <vector34>:
.globl vector34
vector34:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $34
  102005:	6a 22                	push   $0x22
  jmp __alltraps
  102007:	e9 b1 fe ff ff       	jmp    101ebd <__alltraps>

0010200c <vector35>:
.globl vector35
vector35:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $35
  10200e:	6a 23                	push   $0x23
  jmp __alltraps
  102010:	e9 a8 fe ff ff       	jmp    101ebd <__alltraps>

00102015 <vector36>:
.globl vector36
vector36:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $36
  102017:	6a 24                	push   $0x24
  jmp __alltraps
  102019:	e9 9f fe ff ff       	jmp    101ebd <__alltraps>

0010201e <vector37>:
.globl vector37
vector37:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $37
  102020:	6a 25                	push   $0x25
  jmp __alltraps
  102022:	e9 96 fe ff ff       	jmp    101ebd <__alltraps>

00102027 <vector38>:
.globl vector38
vector38:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $38
  102029:	6a 26                	push   $0x26
  jmp __alltraps
  10202b:	e9 8d fe ff ff       	jmp    101ebd <__alltraps>

00102030 <vector39>:
.globl vector39
vector39:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $39
  102032:	6a 27                	push   $0x27
  jmp __alltraps
  102034:	e9 84 fe ff ff       	jmp    101ebd <__alltraps>

00102039 <vector40>:
.globl vector40
vector40:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $40
  10203b:	6a 28                	push   $0x28
  jmp __alltraps
  10203d:	e9 7b fe ff ff       	jmp    101ebd <__alltraps>

00102042 <vector41>:
.globl vector41
vector41:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $41
  102044:	6a 29                	push   $0x29
  jmp __alltraps
  102046:	e9 72 fe ff ff       	jmp    101ebd <__alltraps>

0010204b <vector42>:
.globl vector42
vector42:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $42
  10204d:	6a 2a                	push   $0x2a
  jmp __alltraps
  10204f:	e9 69 fe ff ff       	jmp    101ebd <__alltraps>

00102054 <vector43>:
.globl vector43
vector43:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $43
  102056:	6a 2b                	push   $0x2b
  jmp __alltraps
  102058:	e9 60 fe ff ff       	jmp    101ebd <__alltraps>

0010205d <vector44>:
.globl vector44
vector44:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $44
  10205f:	6a 2c                	push   $0x2c
  jmp __alltraps
  102061:	e9 57 fe ff ff       	jmp    101ebd <__alltraps>

00102066 <vector45>:
.globl vector45
vector45:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $45
  102068:	6a 2d                	push   $0x2d
  jmp __alltraps
  10206a:	e9 4e fe ff ff       	jmp    101ebd <__alltraps>

0010206f <vector46>:
.globl vector46
vector46:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $46
  102071:	6a 2e                	push   $0x2e
  jmp __alltraps
  102073:	e9 45 fe ff ff       	jmp    101ebd <__alltraps>

00102078 <vector47>:
.globl vector47
vector47:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $47
  10207a:	6a 2f                	push   $0x2f
  jmp __alltraps
  10207c:	e9 3c fe ff ff       	jmp    101ebd <__alltraps>

00102081 <vector48>:
.globl vector48
vector48:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $48
  102083:	6a 30                	push   $0x30
  jmp __alltraps
  102085:	e9 33 fe ff ff       	jmp    101ebd <__alltraps>

0010208a <vector49>:
.globl vector49
vector49:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $49
  10208c:	6a 31                	push   $0x31
  jmp __alltraps
  10208e:	e9 2a fe ff ff       	jmp    101ebd <__alltraps>

00102093 <vector50>:
.globl vector50
vector50:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $50
  102095:	6a 32                	push   $0x32
  jmp __alltraps
  102097:	e9 21 fe ff ff       	jmp    101ebd <__alltraps>

0010209c <vector51>:
.globl vector51
vector51:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $51
  10209e:	6a 33                	push   $0x33
  jmp __alltraps
  1020a0:	e9 18 fe ff ff       	jmp    101ebd <__alltraps>

001020a5 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $52
  1020a7:	6a 34                	push   $0x34
  jmp __alltraps
  1020a9:	e9 0f fe ff ff       	jmp    101ebd <__alltraps>

001020ae <vector53>:
.globl vector53
vector53:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $53
  1020b0:	6a 35                	push   $0x35
  jmp __alltraps
  1020b2:	e9 06 fe ff ff       	jmp    101ebd <__alltraps>

001020b7 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $54
  1020b9:	6a 36                	push   $0x36
  jmp __alltraps
  1020bb:	e9 fd fd ff ff       	jmp    101ebd <__alltraps>

001020c0 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $55
  1020c2:	6a 37                	push   $0x37
  jmp __alltraps
  1020c4:	e9 f4 fd ff ff       	jmp    101ebd <__alltraps>

001020c9 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $56
  1020cb:	6a 38                	push   $0x38
  jmp __alltraps
  1020cd:	e9 eb fd ff ff       	jmp    101ebd <__alltraps>

001020d2 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $57
  1020d4:	6a 39                	push   $0x39
  jmp __alltraps
  1020d6:	e9 e2 fd ff ff       	jmp    101ebd <__alltraps>

001020db <vector58>:
.globl vector58
vector58:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $58
  1020dd:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020df:	e9 d9 fd ff ff       	jmp    101ebd <__alltraps>

001020e4 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $59
  1020e6:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020e8:	e9 d0 fd ff ff       	jmp    101ebd <__alltraps>

001020ed <vector60>:
.globl vector60
vector60:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $60
  1020ef:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020f1:	e9 c7 fd ff ff       	jmp    101ebd <__alltraps>

001020f6 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $61
  1020f8:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020fa:	e9 be fd ff ff       	jmp    101ebd <__alltraps>

001020ff <vector62>:
.globl vector62
vector62:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $62
  102101:	6a 3e                	push   $0x3e
  jmp __alltraps
  102103:	e9 b5 fd ff ff       	jmp    101ebd <__alltraps>

00102108 <vector63>:
.globl vector63
vector63:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $63
  10210a:	6a 3f                	push   $0x3f
  jmp __alltraps
  10210c:	e9 ac fd ff ff       	jmp    101ebd <__alltraps>

00102111 <vector64>:
.globl vector64
vector64:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $64
  102113:	6a 40                	push   $0x40
  jmp __alltraps
  102115:	e9 a3 fd ff ff       	jmp    101ebd <__alltraps>

0010211a <vector65>:
.globl vector65
vector65:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $65
  10211c:	6a 41                	push   $0x41
  jmp __alltraps
  10211e:	e9 9a fd ff ff       	jmp    101ebd <__alltraps>

00102123 <vector66>:
.globl vector66
vector66:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $66
  102125:	6a 42                	push   $0x42
  jmp __alltraps
  102127:	e9 91 fd ff ff       	jmp    101ebd <__alltraps>

0010212c <vector67>:
.globl vector67
vector67:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $67
  10212e:	6a 43                	push   $0x43
  jmp __alltraps
  102130:	e9 88 fd ff ff       	jmp    101ebd <__alltraps>

00102135 <vector68>:
.globl vector68
vector68:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $68
  102137:	6a 44                	push   $0x44
  jmp __alltraps
  102139:	e9 7f fd ff ff       	jmp    101ebd <__alltraps>

0010213e <vector69>:
.globl vector69
vector69:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $69
  102140:	6a 45                	push   $0x45
  jmp __alltraps
  102142:	e9 76 fd ff ff       	jmp    101ebd <__alltraps>

00102147 <vector70>:
.globl vector70
vector70:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $70
  102149:	6a 46                	push   $0x46
  jmp __alltraps
  10214b:	e9 6d fd ff ff       	jmp    101ebd <__alltraps>

00102150 <vector71>:
.globl vector71
vector71:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $71
  102152:	6a 47                	push   $0x47
  jmp __alltraps
  102154:	e9 64 fd ff ff       	jmp    101ebd <__alltraps>

00102159 <vector72>:
.globl vector72
vector72:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $72
  10215b:	6a 48                	push   $0x48
  jmp __alltraps
  10215d:	e9 5b fd ff ff       	jmp    101ebd <__alltraps>

00102162 <vector73>:
.globl vector73
vector73:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $73
  102164:	6a 49                	push   $0x49
  jmp __alltraps
  102166:	e9 52 fd ff ff       	jmp    101ebd <__alltraps>

0010216b <vector74>:
.globl vector74
vector74:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $74
  10216d:	6a 4a                	push   $0x4a
  jmp __alltraps
  10216f:	e9 49 fd ff ff       	jmp    101ebd <__alltraps>

00102174 <vector75>:
.globl vector75
vector75:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $75
  102176:	6a 4b                	push   $0x4b
  jmp __alltraps
  102178:	e9 40 fd ff ff       	jmp    101ebd <__alltraps>

0010217d <vector76>:
.globl vector76
vector76:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $76
  10217f:	6a 4c                	push   $0x4c
  jmp __alltraps
  102181:	e9 37 fd ff ff       	jmp    101ebd <__alltraps>

00102186 <vector77>:
.globl vector77
vector77:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $77
  102188:	6a 4d                	push   $0x4d
  jmp __alltraps
  10218a:	e9 2e fd ff ff       	jmp    101ebd <__alltraps>

0010218f <vector78>:
.globl vector78
vector78:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $78
  102191:	6a 4e                	push   $0x4e
  jmp __alltraps
  102193:	e9 25 fd ff ff       	jmp    101ebd <__alltraps>

00102198 <vector79>:
.globl vector79
vector79:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $79
  10219a:	6a 4f                	push   $0x4f
  jmp __alltraps
  10219c:	e9 1c fd ff ff       	jmp    101ebd <__alltraps>

001021a1 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $80
  1021a3:	6a 50                	push   $0x50
  jmp __alltraps
  1021a5:	e9 13 fd ff ff       	jmp    101ebd <__alltraps>

001021aa <vector81>:
.globl vector81
vector81:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $81
  1021ac:	6a 51                	push   $0x51
  jmp __alltraps
  1021ae:	e9 0a fd ff ff       	jmp    101ebd <__alltraps>

001021b3 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $82
  1021b5:	6a 52                	push   $0x52
  jmp __alltraps
  1021b7:	e9 01 fd ff ff       	jmp    101ebd <__alltraps>

001021bc <vector83>:
.globl vector83
vector83:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $83
  1021be:	6a 53                	push   $0x53
  jmp __alltraps
  1021c0:	e9 f8 fc ff ff       	jmp    101ebd <__alltraps>

001021c5 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $84
  1021c7:	6a 54                	push   $0x54
  jmp __alltraps
  1021c9:	e9 ef fc ff ff       	jmp    101ebd <__alltraps>

001021ce <vector85>:
.globl vector85
vector85:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $85
  1021d0:	6a 55                	push   $0x55
  jmp __alltraps
  1021d2:	e9 e6 fc ff ff       	jmp    101ebd <__alltraps>

001021d7 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $86
  1021d9:	6a 56                	push   $0x56
  jmp __alltraps
  1021db:	e9 dd fc ff ff       	jmp    101ebd <__alltraps>

001021e0 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $87
  1021e2:	6a 57                	push   $0x57
  jmp __alltraps
  1021e4:	e9 d4 fc ff ff       	jmp    101ebd <__alltraps>

001021e9 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $88
  1021eb:	6a 58                	push   $0x58
  jmp __alltraps
  1021ed:	e9 cb fc ff ff       	jmp    101ebd <__alltraps>

001021f2 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $89
  1021f4:	6a 59                	push   $0x59
  jmp __alltraps
  1021f6:	e9 c2 fc ff ff       	jmp    101ebd <__alltraps>

001021fb <vector90>:
.globl vector90
vector90:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $90
  1021fd:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021ff:	e9 b9 fc ff ff       	jmp    101ebd <__alltraps>

00102204 <vector91>:
.globl vector91
vector91:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $91
  102206:	6a 5b                	push   $0x5b
  jmp __alltraps
  102208:	e9 b0 fc ff ff       	jmp    101ebd <__alltraps>

0010220d <vector92>:
.globl vector92
vector92:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $92
  10220f:	6a 5c                	push   $0x5c
  jmp __alltraps
  102211:	e9 a7 fc ff ff       	jmp    101ebd <__alltraps>

00102216 <vector93>:
.globl vector93
vector93:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $93
  102218:	6a 5d                	push   $0x5d
  jmp __alltraps
  10221a:	e9 9e fc ff ff       	jmp    101ebd <__alltraps>

0010221f <vector94>:
.globl vector94
vector94:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $94
  102221:	6a 5e                	push   $0x5e
  jmp __alltraps
  102223:	e9 95 fc ff ff       	jmp    101ebd <__alltraps>

00102228 <vector95>:
.globl vector95
vector95:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $95
  10222a:	6a 5f                	push   $0x5f
  jmp __alltraps
  10222c:	e9 8c fc ff ff       	jmp    101ebd <__alltraps>

00102231 <vector96>:
.globl vector96
vector96:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $96
  102233:	6a 60                	push   $0x60
  jmp __alltraps
  102235:	e9 83 fc ff ff       	jmp    101ebd <__alltraps>

0010223a <vector97>:
.globl vector97
vector97:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $97
  10223c:	6a 61                	push   $0x61
  jmp __alltraps
  10223e:	e9 7a fc ff ff       	jmp    101ebd <__alltraps>

00102243 <vector98>:
.globl vector98
vector98:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $98
  102245:	6a 62                	push   $0x62
  jmp __alltraps
  102247:	e9 71 fc ff ff       	jmp    101ebd <__alltraps>

0010224c <vector99>:
.globl vector99
vector99:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $99
  10224e:	6a 63                	push   $0x63
  jmp __alltraps
  102250:	e9 68 fc ff ff       	jmp    101ebd <__alltraps>

00102255 <vector100>:
.globl vector100
vector100:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $100
  102257:	6a 64                	push   $0x64
  jmp __alltraps
  102259:	e9 5f fc ff ff       	jmp    101ebd <__alltraps>

0010225e <vector101>:
.globl vector101
vector101:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $101
  102260:	6a 65                	push   $0x65
  jmp __alltraps
  102262:	e9 56 fc ff ff       	jmp    101ebd <__alltraps>

00102267 <vector102>:
.globl vector102
vector102:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $102
  102269:	6a 66                	push   $0x66
  jmp __alltraps
  10226b:	e9 4d fc ff ff       	jmp    101ebd <__alltraps>

00102270 <vector103>:
.globl vector103
vector103:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $103
  102272:	6a 67                	push   $0x67
  jmp __alltraps
  102274:	e9 44 fc ff ff       	jmp    101ebd <__alltraps>

00102279 <vector104>:
.globl vector104
vector104:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $104
  10227b:	6a 68                	push   $0x68
  jmp __alltraps
  10227d:	e9 3b fc ff ff       	jmp    101ebd <__alltraps>

00102282 <vector105>:
.globl vector105
vector105:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $105
  102284:	6a 69                	push   $0x69
  jmp __alltraps
  102286:	e9 32 fc ff ff       	jmp    101ebd <__alltraps>

0010228b <vector106>:
.globl vector106
vector106:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $106
  10228d:	6a 6a                	push   $0x6a
  jmp __alltraps
  10228f:	e9 29 fc ff ff       	jmp    101ebd <__alltraps>

00102294 <vector107>:
.globl vector107
vector107:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $107
  102296:	6a 6b                	push   $0x6b
  jmp __alltraps
  102298:	e9 20 fc ff ff       	jmp    101ebd <__alltraps>

0010229d <vector108>:
.globl vector108
vector108:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $108
  10229f:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022a1:	e9 17 fc ff ff       	jmp    101ebd <__alltraps>

001022a6 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $109
  1022a8:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022aa:	e9 0e fc ff ff       	jmp    101ebd <__alltraps>

001022af <vector110>:
.globl vector110
vector110:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $110
  1022b1:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022b3:	e9 05 fc ff ff       	jmp    101ebd <__alltraps>

001022b8 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $111
  1022ba:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022bc:	e9 fc fb ff ff       	jmp    101ebd <__alltraps>

001022c1 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $112
  1022c3:	6a 70                	push   $0x70
  jmp __alltraps
  1022c5:	e9 f3 fb ff ff       	jmp    101ebd <__alltraps>

001022ca <vector113>:
.globl vector113
vector113:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $113
  1022cc:	6a 71                	push   $0x71
  jmp __alltraps
  1022ce:	e9 ea fb ff ff       	jmp    101ebd <__alltraps>

001022d3 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $114
  1022d5:	6a 72                	push   $0x72
  jmp __alltraps
  1022d7:	e9 e1 fb ff ff       	jmp    101ebd <__alltraps>

001022dc <vector115>:
.globl vector115
vector115:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $115
  1022de:	6a 73                	push   $0x73
  jmp __alltraps
  1022e0:	e9 d8 fb ff ff       	jmp    101ebd <__alltraps>

001022e5 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $116
  1022e7:	6a 74                	push   $0x74
  jmp __alltraps
  1022e9:	e9 cf fb ff ff       	jmp    101ebd <__alltraps>

001022ee <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $117
  1022f0:	6a 75                	push   $0x75
  jmp __alltraps
  1022f2:	e9 c6 fb ff ff       	jmp    101ebd <__alltraps>

001022f7 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $118
  1022f9:	6a 76                	push   $0x76
  jmp __alltraps
  1022fb:	e9 bd fb ff ff       	jmp    101ebd <__alltraps>

00102300 <vector119>:
.globl vector119
vector119:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $119
  102302:	6a 77                	push   $0x77
  jmp __alltraps
  102304:	e9 b4 fb ff ff       	jmp    101ebd <__alltraps>

00102309 <vector120>:
.globl vector120
vector120:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $120
  10230b:	6a 78                	push   $0x78
  jmp __alltraps
  10230d:	e9 ab fb ff ff       	jmp    101ebd <__alltraps>

00102312 <vector121>:
.globl vector121
vector121:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $121
  102314:	6a 79                	push   $0x79
  jmp __alltraps
  102316:	e9 a2 fb ff ff       	jmp    101ebd <__alltraps>

0010231b <vector122>:
.globl vector122
vector122:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $122
  10231d:	6a 7a                	push   $0x7a
  jmp __alltraps
  10231f:	e9 99 fb ff ff       	jmp    101ebd <__alltraps>

00102324 <vector123>:
.globl vector123
vector123:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $123
  102326:	6a 7b                	push   $0x7b
  jmp __alltraps
  102328:	e9 90 fb ff ff       	jmp    101ebd <__alltraps>

0010232d <vector124>:
.globl vector124
vector124:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $124
  10232f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102331:	e9 87 fb ff ff       	jmp    101ebd <__alltraps>

00102336 <vector125>:
.globl vector125
vector125:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $125
  102338:	6a 7d                	push   $0x7d
  jmp __alltraps
  10233a:	e9 7e fb ff ff       	jmp    101ebd <__alltraps>

0010233f <vector126>:
.globl vector126
vector126:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $126
  102341:	6a 7e                	push   $0x7e
  jmp __alltraps
  102343:	e9 75 fb ff ff       	jmp    101ebd <__alltraps>

00102348 <vector127>:
.globl vector127
vector127:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $127
  10234a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10234c:	e9 6c fb ff ff       	jmp    101ebd <__alltraps>

00102351 <vector128>:
.globl vector128
vector128:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $128
  102353:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102358:	e9 60 fb ff ff       	jmp    101ebd <__alltraps>

0010235d <vector129>:
.globl vector129
vector129:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $129
  10235f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102364:	e9 54 fb ff ff       	jmp    101ebd <__alltraps>

00102369 <vector130>:
.globl vector130
vector130:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $130
  10236b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102370:	e9 48 fb ff ff       	jmp    101ebd <__alltraps>

00102375 <vector131>:
.globl vector131
vector131:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $131
  102377:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10237c:	e9 3c fb ff ff       	jmp    101ebd <__alltraps>

00102381 <vector132>:
.globl vector132
vector132:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $132
  102383:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102388:	e9 30 fb ff ff       	jmp    101ebd <__alltraps>

0010238d <vector133>:
.globl vector133
vector133:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $133
  10238f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102394:	e9 24 fb ff ff       	jmp    101ebd <__alltraps>

00102399 <vector134>:
.globl vector134
vector134:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $134
  10239b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023a0:	e9 18 fb ff ff       	jmp    101ebd <__alltraps>

001023a5 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $135
  1023a7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023ac:	e9 0c fb ff ff       	jmp    101ebd <__alltraps>

001023b1 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $136
  1023b3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023b8:	e9 00 fb ff ff       	jmp    101ebd <__alltraps>

001023bd <vector137>:
.globl vector137
vector137:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $137
  1023bf:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023c4:	e9 f4 fa ff ff       	jmp    101ebd <__alltraps>

001023c9 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $138
  1023cb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023d0:	e9 e8 fa ff ff       	jmp    101ebd <__alltraps>

001023d5 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $139
  1023d7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023dc:	e9 dc fa ff ff       	jmp    101ebd <__alltraps>

001023e1 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $140
  1023e3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023e8:	e9 d0 fa ff ff       	jmp    101ebd <__alltraps>

001023ed <vector141>:
.globl vector141
vector141:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $141
  1023ef:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023f4:	e9 c4 fa ff ff       	jmp    101ebd <__alltraps>

001023f9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $142
  1023fb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102400:	e9 b8 fa ff ff       	jmp    101ebd <__alltraps>

00102405 <vector143>:
.globl vector143
vector143:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $143
  102407:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10240c:	e9 ac fa ff ff       	jmp    101ebd <__alltraps>

00102411 <vector144>:
.globl vector144
vector144:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $144
  102413:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102418:	e9 a0 fa ff ff       	jmp    101ebd <__alltraps>

0010241d <vector145>:
.globl vector145
vector145:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $145
  10241f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102424:	e9 94 fa ff ff       	jmp    101ebd <__alltraps>

00102429 <vector146>:
.globl vector146
vector146:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $146
  10242b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102430:	e9 88 fa ff ff       	jmp    101ebd <__alltraps>

00102435 <vector147>:
.globl vector147
vector147:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $147
  102437:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10243c:	e9 7c fa ff ff       	jmp    101ebd <__alltraps>

00102441 <vector148>:
.globl vector148
vector148:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $148
  102443:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102448:	e9 70 fa ff ff       	jmp    101ebd <__alltraps>

0010244d <vector149>:
.globl vector149
vector149:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $149
  10244f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102454:	e9 64 fa ff ff       	jmp    101ebd <__alltraps>

00102459 <vector150>:
.globl vector150
vector150:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $150
  10245b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102460:	e9 58 fa ff ff       	jmp    101ebd <__alltraps>

00102465 <vector151>:
.globl vector151
vector151:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $151
  102467:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10246c:	e9 4c fa ff ff       	jmp    101ebd <__alltraps>

00102471 <vector152>:
.globl vector152
vector152:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $152
  102473:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102478:	e9 40 fa ff ff       	jmp    101ebd <__alltraps>

0010247d <vector153>:
.globl vector153
vector153:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $153
  10247f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102484:	e9 34 fa ff ff       	jmp    101ebd <__alltraps>

00102489 <vector154>:
.globl vector154
vector154:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $154
  10248b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102490:	e9 28 fa ff ff       	jmp    101ebd <__alltraps>

00102495 <vector155>:
.globl vector155
vector155:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $155
  102497:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10249c:	e9 1c fa ff ff       	jmp    101ebd <__alltraps>

001024a1 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $156
  1024a3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024a8:	e9 10 fa ff ff       	jmp    101ebd <__alltraps>

001024ad <vector157>:
.globl vector157
vector157:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $157
  1024af:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024b4:	e9 04 fa ff ff       	jmp    101ebd <__alltraps>

001024b9 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $158
  1024bb:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024c0:	e9 f8 f9 ff ff       	jmp    101ebd <__alltraps>

001024c5 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $159
  1024c7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024cc:	e9 ec f9 ff ff       	jmp    101ebd <__alltraps>

001024d1 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $160
  1024d3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024d8:	e9 e0 f9 ff ff       	jmp    101ebd <__alltraps>

001024dd <vector161>:
.globl vector161
vector161:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $161
  1024df:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024e4:	e9 d4 f9 ff ff       	jmp    101ebd <__alltraps>

001024e9 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $162
  1024eb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024f0:	e9 c8 f9 ff ff       	jmp    101ebd <__alltraps>

001024f5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $163
  1024f7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024fc:	e9 bc f9 ff ff       	jmp    101ebd <__alltraps>

00102501 <vector164>:
.globl vector164
vector164:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $164
  102503:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102508:	e9 b0 f9 ff ff       	jmp    101ebd <__alltraps>

0010250d <vector165>:
.globl vector165
vector165:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $165
  10250f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102514:	e9 a4 f9 ff ff       	jmp    101ebd <__alltraps>

00102519 <vector166>:
.globl vector166
vector166:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $166
  10251b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102520:	e9 98 f9 ff ff       	jmp    101ebd <__alltraps>

00102525 <vector167>:
.globl vector167
vector167:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $167
  102527:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10252c:	e9 8c f9 ff ff       	jmp    101ebd <__alltraps>

00102531 <vector168>:
.globl vector168
vector168:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $168
  102533:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102538:	e9 80 f9 ff ff       	jmp    101ebd <__alltraps>

0010253d <vector169>:
.globl vector169
vector169:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $169
  10253f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102544:	e9 74 f9 ff ff       	jmp    101ebd <__alltraps>

00102549 <vector170>:
.globl vector170
vector170:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $170
  10254b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102550:	e9 68 f9 ff ff       	jmp    101ebd <__alltraps>

00102555 <vector171>:
.globl vector171
vector171:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $171
  102557:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10255c:	e9 5c f9 ff ff       	jmp    101ebd <__alltraps>

00102561 <vector172>:
.globl vector172
vector172:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $172
  102563:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102568:	e9 50 f9 ff ff       	jmp    101ebd <__alltraps>

0010256d <vector173>:
.globl vector173
vector173:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $173
  10256f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102574:	e9 44 f9 ff ff       	jmp    101ebd <__alltraps>

00102579 <vector174>:
.globl vector174
vector174:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $174
  10257b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102580:	e9 38 f9 ff ff       	jmp    101ebd <__alltraps>

00102585 <vector175>:
.globl vector175
vector175:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $175
  102587:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10258c:	e9 2c f9 ff ff       	jmp    101ebd <__alltraps>

00102591 <vector176>:
.globl vector176
vector176:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $176
  102593:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102598:	e9 20 f9 ff ff       	jmp    101ebd <__alltraps>

0010259d <vector177>:
.globl vector177
vector177:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $177
  10259f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025a4:	e9 14 f9 ff ff       	jmp    101ebd <__alltraps>

001025a9 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $178
  1025ab:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025b0:	e9 08 f9 ff ff       	jmp    101ebd <__alltraps>

001025b5 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $179
  1025b7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025bc:	e9 fc f8 ff ff       	jmp    101ebd <__alltraps>

001025c1 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $180
  1025c3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025c8:	e9 f0 f8 ff ff       	jmp    101ebd <__alltraps>

001025cd <vector181>:
.globl vector181
vector181:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $181
  1025cf:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025d4:	e9 e4 f8 ff ff       	jmp    101ebd <__alltraps>

001025d9 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $182
  1025db:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025e0:	e9 d8 f8 ff ff       	jmp    101ebd <__alltraps>

001025e5 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $183
  1025e7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025ec:	e9 cc f8 ff ff       	jmp    101ebd <__alltraps>

001025f1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $184
  1025f3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025f8:	e9 c0 f8 ff ff       	jmp    101ebd <__alltraps>

001025fd <vector185>:
.globl vector185
vector185:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $185
  1025ff:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102604:	e9 b4 f8 ff ff       	jmp    101ebd <__alltraps>

00102609 <vector186>:
.globl vector186
vector186:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $186
  10260b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102610:	e9 a8 f8 ff ff       	jmp    101ebd <__alltraps>

00102615 <vector187>:
.globl vector187
vector187:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $187
  102617:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10261c:	e9 9c f8 ff ff       	jmp    101ebd <__alltraps>

00102621 <vector188>:
.globl vector188
vector188:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $188
  102623:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102628:	e9 90 f8 ff ff       	jmp    101ebd <__alltraps>

0010262d <vector189>:
.globl vector189
vector189:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $189
  10262f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102634:	e9 84 f8 ff ff       	jmp    101ebd <__alltraps>

00102639 <vector190>:
.globl vector190
vector190:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $190
  10263b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102640:	e9 78 f8 ff ff       	jmp    101ebd <__alltraps>

00102645 <vector191>:
.globl vector191
vector191:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $191
  102647:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10264c:	e9 6c f8 ff ff       	jmp    101ebd <__alltraps>

00102651 <vector192>:
.globl vector192
vector192:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $192
  102653:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102658:	e9 60 f8 ff ff       	jmp    101ebd <__alltraps>

0010265d <vector193>:
.globl vector193
vector193:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $193
  10265f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102664:	e9 54 f8 ff ff       	jmp    101ebd <__alltraps>

00102669 <vector194>:
.globl vector194
vector194:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $194
  10266b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102670:	e9 48 f8 ff ff       	jmp    101ebd <__alltraps>

00102675 <vector195>:
.globl vector195
vector195:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $195
  102677:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10267c:	e9 3c f8 ff ff       	jmp    101ebd <__alltraps>

00102681 <vector196>:
.globl vector196
vector196:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $196
  102683:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102688:	e9 30 f8 ff ff       	jmp    101ebd <__alltraps>

0010268d <vector197>:
.globl vector197
vector197:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $197
  10268f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102694:	e9 24 f8 ff ff       	jmp    101ebd <__alltraps>

00102699 <vector198>:
.globl vector198
vector198:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $198
  10269b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026a0:	e9 18 f8 ff ff       	jmp    101ebd <__alltraps>

001026a5 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $199
  1026a7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026ac:	e9 0c f8 ff ff       	jmp    101ebd <__alltraps>

001026b1 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $200
  1026b3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026b8:	e9 00 f8 ff ff       	jmp    101ebd <__alltraps>

001026bd <vector201>:
.globl vector201
vector201:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $201
  1026bf:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026c4:	e9 f4 f7 ff ff       	jmp    101ebd <__alltraps>

001026c9 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $202
  1026cb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026d0:	e9 e8 f7 ff ff       	jmp    101ebd <__alltraps>

001026d5 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $203
  1026d7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026dc:	e9 dc f7 ff ff       	jmp    101ebd <__alltraps>

001026e1 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $204
  1026e3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026e8:	e9 d0 f7 ff ff       	jmp    101ebd <__alltraps>

001026ed <vector205>:
.globl vector205
vector205:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $205
  1026ef:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026f4:	e9 c4 f7 ff ff       	jmp    101ebd <__alltraps>

001026f9 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $206
  1026fb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102700:	e9 b8 f7 ff ff       	jmp    101ebd <__alltraps>

00102705 <vector207>:
.globl vector207
vector207:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $207
  102707:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10270c:	e9 ac f7 ff ff       	jmp    101ebd <__alltraps>

00102711 <vector208>:
.globl vector208
vector208:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $208
  102713:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102718:	e9 a0 f7 ff ff       	jmp    101ebd <__alltraps>

0010271d <vector209>:
.globl vector209
vector209:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $209
  10271f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102724:	e9 94 f7 ff ff       	jmp    101ebd <__alltraps>

00102729 <vector210>:
.globl vector210
vector210:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $210
  10272b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102730:	e9 88 f7 ff ff       	jmp    101ebd <__alltraps>

00102735 <vector211>:
.globl vector211
vector211:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $211
  102737:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10273c:	e9 7c f7 ff ff       	jmp    101ebd <__alltraps>

00102741 <vector212>:
.globl vector212
vector212:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $212
  102743:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102748:	e9 70 f7 ff ff       	jmp    101ebd <__alltraps>

0010274d <vector213>:
.globl vector213
vector213:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $213
  10274f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102754:	e9 64 f7 ff ff       	jmp    101ebd <__alltraps>

00102759 <vector214>:
.globl vector214
vector214:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $214
  10275b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102760:	e9 58 f7 ff ff       	jmp    101ebd <__alltraps>

00102765 <vector215>:
.globl vector215
vector215:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $215
  102767:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10276c:	e9 4c f7 ff ff       	jmp    101ebd <__alltraps>

00102771 <vector216>:
.globl vector216
vector216:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $216
  102773:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102778:	e9 40 f7 ff ff       	jmp    101ebd <__alltraps>

0010277d <vector217>:
.globl vector217
vector217:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $217
  10277f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102784:	e9 34 f7 ff ff       	jmp    101ebd <__alltraps>

00102789 <vector218>:
.globl vector218
vector218:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $218
  10278b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102790:	e9 28 f7 ff ff       	jmp    101ebd <__alltraps>

00102795 <vector219>:
.globl vector219
vector219:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $219
  102797:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10279c:	e9 1c f7 ff ff       	jmp    101ebd <__alltraps>

001027a1 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $220
  1027a3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027a8:	e9 10 f7 ff ff       	jmp    101ebd <__alltraps>

001027ad <vector221>:
.globl vector221
vector221:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $221
  1027af:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027b4:	e9 04 f7 ff ff       	jmp    101ebd <__alltraps>

001027b9 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $222
  1027bb:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027c0:	e9 f8 f6 ff ff       	jmp    101ebd <__alltraps>

001027c5 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $223
  1027c7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027cc:	e9 ec f6 ff ff       	jmp    101ebd <__alltraps>

001027d1 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $224
  1027d3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027d8:	e9 e0 f6 ff ff       	jmp    101ebd <__alltraps>

001027dd <vector225>:
.globl vector225
vector225:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $225
  1027df:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027e4:	e9 d4 f6 ff ff       	jmp    101ebd <__alltraps>

001027e9 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $226
  1027eb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027f0:	e9 c8 f6 ff ff       	jmp    101ebd <__alltraps>

001027f5 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $227
  1027f7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027fc:	e9 bc f6 ff ff       	jmp    101ebd <__alltraps>

00102801 <vector228>:
.globl vector228
vector228:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $228
  102803:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102808:	e9 b0 f6 ff ff       	jmp    101ebd <__alltraps>

0010280d <vector229>:
.globl vector229
vector229:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $229
  10280f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102814:	e9 a4 f6 ff ff       	jmp    101ebd <__alltraps>

00102819 <vector230>:
.globl vector230
vector230:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $230
  10281b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102820:	e9 98 f6 ff ff       	jmp    101ebd <__alltraps>

00102825 <vector231>:
.globl vector231
vector231:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $231
  102827:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10282c:	e9 8c f6 ff ff       	jmp    101ebd <__alltraps>

00102831 <vector232>:
.globl vector232
vector232:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $232
  102833:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102838:	e9 80 f6 ff ff       	jmp    101ebd <__alltraps>

0010283d <vector233>:
.globl vector233
vector233:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $233
  10283f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102844:	e9 74 f6 ff ff       	jmp    101ebd <__alltraps>

00102849 <vector234>:
.globl vector234
vector234:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $234
  10284b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102850:	e9 68 f6 ff ff       	jmp    101ebd <__alltraps>

00102855 <vector235>:
.globl vector235
vector235:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $235
  102857:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10285c:	e9 5c f6 ff ff       	jmp    101ebd <__alltraps>

00102861 <vector236>:
.globl vector236
vector236:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $236
  102863:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102868:	e9 50 f6 ff ff       	jmp    101ebd <__alltraps>

0010286d <vector237>:
.globl vector237
vector237:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $237
  10286f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102874:	e9 44 f6 ff ff       	jmp    101ebd <__alltraps>

00102879 <vector238>:
.globl vector238
vector238:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $238
  10287b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102880:	e9 38 f6 ff ff       	jmp    101ebd <__alltraps>

00102885 <vector239>:
.globl vector239
vector239:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $239
  102887:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10288c:	e9 2c f6 ff ff       	jmp    101ebd <__alltraps>

00102891 <vector240>:
.globl vector240
vector240:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $240
  102893:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102898:	e9 20 f6 ff ff       	jmp    101ebd <__alltraps>

0010289d <vector241>:
.globl vector241
vector241:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $241
  10289f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028a4:	e9 14 f6 ff ff       	jmp    101ebd <__alltraps>

001028a9 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $242
  1028ab:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028b0:	e9 08 f6 ff ff       	jmp    101ebd <__alltraps>

001028b5 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $243
  1028b7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028bc:	e9 fc f5 ff ff       	jmp    101ebd <__alltraps>

001028c1 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $244
  1028c3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028c8:	e9 f0 f5 ff ff       	jmp    101ebd <__alltraps>

001028cd <vector245>:
.globl vector245
vector245:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $245
  1028cf:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028d4:	e9 e4 f5 ff ff       	jmp    101ebd <__alltraps>

001028d9 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $246
  1028db:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028e0:	e9 d8 f5 ff ff       	jmp    101ebd <__alltraps>

001028e5 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $247
  1028e7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028ec:	e9 cc f5 ff ff       	jmp    101ebd <__alltraps>

001028f1 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $248
  1028f3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028f8:	e9 c0 f5 ff ff       	jmp    101ebd <__alltraps>

001028fd <vector249>:
.globl vector249
vector249:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $249
  1028ff:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102904:	e9 b4 f5 ff ff       	jmp    101ebd <__alltraps>

00102909 <vector250>:
.globl vector250
vector250:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $250
  10290b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102910:	e9 a8 f5 ff ff       	jmp    101ebd <__alltraps>

00102915 <vector251>:
.globl vector251
vector251:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $251
  102917:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10291c:	e9 9c f5 ff ff       	jmp    101ebd <__alltraps>

00102921 <vector252>:
.globl vector252
vector252:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $252
  102923:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102928:	e9 90 f5 ff ff       	jmp    101ebd <__alltraps>

0010292d <vector253>:
.globl vector253
vector253:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $253
  10292f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102934:	e9 84 f5 ff ff       	jmp    101ebd <__alltraps>

00102939 <vector254>:
.globl vector254
vector254:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $254
  10293b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102940:	e9 78 f5 ff ff       	jmp    101ebd <__alltraps>

00102945 <vector255>:
.globl vector255
vector255:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $255
  102947:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10294c:	e9 6c f5 ff ff       	jmp    101ebd <__alltraps>

00102951 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102951:	55                   	push   %ebp
  102952:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102954:	8b 45 08             	mov    0x8(%ebp),%eax
  102957:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10295a:	b8 23 00 00 00       	mov    $0x23,%eax
  10295f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102961:	b8 23 00 00 00       	mov    $0x23,%eax
  102966:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102968:	b8 10 00 00 00       	mov    $0x10,%eax
  10296d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10296f:	b8 10 00 00 00       	mov    $0x10,%eax
  102974:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102976:	b8 10 00 00 00       	mov    $0x10,%eax
  10297b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10297d:	ea 84 29 10 00 08 00 	ljmp   $0x8,$0x102984
}
  102984:	5d                   	pop    %ebp
  102985:	c3                   	ret    

00102986 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102986:	55                   	push   %ebp
  102987:	89 e5                	mov    %esp,%ebp
  102989:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10298c:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102991:	05 00 04 00 00       	add    $0x400,%eax
  102996:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10299b:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029a2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029a4:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029ab:	68 00 
  1029ad:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029b2:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029b8:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029bd:	c1 e8 10             	shr    $0x10,%eax
  1029c0:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029c5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029cc:	83 e0 f0             	and    $0xfffffff0,%eax
  1029cf:	83 c8 09             	or     $0x9,%eax
  1029d2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029de:	83 c8 10             	or     $0x10,%eax
  1029e1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ed:	83 e0 9f             	and    $0xffffff9f,%eax
  1029f0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029f5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029fc:	83 c8 80             	or     $0xffffff80,%eax
  1029ff:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a04:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0b:	83 e0 f0             	and    $0xfffffff0,%eax
  102a0e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a13:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a1a:	83 e0 ef             	and    $0xffffffef,%eax
  102a1d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a22:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a29:	83 e0 df             	and    $0xffffffdf,%eax
  102a2c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a31:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a38:	83 c8 40             	or     $0x40,%eax
  102a3b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a40:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a47:	83 e0 7f             	and    $0x7f,%eax
  102a4a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a4f:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a54:	c1 e8 18             	shr    $0x18,%eax
  102a57:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a5c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a63:	83 e0 ef             	and    $0xffffffef,%eax
  102a66:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a6b:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a72:	e8 da fe ff ff       	call   102951 <lgdt>
  102a77:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a7d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a81:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a84:	c9                   	leave  
  102a85:	c3                   	ret    

00102a86 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a86:	55                   	push   %ebp
  102a87:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a89:	e8 f8 fe ff ff       	call   102986 <gdt_init>
}
  102a8e:	5d                   	pop    %ebp
  102a8f:	c3                   	ret    

00102a90 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a90:	55                   	push   %ebp
  102a91:	89 e5                	mov    %esp,%ebp
  102a93:	83 ec 58             	sub    $0x58,%esp
  102a96:	8b 45 10             	mov    0x10(%ebp),%eax
  102a99:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  102a9f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102aa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102aa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aab:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102aae:	8b 45 18             	mov    0x18(%ebp),%eax
  102ab1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ab7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102aba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102abd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ac6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102aca:	74 1c                	je     102ae8 <printnum+0x58>
  102acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102acf:	ba 00 00 00 00       	mov    $0x0,%edx
  102ad4:	f7 75 e4             	divl   -0x1c(%ebp)
  102ad7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102add:	ba 00 00 00 00       	mov    $0x0,%edx
  102ae2:	f7 75 e4             	divl   -0x1c(%ebp)
  102ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102aee:	f7 75 e4             	divl   -0x1c(%ebp)
  102af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102af4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102afa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102afd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b00:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b06:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b09:	8b 45 18             	mov    0x18(%ebp),%eax
  102b0c:	ba 00 00 00 00       	mov    $0x0,%edx
  102b11:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b14:	77 56                	ja     102b6c <printnum+0xdc>
  102b16:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b19:	72 05                	jb     102b20 <printnum+0x90>
  102b1b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102b1e:	77 4c                	ja     102b6c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b20:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b23:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b26:	8b 45 20             	mov    0x20(%ebp),%eax
  102b29:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b2d:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b31:	8b 45 18             	mov    0x18(%ebp),%eax
  102b34:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b42:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b50:	89 04 24             	mov    %eax,(%esp)
  102b53:	e8 38 ff ff ff       	call   102a90 <printnum>
  102b58:	eb 1c                	jmp    102b76 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b61:	8b 45 20             	mov    0x20(%ebp),%eax
  102b64:	89 04 24             	mov    %eax,(%esp)
  102b67:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6a:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b6c:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b70:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b74:	7f e4                	jg     102b5a <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b76:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b79:	05 70 3d 10 00       	add    $0x103d70,%eax
  102b7e:	0f b6 00             	movzbl (%eax),%eax
  102b81:	0f be c0             	movsbl %al,%eax
  102b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b87:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b8b:	89 04 24             	mov    %eax,(%esp)
  102b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b91:	ff d0                	call   *%eax
}
  102b93:	c9                   	leave  
  102b94:	c3                   	ret    

00102b95 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b95:	55                   	push   %ebp
  102b96:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b98:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b9c:	7e 14                	jle    102bb2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba1:	8b 00                	mov    (%eax),%eax
  102ba3:	8d 48 08             	lea    0x8(%eax),%ecx
  102ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  102ba9:	89 0a                	mov    %ecx,(%edx)
  102bab:	8b 50 04             	mov    0x4(%eax),%edx
  102bae:	8b 00                	mov    (%eax),%eax
  102bb0:	eb 30                	jmp    102be2 <getuint+0x4d>
    }
    else if (lflag) {
  102bb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bb6:	74 16                	je     102bce <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbb:	8b 00                	mov    (%eax),%eax
  102bbd:	8d 48 04             	lea    0x4(%eax),%ecx
  102bc0:	8b 55 08             	mov    0x8(%ebp),%edx
  102bc3:	89 0a                	mov    %ecx,(%edx)
  102bc5:	8b 00                	mov    (%eax),%eax
  102bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  102bcc:	eb 14                	jmp    102be2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bce:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd1:	8b 00                	mov    (%eax),%eax
  102bd3:	8d 48 04             	lea    0x4(%eax),%ecx
  102bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  102bd9:	89 0a                	mov    %ecx,(%edx)
  102bdb:	8b 00                	mov    (%eax),%eax
  102bdd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102be2:	5d                   	pop    %ebp
  102be3:	c3                   	ret    

00102be4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102be4:	55                   	push   %ebp
  102be5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102be7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102beb:	7e 14                	jle    102c01 <getint+0x1d>
        return va_arg(*ap, long long);
  102bed:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf0:	8b 00                	mov    (%eax),%eax
  102bf2:	8d 48 08             	lea    0x8(%eax),%ecx
  102bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  102bf8:	89 0a                	mov    %ecx,(%edx)
  102bfa:	8b 50 04             	mov    0x4(%eax),%edx
  102bfd:	8b 00                	mov    (%eax),%eax
  102bff:	eb 28                	jmp    102c29 <getint+0x45>
    }
    else if (lflag) {
  102c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c05:	74 12                	je     102c19 <getint+0x35>
        return va_arg(*ap, long);
  102c07:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0a:	8b 00                	mov    (%eax),%eax
  102c0c:	8d 48 04             	lea    0x4(%eax),%ecx
  102c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  102c12:	89 0a                	mov    %ecx,(%edx)
  102c14:	8b 00                	mov    (%eax),%eax
  102c16:	99                   	cltd   
  102c17:	eb 10                	jmp    102c29 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c19:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1c:	8b 00                	mov    (%eax),%eax
  102c1e:	8d 48 04             	lea    0x4(%eax),%ecx
  102c21:	8b 55 08             	mov    0x8(%ebp),%edx
  102c24:	89 0a                	mov    %ecx,(%edx)
  102c26:	8b 00                	mov    (%eax),%eax
  102c28:	99                   	cltd   
    }
}
  102c29:	5d                   	pop    %ebp
  102c2a:	c3                   	ret    

00102c2b <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c2b:	55                   	push   %ebp
  102c2c:	89 e5                	mov    %esp,%ebp
  102c2e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c31:	8d 45 14             	lea    0x14(%ebp),%eax
  102c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  102c41:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4f:	89 04 24             	mov    %eax,(%esp)
  102c52:	e8 02 00 00 00       	call   102c59 <vprintfmt>
    va_end(ap);
}
  102c57:	c9                   	leave  
  102c58:	c3                   	ret    

00102c59 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c59:	55                   	push   %ebp
  102c5a:	89 e5                	mov    %esp,%ebp
  102c5c:	56                   	push   %esi
  102c5d:	53                   	push   %ebx
  102c5e:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c61:	eb 18                	jmp    102c7b <vprintfmt+0x22>
            if (ch == '\0') {
  102c63:	85 db                	test   %ebx,%ebx
  102c65:	75 05                	jne    102c6c <vprintfmt+0x13>
                return;
  102c67:	e9 d1 03 00 00       	jmp    10303d <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c73:	89 1c 24             	mov    %ebx,(%esp)
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c7b:	8b 45 10             	mov    0x10(%ebp),%eax
  102c7e:	8d 50 01             	lea    0x1(%eax),%edx
  102c81:	89 55 10             	mov    %edx,0x10(%ebp)
  102c84:	0f b6 00             	movzbl (%eax),%eax
  102c87:	0f b6 d8             	movzbl %al,%ebx
  102c8a:	83 fb 25             	cmp    $0x25,%ebx
  102c8d:	75 d4                	jne    102c63 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c8f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c93:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ca0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ca7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102caa:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cad:	8b 45 10             	mov    0x10(%ebp),%eax
  102cb0:	8d 50 01             	lea    0x1(%eax),%edx
  102cb3:	89 55 10             	mov    %edx,0x10(%ebp)
  102cb6:	0f b6 00             	movzbl (%eax),%eax
  102cb9:	0f b6 d8             	movzbl %al,%ebx
  102cbc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102cbf:	83 f8 55             	cmp    $0x55,%eax
  102cc2:	0f 87 44 03 00 00    	ja     10300c <vprintfmt+0x3b3>
  102cc8:	8b 04 85 94 3d 10 00 	mov    0x103d94(,%eax,4),%eax
  102ccf:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cd1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cd5:	eb d6                	jmp    102cad <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102cd7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102cdb:	eb d0                	jmp    102cad <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cdd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ce4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ce7:	89 d0                	mov    %edx,%eax
  102ce9:	c1 e0 02             	shl    $0x2,%eax
  102cec:	01 d0                	add    %edx,%eax
  102cee:	01 c0                	add    %eax,%eax
  102cf0:	01 d8                	add    %ebx,%eax
  102cf2:	83 e8 30             	sub    $0x30,%eax
  102cf5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102cf8:	8b 45 10             	mov    0x10(%ebp),%eax
  102cfb:	0f b6 00             	movzbl (%eax),%eax
  102cfe:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d01:	83 fb 2f             	cmp    $0x2f,%ebx
  102d04:	7e 0b                	jle    102d11 <vprintfmt+0xb8>
  102d06:	83 fb 39             	cmp    $0x39,%ebx
  102d09:	7f 06                	jg     102d11 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d0b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102d0f:	eb d3                	jmp    102ce4 <vprintfmt+0x8b>
            goto process_precision;
  102d11:	eb 33                	jmp    102d46 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102d13:	8b 45 14             	mov    0x14(%ebp),%eax
  102d16:	8d 50 04             	lea    0x4(%eax),%edx
  102d19:	89 55 14             	mov    %edx,0x14(%ebp)
  102d1c:	8b 00                	mov    (%eax),%eax
  102d1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d21:	eb 23                	jmp    102d46 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102d23:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d27:	79 0c                	jns    102d35 <vprintfmt+0xdc>
                width = 0;
  102d29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d30:	e9 78 ff ff ff       	jmp    102cad <vprintfmt+0x54>
  102d35:	e9 73 ff ff ff       	jmp    102cad <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d41:	e9 67 ff ff ff       	jmp    102cad <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d4a:	79 12                	jns    102d5e <vprintfmt+0x105>
                width = precision, precision = -1;
  102d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d52:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d59:	e9 4f ff ff ff       	jmp    102cad <vprintfmt+0x54>
  102d5e:	e9 4a ff ff ff       	jmp    102cad <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d63:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d67:	e9 41 ff ff ff       	jmp    102cad <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  102d6f:	8d 50 04             	lea    0x4(%eax),%edx
  102d72:	89 55 14             	mov    %edx,0x14(%ebp)
  102d75:	8b 00                	mov    (%eax),%eax
  102d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d7a:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d7e:	89 04 24             	mov    %eax,(%esp)
  102d81:	8b 45 08             	mov    0x8(%ebp),%eax
  102d84:	ff d0                	call   *%eax
            break;
  102d86:	e9 ac 02 00 00       	jmp    103037 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  102d8e:	8d 50 04             	lea    0x4(%eax),%edx
  102d91:	89 55 14             	mov    %edx,0x14(%ebp)
  102d94:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d96:	85 db                	test   %ebx,%ebx
  102d98:	79 02                	jns    102d9c <vprintfmt+0x143>
                err = -err;
  102d9a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d9c:	83 fb 06             	cmp    $0x6,%ebx
  102d9f:	7f 0b                	jg     102dac <vprintfmt+0x153>
  102da1:	8b 34 9d 54 3d 10 00 	mov    0x103d54(,%ebx,4),%esi
  102da8:	85 f6                	test   %esi,%esi
  102daa:	75 23                	jne    102dcf <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102dac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102db0:	c7 44 24 08 81 3d 10 	movl   $0x103d81,0x8(%esp)
  102db7:	00 
  102db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc2:	89 04 24             	mov    %eax,(%esp)
  102dc5:	e8 61 fe ff ff       	call   102c2b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102dca:	e9 68 02 00 00       	jmp    103037 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102dcf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102dd3:	c7 44 24 08 8a 3d 10 	movl   $0x103d8a,0x8(%esp)
  102dda:	00 
  102ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dde:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de2:	8b 45 08             	mov    0x8(%ebp),%eax
  102de5:	89 04 24             	mov    %eax,(%esp)
  102de8:	e8 3e fe ff ff       	call   102c2b <printfmt>
            }
            break;
  102ded:	e9 45 02 00 00       	jmp    103037 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102df2:	8b 45 14             	mov    0x14(%ebp),%eax
  102df5:	8d 50 04             	lea    0x4(%eax),%edx
  102df8:	89 55 14             	mov    %edx,0x14(%ebp)
  102dfb:	8b 30                	mov    (%eax),%esi
  102dfd:	85 f6                	test   %esi,%esi
  102dff:	75 05                	jne    102e06 <vprintfmt+0x1ad>
                p = "(null)";
  102e01:	be 8d 3d 10 00       	mov    $0x103d8d,%esi
            }
            if (width > 0 && padc != '-') {
  102e06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e0a:	7e 3e                	jle    102e4a <vprintfmt+0x1f1>
  102e0c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e10:	74 38                	je     102e4a <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e12:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1c:	89 34 24             	mov    %esi,(%esp)
  102e1f:	e8 15 03 00 00       	call   103139 <strnlen>
  102e24:	29 c3                	sub    %eax,%ebx
  102e26:	89 d8                	mov    %ebx,%eax
  102e28:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e2b:	eb 17                	jmp    102e44 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e2d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e34:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e38:	89 04 24             	mov    %eax,(%esp)
  102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e40:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e48:	7f e3                	jg     102e2d <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e4a:	eb 38                	jmp    102e84 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e50:	74 1f                	je     102e71 <vprintfmt+0x218>
  102e52:	83 fb 1f             	cmp    $0x1f,%ebx
  102e55:	7e 05                	jle    102e5c <vprintfmt+0x203>
  102e57:	83 fb 7e             	cmp    $0x7e,%ebx
  102e5a:	7e 15                	jle    102e71 <vprintfmt+0x218>
                    putch('?', putdat);
  102e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e63:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6d:	ff d0                	call   *%eax
  102e6f:	eb 0f                	jmp    102e80 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e78:	89 1c 24             	mov    %ebx,(%esp)
  102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e80:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e84:	89 f0                	mov    %esi,%eax
  102e86:	8d 70 01             	lea    0x1(%eax),%esi
  102e89:	0f b6 00             	movzbl (%eax),%eax
  102e8c:	0f be d8             	movsbl %al,%ebx
  102e8f:	85 db                	test   %ebx,%ebx
  102e91:	74 10                	je     102ea3 <vprintfmt+0x24a>
  102e93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e97:	78 b3                	js     102e4c <vprintfmt+0x1f3>
  102e99:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e9d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ea1:	79 a9                	jns    102e4c <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ea3:	eb 17                	jmp    102ebc <vprintfmt+0x263>
                putch(' ', putdat);
  102ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eac:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb6:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102eb8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ebc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ec0:	7f e3                	jg     102ea5 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102ec2:	e9 70 01 00 00       	jmp    103037 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eca:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ece:	8d 45 14             	lea    0x14(%ebp),%eax
  102ed1:	89 04 24             	mov    %eax,(%esp)
  102ed4:	e8 0b fd ff ff       	call   102be4 <getint>
  102ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102edc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ee5:	85 d2                	test   %edx,%edx
  102ee7:	79 26                	jns    102f0f <vprintfmt+0x2b6>
                putch('-', putdat);
  102ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  102efa:	ff d0                	call   *%eax
                num = -(long long)num;
  102efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f02:	f7 d8                	neg    %eax
  102f04:	83 d2 00             	adc    $0x0,%edx
  102f07:	f7 da                	neg    %edx
  102f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f16:	e9 a8 00 00 00       	jmp    102fc3 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f22:	8d 45 14             	lea    0x14(%ebp),%eax
  102f25:	89 04 24             	mov    %eax,(%esp)
  102f28:	e8 68 fc ff ff       	call   102b95 <getuint>
  102f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f30:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f3a:	e9 84 00 00 00       	jmp    102fc3 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f42:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f46:	8d 45 14             	lea    0x14(%ebp),%eax
  102f49:	89 04 24             	mov    %eax,(%esp)
  102f4c:	e8 44 fc ff ff       	call   102b95 <getuint>
  102f51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f54:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f57:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f5e:	eb 63                	jmp    102fc3 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f67:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f71:	ff d0                	call   *%eax
            putch('x', putdat);
  102f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f76:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f81:	8b 45 08             	mov    0x8(%ebp),%eax
  102f84:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f86:	8b 45 14             	mov    0x14(%ebp),%eax
  102f89:	8d 50 04             	lea    0x4(%eax),%edx
  102f8c:	89 55 14             	mov    %edx,0x14(%ebp)
  102f8f:	8b 00                	mov    (%eax),%eax
  102f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f9b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102fa2:	eb 1f                	jmp    102fc3 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fab:	8d 45 14             	lea    0x14(%ebp),%eax
  102fae:	89 04 24             	mov    %eax,(%esp)
  102fb1:	e8 df fb ff ff       	call   102b95 <getuint>
  102fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102fbc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fc3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fca:	89 54 24 18          	mov    %edx,0x18(%esp)
  102fce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102fd1:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fe3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff1:	89 04 24             	mov    %eax,(%esp)
  102ff4:	e8 97 fa ff ff       	call   102a90 <printnum>
            break;
  102ff9:	eb 3c                	jmp    103037 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  103002:	89 1c 24             	mov    %ebx,(%esp)
  103005:	8b 45 08             	mov    0x8(%ebp),%eax
  103008:	ff d0                	call   *%eax
            break;
  10300a:	eb 2b                	jmp    103037 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10300c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10300f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103013:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10301a:	8b 45 08             	mov    0x8(%ebp),%eax
  10301d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10301f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103023:	eb 04                	jmp    103029 <vprintfmt+0x3d0>
  103025:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103029:	8b 45 10             	mov    0x10(%ebp),%eax
  10302c:	83 e8 01             	sub    $0x1,%eax
  10302f:	0f b6 00             	movzbl (%eax),%eax
  103032:	3c 25                	cmp    $0x25,%al
  103034:	75 ef                	jne    103025 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103036:	90                   	nop
        }
    }
  103037:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103038:	e9 3e fc ff ff       	jmp    102c7b <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10303d:	83 c4 40             	add    $0x40,%esp
  103040:	5b                   	pop    %ebx
  103041:	5e                   	pop    %esi
  103042:	5d                   	pop    %ebp
  103043:	c3                   	ret    

00103044 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103044:	55                   	push   %ebp
  103045:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103047:	8b 45 0c             	mov    0xc(%ebp),%eax
  10304a:	8b 40 08             	mov    0x8(%eax),%eax
  10304d:	8d 50 01             	lea    0x1(%eax),%edx
  103050:	8b 45 0c             	mov    0xc(%ebp),%eax
  103053:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103056:	8b 45 0c             	mov    0xc(%ebp),%eax
  103059:	8b 10                	mov    (%eax),%edx
  10305b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305e:	8b 40 04             	mov    0x4(%eax),%eax
  103061:	39 c2                	cmp    %eax,%edx
  103063:	73 12                	jae    103077 <sprintputch+0x33>
        *b->buf ++ = ch;
  103065:	8b 45 0c             	mov    0xc(%ebp),%eax
  103068:	8b 00                	mov    (%eax),%eax
  10306a:	8d 48 01             	lea    0x1(%eax),%ecx
  10306d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103070:	89 0a                	mov    %ecx,(%edx)
  103072:	8b 55 08             	mov    0x8(%ebp),%edx
  103075:	88 10                	mov    %dl,(%eax)
    }
}
  103077:	5d                   	pop    %ebp
  103078:	c3                   	ret    

00103079 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103079:	55                   	push   %ebp
  10307a:	89 e5                	mov    %esp,%ebp
  10307c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10307f:	8d 45 14             	lea    0x14(%ebp),%eax
  103082:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103088:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10308c:	8b 45 10             	mov    0x10(%ebp),%eax
  10308f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103093:	8b 45 0c             	mov    0xc(%ebp),%eax
  103096:	89 44 24 04          	mov    %eax,0x4(%esp)
  10309a:	8b 45 08             	mov    0x8(%ebp),%eax
  10309d:	89 04 24             	mov    %eax,(%esp)
  1030a0:	e8 08 00 00 00       	call   1030ad <vsnprintf>
  1030a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030ab:	c9                   	leave  
  1030ac:	c3                   	ret    

001030ad <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1030ad:	55                   	push   %ebp
  1030ae:	89 e5                	mov    %esp,%ebp
  1030b0:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c2:	01 d0                	add    %edx,%eax
  1030c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030d2:	74 0a                	je     1030de <vsnprintf+0x31>
  1030d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030da:	39 c2                	cmp    %eax,%edx
  1030dc:	76 07                	jbe    1030e5 <vsnprintf+0x38>
        return -E_INVAL;
  1030de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030e3:	eb 2a                	jmp    10310f <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030e5:	8b 45 14             	mov    0x14(%ebp),%eax
  1030e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1030ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030fa:	c7 04 24 44 30 10 00 	movl   $0x103044,(%esp)
  103101:	e8 53 fb ff ff       	call   102c59 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103109:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10310f:	c9                   	leave  
  103110:	c3                   	ret    

00103111 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103111:	55                   	push   %ebp
  103112:	89 e5                	mov    %esp,%ebp
  103114:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10311e:	eb 04                	jmp    103124 <strlen+0x13>
        cnt ++;
  103120:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103124:	8b 45 08             	mov    0x8(%ebp),%eax
  103127:	8d 50 01             	lea    0x1(%eax),%edx
  10312a:	89 55 08             	mov    %edx,0x8(%ebp)
  10312d:	0f b6 00             	movzbl (%eax),%eax
  103130:	84 c0                	test   %al,%al
  103132:	75 ec                	jne    103120 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103134:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103137:	c9                   	leave  
  103138:	c3                   	ret    

00103139 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103139:	55                   	push   %ebp
  10313a:	89 e5                	mov    %esp,%ebp
  10313c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10313f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103146:	eb 04                	jmp    10314c <strnlen+0x13>
        cnt ++;
  103148:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10314c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10314f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103152:	73 10                	jae    103164 <strnlen+0x2b>
  103154:	8b 45 08             	mov    0x8(%ebp),%eax
  103157:	8d 50 01             	lea    0x1(%eax),%edx
  10315a:	89 55 08             	mov    %edx,0x8(%ebp)
  10315d:	0f b6 00             	movzbl (%eax),%eax
  103160:	84 c0                	test   %al,%al
  103162:	75 e4                	jne    103148 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103167:	c9                   	leave  
  103168:	c3                   	ret    

00103169 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103169:	55                   	push   %ebp
  10316a:	89 e5                	mov    %esp,%ebp
  10316c:	57                   	push   %edi
  10316d:	56                   	push   %esi
  10316e:	83 ec 20             	sub    $0x20,%esp
  103171:	8b 45 08             	mov    0x8(%ebp),%eax
  103174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103177:	8b 45 0c             	mov    0xc(%ebp),%eax
  10317a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10317d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103183:	89 d1                	mov    %edx,%ecx
  103185:	89 c2                	mov    %eax,%edx
  103187:	89 ce                	mov    %ecx,%esi
  103189:	89 d7                	mov    %edx,%edi
  10318b:	ac                   	lods   %ds:(%esi),%al
  10318c:	aa                   	stos   %al,%es:(%edi)
  10318d:	84 c0                	test   %al,%al
  10318f:	75 fa                	jne    10318b <strcpy+0x22>
  103191:	89 fa                	mov    %edi,%edx
  103193:	89 f1                	mov    %esi,%ecx
  103195:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103198:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10319b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1031a1:	83 c4 20             	add    $0x20,%esp
  1031a4:	5e                   	pop    %esi
  1031a5:	5f                   	pop    %edi
  1031a6:	5d                   	pop    %ebp
  1031a7:	c3                   	ret    

001031a8 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1031a8:	55                   	push   %ebp
  1031a9:	89 e5                	mov    %esp,%ebp
  1031ab:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1031b4:	eb 21                	jmp    1031d7 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1031b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b9:	0f b6 10             	movzbl (%eax),%edx
  1031bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031bf:	88 10                	mov    %dl,(%eax)
  1031c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031c4:	0f b6 00             	movzbl (%eax),%eax
  1031c7:	84 c0                	test   %al,%al
  1031c9:	74 04                	je     1031cf <strncpy+0x27>
            src ++;
  1031cb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1031cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1031d3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1031d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031db:	75 d9                	jne    1031b6 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1031dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031e0:	c9                   	leave  
  1031e1:	c3                   	ret    

001031e2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031e2:	55                   	push   %ebp
  1031e3:	89 e5                	mov    %esp,%ebp
  1031e5:	57                   	push   %edi
  1031e6:	56                   	push   %esi
  1031e7:	83 ec 20             	sub    $0x20,%esp
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031fc:	89 d1                	mov    %edx,%ecx
  1031fe:	89 c2                	mov    %eax,%edx
  103200:	89 ce                	mov    %ecx,%esi
  103202:	89 d7                	mov    %edx,%edi
  103204:	ac                   	lods   %ds:(%esi),%al
  103205:	ae                   	scas   %es:(%edi),%al
  103206:	75 08                	jne    103210 <strcmp+0x2e>
  103208:	84 c0                	test   %al,%al
  10320a:	75 f8                	jne    103204 <strcmp+0x22>
  10320c:	31 c0                	xor    %eax,%eax
  10320e:	eb 04                	jmp    103214 <strcmp+0x32>
  103210:	19 c0                	sbb    %eax,%eax
  103212:	0c 01                	or     $0x1,%al
  103214:	89 fa                	mov    %edi,%edx
  103216:	89 f1                	mov    %esi,%ecx
  103218:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10321b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10321e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103221:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103224:	83 c4 20             	add    $0x20,%esp
  103227:	5e                   	pop    %esi
  103228:	5f                   	pop    %edi
  103229:	5d                   	pop    %ebp
  10322a:	c3                   	ret    

0010322b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10322b:	55                   	push   %ebp
  10322c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10322e:	eb 0c                	jmp    10323c <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103230:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103234:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103238:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10323c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103240:	74 1a                	je     10325c <strncmp+0x31>
  103242:	8b 45 08             	mov    0x8(%ebp),%eax
  103245:	0f b6 00             	movzbl (%eax),%eax
  103248:	84 c0                	test   %al,%al
  10324a:	74 10                	je     10325c <strncmp+0x31>
  10324c:	8b 45 08             	mov    0x8(%ebp),%eax
  10324f:	0f b6 10             	movzbl (%eax),%edx
  103252:	8b 45 0c             	mov    0xc(%ebp),%eax
  103255:	0f b6 00             	movzbl (%eax),%eax
  103258:	38 c2                	cmp    %al,%dl
  10325a:	74 d4                	je     103230 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10325c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103260:	74 18                	je     10327a <strncmp+0x4f>
  103262:	8b 45 08             	mov    0x8(%ebp),%eax
  103265:	0f b6 00             	movzbl (%eax),%eax
  103268:	0f b6 d0             	movzbl %al,%edx
  10326b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10326e:	0f b6 00             	movzbl (%eax),%eax
  103271:	0f b6 c0             	movzbl %al,%eax
  103274:	29 c2                	sub    %eax,%edx
  103276:	89 d0                	mov    %edx,%eax
  103278:	eb 05                	jmp    10327f <strncmp+0x54>
  10327a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10327f:	5d                   	pop    %ebp
  103280:	c3                   	ret    

00103281 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103281:	55                   	push   %ebp
  103282:	89 e5                	mov    %esp,%ebp
  103284:	83 ec 04             	sub    $0x4,%esp
  103287:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10328d:	eb 14                	jmp    1032a3 <strchr+0x22>
        if (*s == c) {
  10328f:	8b 45 08             	mov    0x8(%ebp),%eax
  103292:	0f b6 00             	movzbl (%eax),%eax
  103295:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103298:	75 05                	jne    10329f <strchr+0x1e>
            return (char *)s;
  10329a:	8b 45 08             	mov    0x8(%ebp),%eax
  10329d:	eb 13                	jmp    1032b2 <strchr+0x31>
        }
        s ++;
  10329f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a6:	0f b6 00             	movzbl (%eax),%eax
  1032a9:	84 c0                	test   %al,%al
  1032ab:	75 e2                	jne    10328f <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1032ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032b2:	c9                   	leave  
  1032b3:	c3                   	ret    

001032b4 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1032b4:	55                   	push   %ebp
  1032b5:	89 e5                	mov    %esp,%ebp
  1032b7:	83 ec 04             	sub    $0x4,%esp
  1032ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032bd:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032c0:	eb 11                	jmp    1032d3 <strfind+0x1f>
        if (*s == c) {
  1032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c5:	0f b6 00             	movzbl (%eax),%eax
  1032c8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032cb:	75 02                	jne    1032cf <strfind+0x1b>
            break;
  1032cd:	eb 0e                	jmp    1032dd <strfind+0x29>
        }
        s ++;
  1032cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d6:	0f b6 00             	movzbl (%eax),%eax
  1032d9:	84 c0                	test   %al,%al
  1032db:	75 e5                	jne    1032c2 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1032dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032e0:	c9                   	leave  
  1032e1:	c3                   	ret    

001032e2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032e2:	55                   	push   %ebp
  1032e3:	89 e5                	mov    %esp,%ebp
  1032e5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032f6:	eb 04                	jmp    1032fc <strtol+0x1a>
        s ++;
  1032f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ff:	0f b6 00             	movzbl (%eax),%eax
  103302:	3c 20                	cmp    $0x20,%al
  103304:	74 f2                	je     1032f8 <strtol+0x16>
  103306:	8b 45 08             	mov    0x8(%ebp),%eax
  103309:	0f b6 00             	movzbl (%eax),%eax
  10330c:	3c 09                	cmp    $0x9,%al
  10330e:	74 e8                	je     1032f8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103310:	8b 45 08             	mov    0x8(%ebp),%eax
  103313:	0f b6 00             	movzbl (%eax),%eax
  103316:	3c 2b                	cmp    $0x2b,%al
  103318:	75 06                	jne    103320 <strtol+0x3e>
        s ++;
  10331a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10331e:	eb 15                	jmp    103335 <strtol+0x53>
    }
    else if (*s == '-') {
  103320:	8b 45 08             	mov    0x8(%ebp),%eax
  103323:	0f b6 00             	movzbl (%eax),%eax
  103326:	3c 2d                	cmp    $0x2d,%al
  103328:	75 0b                	jne    103335 <strtol+0x53>
        s ++, neg = 1;
  10332a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10332e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103335:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103339:	74 06                	je     103341 <strtol+0x5f>
  10333b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10333f:	75 24                	jne    103365 <strtol+0x83>
  103341:	8b 45 08             	mov    0x8(%ebp),%eax
  103344:	0f b6 00             	movzbl (%eax),%eax
  103347:	3c 30                	cmp    $0x30,%al
  103349:	75 1a                	jne    103365 <strtol+0x83>
  10334b:	8b 45 08             	mov    0x8(%ebp),%eax
  10334e:	83 c0 01             	add    $0x1,%eax
  103351:	0f b6 00             	movzbl (%eax),%eax
  103354:	3c 78                	cmp    $0x78,%al
  103356:	75 0d                	jne    103365 <strtol+0x83>
        s += 2, base = 16;
  103358:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10335c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103363:	eb 2a                	jmp    10338f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103365:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103369:	75 17                	jne    103382 <strtol+0xa0>
  10336b:	8b 45 08             	mov    0x8(%ebp),%eax
  10336e:	0f b6 00             	movzbl (%eax),%eax
  103371:	3c 30                	cmp    $0x30,%al
  103373:	75 0d                	jne    103382 <strtol+0xa0>
        s ++, base = 8;
  103375:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103379:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103380:	eb 0d                	jmp    10338f <strtol+0xad>
    }
    else if (base == 0) {
  103382:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103386:	75 07                	jne    10338f <strtol+0xad>
        base = 10;
  103388:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10338f:	8b 45 08             	mov    0x8(%ebp),%eax
  103392:	0f b6 00             	movzbl (%eax),%eax
  103395:	3c 2f                	cmp    $0x2f,%al
  103397:	7e 1b                	jle    1033b4 <strtol+0xd2>
  103399:	8b 45 08             	mov    0x8(%ebp),%eax
  10339c:	0f b6 00             	movzbl (%eax),%eax
  10339f:	3c 39                	cmp    $0x39,%al
  1033a1:	7f 11                	jg     1033b4 <strtol+0xd2>
            dig = *s - '0';
  1033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a6:	0f b6 00             	movzbl (%eax),%eax
  1033a9:	0f be c0             	movsbl %al,%eax
  1033ac:	83 e8 30             	sub    $0x30,%eax
  1033af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033b2:	eb 48                	jmp    1033fc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b7:	0f b6 00             	movzbl (%eax),%eax
  1033ba:	3c 60                	cmp    $0x60,%al
  1033bc:	7e 1b                	jle    1033d9 <strtol+0xf7>
  1033be:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c1:	0f b6 00             	movzbl (%eax),%eax
  1033c4:	3c 7a                	cmp    $0x7a,%al
  1033c6:	7f 11                	jg     1033d9 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cb:	0f b6 00             	movzbl (%eax),%eax
  1033ce:	0f be c0             	movsbl %al,%eax
  1033d1:	83 e8 57             	sub    $0x57,%eax
  1033d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033d7:	eb 23                	jmp    1033fc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033dc:	0f b6 00             	movzbl (%eax),%eax
  1033df:	3c 40                	cmp    $0x40,%al
  1033e1:	7e 3d                	jle    103420 <strtol+0x13e>
  1033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e6:	0f b6 00             	movzbl (%eax),%eax
  1033e9:	3c 5a                	cmp    $0x5a,%al
  1033eb:	7f 33                	jg     103420 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f0:	0f b6 00             	movzbl (%eax),%eax
  1033f3:	0f be c0             	movsbl %al,%eax
  1033f6:	83 e8 37             	sub    $0x37,%eax
  1033f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  103402:	7c 02                	jl     103406 <strtol+0x124>
            break;
  103404:	eb 1a                	jmp    103420 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103406:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10340a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10340d:	0f af 45 10          	imul   0x10(%ebp),%eax
  103411:	89 c2                	mov    %eax,%edx
  103413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103416:	01 d0                	add    %edx,%eax
  103418:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10341b:	e9 6f ff ff ff       	jmp    10338f <strtol+0xad>

    if (endptr) {
  103420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103424:	74 08                	je     10342e <strtol+0x14c>
        *endptr = (char *) s;
  103426:	8b 45 0c             	mov    0xc(%ebp),%eax
  103429:	8b 55 08             	mov    0x8(%ebp),%edx
  10342c:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10342e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103432:	74 07                	je     10343b <strtol+0x159>
  103434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103437:	f7 d8                	neg    %eax
  103439:	eb 03                	jmp    10343e <strtol+0x15c>
  10343b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10343e:	c9                   	leave  
  10343f:	c3                   	ret    

00103440 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103440:	55                   	push   %ebp
  103441:	89 e5                	mov    %esp,%ebp
  103443:	57                   	push   %edi
  103444:	83 ec 24             	sub    $0x24,%esp
  103447:	8b 45 0c             	mov    0xc(%ebp),%eax
  10344a:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10344d:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103451:	8b 55 08             	mov    0x8(%ebp),%edx
  103454:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103457:	88 45 f7             	mov    %al,-0x9(%ebp)
  10345a:	8b 45 10             	mov    0x10(%ebp),%eax
  10345d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103460:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103463:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103467:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10346a:	89 d7                	mov    %edx,%edi
  10346c:	f3 aa                	rep stos %al,%es:(%edi)
  10346e:	89 fa                	mov    %edi,%edx
  103470:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103473:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103476:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103479:	83 c4 24             	add    $0x24,%esp
  10347c:	5f                   	pop    %edi
  10347d:	5d                   	pop    %ebp
  10347e:	c3                   	ret    

0010347f <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10347f:	55                   	push   %ebp
  103480:	89 e5                	mov    %esp,%ebp
  103482:	57                   	push   %edi
  103483:	56                   	push   %esi
  103484:	53                   	push   %ebx
  103485:	83 ec 30             	sub    $0x30,%esp
  103488:	8b 45 08             	mov    0x8(%ebp),%eax
  10348b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10348e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103491:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103494:	8b 45 10             	mov    0x10(%ebp),%eax
  103497:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10349a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10349d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034a0:	73 42                	jae    1034e4 <memmove+0x65>
  1034a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034b7:	c1 e8 02             	shr    $0x2,%eax
  1034ba:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1034bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034c2:	89 d7                	mov    %edx,%edi
  1034c4:	89 c6                	mov    %eax,%esi
  1034c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034cb:	83 e1 03             	and    $0x3,%ecx
  1034ce:	74 02                	je     1034d2 <memmove+0x53>
  1034d0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034d2:	89 f0                	mov    %esi,%eax
  1034d4:	89 fa                	mov    %edi,%edx
  1034d6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e2:	eb 36                	jmp    10351a <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ed:	01 c2                	add    %eax,%edx
  1034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034f2:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f8:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034fe:	89 c1                	mov    %eax,%ecx
  103500:	89 d8                	mov    %ebx,%eax
  103502:	89 d6                	mov    %edx,%esi
  103504:	89 c7                	mov    %eax,%edi
  103506:	fd                   	std    
  103507:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103509:	fc                   	cld    
  10350a:	89 f8                	mov    %edi,%eax
  10350c:	89 f2                	mov    %esi,%edx
  10350e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103511:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103514:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103517:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10351a:	83 c4 30             	add    $0x30,%esp
  10351d:	5b                   	pop    %ebx
  10351e:	5e                   	pop    %esi
  10351f:	5f                   	pop    %edi
  103520:	5d                   	pop    %ebp
  103521:	c3                   	ret    

00103522 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103522:	55                   	push   %ebp
  103523:	89 e5                	mov    %esp,%ebp
  103525:	57                   	push   %edi
  103526:	56                   	push   %esi
  103527:	83 ec 20             	sub    $0x20,%esp
  10352a:	8b 45 08             	mov    0x8(%ebp),%eax
  10352d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103530:	8b 45 0c             	mov    0xc(%ebp),%eax
  103533:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103536:	8b 45 10             	mov    0x10(%ebp),%eax
  103539:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10353c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10353f:	c1 e8 02             	shr    $0x2,%eax
  103542:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354a:	89 d7                	mov    %edx,%edi
  10354c:	89 c6                	mov    %eax,%esi
  10354e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103550:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103553:	83 e1 03             	and    $0x3,%ecx
  103556:	74 02                	je     10355a <memcpy+0x38>
  103558:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10355a:	89 f0                	mov    %esi,%eax
  10355c:	89 fa                	mov    %edi,%edx
  10355e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103561:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103564:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103567:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10356a:	83 c4 20             	add    $0x20,%esp
  10356d:	5e                   	pop    %esi
  10356e:	5f                   	pop    %edi
  10356f:	5d                   	pop    %ebp
  103570:	c3                   	ret    

00103571 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103571:	55                   	push   %ebp
  103572:	89 e5                	mov    %esp,%ebp
  103574:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103577:	8b 45 08             	mov    0x8(%ebp),%eax
  10357a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10357d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103580:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103583:	eb 30                	jmp    1035b5 <memcmp+0x44>
        if (*s1 != *s2) {
  103585:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103588:	0f b6 10             	movzbl (%eax),%edx
  10358b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10358e:	0f b6 00             	movzbl (%eax),%eax
  103591:	38 c2                	cmp    %al,%dl
  103593:	74 18                	je     1035ad <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103595:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103598:	0f b6 00             	movzbl (%eax),%eax
  10359b:	0f b6 d0             	movzbl %al,%edx
  10359e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035a1:	0f b6 00             	movzbl (%eax),%eax
  1035a4:	0f b6 c0             	movzbl %al,%eax
  1035a7:	29 c2                	sub    %eax,%edx
  1035a9:	89 d0                	mov    %edx,%eax
  1035ab:	eb 1a                	jmp    1035c7 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1035ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035b1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1035b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035bb:	89 55 10             	mov    %edx,0x10(%ebp)
  1035be:	85 c0                	test   %eax,%eax
  1035c0:	75 c3                	jne    103585 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1035c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035c7:	c9                   	leave  
  1035c8:	c3                   	ret    
