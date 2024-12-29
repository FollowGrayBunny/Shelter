OUTPUT_FORMAT("elf32-i386")  /* Formato ELF a 32 bit */
ENTRY(main)                  /* Punto di ingresso del kernel */

SECTIONS {
    . = 0x1000;              /* Caricamento del kernel a 0x1000 */
    .text : {
        *(.text)             /* Sezione del codice */
    }
    .rodata : {
        *(.rodata)           /* Sezione dei dati in sola lettura */
    }
    .data : {
        *(.data)             /* Sezione dati */
    }
    .bss : {
        *(.bss)              /* Sezione BSS (azzerata) */
    }
}
