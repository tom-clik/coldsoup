component {
	this.mappings = {
		"/coldsoup" = ExpandPath(".."),
		"/docbox" = ExpandPath("../../../docbox"),
		"/testbox" = ExpandPath("../../../testbox"),
		"/docs" = ExpandPath("../docs")
	};
	this.debug = 1;

	public void function onError(e) {
		
		var niceError = ["message"=e.message,"detail"=e.detail,"code"=e.errorcode,"ExtendedInfo"=deserializeJSON(e.ExtendedInfo)];
		
		// supply original tag context in extended info
		if (IsDefined("niceError.ExtendedInfo.tagcontext")) {
			niceError["tagcontext"] =  niceError.ExtendedInfo.tagcontext;
			StructDelete(niceError.ExtendedInfo,"tagcontext");
		}
		else {
			niceError["tagcontext"] =  e.TagContext;
		}
		
	

		// set to true in any API to always get JSON errors even when testing
		param name="request.prc.isAjaxRequest" default="false" type="boolean";

		if (e.type == "ajaxError" OR request.prc.isAjaxRequest) {
			
			local.errorCode = createUUID();
			local.filename = this.errorFolder & "/" & local.errorCode & ".html";
			
			FileWrite(local.filename,local.errorDump,"utf-8");
			
			local.error = {
				"status": 500,
				"filename": local.filename,
				"message" : e.message,
				"code": local.errorCode
			}
			
			WriteOutput(serializeJSON(local.error));
		}
		else {
			if (this.debug) {
				writeDump(niceError);
			}
			else {
				handleError(niceError);
				
				local.pageWritten = false;
				if (IsDefined("application.pageObj")) {

					request.content.body = "<h1>Error</h1>";
					request.content.body &= arguments.e.message;
					try {
						writeOutput(application.pageObj.buildPage(request.content));
						local.pageWritten = true;
					}
					catch (any e) {

					}
				}
				if (NOT local.pageWritten) {
					writeOutput("Sorry, an error has occurred");
				}

			}
			
		}
		
	}
}