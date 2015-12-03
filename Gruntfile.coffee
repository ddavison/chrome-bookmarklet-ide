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

    compass:
      dist:
        options:
          sassDir: "<%= srcDirScss %>"
          cssDir: "<%= cssOutput %>"
          outputStyle: 'compact'

    coffee:
      production:
        expand:true
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

    watch:
      coffee:
        files: "<%= srcDirCoffee %>/**/*.coffee"
        tasks: ["coffee:development"]
      css:
        files: "<%= srcDirScss %>/**/*.scss"
        tasks: ["compass:dist"]

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
  grunt.loadNpmTasks('grunt-contrib-compass')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-compress')

  grunt.registerTask('default', [
    'clean',             # clean the distribution directory
    'jade:compile',       # compile the jade sources
    'coffee:production', # compile the coffeescript
    'compass:dist',      # compile the sass
    'copy:manifest',     # copy the chrome manifest
    'copy:images',          # copy the png resize button
    'copy:third_party',  # copy all third party sources that are needed
  ])

  grunt.registerTask('release', ->
    grunt.task.run('default')
    grunt.task.run('compress:extension')
  )
