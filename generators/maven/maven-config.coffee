folderize = require('../../common/util').folderize

module.exports.CONFIG = 
  defaults:
    group: 'com.fadv.integrations' # please also see questions.group below
  mule : 
    version: '3.7.1'
    tools:
      version: '1.1'  
    artifact : 
      type: String
      required: false
      default: ''
  options :
    community : 
      desc: 'Creates a Mule Community Edition (CE) project'
      alias: 'ce'
      type: Boolean
      defaults: false
    enterprise :
      desc: 'Creates a Mule Enterprise Edition (EE) project'
      alias: 'ee'
      type: Boolean
      defaults: false
  questions: 
    edition: (self) ->
        when: () -> ( self.options.community and self.options.enterprise ) or ( not self.options.community and not self.options.enterprise )
        type: 'list'
        name: 'edition'
        choices: ['CE - Community Edition', 'EE - Enterprise Edition']
        default: 0
        message: if ( self.options.community and self.options.enterprise ) then 'Both community and enterprise switches has been provided, which one?' else 'Neither CE no EE flag was provided. which one?'
    group: (self) ->
        when: () -> not self.group
        type: 'input'
        name: 'group'
        message: 'Enter your group id'
        default: 'com.fadv.integrations'
    artifact: (self) ->
        when: () -> not self.artifact
        type: 'input'
        name: 'artifact'
        message: 'Enter your artifact id'
        default: (answers) ->
          name = self.name || self.appname || ''
          folderize name
    version: (self) ->
        when: () -> not self.version
        type: 'input'
        name: 'version'
        message: 'Enter your project version (semver)'
        default: '1.0.0'

