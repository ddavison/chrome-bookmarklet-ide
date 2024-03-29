sass = require 'node-sass'

module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON("package.json")
    srcDir: "./src"
    srcDirScss: "<%= srcDir %>/scss"
    srcDirCoffee: "<%= srcDir %>/coffee"
    srcDirImages: "./images"
    srcDirThirdParty: "./bower_components"
    outputDir: "./dist"
    assetDir: "<%= outputDir %>/assets"
    cssOutput: "<%= assetDir %>/css"
    jsOutput: "<%= assetDir %>/js"
    imagesOutput: "<%= assetDir %>/images"
    thirdPartyOutput: "<%= assetDir %>/third-party"
    cssRequestPath: "/css"
    jsRequestPath: "/js"
    watch:
      options:
        livereload: true
      scss:
        files: ['src/scss/*.scss']
        tasks: ['sass', 'reload', 'notify:popup_dist']
      scss_popup:
        files: ['src/scss/popup/*.scss']
        tasks: ['sass:popup_dist', 'reload', 'notify:popup_dist']
      scss_editor:
        files: ['src/scss/editor/*.scss']
        tasks: ['sass:editor_dist', 'reload', 'notify:editor_dist']
      scss_options:
        files: ['src/scss/options.scss']
        tasks: ['sass:options_dist', 'reload', 'notify:options_dist']
      coffee:
        files: ['src/coffee/*.coffee']
        tasks: ['coffee', 'reload', 'notify:coffee']
      jade:
        files: ['src/*.jade', 'src/jade/*.jade']
        tasks: ['jade', 'reload', 'notify:jade']
    reload:
      extensions_main_page:
        options:
          match: /Extensions/
      extensions_page:
        options:
          match: /IDE ::/
    sass:
      options:
        implementation: sass,
        sourceMap: true,
        outputStyle: 'compressed'
      editor_dist:
        files:
          'dist/assets/css/editor.css': 'src/scss/editor/editor.scss'
      popup_dist:
        files:
          'dist/assets/css/popup.css': 'src/scss/popup/popup.scss'
      options_dist:
        files:
          'dist/assets/css/options.css': 'src/scss/options.scss'
    notify:
      editor_dist:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Editor SASS Complete'
      popup_dist:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Popup SASS Complete'
      options_dist:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Options SASS Complete'
      coffee:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Coffee Complete'
      jade:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Jade Complete'
    coffee:
      production:
        expand: true
        cwd: "<%= srcDirCoffee %>"
        src: ["**/*.coffee"]
        dest: "<%= jsOutput %>"
        ext: ".js"

    jade:
      compile:
        options:
          data:
            debug: false
        files: [
          cwd: "<%= srcDir %>"
          src: "*.jade"
          dest: "<%= outputDir %>"
          expand: true
          ext: ".html"
        ]
    copy:
      manifest:
        files: [{
          expand: true,
          src: ['manifest.json'],
          dest: '<%= outputDir %>'
        }
        ]
      images:
        files: [{
          expand: true
          cwd: '<%= srcDirImages %>/'
          src: ['*']
          dest: '<%= imagesOutput %>/'
        }]
      foundation:
        files: [
          expand: true
          cwd: '<%= srcDirThirdParty %>/foundation-sites/dist'
          src: ['**/*.min*']
          dest: '<%= thirdPartyOutput %>/foundation'
        ]
      font_awesome:
        files: [
          expand: true
          cwd: '<%= srcDirThirdParty %>/font-awesome/css'
          src: ['**/*.min*']
          dest: '<%= thirdPartyOutput %>/font-awesome'
        ,
          expand: true
          cwd: '<%= srcDirThirdParty %>/font-awesome/fonts'
          src: ['**/*']
          dest: '<%= thirdPartyOutput %>/fonts'
        ]
      jquery:
        files: [
          expand: true
          cwd: '<%= srcDirThirdParty %>/jquery/dist'
          src: ['**/*.min*']
          dest: '<%= thirdPartyOutput %>/jquery'
        ]
      codemirror:
        files: [
          expand: true,
          cwd: '<%= srcDirThirdParty %>/codemirror/lib',
          src: ['**/*'],
          dest: '<%= thirdPartyOutput %>/codemirror'
        ,
          expand: true,
          cwd: '<%= srcDirThirdParty %>/codemirror/mode/javascript',
          src: ['javascript.js'],
          dest: '<%= thirdPartyOutput %>/codemirror/mode'
        ,
          expand: true,
          cwd: '<%= srcDirThirdParty %>/codemirror/theme',
          src: ['*.css'],
          dest: '<%= thirdPartyOutput %>/codemirror/theme'
        ]

    uglify:
      minify:
        files: [
          "<%= outputDir %>/js/main.js"
        ]
        options:
          compress: true
          banner: "/* TODO */"


# zip up everything for release
    compress:
      extension:
        options:
          mode: 'zip'
          archive: '<%= pkg.name %>-<%= pkg.version %>.zip'
        expand: true
        src: ['**/*']
        cwd: 'dist/'

    clean:
      options:
        force: true
      build: ['<%= outputDir %>']
  )

  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-compress')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-sass')
  grunt.loadNpmTasks('grunt-notify')

  grunt.registerTask('Watch', ['watch'])

  grunt.registerTask('default', [
    'clean:build', # clean the distribution directory
    'jade:compile', # compile the jade sources
    'coffee:production', # compile the coffeescript
    'sass:editor_dist', # compile the sass
    'sass:popup_dist', # compile the sass
    'sass:options_dist'
    'copy:manifest', # copy the chrome manifest
    'copy:images', # copy the png resize button
    'copy:foundation', # copy foundation dependencies
    'copy:font_awesome', # copy font-awesome dependencies
    'copy:jquery', # copy jquery dependencies
    'copy:codemirror', # copy codemirror dependencies
  ])

  grunt.registerTask('release', ->
    grunt.task.run('default')
    grunt.task.run('compress:extension')
  )
