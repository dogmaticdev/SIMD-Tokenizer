%define SYS_READ    0
%define SYS_WRITE   1
%define SYS_OPEN    2
%define SYS_CLOSE   3
%define SYS_FSTAT   5
%define SYS_MMAP    9
%define SYS_MUNMAP  11
%define SYS_EXIT    60

%define O_RDONLY    0
%define O_WRONLY    1
%define O_CREAT     0o100
%define O_TRUNC     0o1000

%define PROT_READ   1
%define PROT_WRITE  2
%define MAP_PRIVATE 2
%define MAP_ANON    0x20

%define STAT_SIZE_OFFSET 48     ; offset of st_size in struct stat

section .data
    sequence: db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    err_usage       db "Usage: whitespace <input> <output>", 10
    err_usage_len   equ $ - err_usage

    err_open_r      db "Error: cannot open input file", 10
    err_open_r_len  equ $ - err_open_r

    err_open_w      db "Error: cannot open output file", 10
    err_open_w_len  equ $ - err_open_w

    err_fstat       db "Error: fstat failed", 10
    err_fstat_len   equ $ - err_fstat

    err_mmap        db "Error: mmap failed", 10
    err_mmap_len    equ $ - err_mmap

    err_read        db "Error: read failed", 10
    err_read_len    equ $ - err_read

    err_write       db "Error: write failed", 10
    err_write_len   equ $ - err_write
    msg_sec db " seconds, ", 0
    msg_sec_len equ $ - msg_sec -1
    msg_ns db " nanoseconds", 10, 0
    msg_ns_len equ $ - msg_ns - 1
section .bss
    timespec_start resb 16
    timespec_end resb 16
    stat_buf        resb 144        ; sizeof(struct stat) on x86-64
    numBuf resb 20

section .text
    global _start

_start:
    ; ── Check argument count ──────────────────────────────────────────────────
    mov     rax, [rsp]              ; argc
    cmp     rax, 3
    jne     .usage_error

    ; ── Open input file ───────────────────────────────────────────────────────
    mov     rax, SYS_OPEN
    mov     rdi, [rsp+16]           ; argv[1] = input path
    xor     rsi, rsi                ; O_RDONLY
    xor     rdx, rdx
    syscall
    cmp     rax, 0
    jl      .open_read_error
    mov     r12, rax                ; r12 = input fd

    ; ── fstat to get file size ────────────────────────────────────────────────
    mov     rax, SYS_FSTAT
    mov     rdi, r12                ; fd
    mov     rsi, stat_buf           ; pointer to stat struct
    syscall
    cmp     rax, 0
    jl      .fstat_error

    mov     r13, [stat_buf + STAT_SIZE_OFFSET]  ; r13 = file size (st_size)

    ; ── mmap: allocate exactly file-size bytes ────────────────────────────────
    ; mmap(NULL, length, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANON, -1, 0)
    mov     rax, SYS_MMAP
    xor     rdi, rdi                ; addr = NULL (kernel chooses)
    mov     rsi, r13                ; length = file size
    mov     rdx, PROT_READ | PROT_WRITE
    mov     r10, MAP_PRIVATE | MAP_ANON
    mov     r8,  -1                 ; fd = -1 (anonymous)
    xor     r9,  r9                 ; offset = 0
    syscall
    cmp     rax, -1
    je      .mmap_error
    mov     rbp, rax                ; rbp = pointer to allocated buffer

    ; ── Read file into buffer ─────────────────────────────────────────────────
    mov     rax, SYS_READ
    mov     rdi, r12                ; input fd
    mov     rsi, rbp                ; buffer pointer
    mov     rdx, r13                ; read exactly file-size bytes
    syscall
    cmp     rax, 0
    jl      .read_error



    ; ── Close input file ──────────────────────────────────────────────────────
    mov     rax, SYS_CLOSE
    mov     rdi, r12
    syscall

    mov r12, rbp
    mov r14, rbp
    lea r15, [rbp + r13]

    mov rax, 228
    mov rdi, 1
    mov rsi, timespec_start
    syscall
    ;rbp is the start pointer
    ;r12 is the write pointer
    ;r13 is the file size
    ;r14 is read pointer
    ;r15 is end pointer
    pxor     xmm0, xmm0        ; Empty Register
    mov      eax, 0x20
    pinsrb   xmm1, eax, 0      ; 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    pshufb   xmm1, xmm0        ; 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
    movdqa   xmm2, [sequence]  ; 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
    xor rsi, rsi

.clear_whitespace:
    cmp r14, r15
    jge .end
    movdqa xmm3, [r14]
    add r14, 16
    ;Example: SPACE SPACE H e l l o SPACE W o r l d SPACE SPACE SPACE

    movdqa xmm4, xmm3
    pcmpgtb  xmm4, xmm1        ; 00 00 ff ff ff ff ff 00 ff ff ff ff ff 00 00 00
    pmovmskb eax, xmm4         ; 0 0 1 1 1 1 1 0 1 1 1 1 1 0 0 0
    pand xmm3, xmm4            ; NULL NULL H e l l o NULL W o r l d NULL NULL NULL

    cmp ax, 0xFFFF             ; Move the whole register to the buffer if it is full
    jz .full

    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx
                               ; 0 0 1 1 1 1 1 0 1 1 1 1 1 0 0 0
    bsf cx, ax                 ;     ^ cx = 2
    jz .clear_whitespace       ; Next loop if register is empty
    test cx, cx
    jz .skip
    shr ax, cl                 ; 1 1 1 1 1 0 1 1 1 1 1 0 0 0 0 0
    test sil, sil
    jz .check
    xor sil, sil
    dec ecx
    inc ebx
    test cx, cx
    jnz .check
.skip:
    movdqa xmm5, xmm2
    jmp .next
.check:
    mov edx, ecx
    pinsrb xmm5, ecx, 0        ; 2
    pshufb xmm5, xmm0          ; 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
    paddusb xmm5, xmm2         ; 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 10 11
.next:
    not ax                     ; 0 0 0 0 0 1 0 0 0 0 0 1 1 1 1 1
    bsf cx, ax                 ;           ^ cx = 5
    not ax                     ; 1 1 1 1 1 0 1 1 1 1 1 0 0 0 0 0
    inc cx                     ; cx = 6
    shr ax, cl                 ; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0
    add ebx, ecx               ; bx = 6
    dec cx
    pinsrb xmm6, ecx, 0
    pshufb xmm6, xmm0          ; 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
    movdqa xmm4, xmm2          ; 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
    pcmpgtb xmm4, xmm6         ; 00 00 00 00 00 00 ff ff ff ff ff ff ff ff ff ff
    por xmm4, xmm5             ; 02 03 04 05 06 07 ff ff ff ff ff ff ff ff ff ff
    cmp ax, 0
    jz .end_loop
.string_loop:
    xor ecx, ecx               ; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0
    bsf cx, ax                 ; ^ 0 = cx
    test cx, cx
    jz .skip2

    add dx, cx
    shr ax, cl
    pinsrb xmm6, ecx, 0
    pshufb xmm6, xmm0
    paddusb xmm5, xmm6
.skip2:
    not ax                     ; 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1
    bsf cx, ax                 ;           ^ cx = 5
    not ax                     ; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0

    inc cx                     ; cx = 6
    shr ax, cl                 ; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    add bx, cx                 ; bx = 12
    mov cx, bx
    dec cx                     ; cx = 11 = 0b

    pinsrb xmm6, ecx, 0        ; 0b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    pshufb xmm6, xmm0          ; 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b
    movdqa xmm7, xmm2          ; 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
    pcmpgtb xmm7, xmm6         ; 00 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff

    por xmm7, xmm5             ; 02 03 04 05 06 07 08 09 0a 0b 0c 0d ff ff ff ff
    pminub xmm4, xmm7          ; 02 03 04 05 06 07 08 09 0a 0b 0c 0d ff ff ff ff

    cmp ax, 0
    jne .string_loop
.end_loop:
    lea ecx, [ebx + edx]
    cmp ecx, 17
    setz sil                   ; dl = 0
    sub ebx, esi               ; ebx = 12

    pshufb xmm3, xmm4
    movdqu [r12], xmm3
    add r12, rbx
    jmp .clear_whitespace
.full:
    movdqu [r12], xmm3
    mov rsi, 1
    add r12, 16
    jmp .clear_whitespace
.end:
    mov rax, 228
    mov rdi, 1
    mov rsi, timespec_end
    syscall

    mov rax, [timespec_end]
    sub rax, [timespec_start]

    mov rbx, [timespec_end + 8]
    sub rbx, [timespec_start + 8]
    push rbx
    call print_uint
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_sec
    mov rdx, msg_sec_len
    syscall

    pop rax                ; restore nanoseconds into rax
    call print_uint
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_ns
    mov rdx, msg_ns_len
    syscall



    sub r12, rbp
    mov r13, r12
    ; ── Open output file ──────────────────────────────────────────────────────
    mov     rax, SYS_OPEN
    mov     rdi, [rsp+24]           ; argv[2] = output path
    mov     rsi, O_WRONLY | O_CREAT | O_TRUNC
    mov     rdx, 0o644              ; rw-r--r--
    syscall
    cmp     rax, 0
    jl      .open_write_error
    mov     r12, rax                ; r12 = output fd (reuse)

    ; ── Write buffer to output file ───────────────────────────────────────────
    mov     rax, SYS_WRITE
    mov     rdi, r12
    mov     rsi, rbp                ; buffer pointer
    mov     rdx, r13                ; bytes to write
    syscall
    cmp     rax, 0
    jl      .write_error

    ; ── Close output file ─────────────────────────────────────────────────────
    mov     rax, SYS_CLOSE
    mov     rdi, r12
    syscall

    ; ── munmap: free the allocated memory ─────────────────────────────────────
    mov     rax, SYS_MUNMAP
    mov     rdi, r14                ; buffer pointer
    mov     rsi, r13                ; length
    syscall

    ; ── Exit success ──────────────────────────────────────────────────────────
    mov     rax, SYS_EXIT
    xor     rdi, rdi
    syscall

; ── Error handlers ────────────────────────────────────────────────────────────
.usage_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_usage
    mov     rdx, err_usage_len
    syscall
    jmp     .exit_fail

.open_read_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_open_r
    mov     rdx, err_open_r_len
    syscall
    jmp     .exit_fail

.fstat_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_fstat
    mov     rdx, err_fstat_len
    syscall
    jmp     .exit_fail

.mmap_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_mmap
    mov     rdx, err_mmap_len
    syscall
    jmp     .exit_fail

.read_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_read
    mov     rdx, err_read_len
    syscall
    jmp     .exit_fail

.open_write_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_open_w
    mov     rdx, err_open_w_len
    syscall
    jmp     .exit_fail

.write_error:
    mov     rax, SYS_WRITE
    mov     rdi, 2
    mov     rsi, err_write
    mov     rdx, err_write_len
    syscall

.exit_fail:
    mov     rax, SYS_EXIT
    mov     rdi, 1
    syscall
print_uint:
    mov rcx, numBuf + 20
    mov rbx, 10
.printer:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .printer
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, numBuf + 20
    sub rdx, rcx
    syscall
    ret
