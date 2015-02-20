gulp      = require 'gulp'
coffee    = require 'gulp-coffee'
lint      = require 'gulp-coffeelint'
sourcemap = require 'gulp-sourcemaps'
aglio     = require 'gulp-aglio'

gulp.task 'default', ['scripts', 'config', 'config:sql', 'docs']

gulp.task 'scripts', ->

  gulp.src ['src/**/*.coffee'], base: './src'
    .pipe lint()
    .pipe lint.reporter()
    .pipe sourcemap.init()
    .pipe coffee()
    .pipe sourcemap.write './'
    .pipe gulp.dest './dist'

gulp.task 'config', ->

  gulp.src ['config/**/*.json'], base: './config'
    .pipe gulp.dest './dist/config'

gulp.task 'config:sql', ->

  gulp.src ['config/**/*.sql'], base: './config'
    .pipe gulp.dest './dist/config'

gulp.task 'docs', ->

  gulp.src ['src/docs/index.md']
    .pipe aglio()
    .pipe gulp.dest './dist/docs'
