#!/bin/bash
export LC_NUMERIC="en_US.UTF-8"
SUM="0.0"
rm -f res.txt
touch res.txt
echo $1 > res.txt
for (( i=1; i <= $1; i++ ))
do
	sudo ./run_qemu_bg.sh
	#sudo ./run_usermode_bg.sh
	t1=$(awk '
			/Embox kernel start/ { print $1}
			/httpd/ {}
		' cont.out)
	t2=$(awk '
			/Embox kernel start/ {}
			/httpd/ { print $1}
		' cont.out)
	stty echo
	echo $t1
	echo $t2
	d1=$(date -d $t1 +%S%N)
	d2=$(date -d $t2 +%S%N)
	DIFFNANO=$(expr ${d2} - ${d1})
	res=$(echo "($DIFFNANO / 1000000)" | bc -l)
	DIFFMS=$(printf %.2f $res) 
	echo "init time: $DIFFMS"
	SUM=$(echo "${SUM} + ${DIFFMS}" | bc -l)
done 
AVG=$(echo "($SUM / $1)" | bc -l)
echo "average = $AVG"
python3 get_mods_dist.py