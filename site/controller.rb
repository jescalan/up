# If you have no idea what this is, don't mess with it

# For more information on how to use and customize this file, check out
# the docs for stasis at http://stasis.me

require "rubygems"
require "bundler/setup"

require 'sass'
require 'haml'
require 'coffee-script'

ignore /\/css\/modules/
ignore /assets/
ignore /config.html/
ignore /\/css\/_.*/
ignore /Gemfile.*/
ignore /\.gitignore/
ignore /\.sass-cache/
ignore /\.git/
ignore /\.powder/
ignore /\.DS_Store/
ignore /config.ru/
ignore /readme.md/

layout 'layouts/layout.html.haml'



# if you feel like having some sweet ascii art in your source...

helpers do
  def roots_badge
    "<!--
            Made with...

                      __             
                     /\\ \\__          
   _ __   ___     ___\\ \\ ,_\\   ____  
  /\\`'__\\/ __`\\  / __`\\ \\ \\/  /',__\\ 
  \\ \\ \\//\\ \\ \\ \\/\\ \\ \\ \\ \\ \\_/\\__, `\\
   \\ \\_\\\\ \\____/\\ \\____/\\ \\__\\/\\____/
    \\/_/ \\/___/  \\/___/  \\/__/\\/___/

-->"
  end
end