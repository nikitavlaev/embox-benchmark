#!/bin/bash
TIMEOUT="20"
OUTPUT_FILE=./cont.out
RUN_QEMU="./scripts/qemu/auto_qemu "
AUTOQEMU_NOGRAPHIC_ARG="-serial stdio -display none"

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
		/httpd/ { f = 1 }
		END { exit !(f) ? 2 : f }
	' $OUTPUT_FILE
}

sim_bg=

run_bg() {
	rm -f $OUTPUT_FILE
	touch $OUTPUT_FILE

	run_cmd="$RUN_QEMU"

	set +ve
	sudo PATH=$PATH \
		AUTOQEMU_KVM_ARG="$AUTOQEMU_KVM_ARG" \
		AUTOQEMU_NOGRAPHIC_ARG="$AUTOQEMU_NOGRAPHIC_ARG" \
		"$(sudo_var_pass AUTOQEMU_NICS)" \
		"$(sudo_var_pass AUTOQEMU_NICS_CONFIG)"	\
		"$(sudo_var_pass KERNEL)" \
		USERMODE_START_OUTPUT="$USERMODE_START_OUTPUT" \
	    $run_cmd | ts '%H:%M:%.S' | tee -a $OUTPUT_FILE &
	
		
	pids=($(jobs -l | perl -pe '/(\d+) /; $_=$1 . "\n"'))
	echo ${pids[0]}
	sim_bg=${pids[0]}

	export OUTPUT_FILE
	export -f run_check
    echo '>>>>>>>>>> start checking'
	timeout $TIMEOUT bash -c '
        $(run_check)
        st=$?
        echo $st
        while [ $st -eq 2 ]; do
            sleep 1
            $(run_check)
            st=$?
            echo $st
        done' && \
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
		cat $OUTPUT_FILE >> res.txt
	fi
	#restore_conf
}

run_bg 
kill_bg
