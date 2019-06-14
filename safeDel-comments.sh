#! /usr/bin/env bash

AUTHOR="Michael Kofi Badu"
STUDENTNUMBER="S1719029"
trashCan="$HOME/.trashCan"
USAGE="usage: $0 file [file ...]" 

# Creating the trashCan directory
main(){
#The printf accepts the format string which is used to display the author and the student number
#The printf displays the string in the defined standard output
	printf "$AUTHOR $STUDENTNUMBER\n"
	# if there is no trashCan directory does not exist, then make one 
	if [[ ! -e $trashCan ]]; then
#The trashcan is defined with an if condition to check if it is available
	   	 mkdir $trashCan
#The mkdir is used to create the directory of the trash can
		echo "trashCan created successfully!"
#After the trash can has been created the echo command is then used to display the line text
	fi
	if [[ $1 == "" ]]; then
#The arguments states if the trash Can is empty
		menu
   	 elif [[ -f $1 ]]; then 
        	mv $@ $trashCan
#The mv command moves the files to the trash can
        echo "$@ has been successfully moved to the trash can directory"
#The echo command displays the file has been moved to the trash can
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
#List all the files in the trash can and it select the specific raws from the list output
#based on the filename, type and size
ls -l $trashCan | awk '{print $9, $6, $5, $7}'
}

ctrlC(){
	echo -e "\r\nYou hit Ctrl-C. Are you exiting?!"
#exit makes your script stop execution at that point and return to the command line
    	exit 130
#This is exiting from the trap which requires to add 128 to the exit code that is been be used
# with an addition of 2 which was going to be the exit code which makes it exit 130
}

EndScript(){
#The -e enable echo's interpretation of additional instances of the newline character ("\r)
#As well as the interpretation of other special characters
    	echo -e "\r\nGoodbye $USER!"
#The should display that Goodbye User! when the EndScript in runned
}


#Recovering file from the trashCan
recover(){
#if the file/directory doesnt exist in trashCan directory
if [[ ! -f $trashCan"/"$1 && ! -d $trashCan"/"$1 ]]; then
#If the file and the directory does not exist in the trash
    	echo "$1 does not exist in this trashcan"
#Then the it should prompt the user that the trash can is empty
else
#move file to current directory
    	mv "$trashCan/$1" $1
	echo "The file $1 has been recovered to the current directory"
fi
}

#Deleting file in the trashCan
deleteFile(){
	echo "enter filename or directory:"
	read content
#if the value of cannot is a file or directory in the trash can
	if [[ -f "$trashCan/$content" || -d "$trashCan/$content" ]]; then
	echo "are you sure you want to delete $content ?"
	read input
	case $input in
	 n) echo "Skipped input";;
	 Y|*)
#if its a directory recursively delete
		if [[ -d "$trashCan/$content" ]]; then 
			rm -r "$trashCan/$content"
			echo "Successfully deleted $content"
		else 
#if its just a file do normal delete
			rm "$trashCan/$content"
			echo "Successfully deleted $content"
		fi
		;;
                esac 
 	else echo "$content does not exist i this folder" 
	fi
}

# Total Usage in bytes of the trashcan directory
total(){
 	Display=$(du -c ${trashCan} | cut -f -1  )
#It echo's the total usage in bytes as per the instructions
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



