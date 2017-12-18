#! /bin/bash

################################################
# Install package managers
################################################

# install homebrew package manager
if [ ! -f /usr/local/Homebrew/bin/brew ]
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install brew cask to enable text installation of gui applications
if [ ! -d /usr/local/Homebrew/Library/Taps/caskroom/homebrew-cask ]
then
    brew tap caskroom/cask
fi

#################################################
# install python and ansible
#################################################
if [ ! -f /usr/local/opt/python/libexec/bin/python ]; then brew install python; fi
if [ $(which python) != "/usr/local/opt/python/libexec/bin/python" ]
then
    export PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi
if [ ! -f /usr/local/bin/ansible ]; then pip install ansible; fi 

#################################################
# configure osx settings
#################################################

# enable firewall ANS TODO needs work
#sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
#sudo launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plist
#sudo launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist
#
#sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
#sudo launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist
#

# set key repeat rate to something reasonable
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# set desktops up as desired
#defaults write -g DesktopLocationFixed

# disable automatically adjust brightness

#require fn key to change volume/brightness etc.
defaults write -g com.apple.keyboard.fnState -boolean true

# set mouse to scroll in the traditional direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# kill all dock defaults
defaults delete com.apple.dock;killall Dock

# set dock to the left side
defaults write com.apple.dock orientation -string left

# set dock to hide automatically
defaults write com.apple.dock autohide -bool TRUE

# make sure that new settings aren't overwritten by current settings
sleep 1
killall Dock
