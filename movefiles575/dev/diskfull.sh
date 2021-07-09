#!/bin/bash

# test example script.. check disk space used test script.  2021-03-25 rev:1

# usage:         c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/movefiles575/diskfull.sh"


# df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;

df -H | grep -E 'cygwin' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 20 ]; then
  echo "sending error email, ${usep}% on ${HOSTNAME} ..."
    # echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" | mail -s "Alert: Almost out of disk space $usep%" dgleba@stackpole.com
	# variables didnt pass through. Just go without.. /cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "test 491" -body "testing error email. ${usep}% on ${HOSTNAME}" -to "dgleba@stackpole.com" -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
	/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe 'send-mailmessage -subject "TEST ignore this..    Warning: Disk space 6365 IPC" -body "C: drive may be running out to disk space. Please check it." -to @("dgleba@stackpole.com", "kjarzecki@stackpole.com") -dno onFailure -smtpServer MESG01.stackpole.ca -from "dgleba@stackpole.com"'
  fi
done


notes_comments ()
{
$ df
Filesystem         1K-blocks       Used Available Use% Mounted on
C:/app/cyg/cygwin  982697980  309333756 673364224  32% /
N:                1468003600 1393890096  74113504  95% /cygdrive/n
P:                 419068924   74012376 345056548  18% /cygdrive/p
S:                1468003600 1393890096  74113504  95% /cygdrive/s
T:                1468003600 1393890096  74113504  95% /cygdrive/t
}

