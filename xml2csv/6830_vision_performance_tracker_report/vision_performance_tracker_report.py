# Import Modules
import xml.etree.ElementTree as ET 
import csv
import time
import os.path
from datetime import datetime, timedelta
import yaml

# ---------------------------Functions---------------------------------
# YAML LOADER
def loadYaml(filepath):
    with open(filepath, "r") as fileDescriptor:
        yamlFileContents = yaml.load(fileDescriptor, Loader=yaml.FullLoader)
    return yamlFileContents

# DATETIME RANGE FORMAT
def formatReportTime(dateInput):
    formatted = str(dateInput)
    formatted = formatted.replace("-","")
    formatted = formatted.replace(":","")
    formatted = formatted.replace(" ","")
    formatted = int(formatted)
    return formatted

# GET ONLY FILENAME FROM FULL FILENAME
def getFileNameDate(filename):
    nameDate = filename.split(".")[-2]
    return int(nameDate[-15:].replace("T", ""))

# GET CAMERA FROM FILENAME
def getCameraFromFile(filename):
    camera = "_".join(filename.split("_")[:-1])
    camera = camera.replace("_", " ").title()
    return camera

# GET DEFECTS FROM FILE
def getDefectFromFile(filepath):
    defectsInFile = []
    tree = ET.parse(filepath)
    root = tree.getroot()
    for objectTag in root.findall("object"):
        defect = objectTag[0].text
        defectsInFile.append(defect)
    return defectsInFile

# GET DATE FROM FILENAME
def getFileDate(filename):
    return filename[-19:-11]

# GET TIME FROM FILE
def getFileTime(filename):
    fileTime = filename[-10:-6]
    if fileTime[0] == "0":
        fileTime = fileTime[1:]
    return fileTime

# GET SHIFT NUMBER FROM FILE
def getShiftNumber(fileTime):
    fileTime = int(fileTime)
    if fileTime >= 630 and fileTime <= 1430:
        return 1
    elif fileTime >= 1430 and fileTime <= 2230:
        return 2
    elif fileTime >= 2230:
        return 3
    elif fileTime >= 0000 and fileTime <= 630:
        return 3

# Get Filename from path
def getFileName(filePath):
    filename = filePath.rsplit("\\",1)
    return filename

# ---------------------------Setup Global Variables---------------------------------
    
# Load Yaml Data
filepath = "config.yaml"
yamlFileContents = loadYaml(filepath)

# Assign Yaml Data to Variables
pathToFolder = str(yamlFileContents.get('path')) 
partNumber = str(yamlFileContents.get('productNumber'))
timeRange = yamlFileContents.get("timeRange")
# get timeRange value in Days
timeRangeDays = timeRange/24
reportEndTime = str(yamlFileContents.get("reportEndTime"))
# Pull Hour Minute Second from end time for Range
if len(reportEndTime) == 3:
    RETH = int(reportEndTime[0])
    RETM = int(reportEndTime[1:])
    RETS = 00
elif len(reportEndTime) == 4:
    RETH = int(reportEndTime[:2])
    RETM = int(reportEndTime[2:])
    RETS = 00

# Time
dateIso = datetime.now().replace(microsecond=0).isoformat()
dateForCSV = dateIso.replace("T", " ")
dateIso = dateIso.replace(":", "")


# XML Data and CSV Writer
xmlData = open(f'vision_performance_tracker_report{dateIso}.csv', 'w', newline='')
csvwriter = csv.writer(xmlData)
extensions = ('.png', '.xml')
xmlFiles = []
pngFiles = []
    
# Empty Lists
dates = []
shifts = [1, 2, 3]
cameras = []
defects = []
headers = []



# Get Ranges for file collection
# Oldest Files to include
reportOldest = datetime.today().replace(hour=RETH,minute=RETM,second=RETS,microsecond=0) - timedelta(days= timeRangeDays)
reportOldest = formatReportTime(reportOldest)


# Newest files to include
reportNewest = formatReportTime(datetime.today().replace(hour=RETH,minute=RETM,second=RETS,microsecond=0))


# Main Section of Code

# ---------------------Create and Write Headers for CSV File--------------------------------
headerId = headers.append('id')
headerProductNumber = headers.append('Product_Number')
headerDateRun = headers.append('date_run')
headerShift = headers.append('Shift')
headerChute = headers.append('Chute')
headerCamera = headers.append('Camera')
headerShortComment = headers.append('short_comment')
headerDefect = headers.append('defect')
headerDefectQty = headers.append('defect_qty')
headerDefentConfigured = headers.append('defect_configured')
headerReport = headers.append('report')
headerTotalType = headers.append('total_type')
headerTotalQty = headers.append('total_qty')
headerDataCpllectionTimestamp = headers.append('Data_Collection_Timestamp')
headerDataCollectionComment = headers.append('DataCollectioncomment')
headerModelVersion = headers.append('model_version')
headerLongComment = headers.append('long_comment')
csvwriter.writerow(headers)
# -------------------------Itterate Files Creating Lists-----------------------------
for subdirs, dirs, files in os.walk(pathToFolder):
    for filename in files:
        
            
        # Set Extension for PNG Files
        ext = os.path.splitext(filename)[-1].lower()
        if ext in extensions:
            fileNameDate = getFileNameDate(filename)
            
            # Check if fileNameDate is within range of search
            if fileNameDate >= reportOldest and fileNameDate <= reportNewest:
                    # If File is XML
                    if ext == extensions[0]:
                        # Get currentFilePath of PNG File and Append to pngFiles List
                        currentFilePath = (subdirs + "\\" + filename)
                        pngFiles.append(currentFilePath)
                        # Get Date Of PNG and Append to Dates
                        date = filename[-19:-11]
                        if date not in dates:
                            dates.append(date)
                    # If File is XML append to xmlFiles list
                    elif ext == extensions[1]:
                        currentFilePath = (subdirs + "\\" + filename)
                        xmlFiles.append(currentFilePath)
                        # Find Unique Cameras
                        camera = getCameraFromFile(filename)
                        if camera not in cameras:
                            cameras.append(camera)
                        # Find all Unique Defects
                        fileDefects = getDefectFromFile(currentFilePath)
                        for defect in fileDefects:
                            if defect not in defects:
                                defects.append(defect)

# --------------------------Main Script for organizing data-----------------------------
for date in sorted(dates):
    # Counter for each shift in a day for counting PNG Files
    shift1 = 0
    shift2 = 0
    shift3 = 0

    for pngFile in pngFiles:
        # Get Date of File and compare to current date in itteration
        pngDate = getFileDate(pngFile)
        if pngDate == date:
            # get shift number of shift and increase corresponding counter
            shiftNumber = getShiftNumber(getFileTime(pngFile))
            if shiftNumber == 1:
                shift1 += 1
            elif shiftNumber == 2:
                shift2 += 1
            elif shiftNumber == 3:
                shift3 += 1
    
    for shift in shifts:
        # FilesFound prevents empty entries in csv, xmlFilesFound counts xml files per shift
        filesFound = 0
        xmlFilesFound = 0
#----------------- Count amount of xml files per shift------------------
        for xml in xmlFiles:
            # Compare xml Date to current date itteration
            xmltree = ET.parse(xml)
            xmlroot = xmltree.getroot()
            xmlfilename = xmlroot[0].text
            xmlDate = getFileDate(xml)
            if xmlDate == date:
                fileShift = getShiftNumber(getFileTime(xml))
                if fileShift == shift:
                    xmlFilesFound += 1
#---------------------Itterate through list of cameras--------------------        
        for camera in cameras:
            # Create counters for defects and reset each loop
            defectCounters = []
            value = 0
            for defect in defects:
                defectCounter = [defect, value]
                defectCounters.append(defectCounter)
# ------------------Walk through xml files-------------------
            for xml in xmlFiles:
                xmltree = ET.parse(xml)
                xmlroot = xmltree.getroot()
                xmlfilename = xmlroot[0].text
                # Get file date and check if it matches the current date itteration
                xmlDate = getFileDate(xml)
                if xmlDate == date:
                    fileShift = getShiftNumber(getFileTime(xml))
                    if fileShift == shift:
                        # Get camera from file and check if it matches the camera in the itteration
                        cameraCounter = 0
                        # use getFileName to extract just the filename from the xml
                        fileName = getFileName(xml)[-1]
                        # get camera from fileName of xml
                        fileCamera = getCameraFromFile(fileName)
                        # Check if camera matches camera in current itteration
                        if fileCamera == camera:
                            filesFound += 1
                            cameraCounter += 1
#---------------Get Defects Per Camera in each file---------------------
                            defectsInFile = getDefectFromFile(xml)
                            for fileDefect in defectsInFile:
                                for defect in defectCounters:
                                    if fileDefect in defect:
                                        defect[1] += 1
#------------------------Writing Data To File---------------------------
            for defect in defectCounters:
                if defect[1] > 0:
                    csvInputs = []
                    csvTotalInputs = []
                    dateFormatted = date[0:4] + "-" + date[4:6] + "-" + date[6:]
                    # Append Data into list to be added to csv file
                    csvInputs.append(" ")
                    csvInputs.append(partNumber)
                    csvInputs.append(dateFormatted)
                    csvInputs.append(shift)
                    csvInputs.append("Reject")
                    csvInputs.append(camera)
                    csvInputs.append(" ")
                    csvInputs.append(defect[0])
                    csvInputs.append(defect[1])
                    csvInputs.append(" ")
                    csvInputs.append(" ")
                    csvInputs.append("Defect")
                    csvInputs.append(" ")
                    csvInputs.append(dateForCSV)
                    csvInputs.append(" ")
                    csvInputs.append("3")
                    csvInputs.append(" ")
                    # Write To CSV
                    csvwriter.writerow(csvInputs)

            if shift == 1:
                shiftpng = shift1
            elif shift == 2:
                shiftpng = shift2
            elif shift == 3:
                shiftpng = shift3
        # Only create total rows if files are found for a day
        if filesFound > 0:
           csvTotalInputs.append(" ")
           csvTotalInputs.append(partNumber)
           csvTotalInputs.append(dateFormatted)
           csvTotalInputs.append(shift)
           csvTotalInputs.append("Total")
           csvTotalInputs.append("Total")
           csvTotalInputs.append(" ")
           csvTotalInputs.append("Total")
           csvTotalInputs.append(" ")
           csvTotalInputs.append(" ")
           csvTotalInputs.append(" ")
           csvTotalInputs.append("Total Numbers")
           csvTotalInputs.append("Total QTY")
           csvTotalInputs.append(dateForCSV)
           csvTotalInputs.append(" ")
           csvTotalInputs.append("3")
           csvTotalInputs.append(" ")
           # insert data for totals in correct locations in total section and write row to file
           for i in range(1,5):
                if i == 1:
                    csvTotalInputs[-6] = "SlotRejectTotal"
                    csvTotalInputs[-5] = " "
                    csvwriter.writerow(csvTotalInputs)
                elif i == 2:
                    csvTotalInputs[-6] = "MultiRejectTotal"
                    csvTotalInputs[-5] = " "
                    csvwriter.writerow(csvTotalInputs)
                elif i == 3:
                    csvTotalInputs[-6] = "SystemPassTotal"
                    csvTotalInputs[-5] = shiftpng
                    csvwriter.writerow(csvTotalInputs)
                elif i == 4:
                    csvTotalInputs[-6] = "SystemRejectTotal"
                    csvTotalInputs[-5] = xmlFilesFound
                    csvwriter.writerow(csvTotalInputs)
# Close File
xmlData.close()


                    



            


