Run the following way.

python \\corp-fs01\CORP-PM\data_eng\project_folders\3010_python\trainevalsplit-py source_directory destination_directory


The program will ask you to input how the files should be formatted:
	3 options:
		train:
			-input an integer between 0 and 100 to represent the percentage of files that will go into the train folder.
			-This is meant for folders such as 10a, 11a, 10d, 11d, and etc.
		test:
			-this is meant for the folder that the model trained with the 10a folder is going to run the inference on.
			-this will not copy any of the xml files as the xml files are meant to generated by the model.
		validate:
			-this is meant for the validate folder, it will copy files exactly.
			-for now will have to remove the xml files from false rejects manually in the nok folders from production folder.
			-have been asked to keep xml files from a folder that we are sure of consists only rejects that the model has not seen.

