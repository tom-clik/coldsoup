<cfscript>
// @title Remove comments
// @description Uses an inefficient recursive loop to remove comments.

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));

coldsoup.removeComments(doc);

displayCode(coldsoup.getHTML(doc));

</cfscript>