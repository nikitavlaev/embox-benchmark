# Scripts
Here are scripts, that can be used to recreate my results

## 1. Embox
At first, you should install Embox: https://github.com/embox  
Then, run:  
$ make confload-x86/qemu  
Then, copy build.conf, mods.config and system_start.inc from /conf dir to the /conf directory of Embox  
After that,  
$ make  
Finally, you can add my other scripts to the root directory of Embox and you will be able to test Embox boot time like this:   
$ ./test_boot_time.sh 3  
Output will contain averaged boot time of 3 measurements.  
Also, you will be able to see that we also created mods_dist.png, which is the figure, containing info about module  initialization time.  


## 2. Rumprun
Firstly you have to run this:  
$ git clone http://repo.rumpkernel.org/rumprun  
$ cd rumprun  
$ git submodule update --init  
Secondly, you have to copy version of build-rr.sh with my fixes to the to root of rumprun repo:  
After that, run this:  
$ CC=cc ./build-rr.sh hw  
That should finish normally.  
After that, we need to build httpd.  
Copy httpd folder to the root of rumprun directory.  
Then, run:  
$ export PATH="${PATH}:$(pwd)/rumprun/bin"  
$ cd httpd  
$ make CC=x86_64-rumprun-netbsd-gcc  
$ cd ..  
Then you can use my scripts, placing them at the root directory of rumprun repo, to see timestamps of the start and finish of the rumprun boot. 
