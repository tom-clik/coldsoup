<cfscript>
// @title Remove comments
// @description Uses an inefficient recursive loop to rmoeve comments.

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));

coldSoup.removeComments(doc);

displayCode(coldsoup.getHTML(doc));

</cfscript>