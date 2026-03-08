component {
	
	public void function onRequestStart(targetPage) {

		local.settingsPath = expandPath("settings.json");
		if ( ! fileExists(local.settingsPath) ) {
			throw("To use the samples you must create settings.json in the samples folder with the path to your Flexmark jar");
		}

		request.prc = {};
		request.rc = Duplicate(url);
		structAppend(request.rc, form);
		
		try {
			request.prc.jar = deserializeJSON( fileRead( local.settingsPath ) ).jar;
			if (! fileExists(request.prc.jar)) {
				throw("Jar file #request.prc.jar# not found");
			}
		}
		catch (any e) {
			throw("Unable to read settings file: #e.message#");
		}

		

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

}