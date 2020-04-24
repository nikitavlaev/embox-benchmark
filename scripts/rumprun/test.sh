#сcd ..; export PATH="${PATH}:$(pwd)/rumprun/bin"
x86_64-rumprun-netbsd-gcc -o helloer-rumprun helloer.c
rumprun-bake hw_virtio helloer-rumprun.bin helloer-rumprun
./helloer
rumprun qemu -i helloer-rumprun.bin 