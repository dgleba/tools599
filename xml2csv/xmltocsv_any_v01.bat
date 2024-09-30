::@echo off


cd C:\data\script\tools599\xml2csv
call .\venv001\Scripts\activate

python "C:\data\script\tools599\xml2csv\xmltocsv_any_v03.py" "D:\data\vision_6830\image_data" "D:\data\vision_6830\xml_to_csv_reports"
timeout 3

:: Run parts.produced.report
c:\prg\cygwin64\bin\bash.exe -l -c "/cygdrive/c/data/script/tools599/xml2csv/parts-inspected.6830.sh"
timeout 92

