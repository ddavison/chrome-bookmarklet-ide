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
      scss_popup:
        files: ['src/scss/popup/*.scss']
        tasks: ['sass:popup_dist', 'autoprefixer:popup_dist', 'notify:popup_dist']
      scss_editor:
        files: ['src/scss/editor/*.scss']
        tasks: ['sass:editor_dist', 'autoprefixer:editor_dist', 'reload', 'notify:editor_dist']
    reload:
      extensions_page:
        options:
          match: /Extensions/
    autoprefixer:
      options:
        map: true
      popup_dist:
        src: 'dist/assets/css/popup.css'
      editor_dist:
        src: 'dist/assets/css/editor.css'
    sass:
      options:
        sourceMap: true,
        outputStyle: 'compressed'
      editor_dist:
        files:
          'dist/assets/css/editor.css': 'src/scss/editor/editor.scss'
      popup_dist:
        files:
          'dist/assets/css/popup.css': 'src/scss/popup/popup.scss'
    notify:
      editor_dist:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Editor SASS Complete'
      popup_dist:
        options:
          title: 'Chrome Bookmarket IDE',
          message: 'Popup SASS Complete'
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
      third_party:
        files: [
          expand: true
          cwd: '<%= srcDirThirdParty %>/'
          src: ['**/*']
          dest: '<%= thirdPartyOutput %>/'
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

    clean: ["<%= outputDir %>"]
  )

  grunt.loadNpmTasks('grunt-contrib-jade')
#  grunt.loadNpmTasks('grunt-cogntrib-compass')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-compress')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-sass')
  grunt.loadNpmTasks('grunt-autoprefixer')
  grunt.loadNpmTasks('grunt-notify')
  grunt.loadNpmTasks('grunt-reload-chrome')

  grunt.registerTask('Watch', ['watch'])

  grunt.registerTask('default', [
    'clean', # clean the distribution directory
    'jade:compile', # compile the jade sources
    'coffee:production', # compile the coffeescript
    'sass:editor_dist', # compile the sass
    'sass:popup_dist', # compile the sass
    'copy:manifest', # copy the chrome manifest
    'copy:images', # copy the png resize button
    'copy:third_party', # copy all third party sources that are needed
  ])

  grunt.registerTask('release', ->
    grunt.task.run('default')
    grunt.task.run('compress:extension')
  )
