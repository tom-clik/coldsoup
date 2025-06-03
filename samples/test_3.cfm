<cfscript>


// @title  Convert an XML node into a struct
// @description  Create JSON like translation from data to CF objects

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
test = coldSoup.XMLNode2Struct(doc.select("viewport").first());

WriteDump(test);


markdown = new markdown.flexmark(attributes=1);
writeOutput("<pre>#test.testing#</pre>");
writeOutput(markdown.toHtml(test.testing));
</cfscript>