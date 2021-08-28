
$path01 = "C:\data\move\test01"
$path02 = "C:\data\move\test02"

$path01 = "/cygdrive/c/data/move/test01"
$path02 = "/cygdrive/c/data/move/test02"


function offline {

# =================================================

# echo verbose

robocopy $path01 $path02  /xo

timeout 9




# =================================================

echo suppress extra report output lines.

echo  this prevents any meaning full file output. useless.

# robocopy $path01 $path02   /NDL /NP /ns /nc 

# /NS :: No Size – don’t log file sizes.
# /NC :: No Class – don’t log file classes.
# /NFL :: No File List – don’t log file names.
# /NDL :: No Directory List – don’t log directory names.
# /NP :: No Progress – don’t display % copied.




# =================================================



echo grep = best solution..

robocopy $path01 $path02 /np /xo |  C:\prg\cygwin64\bin\grep.exe  -v '*EXTRA File'

# =================================================


# end offline
}





# =================================================

# $cyg   = C:\prg\cygwin64\bin
# $rsync = "{0}\rsync.exe" -f $cyg
write-host $path01
C:\prg\cygwin64\bin\rsync -a $path01 $path02


# =================================================
# =================================================
# =================================================
# =================================================

timeout 1

