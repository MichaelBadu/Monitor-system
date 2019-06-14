#!/usr/bin/env bash

#Monitor script for the safeDel.

AUTHOR="Michael Kofi Badu"
STUDENTNUMBER="S1719029"


 main(){
    printf "$AUTHOR $STUDENTNUMBER\n"

	while :
	do
		initial=()
		for f in ~/.trashCan/*; do
			initial+=($f)
		done
		startMonitor
	done

}

startMonitor(){
	sleep 15
	new_files=()
	for f in ~/.trashCan/*; do
    new_files+=($f)
done
	if (( "${#new_files[@]}" > "${#initial[@]}" ));then
    	echo "A new file has been added"
elif (( "${#new_files[@]}" < "${#initial[@]}" ));then
    	echo "A file has been removed"
else
    	for((i=0;i<${#initial[@]};i++))
        do
            	if [[ ! $(md5sum "${initial[$i]}" | awk '{print $1}') -eq $(md5sum "${new_files[$i]}"| awk '{print $1}') ]];then
                echo "${initial[$i]} has been modified."
            	fi
#            echo "${initial[$i]}"
        done
fi

}

main
