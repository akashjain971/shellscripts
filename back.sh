#! /bin/bash

display_man_page()
{
	echo "Usage: back [steps]"
	echo "moves [steps] back from the current directory"
	echo "0 will move to the previous path"
	echo "run the command as source to reflect in current shell"
}

if [ "$1" == "--help" ]; then
	display_man_page
elif [[ "$1" != [0-9]* ]]; then
    echo "back: invalid option -- '$1'"
    echo "try 'back --help' for more information."
elif [ "$1" == "0" ] && [ ! -z "$current_dir" ]; then
	cd "$current_dir"
	current_dir=""
else
	current_dir="$PWD"
	for (( i=0; i<$1; i++ )); do
   		cd ../
	done
fi
