<cfscript>


// @title  Convert an XML node into a struct
// @description  Create JSON like translation from data to CF objects

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
test = coldSoup.XMLNode2Struct(doc.select("viewport").first());

WriteDump(test);

</cfscript>