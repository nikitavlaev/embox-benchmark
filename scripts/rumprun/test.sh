export PATH="${PATH}:$(pwd)/rumprun/bin"
x86_64-rumprun-netbsd-gcc -o time-test-rumprun time_test.c
rumprun-bake hw_virtio time-test-rumprun.bin  time-test-rumprun
gcc time_test.c -o time_test
./time_test | ts 
rumprun qemu -i time-test-rumprun.bin | ts 
