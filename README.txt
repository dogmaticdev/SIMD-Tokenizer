Assembly Tokenizer that can parse more than 1 gigabytes of ascii per second.
This is relatively slow in comparison to https://github.com/WojciechMula/toys/tree/master/avx512-remove-spaces
That program focuses on the AVX512VBMI2 CPU Architecture, This one uses SSE2 and is applicable universally in comparison.

This program takes inputted text, removes whitespace, and seperates strings with a null terminator.

stats:
11998 bytes in 12754 nano seconds
11998 ÷ 0.000012754 = 940724479 bytes, or 0.94gb/s

31346 bytes in 22042 nano seconds 
31346 ÷ 0.000027334 = 1422103257.4 bytes, or 1.42gb/s

These stats are taken from my Ryzen 7 3700X 8-core processor that I got off ebay for like 60 bucks.
As you can probably notice there is a very obvious increase in its speed, and it will most certainly cross 1.5gb/s If pushed to such extents.

It currently only works on linux, I won't be making it cross platform any time soon.

To build get nasm and run:
nasm -f elf64 tokenizer.asm -o tokenizer.o && ld tokenizer.o -o tokenizer

to use:
./tokenizer input.txt output.txt

There are no plans to create proper documentation or make this accesible to your language of choice.
Not unless, you wish to do that, or sponsor me to.

I made this for the programming language I am making, so I may only come back to it in a while.
