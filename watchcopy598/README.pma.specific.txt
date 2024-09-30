
Installation specific to PM-A

ver: 2021-10-29 - v01

=================================================

Installation on  cmm 10001:

This cmm receives files from the other cmms so they get ingested to litmus from this cmm.

install it like the others, but the share to c:\data\cmm\litmus must be writable by the other cmms copying files to this cmm.

create shares 
	- c:\data\cmm\watchedoutput\litmus   readwrite


=================================================

Installation on other cmms:


run  C:\data\script\tools599\watchcopy598\update-local-598.bat

run  C:\data\script\tools599\watchcopy598\copy.initial.config.bat

modify qccalc to pick up files from "C:\data\cmm\watchedoutput\qccalc"

import tasks to task scheduler


=================================================


_____________

List:

cmm 10000 = \\pma-cmm1
C:\Users\pmdacmm.STACKPOLE>whoami stackpole\pmdacmm

=

cmm 10001


_____________


=================================================


Machine	System	Gauge	hostname	IP Address	whoami	QC-Gauge Spec Plan Name	Litmus file watcher Function
Duramax CMM Lab	CMM Computer (Duramax)	CMM	PMDA-DuramaxCMM	10.4.110.89		QC-Calc	not using this 
CMM10000	CMM Computer (10000)	CMM	PMA-CMM1	10.4.72.5	stackpole\pmdacmm	QC-Calc	copies litmus files to cmm10001
CMM10001	CMM Computer (10001)	CMM	PMDA-BKH70W2	10.4.71.61	stackpole\ymei	QC-Calc	Other CMMs copy litmus files to this one
CMM10100	CMM Computer (10100)	CMM	PMC-PRISMO1	10.4.72.10	prismo1	QC-Calc	copies litmus files to cmm10001
CMM10099	CMM Computer (10099)	CMM	PMDA-BKJ50W2	10.4.71.213		QC-Calc	DO NOT install watcher. It copies all files to to cmm10001 \result folder