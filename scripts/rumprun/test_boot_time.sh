export PATH="${PATH}:$(pwd)/rumprun/bin"
rumprun-bake hw_virtio httpd.bin  httpd/httpd
echo $(date +"%T.%N") > cont.out
sudo ./run_qemu_bg.sh
awk '
		/rump kernel bare metal bootstrap/ { print }
		/fail/ || /accept/ { print }
	' cont.out
stty echo
#make CC=x86_64-rumprun-netbsd-gcc