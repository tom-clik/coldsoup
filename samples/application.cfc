component {


	// ensure we only preview via index page
	public void function onRequestStart(targetPage) {

		request.prc = {};
		request.rc = Duplicate(url);
		request.prc.coldsoup = new coldsoup.coldSoup();

		local.script = ListLast(arguments.targetPage,"/");
		if (local.script neq "index.cfm") {
			if (Left(local.script ,4) eq "test") {
				local.testID = ListLast(ListFirst(arguments.targetPage,"."),"_");
				if (isValid("integer",local.testID )) {
					cflocation( url="index.cfm?test=" & local.testID, addtoken="false" );
				}
				else {
					cflocation( url="index.cfm", addtoken="false" );
				}
			}
			else {
				writeDump(local.script);
				abort;
			}
		}
		

	}

	function displayCode(html) {
		WriteOutput("<pre>" & HtmlEditFormat(arguments.html) & "<pre>");
	}


}