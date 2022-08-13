Purpose: To copy files from corp server to GAA in a specified format.

Formats:
	1. train and eval split.
		- all files for training get split by an integer percentage to two folders, train and eval.
		- xml files will not be copied for folders named `OK` or `false_rejects`.
		- xml files will not be copied for folders named `flag` within the `OK` folder.
	2. allinone
		- files for inference. Must not contain any xml when copying to GAA.
	3. final_test
		- one folder that has known defects and only defects for a false pass comparison to be done by GAA.
		- other ones must be like allinone, where the xml files are to be removed.
		- for now xml files to be removed manually in this folder as needed.

Usage:
	python pyythonfile.py source_folder destination_folder [-options]
		options example: --train 80 --format train
		
		For training folder use --train [percentage between 0 and 100] --format train
		for allinone use (optional [--test 0]) --format allinone
		for final_test use (optional[--validate 0])  --format final_test



NOTE: Avoid trying to mix and match the options. It will copy the files incorrectly and will have to do it again. Feature to stop mixing and matching not yet added.


=================================================

examples:

python D:\data\script\tools599\datasplit\train_eval_split.py 

python D:\data\script\tools599\datasplit\train_eval_split.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12a d:\0\irt1  --train 50 --format train

python \\corp-fs01\CORP-PM\data_eng\project_folders\3010_python\trainevalsplit-py\train_eval_split.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12a d:\0\irt2  --train 50 --format train


python \\corp-fs01\CORP-PM\data_eng\project_folders\3010_python\trainevalsplit-py\train_eval_split.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12a d:\0\irt4 --train 50 --format train
python \\corp-fs01\CORP-PM\data_eng\project_folders\3010_python\trainevalsplit-py\train_eval_split.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12d d:\0\irt4 --train 50 --format train
python \\corp-fs01\CORP-PM\data_eng\project_folders\3010_python\trainevalsplit-py\train_eval_split.py  D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim\12e d:\0\irt4 --train 50 --format train


_____________


prep for ir7c:

set pybase=D:\data\script\tools599
set srcpath=D:\copyof\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\grp12_inner-rim


 python %pybase%\goodimgxml651\goodimg.makexml.651e.py  %srcpath%\12a\inner-rim_ml_gen\ok
 python %pybase%\goodimgxml651\goodimg.makexml.651e.py  %srcpath%\12d\clean
 python %pybase%\goodimgxml651\goodimg.makexml.651e.py  %srcpath%\12e\ok
 
del %srcpath%\12d\false_rejects-xml\*.xml
 python %pybase%\goodimgxml651\goodimg.makexml.651e.py  %srcpath%\12d\false_rejects-xml
 
del %srcpath%\12e\false_rejects-xml\*.xml
 python %pybase%\goodimgxml651\goodimg.makexml.651e.py  %srcpath%\12e\false_rejects-xml



python %pybase%\datasplit\train_eval_split.py  %srcpath%\12a d:\0\ir7c2 --train 70 --format train
python %pybase%\datasplit\train_eval_split.py  %srcpath%\12d d:\0\ir7c2 --train 70 --format train
python %pybase%\datasplit\train_eval_split.py  %srcpath%\12e d:\0\ir7c2 --train 70 --format train


set pybase=D:\data\script\tools599
set srcpath=\\corp-fs01\CORP-PM\data_eng\ml_lib\ml_lib_6830\validate\inner-rim\verified
python %pybase%\datasplit\train_eval_split.py  %srcpath% d:\0\ir7c-v1  --format final_test



