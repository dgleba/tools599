Purpose:
	- convert data from xml files into a csv file.

Usage:
	python pyythonfile.py source_folder destination_folder config_location.yaml [--options]
		- source
			- Enter the source folder path that you want to read the xml data from
		- destination
			- Enter the destination folder path where you want to save the csv file
		- config
			- Enter the path of where the appropriate config file is located. Refer to the howtouseyamlfiles.txt file for more info
		- Options
			--yesterday 
				- for use on the machine
				- it will take the folders with yesterday's date from the current date and convert the xml data into a csv file.
				

NOTE:
- DO NOT enter the option if you are not trying to get yesterday's data
	- for eg: when you are not running it on a machine.