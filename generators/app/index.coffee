fs         = require 'fs'
generators = require 'yeoman-generator'
muleConfig = require './mule-config'
folderize  = require('../../common/util').folderize

CONFIG = muleConfig.CONFIG

class MuleGenerator extends generators.Base
  constructor : () ->
    generators.Base.apply this, arguments

    # Register all arguments
    @argument key, value for key,value of CONFIG.arguments

    # Register all options
    @option key, value for key,value of CONFIG.options

  prompting : () ->
    done = @async();

    @project = {}
    questions = []
    self = @

    questions.push CONFIG.questions.name self
    questions.push CONFIG.questions.description self

    @prompt questions, ( answers ) ->
      self.project.name        = self.name || answers.name
      self.project.description = self.description || answers.description

      console.log "Project : #{JSON.stringify(self.project)}"
      done()

    self
    

  writing : () ->
    @log 'Writing...'
    done = @async()
    
    targetName = folderize( if @project.mavenize then @project.artifact else @project.name )

    # Create the project folder
    @log "Creating project folder #{targetName}..."
    try
      tfStats = fs.statSync targetName
    catch e
      fs.mkdirSync targetName

    @project.file         = targetName
    @project.folder       = tfStats
    @project.generated_at = new Date()

    @destinationRoot( targetName )

    @log "File = #{@project.file}"

    # Creating files...
    @log "Creating files..."
    @fs.copyTpl @templatePath('../../../templates/mule-non-maven/'), @destinationPath(), 
      project : @project

    @fs.copyTpl @templatePath('../../../templates/mule-non-maven/.*'), @destinationPath(), 
      project : @project
    
    done();

  conflicts : () ->
    @log 'Resolving...'
    done = @async()

    done()
    @log "Done!"


  end : () ->
    @log 'Cleaning up...'
    done = @async()
    
    console.log "Renaming ", @destinationPath('src/main/app/main-app-flow.xml'), " with ", @destinationPath("src/main/app/#{@project.file}.xml")
    fs.renameSync @destinationPath('src/main/app/main-app-flow.xml'), @destinationPath("src/main/app/#{@project.file}.xml")     

    done()
    @log "Done!"

module.exports = MuleGenerator