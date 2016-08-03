# wsl_gui_autoinstall.bat
Automatically install X Windows and PulseAudio within a WSL (Bash on Windows on Linux) environment

To run:

* Download "wsl_gui_autoinstall.bat"
* Some browsers will save it as "wsl_gui_autoinstall.bat.txt".  If this happens, rename it to remove the ".txt" suffix.
* Double-click on the downloaded file to run it
* Follow the on-screen instructions
* Run Bash as "bash --login" (the default bash doesn't use this flag).  Or, run "export DISPLAY=:0" inside each bash window that needs to support graphical output.

If the script opens in a text editor rather than running, it probably needs to be renamed.  Note that Windows hides the last file extension by default in many configurations.  It may be easy to do this using the "move" command at a Windows Command Prompt.

This script has only been lightly tested.  You will probably need to debug it on your own system.  Please read through the script and make sure you understand what it is doing before using it.

Thanks to @therealkenc, @fpqc, and many others on the [BashOnWindows bug-tracker](https://github.com/Microsoft/BashOnWindows/issues/486) for figuring out many of the individual steps in these scripts.  Most of them are also explained in more detail [here](http://wsl-forum.qztc.io/viewforum.php?f=6).
