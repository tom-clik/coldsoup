<cfscript>

// @title  Parse some XML and display using prettyXML.
// @description  XML is handled slightly differently to HTML. It's more fussy but has greater  functionality

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
displayCode(coldsoup.getPrettyXML(doc));


</cfscript>