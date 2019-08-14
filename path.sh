#!/usr/bin/bash

# store original IFS
original_ifs="$IFS";

# change IFS to colon as $PATH is colon seperated
IFS=":";

option="$1"
path="$2"

display_directories()
{
    for dir in $PATH;
    do
        echo "$dir"
    done
}

display_man_page()
{
    echo "Usage: path [option]... [PATH/COMMAND]..."
    echo "Add/Remove/Find PATH/COMMAND in \$PATH"

    echo -e "\nOptions:"
    echo "     no option    display all directories in \$PATH"
    echo "    -C, --check   check if directory is present in \$PATH"
    echo "    -F, --find    display path of command"
    echo "    -A, --add     add directory to \$PATH"
    echo "    -R, --remove  remove directory from \$PATH"
    echo "    -H, --help    display help message"

    echo -e "\nNote:"
    echo "    run the script as source to reflect modifications in current shell"
    echo "    add an alias to access from anywhere and to run as source"
    echo "    alias path=\"source <script path>/path.sh\""

    echo -e "\nExamples:"
    echo "root@kali:~# path"
    echo "root@kali:~# path --check /bin"
    echo "root@kali:~# path --find ls"
    echo "root@kali:~# path --add /root/myscripts"
    echo "root@kali:~# path --remove /root/myscripts"
    echo "root@kali:~# path --help"
}

check_directory()
{
    if [[ $PATH == *"$1"* ]]; then
        return 1
    else
        return 0
    fi
}

find_command_path()
{
    for dir in $PATH;
    do
        if [ -e "$dir/$1" ]; then
            echo "$dir/$1"
            return
        fi
    done

    echo "Command not found"
}

add_directory()
{
    # check path already in $PATH
    check_directory "$1"
    if [ $? == 1 ]; then
        echo "$1 already in \$PATH"
        return
    fi

    if [ -z "$PATH" ]; then
        PATH="$1"           # first entry
    else
        PATH="${PATH}:$1"   # subsequent entry
    fi

    echo "${PATH}"
}

remove_directory()
{
    # check if path present in $PATH
    check_directory "$1"
    if [ $? == 0 ]; then
        echo "$1 not found in \$PATH"
        return
    fi

    original_path="${PATH}"
    PATH=""

    for dir in $original_path;
    do
        if [[ "$dir" != "$1" ]]; then
            PATH+="$dir$IFS"
        fi
    done

    # remove trailing $IFS
    PATH=${PATH:0:-1}
    echo "${PATH}"
}

handle_check_option()
{
    if [ -z "$1" ]; then
        echo "Enter a path to check"
    else
        check_directory "$1"
        if [ $? == 1 ]; then
            echo "Yes"
        else
            echo "No"
        fi
    fi
}

handle_find_option()
{
    if [ -z "$1" ]; then
        echo "Enter a command to find"
    else
        find_command_path "$1"
    fi
}

handle_add_option()
{
    if [ -z "$1" ]; then
        echo "Enter a path to add"
    else
        add_directory "$1"
    fi
}

handle_remove_option()
{
    if [ -z "$path" ]; then
        echo "Enter a path to remove"
    else
        remove_directory "$path"
    fi
}

handle_invalid_option()
{
    echo "path: invalid option -- '$1'"
    echo "try 'path --help' for more information."
}

# remove trailing forward-slash(/)in path if any
if [ ! -z "$path" ] && [ "${path: -1}" == "/" ]; then
    path="${path%?}"
fi

if [ -z "$option" ]; then
    display_directories
elif [ "$option" == "-H" ] || [ "$option" == "--help" ]; then
    display_man_page
elif [ "$option" == "-C" ] || [ "$option" == "--check" ]; then
    handle_check_option "$path"
elif [ "$option" == "-F" ] || [ "$option" == "--find" ]; then
    handle_find_option "$path"
elif [ "$option" == "-A" ] || [ "$option" == "--add" ]; then
    handle_add_option "$path"
elif [ "$option" == "-R" ] || [ "$option" == "--remove" ]; then
    handle_remove_option "$path"
else
    handle_invalid_option "$option"
fi

# restore original IFS
IFS=$original_ifs;