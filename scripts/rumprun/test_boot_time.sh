export PATH="${PATH}:$(pwd)/rumprun/bin"
rumprun-bake hw_virtio httpd.bin  httpd/httpd
export LC_NUMERIC="en_US.UTF-8"
SUM="0.0"
rm -f res.txt
touch res.txt
echo $1 > res.txt
for (( i=1; i <= $1; i++ ))
do
	sudo ./run_qemu_bg.sh
	t1=$(awk '
			/rump kernel bare metal bootstrap/ { print $1}
			/accept/ {}
		' cont.out)
	t2=$(awk '
			/rump kernel bare metal bootstrap/ {}
			/accept/ { print $1}
		' cont.out)
	stty echo
	echo $t1
	echo $t2
	d1=$(date -d $t1 +%S%N)
	d2=$(date -d $t2 +%S%N)
	DIFFNANO=$(expr ${d2} - ${d1})
	res=$(echo "($DIFFNANO / 1000000)" | bc -l)
	DIFFMS=$(printf %.2f $res) 
	echo "init time: $DIFFMS" | tee -a res.txt
	SUM=$(echo "${SUM} + ${DIFFMS}" | bc -l)
done 
AVG=$(echo "($SUM / $1)" | bc -l)
echo "average init time = $AVG" | tee -a res.txt
#make CC=x86_64-rumprun-netbsd-gcc