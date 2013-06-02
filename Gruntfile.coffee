module.exports = (grunt) ->
  grunt.initConfig
    pkg: '<json:package.json>'

    coffee:
      lib:
        expand: true
        cwd: 'src/'
        src: '**/*.coffee'
        dest: 'lib/'
        ext: '.js'

    simplemocha:
      lib:
        src: 'test/**/*_test.coffee'
        options:
          globals: ['expect']
          timeout: 6000
          ui: 'bdd'
          reporter: 'spec'

    watch:
      files: [
        'Gruntfile.coffee'
        'src/**/*.coffee'
        'test/**/*.coffee'
      ]
      tasks: 'test'

  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'test', 'simplemocha'
  grunt.registerTask 'default', ['test']
