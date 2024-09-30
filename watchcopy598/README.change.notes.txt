=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================
=================================================


=================================================

2021-08-24 04:29 PM 

\\pmda-bkh70w2\data\script\tools599\watchcopy598\watch598.ps1

change to..

      if ( $chrfound -and $hdrfound -and $fetfound) {
        Start-Sleep 8
        # Copy notified files from A to B
        $mts = (Get-Date).toString("yyyyMMdd_HH.mm.ss")
        robocopy $PathToMonitor $interimfolder $filechr $filehdr $filefet /mov /xo /is  /R:3 /W:4 /tee /log:$global:logpath\debug\robocopy.monitor-interim_$mts.txt



=================================================

2021-08-24 03:54:22 PM 

Parth: I want to ask you to change the folder that QCCalc picks up data from.
Current:  c:\result
New path: "C:\data\cmm\watchedoutput\qccalc"


\\pmda-bkh70w2\data\script\tools599\watchcopy598\watch598.ps1
\\pmda-bkh70w2\data\script\tools599\watchcopy598\zTS\watch598_T_2021-08-24__03.53.13.ps1

change to

      if ( $hdrfound -and $fetfound) {
        Start-Sleep 8
        # Copy notified files from A to B
        robocopy $PathToMonitor $interimfolder $filechr $filehdr $filefet /mov /xo /is  /R:3 /W:4

was
        robocopy $PathToMonitor $interimfolder $filechr $filehdr $filefet  /xo 


=================================================

