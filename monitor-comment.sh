#!/usr/bin/env bash

#Monitor script for the safeDel.

AUTHOR="Michael Kofi Badu"
STUDENTNUMBER="S1719029"
#Creating an array for all the files.
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
#After 15 seconds read the files in the trash can directory
	sleep 15
	new_files=()
	for f in ~/.trashCan/*; do
    new_files+=($f)
done
#compare the length if greater
	if (( "${#new_files[@]}" > "${#initial[@]}" ));then
    	echo "A new file has been added"
#Add a new file to the function
elif (( "${#new_files[@]}" < "${#initial[@]}" ));then

    	echo "A file has been removed"
else

    	for((i=0;i<${#initial[@]};i++))
        do
            	if [[ ! $(md5sum "${initial[$i]}" | awk '{print $1}') -eq $(md5sum "${new_files[$i]}"| awk '{print $1}') ]];then
                echo "${initial[$i]} has been modified."
            	fi

        done
fi

}

main
