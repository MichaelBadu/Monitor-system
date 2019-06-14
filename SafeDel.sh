#! /usr/bin/env bash

AUTHOR="Michael Kofi Badu"
STUDENTNUMBER="S1719029"
trashCan="$HOME/.trashCan"
USAGE="usage: $0 file [file ...]" 


main(){


	printf "$AUTHOR $STUDENTNUMBER\n"

	if [[ ! -e $trashCan ]]; then

	   	 mkdir $trashCan

		echo "trashCan created successfully!"

	fi
	if [[ $1 == "" ]]; then

		menu
   	 elif [[ -f $1 ]]; then 
        	mv $@ $trashCan

        echo "$@ has been successfully moved to the trash can directory"

    	elif [[ -d $1 ]]; then
        mv  $1 $trashCan
        echo "$1 has been successfully moved to the trash can directory"
	else 
	while getopts :lr:dtmk args #options
		do
		  	case $args in
		     l) list;;
		     r) recover $OPTARG;;
		     d) deleteFile;; 
		     t) total;; 
		     w) bash monitor.sh;; 
		     k) 
			trap ctrlC SIGINT
			trap EndScript EXIT
			
		     ;;     
		     :) echo "data missing, option -$OPTARG";;
		    \?) echo "$USAGE";;
		  esac
		done
	fi
}

list(){

ls -l $trashCan | awk '{print $9, $6, $5, $7}'
}

ctrlC(){
	echo -e "\r\nYou hit Ctrl-C. Are you exiting?!"

    	exit 130

}

EndScript(){

    	echo -e "\r\nGoodbye $USER!"

}



recover(){

if [[ ! -f $trashCan"/"$1 && ! -d $trashCan"/"$1 ]]; then

    	echo "$1 does not exist in this trashcan"

else

    	mv "$trashCan/$1" $1
	echo "The file $1 has been recovered to the current directory"
fi
}


deleteFile(){
	echo "enter filename or directory:"
	read content

	if [[ -f "$trashCan/$content" || -d "$trashCan/$content" ]]; then
	echo "are you sure you want to delete $content ?"
	read input
	case $input in
	 n) echo "Skipped input";;
	 Y|*)

		if [[ -d "$trashCan/$content" ]]; then 
			rm -r "$trashCan/$content"
			echo "Successfully deleted $content"
		else 

			rm "$trashCan/$content"
			echo "Successfully deleted $content"
		fi
		;;
                esac 
 	else echo "$content does not exist i this folder" 
	fi
}


total(){
 	Display=$(du -c ${trashCan} | cut -f -1  )

 	echo "$Display bytes"
}

Monitor(){
	bash $PWD/monitor.sh -w
}


menu(){
((pos = OPTIND - 1))
    shift $pos

    PS3='option> '

    if (( $# == 0 ))
    then if (( $OPTIND == 1 )) 
     then select menu_list in list recover delete total watch kill exit
          do 
		  case $menu_list in
		 "list") list;;
		 "recover")echo -n " Enter the name of the file or directory: "
		       read ans
		       recover $ans;;
		 "delete") deleteFile;;
		 "total") echo -n "Total usage: " 
		        du -sh $trashCan | awk '{print $1}';;
		 "monitor") bash monitor.sh;;
		 "kill")trap ctrlC SIGINT
			trap EndScript EXIT;;
		 "exit") exit 0;;
		 *) echo "unknown option";;
		 esac
          done
     fi
    else echo "extra args??: $@"
    fi
}
main $1



