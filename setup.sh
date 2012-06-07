#!/bin/sh

function ask {
  while true; do
 
    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi
 
    # Ask the question
    read -p "$1 [$prompt] " REPLY

    # Default?
    if [ -z "$REPLY" ]; then
      REPLY=$default
    fi
 
    # Check if the reply is valid
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
 
  done
}

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

echo "------------------";
echo "Installing Node.js";
echo "------------------";
if ask "Do you want to install Node.js?"; then
  brew install node
  
  if ask "Do you want to install NPM?"; then
    curl http://npmjs.org/install.sh | sh
  fi

  if ask "Do you want to install ender?"; then
    npm install ender -g
  fi
fi


if [ ! -z $database ]; then
  if [ "$database" == "mysql" ]; then
    echo "----------------";
    echo "Installing MySQL";
    echo "----------------";
    brew install mysql;
    unset TMPDIR;
    mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp;

    if ask "Do you want to create launch agents for MySQL?" Y; then
      mkdir -p ~/Library/LaunchAgents
      # hopefully the plist name doesn't change
      find /usr/local/Cellar/mysql/ -name "homebrew.mxcl.mysql.plist" -exec cp {} ~/Library/LaunchAgents/ \;
      launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
    fi
    echo "Note: $ mysql.server {start,stop,restart}"


  else if [ "$database" == "mongo" || "$database" == "mongodb" ]; then
    echo "------------------";
    echo "Installing MongoDB";
    echo "------------------";
    brew install mongodb;

    if ask "Do you want to create the default db path?" Y; then
      sudo mkdir -p /data/db/
      sudo chown `id -u` /data/db
    fi


  else if [ "$database" == "redis" ]; then
    echo "-------------------";
    echo "Installing Redis.IO";
    echo "-------------------";
    brew install redis;

    if ask "Do you want to create launch agents for redis?" Y; then
      mkdir -p ~/Library/LaunchAgents
      find /usr/local/Cellar/redis/ -name "homebrew.mxcl.redis.plist" -exec cp {} ~/Library/LaunchAgents/ \;
      launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
    fi


  else if [ "$database" == "postegres" || "$database" == "postegresql" ]; then
    echo "---------------------";
    echo "Installing PostgreSQL";
    echo "---------------------";
    brew install postgresql;

    if ask "Is this your first install of Postgres?" Y; then
      initdb /usr/local/var/postgres;
    fi

    if ask "Do you want to create launch agents for Postgres?" Y; then
      mkdir -p ~/Library/LaunchAgents
      # hopefully the plist name doesn't change
      find /usr/local/Cellar/postgresql/ -name "homebrew.mxcl.postgresql.plist" -exec cp {} ~/Library/LaunchAgents/ \;
      launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    fi


  else 
    echo "This shouldn't even be possible!"
  fi
fi

echo "---------------------------------------------------------------------"
echo "Boom! All finished. Everything should be good to go."
echo "---------------------------------------------------------------------"