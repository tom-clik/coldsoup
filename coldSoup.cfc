/*  coldSoup.cfc

Wrapper for Jsoup 

*/
component {

	/**
	 * Pseudo constructor
	 */
	public void function init() {

				
		this.jsoup = createObject( "java", "org.jsoup.Jsoup" );
		this.parser = createObject( "java", "org.jsoup.parser.Parser" );
		variables.whitelistObj = createObject( "java", "org.jsoup.safety.Whitelist" );
		variables.whiteLists = {};
		this.XMLParser = this.parser.XMLParser();
		this.xmlSyntax = createObject( "java", "org.jsoup.nodes.Document$OutputSettings$Syntax").xml;
		this.Pretty = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").outline(true);
		this.notPretty = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").prettyPrint(false).outline(false);
		
		this.xml = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").prettyPrint(false).outline(false).syntax(this.xmlSyntax);
		this.prettyXML = createObject( "java", "org.jsoup.nodes.Document$OutputSettings").prettyPrint(true).outline(false).syntax(this.xmlSyntax);
		
	}

	/**
	 * DEPRECATED: mainly  becuase I'm not sure what it's for.
	 *
	 * you can pass in either an html string, or a parsed document, and will get the same type back
	 */
	public function HTMLEscapeTag(doc, tag, wrap="", boolean replaceWhitespace="1") output=false {

		// Parse doc if needed
		if( IsSimpleValue(arguments.doc) ) {
			local.doc = this.jsoup.jsoup.parse(arguments.doc);
		} else {
			local.doc = arguments.doc;
		}

		// select our tags
		local.elements = arguments.doc.select("#arguments.tag#");

		for( local.i = 1; local.i LTE ArrayLen(local.elements) ; local.i = local.i+1) {			
			local.element = local.elements[local.i];

			// prepare a blank textNode
			local.newNode = this.jsoup.parseBodyFragment(' ').body().textNodes()[1];
			// And set it's TEXT to the value of the elements html
			local.tag = local.element.outerHTML();
			if( arguments.replaceWhiteSpace ) {
				local.text = local.element.html();
				if( local.text neq '' ) {
					local.tag = replace(local.tag,'<br />',chr(13)&chr(10),'all');
					local.tag = replace(local.tag,'&nbsp;',' ','all');
				}
			}
			local.newNode.text(local.tag);

			// wrap the element if requested
			if( arguments.wrap neq '')  {
				local.element.wrap('<#arguments.wrap#></#arguments.wrap#>');
			}
			// replace the original HTML node with the text node
			local.element.replaceWith(local.newNode);
		}

		// Return string if we passed in a string, and document if we passed in a document
		if( isSimpleValue(arguments.doc) ) {
			return local.doc.html();
		} else {
			return local.doc;
		}
	}

	/**
	 * Sanitize HTML by calling jsoup.clean() with specified whitelist
	 */
	public string function clean(required string html, whitelist="basic") {

		local.whiteListObj = getWhitelist(arguments.whitelist);
		local.rethtml = this.jsoup.clean(arguments.html,local.whiteListObj);
		return local.rethtml;
	}

	/**
	 * Parse HTML into a jsoup node
	 */
	public function parse(required html) {

		local.node = this.jsoup.parse(arguments.html);
		return local.node;
	}

	/**
	 * Set syntax to XML and parse
	 */
	public function getXML(required node) {

		node.outputSettings(this.xml);
		return node.html();
	}

	/**
	 * @hint  Return pretty printed XML
	 
	 */
	public function getPrettyXML(required node) {

		arguments.node.outputSettings(this.prettyXML);

		return arguments.node.html();
	}

	/**
	 * Wrapper for html method with boolean for pretty printing
	 */
	public function getHTML(required node, boolean pretty="1") {

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
	//  do not rename - can't use `IsValid` in older CF as is in-built function 
	public boolean function htmlIsValid(required html, whitelist="basic") {

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
	public void function addWhiteList(required string name, required whitelist) {

		variables.whiteLists["#arguments.name#"] = arguments.whitelist;	

	}

	/**
	 * Return whitelist from keyword e.g. basic for basic()
	 *
	 * @whitelist   none|basic|simpleText|relaxed|basicWithImages
	 * 
	 */
	public function getWhitelist(required string whitelist) {

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
				throw("Whitelist #arguments.whitelist# not allowed");
			}

		}

		
		return local.whiteListObj;
	}

	/**
	 * Parse an XML document
	 */
	public function parseXML(required xml, baseurl="") {

		local.xmlObj = this.jsoup.parse(arguments.xml,arguments.baseurl,this.XMLParser);
		return local.xmlObj;
	}

	/**
	 * Take an XML node and combine all its attributes and sub tags into a single struct. If the sub tags have children or attributes it recurses
	 */
	public function XMLNode2Struct(required xmlNode) {

		var retVal = getAttributes(arguments.xmlNode);
		var testAtts = false;
		var testchildren = false;
		var child = false;
			
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
			// NOT IMPLEMENTED:also allow text attibute text=yes so you can wrap the whole thing in tags e.g. <p> or <div>
			
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
	public Struct function getAttributes(required xmlNode) {

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

	/**
	 * Create a node and return it
	 */
	public function createNode(required tagName, text, id, classes) {

		var tag = createObject('java','org.jsoup.parser.Tag').valueOf(arguments.tagName);
		var node = createObject("java", "org.jsoup.nodes.Element").init(
				tag,
				javacast('string', ''));
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

}
