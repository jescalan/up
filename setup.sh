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

# check to see if the user has already messed up their shit

if [-z "$(which rvm)"]; then
  echo "Looks like you installed RVM, which probably means your system is messed up"
  echo "and/or you have been tinkering with your environement and ruby."
  echo "email hello@jenius.me or talk to Jeff for further assistance"
  exit 1
fi

# if not, let's make it happen!

echo "-------------------------------------------------------------";
echo "Please enter your password, we have to move some files around";
echo "-------------------------------------------------------------";

sudo echo "perfect!"

echo "-----------------------------";
echo "Setting up command line prefs";
echo "-----------------------------";

if ask "Do you want to pimp your terminal prompt?"; then

  if [ -f ~/.bashrc ]; then
    cat ~/.bashrc >> ~/.profile
    rm ~/.bashrc
    echo "I moved your settings from ~/.bashrc to ~/.profile";
  fi

  if [ -f ~/.bash_profile ]; then
    cat ~/.bash_profile >> ~/.profile
    rm ~/.bash_profile
    echo "I moved your settings from ~/.bash_profile to ~/.profile";
  fi

  if [ -f ~/.bash_login ]; then
    cat ~/.bash_login >> ~/.profile
    rm ~/.bash_login
    echo "I moved your settings from ~/.bash_login to ~/.profile";
  fi

  echo "PS1='\[\e[0;31m\]⚡\[\e[m\] \[\e[0;33m\]\${PWD##*/}\[\e[m\] '" >> ~/.profile;

  if ask "Would you like some awesome command line shortcuts?"; then
    echo 'alias ll="ls -lahG"' >> ~/.profile
    echo 'alias reload="source ~/.profile"' >> ~/.profile
    echo 'alias profile="vim ~/.profile"' >> ~/.profile
    echo 'alias up="cd .."' >> ~/.profile
    echo 'alias desktop="cd ~/Desktop"' >> ~/.profile
    echo 'alias be="bundle exec"' >> ~/.profile
    echo 'alias go="git checkout"' >> ~/.profile
    echo 'alias godev="git checkout develop"' >> ~/.profile
    echo 'alias s="echo \"\"; git status -sb; echo \"\""' >> ~/.profile
    echo 'alias stage="git add ."' >> ~/.profile
    echo 'alias c="fact git commit -am"' >> ~/.profile
    echo 'alias got="git "' >> ~/.profile
    echo 'alias get="git "' >> ~/.profile
    echo 'alias glog="git log --graph --pretty=format:\"%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset\" --abbrev-commit --date=relative"' >> ~/.profile
    echo 'alias branch="git branch"' >> ~/.profile
    echo 'alias mpush="git push origin master"' >> ~/.profile
    echo 'alias mpull="git pull origin master"' >> ~/.profile
    echo 'alias dpush="git push origin develop"' >> ~/.profile
    echo 'alias dpull="git pull origin develop"' >> ~/.profile
    echo 'alias amend="git commit --amend -m"' >> ~/.profile
    echo 'alias fact="echo \"-------------------------------------------------------------------------------\";  curl -s randomfunfacts.com | sed -n \"s/.*<i>\(.*\)<\/i>.*/\1/p\"; echo \"-------------------------------------------------------------------------------\";"' >> ~/.profile
  fi

  source ~/.profile;

fi

echo "-------------------";
echo "Installing Homebrew";
echo "-------------------";

ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go);
brew update;

echo "--------------";
echo "Installing git";
echo "--------------";

brew install git;

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

rbenv install 1.9.3-p194;
rbenv rehash;
rbenv global 1.9.3-p194;

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

if ask "Do you want to install Node.js? (server side javascript development)"; then

  echo "Downloading..."
  NODEVER=0.8.8
  curl -O http://nodejs.org/dist/v$NODEVER/node-v$NODEVER.pkg
  echo "Installing..."
  sudo installer -pkg node-v$NODEVER.pkg -target /

  if ask "Would you like to install some important node packages?"
    echo "Installing bower (client-side javascript package management)"
    npm install bower -g
    echo "Installing coffeescript (javascript except a million times better)"
    npm install coffee-script -g
    echo "Installing supervisor (node app auto-reload on changes)"
    npm install supervisor -g
    echo "Installing express (web framework for node)"
    npm install express -g
  fi

fi

echo "----------------";
echo "Database Options";
echo "----------------";

if ask "Would you like to install databases? (optional)" N; then

  if ask "Do you want to install MySQL?" Y; then
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
  fi

  if ask "Do you want to install MongoDB?" Y; then
    echo "------------------";
    echo "Installing MongoDB";
    echo "------------------";
    brew install mongodb;

    if ask "Do you want to create the default db path?" Y; then
      sudo mkdir -p /data/db/
      sudo chown `id -u` /data/db
    fi  
  fi

  if ask "Do you want to install Redis?" Y; then
    echo "-------------------";
    echo "Installing Redis";
    echo "-------------------";
    brew install redis;

    if ask "Do you want to create launch agents for redis?" Y; then
      mkdir -p ~/Library/LaunchAgents
      find /usr/local/Cellar/redis/ -name "homebrew.mxcl.redis.plist" -exec cp {} ~/Library/LaunchAgents/ \;
      launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
    fi
  fi

  if ask "Do you want to install PostegreSQL?" Y; then
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
  fi

fi

echo "---------------------------------------------------------------------"
echo "Boom! All finished. Everything should be good to go."
echo "If there were any errors, save the output where the error came up"
echo "and send it to hello@jenius.me for help!"
echo "---------------------------------------------------------------------"