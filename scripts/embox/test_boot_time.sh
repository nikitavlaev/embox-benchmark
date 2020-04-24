echo $(date +"%T.%N") > res.txt
./scripts/qemu/auto_qemu | ts '%H:%M:%.S' | tee log.txt
LINE=$(cat log.txt | awk '/ time/{print $1}')
echo $LINE >> res.txt
