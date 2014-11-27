"use strict"

handleError = (err) ->
  console.warn err
  @emit "end"

gulp = require("gulp")
path = require("path")
sass = require('gulp-sass')
rubysass = require('gulp-ruby-sass')
haml = require('gulp-haml-coffee')
flatten = require('gulp-flatten')
include = require('gulp-file-include')
middleman = require('gulp-middleman')
assetpaths = require("./lib/gulp-assetpaths/gulp-assetpaths.coffee")
rewriteCSS = require('./lib/gulp-rewrite-css/index.coffee')
del = require('del')
vinylPaths = require('vinyl-paths')


$ = require("gulp-load-plugins")()
sourcemaps = require("gulp-sourcemaps")

options = {}

options.rewriteCSSDev =
  destination: '/tmp/assets/'
  relative: false

options.rewriteCSSDist =
  destination: '/assets/'
  relative: false

options.sassBasePaths = ['./app/stylesheets']

options.sassDev =
  errLogToConsole: true
  sourceComments: 'normal'
  outputStyle: 'compact'

options.sassDist =
  errLogToConsole: true
  sourceComments: 'normal'
  outputStyle: 'compact'

gulp.task "sass:watch", ->
  gulp
    .src("./app/stylesheets/**/*.sass")
    #.pipe(sass(options.sassDev))
    .pipe(rubysass())
    .pipe(rewriteCSS(options.rewriteCSSDev))
    .pipe(gulp.dest("./app/tmp/stylesheets"))
    .pipe($.connect.reload())
    .on "error", $.util.log
  return

gulp.task "sass:dist", ->
  gulp
    .src(["./app/stylesheets/**/*.sass"])
    #.pipe(sass(options.sassDist))
    .pipe(rubysass())
    .pipe(rewriteCSS(options.rewriteCSSDist))
    .pipe(gulp.dest("./dist/stylesheets"))
    .on "error", $.util.log
  return

options.middleman =
  useBundler: true
  port: 4567

gulp.task "middleman:watch", ->
  middleman.server(options.middleman)
  return

gulp.task "middleman:dist", ->
  middleman.build(options.middleman)
  return


# Images
gulp.task "images:watch", ->
  gulp
    .src("app/images/**/*")
    .pipe(gulp.dest("./app/tmp/assets"))
    .pipe $.connect.reload()
    .on "error", $.util.log

gulp.task "images:dist", ->
  gulp
    .src(["app/images/**/*", "app/vendor/components/**/*.{jpg,jpeg,png,svg}"])
    .pipe(gulp.dest("./dist/assets"))
    .on "error", $.util.log


gulp.task "fonts:watch", ->
  gulp
    .src("app/**/*.{eot,svg,ttf,woff}")
    .pipe(flatten())
    .pipe(gulp.dest("./app/tmp/assets"))
    .pipe $.connect.reload()
    .on "error", $.util.log

gulp.task "fonts:dist", ->
  gulp
    .src("app/**/*.{eot,svg,ttf,woff}")
    .pipe(flatten())
    .pipe(gulp.dest("./dist/assets"))
    .on "error", $.util.log

gulp.task "haml", ->
  gulp
    .src("app/**/*.haml")
    .pipe(include(
      prefix: "@@"
      basepath: "@file"
    ))
    .pipe(haml())
    .pipe(gulp.dest("./app/tmp"))
    .pipe($.connect.reload())
    .on "error", $.util.log
  return

# Clean
gulp.task "clean:watch", (cb) ->
  gulp
    .src("./app/tmp/**")
    .pipe vinylPaths(del)
    .on "error", $.util.log

gulp.task "clean:dist", (cb) ->
  gulp
    .src("./dist/**")
    .pipe vinylPaths(del)
    .on "error", $.util.log

# Dist
gulp.task "dist", [
  #"clean:dist"
  #"middleman:dist"
  "sass:dist"
  #"haml"
  "images:dist"
  "fonts:dist"
]

# Default task
gulp.task "default", ["clean:dist"], ->
  gulp.start "dist"
  return

# Connect
gulp.task "connect", $.connect.server(
  root: ["./app"]
  port: 9000
  livereload: true
)

# Watch
gulp.task "watch", [
  #"middleman:watch"
  "sass:watch"
  "images:watch"
  "fonts:watch"
  #"assets"
  #"html"
  #"haml"
  #"bundle"
  "connect"
], ->
  # Watch .html files
  #gulp.watch "app/*.html", ["html"]
  #gulp.watch "app/**/*.haml", ["haml"]
  # Watch .coffeescript files
  #gulp.watch('app/scripts/**/*.coffee', ['coffee', 'scripts']);
  #gulp.watch "app/scripts/**/*.coffee", ["scripts"]
  #gulp.watch "app/stylesheets/**/*.css", ["assets"]
  gulp.watch "app/stylesheets/**/*.{sass,scss}", ["sass:watch"]
  gulp.watch "app/fonts/**/*", ["fonts:watch"]
  gulp.watch "app/images/**/*", ["images:watch"]

 
  # Watch .js files
  #gulp.watch "app/scripts/**/*.js", ["scripts"]
  
  # Watch image files
  #gulp.watch "app/images/**/*", ["images"]
  return

