yaml          = require 'js-yaml'
fs            = require 'fs'
XmlUtil       = require './xmlutil'

class PatcherService 
	constructor: ( @file, @options ) ->
		@loaded = false

		try
			@doc = yaml.safeLoad fs.readFileSync @file, 'utf8'

			@loaded = true
		catch error
			console.error "Unable to load parser settings YAML file. #{@file}", error

	fire: ( onEvent ) ->
		throw "Settings file not loaded. " if not @loaded

		console.log "applying actions for #{onEvent}"

		for key, value of @doc
			file = key
			project = @options
			filePath = eval "`#{value.path}`"
			console.log "processing #{file} on file #{filePath}..."
			for action in value.actions
				@applyAction filePath, project, action if action.on is onEvent
				@applyAction filePath, project, action.rollback if action.rollback.on is onEvent

		console.log "done."

	applyAction : ( file, project, action ) ->
		switch action.action
			when "add-xml-node"    then @addXmlNode file, project, action
			when "remove-xml-node" then @removeXmlNode file, project, action
			else throw "Unsupport action ( #{action.action} )."

	addXmlNode: ( file, project, action ) ->
		console.log "adding xml nodes to #{file}..."
		thePath = action.path
		entries = if action.content instanceof Array then action.content else [ action.content ]

		doc = XmlUtil.LoadXmlFile file
		XmlUtil.AppendXmlStringsToXPath doc, thePath, entries
		XmlUtil.WriteXmlFile file, doc

	removeXmlNode: ( file, project, action ) ->
		console.log "removing xml nodes to #{file}..."
		thePath = action.path

		doc = XmlUtil.LoadXmlFile file
		XmlUtil.RemoveNodesByXPath doc, thePath
		XmlUtil.WriteXmlFile file, doc

module.exports = PatcherService
# main()
#
#patcher = new PatcherService 'settings.yml', 
# 	destination : 
# 		path : 'c:/temp'#
#
#console.log "processing action:  #{ process.argv }"
#patcher.fire process.argv[2] if process.argv.length > 2