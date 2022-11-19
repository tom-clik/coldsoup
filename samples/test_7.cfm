<cfscript>

// @title  Create our own safeList
// @description Construct a whilelist with allowed tags and an enforced data attribute

writeOutput("<pre>#htmlEditFormat(request.prc.dodgyHTML)#</pre>");
writeOutput("<h3>Custom whitelist</h3>");
safeList = coldSoup.getWhitelist("none");

// see the methods or refer to JSoup docs
// writeDump(safeList);
safeList.addTags(javacast("String[]",  ["h1","h2"]));
safeList.addAttributes(javacast("String","h2"),javacast("String[]",  ["id"]));
safeList.addEnforcedAttribute(javacast("String","h2"),javacast("String","data-checked"),javacast("String","true"));

coldSoup.addWhiteList("test", safeList)
okHTML = coldSoup.clean(html=request.prc.dodgyHTML,whitelist="test");
displayCode(okHTML);

</cfscript>