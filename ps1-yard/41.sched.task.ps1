
Get-ScheduledTask -taskname "*start*575*"

Get-ScheduledTask -taskname "*575*"

Enable-ScheduledTask -taskname "start*575*"

Enable-ScheduledTask -taskname "start move 575"

disable-ScheduledTask -taskname "start move 575"


# =================================================


It doesn't work the first time, then it works the second time.


PS C:\data\script\tools599\ps1-yard> 			disable-ScheduledTask -taskname "start move 575"
disable-ScheduledTask : Element not found.
At line:1 char:1
+ disable-ScheduledTask -taskname "start move 575"
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (PS_ScheduledTask:Root/Microsoft/...S_ScheduledTask) [Disable-ScheduledTask], CimException
    + FullyQualifiedErrorId : HRESULT 0x80070490,Disable-ScheduledTask



PS C:\data\script\tools599\ps1-yard> 			disable-ScheduledTask -taskname "start move 575"

TaskPath                                       TaskName                          State
--------                                       --------                          -----
\                                              start move 575                    Disabled


PS C:\data\script\tools599\ps1-yard>


# =================================================


