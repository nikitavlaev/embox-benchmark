#!/bin/bash

TIMEOUT="10"
OUTPUT_FILE="./cont.out"
OUTPUT_FILE_1="cont.out"
RUN_QEMU="rumprun qemu -i -M 128 -I if,vioif,'-net tap,script=no,ifname=tap0' -g '-display none -vga none -serial stdio' -W if,inet,static,10.0.120.101/24 -- ./httpd.bin"
AUTOQEMU_NOGRAPHIC_ARG="-serial file:${OUTPUT_FILE} -display none"

sudo_var_pass() {
	if [ ${!1+defined} ]; then
		echo $1=${!1}
	else
		#output is passed to sudo that not likes empty arguments
		echo __T=
	fi
}

run_check() {
	awk '
		/^run: success auto poweroff/ || /embox>/ || /[a-z]+@embox/ { s = 1 }
		/fail/ || /accept/ { f = 1 }
		END { exit !(f || s) ? 2 : f || !s }
	' $OUTPUT_FILE
}

sim_bg=

run_bg() {
	rm -f $OUTPUT_FILE
	touch $OUTPUT_FILE

	run_cmd="$RUN_QEMU"

	set +ve
	PATH="${PATH}:$(pwd)/rumprun/bin:$(pwd)"
	rumprun qemu -i -M 128 -I if,vioif,'-net tap,script=no,ifname=tap0' -g '-display none -vga none -serial stdio' -W if,inet,static,10.0.120.101/24 -- ./httpd.bin | ts '%H:%M:%.S' | tee -a $OUTPUT_FILE &
	pids=($(jobs -l | perl -pe '/(\d+) /; $_=$1 . "\n"'))
	echo ${pids[0]}
	sim_bg=${pids[0]}
	export OUTPUT_FILE
	export -f run_check
    echo '>>>>>>>>>> start checking'
	timeout $TIMEOUT bash -c '
        echo Start
        $(run_check)
        st=$?
        echo $st
        while [ $st -eq 2 ]; do
            sleep 1
            $(run_check)
            st=$?
            echo $st
        done
        echo Finish' && \
		sleep 5 # let things to settle down
}

kill_bg() {
	# Sometimes $sim_bg is empty string, so we should make sure pstree is
	# called with acual PID (otherwise it will print every process running)

    echo '>>>>>>>>>>> KILL BG'
	if test -z "$sim_bg"
	then
		echo "warning: No background process running"
	else
		pstree -A -p $sim_bg | sed 's/[0-9a-z{}_\.+`-]*(\([0-9]\+\))/\1 /g' | xargs sudo kill
	fi

	#restore_conf
}

run_bg 
kill_bg
