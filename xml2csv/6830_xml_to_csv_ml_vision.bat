::@echo off


"C:\Users\Vision\AppData\Local\Programs\Python\Python37\python.exe" "C:\data\script\tools599\xml2csv\6830_xml_to_csv_ml_vision.py"
timeout 3


:: Run parts.produced.report
c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/tools599/xml2csv/parts-inspected.6830.sh"
timeout 92
