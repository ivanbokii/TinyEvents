module.exports = function(grunt) {

  grunt.initConfig({

    // Import package manifest
    pkg: grunt.file.readJSON("tinyEvents.json"),

    // Banner definitions
    meta: {
      banner: "/*\n" +
        " *  <%= pkg.title || pkg.name %> - v<%= pkg.version %>\n" +
        " *  <%= pkg.description %>\n" +
        " *  <%= pkg.homepage %>\n" +
        " *\n" +
        " *  Made by <%= pkg.author.name %>\n" +
        " *  Under <%= pkg.licenses[0].type %> License\n" +
        " */\n"
    },

    // Concat definitions
    concat: {
      dist: {
        src: ["src/global.js", "src/templates.js", "src/utils.js", "src/tinyEvents.js"],
        dest: "dist/tinyEvents.js"
      },
      options: {
        separator: "//--------\n",
        banner: "<%= meta.banner %>"
      }
    },

    sass: {
      dist: {
        // options: {
        //   includePaths: ['demo/sass']
        // },
        files: {
          "demo/css/index.css": "demo/sass/index.sass"
        }
      }
    },

    // Lint definitions
    jshint: {
      files: ["src/tinyEvents.js"],
      options: {
        jshintrc: ".jshintrc"
      }
    },

    // Minify definitions
    uglify: {
      my_target: {
        src: ["dist/tinyEvents.js"],
        dest: "dist/tinyEvents.min.js"
      },
      options: {
        banner: "<%= meta.banner %>"
      }
    },

    // CoffeeScript compilation
    coffee: {
      compile: {
        files: {
          "dist/tinyEvents.js": ["src/global.coffee"
                                , "src/templates.coffee"
                                , "src/utils.coffee"
                                , "src/calendar.coffee"
                                , "src/events.coffee"
                                , "src/tinyEvents.coffee"]
        }
      }
    },

    watch: {
      files: ['src/*.coffee', 'demo/sass/*.sass'],
      tasks: ['coffee', 'sass']
    },

    clean: ['src/*.js']
  });

  grunt.loadNpmTasks("grunt-contrib-concat");
  grunt.loadNpmTasks("grunt-contrib-jshint");
  grunt.loadNpmTasks("grunt-contrib-uglify");
  grunt.loadNpmTasks("grunt-contrib-coffee");
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-sass');

  grunt.registerTask("default", ["jshint", "uglify", "sass"]);
  grunt.registerTask("travis", ["jshint"]);


};
