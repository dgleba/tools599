@echo off
CALL C:\data\xml_to_csv_reports\6830_xml_to_csv_env\Scripts\activate.bat
@REM 
"C:\Users\Vision\AppData\Local\Programs\Python\Python37\python.exe" "C:\data\scripts\xml_to_csv_reports\6830_xml_to_csv_final.py" runserver

@REM python C:\scripts\xml_to_csv_reports\6830_xml_to_csv_with_scores_datetime_camera_previous_days_data.py runserver

timeout 1223



