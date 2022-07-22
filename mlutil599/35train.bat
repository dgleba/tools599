@echo off
:: set title to the batch file name.
title %~n0
@REM set date variables. cd to c:\temp so log files are placed there.
::REM[us region date] (setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
(setlocal enableDelayedExpansion & for /f %%a in ('wmic os get localdatetime') do (for /F "tokens=1 delims=." %%b in ("%%a") do (echo %%b>%temp%\tmpdate987123.txt & set /p t3=<%temp%\tmpdate987123.txt&set dt=!t3:~0,8!&set ts=!t3:~8,6!&set rand1=%random%)))
echo date vars.. dt=%dt%  ts=%ts% rand=%rand1%
(setlocal enableDelayedExpansion&set tmpdir=c:\temp\mllog&mkdir !tmpdir!>nul 2>nul)
c:&cd c:\temp&echo on



REM # Model training 1 GPU. Make sure number of batches=1 in config file:
REM # empty out training folder..

:: usage:  d:\data\script\tools599\mlutil599\35train.bat

d:
rename d:\crib\traintf1-01\training training%random%
mkdir D:\crib\traintf1-01\training
cd d:\crib\traintf1-01
rename training\trainout.txt trainout_pre%dt%_%ts%_%rand1%.txt
echo -=-=-=-=-=-=-=-=-=-=--=-=-=- date vars.. dt=%dt%  ts=%ts% rand=%rand1% 2>&1|D:\data\script\tools599\mlutil599\tee -a training\trainout.txt

nvidia-smi 2>&1|D:\data\script\tools599\mlutil599\tee -a training\trainout.txt

python D:\data\script\tools599\mlutil599\cleargpu.py

echo -=-=-=-=-=-=-=-=-=-=--=-=-=- date vars.. dt=%dt%  ts=%ts% rand=%rand1% 2>&1|D:\data\script\tools599\mlutil599\tee -a training\trainout.txt

python model_main.py --logtostderr --train_dir=training/ --pipeline_config_path=faster_rcnn_inception_v2_pets.config --model_dir=training/ 

::2>&1|D:\data\script\tools599\mlutil599\tee -a training\trainout.txt

