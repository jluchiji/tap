gulp      = require 'gulp'
coffee    = require 'gulp-coffee'
lint      = require 'gulp-coffeelint'
sourcemap = require 'gulp-sourcemaps'

gulp.task 'default', ->

  gulp.src ['src/**/*.coffee'], base: './src'
    .pipe lint()
    .pipe lint.reporter()
    .pipe sourcemap.init()
    .pipe coffee()
    .pipe sourcemap.write './'
    .pipe gulp.dest './dist'
