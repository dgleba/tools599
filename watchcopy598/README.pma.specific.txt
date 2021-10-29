
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

import tasks


=================================================


_____________

List:

cmm 10000 = \\pma-cmm1
C:\Users\pmdacmm.STACKPOLE>whoami stackpole\pmdacmm

=

cmm 10001


_____________


=================================================

