<cfscript>
// @title Simple check of html validitity
// @description  
ok = coldSoup.isValidHTML(request.prc.dodgyHTML);
writeOutput("<pre>#htmlEditFormat(request.prc.dodgyHTML)#</pre>");

WriteOutput("Dodgy html is ok? " & yesNoFormat(ok));

</cfscript>