## Up

A set of shell scripts to painlessly set up a modern ruby environment on your computer. Can be found at [http://up.jenius.me](http://up.jenius.me)

**Warning: The GCC installer bundled with up works with Lion only. [Click here to download a snow leopard version](https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.6.pkg).**

- `test` checks whether gcc is installed and tells you if it is or not
- `gcc` downloads the apple gcc installer from my server so that you don't have to log in with an apple ID and all those shenanigans, then mounts the disk and opens the installer
- `setup` installs the packages listed below.
  - to have database install as well, use the `-d` flag *ex: `./setup.sh -d mysql`*
    - **Currently available options**
    - [mysql](http://www.mysql.com/)
    - [redis](http://redis.io/)
    - [mongo](http://www.mongodb.org/)
    - [postgres](http://www.postgresql.org/)

### What it installs

- [homebrew](http://mxcl.github.com/homebrew/)
- [rbenv](https://github.com/sstephenson/rbenv)
- [ruby-build](https://github.com/sstephenson/ruby-build)
- [ruby 1.9.3-p125](http://www.ruby-lang.org/en/downloads/)
- [git](http://git-scm.com/)
- [rubygems](http://rubygems.org/)
- [bundler](http://gembundler.com/)
- [pow](http://pow.cx)
- [powder](https://github.com/rodreegez/powder)
- [haml](http://haml-lang.com/)
- [sass](http://sass-lang.com/)
- [coffeescript](http://jashkenas.github.com/coffee-script/)
- [stasis](http://stasis.me/)
- [rails](http://rubyonrails.org/)

### Contributors

I'd like to give a huge thank you to @idPro for his awesome contributions to this project. I'm always happy to look at contributions from anyone else, ust get in contact or send in a pull request!