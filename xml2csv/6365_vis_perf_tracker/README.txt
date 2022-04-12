1) CONFIGURE .YAML FILE
Prior to running the script, please configure settings 'config.yaml': 

a) path: path to folder containing files for report
  - Change this to be the folder that contains files for report to be made with
  - Format is 'C:\folder\subfolder\subfolder2\...\foldercontainingimages', 
  where the path is enclosed in single quotations, not double-scalar.

b) productNumber: Product number of current part that report will be made for
   - Change according to part number for report
  - Format is  "XX.XXXX" where X's are numbers, which must be surrounded by quotations marks

c) timeRange: number of hours back to search for files. will be the start time for the report
   - Change this according to how far back you would like the report to include files for
  - Format is  XXXX, where X's are numbers, and they are not to be enclosed by quotation marks
  
d) reportEndTime: time that report should end at and stop looking for files after this time
   - Change this according to the time you would like to end report at
	shift 1 = 630 (6:30am - 2:30pm)
	shift 2 = 1430 (2:30pm - 10:30pm)
	shift 3 = 2230 (10:30pm - 6:30am)
	
	report will not include files after reportEndTime.
	
  - Format is  XXX or XXXX where X's are numbers, and they are not to be enclosed by quotation marks

2) EXECUTING THE SCRIPT
Run the script 'scriptRevision.py' either through command prompt or in IDE terminal.
Running script 'scriptRevision.py' will create a .csv file where script is located,
containing data for all files within the given time parameters of config file.

3) REVIEW DATA
Open .csv file to review data. Report generated will include date and timestamp each time it is run,
so each time the script runs it does not override the existing report, but creates unique files each time.

- Format is vision_performance_tracker_reportYYYY-MM-DDTHHMMSS.csv 
Year-Month-Day-T-Hour-Minutes-Seconds

Example: vision_performance_tracker_report2021-07-26T112714.csv 
------------------------------------------------------------------------------
NOTES:
Added November 18, 2021 by K. Jarzecki

4) System total passes = all .png files that do not have a corresponding .xml file
System total rejects = number of .xml files
------------------------------------------------------------------------------
