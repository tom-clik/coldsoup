<cfscript>

// @title  Parse some XML and display using prettyXML.
// @description  XML is handled slightly differently to HTML. It's more fussy but has greater  functionality

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
coldsoup.outputSettings(doc, "prettyXML");

// writeDump(var=doc,abort=1);

local.data = coldSoup.XMLNode2Struct(doc);

displayCode( doc.html() );


</cfscript>