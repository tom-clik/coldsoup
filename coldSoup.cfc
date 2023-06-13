/*  

# coldSoup.cfc

Wrapper for Jsoup

Author: Tom Peer 

See README.md

*/
component {

	/**
	 * Pseudo constructor
	 */
	public coldSoup function init() {

		this.jsoup             = createObject( "java", "org.jsoup.Jsoup" );
		this.parser            = createObject( "java", "org.jsoup.parser.Parser" );
		variables.whitelistObj = createObject( "java", "org.jsoup.safety.Whitelist" );
		variables.whiteLists   = {};
		this.XMLParser         = this.parser.XMLParser();
		this.xmlSyntax         = createObject( "java", "org.jsoup.nodes.Document$OutputSettings$Syntax").xml;
		this.Pretty            = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").outline(true);
		this.notPretty         = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").prettyPrint(false).outline(false);
		this.xml               = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").prettyPrint(false).outline(false).syntax(this.xmlSyntax);
		this.prettyXML         = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").prettyPrint(true).outline(false).syntax(this.xmlSyntax);

		return this;

	}

	/**
	 * Sanitize HTML by calling jsoup.clean() with specified whitelist
	 *
	 * @html         HTML string to clean
	 * @whitelist    Name of whitelist -- either one of the standards (see getWhiteList() or the name of a custom white list (see addWhiteList()))
	 * 
	 */
	public string function clean(required string html, whitelist="basic") {

		local.whiteListObj = getWhitelist(arguments.whitelist);
		local.rethtml      = this.jsoup.clean(arguments.html,local.whiteListObj);
		
		return local.rethtml;
	}

	/**
	 * Parse HTML into a jsoup document
	 */
	public object function parse(required html) {

		local.document = this.jsoup.parse(arguments.html);
		
		return local.document;
	}

	/**
	 * Set syntax to XML and get html
	 */
	public string function getXML(required node) {

		arguments.node.outputSettings(this.xml);
		
		return node.html();
	}

	/**
	 * Return pretty printed XML
	 */
	public string function getPrettyXML(required node) {

		arguments.node.outputSettings(this.prettyXML);

		return arguments.node.html();
	}

	/**
	 * @hint Wrapper for Node.html() method with boolean for pretty printing
	 *
	 * NB sets the output settings for the node to pretty so subsequent calls to html()
	 * will use that.
	 * 
	 */
	public string function getHTML(
		required any      node, 
		         boolean  pretty="1"
		) {

		if (arguments.pretty) {
			arguments.node.outputSettings(this.Pretty);
		}
		else {
			arguments.node.outputSettings(this.notPretty);
		}
		return arguments.node.html();
	}
	
	/**
	 * See if HTML is valid according to specified whitelist
	 */
	public boolean function isValidHTML(
		required string    html, 
		         string    whitelist="basic"
		) {

		local.whiteListObj = getWhitelist(arguments.whitelist);
		return this.jsoup.isValid(arguments.html,local.whiteListObj);
	}
	
	/**
	 * @hint Add custom whitelist to reference by name 
	 *
	 * To create your own whitelist, get one of the standard ones and modify it
	 * with available methods
	 *
	 * https://jsoup.org/apidocs/org/jsoup/safety/Safelist.html
	 * 
	 * @name  name to use when cleaning/checking validity
	 * @whitelist jsoup safelist object
	 */
	public void function addWhiteList(
		required string  name, 
		required object  whitelist) {
		
		if (! IsInstanceOf( obj=arguments.whitelist, type="org.jsoup.safety.Whitelist" )) {
			throw("Invald white list object");
		}

		variables.whiteLists["#arguments.name#"] = arguments.whitelist;	

	}

	/**
	 * @hint Return whitelist from keyword e.g. basic for basic()
	 * 
	 * @whitelist   none|basic|simpleText|relaxed|basicWithImages
	 * 
	 **/
	public object function getWhitelist(required string whitelist) {

		switch(arguments.whitelist) {
			case "none":
				local.whiteListObj = variables.whitelistObj.none();
				break;
			case "basic":
				local.whiteListObj = variables.whitelistObj.basic();
				break;
			case "simpleText":
				local.whiteListObj = variables.whitelistObj.simpleText();
				break;
			case "relaxed":
				local.whiteListObj = variables.whitelistObj.relaxed();
				break;
			case "basicWithImages":
				local.whiteListObj = variables.whitelistObj.basicWithImages();
				break;			
			default:
			
			if (structKeyExists(variables.whitelists,arguments.whitelist)) {
				local.whiteListObj = variables.whitelists[arguments.whitelist];
			}
			else {
				throw("Whitelist #arguments.whitelist# not defined");
			}

		}

		return local.whiteListObj;
	}

	/**
	 * Parse an XML document
	 */
	public function parseXML(
		required string xml, 
		         string baseurl="") {

		local.xmlObj = this.jsoup.parse(arguments.xml,arguments.baseurl,this.XMLParser);
		return local.xmlObj;
	}

	/**
	 * Take an XML node and combine all its attributes and sub tags into a single struct. If the sub tags have children or attributes it recurses
	 */
	public struct function XMLNode2Struct(required xmlNode) {

		var retVal        = getAttributes(arguments.xmlNode);
		var testAtts      = false;
		var testchildren  = false;
		var child         = false;
			
		// simple single text node is added as content field.
		if (Trim(xmlNode.ownText()) neq "") {
			retVal["content"] = xmlNode.ownText();
		}

		for (child in arguments.xmlNode.children()) {
			testAtts = child.attributes().size();
			testchildren = child.children().size();


			local.tagName = child.tagName();
			// issues with jsoup not allowing eg. image or caption. Prefix anything with field- to get around this,
			local.isFix = (ListFirst(local.tagName,"-") eq "field");
			if (local.isFix) {
				local.tagName = ListRest(local.tagName,"-");
			}

			// assume any element with mix of text and tags is html
			
			local.val = "";

			if (Trim(child.ownText()) neq "") {
				retVal[local.tagName] = child.html();
			}

			else if (testAtts OR testchildren) {
				// if there are multiple tags with the same tag name, create an array
				if (StructKeyExists(retVal,local.tagName)) {
					if (NOT IsArray(retVal[local.tagName])) {
						local.tmpFirstVal = retVal[local.tagName];
						retVal[local.tagName] = ArrayNew(1);
						arrayAppend(retVal[local.tagName], local.tmpFirstVal);
					}
					arrayAppend(retVal[local.tagName], XMLNode2Struct(child));
				}
				else {
					retVal[local.tagName] = XMLNode2Struct(child);
				}
			}
			else {
			 	retVal[local.tagName] = "";
			}
		}
		
		return retVal;
	}

	/**
	 * @hint Get all attibutes for an XML node and return as struct
	 * 
	 * Data attributes will be returned as keys of a struct "data"
	 * 
	 */
	public struct function getAttributes(required object xmlNode) {

		if (! IsInstanceOf(arguments.xmlNode, "org.jsoup.nodes.Element")) {
			throw("Invalid xmlNode");
		}

		var retVal = {};

		local.attributes = arguments.xmlNode.attributes().asList();

		for (local.attribute in local.attributes) {
			local.key = local.attribute.getKey();
			if (Left(local.key,5) == "data-") {
				if (!StructKeyExists(retVal,"data")) {
					retVal["data"] = {};
				}
				local.key = ListRest(local.key,"-");
				retVal["data"][local.key] = local.attribute.getValue();
			}
			else {
				retVal[local.key] = local.attribute.getValue();
			}
	 	}
		return retVal;
	}

	public void function copyAttributes(required object source, required object destination) {
		local.attributes = arguments.source.attributes().asList();

		for (local.attribute in local.attributes) {
			arguments.destination.attr(local.attribute.getKey(),local.attribute.getValue());
		}
	}

	/**
	 * Parse an html fragment and return the created node
	 * 
	 * @html        Single tag.
	 **/
	public any function parseNode(required string html) {
		local.document = this.jsoup.parseBodyFragment(arguments.html);
		local.node = local.document.body().children().first();
		return local.node;
	}
 
	/**
	 * Create a node
	 * 
	 * @tagName       Tag name e.g. h2
	 * @text          Text for tag.
	 * @id            ID attribute for tag
	 * @classes       Class attribute for tag
	 *
	 **/
	public object function createNode(
		required string tagName, 
		         string text, 
		         string id, 
		         string classes
		) {

		var node = createObject("java", "org.jsoup.nodes.Element").init(
			Javacast('string', arguments.tagName)
		);

		if (IsDefined("arguments.text")) {
			node.html(arguments.text);
		}
		if (IsDefined("arguments.id")) {
			node.attr("id", arguments.id);
		}
		if (IsDefined("arguments.classes")) {
			node.attr("class", arguments.classes);
		}

		return node;
	}

	/**
	 * Create a text node
	 */
	public object function createTextNode(required string text) {
		var node = createObject("java", "org.jsoup.nodes.TextNode").init(
			javacast('string', arguments.text)
		);
		
		return node;
	}

	/**
	 * Return java class name for node (Element|TextNode|Comment|DataNode)
	 */
	public string function nodeType(required node) {
		local.type = "";
		if (IsInstanceOf(arguments.node, "org.jsoup.nodes.Element")) {
			local.type = "Element";	
		}
		else if (IsInstanceOf(arguments.node, "org.jsoup.nodes.TextNode")) {
			local.type = "TextNode";	
		} 
		else if (IsInstanceOf(arguments.node, "org.jsoup.nodes.Comment")) {
			local.type = "Comment";	
		}
		else if (IsInstanceOf(arguments.node, "org.jsoup.nodes.DataNode")) {
			local.type = "DataNode";	
		}
		return local.type;
	}

	/**
	 * Get struct of info about a node.  Values depend on type.
	 */
	public struct function nodeInfo(required node) {
		var info = {"type"=nodeType(arguments.node)};
		switch (info.type) {
			case "Element":
				info["tagname"] = arguments.node.tagName();
				info["html"] = arguments.node.html();
				info["attributes"] = getAttributes(arguments.node);
				break;
			case "TextNode":
				info["text"] = arguments.node.text();	
				break;
			case "Comment":
				break;
			case "DataNode":
				break;

		}

		return info;
	}

}
