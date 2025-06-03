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
	public coldSoup function init(required string jarpath) {

		// Install the bundle through OSGI mechanism to avoid conflicts
		local.CFMLEngine = createObject( "java", "lucee.loader.engine.CFMLEngineFactory" ).getInstance();
		local.OSGiUtil = createObject( "java", "lucee.runtime.osgi.OSGiUtil" );
		local.resource = CFMLEngine.getResourceUtil().toResourceExisting( getPageContext(), jarpath );
		local.bundle = OSGiUtil.installBundle( CFMLEngine.getBundleContext(), local.resource, true);

		// expose the parsers as public objects
		this.jsoup             = createObject( "java", "org.jsoup.Jsoup", "org.jsoup");
		this.parser            = createObject( "java", "org.jsoup.parser.Parser", "org.jsoup" );
		this.XMLParser         = this.parser.XMLParser();

		// use addSafelist and getSafelist to use safelists
		variables.safelistObj = createObject( "java", "org.jsoup.safety.Safelist", "org.jsoup" );
		variables.safeLists   = {};
		
		// This really ought to be private
		this.xmlSyntax         = createObject( "java", "org.jsoup.nodes.Document$OutputSettings$Syntax", "org.jsoup").xml;

		// output formats. You can use a document's outputSettings() with these objects
		// or call outputSettings(doc, "name") in this component
		this.Pretty            = createObject( "java", "org.jsoup.nodes.Document$OutputSettings", "org.jsoup").prettyPrint(true).outline(true);
		this.notPretty         = createObject( "java", "org.jsoup.nodes.Document$OutputSettings", "org.jsoup").prettyPrint(false).outline(false);
		this.xml               = createObject( "java", "org.jsoup.nodes.Document$OutputSettings", "org.jsoup").prettyPrint(false).outline(false).syntax(this.xmlSyntax);
		this.prettyXML         = createObject( "java", "org.jsoup.nodes.Document$OutputSettings", "org.jsoup").prettyPrint(true).outline(true).syntax(this.xmlSyntax);

		return this;

	}

	/**
	 * Sanitize HTML by calling jsoup.clean() with specified safelist
	 *
	 * @html         HTML string to clean
	 * @safelist    Name of safelist -- either one of the standards (see getSafelist() or the name of a custom safe list (see addSafelist()))
	 * 
	 */
	public string function clean(required string html, safelist="basic") {

		local.safeListObj = getSafelist(arguments.safelist);
		local.rethtml      = this.jsoup.clean( arguments.html ,local.safeListObj);
		
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
	 * Return pretty printed XML -- use outputSettings in preference
	 *
	 * @deprecated NB This changes the outputSettings of the supplied node. 
	 *
	 */
	public string function getPrettyXML(required node) {

		arguments.node.outputSettings(this.prettyXML);

		return arguments.node.html();
	}

	/**
	 * Set outputsettings for a document using keyword
	 * @settings      Pretty|notPretty|xml|prettyXML
	 */
	public void function outputSettings(required node, required string settings) {

		switch (arguments.settings) {
			case "Pretty":
			case "notPretty":
			case "xml":
			case "prettyXML":
				arguments.node.outputSettings(this[arguments.settings]);
				break;
			default:
				throw(
					message="Output settings #arguments.settings# not defined",
					detail="To use your own output settings, use the document's own outputSettings() method"
				);

		}

	}

	/**
	 * @hint Wrapper for Node.html() method with boolean for pretty printing
	 *
	 * @deprecated use outputSettings()
	 *
	 * NB sets the output settings for the node to pretty so subsequent calls to html()
	 * will use that.
	 * 
	 */
	public string function getHTML(
		required object   node, 
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
	 * See if HTML is valid according to specified safelist
	 */
	public boolean function isValidHTML(
		required string    html, 
		         string    safelist="basic"
		) {

		local.safeListObj = getSafelist(arguments.safelist);
		return this.jsoup.isValid(arguments.html,local.safeListObj);
	}
	
	/**
	 * @hint Add custom safelist to reference by name 
	 *
	 * To create your own safelist, get one of the standard ones and modify it
	 * with available methods
	 *
	 * https://jsoup.org/apidocs/org/jsoup/safety/Safelist.html
	 * 
	 * @name  name to use when cleaning/checking validity
	 * @safelist jsoup safelist object
	 */
	public void function addSafelist(
		required string  name, 
		required object  safelist) {
		
		if (! IsInstanceOf( obj=arguments.safelist, type="org.jsoup.safety.Safelist" )) {
			throw("Invald safe list object");
		}

		variables.safeLists["#arguments.name#"] = arguments.safelist;	

	}

	/**
	 * @hint Return safelist from keyword e.g. basic for basic()
	 * 
	 * @safelist   none|basic|simpleText|relaxed|basicWithImages
	 * 
	 **/
	public object function getSafelist(required string safelist) {

		switch(arguments.safelist) {
			case "none":
				local.safeListObj = variables.safelistObj.none();
				break;
			case "basic":
				local.safeListObj = variables.safelistObj.basic();
				break;
			case "simpleText":
				local.safeListObj = variables.safelistObj.simpleText();
				break;
			case "relaxed":
				local.safeListObj = variables.safelistObj.relaxed();
				break;
			case "basicWithImages":
				local.safeListObj = variables.safelistObj.basicWithImages();
				break;			
			default:
				if (structKeyExists(variables.safelists,arguments.safelist)) {
					local.safeListObj = variables.safelists[arguments.safelist];
				}
				else {
					throw("Safelist #arguments.safelist# not defined");
				}

		}

		return local.safeListObj;
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
			local.val = local.attribute.getValue() ? : true;
			if (Left(local.key,5) == "data-") {
				if (!StructKeyExists(retVal,"data")) {
					retVal["data"] = {};
				}
				local.key = ListRest(local.key,"-");
				retVal["data"][local.key] = local.val;
			}
			else {
				retVal[local.key] = local.val;
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
	public object function parseNode(required string html) {
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

	/**
	 * @hint Remove superfluous anchor tags from headings
	 * 
	 * When using Markdown converters often we end up with
	 * anchor points like
	 *
	 * ```html
	 * <h2><a id='id' href='#id'>heading</a>
	 * ```
	 * These are uneccessary in modern HTML and can break 
	 * functionality that uses the IDs on the heading tags
	 * 
	 * Use this to "unwrap" them while keeping the ID. 
	 */
	public void function unwrapHeaders(required node) {

		local.headers = arguments.node.select("h1,h2,h3,h4,h5,h6");
		
		for (local.header in local.headers) {
			
			// NB this gets overridden in flexmark if auto headers is on. See next
			local.id = local.header.id();
			
			// generate id from header text NB flexmark places the id and other attributes in to the <a> child tag
			local.anchor = local.header.select("a");
			if ( ArrayLen( local.anchor ) ) {
				local.tag = local.anchor.first();

				local.id = local.tag.id();
				local.href = local.anchor.attr("href");
				if (IsDefined("local.href")) {
					local.target = ListLast(local.href,"##");
				}
				
				// flexmark always adds href to anchors. If it links to itself it's an anchor not a link.
				if (local.id == local.target) {
					local.tag.removeAttr("href");
					// There is also a bug in Flexmark which removes ids if you're not using anchorlinks.
					// Therefore the only way to get the ids is to use anchor links and assign the id to the parent element
					copyAttributes(local.tag,local.header);
					local.tag.unwrap();
				}
			}

			// if there was no ID on header or on anchor, create one
			if (NOT (IsDefined("local.id") AND local.id neq "")) {
				local.id = LCase(ReReplace(Replace(local.header.text()," ","-","all"), "[^\w\-]", "", "all"));
				local.header.attr("id",local.id);
			}
			
		}

	}

}
