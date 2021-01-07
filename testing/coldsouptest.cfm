<cfscript>

coldsoup = createObject("component", "coldsoup.coldSoup").init();

// Test 1.
// Parse some bad HTML

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));
displayCode(coldsoup.gethtml(doc,true));

// Test 2.
// Parse some XML

doc = coldSoup.parseXML(FileRead(ExpandPath("../testing/someXML.xml")));
displayCode(coldsoup.getPrettyXML(doc));

test = coldSoup.XMLNode2Struct(doc.select("viewport").first());

writeDump(test);
// displayCode(test.html());


function displayCode(html) {
	WriteOutput("<pre>" & htmlEditFormat(arguments.html) & "<pre>");
}

</cfscript>