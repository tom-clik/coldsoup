<cfscript>

// @title Parse some bad HTML
// 
// @description Malformed HTML is parsed and a well formed document can be exported

html = FileRead(ExpandPath("../testing/rubbish.html"))

writeOutput("<pre>#htmlEditFormat(html)#</pre>");
doc = coldSoup.parse(html);
displayCode(coldsoup.getHTML(doc));


</cfscript>