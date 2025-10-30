<cfscript>


// @title  Convert an XML node into a struct
// @description  Create JSON like translation from data to CF objects

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
test = coldSoup.XMLNode2Struct(doc.select("viewport").first());

WriteDump(var=test,expand=0);

// should strip tabs from line starts of text node

displayCode( test.testing );

// confirm by converting to HTML
try {
	markdown = new markdown.flexmark(attributes=1,coldsoupObj=coldsoup);
	displayCode( markdown.toHtml(test.testing) );
}
catch (any e) {
	// library not installed
}
</cfscript>