## Research results
0. Learned about unikernels, main concepts
1. Figured out, that Rumpkernel OS is best candidate for benchmark,
shortly, because it's structure has much in common with Embox's, and it's 
development was driven by the same goals
2. Learned how to create and launch apps using Embox
3. Tinkered some rumprun scripts to work on my Ubuntu 18.04
4. Did step 2 for rumprun, with more tinkering
5. Chose qemu as machine emulator, because it is only one properly supported
for both OS, and learned how to use it
5. Came to decision, that measuring boot time with light network config will
be a good start, mainly because it is a common usecase of unikernels and it
is less problematic to implement
6. Created simple boot time test scripts for both OS
6. Found a way to create custom configs for rumprun
7. Working on creating equivalent configs
