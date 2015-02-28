##############################
# Load data
#Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each{ |file| require file }
#Navigation.load_all(data.navigation)

##############################
# Helpers
require 'config/routes'
require 'config/helpers'
require 'config/icon_helper'
require 'builder'
require 'pry'
require 'pry-pretty-numeric'
require "better_errors"

helpers do
  include RouteHelpers
  include ApplicationHelpers
  include IconHelper
end

##############################
# Initalise

# Markdown config
module Haml::Filters::Markdown
  include Haml::Filters::Base
  #lazy_require "redcarpet"
  require 'redcarpet'

  def render(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text)
  end
end


set :source_dir, 'app'
set :source, 'app'

set :build_dir, 'build'

#activate :i18n, langs: [:en, :ru], mount_at_root: false

# Middleman Navigation
# activate :navigation

# Livereload
activate :livereload, apply_js_live: false, apply_css_live: false, port: '35739'

# Automatic image dimensions on image_tag helper

##############################
# Pages
set :layouts_dir, "layouts"
#page "*", :layout => "application"
set :layout, :application
page "/", :layout => :page

##############################
# Dynamically Generated Pages
activate :directory_indexes  #Removes .html from file

##############################
## Settings
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true,
               :autolink => true, 
               :smartypants => true


set :css_dir, 'tmp/stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :relative_links, true

# Development-specific configuration
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# Build-specific configuration
configure :build do
  # Clean 'Build' folder clean
  ignore "/javascripts/application/*"
  ignore "/javascripts/vendor/lib/*"
  ignore "stylesheets/**/*"
  ignore "stylesheets/*"
  ignore "images/*"
  ignore "fonts/*"
  ignore "tmp/*"
  ignore "vendor/*"
  ignore "*.rb"
  ignore ".git"
  # TODO transfer all to app folder and ignore it on build

  # activate :minify_css
  
  # Minify Javascript on build
  activate :minify_javascript
  
  # Enable cache buster
  activate :cache_buster

end
  
  # Use relative URLs
  activate :relative_assets
  
  # Or use a different image path
  # set :http_path, "/Content/images/"

after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  @bower_assets_path = File.join "#{root}", @bower_config["directory"]
  sprockets.append_path @bower_assets_path
  sprockets.append_path 'vendor/assets/javascripts'
end


