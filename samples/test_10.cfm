<cfscript>
// @title Remove comments
// @description Uses an inefficient recursive loop to remove comments.

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));

/* this throwing null pointer error when run in Lucee context 
(if there are any comments to remove...should be a big pointer to where the error lies but I still can't fund it)
nodeVisitor = createObject("java", "org.coldsoup.RemoveCommentsVisitor");
doc.traverse(nodeVisitor);
*/

coldSoup.removeComments(doc);

displayCode(coldsoup.getHTML(doc));

</cfscript>