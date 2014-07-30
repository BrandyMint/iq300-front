##############################
# Load data
#Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each{ |file| require file }
#Navigation.load_all(data.navigation)

#activate :fjords do |config|
  #config.username = ""
  #config.password = ""
  #config.domain = "site.example.com"
#end


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

#activate :i18n, langs: [:en, :ru], mount_at_root: false

# Middleman Navigation
activate :navigation

# Livereload
# activate :livereload

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
end

##############################
# Pages
page "*", :layout => "application"

#page:
#  proxy "/#{link}.html", "/demo.html", :locals => { :src => link, :next_link => next_link, :skip_this => skip_this }

##############################
# Dynamically Generated Pages
activate :directory_indexes  #Removes .html from file

##############################
## Settings
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true,
               :autolink => true, 
               :smartypants => true


set :css_dir, 'assets/stylesheets'

set :js_dir, 'assets/javascripts'

set :images_dir, 'images'

set :relative_links, true

activate :sprockets


# Development-specific configuration
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end


# Build-specific configuration
configure :build do
  # Clean 'Build' folder clean
  ignore "/assets/javascripts/application/*"
  ignore "/assets/javascripts/vendor/lib/*"
  ignore "/assets/stylesheets/vendor/*"
  ignore "/assets/stylesheets/app/*"
  ignore "/vendor/components/*"
  ignore "*.rb"

  activate :minify_css
  
  # Minify Javascript on build
  activate :minify_javascript
  
  # Enable cache buster
  activate :cache_buster

  # Activate google-analytics extension
  activate :google_analytics do |ga|
    ga.tracking_id = 'UA-XXXXXXX-X'
  end
  
  # Use relative URLs
  activate :relative_assets
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end

after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  @bower_assets_path = File.join "#{root}", @bower_config["directory"]
  sprockets.append_path 'app/vendor'
  sprockets.append_path @bower_assets_path
  sprockets.append_path 'vendor/assets/javascripts'
  sprockets.append_path 'vendor/assets/stylesheets'
  sprockets.append_path 'app/assets/stylesheets/fonts'
  #sprockets.import_asset 'app/robots.txt'
end


