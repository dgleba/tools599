'
' How to start a windows batch file with no visible window..
' http://stackoverflow.com/questions/18881221/how-to-start-a-batch-file-minimized-with-task-scheduler-in-windows-8-comspec
' start a batch file so it will be invisible. no batch window is visible...
' %SystemRoot%\system32\wscript.exe
' parameters: "invisible.vbs" "test.bat" //nologo
' 2017-03-07_Tue_08.04-AM David Gleba
'
' in task scheduler:
'  <Actions Context="Author">
'    <Exec>
'      <Command>%SystemRoot%\system32\wscript.exe</Command>
'      <Arguments>"invisible.vbs" "test.bat" //nologo</Arguments>
'      <WorkingDirectory>c:\crib\script</WorkingDirectory>
'    </Exec>
'  </Actions>
'  
' usage: %SystemRoot%\system32\wscript.exe "invisible.vbs" "myscript.cmd" //nologo
'        %SystemRoot%\system32\wscript.exe   "C:\data\script\movefiles575\invisible.vbs"  "C:\data\script\movefiles575\start-move-files-575.bat" //nologo

CreateObject("Wscript.Shell").Run """" & WScript.Arguments(0) & """", 0, False
