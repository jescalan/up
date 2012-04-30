#!/bin/sh

database=''

while getopts ":d:" opt; do
  case $opt in
    d)
      case $OPTARG in
        mysql)      database=$OPTARG
                    ;;
        postgres)   database=$OPTARG
                    ;;
        postgresql)   database=$OPTARG
                    ;;
        mongo)      database=$OPTARG
                    ;;
        mongodb)      database=$OPTARG
                    ;;
        redis)      database=$OPTARG
                    ;;
        *)          echo "Invalid Database Option (add a ticket on https://github.com/jenius/up/issues to request others)"
                    ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument. (mysql, postgres, redis, or mongo)" >&2
      exit 1
      ;;
  esac
done

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
touch ~/.gemrc;
echo "gem: --no-ri --no-rdoc" >> ~/.gemrc;

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

if [ ! -z $database ]; then
  if [ "$database" == "mysql" ]; then
    echo "----------------";
    echo "Installing MySQL";
    echo "----------------";
    brew install mysql;
    unset TMPDIR;
    mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp;
  else if [ "$database" == "mongo" || "$database" == "mongodb" ]; then
    echo "------------------";
    echo "Installing MongoDB";
    echo "------------------";
    brew install mongodb;
  else if [ "$database" == "redis" ]; then
    echo "-------------------";
    echo "Installing Redis.IO";
    echo "-------------------";
    brew install redis;
  else if [ "$database" == "postegres" || "$database" == "postegresql" ]; then
    echo "---------------------";
    echo "Installing PostgreSQL";
    echo "---------------------";
    brew install postgresql;
    initdb /usr/local/var/postgres;
  else 
    echo "This shouldn't even be possible!"
  fi
fi

echo "---------------------------------------------------------------------"
echo "Boom! All finished. Everything should be good to go."
echo "If you installed a database, scroll up and make sure everything is ok"
echo "---------------------------------------------------------------------"
