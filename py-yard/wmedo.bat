C:\prg\miniconda3\Scripts\watchmedo.exe --help


goto :end



C:\prg\miniconda3\Scripts\watchmedo.exe shell-command  --patterns="*.py;*.txt"  --command='echo "${watch_src_path}"' c:\0\1




    
REM C:\prg\miniconda3\Scripts\watchmedo.exe --patterns="*.sql" --command='~/Desktop/load_files_into_mysql_database.sh'






=================================================

https://stackoverflow.com/questions/182197/how-do-i-watch-a-file-for-changes



Simplest solution for me is using watchdog's tool watchmedo

From https://pypi.python.org/pypi/watchdog I now have a process that looks up the sql files in a directory and executes them if necessary.

watchmedo shell-command \
--patterns="*.sql" \
--recursive \
--command='~/Desktop/load_files_into_mysql_database.sh' \
.


=================================================

:end
pause