#!/usr/bin/env bash




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@  
#@  status
#       I can't get this to work.
#@  
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   2022-07-19[Jul-Tue]15-17PM 

















set +vx
echo $0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# just some info about the script...

pwd1=$(pwd)
echo _________________Startingb $HOSTNAME,  pwd.. ,$pwd1,  ${BASH_SOURCE[0]},  $(date +" %Y-%m-%d_%H.%M.%S")
echo "  Bashsource full array: ${BASH_SOURCE[@]}"  # echo full bashsource array

# store full path and name with no special filename characters..
# shfname=$(echo `pwd`@${BASH_SOURCE[@]} | sed 's/\./_/g' | sed 's/\//!/g' )
shfname=$(echo `pwd`_@${BASH_SOURCE[@]} |  sed 's/\//,/g' )
echo "    shfname: $shfname "
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#limit to only one instance...
script_name=$(basename -- "$0")
p=$(pidof -x "$script_name" )
echo " scriptname pid: $script_name  $p"
if pidof -x "$script_name" -o $$ >/dev/null;then
   echo "An another instance of this script is already running, please clear all the sessions of this script before starting a new session"
   exit 1
fi


# Check if another instance of this script is running
pidof -o %PPID -x $0 
#>/dev/null && echo "ERROR: Script $0 already running, exiting." && exit 1

# Check if another instance of this script is running
pidof -o %PPID -x $(basename -- "$0") >/dev/null && echo "ERROR: Script $0 already running" && exit 1

echo try3
# Check if another instance of script is running
if pidof -o %PPID -x -- $(basename -- "$0") >/dev/null; then
  printf >&2 '%s\n' "ERROR: Script $0 already running. stopped."
  exit 1
fi

echo try4
me="$(basename "$0")";
running=$(ps h -C "$me" | grep -wv $$ | wc -l);
[[ $running > 1 ]] && exit;



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Main: 
# your code...


cntr=0
while ! [ -f /home/file/import1/scrapdumpDetail.sql ];
do
    echo "$cntr."
    sleep 2
    cntr=$((cntr + 1))
    if [ $cntr -ge 1001 ] ; then   exit 7 ; fi 
done

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

