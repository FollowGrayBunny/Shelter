; Bootloader 1: Carica il kernel e lo avvia
[org 0x7C00]       ; Punto di inizio per il bootloader
BITS 16

start:
    ; Inizializza i segmenti
    cli                 ; Disabilita interruzioni
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack iniziale
    sti                 ; Abilita interruzioni

    ; Mostra un messaggio iniziale
    mov si, msg_bootloader
print_msg:
    lodsb
    or al, al
    jz load_kernel
    mov ah, 0x0E
    int 0x10
    jmp print_msg

load_kernel:
    ; Carica il kernel (settori 2-18) in memoria a 0x1000
    mov ah, 0x02        ; Funzione BIOS per leggere
    mov al, 17          ; Numero di settori (2-18)
    mov ch, 0           ; Cilindro 0
    mov cl, 2           ; Settore 2
    mov dh, 0           ; Testina 0
    mov dl, 0           ; Disco (0 = floppy)
    mov bx, 0x1000      ; Destinazione in memoria
    int 0x13
    jc error            ; Salta a errore se c'è un problema

    ; Salta al kernel a 0x1000
    jmp 0x0000:0x1000

error:
    ; Mostra un messaggio di errore
    mov si, msg_error
print_error:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    int 0x10
    jmp print_error

halt:
    hlt
    jmp halt

msg_bootloader db "Bootloader: Caricamento del kernel...", 0
msg_error db "Errore: impossibile caricare il kernel.", 0

times 510-($-$$) db 0
dw 0xAA55          ; Firma del settore di boot
