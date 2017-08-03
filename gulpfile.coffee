"use strict"

handleError = (err) ->
  console.warn err
  @emit "end"

gulp = require("gulp")
path = require("path")
sass = require('gulp-sass')
flatten = require('gulp-flatten')
#include = require('gulp-file-include')
#middleman = require('gulp-middleman')
#assetpaths = require("./lib/gulp-assetpaths/gulp-assetpaths.coffee")
rewriteCSS = require('./lib/gulp-rewrite-css/index.coffee')
del = require('del')
vinylPaths = require('vinyl-paths')
browserSync = require('browser-sync')
reload = browserSync.reload
#postcss = require('gulp-postcss')
#autoprefixer = require('autoprefixer-core')
#autoprefixer = require('gulp-autoprefixer')
debug = require('gulp-debug')
shell = require('gulp-shell')
minifyCss = require('gulp-minify-css')
awspublish = require('gulp-awspublish')
parallelize = require('concurrent-transform')
keys = require('./config/keys.coffee')
minimist = require('minimist')

$ = require("gulp-load-plugins")()
sourcemaps = require("gulp-sourcemaps")

knownOptions =
  string: 'env',
  default: { env: process.env.NODE_ENV || 'staging' }

options = {}

options.cli = minimist(process.argv.slice(2), knownOptions)

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

options.autoprefixer =
  browsers: ['Explorer 10', 'Chrome 31', 'Firefox 27', 'Opera 27', 'Safari 7', 'iOS 7', 'Android 4.1', 'OperaMini 8']
  cascade: false

options.minifyCss =
  compatibility: '*'

publishers = {}
threads = 10

gulp.task "sass:watch", ->
  gulp
    .src("./app/stylesheets/**/*.sass")
    .pipe(sass(options.sassDev))
    .pipe(rewriteCSS(options.rewriteCSSDev))
    .pipe(gulp.dest("./app/tmp/stylesheets"))
    .pipe($.connect.reload())
    .on "error", $.util.log

gulp.task "sass:dist", ->
  gulp
    .src("./app/stylesheets/**/*.sass")
    .pipe(sass(options.sassDist))
    .pipe(rewriteCSS(options.rewriteCSSDist))
    .pipe(minifyCss(options.minifyCss))
    .pipe(gulp.dest("./dist/stylesheets"))
    .on "error", $.util.log

gulp.task "prefix:watch", ["sass:watch"], shell.task([
  #'./node_modules/.bin/autoprefixer ' + './app/tmp/stylesheets/*.css ' + '-b '+ '"' + options.autoprefixer.browsers.join(', ').toLowerCase() + '"'
  # TODO just a temporary fix
  './node_modules/.bin/autoprefixer ' + './app/tmp/stylesheets/*.css '
])

gulp.task "prefix:dist", ["sass:dist"], shell.task([
  #'./node_modules/.bin/autoprefixer ' + './dist/stylesheets/*.css ' + '-b '+ '"' + options.autoprefixer.browsers.join(', ').toLowerCase() + '"'
  # TODO just a temporary fix
  './node_modules/.bin/autoprefixer ' + './app/tmp/stylesheets/*.css '
])


options.middleman =
  useBundler: true
  port: 4567

gulp.task "middleman:watch", ->
  middleman.server(options.middleman)
  return

gulp.task "middleman:dist", ->
  middleman.build(options.middleman)
  return

gulp.task 'browser-sync', ->
  browserSync
    proxy: 'localhost:4567'
    port: 3001
  return

gulp.task "browser-sync-reload", ->
  gulp.src(["app/tmp/stylesheets/*.css", "app/javascripts/**/*.*"]).pipe reload({stream: true})
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
    .src("app/**/*.{eot,svg,ttf,woff,woff2}")
    .pipe(flatten())
    .pipe(gulp.dest("./app/tmp/assets"))
    .pipe $.connect.reload()
    .on "error", $.util.log

gulp.task "fonts:dist", ->
  gulp
    .src("app/**/*.{eot,svg,ttf,woff,woff2}")
    .pipe(flatten())
    .pipe(gulp.dest("./dist/assets"))
    .on "error", $.util.log

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
  "images:dist"
  "fonts:dist"
  "prefix:dist"
], ->
  gulp.on 'stop', ->
    process.nextTick ->
      process.exit 0
      return
    return

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
  "prefix:watch"
  #"assets"
  #"html"
  #"bundle"
  "connect"
  "browser-sync"
], ->
  # Watch .html files
  #gulp.watch "app/*.html", ["html"]
  # Watch .coffeescript files
  #gulp.watch('app/scripts/**/*.coffee', ['coffee', 'scripts']);
  #gulp.watch "app/scripts/**/*.coffee", ["scripts"]
  #gulp.watch "app/stylesheets/**/*.css", ["assets"]
  gulp.watch "app/stylesheets/**/*.{sass,scss}", ["sass:watch", "prefix:watch"]
  gulp.watch "app/fonts/**/*", ["fonts:watch"]
  gulp.watch "app/images/**/*", ["images:watch"]
  #gulp.watch ["app/**/*.haml"], ["browser-sync-reload"]
  gulp.watch ["app/javascripts/**/*.*", "app/tmp/stylesheets/*.css"], ["browser-sync-reload"]
  #gulp.watch ["app/tmp/stylesheets/*.css"], ["browser-sync-reload"]

  # Watch .js files
  #gulp.watch "app/scripts/**/*.js", ["scripts"]

  # Watch image files
  #gulp.watch "app/images/**/*", ["images"]
  return

createPublisher = (env = 'staging') ->
  return awspublish.create(
    region: keys.s3[env].region
    params: Bucket: keys.s3[env].bucket
    accessKeyId: keys.s3[env].key
    secretAccessKey: keys.s3[env].secret)

upload = (env = 'staging') ->
  publisher = createPublisher(env)
  gulp.src(['./build/**/*', './dist/**/*'])
    .pipe(parallelize(publisher.publish(), threads))
    .pipe(publisher.cache())
    .pipe awspublish.reporter()
    .on 'error', (err) ->
      $.util.log plugins.util.colors.red('s3 upload error:'), '\n', err, '\n'
      gulp.emit 'end'
      return
    .on 'end', ->
      $.util.log "http://#{keys.s3[env].bucket}.s3-website.#{keys.s3[env].region}.amazonaws.com"

gulp.task 's3', ->
  env = process.env.NODE_ENV || 'staging'
  upload env
  return


