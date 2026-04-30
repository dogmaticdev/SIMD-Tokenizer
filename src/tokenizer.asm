;nasm -f elf64 tokenizer.asm -o tokenizer.o && ld tokenizer.o -o whitespace
;./tokenizer hell.txt output.txt

section .data
    despace:  db 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
    sequence: db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    index0: db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    index1: db 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff
    index2: db 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff
    index3: db 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff
    index4: db 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff
    index5: db 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff
    index6: db 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    index7: db 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    index8: db 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    index9: db 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    indexA: db 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    indexB: db 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    indexC: db 0x0C, 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    indexD: db 0x0D, 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    indexE: db 0x0E, 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    indexF: db 0x0F, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff

    bitmask0: db 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff ;16
    bitmask1: db 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask2: db 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask3: db 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask4: db 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask5: db 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask6: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask7: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask8: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmask9: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmaskA: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmaskB: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff
    bitmaskC: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
    bitmaskD: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff
    bitmaskE: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff
    bitmaskF: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    bitmaskG: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

    usage:              db "Usage: whitespace <input> <output>", 10
    usage_length:       equ $ - usage

    open_input:         db "Error: cannot open input file", 10
    open_input_length:  equ $ - open_input

    open_output:        db "Error: cannot open output file", 10
    open_output_length: equ $ - open_output

    fstat:              db "Error: fstat failed", 10
    fstat_length:       equ $ - fstat

    mmap:               db "Error: mmap failed", 10
    mmap_length:        equ $ - mmap

    write:              db "Error: write failed", 10
    write_length:       equ $ - write

section .bss
    input_descriptor    resb 8
    input_size          resb 8
    input_pointer       resb 8

    output_descriptor   resb 8
    output_size         resb 8

    stat_buffer         resb 144        ; sizeof(struct stat) on x86-64

section .text
    global _start

_start:
    ; ── Check argument count ─────────────────────────────────────────────────
    mov rax, [rsp]              ; argc
    cmp rax, 3
    jne .usage_error

    ; ── Open input file ──────────────────────────────────────────────────────
    mov rax, 2        ; open
    mov rdi, [rsp+16] ; argv[1] = input path
    xor rsi, rsi      ; read only: 0
    xor rdx, rdx
    syscall
    test rax, rax
    js  .open_input_error
    mov [input_descriptor], rax      ; r14 is input descriptor

    ; ── fstat to get file size ───────────────────────────────────────────────
    mov rax, 5 ;fstat
    mov rdi, [input_descriptor] ; file descriptor
    mov rsi, stat_buffer        ; pointer to stat struct
    syscall
    test rax, rax
    js  .fstat_error
    mov rax, [stat_buffer + 48]
    mov [input_size], rax

    ; ── brk allocate ─────────────────────────────────────────────────────────
    mov rax, 12         ; sys_brk
    xor rdi, rdi        ; pass 0 to get current break
    syscall
    mov [input_pointer], rax


    mov rax, 12
    mov rdi, [input_pointer]
    add rdi, [input_size]
    syscall


    ; ── Read file into buffer ─────────────────────────────────────────────────
    mov     rax, 0
    mov     rdi, [input_descriptor]                ; input fd
    mov     rsi, [input_pointer]                ; buffer pointer
    mov     rdx, [input_size]                ; read exactly file-size bytes
    syscall
    test     rax, rax
    js      .read_error

    ; ── Close input file ─────────────────────────────────────────────────────
    mov rax, 3 ;close
    mov rdi, [input_descriptor]
    syscall

    ;r8 write pointer
    ;r9 read pointer
    ;10 end pointer
    ;rdx string length
    ;rcx count
    ;rax bitmask
    ;rdi offset
    ;rsi bool

    ; ── Allocate Pointers ────────────────────────────────────────────────────
    mov r8, [input_pointer]
    mov r9, [input_pointer]
    mov r10, [input_pointer]
    add r10, [input_size]


    ; ── Setup Registers ──────────────────────────────────────────────────────
    pxor   xmm0, xmm0       ; Empty Register
    movdqa xmm1, [despace]  ; 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
    movdqa xmm2, [sequence] ; 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f

    xor rcx, rcx
    xor rdx, rdx
    xor rdi, rdi

.clear:
    xor rsi, rsi

.clear_whitespace:
    cmp r9, r10
    jge .end

    movdqa xmm3, [r9]
    add r9, 16

    ;Example: SPACE SPACE H e l l o SPACE W o r l d SPACE SPACE SPACE
    movdqa   xmm4, xmm3
    pcmpgtb  xmm4, xmm1   ; 00 00 ff ff ff ff ff 00 ff ff ff ff ff 00 00 00
    pmovmskb eax, xmm4    ; 0 0 1 1 1 1 1 0 1 1 1 1 1 0 0 0
    pand     xmm3, xmm4   ; NULL NULL H e l l o NULL W o r l d NULL NULL NULL

    cmp      ax, 0xFFFF   ; Move the whole register to the buffer if it is full
    jz .full

                          ; 0 0 1 1 1 1 1 0 1 1 1 1 1 0 0 0
    tzcnt    cx, ax       ;     ^ cx = 2
    jc .clear_whitespace  ; Next loop if register is empty
    jz .skip

    shr      ax, cl       ; 1 1 1 1 1 0 1 1 1 1 1 0 0 0 0 0
    test     sil, sil
    jz .check
    xor      sil, sil
    dec      cx
    inc      dx
    test     cx, cx
    jnz .check

.skip:
    movdqa   xmm5, xmm2 ; 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
    jmp .next

.check:
    mov      edi, ecx
    shl      ecx, 4
    movdqa   xmm5, [index0 + rcx]   ; 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 10 11
.next:
    not      ax                     ; 0 0 0 0 0 1 0 0 0 0 0 1 1 1 1 1
    tzcnt    cx, ax                 ;           ^ cx = 5
    not      ax                     ; 1 1 1 1 1 0 1 1 1 1 1 0 0 0 0 0

    inc      cx                     ; cx = 6
    shr      ax, cl                 ; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0
    add      dx, cx                 ; dx = 6
    dec      cx
    shl      ecx, 4
    movdqa   xmm4, [bitmask0 + rcx] ; 00 00 00 00 00 00 ff ff ff ff ff ff ff ff ff ff
    por      xmm4, xmm5             ; 02 03 04 05 06 07 ff ff ff ff ff ff ff ff ff ff

.string_loop:
    xor      ecx, ecx               ; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0
    tzcnt    cx, ax                 ; ^ 0 = cx
    jc .end_loop
    jz .skip2

    add      di, cx
    shr      ax, cl
    mov      ecx, edi
    shl      ecx, 4
    movdqa   xmm5, [index0 + rcx]   ; 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 10 11

.skip2:
    not      ax                     ; 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1
    tzcnt    cx, ax                 ;           ^ cx = 5
    not      ax                     ; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0

    inc      cx                     ; cx = 6
    shr      ax, cl                 ; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    add      dx, cx                 ; dx = 12
    mov      cx, dx
    dec      cx                     ; cx = 11 = 0b

    shl ecx, 4
    movdqa   xmm6, [bitmask0 + rcx] ; 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff ff
    por      xmm6, xmm5             ; 02 03 04 05 06 07 08 09 0A 0B 0C ff ff ff ff ff
    pminub   xmm4, xmm6             ; 02 03 04 05 06 07 08 09 0A 0B 0C ff ff ff ff ff

    jmp .string_loop

.end_loop:
    lea      ecx, [edx + edi]
    xor      edi, edi
    cmp      ecx, 17
    setz sil                   ; dl = 0
    sub      edx, esi               ; edx = 12

    pshufb   xmm3, xmm4
    movdqu   [r8], xmm3
    add      r8, rdx
    xor      edx, edx
    jmp .clear_whitespace

.full:
    movdqu   [r8], xmm3
    mov      rsi, 1
    add      r8, 16
    jmp .clear_whitespace

.end:
    ; ── Get Output Size ──────────────────────────────────────────────────────
    sub r8, [input_pointer]
    mov [output_size], r8

    ; ── Open output file ─────────────────────────────────────────────────────
    mov     rax, 2 ;open
    mov     rdi, [rsp+24] ; argv[2] = file name
    mov     rsi, 0o1101   ; truncate: 0o1000, create: 0o100, write only: 1
    mov     rdx, 0o644    ; rw-r--r-- r=4, w=2, 4+2=6, 4, 4
    syscall
    cmp     rax, 0
    jl      .open_output_error
    mov     [output_descriptor], rax

    ; ── Write buffer to output file ──────────────────────────────────────────
    mov     rax, 1 ;write
    mov     rdi, [output_descriptor] ; file descriptor
    mov     rsi, [input_pointer]     ; buffer pointer
    mov     rdx, [output_size]       ; bytes to write
    syscall
    cmp     rax, 0
    jl      .write_error

    ; ── Close output file ────────────────────────────────────────────────────
    mov     rax, 3 ;close
    mov     rdi, [output_descriptor]
    syscall

    ; ── munmap: free the allocated memory ────────────────────────────────────
    mov rax, 12
    mov rdi, [input_pointer]
    syscall


    ; ── Exit success ─────────────────────────────────────────────────────────
    mov     rax, 60 ;exit
    xor     rdi, rdi
    syscall

    ; ── Error handlers ───────────────────────────────────────────────────────
.usage_error:
    mov     rsi, usage
    mov     rdx, usage_length
    jmp .print_error

.open_input_error:
    mov     rsi, open_input
    mov     rdx, open_input_length
    jmp .print_error

.fstat_error:
    mov     rsi, fstat
    mov     rdx, fstat_length
    jmp .print_error

.mmap_error:
    mov     rsi, mmap
    mov     rdx, mmap_length
    jmp .print_error

.open_output_error:
    mov     rsi, open_output
    mov     rdx, open_output_length
    jmp .print_error

.read_error:
    mov     rsi, write
    mov     rdx, write_length
    jmp .print_error

.write_error:
    mov     rsi, write
    mov     rdx, write_length

.print_error:
    mov rax, 1; write
    mov rdi, 2; terminal
    syscall

.exit_error:
    mov     rax, 60 ;exit
    mov     rdi, 1  ;error
    syscall
