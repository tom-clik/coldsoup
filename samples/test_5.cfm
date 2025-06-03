<cfscript>
// @title Simple check of html validitity
// @description  call isValidHTML with default safelist.
// 
safelist = createObject("java", "org.jsoup.safety.Safelist" );

ok = coldSoup.isValidHTML(request.prc.dodgyHTML);

writeOutput("<pre>#htmlEditFormat(request.prc.dodgyHTML)#</pre>");
WriteOutput("Dodgy html is ok? " & yesNoFormat(ok));

</cfscript>