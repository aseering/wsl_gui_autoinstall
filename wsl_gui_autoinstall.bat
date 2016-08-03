@ECHO OFF

SET "LINUXTMP=$(echo '%TMP:\=\\%' | sed -e 's|\\|/|g' -e 's|^\([A-Za-z]\)\:/\(.*\)|/mnt/\L\1\E/\2|')"
echo LINUXTMP = "%LINUXTMP%"

ECHO --- Running Linux installation.  You will be prompted for your Ubuntu user's password:
REM One big long command to be absolutely sure we're not prompted for a password repeatedly

echo yes ^| add-apt-repository ppa:aseering/wsl-pulseaudio > "%TMP%\script.sh"
echo apt-get update >> "%TMP%\script.sh"
echo apt-get -y install pulseaudio unzip >> "%TMP%\script.sh"
echo sed -i 's/; default-server =/default-server = 127.0.0.1/' /etc/pulse/client.conf >> "%TMP%\script.sh"
echo sed -i "s$<listen>.*</listen>$<listen>tcp:host=localhost,port=0</listen>$" /etc/dbus-1/session.conf >> "%TMP%\script.sh"
C:\Windows\System32\bash.exe -c "chmod +x '%LINUXTMP%/script.sh' ; tr -d $'\r' < '%LINUXTMP%/script.sh' | tee '%LINUXTMP%/script_clean.sh'; sudo '%LINUXTMP%/script_clean.sh'"

ECHO --- Downloading required third-party packages
ECHO --- VcXsrv...
C:\Windows\System32\bash.exe -xc "wget -cO '%LINUXTMP%/vcxsrv.exe' 'http://downloads.sourceforge.net/project/vcxsrv/vcxsrv/1.18.3.0/vcxsrv-64.1.18.3.0.installer.exe'"

ECHO --- PulseAudio...
C:\Windows\System32\bash.exe -xc "wget -cO '%LINUXTMP%/pulseaudio.zip' 'http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip'"

ECHO --- Installing packages
ECHO --- Running VcXsrv graphical installer; please accept all of the default options
"%TMP%\vcxsrv.exe"

ECHO --- Adding link for X Server to Startup Items
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Start Menu\Programs\Startup\VcXsrv.lnk');$s.TargetPath='%ProgramFiles%\VcXsrv\vcxsrv.exe';$s.Arguments=':0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl';$s.Save()"

ECHO --- Launching X Server.  DO NOT grant access to any network interfaces if prompted; they are unnecessary.
"%userprofile%\Start Menu\Programs\Startup\VcXsrv.lnk"

ECHO --- Adding X environment variable to your .bashrc
C:\Windows\System32\bash.exe -xc "echo 'export DISPLAY=localhost:0' >> ~/.bashrc"

ECHO --- Extracting PulseAudio
md "%TMP%\pulseaudio"
C:\Windows\System32\bash.exe -xc "unzip -o '%LINUXTMP%/pulseaudio.zip' -d '%LINUXTMP%/pulseaudio'"

ECHO --- Installing PulseAudio
xcopy /e "%TMP%\pulseaudio" "%AppData%\PulseAudio"

ECHO --- Setting PulseAudio to run at startup
echo set ws=wscript.createobject("wscript.shell") > "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_pulseaudio.vbe"
echo ws.run "%AppData%\PulseAudio\bin\pulseaudio.exe --exit-idle-time=-1",0 >> "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_pulseaudio.vbe"

REM Recomended/required settings
echo load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 >> "%AppData%\PulseAudio\etc\pulse\default.pa"
"%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_pulseaudio.vbe"
ECHO When prompted, DO NOT allow 'pulseaudio' access to any of your networks.  It doesn't need access.

ECHO All Done
PAUSE