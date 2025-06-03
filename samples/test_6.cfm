<cfscript>
// @title Clean dodgy html
// @description  Default safeList is basic. Relaxed will allow h2 tags.
writeOutput("<pre>#htmlEditFormat(request.prc.dodgyHTML)#</pre>");

writeOutput("<h3>Basic safelist</h3>");
okText = coldSoup.clean(request.prc.dodgyHTML);
displayCode(okText);

writeOutput("<h3>relaxed safelist</h3>");
okHTML = coldSoup.clean(html=request.prc.dodgyHTML,safelist="relaxed");
displayCode(okHTML);

</cfscript>