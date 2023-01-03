component {
	
	public void function onRequestStart(targetPage) {

		request.prc = {};
		request.rc = Duplicate(url);
		request.prc.coldsoup = new coldsoup.coldSoup();

		local.script = ListLast(arguments.targetPage,"/");
		
		// ensure we only preview via index page
		if (local.script neq "index.cfm") {
			
			if (Left(local.script ,4) eq "test") {

				local.testID = ListLast(ListFirst(arguments.targetPage,"."),"_");

				if (isValid("integer",local.testID )) {
					cflocation( url="index.cfm?test=" & local.testID, addtoken="false" );
				}
				
			}

			cflocation( url="index.cfm", addtoken="false" );
			
		}
		

	}

	function displayCode(html) {
		WriteOutput("<pre>" & HtmlEditFormat(arguments.html) & "<pre>");
	}


}