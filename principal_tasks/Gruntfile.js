module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    
    coffee: {
      compile: {
        files: {
          'server.js': 'src/server.coffee' // 1:1 compile
          // 'path/to/another.js': ['path/to/sources/*.coffee', 'path/to/more/*.coffee'] // compile and concat into single file
        }
      }
    },
    
    concurrent: {
      dev: {
        tasks: ['nodemon', 'watch'],
        options: {
          logConcurrentOutput: true,
          spawn: false
        }
      }
    },
    
    nodemon: {
      dev: {
        script: 'server.js',
        options: {
          // ext: 'js,coffee',
          // watch: ['src', 'server.js'],
          // legacyWatch: true,
          env: {
            PORT: '3000'
          }
        }
      }
    },
    
    watch: {
      coffee: {
        files: ['src/**/*.coffee'],
        tasks: ['clean','coffee'],
        options: {
          livereload: true
        }
      } 
    },
   
    clean: {
      build: {
        src: ["server.js"]
      }
    }
  
  });

  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-concurrent');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask('build', ['coffee','concurrent']);
  grunt.registerTask('default', ['clean','build']);
}