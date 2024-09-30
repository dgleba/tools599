--------------------------------------------------------------------------------------------------------------------------------------------------------------------
XML Tag Editor - rev.6
Jan 07 2022
K. Jarzecki

New features added;

1) When generating .csv summary report, script will now list .png as well as .xml files, 
	but still only copies over .xml files into back-up zip folder.

2) Added 'Datetime Slice' header - this value represents the string within the filename that represents the datetime.
	Format of this string is YYYYMMDDTHHmmSS
	Ex. 211208T073235
	Headers in .csv file now include;
	- Full pathway, not including filename
	- Filename.extension
	- Camera name
	- Datetime stamp of image formatted to SQL format
	- Datetime Slice, as aforementioned
	- File extension

3) Script made to be more robust. 
- Looks for ALL .xml files in directory passed to the program, which could include .xml files with different
	filename formats and contents than the intended .xml files.
- Code will 'try' to extract all of the pertinent data, based on filename format
	- If there are any inconsistencies/out of range errors, script passes over this filename
	- When it passes it over, it adds it to a 'kick-out' list
- When it comes time to copy over files into the zip folder, script will ONLY copy over files
	that match the '.xml' file extension, as well as if they are NOT in the kick-out list.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
XML Tag Editor - rev.5
Jan 06 2022
K. Jarzecki

New feature added;

1) Script will now automatically create a .csv file summarizing all of the original .xml file data.

2) .csv file is named '__directory-name-passed-to-program__' + '-xml-back-up-' + datetime stamp.

3) Headers in .csv file include;
- Full pathway, not including filename
- Filename.extension
- Camera name
- Datetime stamp of image
- File extension

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
XML Tag Editor - rev.3
Jan 06 2022
K. Jarzecki

New feature added.

Script will now automatically create a back-up zip folder of all the .xml files found in the directory passed to it.

Zip folder is named '__directory-name-passed-to-program__' + '-xml-back-up-' + datetime stamp.

More specifically the program;
- Creates destination folder within the directory passed to program
- Copies all .xml files to this destination folder
- Creates a zip folder using the same destination folder name
- Copies over entire contents of destination folder to zip folder
- Clears unzipped destination folder and all its contents

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
XML Tag Editor - rev.2
Jan 04 2022
K. Jarzecki

Launch python script in command prompt.

XML Tag Editor Features:

1) Asks user input for directory of interest.

2) Program will generate a list of tags available to edit from all of the .xml files in the directory specified.

3) Asks which tag from the tag list you'd like to change.
	- If you deviate from one of the tag options provided, it will continue to loop until you type in an exact match
	to one of the tags. Ex. Tag list is ['Debris', 'Damage', 'Stain', 'Scratch', 'Misload']
	- It will not accept 'Debis', 'Stin', 'stain', 'Mislod', or any other strings that don't match the options exactly.
	- Response is case sensitive.

4) Asks if you want to replace with another tag, or delete.
	- WARNING: Once tags have been removed, they cannot be recovered.
	- Best practice is to make a back-up directory of the files you wish to edit before editing tags.

5) Asks for confirmation before proceeding (y/n).
	- If 'n', returns you to defect tag selection.
	- If 'y', makes changes, prints confirmation statement of changes made, then returns you to defect tag selection.

6) Takes you back to defect tag selection once changes have been completed.

7) Keeps log of changes in 'xml_tag_editor_logger.log', located in the same folder as the python script with date/time stamp

8) Changes can be viewed either by opening xml files, or in Image Labeller.

### LESSONS LEARNED FROM WRITING THIS SCRIPT-------------------------------
## Note about replacing tags with empty string - this breaks the .xml file. Anything after the broken tag will not be read. 
# It changes the <name>DEFECT</name> into '<name />' which stops the code from reading the file, and any defects that appear after this broken tag will not be read.
# Noticed this on outer_surface_211208T0723723.xml - Misload appeared at the very end of the script. It was not included after replacing
#  a different defect tag in the document, ex. Debris
# Because 'Debris' tags appeared in the document first, the first instance of '<name />' meant anything after it would not get read.
# Therefore, have to remove entire section of <object></object>, not just tag.text
--------------------------------------------------------------------------------------------------------------------------------------------------------------------