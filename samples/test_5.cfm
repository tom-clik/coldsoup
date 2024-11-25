<cfscript>
// @title Simple check of html validitity
// @description  
// 
safelist = createObject("java", "org.jsoup.safety.Safelist" );


basic = safelist.basic();


	// 	.init()
	// 	.addTags([ "strong", "em" ])
	// 	.addTags([ "p", "ul", "ol", "li" ])
	// ;

writeDump(basic);

cleaner = createObject("java", "org.jsoup.safety.Cleaner" ).init(basic);

writeDump(cleaner);

Jsoup = createObject("java", "org.jsoup.Jsoup" );

request.prc.dodgyHTML = createObject("java","StringBuilder").init("Hello").toString();
writeDump(request.prc.dodgyHTML);


ok = Jsoup.isValid( request.prc.dodgyHTML, safelist )
	;

// ok = coldSoup.isValidHTML(request.prc.dodgyHTML);
writeOutput("<pre>#htmlEditFormat(request.prc.dodgyHTML)#</pre>");

WriteOutput("Dodgy html is ok? " & yesNoFormat(ok));

</cfscript>