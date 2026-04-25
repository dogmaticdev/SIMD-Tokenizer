Assembly Tokenizer that can parse more than 1 gigabytes of ascii per second.
I didn't bother making a multi-threaded version, because this is already like 10-50 times faster than everything else.

More specifically, it takes inputted text, removes whitespace, and seperates strings with a null terminator.

stats:
12052 bytes in 11951 nano seconds
10448 ÷ 0.000011302 = 1008451175.6 bytes, or 1.00gb/s

31346 bytes in 27334 nano seconds 
31346 ÷ 0.000032241 = 1146776907.8 bytes, or 1.14gb/s

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
