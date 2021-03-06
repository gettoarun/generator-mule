// Generated by CoffeeScript 1.10.0
var folderize;

folderize = require('../../common/util').folderize;

module.exports.CONFIG = {
  "arguments": {
    name: {
      type: String,
      required: false,
      "default": void 0
    },
    description: {
      type: String,
      required: false,
      "default": void 0
    }
  },
  options: {
    maven: {
      desc: 'Generate / Convert project to maven.',
      alias: 'mvn',
      type: Boolean
    }
  },
  questions: {
    name: function(self) {
      return {
        when: function() {
          return !self.name;
        },
        type: 'input',
        name: 'name',
        message: 'Enter your project name',
        "default": this.appname
      };
    },
    description: function(self) {
      return {
        when: function() {
          return !self.description;
        },
        type: 'input',
        name: 'description',
        message: 'Enter your project description',
        "default": ''
      };
    }
  }
};
