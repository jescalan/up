#!/bin/sh

# Apple Official Version - not yet supported by ruby-build

# cd ~/Desktop; curl -O http://up.jenius.me/command-line-tools.dmg; 
# hdiutil mount command-line-tools.dmg; 
# sudo cp -r /Volumes/Command\ Line\ Tools/ ~/Desktop; 
# open Command\ Line\ Tools.mpkg;
# rm ~/Desktop/Command\ Line\ Tools/

# OSX GCC Installer by Kenneth Reitz
# (https://github.com/kennethreitz/osx-gcc-installer/)

cd ~/Desktop;
curl -O http://up.jenius.me/gcc-installer.pkg
open ~/Desktop/gcc-installer.pkg

echo "";
echo "Sweet, ready to go. Finish the install, run 'curl http://up.jenius.me/setup | sh' and you'll be all set!"; 
echo "";