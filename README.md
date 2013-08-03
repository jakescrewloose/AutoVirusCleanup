AutoVirusCleanup
================

Automatically removes viruses by using a combination of tools with the ability to report back to the GFI MAX dashboard.

====================================
Description:
====================================
Basically this just automates cleaning up viruses using other tools to get the job done.

First of it kills open browsers
Then uses rKill to stop viruses in memory
Then runs TDSS killer followed by CCLeaner
Once that's done it runs a little further cleaning
It then scans with installs, updates and scans with malwarebytes
Finally it uses VipreRescue to do a scan of the system.

Now VipreRescue is a large download so expect this to take the longest.

====================================
Installation Procedure:
====================================
First of all create a test.bat file on your desktop
Open it in notepad and just type “echo test”

It’s just a placeholder for the time being.
This process will be a little nicer, but this is just to test.

Next upload it to the dashboard and call the script "Screwloose Malware Cleaner" (No talking marks obviously)
*See first Picture*

Then upload the script and add the script as a check for the computer you want to test it on.
*See Second Picture*

Next save this attached file on your desktop somewhere.
Then open the command prompt and run CleanUp.exe /API <YOUR API FROM THE GFI DASHBOARD> /URL <YOUR API URL>

The URL for Australia is system-monitor.com
I'm guessing the UK is system-monitor.co.uk
US is systemmonitor.us

*See Third Picture*

You can get the API from your dashboard by going to general>general settings then API on the left 

Then if all is done correctly then you should see a similar output to this
*See Fourth Picture*

Once complete look in your dashboard under notes on the device
And there you will have your scan results :)
*See Fifth Picture*

====================================
Changelog:
====================================
1g (10/03/2013)
- Added logfile output
- Fixed possible problems with Process killer whitelist

1f (10/03/2013)
- Replaced rKill with own process killer
- Recompiled with UPX Enabled.

1e (10/03/2013)
- Recompiled without UPX compression to stop getting False Positives.

1d (10/03/2013)
- Changed download process to include more error checking
- Changed GFI PostBack URL to use API URL Parameter

1c (10/03/2013)
- Implemented API URL for regions outside of Australia
- Fixed possible problem with Malwarebytes Updater Interaction.

1b (09/03/2013)
- Initial Public release
