fs         = require 'fs'
generators = require 'yeoman-generator'
mvnConfig  = require './maven-config'
folderize  = require('../../common/util').folderize

XmlUtil        = require '../../common/xmlutil'
PatcherService = require '../../common/patcher'

CONFIG = mvnConfig.CONFIG

class MavenGenerator extends generators.Base
	constructor : () ->
		generators.Base.apply this, arguments

		# Register all arguments
		@argument key, value for key,value of CONFIG.arguments

		# Register all options
		@option key, value for key,value of CONFIG.options

	initializing : () ->
		@log 'initializing...'
		done = @async()

		muleProjFile = @destinationPath './mule-project.xml'
		self = @
		fs.stat muleProjFile, (err, stats) ->
			self.log.error "The folder #{self.destinationPath()} is not a mule project. please check." if err and err.code is 'ENOENT'
			self.env.error "" if err and err.code is 'ENOENT'
			mulePomFile  = self.destinationPath 'pom.xml'
			fs.stat mulePomFile, (err, stats) ->
				console.log "no pom file found at #{mulePomFile}, will be creating one...", err, stats if err and err.code = 'ENOENT'
				doc  = XmlUtil.LoadXmlFile mulePomFile
				ns = { "pom" : "http://maven.apache.org/POM/4.0.0" }
				self.group = XmlUtil.XPathValue doc, '//pom:groupId/text()', ns
				self.artifact = XmlUtil.XPathValue doc, '//pom:artifactId/text()', ns
				self.version = XmlUtil.XPathValue doc, '/pom:project/pom:version/text()', ns

				console.log "GROUP: " , self.group, "ARTIFACT ", self.artifact, "VERSION ", self.version
				done()

	prompting : () ->
	  	@log 'prompting...'
	  	done = @async()

	  	@project =
	      mavenize: ( @options.mvn is true )
	      destination:
	      	path: @destinationPath()

	    self = @
	    questions = []
	    questions.push CONFIG.questions.group self
	    questions.push CONFIG.questions.artifact self
	    questions.push CONFIG.questions.version self
	    questions.push CONFIG.questions.edition self

	    @prompt questions, ( answers ) ->    
	        self.project.group     = answers.group if answers.group 
	        self.project.artifact  = answers.artifact if answers.artifact
	        self.project.version   = answers.version if answers.versions
	        self.project.community = undefined
	        self.project.community = true if self.options.community
	        self.project.community = false if self.options.enterprise
	        self.project.community = /^CE/.test answers.edition if self.project.community is undefined

	        done()

	writing : () ->
		@log 'writing...'
		done = @async()

		if not fs.existsSync @destinationPath('pom.xml')
			@log "Creating pom files..."
			@fs.copyTpl @templatePath('../../../templates/mule-maven/pom.xml'), @destinationPath('./pom.xml'), { 
					project : @project,
					mule: CONFIG.mule
				} 

		@log "patching pom.xml for mule edition: CE is #{@project.community}..."
		patcher = new PatcherService @templatePath('../../../templates/mule-maven/mule-maven-settings.yml'), @project
		patcher.fire if @project.community then 'ce' else 'un-ce'

		done()

	conflicts : () ->
		@log 'Resolving...'
		done = @async()
		# write your conflict code here
		done()

	end : () ->
		@log 'cleaning up...'
		done = @async()
		# write your cleanup code here...
		done()

module.exports = MavenGenerator