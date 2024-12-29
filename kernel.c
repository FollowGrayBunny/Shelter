void main() {
    asm volatile (
        "xor %%ax, %%ax \n"
        "mov %%ax, %%ds \n"
        "mov %%ax, %%es \n"
        :
        :
        : "ax"
    );

    char *video_memory = (char *) 0xB8000;
    const char *msg = "HELLO KERNEL";
    for (int i = 0; msg[i] != '\0'; i++) {
        video_memory[i * 2] = msg[i];
        video_memory[i * 2 + 1] = 0x07;
    }

    while (1);
}
