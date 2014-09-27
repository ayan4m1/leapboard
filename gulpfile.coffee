glob = require 'glob'
gulp = require 'gulp'
util = require 'util'
karma = require 'karma'
sass = require 'gulp-sass'
gulpif = require 'gulp-if'
http = require 'http-server'
cssmin = require 'gulp-cssmin'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
flatten = require 'gulp-flatten'

src = 'src/'
dist = 'dist/'
lib = 'lib/'
port = 3000

# return glob for source files by extension
srcGlob = (exts) ->
  return "src/#{exts}/**/*.#{exts}" unless util.isArray(exts)
  exts.map (ext) ->
    "src/#{ext}/**/*.#{ext}"

gulp.task 'default', ['update'], ->
  console.log "app listening at http://localhost:#{port}/"
  http.createServer(
    root: 'dist/'
  ).listen(port)
  console.log 'watching for source file changes...'
  gulp.watch(srcGlob([
    'coffee',
    'html',
    'scss'
  ]), ['update'])

gulp.task 'update', -> [
  # icon fonts
  gulp.src("#{lib}fontawesome/fonts/*").pipe(gulp.dest("#{dist}fonts"))
  gulp.src("#{lib}weather-icons/font/*").pipe(gulp.dest("#{dist}font"))

  # images
  gulp.src("#{src}img/*").pipe(gulp.dest("#{dist}img"))

  # css
  # todo: sed weather-icons to use ../fonts/
  gulp.src([
    "#{lib}weather-icons/css/*.min.css"
    srcGlob('scss')
  ])
  .pipe(gulpif(/\.scss$/, sass()))
  # todo: use uncss
  #.pipe(uncss(
  #  html: glob.sync(srcGlob('html'))
  #))
  .pipe(cssmin())
  .pipe(gulp.dest("#{dist}css"))

  # js libs
  # todo: use .min.js files when not developing
  gulp.src([
    "#{lib}/angular/angular.js"
    "#{lib}/jquery/dist/jquery.js"
    "#{lib}/bootstrap/dist/js/bootstrap.js"
    "#{lib}/leapjs/leap-0.6.2.js"
    "#{lib}/momentjs/moment.js"
  ]).pipe(flatten()).pipe(gulp.dest("#{dist}js/lib"))

  # coffee
  gulp.src(srcGlob('coffee')).pipe(coffee()).pipe(gulp.dest("#{dist}js"))

  # html
  gulp.src(srcGlob('html')).pipe(gulp.dest(dist))
]

gulp.task 'test', ['update'], ->
  karma.server.start {configFile: "#{__dirname}/test/karma.conf.coffee"}