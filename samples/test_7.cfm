<cfscript>

// @title  Create our own safeList
// @description Construct a safeList with allowed tags and an enforced data attribute

writeOutput("<pre>#htmlEditFormat(request.prc.dodgyHTML)#</pre>");
writeOutput("<h3>Custom safelist</h3>");
safeList = coldSoup.getsafelist("none");

// see the methods or refer to JSoup docs


safeList.addTags(javacast("String[]",  ["h1","h2"]));
safeList.addAttributes(javacast("String","h2"),javacast("String[]",  ["id"]));
safeList.addEnforcedAttribute(javacast("String","h2"),javacast("String","data-checked"),javacast("String","true"));

coldSoup.addsafeList("test", safeList)
okHTML = coldSoup.clean(html=request.prc.dodgyHTML,safelist="test");
displayCode(okHTML);

</cfscript>