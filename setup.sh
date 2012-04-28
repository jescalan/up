#!/bin/sh

echo "-------------------------------------------------------------";
echo "Please enter your password, we have to move some files around";
echo "-------------------------------------------------------------";

sudo echo "perfect!"

echo "-----------------------------";
echo "Setting up command line prefs";
echo "-----------------------------";

mv ~/.bash_profile ~/.bashrc;
echo "PS1='\[\e[0;31m\]⚡\[\e[m\] \[\e[0;33m\]\${PWD##*/}\[\e[m\] '" >> ~/.bashrc;
source ~/.bashrc;

echo "-------------------";
echo "Installing Homebrew";
echo "-------------------";

/usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)";
brew update;

echo "----------------";
echo "Installing rbenv";
echo "----------------";

brew install rbenv;
echo 'export PATH="$HOME/.rbenv/bin:/usr/local/bin:$PATH"' >> ~/.profile;
echo 'eval "$(rbenv init -)"' >> ~/.profile;
source ~/.profile;

echo "---------------------";
echo "Installing ruby-build";
echo "---------------------";

brew install ruby-build;

echo "---------------------";
echo "Installing ruby 1.9.3";
echo "---------------------";

rbenv install 1.9.3-p125;
rbenv rehash;
rbenv global 1.9.3-p125;

echo "--------------";
echo "Installing git";
echo "--------------";

brew install git;

echo "-----------------";
echo "Updating rubygems";
echo "-----------------";

sudo gem update --system;
sudo touch ~/.gemrc;
sudo echo "gem: --no-ri --no-rdoc" >> ~/.gemrc;

echo "------------------";
echo "Installing bundler";
echo "------------------";

sudo gem install bundler;

echo "--------------";
echo "Installing pow";
echo "--------------";

curl get.pow.cx | sh;

echo "-----------------";
echo "Installing powder";
echo "-----------------";

sudo gem install powder;

echo "-------------------------------------";
echo "Installing haml, sass, & coffeescript";
echo "-------------------------------------";

sudo gem install haml;
sudo gem install sass;
sudo gem install coffee-script;

echo "-----------------";
echo "Installing stasis";
echo "-----------------";

sudo gem install stasis;

echo "----------------";
echo "Installing rails";
echo "----------------";

sudo gem install rails;

echo ""
echo "Boom! All finished. Everything should be good to go."
echo ""