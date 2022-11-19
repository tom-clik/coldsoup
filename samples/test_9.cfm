<cfscript>
// @title Loop over tags
// @description Using a Jquery like selector, we can create an Array of nodes and loop over them

doc = coldSoup.parse(FileRead(ExpandPath("../testing/rubbish.html")));
paras = doc.select("p");
writeOutput("<p>" & paras.len() & " p tags found");
for (para in paras) {
	writeDump(coldSoup.tagInfo(para));
}
</cfscript>