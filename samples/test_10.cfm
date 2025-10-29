<cfscript>
// @title Remove comments
// @description Use an inefficient recursive loop and a faster text match to remove comments.

html = FileRead(ExpandPath("../testing/rubbish.html"));
for (i =1; i lt 8; i++) {
	html &= html;
}

doc = coldSoup.parse(html);

cftimer(type="inline" label="Nodes") {
	coldsoup.removeComments(doc);
}

// displayCode(coldsoup.getHTML(doc));

writeOutput("<h3>Text version</h3>
	<p>This uses a text replacement on the finished html,  more efficient for complex html docs</p>");

cftimer(type="inline" label="text") {
	quick = coldSoup.removeHTMLComments(html);
}

// displayCode( quick );

</cfscript>