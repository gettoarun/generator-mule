fs            = require 'fs'
xpath         = require 'xpath'
DOMParser     = require('xmldom').DOMParser
XMLSerializer = require('xmldom').XMLSerializer

class XmlUtil

	@LoadXmlFile = ( file ) ->
		doc = new DOMParser().parseFromString fs.readFileSync(file, 'utf8') , 'text/xml'

	@LoadXmlString = ( string ) ->
		doc = new DOMParser().parseFromString string, 'text/xml'

	@SerializeToString = ( doc ) ->
		new XMLSerializer().serializeToString( doc )

	@WriteXmlFile = ( file, doc ) ->
		fs.writeFileSync file, @SerializeToString doc

	@AppendXmlStringToXPath = (doc, nxpath, xmlString) ->
		@AppendXmlStringsToXPath doc, nxpath, [ xmlString ]

	@AppendXmlStringsToXPath = (doc, nxpath, xmlStrings) ->
		targetNode = xpath.select1 nxpath, doc
		targetNode.appendChild @LoadXmlString xmlString for xmlString in xmlStrings

	@RemoveNodesByXPath = (doc, nxpath) ->
		targetNodes = xpath.select nxpath, doc
		targetNode.parentNode.removeChild targetNode for targetNode in targetNodes

	@XPathValue = (doc, nxpath, ns = null) ->
		select = xpath.useNamespaces ns
		select(nxpath, doc)[0].nodeValue

	@XPathFromFile = ( file , nxpath ) ->
		doc = @LoadXmlFile file
		xpath.select1 nxpath, doc

module.exports = XmlUtil