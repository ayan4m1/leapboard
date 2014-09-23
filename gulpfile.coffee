gulp = require 'gulp'
karma = require 'karma'
sass = require 'gulp-sass'
http = require 'http-server'
watch = require 'gulp-watch'
cssmin = require 'gulp-cssmin'
coffee = require 'gulp-coffee'

src = 'src/'
dist = 'dist/'
lib = 'lib/'
test = __dirname + '/test/'
port = 3000

# extension -> gulp middleware mapping
exts =
  scss: (src) -> src.pipe(watch()).pipe(sass()).pipe(cssmin()).pipe(gulp.dest("#{dist}css"))
  coffee: (src) -> src.pipe(watch()).pipe(coffee()).pipe(gulp.dest("#{dist}js"))
  html: (src) -> src.pipe(watch()).pipe(gulp.dest(dist))

gulp.task 'default', ['update'], ->
  http.createServer({root: 'dist/'}).listen(port)
  console.log("app listening at http://localhost:#{port}/")

gulp.task 'update', ->
  gulp.src("#{lib}leapjs/leap*.min.js").pipe(gulp.dest("#{dist}js"))
  gulp.src("#{lib}fontawesome/fonts/*").pipe(gulp.dest("#{dist}fonts"))
  gulp.src("#{src}img/*").pipe(gulp.dest("#{dist}img"))
  exts[ext] gulp.src "src/#{ext}/**/*.#{ext}" for ext of exts

gulp.task 'test', ['update'], ->
  karma.server.start {configFile: "#{test}karma.conf.coffee"}