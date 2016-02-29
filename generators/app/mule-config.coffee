folderize = require('../../common/util').folderize

module.exports.CONFIG =
  arguments :
    name : 
      type: String
      required: false
      default: undefined
    description : 
      type: String
      required: false
      default: undefined
  options :
    maven : 
      desc: 'Generate / Convert project to maven.'
      alias: 'mvn'
      type: Boolean
  questions :
    name: (self) ->
        when: () -> not self.name
        type: 'input'
        name: 'name'
        message: 'Enter your project name'
        default: @appname   
    description: (self) ->
        when: () -> not self.description
        type: 'input'
        name: 'description'
        message: 'Enter your project description'
        default: ''
