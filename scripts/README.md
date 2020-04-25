# Scripts
Here are scripts, that can be used to recreate my results

## 1. Rumprun
Firstly you have to run this:  
$ git clone http://repo.rumpkernel.org/rumprun  
$ cd rumprun  
$ git submodule update --init  
Secondly, you have to copy version of build-rr.sh with my fixes to the to root of rumprun repo:  
After that, run this:  
$ CC=cc ./build-rr.sh hw  
Then you can use my scripts, placing them at the root directory of rumprun repo.  
